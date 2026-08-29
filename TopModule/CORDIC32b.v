// ===========================================================================
// Coordinate Rotation Digital Computer (CORDIC) Hardware Accelerator
// ===========================================================================
// Rotation Mode (32-Bit Precision)
// Author : Nigil M R
`timescale 1ns/1ps

module CORDIC32b (
    input wire CLK,
    input wire RST,
    input wire signed [31:00] radIn,
    output reg DONE,
    output reg signed [31:00] sinOut,
    output reg signed [31:00] cosOut
);

reg signed [05:00] pipStg;
reg signed [31:00] radians;
reg signed [31:00] reg_x [00:32];
reg signed [31:00] reg_y [00:32];
reg signed [31:00] reg_z [00:32];
reg signed [31:00] arcTan[00:32];

always @(*)
begin
    reg_x[00] = 32'sh136E9DB5;
    reg_y[00] = 32'sh00000000; 
    radians   = radIn;
    // Checks
    // Between 90° and 180° 
    // Between −180° and −90°
    reg_z[00] = (radians >= 32'sh3243F6A9 && radians <= 32'sh6487ED51) ? 32'sh6487ED51 - radians :
                (radians <= 32'shCDBC0957 && radians >= 32'sh9B7812AF) ? radians + 32'sh6487ED51 :
                radians;
    // Arch Tangent
    arcTan[00] = 32'sh1921FB54;
    arcTan[01] = 32'sh0ED63383;
    arcTan[02] = 32'sh07D6DD7E;
    arcTan[03] = 32'sh03FAB753;
    arcTan[04] = 32'sh01FF55BB;
    arcTan[05] = 32'sh00FFEAAE;
    arcTan[06] = 32'sh007FFD55;
    arcTan[07] = 32'sh003FFFAA;
    arcTan[08] = 32'sh001FFFF5;
    arcTan[09] = 32'sh000FFFFF;
    arcTan[10] = 32'sh00080000;
    arcTan[11] = 32'sh00040000;
    arcTan[12] = 32'sh00020000;
    arcTan[13] = 32'sh00010000;
    arcTan[14] = 32'sh00008000;
    arcTan[15] = 32'sh00004000;
    arcTan[16] = 32'sh00002000;
    arcTan[17] = 32'sh00001000;
    arcTan[18] = 32'sh00000800;
    arcTan[19] = 32'sh00000400;
    arcTan[20] = 32'sh00000200;
    arcTan[21] = 32'sh00000100;
    arcTan[22] = 32'sh00000080;
    arcTan[23] = 32'sh00000040;
    arcTan[24] = 32'sh00000020;
    arcTan[25] = 32'sh00000010;
    arcTan[26] = 32'sh00000008;
    arcTan[27] = 32'sh00000004;
    arcTan[28] = 32'sh00000002;
    arcTan[29] = 32'sh00000001;
    arcTan[30] = 32'sh00000000;
    arcTan[31] = 32'sh00000000;
end

always @(posedge CLK)
begin
    if(RST)
    begin
        pipStg <= 6'h0;
        DONE   <= 1'h0;
    end
    else
    begin
        if (pipStg == 6'h20)
        begin
            cosOut <= (radians >= 32'sh3243F6A9 && radians <= 32'sh6487ED51) ? 32'h0 - reg_x[32] :
                      (radians <= 32'shCDBC0957 && radians >= 32'sh9B7812AF) ? 32'h0 - reg_x[32] :
                       reg_x[32];
            sinOut <= (radians >= 32'sh3243F6A9 && radians <= 32'sh6487ED51) ? reg_y[32]         :
                      (radians <= 32'shCDBC0957 && radians >= 32'sh9B7812AF) ? 32'h0 - reg_y[32] :
                      reg_y[32];
            DONE   <= 1'h1;             
        end
        // Cannot be driven inside "Generate", leads to "Multi-Driver Conflict"!
        pipStg <= pipStg + 6'h1;
    end
end

genvar count_i;
// 1-Cycle
// Generate 
generate
    for(count_i = 0; count_i < 32; count_i = count_i + 1) 
    begin : CORDICStages
        always @(posedge CLK) 
        if(RST)
        begin
            reg_x[count_i + 1] <= 32'sh0;
            reg_y[count_i + 1] <= 32'sh0;
            reg_z[count_i + 1] <= 32'sh0;
        end
        else 
        begin
            if(!reg_z[count_i][31])
            begin
                reg_x[count_i + 1] <= reg_x[count_i] - (reg_y[count_i] >>> count_i);
                reg_y[count_i + 1] <= reg_y[count_i] + (reg_x[count_i] >>> count_i);
                reg_z[count_i + 1] <= reg_z[count_i] - arcTan[count_i];
            end
            else 
            begin
                reg_x[count_i + 1] <= reg_x[count_i] + (reg_y[count_i] >>> count_i);
                reg_y[count_i + 1] <= reg_y[count_i] - (reg_x[count_i] >>> count_i);
                reg_z[count_i + 1] <= reg_z[count_i] + arcTan[count_i];
            end
        end
    end 
endgenerate
endmodule

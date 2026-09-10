// ===============================================================
// TEST-BENCH FOR CORDIC ACCELERATOR (CORDIC32b.v)
// ===============================================================
// Rotation Mode (32-Bit Precision)
// Author : Nigil M R
`timescale 1ns/1ps

module CORDIC32b_tb;
    localparam NUM_VEC = 400;

    // Inputs
    reg CLK;
    reg RST;
    reg signed [31:00] radIn;
    // Outputs
    wire DONE;
    wire signed [31:00] sinOut;
    wire signed [31:00] cosOut;

    // Intergers
    integer passCount;
    integer failCount;
    integer count_i;

    // Time
    time startTime;
    time endTime;

    // Tolerance
    localparam signed [31:00] TOL = 32'sd16;

    reg signed [31:00] testInAngle  [00:NUM_VEC-1];
    reg        [63:00] testOutVals  [00:NUM_VEC-1];   

    // Module Instantiation (Design Under Test)
    CORDIC32b DUT (.CLK(CLK), .RST(RST), .radIn(radIn), .DONE(DONE), .sinOut(sinOut), .cosOut(cosOut));

    // Clock Generation
    always #5 CLK = ~CLK;

    // Test-Bench
    task runVector;
        input integer testNum;
        // Cosine, Sine
        input [63:00] expOuts;
        input signed [31:00] testAngle;
        reg signed [31:00] expCos;
        reg signed [31:00] expSin;
        reg signed [63:00] dCos;
        reg signed [63:00] dSin;
        reg ok;

        begin
            expCos = expOuts[63:32];
            expSin = expOuts[31:00];

            radIn = testAngle;
            RST = 1;
            @(posedge CLK);
            @(posedge CLK);
            RST = 0;
            startTime = $time;

            // Print Inputs
            $display("Test No. : %0d\nSTART : %0t\nANGLE : %h", testNum + 1, startTime, testAngle);

            wait (DONE == 1'b1);
            @(posedge CLK);
            endTime = $time;

            dCos = cosOut - expCos; if (dCos < 0) dCos = -dCos;
            dSin = sinOut - expSin; if (dSin < 0) dSin = -dSin;
            ok = (dCos <= TOL) && (dSin <= TOL);

            if (ok)
            // Success Check
            begin
                passCount = passCount + 1;
                $display("E : %h  E : %h\nH : %h  H : %h\nEND : %0t\n",
                          expCos, expSin, cosOut, sinOut, endTime);
            end
            // Failure Check
            else
            begin
                failCount = failCount + 1;
                $display("FAIL Test No. %0d: cos=%h (exp %h, d=%0d)  sin=%h (exp %h, d=%0d)",
                          testNum + 1, cosOut, expCos, dCos, sinOut, expSin, dSin);
            end
            repeat (2) @(posedge CLK);
        end
    endtask

    initial begin
        passCount = 0;
        failCount = 0;
        CLK       = 0;
        RST       = 1;
        radIn     = 0;

        $readmemh("/home/nigil/Verilog/testvecs/CORDIC_inputs.txt",  testInAngle);
        $readmemh("/home/nigil/Verilog/testvecs/CORDIC_outputs.txt", testOutVals);

        repeat (3) @(posedge CLK);
        RST = 0;
        repeat (2) @(posedge CLK);

        // Read from File 
        for (count_i = 0; count_i < NUM_VEC; count_i = count_i + 1)
        begin
            runVector(count_i, testOutVals[count_i], testInAngle[count_i]);
        end
        $display("TOTAL PASS: %0d/%0d", passCount, NUM_VEC);
        #20 $finish;
    end

    // Avoid Simulation Running Indefinitely
    initial begin
        #6000000;
        $display("TimeOut");
        $finish;
    end
endmodule

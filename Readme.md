# 𝗥𝗢𝗧𝗔𝗧𝗜𝗢𝗡 𝗠𝗢𝗗𝗘 𝟯𝟮𝗯 𝗖𝗢𝗥𝗗𝗜𝗖 𝗛𝗔𝗥𝗗𝗪𝗔𝗥𝗘 𝗔𝗖𝗖𝗘𝗟𝗘𝗥𝗔𝗧𝗢𝗥
This repository contains an implementation of a 32-bit CORDIC accelerator operating in Rotation Mode, capable of generating sine and cosine values for angles from 0° to 360°.

**Caution**: When using `GENERATE` blocks in Verilog, ensure that multiple generated instances do not unintentionally drive the same variable or net. Since the generated hardware operates concurrently, assigning the same signal from multiple `ALWAYS` blocks can result in multiple-driver conflicts or unintended behavior.

For example, the following approach can cause a conflict because every generated block attempts to drive the same signal: 

```Verilog
genvar count_i;
generate
  for(count_i = 0; count_i < ITERATIONS; count_i = count_i + 1)
  begin
    always @(*)
    being
      outSignal = i;
    end
  end
endgenerate
```

Instead, each generated instance should drive a separate signal or array element:

```Verilog
genvar count_i;
generate
  for(count_i = 0; count_i < ITERATIONS; count_i = count_i + 1)
  begin
    always @(*)
    being
      outSignal[count_i] = i;
    end
  end
endgenerate
```

Using separate signals for each generated instance helps prevent multiple-driver conflicts.

|<img width="1919" height="1079" alt="CORDIC_VerilatorTest" src="https://github.com/user-attachments/assets/75d5176d-4e42-494c-b5b2-95bfa7456273" />|
|:-----:|
| _Figure 1. Successful Execution of Coordinate Rotation Digital Computer (CORDIC) Algorithm Using Verilator_ |

## Reference
[YouTube - NPTEL - Derivation of Coordinate Rotation Digital Computer Algorithm](https://tinyurl.com/YT-NPTEL-CORDICAlgo)

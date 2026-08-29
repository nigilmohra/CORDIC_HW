# 𝗥𝗢𝗧𝗔𝗧𝗜𝗢𝗡 𝗠𝗢𝗗𝗘 𝟯𝟮𝗯 𝗖𝗢𝗥𝗗𝗜𝗖 𝗛𝗔𝗥𝗗𝗪𝗔𝗥𝗘 𝗔𝗖𝗖𝗘𝗟𝗘𝗥𝗔𝗧𝗢𝗥
This repository contains an implementation of a 32-bit CORDIC accelerator operating in Rotation Mode, capable of generating sine and cosine values for angles from 0° to 360°.

Through this project, I learned how the generate statement in Verilog works, including the constructs that can be used within a generate block. I also learned how multiple always blocks can operate concurrently. **One important lesson was that multiple generated blocks should not drive the same variable or net unintentionally, as this can create multiple-driver conflicts**. Using separate signals or separate array elements for each generated instance helps avoid such issues.

|<img width="1919" height="1079" alt="CORDIC_VerilatorTest" src="https://github.com/user-attachments/assets/75d5176d-4e42-494c-b5b2-95bfa7456273" />|
|:-----:|
| _Figure 1. Successful Execution of Coordinate Rotation Digital Computer (CORDIC) Algorithm Using Verilator_ |

## Reference
[YouTube - NPTEL - Derivation of Coordinate Rotation Digital Computer Algorithm](https://tinyurl.com/YT-NPTEL-CORDICAlgo)

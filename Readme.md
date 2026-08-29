# 𝗖𝗢𝗢𝗥𝗗𝗜𝗡𝗔𝗧𝗘 𝗥𝗢𝗧𝗔𝗧𝗜𝗢𝗡 𝗗𝗜𝗚𝗜𝗧𝗔𝗟 𝗖𝗢𝗠𝗣𝗨𝗧𝗘𝗥
This repository contains an implementation of a 32-bit CORDIC accelerator operating in Rotation Mode, capable of generating sine and cosine values for angles from 0° to 360° using quadrant folding.

Through this project, I learned how the generate statement in Verilog works, including the constructs that can be used within a generate block. I also learned how multiple always blocks can operate concurrently. **One important lesson was that multiple generated blocks should not drive the same variable or net unintentionally, as this can create multiple-driver conflicts**. Using separate signals or separate array elements for each generated instance helps avoid such issues.

## Reference
[YouTube - NPTEL - Derivation of Coordinate Rotation Digital Computer Algorithm](https://tinyurl.com/YT-NPTEL-CORDICAlgo)

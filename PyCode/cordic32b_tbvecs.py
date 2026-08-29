# GENERATING TEST VECTORS FOR 'CORDIC (32-BIT PRECISION)'

# LIBRARIES ...
import math, random

# CONSTANTS
SCALE = 2 ** 29  

# FUNCTION
def genCORDIC_testVector(vectorSize):
    quadrantRanges = [(0, 90), (90, 180), (-180, -90), (-90, 0)]
    totalVectors = vectorSize * len(quadrantRanges)

    targetIn  = open('CORDIC_inputs.txt', 'w')
    targetOut = open('CORDIC_outputs.txt', 'w')

    count_i = 0
    for angleLo, angleHi in quadrantRanges:
        for count_j in range(vectorSize):
            # ANGLES
            angleDeg = random.uniform(angleLo, angleHi)
            angleRad = math.radians(angleDeg)

            # COSINE / SINE
            cosData = math.cos(angleRad)
            sinData = math.sin(angleRad)

            # FORMATTING & WRITE 
            targetIn.write(format(int(round(angleRad * SCALE)) & 0xFFFFFFFF, '08x'))
            targetOut.write(format(int(round(cosData * SCALE)) & 0xFFFFFFFF, '08x') +
                             format(int(round(sinData * SCALE)) & 0xFFFFFFFF, '08x'))

            # NEWLINE
            targetIn.write('\n')
            targetOut.write('\n')

            # PROGRESS
            print(f'Generating CORDIC Test Vectors {count_i + 1}/{totalVectors}')

            count_i += 1

    # CLOSE
    targetIn.close()
    targetOut.close()

# CALL
genCORDIC_testVector(100)
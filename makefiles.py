import os

for num in range(1, 121):
    num = str(num)
    if len(num) == 1:
        os.mkdir("Sonorine_00" + num)
    elif len(num) == 2:
        os.mkdir("Sonorine_0" + num)
    elif len(num) == 3:
        os.mkdir("Sonorine_" + num)

import math
def log(position):

    minp = 0
    maxp = 127

    minv = math.log(1)
    maxv = math.log(60)

    scale = (maxv-minv) / (maxp - minp)
    return math.exp(minv + scale*(position - minp))

for each in range(0, 127):
    print(log(each))


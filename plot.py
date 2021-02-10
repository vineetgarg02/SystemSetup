import matplotlib.pyplot as plt
import numpy as np

file1 = "/Users/vgarg/workspace/projects/compilation_latency/smg_profiling/HDP_profiling/pre_run_1.numbers.csv"
file2 = "/Users/vgarg/workspace/projects/compilation_latency/smg_profiling/HDP_profiling/pre_run_2.numbers.csv"

run1 = []
run2 = []

seq=[]
cnt=int(0)

j = 0
with open(file1) as fp:
    line = fp.readline()
    j = j+1
    while line:
        run1.append(float(line.rstrip('\n')))
        cnt=int(cnt)+1
        seq.append(cnt)
        line = fp.readline()
        j = j+1

i=0
with open(file2) as fp:
    line = fp.readline()
    i=i+1
    while line:
        run2.append(float(line.rstrip('\n')))
        line = fp.readline()
        i = i+1

xa=[1,2,3,4,5,6,7,8,9]
ya=[0.10,0.05,0.03,1.12,0.021,4.90,3.0,0.045,1.2]

yb=[0.11,0.08,0.09,1.10,0.028,4.99,3.9,0.040,0.2]

plt.scatter(seq,run1, s=1)
plt.scatter(seq,run2, s=1)

plt.show()

import numpy as np
import matplotlib
matplotlib.use("TkAgg")
from matplotlib import pyplot as plt

n, f30, f25, f20, f15, f10, f5, f1 = [], [], [], [], [], [], [],[]


def get_cols(filename):
    """
    """
    n, f30,f25 = [], [], []
    with open(filename, "r") as f:
        for line in f:
            values = [float(s) for s in line.split()]
            n.append(values[0])
            f30.append(values[1])
            f25.append(values[2])
            f20.append(values[3])
            f15.append(values[4])
            f10.append(values[5])
            f5.append(values[6])
            f1.append(values[7])
    return n, f30, f25, f20, f15, f10, f5, f1


def plot_time(n, f30, f25, f20, f15, f10, f5, f1, plt1, output):
    plt1.figure(1, clear=True)
    plt1.subplot()
    plt1.plot(n,f30,label="30 steams")
    plt1.plot(n,f25,label="25 streams")
    plt1.plot(n, f20, label="20 steams")
    plt1.plot(n, f15, label="15 steams")
   # plt1.plot(n, f20, label="10 steams")
    plt1.plot(n, f10, label="10 steams")
    plt1.plot(n,f5 ,label="5 streams")
    plt1.plot(n, f1,label=" 1 stream")
    plt1.suptitle("Time")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('Gflops/s')
    plt.tight_layout()
    plt1.savefig(output)


n, f30, f25, f20, f15, f10, f5, f1 = get_cols('../data/Gflops.dat')


plot_time(n, f30, f25, f20, f15, f10, f5, f1, plt, '../img/perfomance.png')



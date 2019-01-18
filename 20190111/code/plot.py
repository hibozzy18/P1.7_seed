import numpy as np
import matplotlib
matplotlib.use("TkAgg")
from matplotlib import pyplot as plt

n, t, flot, t1, flot1 = [], [], [], [], []


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
    return n, flot, f25


def plot_time(n, t, t25,plt1, output):
    plt1.figure(1, clear=True)
    plt1.subplot()
    plt1.plot(n,t)
    plt1.plot(n, t25)
    plt1.suptitle("Time")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('time(s)')
    plt.tight_layout()
    plt1.savefig(output)



nnew, flot1, flot = get_cols('../data/time2.dat')


plot_time(nnew, flot1, flot, plt, '../img/time.png')



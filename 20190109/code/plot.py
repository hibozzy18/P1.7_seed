import matplotlib
matplotlib.use("TkAgg")
from matplotlib import pyplot as plt
from matplotlib import pyplot as plt2
import numpy as np

n, t, f = [], [], []


def get_cols(filename):
    """
    """
    n, t, flot = [], [], []
    with open(filename, "r") as f:
        for line in f:
            values = [float(s) for s in line.split()]
            n.append(values[0])
            t.append(values[1])
            flot.append(values[2])
    return n, t, flot

def plot_time(n,  t, plt1, output):
    plt1.figure(1, clear=True)
    plt1.subplot(111)
   # plt1.plot(n, t, '-b', label='Time/us')
    err = 0.1 + 0.2*np.sqrt(t)
    plt1.errorbar(n, t, yerr=err,label='Time/us')
    plt1.suptitle("Time")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('time(us)')
    plt.tight_layout()
    plt1.savefig(output)

n, t, f = get_cols('../data/time.dat')
plot_time(n, t, plt, '../img/time.png')
    
def plot_pperfomance(n,  t, plt1, output):
    plt1.figure(2, clear=True)
    plt1.subplot(111)
    plt1.plot(n, t, '-r', label='Performance')
    plt1.suptitle("Perfomance")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('Gflops/s')
    plt.tight_layout()
    plt1.savefig(output)
    

plot_pperfomance(n, f, plt2, '../img/perfomance.png')

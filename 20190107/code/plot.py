
import matplotlib
matplotlib.use("TkAgg")
from matplotlib import pyplot as plt

n, t, f= [], [], []


def get_cols(filename):
    """
    """
    n, t, flot = [], [], []
    with open(filename, "r") as f:
        for line in f:
            values = [float(s) for s in line.split()]
            n.append(values[0])
            t.append(values[2])
            flot.append(values[3])
    return n, t, flot

def plot_time(n,  t, plt1 , output):
    plt1.subplot(121)
    plt1.plot(n, t, '-b', label='Time/us')
    plt1.suptitle("Time")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('time(us)')
    plt.tight_layout()
    plt1.savefig(output)


def plot_pperfomance(n,  t, plt1, output):
    plt1.subplot(122)
    plt1.plot(n, t, '-r', label='Peak Performance')
    plt1.suptitle("Peak Perfomance")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('Gflops/s')
    plt.tight_layout()
    plt1.savefig(output)
  



n,t,f = get_cols('../data/time.dat')
plot_time(n, t, plt, '../img/time.png')
plot_pperfomance(n, f, plt, '../img/time.png')

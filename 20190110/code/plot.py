import matplotlib
matplotlib.use("TkAgg")
from matplotlib import pyplot as plt

n, t, flot, t1, flot1 = [], [], [], [], []

def get_cols(filename):
    """
    """
    n, t, flot,t1, flot1 = [], [], [], [], []
    with open(filename, "r") as f:
        for line in f:
            values = [float(s) for s in line.split()]
            n.append(values[0])
            t.append(values[1])
            flot.append(values[2])
            t1.append(values[3])
            flot1.append(values[4])
    return n, t, flot, t1,flot1


def plot_time(n, t,n1,t1,plt1, output):
    plt1.figure(1, clear=True)
    plt1.subplot()
    plt1.plot(n, t, '-r', label='computation + communication')
    plt1.plot(n, t1, '-b', label='computation ')
    plt1.suptitle("Time")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('time(s)')
    plt.tight_layout()
    plt1.savefig(output)


def plot_pperfomance(n,f, plt1,f1,n1, output):
    plt1.figure(2, clear=True)
    plt1.subplot()
    plt1.plot(n, f, '-r', label=' computation + communication')
    plt1.plot(n, f1, '-b', label='computation')
    plt1.suptitle("Perfomance (Flops)")
    plt1.legend()
    plt1.xlabel('N')
    plt1.ylabel('Gflops/s')
    plt.tight_layout()
    plt1.savefig(output)


n, t, f, t1,flot1 = get_cols('../data/time.dat')
plot_time(n, t,n,t1, plt, '../img/time.png')
plot_pperfomance(n, f,plt,flot1,n, '../img/perfomance.png')

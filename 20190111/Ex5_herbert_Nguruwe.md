#Herbert Nguruwe 
## Cudablass DGEMM

I implemented  cudablass dgemm with multple streams.  I used the cuda malloc asynchonus to copy data over from the host to the device. I excuted the program  changing the number of streams for one value of N.Th raw results are [here] (data/Gflops.dat). The table shows the value of GFlops obtained by streams, the table consists of: N(1st column),then corresponding  streams the first one will be 30, 25,20,15,10,5 and 1.  It can be noted that there is an increase in  perfomance with increase of both N  and streams.

![Perfomance analysis](img/Perfomance.png "time")

As expected an increase in the number N will produce a greater value of GFlops/s as there will be more computational gain.The more the. The perfomancnce of the graph is found on this graph. The difference is not really visiable beacuse of the scale. this can be seen in the file [raw data](data/raw.dat). The 1st raw is N the second, streams, time,Gflops/s

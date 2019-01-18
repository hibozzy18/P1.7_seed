#Herbert Nguruwe 
## Cudablass DGEMM

I implemented  cudablass dgemm with multple streams.  I used the cuda malloc asynchonus to copy data over from the host to the device. I excuted the program  changing the number of streams for one value of N.Below is the graph of the results.



As expected an increse in the number N will  produce a greater value of GFlops/sec.
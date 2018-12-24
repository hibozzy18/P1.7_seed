# P1.7 - Advanced numerical techniques and libraries for linear algebra computations #

## Lecturer: Piotr Luszczek ##

### Abstract ###

One of the main objectives of this course is to introduce design,
implementation, and optimization of High Performance Computing libraries
for numerical linear algebra. The broader hardware landscape will be
presented to give an appropriate context for the programmer of these
libraries. In particular, large supercomputing installations and
scientific clusters will be discussed with the emphasis on their
architectural features that are essential for good performance and
scalability. The programming portion of the course will cover open
community standards including OpenMP, OpenACC, and OpenCL as well as
CUDA programming syntax for the modern GPUs. These language extensions
will be used to implement components of numerical libraries for linear
algebra. The specific computing scenarios that will be covered during
the course will include dense, sparse, and batch variants of the BLAS
and LAPACK routines. Additionally, the distributed memory implementation
will be introduced for multicore clusters with multiple GPU accelerators
per node. This will require the use of some of the more advanced
features of MPI but they will be described with sufficient detail during
the lectures to underscore their implementation in modern MPI libraries.
Finally, the benchmarking aspect of numerical libraries will be
presented and analyzed based on a number of HPC benchmarks: HPL, HPCC,
and HPCG.  Although majority of the presented code will be explained,
familiarity with programming is welcome and will be helpful in following
along.

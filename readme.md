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
community standards including OpenMP and CUDA programming syntax for
the modern GPUs. These language extensions
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

### Daily Lecture Schedule ###

Slides available at http://www.icl.utk.edu/~luszczek/teaching/courses/2019/mhpc/

#### Monday, January 7, 2019 ####

* Morning module 1: HPC Hardware for Numerical Linear Algebra Software
* Morning module 2: OpenMP Programming
* Afternoon module: OpenMP programming exercises

#### Tuesday, January 8, 2019 ####

* Morning module 1: GPUs and CUDA Basics
* Morning module 2: Advanced CUDA Programming
* Afternoon module: CUDA programming exercises

#### Wednesday, January 9, 2019 ####

* Morning module 1: OpenMP Task Programming
* Morning module 2: Numerical Linear Algebra Libraries for Multicore and Many-core Systems with PLASMA
* Afternoon module: PLASMA library installation and basic use

#### Thursday, January 10, 2019 ####

* Morning module 1: Dense Numerical Linear Algebra Routines for Hardware Accelerators with MAGMA
* Morning module 2: Sparse and Batched Numerical Linear Algebra Routines for Hardware Accelerators with MAGMA
* Afternoon module: MAGMA library installation and basic use

#### Friday, January 11, 2019 ####

* Morning module 1: Numerical Linear Algebra Libraries for Distributed Memory GPU Systems with SLATE
* Afternoon module: Distributed Memory Programming

### Hands-on Exercises ###

The lectures will be followed by hands-on exercises that will be graded. Each
student is expected to work independently in class. The work will be turned in
forks of this repository. Grading will be based on source code correctness,
performance evaluation, and analysis of the runs. These issues will be
further explained during the lectures and the questions will be answered in
class during the hands-on sessions.

Your code needs to adhere to basic organization to facilitate grading. The code
from each day should be in its own directory (20190107, 20190108, and so on).
In each directory, there should be a Makefile that compiles your code. The
Makefile should allow to change the compiler and compilation flags:
``make CC=cc CFLAGS=-fopenmp``.  The data from your runs should be in ``data``
directory.  Please use SI prefixes (M, G, T) for your results, data, and
graphs. Avoid using large number of zeros and consider using a logarithmic
scale as appropriate. Your reports should use a simple text format with
references to figures in the ``data`` directory as necessary.

#### Monday, January 7, 2019 ####

Implement square matrix multiplication code (you can port it from CUDA if you
have it) using OpenMP directives. You don't have to get the best time but you
have to use multiple OpenMP threads.  Report the time for running your OpenMP
implementation on all cores of a single node of the cluster.  Use matrices of
sizes from 500 to 3000 with step of 500 (N=500,1000,1500,2000,2500,3000). Also
report the associated performance rate as 2\*N\*N\*N/time where N is the size
of all 3 square matrices A, B, and C.

#### Tuesday, January 8, 2019 ####

Your code should create three arrays: multiply two of them together with
"mulArray" and add the result to the third array with "addArray":
``D[i]=A[i]\*B[i] + C[i]``. All the calculations should be made on the GPU. The
inputs should be copied from the CPU. The result D should be copied back to the
CPU. The intermediate result E[i]=A[i]\*B[i] should also be copied to the CPU.
You will need to use at least two streams and all your data transfers have to
be asynchronous. You are *not* allowed to use the default stream to submit your
kernels or memory transfers.  The answer must be checked for correctness on the
CPU. Make sure you test your code for different thread counts and array sizes.
You may use the same stream and event structure as presented during the
lecture.


#### Wednesday, January 9, 2019 ####

Measure performance of matrix multiplication from PLASMA for square matrices
and report it in Gflop/s for a range of matrix sizes between 500 and 3000.

#### Thursday, January 10, 2019 ####

Measure performance of `magma_dgemm()` for square matrices and report it in
Tflop/s for a large (but no more than 5000) and a small (not less than 500)
matrix size. The call that you make in your code will look like this:

    magma_dgemm(MagmaNoTrans, MagmaNoTrans, N, N, N, -1.0, A_dev, N, B_dev, N, 1.0, C_dev, N, (magma_queue_t)queue );

You should have measurements for two matrix sizes `N` (large and small).
Keep in mind that the pointers in the call are device pointers.

Doxygen documentation of MAGMA's interface [is available
online](http://icl.cs.utk.edu/projectsfiles/magma/doxygen/ "MAGMA Doxygen")
and `magma_dgemm()` description [is also
available](http://icl.cs.utk.edu/projectsfiles/magma/doxygen/group__magma__gemm.html#gaa1c5db46fc9884b01b6423366e47e469
"MAGMA GEMM routines").

To allocate memory on CPU and GPU, you call `magma_malloc...()` [memory magement routines](
http://icl.cs.utk.edu/projectsfiles/magma/doxygen/routines.html#util "MAGMA Utilities").

MAGMA queues are just like CUDA streams, the specific calls mimic CUDA but work
on all platforms. Further information on MAGMA queues is
[online](http://icl.cs.utk.edu/projectsfiles/magma/doxygen/group__magma__queue.html
"MAGMA Queues").

Don't forget to initialize at the beginning and finalize MAGMA library at the end with
[initialize/finalize
functions](http://icl.cs.utk.edu/projectsfiles/magma/doxygen/group__magma__init.html
"MAGMA initialization and finalization").

#### Friday, January 11, 2019 ####

Measure performance of cublasDgemm() for suqare matrices of size 100, 200, 300,
..., 2000 (when testing and debuggin your code, use smaller sizes to keep the
utilization of the cluster low.) Use cublasSetStream() to change the stream for
CUBLAS and try more than one stream for submitting your calls. Find the number
of streams for which you don't get improvement in performance for at least one
problem size. Note that it is possible that only one cublasDgemm() can run on
one stream but it is also possible that you could be able to have multiple
cublasDgemm() run on separate streams and utilize the GPU better. Your results
may vary from your peers depending on how you write your code so you don't have
to get the same answer as the rest of the group. You should be guided by the
performance results that you achieve.

Your performance number in Gflop/s is `2e-9 * N*N*N / time` when running
cublasDgemm() on a single stream. For two streams running cublasDgemm()
simultaneously, it is `2 * 2e-9 * N*N*N / time_for_two_calls` and so on.

Use `event_timer.cu` for measuring time of executing a kernel inside a stream
(second argument to cudaEvenRecord is the stream pointer and passing 0 means
the default NULL stream).

#### Due Dates and Grading ####

All assignments are due on Friday, January 18, 2019 at 20:00 Trieste time zone.
The grades will be assessed after that time. Any question or issues should be
reported before then.

#!/bin/bash

for N in $(seq 500 500 3000)
do
    export OMP_NUM_THREADS=20 && ./omp_refmatmul.exe ${N} >> ../data/time.dat
done

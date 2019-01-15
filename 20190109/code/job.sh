#!/bin/bash

#PBS -S /bin/bash
#PBS -N mt_1024
#PBS -l nodes=1:ppn=20,walltime=2:00:00
#PBS -q  wide

module load openmpi

cd $PBS_O_WORKDIR/

for N in $(seq 500 500 3000)
do
    export OMP_NUM_THREADS=20 && ./plasma_matmul.exe ${N} >> ../data/time.dat
done


#!/bin/bash

#PBS -S /bin/bash
#PBS -N mt_1024
#PBS -l nodes=1:ppn=20,walltime=2:00:00
#PBS -q  wide

module load openmpi

cd $PBS_O_WORKDIR/

PATH_EXE="./run.sh"

$PATH_EXE      
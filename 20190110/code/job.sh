#!/bin/bash 

for N in $(seq 500 500 5000)
do
    ./exe ${N} >> time.dat
done

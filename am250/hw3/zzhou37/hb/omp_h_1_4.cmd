#!/bin/csh

#SBATCH -p Instruction
#SBATCH -J hello_omp_hb
#SBATCH -e job%j.err
#SBATCH -o job%j.out
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -t 00:01:00

setenv OMP_NUM_THREADS 4
./hello_omp_hb

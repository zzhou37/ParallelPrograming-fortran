#!/bin/bash

#SBATCH -p Instruction
#SBATCH -J hello_mpi_hb
#SBATCH -e job%j.err
#SBATCH -o job%j.out
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -t 00:01:00

mpirun -np 4 hello_mpi_hb

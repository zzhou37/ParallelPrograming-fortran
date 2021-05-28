#!/bin/bash

#SBATCH -p Instruction
#SBATCH -J hello_mpi_hb
#SBATCH -e job%j.err
#SBATCH -o job%j.out
#SBATCH -N 2
#SBATCH -n 8
#SBATCH -t 00:01:00

mpirun -np 8 hello_mpi_hb

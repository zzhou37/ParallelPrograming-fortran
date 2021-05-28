#PBS -S /bin/tcsh        ::using tcsh shell
#PBS -q newest           ::adding job into the newest queue
#PBS -N hello_mpi_grape  ::job name is hello
##PBS -j oe              ::creat out and error file
#PBS -l nodes=2:ppn=4     ::use 2 nodes and 8 processor
#PBS -l walltime=00:01:00 ::five mins to run

cd $PBS_O_WORKDIR
mpirun -np 8 hello_mpi_grape 

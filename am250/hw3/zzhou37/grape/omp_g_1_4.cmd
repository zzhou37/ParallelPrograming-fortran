#PBS -S /bin/tcsh        ::using tcsh shell
#PBS -q newest           ::adding job into the newest queue
#PBS -N hello_omp_grape  ::job name is hello
##PBS -j oe              ::creat out and error file
#PBS -l nodes=1:ppn=4     ::use 1 nodes and 4 processor
#PBS -l walltime=00:01:00 ::five mins to run

cd $PBS_O_WORKDIR
setenv OMP_NUM_THREADS 4
./hello_omp_grape

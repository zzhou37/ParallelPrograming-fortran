#PBS -S /bin/tcsh        ::using tcsh shell
#PBS -q newest           ::adding job into the newest queue
#PBS -N hello_omp_grape  ::job name is hello
##PBS -j oe              ::creat out and error file
#PBS -l nodes=1:ppn=8     ::use 1 node and 8 processor
#PBS -l walltime=00:01:00 ::five mins to run

cd $PBS_O_WORKDIR
setenv OMP_NUM_THREADS 8
./hello_omp_grape

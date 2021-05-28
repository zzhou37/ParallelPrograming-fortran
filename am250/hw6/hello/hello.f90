PROGRAM hello

implicit none
integer NTHREADS, TID, OMP_GET_NUM_THREADS, OMP_GET_THREAD_NUM !declear integers

! declear an OMP program

!$OMP PARALLEL PRIVATE(NTHREADS, TID)

! get thread number just like MPI programing

TID = OMP_GET_THREAD_NUM()
print *, 'Hello World from thread = ', TID

! Only Master Thread do those
if(TID .eq. 0) then
   NTHREADS = OMP_GET_NUM_THREADS()
   print *, 'Number of threads = ', NTHREADS
endif

! All threads join master thread and disband

!$OMP END PARALLEL

END 

program sendRec
include 'mpif.h'

integer myid, ierr, numprocs
integer tag, source, destination, count
real, dimension(5) :: buffer
integer stat(MPI_STATUS_SIZE)

call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

!defind basic element before run the code
tag = 1234
source = 0
destination = 1
count = 5

if(myid .eq. source) then
   buffer = (/1.00, 2.00, 3.00, 4.00, 5.00/)
   call MPI_SEND(buffer, count, MPI_REAL,destination, tag, MPI_COMM_WORLD, ierr)
   print*, 'Processor: ', myid,' sent ',buffer
endif

if(myid .eq. destination) then
   call MPI_RECV(buffer, count, MPI_REAL, source, tag, MPI_COMM_WORLD, stat, ierr)
   print *,' Processor: ',myid,' received ',buffer
endif

call MPI_FINALIZE(ierr)

stop
end

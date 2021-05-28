program pingPong
include 'mpif.h'

integer myid, ierr, numprocs
integer tag, source, destination,count
integer buffer
integer stat(MPI_STATUS_SIZE)
integer i, turns

call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

tag = 1234
source = 0
destination = 1
count = 1

turns = 5

if(myid .eq. source) then
   buffer = 1 
   do i = 1, turns
      call MPI_SEND(buffer, count, MPI_INTEGER, destination, tag,&
            &MPI_COMM_WORLD, ierr) 
      print *,' Processor: ',myid,' sent ', buffer
      call MPI_RECV(buffer, count, MPI_INTEGER, destination, tag,&
            &MPI_COMM_WORLD, stat, ierr)
      print *,' Processor: ',myid,' received ', buffer
      buffer = buffer + 1
   end do
endif

if (myid .eq. destination) then
   do i = 1, turns
      call MPI_RECV(buffer, count, MPI_INTEGER, source, tag,&
            &MPI_COMM_WORLD, stat, ierr)
      print *,' Processor: ',myid,' received ', buffer
      buffer = buffer + 2
      call MPI_SEND(buffer, count, MPI_INTEGER, source, tag, &
            &MPI_COMM_WORLD, ierr)
      print *,' Processor: ',myid,' sent ', buffer
   end do
endif

call MPI_FINALIZE(ierr)

stop 
end


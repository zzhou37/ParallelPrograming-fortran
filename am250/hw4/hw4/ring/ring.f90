program ring
include 'mpif.h'

integer myid, ierr, numprocs, request
integer tag, count
integer buffer
integer stat(MPI_STATUS_SIZE)
integer i, n
integer, dimension(8) :: array = (/0,1,2,3,4,5,6,7/)

call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr) !get the ID
call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr) !get the range

tag = 1234
count = 1
n = 5
buffer = array(myid+1) 

!print *,myid,' : ', buffer
!do i=0, n-1
   call MPI_ISEND(buffer, count, MPI_INTEGER, modulo((myid+n),numprocs), tag, &
                 &MPI_COMM_WORLD,request, ierr)
   print *,' Processor: ',myid,' sent to ',modulo((myid+n),numprocs),' ',buffer
   call MPI_RECV(buffer, count, MPI_INTEGER, modulo((myid+(numprocs-modulo(n, numprocs))), numprocs), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
   call MPI_WAIT(request, stat, ierr)
   print *,' Processor: ',myid,' recived from ',modulo((myid+(numprocs-modulo(n, numprocs))), numprocs),' ',buffer
!end do

call MPI_FINALIZE(ierr)

stop
end



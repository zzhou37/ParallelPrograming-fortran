program gather
   include 'mpif.h'
   integer :: myid, numprocs, master
   integer :: buffer
   integer,dimension(:),allocatable :: recvBuffer
   integer :: i, sum = 0
   real :: answer = 0.0
   integer :: totalN, work = 100000
   
   call MPI_INIT(ierr)
   call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
   call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

   master = 0
      
   allocate(recvBuffer(numprocs))
  
   !assign the probility of each node to buffer 
   buffer = sumUpPoints(work, numprocs, myid)


   call MPI_Gather(buffer, 1, MPI_INTEGER,&
                &recvBuffer, 1, MPI_INTEGER, master,&
                &MPI_COMM_WORLD, ierr)

   !what the first process do
   if(myid .eq. master) then
      !calculate the average probility  
      !print *, 'recvBuffer = ', recvBuffer
      totalN = work/numprocs
      totalN = totalN * numprocs
      print *, totalN
      
      do i = 1, numprocs
         sum = sum + recvBuffer(i)
      enddo
      
      answer = real(sum)/real(totalN)*4
      print*, 'answer: ', answer
   endif

   call MPI_FINALIZE(ierr)
end

function sumUpPoints(work, numprocs, myid)
   integer :: work, numprocs, myid
   integer :: sumUpPoints
   integer :: n, i, sumup=0
   integer :: seed
   
   seed = time + myid*2
   n = work/numprocs

   call srand(seed)
   do i = 1, n 
      sumup = sumup + inCircle(rand(), rand())
   enddo
   !print*, n
   !print *, '----------------------------------------------'
   sumUpPints = sumup
end function sumUpPoints

function time()
   integer,dimension(8) :: values
   integer :: time
   call date_and_time(VALUES=values)
   time = values(8)
end function time

function inCircle(x, y)
   real :: x, y
   real :: dis
   integer :: inCircle

   x = x - 0.5
   y = y - 0.5

   dis = sqrt(x*x + y*y)
   
   if(dis > 0.5) then
      inCircle = 0
   else
      inCircle = 1
   endif
end function inCircle











    

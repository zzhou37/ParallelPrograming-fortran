program gameOfLife
include 'mpif.h'

!MPI untility
integer :: myid, ierr, numprocs, request
integer :: tag, source, destination, count
integer :: stat(MPI_STATUS_SIZE)
integer :: direction(8) 
!utility
integer :: seed = 4
integer :: n1, n2, sumNine
integer :: times = 8
parameter(n1 = 2*4)
parameter(n2 = 2*4)
integer :: i, j, k, t
integer :: bi, bj
integer :: SbufferL(6), SbufferR(6), RbufferL(6), RbufferR(6)
integer :: SbufferT(6), SbufferB(6), RbufferT(6), RbufferB(6)
integer :: LT, LB, RT, RB
!board
integer :: board(n1,n2) , subBoard(6,6), newSubBoard(6,6)
!performance
double precision t1, t2

!/////////////////generate a board///////////////
!call srand(seed)
!do i = 1, n1
!   do j = 1, n2
!      board(i, j) = int(rand()/0.5)
!   enddo
!enddo
!/////////////////////////////////////////////////

!/////////////////test board(glider)/////////////
do i = 1, n1
   do j = 1, n2
      board(i, j) = 0
   enddo
enddo
board(1:3,3) = 1
board(2,1) = 1
board(3,2) = 1
!////////////////////////////////////////////////


call MPI_INIT(ierr)
call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, numprocs, ierr)

tag = 1234

if(myid .eq. 0) then 
   do i = 1, n1
      print *, board(i,:)
   enddo
!   print *, ':',board(:,1)
endif




!//////////////////assign value into sub-board//////////////
!get the beginning point of sub-baord
bj = (modulo(myid, n2/4)) * 4 + 1
bi = (int(real(myid)/(real(n2)/4)))*4 + 1 
!print *, "begin at: ",bi, ' ', bj, ' myid = ', myid  
do i = bi, bi+3
   do j = bj, bj+3
      subBoard(i-bi+2,j-bj+2) =  board(i,j)
   enddo
enddo

!call printSubBoard(subBoard, myid)

do t = 1, times

!if (t==2) then
!print *, 'myid: ', myid
!call printSubBoard(subBoard, myid)
!endif
!/////////////////////communication unit//////////////////
!read all colum to bufferL
do i = 2, 5
   SbufferL(i) = subBoard(i,2)
   SbufferR(i) = subBoard(i,5)
   SbufferT(i) = subBoard(2,i)
   SbufferB(i) = subBoard(5,i)
enddo

!get direction for which subboard we should ask for data
call getDirection(myid, direction, n1, n2)
!print *, 'myid is ', myid, ' : ', direction

!exchange data (apply ring model)
!print *, 'myid ',myid,': ', SBufferL,'/', SbufferR,'/', SbufferT,'/', SbufferB

!direction 8 -> 4

!************************
!t1 = MPI_Wtime()
!print *, 'ts = ', t1
!**************************

call MPI_ISEND(SbufferR, 6, MPI_INTEGER, direction(4), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferL, 6, MPI_INTEGER, direction(8), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!direction 4 -> 8
call MPI_ISEND(SbufferL, 6, MPI_INTEGER, direction(8), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferR, 6, MPI_INTEGER, direction(4), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr) 

!direction 6 -> 2
call MPI_ISEND(SbufferT, 6, MPI_INTEGER, direction(2), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferB, 6, MPI_INTEGER, direction(6), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!direction 2 -> 6
call MPI_ISEND(SbufferB, 6, MPI_INTEGER, direction(6), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferT, 6, MPI_INTEGER, direction(2), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!direction 7 -> 3
call MPI_ISEND(subBoard(2,5), 1, MPI_INTEGER, direction(3), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferB(1), 1, MPI_INTEGER, direction(7), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!direction 3 -> 7
call MPI_ISEND(subBoard(5,2), 1, MPI_INTEGER, direction(7), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferT(6), 1, MPI_INTEGER, direction(3), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!direction 1 -> 5
call MPI_ISEND(subBoard(5,5), 1, MPI_INTEGER, direction(5), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferT(1), 1, MPI_INTEGER, direction(1), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!direction 5 -> 1
call MPI_ISEND(subBoard(2,2), 1, MPI_INTEGER, direction(1), tag, &
                 &MPI_COMM_WORLD,request, ierr)
call MPI_RECV(RbufferB(6), 1, MPI_INTEGER, direction(5), tag, &
                 &MPI_COMM_WORLD, stat, ierr)
call MPI_WAIT(request, stat, ierr)

!************************
!t2 = MPI_Wtime()
!print *, 'communicate time = ', (t2-t1)/times
!**************************

!if (t == 2) then
!   print *, 'myid is : ', myid, 'RbufferL: ', RbufferL, 'RbufferR: ', RbufferR, 'RbufferT: ', RbufferT, 'RbufferB: ', RbufferB
!endif



!//////////////////////integrade subboard/////////////////////
call integradeSubBoard(subBoard, RbufferL, RbufferR, RbufferT, RbufferB)

!if (t==2) then 
!print *, 'myid: ', myid
!call printSubBoard(subBoard, myid)
!endif

!//////////////////////update subBoard///////////////////////
do i = 2, 5
   do j = 2, 5
      if (sumNine(i, j, subBoard, 6, 6) == 3) then
         newSubBoard(i,j) = 1
      else if (sumNine(i, j, subBoard, 6, 6) == 2) then
         newSubBoard(i,j) = subBoard(i,j)
      else
         newSubBoard(i,j) = 0
      endif
   enddo
enddo

!copy matrix back to subBorad
do i = 1, 6
   do j = 1, 6
      subBoard(i,j) = newSubBoard(i,j)
   enddo
enddo


!if (t==2) then
!print *, 'myid: ', myid
!call printSubBoard(subBoard, myid)
!endif


!print *, 'subBoard update'
!call printSubBoard(subBoard, myid)

!//////////////////////write back subboard to board////////
 
!wrape up the data
newSubBoard(1,1) = bi
newSubBoard(1,2) = bj

!if (t==1) then
!print *, 'myid: ', myid
!call printSubBoard(newSubBoard, myid)
!endif

!send all data into process 0
if(myid .ne. 0) then
   call MPI_SEND(newSubBoard, 36, MPI_INTEGER, 0 , tag, MPI_COMM_WORLD, ierr)
endif

!process 0 sign data back to matrix
if(myid .eq. 0) then
   do i = bi, bi+3
      do j = bj, bj+3
         board(i,j) = newSubBoard(i-bi+2,j-bj+2) 
      enddo
   enddo

   do k = 1, numprocs-1
      call MPI_RECV(newSubBoard, 36, MPI_INTEGER, k, tag, MPI_COMM_WORLD, stat, ierr)
      bi = newSubBoard(1,1)
      bj = newSubBoard(1,2)
      do i = bi, bi+3
         do j = bj, bj+3
            board(i,j) = newSubBoard(i-bi+2,j-bj+2)
         enddo
      enddo   
   enddo 
   
   bi = 1
   bj = 1  
endif


if(myid .eq. 0) then
print *, 'board update: '
   do i = 1, n1
      print *, board(i,:)
   enddo
!   print *, ':',board(:,1)
endif

!print *, 'before barrier from: ', myid
call MPI_BARRIER(MPI_COMM_WORLD, ierr)
enddo





call MPI_FINALIZE(ierr)

end 

subroutine getDirection(myid, direction, n1, n2)
   integer :: myid, n1, n2, n3
   integer :: direction(8)
   !print *, 'in getDirection'
   !n3 = n1
   !n1 = (n1/4)*(n2/4)    
   
   !print *, 'start calculate'
   direction(2) = modulo(myid - n2/4 + (n1/4)*(n2/4), (n1/4)*(n2/4))

   direction(6) = modulo(myid + n2/4 , (n1/4)*(n2/4))

   if(modulo(myid, n2/4) == 0) then
      direction(8) = myid + n2/4 - 1
   else
      direction(8) = myid - 1
   endif

   if(modulo(myid+1, n2/4) == 0) then
      direction(4) = myid - n2/4 + 1
   else 
      direction(4) = myid + 1
   endif
   
   !print *, 'before 3' 
  
   direction(3) = modulo(direction(4) - n2/4 + (n1/4)*(n2/4), (n1/4)*(n2/4))

   direction(5) = modulo(direction(4) + n2/4 , (n1/4)*(n2/4))

   direction(7) = modulo(direction(8) + n2/4 , (n1/4)*(n2/4))

   direction(1) = modulo(direction(8) - n2/4 + (n1/4)*(n2/4), (n1/4)*(n2/4))
   
   !n1 = n3
   !print *, 'in-and-out'
end subroutine


subroutine integradeSubBoard(subBoard, RbufferL, RbufferR, RbufferT, RbufferB)
   integer :: subBoard(6,6), RbufferL(6), RbufferR(6), RbufferT(6), RbufferB(6)
   integer :: i, j

   do i = 1, 6
      subBoard(1,i) = RbufferT(i)
      subBoard(6,i) = RbufferB(i)
   enddo
   
   do i = 2, 5
      subBoard(i,1) = RbufferL(i)
      subBoard(i,6) = RbufferR(i)
   enddo

end subroutine

subroutine printSubBoard(subBoard, myid)
   integer :: myid, subBoard(6,6)
   print *, myid, ' : '
   do i = 1, 6
      print *, subBoard(i,:)
   enddo
end subroutine


function sumNine(i, j, matrix, row, colum)
implicit none
   integer :: i
   integer :: j
   integer :: sumNine
   integer :: row
   integer :: colum

   integer, dimension(row, colum) :: matrix

   integer :: row1
   integer :: row2
   integer :: row3

   row1 = matrix(i-1,j-1) + matrix(i-1,j) + matrix(i-1,j+1)
   row2 = matrix(i,  j-1) + matrix(i,  j+1)
   row3 = matrix(i+1,j-1) + matrix(i+1,j) + matrix(i+1,j+1)
   sumNine = row1 + row2 + row3

end function sumNine


















































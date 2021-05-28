Program matrixDo
implicit none

real :: t1, t2

!set up all the variables
integer :: n, i , j, k, minimum, x, y
parameter(n=1000)
integer,dimension(n,n) :: m1, m2, m3
!initialize
do i = 1, n
   do j = 1, n
      m1(i,j) = i*2 + j
      m2(i,j) = j*2 + i
      m3(i,j) = 0
   enddo
enddo

!print *, m1

call CPU_TIME(t1)

!$OMP PARALLEL
!$OMP DO
do i = 1, n
   do j = 1, n
      do k = 1, n
         m3(i,j)=m3(i,j)+m1(i,k)*m2(k,j)
      enddo
   enddo
enddo
!$OMP END DO
!$OMP END PARALLEL

minimum = m3(n,n)
x=n
y=n
!$OMP PARALLEL
!$OMP DO
do i = 1, n
   do j = 1, n
      if(m3(i,j)<minimum)then
         minimum = m3(i,j)
         x = i
         y = j
      endif
   enddo
enddo 
!$OMP END DO
!$OMP END PARALLEL

call CPU_TIME(t2)

print *, 'm3 is: ', m3
print *, 'minimum is: ', minimum
print *, 'location is: ', x, ' , ', y
print *, 'time cost: ', t2-t1
End

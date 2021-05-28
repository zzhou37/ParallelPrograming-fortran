Program matrixDo
implicit none

real :: t1, t2

!set up all the variables
integer :: n, i , j, loc(2) 
parameter (n = 1000)
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

!$OMP PARALLEL SHARED(m1,m2,m3,i,j)
!$OMP WORKSHARE

m3 = MATMUL(m1,m2)
loc = MINLOC(m3)
!$OMP END WORKSHARE NOWAIT
!$OMP END PARALLEL

call CPU_TIME(t2)

print *, 'm3 is: ', m3
print *, 'location is: ', loc
print *, 'minimum value is: ',m3(loc(1),loc(2))
print *, 'time cost: ', t2-t1
End

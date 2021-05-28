program trap
implicit none

character(100) :: lowChar
character(100) :: highChar
character(100) :: nChar
real :: low
real :: high
real :: fun
integer :: n
integer :: i

real :: dx
real :: sum
real :: fx
real :: x

!///////////////////////// read coustumer inpot/////////////
if(command_argument_count() /= 3) then
   print* , "Usage: ./trap lowBound highBound, n"
   call exit(1)
end if

call get_command_argument(1, lowChar)
call get_command_argument(2, highChar)
call get_command_argument(3, nChar)

read(lowChar, *)low
read(highChar, *)high
read(nChar, *)n

print* , "low: ", low
print* , "high: ", high
print* , "n: : ", n
!/////////////////////////////////////////////////////////////

!////////////////////////////integrade////////////////////////
sum = 0.0
fx = 0.0
x = low
dx = (high - low)/real(n)

print*, "dx is: ", dx

do i = 1, n
   fx = (fun(x) + fun(x + dx))/2.0
   sum = sum + fx * dx
   x = low + dx * i
   !print*, fx*dx
end do

! get argument form user



print* , "the result is: ", sum

end program trap



! this is the hard wired function
function fun(n)

implicit none
   real :: n
   real :: fun

   fun = sin(n)

end function fun
program ones
implicit none
integer, dimension(:,:), allocatable :: matrix
integer, dimension(:,:), allocatable :: solutionMatrix

integer :: row
integer :: colum
integer :: i
integer :: j
integer :: z

integer :: getRandom
integer :: printMatrix

integer :: sumNine
integer :: sum

!///////////////////////// read coustumer inpot/////////////
print*, "row:"
read(*, *) row

print*, "colum:"
read(*, *) colum

print*, "assume all elements not in array are 0s."

print *, "row:", row
print *, "colum:", colum
!/////////////////////////////////////////////////////////////

!////////////////////////creat the question matrix////////////////////
row = row + 2
colum = colum + 2

allocate (matrix(row, colum))
matrix = 0
!z = printMatrix(matrix, row, colum)

do i = 2, row-1
   do j = 2, colum-1
      matrix(i, j) = getRandom()
   end do
end do

print*, "orignail matrix: "
z = printMatrix(matrix, row, colum)
!//////////////////////////////////////////////////////////////////

!//////////////////////////////solve the matrix///////////////////

allocate(solutionMatrix(row-2, colum-2))
solutionMatrix = 0
do i  = 2, row-1
   do j = 2, colum-1 
      sum = sumNine(i,j, matrix, row, colum)
      if( sum == 3) then
            solutionMatrix(i-1, j-1) = 1
      else
            solutionMatrix(i-1, j-1) = 0
      end if
   end do
end do

print*, "solution: "
z = printMatrix(solutionMatrix, row-2, colum-2)
!////////////////////////////////////////////////////////////
deallocate(matrix)
deallocate(solutionMatrix)

end program ones















!///////////////////functions/////////////////////////////
function printMatrix(matrix, row, colum)
implicit none
   integer :: row
   integer :: colum
   integer :: matrix(row, colum)
   integer :: i
   integer :: j
   integer :: printMatrix

   do i = 1, row
         print*, matrix(i, :)
   end do

end function printMatrix


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






function getRandom()
implicit none
   real :: r
   integer :: getRandom

   getRandom = 0
   call random_seed()
   call random_number(r)

   if(r >= 0.5) then
      getRandom = 1

   else 
      getRandom = 0
   end if
   
end function getRandom


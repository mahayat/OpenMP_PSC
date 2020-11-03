      program temp

      real*8 height(1000),width(1000),cost_of_paint(1000)
      real*8 area, price_per_gallon, coverage

      price_per_gallon = 20.00
      coverage = 20.5

!$omp parallel do
      do index=1,1000
         area = height(index) * width(index)
         cost_of_paint(index) = area * price_per_gallon / coverage
      end do
!$omp end parallel do

      end program

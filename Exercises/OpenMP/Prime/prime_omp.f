      program primes

      integer    n, not_primes, i, j
      real*8     start_time, end_time, omp_get_wtime

      n = 500000
      not_primes=0

      start_time = omp_get_wtime()

!$omp parallel do reduction(+:not_primes) schedule(dynamic)
      do i = 2,n
         do j = 2,i-1
            if (mod(i,j) == 0) then
               not_primes = not_primes + 1
               exit
            end if
         end do
      end do
!$omp end parallel do

      end_time = omp_get_wtime()

      print *, 'Primes: ', n - not_primes
      print *, 'Time taken: ', end_time - start_time

      end program


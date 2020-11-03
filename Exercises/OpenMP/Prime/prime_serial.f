      program primes

      integer n, not_primes, i, j

      n = 500000
      not_primes=0

      do i = 2,n
         do j = 2,i-1
            if (mod(i,j) == 0) then
               not_primes = not_primes + 1
               exit
            end if
         end do
      end do

      print *, 'Primes: ', n - not_primes

      end program


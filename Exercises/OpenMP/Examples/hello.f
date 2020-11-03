      program hello

!$OMP PARALLEL

      print *,"Hello World."

!$OMP END PARALLEL

      stop
      end

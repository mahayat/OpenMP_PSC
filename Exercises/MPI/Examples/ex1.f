      program shifter

      include 'mpif.h'

      integer my_pe_num, errcode

      call MPI_INIT(errcode)

      call MPI_COMM_RANK(MPI_COMM_WORLD, my_pe_num, errcode)

      print *, 'Hello from ', my_pe_num,'.'

      call MPI_FINALIZE(errcode)

      end


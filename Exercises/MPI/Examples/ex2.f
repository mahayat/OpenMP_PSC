      program shifter
      implicit none

      include 'mpif.h'

      integer my_pe_num, errcode, numbertoreceive, numbertosend
      integer status(MPI_STATUS_SIZE)

      call MPI_INIT(errcode)

      call MPI_COMM_RANK(MPI_COMM_WORLD, my_pe_num, errcode)

      numbertosend = 42

      if (my_PE_num.EQ.0) then

         call  MPI_Recv( numbertoreceive, 1, MPI_INTEGER, 1,
     +                   10, MPI_COMM_WORLD, status, errcode)

         print *, 'Number received is: ',numbertoreceive

      endif


      if (my_PE_num.EQ.1) then

         call MPI_Send( numbertosend, 1, MPI_INTEGER, 0, 10,
     +                  MPI_COMM_WORLD, errcode)

      endif

      call MPI_FINALIZE(errcode)

      end

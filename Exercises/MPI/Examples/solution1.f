      program shifter
      implicit none

      include 'mpif.h'

      integer my_pe_num, errcode, numbertosend, message_received
      integer status(MPI_STATUS_SIZE)

      call MPI_INIT(errcode)

      call MPI_COMM_RANK(MPI_COMM_WORLD, my_pe_num, errcode)

      numbertosend = my_pe_num

      if (my_pe_num.EQ.7) then
         call MPI_Send(numbertosend, 1, MPI_INTEGER, 0, 10,
     +        MPI_COMM_WORLD, errcode)
      else
         call MPI_Send(numbertosend, 1, MPI_INTEGER, my_pe_num+1, 10,
     +        MPI_COMM_WORLD, errcode)
      endif

      call  MPI_Recv(message_received, 1, MPI_INTEGER, MPI_ANY_SOURCE,
     +     10, MPI_COMM_WORLD, status, errcode)

      print *,'PE', my_pe_num, ' received ', message_received, '.'

      call MPI_FINALIZE(errcode)
      end

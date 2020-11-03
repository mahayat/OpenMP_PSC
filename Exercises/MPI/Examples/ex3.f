      program shifter
      implicit none

      include 'mpif.h'

      integer my_pe_num, errcode, numbertoreceive, numbertosend
      integer index, result
      integer status(MPI_STATUS_SIZE)

      call MPI_INIT(errcode)

      call MPI_COMM_RANK(MPI_COMM_WORLD, my_pe_num, errcode)

      numbertosend = 4
      result = 0

      if (my_PE_num.EQ.0) then
         do index=1,3
            call MPI_Send( numbertosend, 1, MPI_INTEGER, index, 10,
     +           MPI_COMM_WORLD, errcode)
         enddo
      else
         call  MPI_Recv( numbertoreceive, 1, MPI_INTEGER, 0,
     +                   10, MPI_COMM_WORLD, status, errcode)
         result = numbertoreceive * my_PE_num
      endif

      do index=1,3
         call MPI_Barrier(MPI_COMM_WORLD, errcode)
         if (my_PE_num.EQ.index) then
            print *, 'PE ',my_PE_num,'s result is ',result,'.'
         endif
      enddo

      if (my_PE_num.EQ.0) then
         do index=1,3
            call  MPI_Recv( numbertoreceive, 1, MPI_INTEGER, index,
     +                      10, MPI_COMM_WORLD, status, errcode)
            result = result + numbertoreceive
         enddo
         print *,'Total is ',result,'.'
      else
         call MPI_Send( result, 1, MPI_INTEGER, 0, 10,
     +                  MPI_COMM_WORLD, errcode)
      endif

      call MPI_FINALIZE(errcode)
      end

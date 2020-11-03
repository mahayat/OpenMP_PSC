#include <stdio.h>
#include "mpi.h"

main(int argc, char** argv){

  int my_PE_num, number_to_send, message_received;
  MPI_Status status;

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_PE_num);

  number_to_send = my_PE_num;

  if (my_PE_num==7)
      MPI_Send( &number_to_send, 1, MPI_INT, 0, 10, MPI_COMM_WORLD);
  else
      MPI_Send( &number_to_send, 1, MPI_INT, my_PE_num+1, 10, MPI_COMM_WORLD);

  MPI_Recv( &message_received, 1, MPI_INT, MPI_ANY_SOURCE, 10, MPI_COMM_WORLD, &status);

  printf("PE %d received %d.\n", my_PE_num, message_received);
  
  MPI_Finalize();

}

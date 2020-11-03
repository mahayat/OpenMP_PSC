#include <stdio.h>
#include "mpi.h"

main(int argc, char** argv){

  int my_PE_num, numbertoreceive, numbertosend=42;
  MPI_Status status;

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_PE_num);

  if (my_PE_num==0){
    MPI_Recv( &numbertoreceive, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG,
                MPI_COMM_WORLD, &status);
    printf("Number received is: %d\n", numbertoreceive);}

  else MPI_Send( &numbertosend, 1, MPI_INT,
			     0, 10, MPI_COMM_WORLD);
  MPI_Finalize();

}

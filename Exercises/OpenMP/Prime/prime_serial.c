# include <stdlib.h>
# include <stdio.h>

%% #pragma omp parallel 
int main ( int argc, char *argv[] ){
  int n = 50000;
  int not_primes=0;
  int i,j;

%% #pragma omp for reduction(+:not_primes)
  for ( i = 2; i <= n; i++ ){
    for ( j = 2; j < i; j++ ){
      if ( i % j == 0 ){
	not_primes++;
	break;
      }
    }
  }

  printf("Primes: %d\n", n - not_primes);

}


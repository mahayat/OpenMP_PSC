/*************************************************
 * Laplace OpenMP Parallel Region C Version
 *
 * T is initially 0.0
 * Boundaries are as follows
 *
 *      0         T         0
 *   0  +-------------------+  0
 *      |                   |
 *      |                   |
 *      |                   |
 *   T  |                   |  T
 *      |                   |
 *      |                   |
 *      |                   |
 *   0  +-------------------+ 100
 *      0         T        100
 *
 *  John Urbanic, PSC 2013
 *
 ************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>

// columns and rows
#define NC    1000
#define NR    1000

double t[NR+2][NC+2];      // temperature grid
double t_old[NR+2][NC+2];  // previous temperature grid

// prototypes for helper routines
void initialize();
void set_bcs();
void print_trace(int iter);


int main(int argc, char *argv[]) {

    double dt;                 // largest change in t
    int i, j;                 // grid indexes
    int niter;                // number of iterations
    int iter;                 // current iteration

    printf("How many iterations [100-1000]? ");
    scanf("%d", &niter);

    initialize();            // initialize grid
    set_bcs();               // set boundary conditions

    // initialize t_old
    for(i = 0; i <= NR+1; i++){
        for(j=0; j<=NC+1; j++){
            t_old[i][j] = t[i][j];
        }
    }


    double start_time = omp_get_wtime();

    // do the computation for niter steps
    #pragma omp parallel shared(t, t_old) private(i,j,iter) firstprivate(niter) reduction(max:dt)
    for(iter = 1; iter <= niter; iter++) {

        // main calculation: average my four neighbors
        #pragma omp for
        for(i = 1; i <= NR; i++) {
            for(j = 1; j <= NC; j++) {
                t[i][j] = 0.25 * (t_old[i+1][j] + t_old[i-1][j] +
                                  t_old[i][j+1] + t_old[i][j-1]);
            }
        }
        
	// reset greatest temp change
        dt = 0.0;

        // copy grid to old grid for next iteration and find dt
        #pragma omp for
        for(i = 1; i <= NR; i++){
            for(j = 1; j <= NC; j++){
	      dt = fmax( fabs(t[i][j]-t_old[i][j]), dt);
	      t_old[i][j] = t[i][j];
            }
        }

        // periodically print test values
        #pragma omp master
        if((iter % 100) == 0) {
            print_trace(iter);
        }
	#pragma omp barrier
    }

    double end_time = omp_get_wtime();

    printf("Time taken: %f\n", end_time - start_time);
}


// initialize all the values to 0
void initialize(){

  int i,j;

    for(i = 0; i <= NR+1; i++){
        for (j = 0; j <= NC+1; j++){
            t[i][j] = 0.0;
        }
    }
}


// set the values at the boundary; these boundary values do not change
void set_bcs(){

  int i,j;

    // set sides to 0 and a linear increase
    for(i = 0; i <= NR+1; i++) {
        t[i][0] = 0.0;
        t[i][NC+1] = (100.0/NR)*i;
    }
    
    // set top to 0 and bottom to linear increase
    for(j = 0; j <= NC+1; j++) {
        t[0][j] = 0.0;
        t[NR+1][j] = (100.0/NR)*j;
    }
}


// print trace in bottom corner where most action is
void print_trace(int iter) {

    int i;

    printf("---------- Iteration number: %d ------------\n", iter);
    for(i = NR-5; i <= NR; i++) {
        printf("[%d,%d]: %5.2f  ", i, i, t[i][i]);
    }
    printf("\n");
}

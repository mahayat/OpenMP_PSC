// omp_init_lock.cpp
// compile with: /openmp
#include <stdio.h>
#include <omp.h>

omp_lock_t my_lock;

int main() {
  omp_init_lock(&my_lock);

#pragma omp parallel num_threads(4)
  {
    int tid = omp_get_thread_num( );
    int i, j;

    omp_set_lock(&my_lock);

    for (i = 0; i < 5; ++i) {
      printf("Thread %d - in locked region\n", tid);
    }

    printf("Thread %d - ending locked region\n", tid);

    omp_unset_lock(&my_lock);

  }

  omp_destroy_lock(&my_lock);
}


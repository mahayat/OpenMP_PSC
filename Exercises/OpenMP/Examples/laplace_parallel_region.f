***********************************************************
* Laplace OMP Fortran Version
* 
* T is initially 0.0 
* Boundaries are as follows
*
*          T=0.   
*       _________        
*	|	| 0      
*	|	|        
* T=0.  | T=0.0 | T      
*	|	|        
*	|_______| 100    
*       0     100        
*                        
*
* John Urbanic,  PSC.... 2008;
* From the original version by S Chitre, R Reddy, PSC 1994
***********************************************************

      program omp
      implicit none

      integer   NR, NC
      parameter (NR=1000, NC=1000)
      real*8     t(0:NR+1,0:NC+1), told(0:NR+1,0:NC+1), dt
      integer    i, j, iter, niter
      real*8     start_time, end_time, omp_get_wtime

      print*, 'How many iterations [100-1000]?'
      read*,   niter

      call initialize( t )
      call set_bcs( t )

* Initialize told
      do i=0, NR+1
         do j=0, NC+1
            told(i,j) = t(i,j)
         enddo
      enddo

      start_time = omp_get_wtime()

* Beginning of main loop
!$omp parallel shared(T, Told) private(i,j,iter)
!$omp&         firstprivate(niter) reduction(max:dt)
      Do iter=1,niter

!$omp do          
         Do j=1,NC
            Do i=1,NR
               T(i,j) = 0.25 * ( Told(i+1,j)+Told(i-1,j)+
     $                           Told(i,j+1)+Told(i,j-1) )
            Enddo
         Enddo
!$omp end do          

* Copy grid to old grid for next iteration and find max change
         dt = 0

!$omp do
         Do j=1,NC
            Do i=1,NR
               dt = max( abs(t(i,j) - told(i,j)), dt )
               Told(i,j) = T(i,j)
            Enddo
         Enddo
!$omp end do          

* Print some Values
!$omp master
         If( mod(iter,100).eq.0 ) then
            call print_trace(t, iter)
         endif
!$omp end master

!$omp barrier

* End of main loop
      enddo
!$omp end parallel

      end_time = omp_get_wtime()

      print *, "Time taken: ", end_time-start_time

* End of Program
      END

* Initialize array to zero temp
      subroutine initialize( t )
      implicit none

      integer   NR, NC
      parameter (NR=1000, NC=1000)

      real*8     t(0:NR+1,0:NC+1)
      integer    i, j

      do i=0, NR+1
         do j=0, NC+1
            t(i,j) = 0
         enddo
      enddo
      
      return

      end

* Set boundary conditions.  These stay constant.
      subroutine set_bcs( t )
      implicit none

      integer   NR, NC
      parameter (NR=1000, NC=1000)

      real*8     t(0:NR+1,0:NC+1)
      integer    i, j

*Left and Right BC
      do i=0,NR+1
         T(i,0) = 0.0
         T(i,NC+1) = (100.0/NR) * i
      enddo

*Top and Bottom Boundaries
      do j=0,NC+1
         T(0,j) = 0.0
         T(NR+1,j) = ((100.0)/NC) * j
      enddo

      return

      end

* Print trace in bottom corner
      subroutine print_trace(t, iter)
      implicit none

      integer   NR, NC
      parameter (NR=1000, NC=1000)

      real*8     t(0:NR+1,0:NC+1)
      integer    i, iter

      write(6,1)iter
      write(6,3)(t(i,i), i=NC-5,NC)

 1    format('---------- Iteration number: ', i10, '---------------')
 3    format(5f15.8)
      return
      end

int main(int argc, char** argv){

  float height[1000];
  float width[1000];
  float cost_of_paint[1000];
  float area, price_per_gallon = 20.00, coverage = 20.5;
  int index;

#pragma omp parallel for
  for (index=0; index<1000; index++){
    area = height[index] * width[index];
    cost_of_paint[index] = area * price_per_gallon / coverage; 
  }


}

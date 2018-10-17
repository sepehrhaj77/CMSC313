#include "frac_heap.h"

static fraction fractions[20];

void init_heap(){
  int i;
  for(i=0; i<20; i++){
    fractions[i].sign = 0; /*sign of 0 means not initialized, 1 means positive, -1 means negative*/
    fractions[i].numerator = 0;
    fractions[i].denominator = i+1;
  }
  fractions[19].denominator = 99;
}

fraction *new_frac(){
  int i;
  /*go through entire array of memory dedicated for fractions and return a pointer to the first available index*/
  for(i=0; i<20; i++){
    if(fractions[i].sign == 0){/*sign of 0 means that it is not intialized*/
      return &fractions[i];
    }
  }
  return NULL; /*if no free memory is available, return NULL*/
}

void del_frac(fraction *fptr){

  /*make sure that fptr is pointing to something in our global array, and not some random place in memory*/
  int end = 1;
  int i;
  int index = 0; /*variable to keep track of the index of the fptr passed*/
  for(i=0; i<20; i++){
    /*if the fraction is found in the array, zero it out to indicate a free block and store the index it was found*/
    if(fptr == &fractions[i]){
      end = 0; /*no error has occured, do not exit the program*/
      index = i;
      fptr->sign = 0;
      fptr->numerator = 0;
      break;
    }
  }

  /*if it's not pointing to something in our array, display an error message and exit the program*/
  if(end == 1){
    printf("Pointer passed is not pointing to something in array of fractions!");
    exit(-1);
  }

  /*Calculate what the next free block is*/
  int j;
  int k;
  for(k=0; k<20; k++){
      if(fractions[k].sign==0){


  for(j=k+1; j<21; j++){
    if(j==20){ /* 20 is an invalid index so if j has reach 20 we know there is no free memory further in the array*/
      fractions[k].denominator = 99; /*99 will be my "special number" to indicate no more free space left*/
      break;
    }
    if(fractions[j].sign == 0){ /*if the memory block is free, store that this is the index of the next free block*/
      fractions[k].denominator = j;
      break;
    }
  }
      }
    }
}

/*dumps according to assignment*/
void dump_heap(){
  int i;
  int free = -1;

  printf("\n**** BEGIN HEAP DUMP ****\n");
  
  for(i=0; i<20; i++){
    free++;
    if(fractions[i].sign == 0){
      break;
    }
  }

  printf("first free = %d\n\n", free);

  for(i=0; i<20; i++){
    printf("%d: %d %d %d\n", i, fractions[i].sign, fractions[i].numerator, fractions[i].denominator);
  }

  printf("**** END HEAP DUMP ****\n\n");

}

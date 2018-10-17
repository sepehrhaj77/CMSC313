/*File: frac_heap.c
 *Sepehr Hajbarat
 *Project 6
 *11/15/17
 *This file is the implementation of the frac_heap.h file. It allocates memory for fractions using the malloc() command
 */

#include "frac_heap.h"

union fraction_block_u {
  union fraction_block_u *next;
  fraction frac;
};
typedef union fraction_block_u fraction_block;

fraction_block blocks;
static fraction_block *block = & blocks;

/*initializing an empty list by setting the next element in the list to zero*/
void init_heap(void){
  block->next = NULL;
}

fraction *new_frac(void){
  fraction_block* memArray;
  /*if no free blocks are available*/
  if(block->next == NULL){
    int size = 5*sizeof(fraction);
    memArray = (fraction_block*) malloc(size);

    /*make sure that we have not truly run out of memory on the system*/
    if(memArray == NULL){
      printf("Error: No more memory on the system!");
      exit(-1);
    }

    /*for loop to go through each pointer in the array and set the next pointer in the array to be the next member variable of the pointer*/
    int i;
    for(i=0; i<4; i++){
      memArray[i].next = &memArray[i+1];
    }

    printf("\ncalled malloc() (%d): returned %p\n", size, memArray);
    block->next = memArray;
    fraction_block* removed;
    removed = &memArray[0];
    block->next = &memArray[1];
 
    return &removed->frac;
  }
    /*if a free block is available, return a pointer to the first available free one*/
  else{
    fraction_block* nextAvailable = block->next;
    block->next = block->next->next;
    return &nextAvailable->frac;
  }


}

void del_frac(fraction *frac){
  fraction_block *fbp;
  fbp = (fraction_block *) frac;

  frac->sign = 0;
  frac->numerator = 0;
  frac->denominator = 0;

  fbp->next = block->next;
  block->next = fbp;
}

void dump_heap(void){
  printf("\n**** BEGIN HEAP DUMP ****\n");
  fraction_block* fbp = block->next;

  if(fbp == NULL){
    printf("Free list is empty\n");
    return;
  }

  while(fbp != NULL){
    printf("   %p\n", fbp);
    fbp = fbp->next;
  } 
  printf("\n**** END HEAP DUMP ****\n");
}

#ifndef FRAC_HEAP_H
#define FRAC_HEAP_H

#include <stdlib.h>
#include <stdio.h>

typedef struct fraction{
  signed char sign;
  unsigned int numerator;
  unsigned int denominator;
}fraction;

void init_heap();
fraction *new_frac();
void del_frac(fraction *fptr);
void dump_heap();

#endif

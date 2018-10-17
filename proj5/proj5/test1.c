/*
 *  File: test1.c
 *
 * This test showcases the storage of up to 20 fractions. If you try to create a 21st fraction you will receive a segmentation fault because null will be returned and in init_frac() it will try to dereference null.
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include "frac_heap.h"

/*
 * Compute the greatest common divisor using Euclid's algorithm
 */
unsigned int gcd ( unsigned int a, unsigned int b) {

   if (b == 0) return a ;

   return gcd (b, a % b) ;
}

/*
 * Print a fraction out nicely
 */
void print_frac (fraction *fptr) {

   if (fptr->sign < 0) printf("-") ;

   printf("%d/%d", fptr->numerator, fptr->denominator) ;

}

/*
 * Initialize a fraction
 */
fraction *init_frac (signed char s, unsigned int n, unsigned int d) {
   
   fraction *fp ;

   fp = new_frac() ;
   fp->sign = s ;
   fp->numerator = n ;
   fp->denominator = d ;

   return fp ;
}

/*
 * Add two fractions
 * Return value is a pointer to allocated space.
 * This must be deallocated using del_frac().
 */
fraction *add_frac(fraction *fptr1, fraction *fptr2) {
   unsigned int lcm, div, g, m1, m2  ;
   fraction *answer ;


   g = gcd(fptr1->denominator, fptr2->denominator) ;
   lcm = (fptr1->denominator / g) * fptr2->denominator ;

   m1 = (fptr1->denominator / g) ;
   m2 = (fptr2->denominator / g) ;
   lcm = m1 * fptr2->denominator ;

   answer = new_frac() ;
   answer->denominator = lcm ;

   if (fptr1->sign == fptr2->sign) {

      answer->sign = fptr1->sign ;
      answer->numerator = fptr1->numerator * m2 + fptr2->numerator * m1 ;

   } else if (fptr1->numerator >= fptr2->numerator) {

      answer->sign = fptr1->sign ;
      answer->numerator = fptr1->numerator * m2 - fptr2->numerator * m1 ;

   } else {

      answer->sign = fptr2->sign ;
      answer->numerator = fptr2->numerator * m2 - fptr1->numerator * m1 ;

   }

   div = gcd(answer->numerator, answer->denominator) ;
   answer->numerator /= div ;
   answer->denominator /= div ;

   return answer ;

}


int main() {
   fraction *fp1, *fp2, *fp3 ;

   init_heap() ;

   fp1 = new_frac() ;
   fp1->sign = -1 ;
   fp1->numerator = 5 ;
   fp1->denominator = 7 ;

   fp2 = new_frac() ;
   fp2->sign = 1 ;
   fp2->numerator = 1 ;
   fp2->denominator = 4 ;

   fp3 = add_frac(fp1, fp2) ;

   print_frac(fp1) ; 
   printf(" plus ") ;
   print_frac(fp2) ; 
   printf(" = ") ;
   print_frac(fp3) ; 
   printf("\n") ;

   dump_heap() ;


   fraction *fp4, *fp5, *fp6 ;
   fp4 = init_frac(1, 8, 42) ;
   fp5 = init_frac(1, 17, 96) ;
   fp6 = add_frac(fp4, fp5) ;

   fraction *fp7, *fp8, *fp9 ;
   fp7 = init_frac(1, 9, 43) ;
   fp8 = init_frac(1, 16, 94) ;
   fp9 = add_frac(fp4, fp5) ;

   fraction *fp10, *fp11, *fp12 ;
   fp10 = init_frac(1, 10, 40) ;
   fp11 = init_frac(1, 15, 80) ;
   fp12 = add_frac(fp4, fp5) ;
   
   fraction *fp13, *fp14, *fp15 ;
   fp13 = init_frac(-1, 8, 41) ;
   fp14 = init_frac(1, 11, 96) ;
   fp15 = add_frac(fp4, fp5) ;

   fraction *fp16, *fp17, *fp18 ;
   fp16 = init_frac(-1, 6, 11) ;
   fp17 = init_frac(1, 23, 52) ;
   fp18 = add_frac(fp4, fp5) ;

   fraction *fp19, *fp20, *fp21;
   fp19 = init_frac(1, 6, 11) ;
   fp20 = init_frac(-1, 23, 52) ;
   fp21 = new_frac();
   
   if(fp21 == NULL){
     printf("no room for any more fractions!");
   }   
   
   dump_heap() ;




   return 0 ;
}

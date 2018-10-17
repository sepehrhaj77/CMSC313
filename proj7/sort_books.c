/*sort_books.c
 *sort_books.out
 *created: 11/26/17
 *modified: 11/26/17
 *Sepehr Hajbarat
 *Uses qsort, and calls an assembly written comparison function to sort books primarily by year and then subsort by title
 */

#include "book.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*Given from project description*/
void sort_books(struct book books[], int numBooks);

/*bookcmp will be implemented in assembly so it must be declared as extern*/
extern int bookcmp(const struct book *, const struct book *);

/*Call qsort based on the parameters it needs, using the external bookcmp that will be implemented in assembly*/
void sort_books(struct book books[], int numBooks){
  qsort(books, numBooks, sizeof(books[0]), bookcmp);
}

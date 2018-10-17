#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*
 * Following is straight from the project description
 */
#define TITLE_LEN       32
#define AUTHOR_LEN      20
#define SUBJECT_LEN     10

struct book {
    char author[AUTHOR_LEN + 1];    /* first author */
    char title[TITLE_LEN + 1];
    char subject[SUBJECT_LEN + 1];  /* Nonfiction, Fantasy, Mystery, ... */
    unsigned int year;              /* year of e-book release */
};


/*
 * Declarations for functions that are defined in other files
 */

/*STUB: ADD EXTERNAL FUNCTION DECLARATIONS HERE*/
extern int bookcmp(void);
void sort_books(struct book books[], int numBooks);
void print_books(struct book books[], int numBooks); 

/*
 * Declarations for global variables that need to be accessed
 * from other files
 */
struct book *book1, *book2;
/*STUB: ADD DECLARATIONS FOR YOUR OWN GLOBAL VARIABLES HERE*/

#define MAX_BOOKS 100

int main(int argc, char **argv) {
    struct book books[MAX_BOOKS];
    int numBooks;

    /* STUB: ADD CODE HERE TO READ A RECORD AT A TIME FROM STDIN USING scanf()
            UNTIL IT RETURNS EOF
     */
    FILE *myFile;
    myFile = fopen(argv[1], "r");
    if(myFile==NULL){
      printf("Error opening the file\n");
      exit(-1);
    }

    char tempTitle[80+1];

    int i;
    int numFields;

    /*iterate through and store only MAX_BOOKS books, in this case 100, or stop reading when end of file is reached.*/
    for(i=0; i<MAX_BOOKS; i++){
      numFields = fscanf(myFile, "%80[^,], %20[^,], %10[^,], %u\n", tempTitle, &(books[i].author), &(books[i].subject), &(books[i].year));
      strncpy(books[i].title, tempTitle, 32);
      numBooks=i;
      /*If we have reached the end of the file, store the amount of books we have read in*/
      if(numFields == EOF){
	numBooks = i;
	break;
      }
      /*in case the condition of filling up the array first is met, store the amount of books*/
      else if(i==MAX_BOOKS-1){
	numBooks=MAX_BOOKS;/*if the max number of books has been stored, make that numBooks*/
	break;
      }
    }

    /*    
     int i;
     for (i = 0; i < MAX_BOOKS; i++) {
     */   
	/* Sample line: "Breaking Point, Pamela Clare, Romance, 2011" */

	/* We are giving you the scanf() format string; note that
	 * for the string fields, it uses the conversion spec "%##[^,]",
	 * where "##" is an actual number. This says to read up to a
	 * maximum of ## characters (not counting the null terminator!),
	 * stopping at the first ','  Also note that the first field spec--
	 * the title field--specifies 80 chars.  The title field is NOT
	 * that large, so you need to read it into a temporary buffer first,
	 * of an appropriately large size so that scanf() doesn't overrun it.
	 * All the other fields should be read directly into the struct book's
	 * members.
	 *numFields=
	 */


       /*
	 fscanf(myFile,"%80[^,], %20[^,], %10[^,], %u \n", &tempTitle, &(books[i].author), &(books[i].subject);*/


     /*			  STUB: REST OF ARGS TO scanf()???);
      */
    /*	if (numFields == EOF) {
     *	    numBooks = i;
     *	    break;
     *	}
    */
	/* Now, process the record you just read.
	 * First, confirm that you got all the fields you needed (scanf()
	 * returns the actual number of fields matched).
	 * Then, post-process title (see project spec for reason)
	 */

       /*	STUB: VERIFY AND PROCESS THE RECORD YOU JUST READ
     }*/

    /* Following assumes you stored actual number of books read into
     * var numBooks
     */
    /*    sort_books(books, numBooks);
     *
     *print_books(books, numBooks);
    */
    sort_books(books, numBooks);
    print_books(books, numBooks);
    fclose(myFile);
    return 0;
}

/*
 * sort_books(): receives an array of struct book's, of length
 * numBooks.  Sorts the array in-place (i.e., actually modifies
 * the elements of the array).
 *
 * This is almost exactly what was given in the pseudocode in
 * the project spec--need to replace STUBS with real code
 */
void sort_books(struct book books[], int numBooks) {
  int i, j, min;
  int cmpResult;

  if(numBooks == 0){
    printf("There were no books to read in from the file!\n"); /*in case the array of books is empty*/
    return; /*don't even call bookcmp(), just exit the function*/
  }

  for (i=0; i<numBooks-1; i++){
    min = i; /*assume the book in the current index is the smallest, swap if not*/
    for(j=i+1; j<numBooks; j++){ /*for loop to go through the entire rest of the array and find the smallest value*/
      book1= &books[min];
      book2= &books[j];
      cmpResult = bookcmp();

      if(cmpResult == 1){
	min = j;
      }
    } 

    /*if the current index we are at is not already the smallest*/
    if(min !=i) {
      struct book temp = books[i]; /*temp variable to hold the first book that is being swapped*/
      books[i] = books[min];
      books[min] = temp;
    }

  }


  /*
    int i, j, min;
    int cmpResult;

    for (i = 0; i < numBooks - 1; i++) {
	min = i;
	for (j = i + 1; j < numBooks; j++) {
  */
	    /* Copy pointers to the two books to be compared into the
	     * global variables book1 and book2 for bookcmp() to see
	     */
  /*	    STUB: ADD STUFF HERE

	    cmpResult = bookcmp();*/
	    /* bookcmp returns result in register EAX--above saves
	     * it into cmpResult */

  /*	    if (STUB: book2 COMES BEFORE book1) {
		min = j;
	    }
	}
	if (min != i) {
	    STUB: SWAP books[i], books[min];
	}
	}*/
}

void print_books(struct book books[], int numBooks) {

  /*    STUB: ADD CODE HERE TO OUTPUT LIST OF BOOKS*/
  int i;
  if(numBooks == 0){ /*if array of books is empty print nothing*/
    return;
  }

  for(i=0; i<numBooks; i++){
    printf("%s, %s, %s, %u\n", books[i].title, books[i].author, books[i].subject, books[i].year);
  }
}

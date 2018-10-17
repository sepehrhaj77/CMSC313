#ifndef BOOK_H
#define BOOK_H

#define AUTHOR_LEN      20
#define TITLE_LEN       32
#define SUBJECT_LEN     10

struct book {
    char author[AUTHOR_LEN + 1];    /* first author */
    char title[TITLE_LEN + 1];
    char subject[SUBJECT_LEN + 1];  /* Nonfiction, Fantasy, Mystery, ... */
    unsigned int year;              /* year of e-book release */
};
#endif /* BOOK_H */

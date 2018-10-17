;;; ; bookcmp.asm
;;; ; sort_books.out
;;; ; created: 10/28/17
;;; ; modified 11/1/17
;;; ; Sepehr Hajbarat
;;; ; Compares two books passed by a C function and returns a -1, 0, or 1 based on whether book1 is less than, equal to, or greater than book 2 respectively by year and then title
	


;;  Offsets for fields in struct book.
;;
%define AUTHOR_OFFSET 0
%define TITLE_OFFSET 21
%define SUBJECT_OFFSET 54
%define YEAR_OFFSET 68
	
	SECTION .data
	
	SECTION .text
	global bookcmp
	extern book1, book2

bookcmp:
	mov ebx, [book1]
	mov ecx, [book2]

	;; compare their years first
	.compareYear:
		mov eax, dword[ebx+YEAR_OFFSET] ;store the year of book 1
		mov edx, dword[ecx+YEAR_OFFSET] ;store the year of book 2
		cmp eax, edx
		je .titlecmp		;if years are equal, compare titles
		jl .less		;if book 1's year is less, move on to return a -1 in eax
		jg .greater		;if book 1's year is greater, move on to return a +1 in eax


	;; if the years of the books are the same, subsort by title
	.titlecmp:
		lea esi, [ebx+TITLE_OFFSET] 
		lea edi, [ecx+TITLE_OFFSET] 

	.titlecmpLoop:
		mov ah, [esi]		    ;store the title of book 1 in the 16 byte register ah
		mov dh, [edi]		    ;store the title of book 2 in the 16 byte register dh
		cmp ah, dh
		jl .less		;if the current letter of the title of book 1 is lower alphabetically, move on to return a -1
		jg .greater		;if the current letter of the title of book 1 is greater alphabetically, move on to retuen a +1
	
	;; if the letters are equal, make sure they're not both null. If not, then increment esi and edi to point to the next letter before going back to the beginning of the loop
		cmp ah, 0
		je .equal 	;if they are both equal up until null, they have the exact same title and are equal, so a 0 should be returned
	
		inc esi
		inc edi
		jmp .titlecmpLoop
	
	;; if the books are the same year and title
	.equal:
		mov eax, 0
		jmp .done
	
	;; if book 1 is less than book 2
	.less:
		mov eax, -1
		jmp .done

	;; if book 1 is greater than book 2
	.greater:
		mov eax, 1
		jmp .done
	.done:
		ret
; File: bookcmp.asm
	;; sort_books.out
	;; created: 11/26/17
	;; modified: 11/26/17
	;; Sepehr Hajbarat
;;Defines the bookcmp subroutine for use by the qsort algorithm in sort_books.c
;
%define AUTHOR_OFFSET 0
%define TITLE_OFFSET 21
%define SUBJECT_OFFSET 54
%define YEAR_OFFSET 68
	

        SECTION .text                   ; Code section.
        global  bookcmp                 ; let loader see entry point

bookcmp: 
	push	edi			; push registers we want to use
	push	esi
	push	ecx
	push	edx
	push 	ebp
	
	mov 	ebp, esp		; put what the stack is pointing to in ebp
	
	mov	ecx, [ebp+24]		; get the pointer to the first book by using stack manipulation
	mov	edx, [ebp+28]		; get the pointer to the second book by using stack manipulation

	mov	eax, [ecx + YEAR_OFFSET]; fetch book1's year field
	sub	eax, [edx + YEAR_OFFSET]; and "compare" the to book2's year
	jnz	allDone			; If they're different, we're done
					; with comparisons

cmpTitles:				; Fall through to here if years same
	;; Following could also be done using "lea" instruction
	mov	edi, ecx		; Get address of book1's title
	add	edi, TITLE_OFFSET
	mov	esi, edx		; Get address of book2's title
	add	esi, TITLE_OFFSET
	mov	eax, 0			; Pre-clear all 32 bits of eax

L1:	mov	al, [edi]		; Fetch next char of book1's title
	sub	al, [esi]		; and compare it to matching char in
					; book 2
	jne	titleCmpDone		; If we find a difference, we are done
					; (note this also works if one string
					; or other at NULL)

	;; So far, all chars equal; see if we are at end (i.e., check for NULL)
	cmp	byte [edi], 0
	je	titleCmpDone
	inc	edi
	inc	esi
	jmp	L1

titleCmpDone:
	movsx	eax, al			; need to convert 8-bit to full 32-bit

allDone:				; Clean up and finish
	;; Note that eax already has an appropriate value <0, =0, or >0

	cmp eax, 0		;to ensure only -1, 0, and 1 are stored compare the value to 0
	jg .greaterThan		;if it is greater than 0, it will be transformed to a 1
	jl .lessThan		;if it is less than 0, it will be transofrmed to a -1
	je .done		;otherwise, just keep the 0 in eax that we already stored from al

	.greaterThan:		;store a 1 to indicate greater
		mov eax, 1
		jmp .done

	.lessThan:		;store a -1 to indicate less
		mov eax, -1
		jmp .done

	.done:			;pop all of the registers back to be used again
		pop 	ebp
		pop	edx
		pop	ecx
		pop	esi
		pop	edi
		ret

;;; escapeseqs.asm
;;; escaeseqs
;;; created: 10/1/17
;;; modified 10/12/17
;;; Sepehr Hajbarat
;;; nasm elf assembler
;;; carries out escape sequences typed in a string by the user
;;; nasm -f elf -g F stabs escapeseqs.asm
;;; ld -m elf_i386 -o escapeseqs escapeseqs.o

		%define STDIN 0
	        %define STDOUT 1
	        %define STDERR 2
	        %define SYSCALL_EXIT  1
	        %define SYSCALL_READ  3
	        %define SYSCALL_WRITE 4
	        %define BUFLEN 256

	[SECTION .data]
;;; ; ; Here we declare initialized data. For example: messages, prompts,
;;; ; ; and numbers that we know in advance
msg1:	db "Enter String: " 	;user prompt
len1:	equ $-msg1		;length of first message

msg2:	db "Original: " 	;message to display original string
len2:	equ $-msg2	;length of second message

msg3:	db "Convert: "		;message to display converted string
len3:	equ $-msg3		;length of thirds message

letterTable:	db 'a', 'b', 't', 'n', 'v', 'f', 'r'
decimalTable:	db 7, 8, 9, 10, 11, 12, 13, 92
octalTable:	db 007, 010, 011, 012, 013, 014, 015, 134

errUnknown:	db "Error: unknown escape sequence \" ;error message if capital letter
lenUnknown:	equ $-errUnknown		     ;length of error message

errOverflow:	db "Error: octal value overflow in \" ;error message if octal overflow
lenOverflow:	equ $-errOverflow		     ;length of error message

	
        [SECTION .bss]
;;; ; ; Here we declare uninitialized data. We're reserving space (and
;;; ; ; potentially associating names with that space) that our code
;;; ; ; will use as it executes. Think of these as "global variables"

buf:	        	resb BUFLEN	; buffer for read
newStr:			resb BUFLEN	; new output we're going to have
readlen:	        resb 4	; storage for the length of string we read

escapeSeqStr:		resb BUFLEN ;to hold the error message of what we want to manipulate
escapeSeqLen:		resb 4	    ;length of error string

	[SECTION .text]

	global _start	; make start global so ld can find it

_start:				; the program actually starts here
;;; ;  prompt for user input
	mov eax, SYSCALL_WRITE
	mov ebx, STDOUT
	mov ecx, msg1
	mov edx, len1
	int 80H

;;; ;  read user input
	mov eax, SYSCALL_READ
	mov ebx, STDIN
	mov ecx, buf
	mov edx, BUFLEN
	sub edx, 1
	int 80H

;;; ;  remember how many characters we read
	mov [readlen], eax

;;; ; ;  Tell user what they entered
	mov eax, SYSCALL_WRITE
	mov ebx, STDOUT
	mov ecx, buf
	mov edx, [readlen]
	int 80H
	
	mov eax, SYSCALL_WRITE
	mov ebx, STDOUT
	mov ecx, buf
	mov edx, BUFLEN
	int 80H
	

;;; ;  loop over all characters
	mov esi, buf
	mov edi, newStr

.loop:
	cmp eax, 0
	je .done

;;; ;  grab the next letter
	mov bh, [esi]

;;; only transforms values that are between 'a' and 'z'
	cmp bh, '\'
	je .esc
	jmp .lettercomplete

.esc:
	call handle_ESC

	
.lettercomplete:
	mov [edi], bh
	add esi, 1
	add edi, 1
	sub eax, 1
	jmp .loop

.done:
	call _end

handle_ESC:

.first:
;;; push edi, eax, edx, ecx, and ebx in order and then go on to the next character
	push edi
	push eax
	push ecx
	push ebx
	push edx
;;; go to character next to '\'
	add esi, 1
	mov bh, [esi]

.checkValidity:
	cmp bh, '0'
	jl .unknownSeqError
	cmp bh, '9'
	jg .letterFound

.escapeSeqStr:
	mov edi, escapeSeqStr
	mov eax, 0		;32 bit counter for comparing octal values
	mov cl, 0		;8 bit counter for making sure other stuff after is not inluded, and to compare with esi

	jmp .numberFound
	
;;; if (c == OCTAL_DIGIT)
	;; PSEUDOCODE, not working
	;; mov cl, 0        ;counter to see if it has traversed through the whole octal table
	;; mov dl, 0        ;counter for for loop to see if it has executed 3 times
	;; mov el, 0        ;variable to hold the value
.numberFound:
	;; cmp dl, 3	    ;see if loop has executed max 3 times already
	;; je .checkOctal  ;if so go to done to set it as an escape sequence
	;; mov eax, [esi]   ;set the current character into eax to manipulate it
	;; sub eax, 48	    ;subtract 48 from the ascii value so we get the decimal value of the number
	;; mul el, 8        ;multiple the value variable by 8
	;; add el, [eax]    ;add the converted octal digit value
	;; add esi, 1	    ;move on to the next character to see if it's an octal as well 
	;; mov bh, [esi]
	;; cmp bh, (1,2,3,4,5,6,7,8) ;see if it's an octal value
	;; jne .checkOctal ;if not, we are done and will use the value stored as an octal
	;; sub esi, 1       ;otherwise decrement esi again as we will have to deal with the next octal
	;; cmp el, 377octal ;see if it's greater than 377 octal
	;; jg  .octalOverflowError ;if so go to the section that states there is octal overflow
	;; inc dl           ;increase the counter that keeps track of how many times loop has executed

	;; .checkOctal:
	;; 	mov cl, 0		;counter to see if it has traversed entire octal table
	;; 	mov eax, 0		;counter to keep track of what in the table it is
	;; 	mov edi, octalTable	;point edi to octalTable
	;; 	.octalLoop:
	;;		cmp cl, 7		;see if it has traversed whole octal table
	;; 		je .unknownSeqError	;if it has, there is no matching sequence
	;; 		cmp el, [edi+eax*2]	;compare the value to the octal values inside the table
	;; 		je .setOctalValue
	;; 		inc cl			;increase inside table counter
	;; 		inc eax			;increase counter so we know which thing in the table it is
	;; 		jmp .octalLoop		;go back to the beginning of the loop
	;; 	.setOctalValue:
	;; 		pop eax
	;; 		mov ah, cl		;put new octal value into ah
	;; 		push eax		;put it back on the stack to move on to the next part of the string
	;; 		jmp .done		;jump to where we know we are done converting something
	
;;; else if( c = lowercase)
.letterFound:
	cmp bh, 'a'		;see if it's less than 'a', 
	jl .slashFound		;if so, check to see if it's a slash
	cmp bh, 'z'		;see if it's greater than z
	jg .unknownSeqError	;if so, it's not a valid character

;;; set the escape sequence string and look it up in the table
	mov cl, 0		;counter to see if it has traversed entire letter table
	mov eax, 0		;counter to keep track of what in the table it is
	mov edi, letterTable	;point edi to letterTable

	.letterLoop:
		cmp cl, 7	;compare counter to 7, to see if value was found in table
		je .unknownSeqError	;if not, error has been found
		cmp bh, [edi+eax*2] ;compare the value inside the table
		je .setLetterValue
		inc cl		;increase inside table counter
		inc eax		;increase counter so we know which thing in the table it is
		jmp .letterLoop	;go back to the start of the loop

	.setLetterValue:
		add cl, 7 	;add 7 so that the value now matches the ascii value
		pop ebx		;get ebx's first value from the stack
		mov bh, cl	;put the new ascii value into bh
		push ebx	;put it back on the stack so we save it and can continue to use ebx as an empty register
		jmp .done	;jump to done, where we know that we are done converting a letter

;;; else if (c == '\') 
.slashFound:
		cmp bh, '\'	;see if it's a backslash after the backslash
		je .makeSlash	;if it is, go to section that deals with that
		jmp .unknownSeqError	;if not a backslash, we know its not a number or letter, so it's an error
	.makeSlash:
		pop ebx		;if it's a slash, get ebx, put the ascii value for backslash in it, then push it back on the stack
		mov bh, 92
		push ebx
		jmp .done


;;; else{
	.unknownSeqError:
	;; print the error for unknown sequence
		mov edi, escapeSeqStr
		mov [edi], bh
		mov eax,[escapeSeqLen]
		inc eax
	;; add \n to end of string to terminate it
		add edi, 1
		mov bh, 10
		mov [edi], bh
		inc eax
		mov [escapeSeqLen], eax
	;; print out the message
		mov eax, SYSCALL_WRITE
		mov ebx, STDOUT
		mov ecx, errUnknown
		mov edx, lenUnknown
	;; print out escape string
		mov eax, SYSCALL_WRITE
		mov ebx, STDOUT
		mov ecx, escapeSeqStr
		mov edx, [escapeSeqLen]
		int 80H

	;; we are now finished
		jmp .done
	
	.octalOverflowError:
		mov edi, escapeSeqStr
		mov eax, [escapeSeqLen]
	;; add \n to end of string to terminate it
		add edi, 1
		mov bh, 10
		mov [edi], bh
		inc eax
		mov [escapeSeqLen], eax
	;;;  print out the message for overflow
		mov eax, SYSCALL_WRITE
		mov ebx, STDOUT
		mov ecx, errOverflow
		mov edx, lenOverflow
	;; print out escape string
		mov eax, SYSCALL_WRITE
		mov ebx, STDOUT
		mov ecx, escapeSeqStr
		mov edx, 4
		int 80H
		jmp .done
	.done:
		pop ebx
		pop edi
		pop ecx
		pop eax
		pop edx

		ret
	
_end:
;;; ; print the original string message
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, msg2
	        mov edx, len2
	        int 80H

;;; ; print the original string
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, buf
	        mov edx, [readlen]
	        int 80H

;;; ; print the converted string
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, msg3
	        mov edx, len3
	        int 80H

;;; ; print the converted string
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, newStr
	        mov edx, [readlen]
	        int 80H

;;; ; call sys_exit to finish things off
	        mov eax, SYSCALL_EXIT ;sys_exit syscall
	        mov ebx, 0	      ;no error
	        int 80H		      ;kernel interrupt
	

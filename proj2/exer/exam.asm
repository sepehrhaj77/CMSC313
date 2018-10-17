                %define STDIN 0
	                %define STDOUT 1
	                %define STDERR 2
	                %define SYSCALL_EXIT  1
	                %define SYSCALL_READ  3
	                %define SYSCALL_WRITE 4
	                %define BUFLEN 256

	        [SECTION .data]
;;; ; ; ; Here we declare initialized data. For example: messages, prompts,
;;; ; ; ; and numbers that we know in advance
msg1:	   db "Enter String: "	;user prompt
len1:	   equ $-msg1		;length of first message

orig:	   db "Original: "	;message to display original string
lenOrig:	equ $-orig	;length of second message

conv:	   db "Convert: "	;message to display converted string
lenConv:	equ $-conv	;length of thirds message

letterTable:	    db 'a', 'b', 't', 'n', 'v', 'f', 'r'
decimalTable:	   db 7, 8, 9, 10, 11, 12, 13, 92
octalTable:	     db 007, 010, 011, 012, 013, 014, 015, 134

errUnknown:	     db "Error: unknown escape sequence \" ;error message if capital letter
lenUnknown:	     equ $-errUnknown			   ;length of error message

errOverflow:	    db "Error: octal value overflow in \" ;error message if octal overflow
lenOverflow:	    equ $-errOverflow			  ;length of error message

	        [SECTION .bss]
;;; ; ; ; Here we declare uninitialized data. We're reserving space (and
;;; ; ; ; potentially associating names with that space) that our code
;;; ; ; ; will use as it executes. Think of these as "global variables"

buf:	                    resb BUFLEN	; buffer for read
newStr:	                 resb BUFLEN	; new output we're going to have
readlen:	                resb 4  ; storage for the length of string we read

escapeSeqStr:	           resb BUFLEN ;to hold the error message of what we want to manipulate
escapeSeqLen:	           resb 4      ;length of error string

	        [SECTION .text]

	        global _start   ; make start global so ld can find it

_start:				; the program actually starts here
;;; ; ;  prompt for user input
	mov eax, SYSCALL_WRITE
	mov ebx, STDOUT
	mov ecx, msg1
        mov edx, len1
	int 80H

;;; ; ;  read user input
	mov eax, SYSCALL_READ
	mov ebx, STDIN
	mov ecx, buf
	mov edx, BUFLEN
	sub edx, 1
	int 80H

;;; ; ;  remember how many characters we read
	mov [readlen], eax

;;; ; ; ;  Tell user what they entered
	mov eax, SYSCALL_WRITE
	mov ebx, STDOUT
	mov ecx, orig
	mov edx, lenOrig
	int 80H

	mov eax, SYSCALL_WRITE
	mov ebx, STDOUT
	mov ecx, bufOrig
	mov edx, BUFLEN
	int 80H
	mov esi, buf
	mov edi, newstr

	.loop:
		cmp eax, 0
	        je .done

;;; ; ;  grab the next letter
	        mov bh, [esi]

;;; ; only transforms values that are between 'a' and 'z'
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
_end:
;;; ; print the original string message

;;; ; call sys_exit to finish things off
	        mov eax, SYSCALL_EXIT ;sys_exit syscall
	        mov ebx, 0	      ;no error
	        int 80H		      ;kernel interrupt

handle_ESC:
	ret
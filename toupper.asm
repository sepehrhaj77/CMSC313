	%define STDIN 0
	%define STDOUT 1
	%define STDERR 2
	%define SYSCALL_EXIT  1
	%define SYSCALL_READ  3
	%define SYSCALL_WRITE 4
	%define BUFLEN 256

	[SECTION .data]
;;; ; Here we declare initialized data. For example: messages, prompts,
;;; ; and numbers that we know in advance

msg1:	   	db "Text to be analyzed: "	; user prompt
len1:	   	equ $-msg1		; length of first message

msg2:	   	db "You entered: " ; message to tell user what string they entered
len2:	   	equ $-msg2		  ; length of second message

msg3:	   	db "There were:  " ; message to tell user how many of each type of character there is
len3:	   	equ $-msg3

msg4:		db " alphabetic characters."
len4:		equ $-msg4

msg5:		db " numeric characters."
len5:		equ $-msg5
	
msg6:		db " other characters."
len6:		equ $-msg6

numAlpha:	dw 0		;int to keep track of the number of alphabetic characters, initialized to 0
numNumeric:	dw 0		;variable to keep track of the number of numeric characters, initialized to 0
numOther:	dw 0		;variable to keep traack of the number of other characters, initialized to 0

	[SECTION .bss]
;;; ; Here we declare uninitialized data. We're reserving space (and
;;; ; potentially associating names with that space) that our code
;;; ; will use as it executes. Think of these as "global variables"

buf:	 	resb BUFLEN		; buffer for read
newstr:		resb BUFLEN
readlen:	resb 4		; storage for the length of string we read

	[SECTION .text]

	global _start		; make start global so ld can find it

_start:				; the program actually starts here
;;;  prompt for user input
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, msg1
	        mov edx, len1
	        int 80H

;;;  read user input
	        mov eax, SYSCALL_READ
	        mov ebx, STDIN
	        mov ecx, buf
	        mov edx, BUFLEN
	        int 80H

;;;  remember how many characters we read
	        mov [readlen], eax

;;;  loop over all characters
	        mov esi, buf
	        mov edi, newstr

	.loop:
	        cmp eax, 0
	        je .done

;;;  grab the next letter
	        mov bh, [esi]

;;;  only transform values that are between 'a' and 'z'
	        cmp bh, 'a'
	        jl .lettercomplete
	        cmp bh, 'z'
	        jg .lettercomplete

;;; long list of checking statements to see which type of char it is
		cmp bh, '/'	;
		jle .otherChar
		cmp bh, '9'
		jle .numChar
		cmp bh, '@'
		jle .otherChar
		cmp bh, 'Z'
		jle .alphaChar
		cmp bh, 'a'
		jl .otherChar
		cmp bh, 'z'
		jle .alphaChar
		jmp .otherChar 	

;;;  use the offset between lowercase letters and uppercase letters
;;;  in the ASCII table to shift the letter to uppercase
	        add bh, ('A' - 'a')

	.lettercomplete:
;;;  store the letter and go on to the next one
	        mov [edi], bh
	        add esi, 1
	        add edi, 1
	        sub eax, 1
	        jmp .loop

	.done:
;;;  print the original string message
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, msg2
	        mov edx, len2
	        int 80H

;;;  print the original string
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, buf
	        mov edx, [readlen]
	        int 80H

;;;  print the converted string message
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, msg3
	        mov edx, len3
	        int 80H

;;;  print the converted string
	        mov eax, SYSCALL_WRITE
	        mov ebx, STDOUT
	        mov ecx, newstr
	        mov edx, [readlen]
	        int 80H

;;;  and we're done!
	        jmp .end

	.end:
;;;  call sys_exit to finish things off
	        mov eax, SYSCALL_EXIT ; sys_exit syscall
	        mov ebx, 0	      ; no error
	        int 80H		      ; kernel interrupt
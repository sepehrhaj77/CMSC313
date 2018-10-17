;;; ; Sepehr Hajbarat
;;; ; 9/25/17
;;; ; CMSC 313: Dr. Kraya
;;; ; Project 1: counting characters

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

msg1:	   db "Text to be analyzed: " ; user prompt
len1:	   equ $-msg1		      ; length of first message

msg2:	   db "There were "	;prompt to tell user how many of each type of character there is
len2:	   equ $-msg2		;length of second message

msg3:	   db " alphabetic characters. " ; prompt to tell user how many alphabetic characters
len3:	   equ $-msg3				    ; length of third message

msg4:	   db " numeric characters. " ; prompt to tell user how many numeric characters
len4:	   equ $-msg4				 ; length of fourth message

msg5:	   db " other characters." ; prompt to tell user how many other characters
len5:	   equ $-msg5              ;length of fifth message

msg6:	   db "You entered: "	;prompt to tell user what they entered
len6:	   equ $-msg6		;length of sixth message
	
alphaNum:       dw 30h  		; storage for the number of alphabetic characters, these three will start at 30 in hex because that equates to the int 0 in the ASCII table
numNumeric:  	dw 30h   	       	; storage for the number of numeric characters
otherNum:	dw 30h			; storage for the number of other characters


	[SECTION .bss]
;;; ; ; Here we declare uninitialized data. We're reserving space (and
;;; ; ; potentially associating names with that space) that our code
;;; ; ; will use as it executes. Think of these as "global variables"
buf:	     resb BUFLEN	; buffer for read
readlen:     resb 4	; storage fot the length of string we read

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
	                int 80H

;;; ;  remember how many characters we read
	                mov [readlen], eax

;;; ;  Tell user what they entered
			mov eax, SYSCALL_WRITE	
			mov ebx, STDOUT
			mov ecx, msg6
			mov edx, len6
			int 80H

			mov eax, SYSCALL_WRITE
			mov ebx, STDOUT
			mov ecx, buf
			mov edx, BUFLEN
			int 80H
	
	
;;; ;  loop over all characters
	                mov esi, buf

;;; ;  store counter variables
	                mov bp, [alphaNum]
	                mov cx, [numNumeric]
	                mov dx, [otherNum]

.loop:
	                cmp eax, 0
	                je .done

;;; ;  grab the next letter
	                mov bh, [esi]

;;; ;  algorithm to decide which type of character it is
	                cmp bh, '/'
	                jle .otherChar
	                cmp bh, '{'
	                jge .otherChar
	                cmp bh, '9'
	                jle .numChar
	                cmp bh, '@'
	                jle .otherChar
	                cmp bh, 'Z'
	                jle .alphaChar
	                cmp bh, 'a'
	                jl .otherChar
	                jmp .alphaChar

	        .alphaChar:
	                add bp, 1
	                jmp .lettercomplete

	        .numChar:
	                add cx, 1
	                jmp .lettercomplete
	        .otherChar:
	                add dx, 1
	                jmp .lettercomplete

	        .lettercomplete:
;;; ;  store the letter and go on to the next one
	                add esi, 1
	                sub eax, 1
	                jmp .loop

	        .done:

	                mov [alphaNum], bp
	                mov [numNumeric], cx
	                mov [otherNum], dx
;;; ;  print "There were "
	                mov eax, SYSCALL_WRITE
	                mov ebx, STDOUT
	                mov ecx, msg2
	                mov edx, len2
	                int 80H

;;; ;  print number of alphabetic characters
	                mov eax, SYSCALL_WRITE
	                mov ebx, STDOUT
	                mov ecx, alphaNum
	                mov edx, 1
	                int 80H

;;; ;  print " alphabetic characters. "
	                mov eax, SYSCALL_WRITE
	                mov ebx, STDOUT
	                mov ecx, msg3
	                mov edx, len3
	                int 80H

;;; ; ;  print "There were "
			mov eax, SYSCALL_WRITE
			mov ebx, STDOUT
			mov ecx, msg2
			mov edx, len2
			int 80H

;;; ; ;  print number of numeric characters
			mov eax, SYSCALL_WRITE
			mov ebx, STDOUT
			mov ecx, numNumeric
			mov edx, 1
			int 80H
	
;;; ;  print " numeric characters. "
	                mov eax, SYSCALL_WRITE
	                mov ebx, STDOUT
	                mov ecx, msg4
	                mov edx, len4
	                int 80H

;;; ; ; ;  print "There were "
			mov eax, SYSCALL_WRITE
			mov ebx, STDOUT
			mov ecx, msg2
			mov edx, len2
			int 80H
	
;;; ; print number of other characters
	                mov eax, SYSCALL_WRITE
	                mov ebx, STDOUT
	                mov ecx, otherNum
	                mov edx, 1
	                int 80H

;;; ; print " other characters."
	                mov eax, SYSCALL_WRITE
	                mov ebx, STDOUT
	                mov ecx, msg5
	                mov edx, len5
	                int 80H

;;; ;  and we're done!
	                jmp .end

	        .end:
;;; ;  call sys_exit to finish things off
	                mov eax, SYSCALL_EXIT ; sys_exit syscall
	                mov ebx, 0            ; no error
	                int 80H               ; kernel interrupt
	
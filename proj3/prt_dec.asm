;;  File: prt_dec.asm
;;  Sepehr Hajbarat
;;  implementation of the prt_dec subroutine that prints out a decimal number to the console
;;  
%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4

	SECTION .data
msg:	db "Hello World"
len	equ $-msg

	SECTION .bss
newstr:	resb 256
revstr:	resb 256
	SECTION .text
	global prt_dec		;make subroutine global so other files can access

prt_dec:
;;; pushing the registers
	push eax		
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	mov edi, newstr		;put the reserved space for the new string in edi pointer

	add esp, 28		;go up stack back to the parameter passed
	mov eax, [esp]		;store the parameter in eax
        mov ebx, 10 		;the number with which eax will be divided by
	mov ecx, 1		;counter for reversing the number
	
	cmp eax, 0		;see if the passed value is 0
	je .setZero
	
	.loop:
		cmp eax, 0		;see if the quotient is now 0, which would mean we are done 
		je .startReverse
		mov edx, 0		;clear the edx register for division
		div ebx

		add edx, 48d		;convert actual decimal number to ascii value for that same number
		mov [edi], edx
		add edi, 1		;move the edi pointer forward 1 byte to go to the next stored value
		inc ecx
		jmp .loop

	.startReverse:
		mov edx, ecx		;the counter stores the length of the string, so for printing we want that in edx
		mov esi, revstr		;make esi point to the string in which we will store the reversed (which will be correct order) string

	.reverseLoop:
		mov al, [edi]		;put the current incorrect string character into al
		mov [esi], al
		dec edi
		dec ecx
		inc esi

		cmp ecx,0		;ecx holds the length of the number, if its 0 then we are done
		je .done
		jmp .reverseLoop 	;start again if there are still digits left
	
	.setZero:
		mov edi, revstr		;put the string to be printed in edi
		add eax, 48		;since there's a 0 in eax, add 48 to make it the ascii '0'
		mov [edi], eax		;put the ascii 0 in the revstr to be printed
	
;;; print out the reversed string
	.done:
		xor 	ecx, ecx
		mov     eax, SYSCALL_WRITE ; write message
		mov     ebx, STDOUT
		mov     ecx, revstr	
		int     080h

	;; go back to the where we started in the stack
		sub esp, 28
	;; pop all the registers back in
		pop esi
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret


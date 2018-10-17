; File: mytest3.asm
;
; main program that exercises the prt_dec subroutine
;

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4


        SECTION .data                   ; initialized data section

lf:   	db  10            		; just a linefeed 

msg1:	db " plus "	
len1 equ $ - msg1

msg2: 	db " minus "
len2 equ $ - msg2

msg3:	db " equals "
len3 equ $ - msg3

        SECTION .text                   ; Code section.
        global  _start                  ; let loader see entry point
	extern	prt_dec

_start: 
	mov	ebx, 21
	mov	edx, 678123
	mov	edi, 560234598
	mov	ebp, 468213540 


	push	dword 0xFF
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	dword 0xF46ABCFF
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	5999875
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	ebx
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	edx
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	edi
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	ebp
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	9
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg1
        mov     edx, len1
        int     080h
	
	push	10
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg3
        mov     edx, len3
        int     080h

	push	21
	call	prt_dec
	add	esp, 4
	call	prt_lf

	push	420
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg2
        mov     edx, len2
        int     080h
	
	push	69
	call	prt_dec
	add	esp, 4

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg3
        mov     edx, len3
        int     080h

	push	1
	call	prt_dec
	add	esp, 4
	call	prt_lf


        ; final exit
        ;
exit:   mov     EAX, SYSCALL_EXIT       ; exit function
        mov     EBX, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over



	; A subroutine to print a LF, all registers are preserved
prt_lf:
	push	eax
	push	ebx
	push	ecx
	push	edx

        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, lf
        mov     edx, 1			; LF is a single character
        int     080h

	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	ret


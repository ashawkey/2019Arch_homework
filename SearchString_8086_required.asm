data segment
    buffer db 100
           db 0
           db 100 dup(?)
    success_string db 'Last position: $'
    fail_string db 'Sorry!$'
    newline db 0ah,0dh,'$'
    information db 'NAME: Tang Jiaxinag',0ah,0dh,'ID: 1600012210','$'
data ends

stack_str segment stack
    db 40 dup(0)
    stack_top label word
stack_str ends

code segment
    assume ds:data, cs:code, ss:stack_str
start:
    ; init data
    mov ax, data
    mov ds, ax
    ; init stack
    mov ax, stack_str
    mov ss, ax
    mov sp, offset stack_top
    ; string input
    mov dx, offset buffer
    mov ah, 0ah
    int 21h
read:
    ; character input
    mov ah, 07h
    int 21h
    ; output
    mov dl, al
    mov ah, 02h
    int 21h
    ; newline
    mov dx, offset newline
    mov ah, 09h
    int 21h
    ; exit
    cmp al, 1bh ; 1bh = ESC
    je exit 
    ; loop variable
    mov cx, 0 ; cl is count, ch is location
    mov dl, 0 ; dl is loop variable
loop1:
    ; loop condition
    mov bx, offset buffer + 1 ; length of string
    mov dh, [bx]
    cmp dl, dh
    je finish
    ; test 
    mov bx, offset buffer + 2 ; start of string content
    mov dh, 0
    add bx, dx
    inc dl
    mov ah, [bx] ; ah is character at bx
    cmp al, ah
    je find
    jmp far ptr loop1
find:
    inc cl
    mov ch, dl
    jmp far ptr loop1
exit:
    mov dx, offset information
    mov ah, 09h
    int 21h
    mov ah, 4ch
    int 21h
finish:
    cmp cl, 0
    je fail
    jmp far ptr success
success:
    ; print total hits, only support one-digit number!
    mov al, cl
    mov ah, 0
    call PRINTAX
    ; newline
    mov dx, offset newline
    mov ah, 09h
    int 21h
    ; print success
    mov dx, offset success_string
    mov ah, 09h
    int 21h
    ; print last position
    mov al, ch
    mov ah, 0
    call PRINTAX
    ; print newline
    jmp far ptr endl
fail:
    mov dx, offset fail_string
    mov ah, 09h
    int 21h
    jmp far ptr endl
endl:
    mov dx, offset newline
    mov ah, 09h
    int 21h
    jmp far ptr read

; code to print integer in ax (base_10)
printax proc
	mov bx, 10 ; base = 10
	or ax, ax ; if ax = 0
	jz _0_
loop_p:
	xor dx, dx ; set zero
	mov bx, 10 
	div bx ; ax = ax // bx, dx = ax % bx
	mov bx, ax
	or bx, dx
	jz _E_ ; end
	push dx
	call loop_p
pop dx
add dl, '0'
jmp _1_
_0_: mov dl, '0'
_1_: mov ah, 2
int 21h
_E_: ret
printax endp

code ends
end start
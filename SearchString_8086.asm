data segment
	; length less than 10 (due to integers > 9 needs special boring print techs...)
    buffer db 10
           db 0
           db 10 dup(?)
    success_string db 'Last position: $'
    fail_string db 'Sorry!$'
    newline db 0ah,0dh,'$'
    information db 'NAME: xxxxxxxx',0ah,0dh,'ID: xxxxxxxx','$'
data ends

code segment
    assume ds:data, cs:code
start:
    mov ax, data
    mov ds, ax
    ; string input
    mov dx, offset buffer
    mov ah, 0ah
    int 21h
read:
    ; character input
    mov ah, 07h
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
    mov dl, cl
    add dl, 30h ; add shift from 0
    mov ah, 02h
    int 21h
    ; newline
    mov dx, offset newline
    mov ah, 09h
    int 21h
    ; print success
    mov dx, offset success_string
    mov ah, 09h
    int 21h
    ; print last position
    mov dl, ch
    add dl, 30h
    mov ah, 02h
    int 21h
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

code ends
end start
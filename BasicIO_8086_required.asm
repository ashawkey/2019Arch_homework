data segment
    numbers db 'Zero $One $Two $Three $Four $Five $Six $Seven $Eight $Nine $'
    offset_numbers dw 0,6,11,16,23,29,35,40,47,54
    strings_upper db 'Apple $Banana $Cake $Dessert $Egg $Fig $Grape $Honey $Icecream $Juice $Kiwi $Lemon $Mango $Nut $Orange $Peach $Quarenden $Radish $Strawberry $Tangerine $Udon $Veal $Watermelon $Xacuti $Yam $Zucchini $'
    strings_lower db 'apple $banana $cake $dessert $egg $fig $grape $honey $icecream $juice $kiwi $lemon $mango $nut $orange $peach $quarenden $radish $strawberry $tangerine $udon $veal $watermelon $xacuti $yam $zucchini $'
    offset_strings dw 0,7,15,21,30,35,40,47,54,64,71,77,84,91,96,104,111,122,130,142,153,159,165,177,185,190
    spark_ db 'Spark $'
    at_ db 'At $'
    and_ db 'And $'
    else_ db '? $'
    information db 0ah,0dh,'NAME: Tang Jiaxinag',0ah,0dh,'ID: 1600012210','$'
data ends

stack_str segment stack
    db 40 dup(0)
    stack_top label word
stack_str ends

code segment
    assume ds:data, cs:code
start:
    mov ax, data
    mov ds, ax
    mov ax, stack_str
    mov ss, ax
    mov sp, offset stack_top
input:
    mov ah, 07h
    int 21h
    ; exit
    cmp al, 1bh ; 1bh = ESC
    je exit ; jump if equal
    ; @
    cmp al, 40h
    je print_at
    ; *
    cmp al, 2ah
    je print_spark
    ; &
    cmp al, 26h
    je print_and
    ; else
    cmp al, 2fh ; 30h = 0
    jle print_else
    ; numbers
    cmp al, 39h ; 39h = 9, set ZF to 1 if equals.
    jle print_number ; jump if equal or less
    ; else
    cmp al, 40h
    jle print_else
    ; Alpha
    cmp al, 5ah
    jle print_strings_upper
    ; else
    cmp al, 60h
    jle print_else
    ; alpha
    cmp al, 7ah
    jle print_strings_lower
    ; else
    jg print_else
return:
    mov cx, 02h
    loop input

exit:
    mov dx, offset information
    mov ah, 09h
    int 21h
    mov ah, 4ch
    int 21h

print_and:
    mov dx, offset and_
    jmp far ptr print

print_at:
    mov dx, offset at_
    jmp far ptr print

print_spark:
    mov dx, offset spark_
    jmp far ptr print

print_else:
    mov dx, offset else_
    jmp far ptr print

print_number:
    mov ah, 0
    sub al, 30h
    sal al, 1
    mov bx, offset offset_numbers
    add bx, ax
    mov dx, offset numbers
    add dx, [bx]
    jmp far ptr print

print_strings_upper:
    mov ah, 0
    sub al, 41h
    sal al, 1
    mov bx, offset offset_strings
    add bx, ax
    mov dx, offset strings_upper
    add dx, [bx]
    jmp far ptr print

print_strings_lower:
    mov ah, 0
    sub ax, 61h
    sal al, 1
    mov bx, offset offset_strings
    add bx, ax
    mov dx, offset strings_lower
    add dx, [bx]
    jmp far ptr print

print:
    mov ah, 09h
    int 21h
    jmp far ptr return

code ends
end start
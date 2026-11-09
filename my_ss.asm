startScreen:

pusha
push es
mov ax,0xb800
mov es,ax


mov di , 0
mov cx,2000
mov ax,0x08B0
cld
rep stosw
; lines, big 007 and the banner (everything in data_table)
print_logo:
mov si , data_table
call draw_shapes

; title in gold, row 15
print_title:
mov si , title_text
mov di , 2448               
mov cx , 32                 
mov ah , 0x0E               
call print_text

; "Press Enter to Play" in white
print_enter:
mov si , enter_text
mov di , 3580               
mov cx , 19                 
mov ah , 0x0F               
call print_text

pop es
popa
ret

print_text:
    push ax
    push cx
    push si
    push di
letter:
    lodsb                       ; al = next letter
    stosw                       ; letter + colour on the screen
    loop letter
    pop di
    pop si
    pop cx
    pop ax
    ret
    
draw_shapes:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    cld

next_shape:
    mov al, [si]                ; row
    cmp al, 0xFF                ; 0xFF = end of table
    je done
    mov bl, 80
    mul bl                      ; ax = row * 80
    mov bl, [si+1]              ; column
    xor bh, bh
    add ax, bx
    shl ax, 1                  
    mov di, ax                  ; di = where the shape starts

    mov dl, [si+2]              ; dl = how many rows tall
next_row:
    mov cl, [si+3]              ; cx = how many cells wide
    xor ch, ch
    mov al, [si+4]              ; character
    mov ah, [si+5]              ; colour
    push di
    rep stosw                   ; draw one row of the shape
    pop di
    add di, 160                 ; go to the next screen row
    dec dl
    jnz next_row

    add si, 6                   ; next entry in the table
    jmp next_shape

done:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret


title_text: db 'F  I  R  S  T      L  I  G  H  T'
enter_text: db 'Press Enter to Play'


;  data_table : row, column, height, width, character, colour
;  colour = background * 16 + text colour
;  0x0E gold   0x0F white   0x08 dark grey   0x01 dark blue

data_table:

    ; shadow of 0 (first)
    db  5, 17,  2, 14, 0xDB, 0x01
    db 12, 17,  2, 14, 0xDB, 0x01
    db  7, 17,  5,  4, 0xDB, 0x01
    db  7, 27,  5,  4, 0xDB, 0x01
    ; shadow of 0 (second)
    db  5, 35,  2, 14, 0xDB, 0x01
    db 12, 35,  2, 14, 0xDB, 0x01
    db  7, 35,  5,  4, 0xDB, 0x01
    db  7, 45,  5,  4, 0xDB, 0x01
    ; shadow of 7
    db  5, 53,  2, 14, 0xDB, 0x01
    db  7, 63,  2,  4, 0xDB, 0x01
    db  9, 61,  2,  4, 0xDB, 0x01
    db 11, 59,  3,  4, 0xDB, 0x01

    
    ; 0 (first)
    db  4, 15,  2, 14, 0xDB, 0x0F       ; top bar
    db 11, 15,  2, 14, 0xDB, 0x0F       ; bottom bar
    db  6, 15,  5,  4, 0xDB, 0x0F       ; left side
    db  6, 25,  5,  4, 0xDB, 0x0F       ; right side
    ; 0 (second)
    db  4, 33,  2, 14, 0xDB, 0x0F       ; top bar
    db 11, 33,  2, 14, 0xDB, 0x0F       ; bottom bar
    db  6, 33,  5,  4, 0xDB, 0x0F       ; left side
    db  6, 43,  5,  4, 0xDB, 0x0F       ; right side
    ; 7
    db  4, 51,  2, 14, 0xDB, 0x0F       ; top bar
    db  6, 61,  2,  4, 0xDB, 0x0F       ; step 1
    db  8, 59,  2,  4, 0xDB, 0x0F       ; step 2
    db 10, 57,  3,  4, 0xDB, 0x0F       ; step 3 (tail)

   
    db 15, 19,  1,  1, 0x04, 0x0E       ; gold diamond (left)
    db 15, 60,  1,  1, 0x04, 0x0E       ; gold diamond (right)
   

    db 21,  0,  1, 80, 0xC4, 0x0E       ; gold line above
    db 22,  0,  1, 80, 0x20, 0x00       ; black strip
    db 23,  0,  1, 80, 0xC4, 0x0E       ; gold line under
    db 22, 27,  1,  1, 0x10, 0x0E       ; arrow  >
    db 22, 52,  1,  1, 0x11, 0x0E       ; arrow  <

    db 0xFF
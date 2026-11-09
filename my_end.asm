; ============================================================
;  end25.asm  -  the end screen (25 rows x 80 columns)
;  needs draw_shapes and print_text from start25.asm
; ============================================================

endScreen:

push ax
push bx
push cx
push dx
push si
push di
push es
mov ax,0xb800
mov es,ax

; background : dark grey dots on black
mov di , 0
mov cx,2000
mov ax,0x08B0
cld
rep stosw

; gold lines and the black banner
mov si , end_table
call draw_shapes

; ---- GAME (shadow first, then the real letters on top) ----
mov si , word_game
mov dh , 4
mov dl , 18
mov bl , 0x04               ; dark red shadow
call print_big

mov si , word_game
mov dh , 3
mov dl , 17
mov bl , 0x0F               ; white
call print_big

; ---- OVER ----
mov si , word_over
mov dh , 11
mov dl , 18
mov bl , 0x04
call print_big

mov si , word_over
mov dh , 10
mov dl , 17
mov bl , 0x0F
call print_big

; ---- "M I S S I O N   F A I L E D" (the only red text), row 17 ----
mov si , mission_text
mov di , 2772               ; row 17, column 26
mov cx , 27
mov ah , 0x0C
call print_text

; ---- FINAL SCORE: gold label, white value, row 19 ----
mov si , final_label
mov di , 3102               ; row 19, column 31
mov cx , 12
mov ah , 0x0E
call print_text

mov si , final_value
mov di , 3128               ; row 19, column 44
mov cx , 4
mov ah , 0x0F
call print_text

; ---- keys, row 22 ----
mov si , keys_text
mov di , 3566               ; row 22, column 23
mov cx , 33
mov ah , 0x0F
call print_text

pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret


word_game:    db 'GAME', 0
word_over:    db 'OVER', 0
mission_text: db 'M I S S I O N   F A I L E D'
final_label:  db 'FINAL SCORE:'
final_value:  db '0000'
keys_text:    db 'ENTER = Play Again     ESC = Exit'

; row, column, height, width, character, colour
end_table:
    

    db 21,  0,  1, 80, 0xC4, 0x0E       ; gold line above the text
    db 22,  0,  1, 80, 0x20, 0x00       ; black strip
    db 23,  0,  1, 80, 0xC4, 0x0E       ; gold line under the text
    db 22, 20,  1,  1, 0x10, 0x0E       ; gold arrow  >
    db 22, 58,  1,  1, 0x11, 0x0E       ; gold arrow  <

    db 0xFF


; ------------------------------------------------------------
;  print_big : big block letters, each dot = 2 cells wide, 1 tall
;  (in 25 rows a cell is twice as tall as wide, so dots look square)
;  in: si = text (ends with 0), dh = row, dl = column, bl = colour
;  every letter = 10 cells wide, 5 cells tall (+2 gap)
; ------------------------------------------------------------
print_big:
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

.next_letter:
    lodsb                       ; al = letter
    cmp al, 0
    je .done
    push si                     ; keep our place in the text

    mov si, big_font            ; look for the letter in the font
.find:
    cmp byte [si], 0
    je .letter_done             ; not in font = leave a gap
    cmp [si], al
    je .found
    add si, 6                   ; each font entry is 6 bytes
    jmp .find

.found:
    inc si                      ; si = first of the 5 row numbers
    mov al, dh                  ; di = screen place of this letter
    mov cl, 80
    mul cl
    mov cl, dl
    xor ch, ch
    add ax, cx
    shl ax, 1
    mov di, ax

    mov bh, 5                   ; 5 rows in every letter
.pixel_row:
    mov ch, [si]                ; the dots of this row (5 bits)
    inc si
    mov cl, 5                   ; 5 dots in a row
    push di
.pixel:
    test ch, 0x10               ; is the left dot on?
    jz .empty
    mov al, 0xDB                ; draw a block 2 cells wide
    mov ah, bl
    mov [es:di], ax
    mov [es:di+2], ax
.empty:
    add di, 4                   ; next dot = 2 cells to the right
    shl ch, 1
    dec cl
    jnz .pixel
    pop di
    add di, 160                 ; next dot row = 1 screen row down
    dec bh
    jnz .pixel_row

.letter_done:
    pop si
    add dl, 12                  ; next letter (10 wide + 2 gap)
    jmp .next_letter

.done:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; letter, then 5 rows  (1 = block, 0 = empty)
big_font:
    db 'G', 0x0F, 0x10, 0x13, 0x11, 0x0E
    db 'A', 0x0E, 0x11, 0x1F, 0x11, 0x11
    db 'M', 0x11, 0x1B, 0x15, 0x11, 0x11
    db 'E', 0x1F, 0x10, 0x1E, 0x10, 0x1F
    db 'O', 0x0E, 0x11, 0x11, 0x11, 0x0E
    db 'V', 0x11, 0x11, 0x11, 0x0A, 0x04
    db 'R', 0x1E, 0x11, 0x1E, 0x14, 0x12
    db 0                        ; end of font
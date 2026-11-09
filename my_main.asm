;25L-0583 MUHAMMAD UMAR IMRAN
;25L-0815 MUHAMMAD ABDULLAH MALIK 
gameScreen:

push ax
push cx
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

; sky, buildings, objects, briefcase (everything in game_table)
mov si , game_table
call draw_shapes


mov si , score_label
mov di , 166                ; row 1, column 3
mov cx , 6
mov ah , 0x0E
call print_text

mov si , score_value
mov di , 180               ; row 1, column 10
mov cx , 4
mov ah , 0x0F
call print_text

mov si , time_label
mov di , 228               ; row 1, column 34
mov cx , 5
mov ah , 0x0E
call print_text

mov si , time_value
mov di , 240               ; row 1, column 40
mov cx , 5
mov ah , 0x0F
call print_text

mov si , lives_label
mov di , 284               ; row 1, column 62
mov cx , 6
mov ah , 0x0E
call print_text

pop es
pop di
pop si
pop cx
pop ax
ret


score_label: db 'SCORE:'
score_value: db '0000'
time_label:  db 'TIME:'
time_value:  db '02:00'
lives_label: db 'LIVES:'

; ------------------------------------------------------------
;  game_table : row, column, height, width, character, colour
;  colour = background * 16 + text colour
; ------------------------------------------------------------
game_table:
    

    ; ---- top bar (black) with gold line ----
    db  0,  0,  3, 80, 0x20, 0x00       ; black bar
    db  3,  0,  1, 80, 0xC4, 0x0E       ; gold line
    
    db  0, 24,  3,  1, 0xB3, 0x08      
    db  0, 56,  3,  1, 0xB3, 0x08      
    db  1, 69,  1,  1, 0x03, 0x0C      
    db  1, 71,  1,  1, 0x03, 0x0C      
    db  1, 73,  1,  1, 0x03, 0x0C     
    ; gold coin
    db  7, 13,  1,  4, 0xDC, 0x0E
    db  8, 12,  1,  6, 0xDB, 0x0E
    db  9, 13,  1,  4, 0xDF, 0x0E
    db  8, 14,  1,  2, 0xDB, 0x08       ; coin centre
    ; diamond
    db 11, 32,  1,  2, 0xDC, 0x0B
    db 12, 30,  1,  6, 0xDB, 0x0B
    db 13, 32,  1,  2, 0xDF, 0x0B
    db 12, 31,  1,  1, 0xDB, 0x0F       ; shine
    ; bomb
    db  6, 49,  1,  4, 0xDC, 0x07
    db  7, 48,  1,  6, 0xDB, 0x07
    db  8, 49,  1,  4, 0xDF, 0x07
    db  7, 50,  1,  2, 0xDB, 0x04       ; red eye
    ; gold coin
    db 10, 63,  1,  4, 0xDC, 0x0E
    db 11, 62,  1,  6, 0xDB, 0x0E
    db 12, 63,  1,  4, 0xDF, 0x0E
    db 11, 64,  1,  2, 0xDB, 0x08       ; coin centre
 
    ;jamesbonda kay hath
    db 19,16,1,1,0xFE,0x0F
    db 19,20,1,1,0xFE,0x0F
    ; jamesbond body with a tie or some blood 
    db 18 , 17 , 1,3,0xFE,0x0F
    db 19 , 17 , 1,1,0xDB,0x0F
    db 19,18,1,1,0xDB,0x04
    db 19 ,19,1,1,0xDB,0x0F
    ;jamesbond legs
    db 20 , 17,1 ,1, 0xDB, 0x08
    db 20 , 18,1,1,0x20,0x08
    db 20 , 19 , 1, 1,0xDB,0x08
    ; bottom stage
    db 21 , 0 , 1 , 80 , 0xB0 , 0x07
    db 22, 0 , 3, 80 , 0xB0, 0x01
    db 0xFF
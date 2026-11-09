clrscr:
pusha
push es

mov ax,0xb800
mov es,ax

mov ax,0x0720 
mov cx,2000

cld
rep stosw

pop es
popa
ret
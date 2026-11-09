[org 0x0100]
jmp start

start:
call clrscr
call printer
mov ah , 0x00
int 0x16
mov ax,0x4c00
int 0x21

%include"my_print.asm"
%include"my_ss.asm"
%include"my_clr.asm"
%include"my_main.asm"
%include"my_end.asm"
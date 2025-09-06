;Write a subroutine to copy a given area on the screen at the center of the screen. The routine will be
;passed top, left, bottom, and right in that order through the stack. The parameters passed will always be
;within range the height will be odd and the width will be even so that it can be exactly centered.

[org 0x0100]
jmp start

clrscr:
push es
push ax
push cx
push di

mov ax, 0xb800
mov es, ax
xor di, di
mov ax, 0x0720
mov cx, 2000

cld
rep stosw

pop di
pop cx
pop ax
pop es
ret

movetomid:
push bp
mov bp, sp
push ax
push cx
push bx
push dx
push di
push es

mov dx, [bp+4]
mov bx, [bp+8]
sub dx, bx

mov ax, 0xb800
mov es, ax
mov al, 80
mul byte [bp+8]
add ax, [bp+10]
shl ax, 1
mov di, ax

row_by_row:
mov cx, [bp+6]       ;first print given area before moving it to centre
mov bx, [bp+10]
sub cx, bx
mov bx, cx
mov al, '*'
mov ah, 0x07

rep stosw
add di, 160
shl bx, 1
sub di, bx

dec dx
cmp dx, 0
jne row_by_row       ;done printing the given area

;call clrscr

mov bx, [bp+6]       
sub bx, [bp+10]
mov cx, 80
sub cx, bx
mov si, cx
shr si, 1       ;now si contains x pos from where printing should start for centre

mov bx, [bp+4]
sub bx, [bp+8]
mov cx, 25
sub cx, bx
mov dx, cx
shr dx, 1       ;y value for new position


mov bx, [bp+4]
sub bx, [bp+8]

mov al, 80
mul byte dl
add ax, si
shl ax, 1
mov di, ax

row_by_row1:
mov cx, [bp+6]       
sub cx, [bp+10]
mov dx, cx
mov al, '*'
mov ah, 0x07

rep stosw
add di, 160
shl dx, 1
sub di, dx

dec bx
cmp bx, 0
jne row_by_row1


popa
ret 8

start:
call clrscr

mov ax, 4    ;x top
push ax
mov ax, 4    ;y left
push ax
mov ax, 14    ;x bottom
push ax
mov ax, 9     ;y right
push ax

call movetomid

mov ax, 0x4c00
int 0x21
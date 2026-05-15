BITS 16
ORG 0x7C00

start:
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x00
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    mov ah, 0x01
    mov cx, 0x2607
    int 0x10

    mov byte [sx], 40
    mov byte [sy], 12
    mov byte [sdx], 1
    mov byte [sdy], 0
    call neues_futter

loop:
    call zeichne

    mov cx, 0x0008
    mov dx, 0x0000
    mov ah, 0x86
    int 0x15

    mov ah, 0x01
    int 0x16
    jz move

    mov ah, 0x00
    int 0x16
    cmp ah, 0x48
    jne .n1
    mov byte [sdx], 0
    mov byte [sdy], 0xFF
.n1:
    cmp ah, 0x50
    jne .n2
    mov byte [sdx], 0
    mov byte [sdy], 1
.n2:
    cmp ah, 0x4B
    jne .n3
    mov byte [sdx], 0xFF
    mov byte [sdy], 0
.n3:
    cmp ah, 0x4D
    jne move
    mov byte [sdx], 1
    mov byte [sdy], 0

move:
    mov al, [sx]
    add al, [sdx]
    mov [sx], al
    mov al, [sy]
    add al, [sdy]
    mov [sy], al

    cmp byte [sx], 79
    ja over
    cmp byte [sy], 24
    ja over

    mov al, [sx]
    cmp al, [fx]
    jne loop
    mov al, [sy]
    cmp al, [fy]
    jne loop
    inc byte [punkte]
    call neues_futter
    jmp loop

over:
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x4F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 12
    mov dl, 28
    int 0x10
    mov si, msg_over
.l:
    lodsb
    or al, al
    jz .d
    mov ah, 0x0E
    int 0x10
    jmp .l
.d:
    hlt

zeichne:
    mov ah, 0x02
    mov bh, 0x00
    mov dh, [sy]
    mov dl, [sx]
    int 0x10
    mov ah, 0x09
    mov al, 'O'
    mov bh, 0x00
    mov bl, 0x0A
    mov cx, 1
    int 0x10

    mov ah, 0x02
    mov bh, 0x00
    mov dh, [fy]
    mov dl, [fx]
    int 0x10
    mov ah, 0x09
    mov al, '*'
    mov bh, 0x00
    mov bl, 0x0C
    mov cx, 1
    int 0x10
    ret

neues_futter:
    in al, 0x40
    and al, 0x4F
    add al, 10
    mov [fx], al
    in al, 0x40
    and al, 0x17
    add al, 3
    mov [fy], al
    ret

sx      db 40
sy      db 12
sdx     db 1
sdy     db 0
fx      db 20
fy      db 8
punkte  db 0
msg_over db "GAME OVER! SassanidOS", 0

times 510-($-$$) db 0
dw 0xAA55

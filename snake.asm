BITS 16
ORG 0x7C00

; Variablen zuerst definieren
sx      db 40
sy      db 12
sdx     db 1
sdy     db 0
fx      db 20
fy      db 8
punkte  db 0

start:
    cli
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x00
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    mov ah, 0x01
    mov cx, 0x2607
    int 0x10

    call neues_futter

loop:
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
    jne n1
    cmp byte [sdy], 1
    je n1
    mov byte [sdx], 0
    mov byte [sdy], 0xFF
n1:
    cmp ah, 0x50
    jne n2
    cmp byte [sdy], 0xFF
    je n2
    mov byte [sdx], 0
    mov byte [sdy], 1
n2:
    cmp ah, 0x4B
    jne n3
    cmp byte [sdx], 1
    je n3
    mov byte [sdx], 0xFF
    mov byte [sdy], 0
n3:
    cmp ah, 0x4D
    jne move
    cmp byte [sdx], 0xFF
    je move
    mov byte [sdx], 1
    mov byte [sdy], 0

move:
    mov al, [sx]
    cmp al, [fx]
    jne kein_futter
    mov al, [sy]
    cmp al, [fy]
    jne kein_futter

    inc byte [punkte]
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
    mov al, [sx]
    add al, [sdx]
    mov [sx], al
    mov al, [sy]
    add al, [sdy]
    mov [sy], al
    call neues_futter
    jmp loop

kein_futter:
    mov ah, 0x02
    mov bh, 0x00
    mov dh, [sy]
    mov dl, [sx]
    int 0x10
    mov ah, 0x09
    mov al, ' '
    mov bh, 0x00
    mov bl, 0x00
    mov cx, 1
    int 0x10

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
    mov dl, 25
    int 0x10
    mov si, msg_over
over_loop:
    lodsb
    or al, al
    jz over_done
    mov ah, 0x0E
    int 0x10
    jmp over_loop
over_done:
    cli
    jmp $

neues_futter:
    in al, 0x40
    xor ah, ah
    mov bl, 79
    div bl
    mov [fx], ah
    in al, 0x40
    xor ah, ah
    mov bl, 24
    div bl
    mov [fy], ah
    ret

msg_over db "GAME OVER! SassanidOS", 0

times 510-($-$$) db 0
dw 0xAA55

BITS 16
ORG 0x7C00

start:
    ; Hintergrund blau, Text weiß
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x1F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    ; Cursor positionieren
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x0A
    mov dl, 0x0A
    int 0x10

    ; Text ausgeben
    mov si, msg
.loop:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    int 0x10
    jmp .loop
halt:
    hlt

msg db "SassanidOS wird gestartet...", 0

times 510-($-$$) db 0
dw 0xAA55

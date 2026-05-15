BITS 16
ORG 0x7C00

start:
    ; Hintergrund blau
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x1F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    ; Cursor positionieren
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x03
    mov dl, 0x08
    int 0x10

    ; Logo ausgeben
    mov si, logo
.loop1:
    lodsb
    or al, al
    jz done1
    mov ah, 0x0E
    int 0x10
    jmp .loop1
done1:

    ; Cursor für Text
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x08
    mov dl, 0x08
    int 0x10

    ; Text ausgeben
    mov si, msg
.loop2:
    lodsb
    or al, al
    jz load_kernel
    mov ah, 0x0E
    int 0x10
    jmp .loop2

load_kernel:
    ; Kernel von Disk laden
    mov ah, 0x02
    mov al, 0x05
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, 0x80
    mov bx, 0x1000
    mov es, bx
    mov bx, 0x0000
    int 0x13

    ; Zum Kernel springen
    jmp 0x1000:0x0000

logo db "  ____                              _     _  ___  ____  ", 13, 10
     db " / ___|  __ _  ___  ___  __ _ _ __ (_) __| |/ _ \/ ___| ", 13, 10
     db " \___ \ / _` |/ __|/ __|/ _` | '_ \| |/ _` | | | \___ \ ", 13, 10
     db "  ___) | (_| \__ \\__ \ (_| | | | | | (_| | |_| |___) |", 13, 10
     db " |____/ \__,_|___/___/\__,_|_| |_|_|\__,_|\___/|____/ ", 13, 10, 0

msg db "      Willkommen bei SassanidOS v0.1", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55

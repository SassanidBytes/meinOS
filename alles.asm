BITS 16
ORG 0x7C00

start:
    ; Bildschirm blau
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x1F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    ; Cursor Zeile 5
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x05
    mov dl, 0x00
    int 0x10

    ; Text ausgeben
    mov si, msg
.loop:
    lodsb
    or al, al
    jz warte
    mov ah, 0x0E
    int 0x10
    jmp .loop

warte:
    ; Taste warten
    mov ah, 0x00
    int 0x16
    
    ; Taste anzeigen
    mov ah, 0x0E
    int 0x10
    jmp warte

msg db "SassanidOS v0.1 - Tippe etwas!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55

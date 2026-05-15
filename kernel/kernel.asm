BITS 16
ORG 0x1000

start:
    ; Text direkt in Videospeicher
    mov ax, 0xB800
    mov es, ax
    
    ; "KERNEL GELADEN!" schreiben
    mov si, msg
    mov di, 0
.loop:
    lodsb
    or al, al
    jz done
    mov ah, 0x1F
    mov [es:di], ax
    add di, 2
    jmp .loop
done:
    hlt

msg db "KERNEL GELADEN! SassanidOS v0.1", 0

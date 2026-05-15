BITS 16
ORG 0x7C00

start:
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x1F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x00
    mov dl, 0x00
    int 0x10
    mov si, willkommen
    call print

prompt:
    mov si, prompt_str
    call print
    mov di, buf
    call readline
    mov si, buf
    mov di, cmd_hilfe
    call strcmp
    je do_hilfe
    mov si, buf
    mov di, cmd_info
    call strcmp
    je do_info
    mov si, buf
    mov di, cmd_clear
    call strcmp
    je do_clear
    mov si, unbekannt
    call print
    jmp prompt

do_hilfe:
    mov si, hilfe_text
    call print
    jmp prompt

do_info:
    mov si, info_text
    call print
    jmp prompt

do_clear:
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x1F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x00
    mov dl, 0x00
    int 0x10
    jmp prompt

print:
    lodsb
    or al, al
    jz .d
    mov ah, 0x0E
    int 0x10
    jmp print
.d: ret

readline:
    mov cx, 0
.l: mov ah, 0x00
    int 0x16
    cmp al, 13
    je .e
    cmp al, 8
    je .b
    mov ah, 0x0E
    int 0x10
    stosb
    inc cx
    jmp .l
.b: cmp cx, 0
    je .l
    dec di
    dec cx
    mov ah, 0x0E
    mov al, 8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10
    jmp .l
.e: mov byte [di], 0
    mov ah, 0x0E
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    ret

strcmp:
.l: mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .n
    or al, al
    jz .g
    inc si
    inc di
    jmp .l
.g: ret
.n: add al, 0
    ret

willkommen  db "SassanidOS v0.1 - 'hilfe' fuer Befehle",13,10,0
prompt_str  db "> ",0
unbekannt   db "Unbekannt!",13,10,0
hilfe_text  db "hilfe/info/clear",13,10,0
info_text   db "SassanidOS by David",13,10,0
cmd_hilfe   db "hilfe",0
cmd_info    db "info",0
cmd_clear   db "clear",0
buf times 32 db 0

times 510-($-$$) db 0
dw 0xAA55

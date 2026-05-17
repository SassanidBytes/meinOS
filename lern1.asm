org   0x7C00
bits 16


start:  
	

	mov ecx,          10
	


zueruck:


		dec ecx 
		cmp ecx, 0

		jne zueruck

		jmp $

times 510-($-$$) db 0

dw 0XAA55



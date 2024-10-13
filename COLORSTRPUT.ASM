    assume cs:code,ss:stack,ds:data

    stack segment

        db 128 dup (0)

    stack ends

    data segment

        db 128 dup (0)
        
    data ends

    code segment

    start:    mov ax,stack
              mov ss,ax
              mov sp,128
              
              mov ax,data
              mov ds,ax
              mov si,0

              mov dh,13
              mov dl,0

              call deal

              mov ax,4c00h
              int 21h

    deal:     push ax

    chard:    mov ax,0
              int 16h

              cmp al,20h
              jb nochar
              mov ah,0
              call strput
              mov ah,2
              call strput
              jmp chard

    nochar:   cmp ah,0eh
              je backspace
              cmp ah,1ch
              je enter
              jmp chard

    backspace:
              mov ah,1
              call strput
              mov ah,2
              call strput
              jmp chard

    enter:
              mov al,0
              mov ah,0
              call strput
              mov ah,2
              call strput
              jmp ok

    ok:       pop ax
              ret


    strput:    jmp short put

        table dw pushstack,popstack,showstr

        top dw 0

        color db 1

    put:       push dx
               push bx
               push es
               push di

               cmp ah,2
               ja sret
               mov bl,ah
               mov bh,0
               add bx,bx
               jmp word ptr table[bx]

    pushstack:
               mov bx,top
               mov [si][bx],al
               inc top
               jmp sret

    popstack:
               cmp top,0
               je sret
               dec top
               mov bx,top
               mov al,[bx][si]
               jmp sret

    showstr:
               mov bx,0b800h
               mov es,bx
               mov al,160
               mov ah,0
               mul dh
               mov di,ax
               mov dh,0
               add dl,dl
               add di,dx

               mov bx,0
             
   showstrs:   cmp bx,top
               jne show
               mov byte ptr es:[di],' '
               jmp sret

    show:      mov al,[si][bx]
               mov es:[di],al
               mov ah,byte ptr color
               mov es:[di].1,ah
               inc color
               mov byte ptr es:[di+2],' '
               add di,2
               inc bx
               jmp showstrs

    sret:      pop di
               pop es
               pop bx
               pop dx
               ret
              
    code ends

    end start







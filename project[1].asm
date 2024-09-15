Data segment
    number_names        db 0
    names_length        db 0
    list_of_name        db 90 dup (0)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    num_msg      db "#------------------------------------------------------------------------------#|                                   OpenMenu                                   |#------------------------------------------------------------------------------#|To Select  number and length of Names press 1                                 ||To Enter Names press 2                                                        ||To Perform Ascending sorting 3                                                ||To Perform Descending sorting press 4                                         ||To Display sorted Names press 5                                               ||To Exit press 6                                                               |#------------------------------------------------------------------------------#                                                                                Enter the selected number: $"
    num1_msg     db "please, enter the number of name(s) : $"
    num2_msg     db "please, enter the length of each name : $" 
    num3_msg     db "please, enter the name number $" 
    num4_msg     db " :$"
    
    newline      db 0ah, 0dh, '$'
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    error_len_num   db "sorry, you should enter the length , and the number of name(s) first, try again $"
    error_names     db "sorry, you should enter the name(s) first, try again $"
    error_from_1to6 db "error: only from 1 to 6 are the allowed numbers, try again $"
    error_from_1to9 db "error: only from 1 to 9 are the allowed numbers, try again $"
Data ends

Stack segment
    dw 100h dup(0)  
Stack ends

Code segment
Main proc far
    assume SS:Stack, CS:Code, DS:Data
    mov AX, Data
    mov DS, AX  ; starting
        
        
 return: 
        
        
        lea dx, num_msg  ; printing
        mov ah, 9h
        int 21h
        
        mov ah,1        ; taking the the selected number from the menu
        int 21h
        sub al, 30h
        
        cmp al,1        ; jump to num 1 function
        je length
        cmp al,2        ; jump to num 2 function
        je names
        cmp al,3        ; jump to num 3 function
        je sorting1
        cmp al,4        ; jump to num 4 function
        je sorting2
        cmp al,5        ; jump to num 5 function
        je print5
        cmp al,6        ; jump to num 6 function
        je exit
        
        jmp error1
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; first ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
 length:
        mov list_of_name , 0 
 
        mov ax, 03h              ; fixed the window shape to be 80x25
        int 10h                  ; clean the screa
        lea dx, newline        ; newline  
        mov ah, 9h
        int 21h
        
        
        lea dx, num1_msg       ; printing
        mov ah, 9h
        int 21h 
        
        mov ah,1               ; taking the number from the user
        int 21h
        sub al,30h 
        
        cmp al,10              ; checking if it's allowed
        jnl error3
        cmp al,0
        je  error3
        inc al
        mov number_names , al  ; saveing it for later
        
        lea dx, newline        ; newline  
        mov ah, 9h
        int 21h
        
        lea dx, num2_msg       ; printing
        mov ah, 9h
        int 21h
        
        mov ah,1               ; taking the number from the user
        int 21h
        sub al,30h
           
        cmp al,10              ; checking if it's allowed
        jnl error3
        cmp al,0
        je  error3
        
         mov names_length , al ; saveing it for later   
        
        mov ax, 03h              ; fixed the window shape to be 80x25
        int 10h                  ; clean the screan
                                 
        jmp return
        
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; secund ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    names:cmp number_names,0
          je error2 
         
          mov ax, 03h              ; fixed the window shape to be 80x25
         int 10h                  ; clean the screan
         
         
         mov ax,0 
         mov bx,0
         mov cx,0
         mov dx,0
         mov si,0
         mov di,0
         mov bp,0
            
         mov si, 31h               ; the value of num 1 in ASCII code
                
  all_names:lea dx, num3_msg       ; printing
            mov ah, 9h
            int 21h
            
            mov dx,si 
            mov ah,2
            int 21h
            
            lea dx, num4_msg       ; printing
            mov ah, 9h
            int 21h
            
               
            inc si
            inc di
            
            mov cl, names_length
            
            one_name:
                     mov ah,1               ; taking the number from the user
                     int 21h
                     
                     mov ds:[list_of_name + bp], al
                     inc bp
                     loop one_name
            mov cl, number_names    
            sub cx, di
           
            lea dx, newline        ; newline  
            mov ah, 9h
            int 21h
            loop  all_names
            
            mov ax, 03h              ; fixed the window shape to be 80x25
            int 10h                  ; clean the screan 
            
            jmp return
  
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; third ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   sorting2:cmp number_names,0
            je error2
            cmp list_of_name,0
            je error3
            mov ax, 03h              ; fixed the window shape to be 80x25
            int 10h                  ; clean the screa
            mov bp , 0
    this:   mov cl , number_names
            mov bl , names_length
            mov ch , 0
            inc cx
            mov di , 0
            mov bh , 0
            mov si , 0
            mov dl , 1
            mov dh , 2
            inc bp
      start:
            mov al , [list_of_name + si]
            mov ah , [list_of_name + bx]
            
            inc di
            cmp ah , al 
            jle  not_equals    ; jump if less than or equals
            
            
            mov cl, names_length
   replace: mov al, [list_of_name + si]  
            mov ah, [list_of_name + bx]
            mov [list_of_name + bx], al
            mov [list_of_name + si], ah
            inc si
            inc bx
            loop replace 
   not_equals:
            
            mov al , names_length
            mov ah , 0
            mul dl
            inc dl
            mov si, ax
            
            mov al , names_length
            mov ah , 0
            mul dh
            inc dh
            mov bx, ax
            cmp [list_of_name + bx] ,0
            je end  
            
            mov cl , number_names
            sub cx , di          
            loop start
        end:
            mov cl , number_names
            sub cx, bp
        
        loop this
            jmp return
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; fourth ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
   sorting1:cmp number_names,0
            je error2
            cmp list_of_name,0
            je error3
            mov ax, 03h              ; fixed the window shape to be 80x25
            int 10h                  ; clean the screa
                        mov bp , 0
    this1:   mov cl , number_names
            mov bl , names_length
            mov ch , 0
            inc cx
            mov di , 0
            mov bh , 0
            mov si , 0
            mov dl , 1
            mov dh , 2
            inc bp
      start1:
            mov al , [list_of_name + si]
            mov ah , [list_of_name + bx]
            
            inc di
            cmp ah , al 
            jae  not_equals1         ; jump if above than or equals
            
            
            mov cl, names_length
   replace1: mov al, [list_of_name + si]  
            mov ah, [list_of_name + bx]
            mov [list_of_name + bx], al
            mov [list_of_name + si], ah
            inc si
            inc bx
            loop replace1 
   not_equals1:
            
            mov al , names_length
            mov ah , 0
            mul dl
            inc dl
            mov si, ax
            
            mov al , names_length
            mov ah , 0
            mul dh
            inc dh
            mov bx, ax
            cmp [list_of_name + bx] ,0
            je end1  
            
            mov cl , number_names
            sub cx , di          
            loop start1
        end1:
            mov cl , number_names
            sub cx, bp
        loop this1
   
            jmp return
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; fifth ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   print5:
            cmp number_names,0
            je error2
            cmp list_of_name,0
            je error3
             
            mov ax, 03h              ; fixed the window shape to be 80x25
            int 10h                  ; clean the screan
             
            mov al, names_length
            mov cl, number_names
            mov ah,0
            mul cl               ; mul is auto multiplication the (varible you need * ax) and save it in ax 
            mov ch, 0
            mov cx, ax           ; we mutlipili (names_length * number_names), we save the answer in cx
            
            mov si, 0
            mov di, 0 
            mov ch, 0 
             
            printing:mov al, [list_of_name + si]
                     mov bl, names_length
                     mov bh, 0
                     inc si 
                     
                    
                     cmp di, bx
                     mov bh, al
                     jne same_name          ;jump if not equals
                     lea dx, newline        ; newline  
                     mov ah, 9h
                     int 21h 
                       
                     mov di,0
                     
           same_name:inc di
                     mov dh,0
                     mov dl,bh
                     mov ah,2
                     int 21H
                     
                     loop printing
                     
                     lea dx, newline        ; newline  
                     mov ah, 9h
                     int 21h
                     lea dx, newline        ; newline  
                     mov ah, 9h
                     int 21h
           jmp return 
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; errors ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                
    error1: ; only from 1 to 6
           mov ax, 03h              ; fixed the window shape to be 80x25
           int 10h                  ; clean the screan 
           lea dx, error_from_1to6  ; printing
           mov ah, 9h
           int 21h
           lea dx, newline         ; newline  
           mov ah, 9h
           int 21h
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h 
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h
        
          
          jmp return
          
    error2:
           mov ax, 03h              ; fixed the window shape to be 80x25
           int 10h                  ; clean the screan                                       
           lea dx,  error_len_num ; printing
           mov ah, 9h
           int 21h
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h 
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h 
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h
        
        
           jmp return
           
    error3:
           mov ax, 03h              ; fixed the window shape to be 80x25
           int 10h                  ; clean the screan                                       
           lea dx,  error_names   ; printing
           mov ah, 9h
           int 21h
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h 
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h
                   
           lea dx, newline        ; newline  
           mov ah, 9h
           int 21h
        
        
           jmp return  
          
      exit:
   
   
    mov AX, 4C00h ; Exit 
    int 21h
Main endp
Code ends
End Main
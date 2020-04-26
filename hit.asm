Delay8s MACRO                            ;macro to make a delay with 8 seconds
mov cx,7AH
mov dx,1200H
mov ah,86h
int 15h
ENDM

;--------------------------------------------- 
  Delay MACRO                            ;macro to slowdown the ball

      
    MOV CX, 00H       
    MOV DX, 2EE0H
    MOV AH, 86H
   INT 15H
 
  ENDM Delay
;------------------------------------------------  
drawbar MACRO x,y,color                  ;macro to draw the bar with given the upperleft coordinates
    local drawx

     
    mov cx,x
    mov dx,y
    mov al,color
    mov ah,0ch
    push x
    add x,30
    drawx:
    
     int 10h
    inc cx
    cmp cx,x
    jnz drawx
    sub x,30
    mov cx,x
    add x,30
    inc dx
    cmp dx,200
    jnz drawx
    pop x
 
ENDM drawbar
;-------------------------------------------------------  
.model small
.stack 64
.data 

intro db  10,13, '  I did not kill hany in the exam, so I decided to teach hany how to write an     assembly code',10,13,'$'           ;strings to be displayed on the screen

intro2 db '  you have to hit the blocks in order to make the following task',10,13,'  1- put 12h in the register AX',10,13,'  2- increment the value of BX by 1','$'

instruction db  ' Enter space to start playing','$' 

loseSc db 'TRY AGAIN,HANY your playing skills bad as your coding skills !','$'

congSc db 'CONGRATULATIONS HANY,your coding skills have been improved since the            exam !,please do not come back again !','$'

note db '  note:the only constraint in this game that you can not hit a block without      hitting the below block in the same column','$'

movSt db 'MOV'  

AXSt  db 'AX'

numSt db '12h'

incSt db 'INC'

BXSt db 'BX'

commaSt db ','

blocksorder db 4 dup(?) 

currindex db 0        ;the index of the instruction command 

button db ?           ;save the input button (left or right)

columnIn db ?         ;the column index

blockindexX dw ?      ;index of the block in x (from 0 to 8)

blockindexY dw ?      ;index of the block in y (from 2 to 0)

blocksheight db 9 dup(2)   ;the column height (initializing with 2)

currentx dw 0              ;upeer left x coordinate of the current block

currenty dw 0              ;upeer left y coordinate of the current block

ballcolor db 0AH           

barx dw 140         ;coordinates of the bar

bary dw 190 

ballx dw 155        ;initialize the centre coordinates of the ball 

bally dw 170

blockscount db 0    ;hit blocks count

.code

main proc far
mov ax,@data
mov ds,ax 



mov ah,0                   ;displaying the intro strings
mov al,03h
int 10h 

mov ah,9
mov dx,offset intro
int 21h   

mov ah,9
mov dx,offset intro2
int 21h

mov ah,2
mov dx,0C1Ah
int 10h 

mov ah,9
mov dx,offset instruction
int 21h 

mov ah,2
mov dx,0F00h
int 10h 

mov ah,9
mov dx,offset note
int 21h 


delay8s


mov ah,0
mov al,13h
int 10h 

call drawblocks   ;call a procedure the drawing the blocks

                  
mov  dl, 0        ;display the mov word on the block in first column third row 
mov  dh, 5   
mov  bh, 0    
mov  ah, 02h  
int  10h 

mov ah,0eh
mov bh,0
mov al,movst[0]
mov bl,0Eh
int 10h 

mov ah,0eh
mov bh,0
mov al,movst[1]
mov bl,0Eh
int 10h  

mov ah,0eh
mov bh,0
mov al,movst[2]
mov bl,0Eh
int 10h
        
mov  dl, 19      ;display the AX word on the block in fifth column first row 
mov  dh, 0   
mov  bh, 0    
mov  ah, 02h  
int  10h

mov ah,0eh
mov bh,0
mov al,AXst[0]
mov bl,0Eh
int 10h

mov ah,0eh
mov bh,0
mov al,AXst[1]
mov bl,0Eh
int 10h

mov  dl, 38       ;display the comma on the block in  column 9  row 2
mov  dh, 3   
mov  bh, 0    
mov  ah, 02h  
int  10h

mov ah,0eh
mov bh,0
mov al,commast[0]
mov bl,0Eh
int 10h

mov  dl, 23   
mov  dh, 3   
mov  bh, 0    
mov  ah, 02h  
int  10h

mov ah,0eh        ;display the number on the block in  column 6  row 2
mov bh,0
mov al,numst[0]
mov bl,0Eh
int 10h

mov ah,0eh
mov bh,0
mov al,numst[1]
mov bl,0Eh
int 10h

mov ah,0eh
mov bh,0
mov al,numst[2]
mov bl,0Eh
int 10h 

mov  dl, 27        ;display the INCREMENT word on the block in  column 7  row 1
mov  dh, 0   
mov  bh, 0    
mov  ah, 02h  
int  10h 


mov ah,0eh
mov bh,0
mov al,INCst[0]
mov bl,0Eh
int 10h        
        
mov ah,0eh
mov bh,0
mov al,INCst[1]
mov bl,0Eh
int 10h        
        
mov ah,0eh
mov bh,0
mov al,INCst[2]
mov bl,0Eh
int 10h 


mov  dl, 15        ;display the comma on the block in  column 4  row 2
mov  dh, 3   
mov  bh, 0    
mov  ah, 02h  
int  10h 

mov ah,0eh
mov bh,0
mov al,BXst[0]
mov bl,0Eh
int 10h 

mov ah,0eh
mov bh,0
mov al,BXst[1]
mov bl,0Eh
int 10h
       
                        
drawbar barx,bary,0ch         ;drawing the bar with initial x,y coordinates
                              ;drawing the ball with initial coordinates
call drawball   


pressSp:
mov ah,0                       ;wait for space to be pressed
int 16h
cmp al,20h 
jz angle270
jnz pressSp
;-------------------------------- 
angle270:                      ;first the ball will move with angle 270
mov ballcolor,0AH               ;draw the ball with its color
call drawball                  ;delay to slowdown the ball
delay

mov ballcolor,0                ;then draw the ball with black color to hide the ball
call drawball
delay

call input                     ;check if there is an input to move the bar
                               ;the angle is 270 so increment y coordiante of the ball only and keeb the x coordinate the same
inc bally

cmp bally,187                  ;if the ball hit the bar
jnz angle270 

mov ax,ballx
add ax,2
cmp ax,barx                    ;if the right border of the ball not on the bar then lose
jb dummy1
mov bx,barx
add bx,10
cmp ax,bx                      ;if the ball is on the first 10 columns of the bar then go to angle 135
jbe dummy2
add bx,10
cmp ax,bx                      ;if the ball is on the half 10 columns of the bar ther go to angle 90
jbe angle90
add bx,10
sub ax,4
cmp ax,bx                      ; if the ball is on the last 10 columns of the bar then go to angle 45
jbe angle45 

dummy1:jmp lose                ;if nothing of the above happened the tha ball is not on the bar then lose
dummy2:jmp angle135
;--------------------------------- 
angle90:

mov ballcolor,0Ah
call drawball
delay

mov ballcolor,0
call drawball
delay
call input

dec bally                    ;the angle is 90 so decrement the y coordinate of the ball with the same x coordinate              

call blockindex 
mov si,blockindexX           ;here we calculate the y coordinate which the ball will be expected to hit with  ;0->(0*5)+(1*15)+2
                                                                                                              ;1->(1*5)+(2*15)+2
mov al,5                                                                                                      ;2->(2*5)+(3*15)+2
mov bl,blocksheight[si]      ;multiply the padding by height of column
mul bl
mov bx,ax 
inc blocksheight[si]
mov al,15                    ;multiply the height of the block by the heightog the column +1
mov dl,blocksheight[si]
dec blocksheight[si]
mul dl
mov dx,ax
add bx,dx
add bx,2                     ;add 2 for reasaon of the ball height

                             
cmp bally,3                  ;if the ball hit the upper part of the screen (empty column of blocks) go down
jz dummy2702 

cmp blocksheight[si],-1      ;if the column is empty keep going up until hit the upper part of screen
jz angle90
                                           
cmp bally,bx                 ;no hit happened yet
ja angle90    
                             
sub bx,15                    ;if the ball crossed the block without hitting it but hit the above block then don't crash and go down
cmp bally,bx
jb  dummy2702 

jmp crash                   ;if the ball hit a block in its side or from the bottom

dummy2702:jmp angle270
;---------------------------------------
angle45:

cmp ballx,317               ;hit with the right boundary of the screen ?!  then go to angle 135
jz dummy135

mov ballcolor,0Ah
call drawball
delay

mov ballcolor,0
call drawball
delay
call input

dec bally                    ;to go with angle 45 we need to decrement y and increment x
inc ballx

call blockindex                                  
mov si,blockindexX
mov al,5                                            
mov bl,blocksheight[si]
mul bl
mov bx,ax 
inc blocksheight[si]
mov al,15
mov dl,blocksheight[si]
dec blocksheight[si]
mul dl                                     
mov dx,ax
add bx,dx
add bx,2


cmp bally,3
jz dummy270

cmp blocksheight[si],-1
jz angle45
                                           
cmp bally,bx
ja angle45

sub bx,15
cmp bally,bx
jb  dummy270   

jmp crash  
;---------------------------------------
dummy135:jmp angle135                  
dummy270:jmp angle270 
dummy90:jmp angle90
dummy45:jmp angle45
;---------------------------------------
angle135:
cmp ballx,2                ;if the ball hits the left side of the screen go to angle 45
jz dummy45

mov ballcolor,0Ah
call drawball
delay

mov ballcolor,0
call drawball
delay
call input
                           ;to go with angle 135 decrement x and y
dec bally
dec ballx
  
call blockindex                                 
mov si,blockindexX
mov al,5                                          
mov bl,blocksheight[si]
mul bl
mov bx,ax 
inc blocksheight[si]
mov al,15
mov dl,blocksheight[si]
dec blocksheight[si]
mul dl
mov dx,ax
add bx,dx
add bx,2


cmp bally,3
jz dummy270

cmp blocksheight[si],-1
jz angle135
                                       
cmp bally,bx
ja angle135 

sub bx,15
cmp bally,bx
jb  dummy2703
 
jmp crash   

dummy2703:jmp angle270 
;----------------------------------
crash:
call blockindex                   ;when the crash happen first know the index of the block
call drawblockblack               ;second draw this block with black color
call checkOrder                   ;third check the order of the required instruction
mov bx,blockindexX                ;decrement the height of the column that have the crash
dec blocksheight[bx]
jmp angle270                      ;go to angle 270 
;------------------------------------- 
win:
mov ah,0                  ;print congratulation msg on the screen
mov al,03h
int 10h 

mov ah,2
mov dx,0C0Ah
int 10h 


mov ah,9
mov dx,offset congsc
int 21h 
 
 delay8s

mov ah,0          
mov al,03h
int 10h 

jmp exitmain

;-------------------------------------
lose:                     ;print losing msg on the screen

mov ah,0          
mov al,03h
int 10h 

mov ah,2
mov dx,0C0Ah
int 10h 

mov ah,9
mov dx,offset loseSc
int 21h 

delay8s

mov ah,0          
mov al,03h
int 10h 

exitmain:

mov ah,4ch
int 21h 
   main endp
;------------------------------------------------------
drawblocks proc                ;procedure to draw the blocks

mainloop:                      
cmp currenty,60                ;if the 3 rows are drawn 
jz exit
mov cx,currentx                ;draw a 32*15 block with yellow color
mov bx,currentx
add bx,32
mov dx,currenty
mov si,currenty
add si,15
mov al,0Eh
mov ah,0ch 

                              ;
loop1:                        ;
int 10h                       ;
inc cx                        ;---------------------
cmp cx,bx                     ;                     |
jnz loop1                     ;   draw one block    |
loop2:                        ;                     |
mov cx,currentx               ;                     |
inc dx                        ;                     |
cmp dx,si                     ;---------------------                    
jnz loop1                     ;

cmp cx,288                        ;go to the next row
jz incY
add bx,4                          ;make a space with every column of blocks and the other 4 columns
mov currentx,bx 
mov si,currenty
jmp mainloop
incY:  
add si,5                          ;make a space with every row of blocks and the other 5 rows
mov currenty,si
mov currentx,0                    ;start x from 0 again to draw the next row
jmp mainloop



exit:   
    ret
    drawblocks endp
                     
;--------------------------------------------------------------                     
drawball proc
    
   push ballx              ;keepin the original value of the x,y of the ball
   push bally
   
   sub ballx,2
   sub bally,2
   mov cx,ballx
   mov si,ballx
   add si,5                 ;draw 5*5 ball
   mov dx,bally
   mov di,bally
   add di,5
   mov al,ballcolor         ;with the passed color (black or color)
   mov ah,0ch
   
   ballloop:                ;draw the square
   int 10h
   inc cx
   cmp cx,si
   jnz ballloop                
                                 
   mov cx,ballx              
   inc dx                    
   cmp dx,di
   jnz ballloop
   
   pop bally
   pop ballx
    ret
    drawball endp                     

;----------------------------------------------------------------

drawblockblack proc         ;this procedure draw a black block with the required block index 
    mov si,0
    mov di,0 
    mov ax,36
    mov dx,0
    
    
    
 loopblackx:                ;find the x index (from 0 to 8)       
   cmp blockindexX,si                                              
   jz  calcX                                                       
   inc si
   jmp loopblackx
;------------------- 
dummywin:jmp win
;------------------- 
calcX:                     ;0->x=0             
mul si                     ;1->x=1*36            
cmp dx,0                   ;2->x=2*36  and so on              
jnz x288        
mov cx,ax
jmp loopblacky     

x288:
mov cx,288

loopblacky:                ;find the y index (from 0 to 2)
cmp blockindexY,di
jz  calcY
inc di
jmp loopblacky

calcY:
mov ax,20                  ;0->y=0
mul di                     ;1->y=20
mov dx,ax                  ;2->y=40

drawblack:                 ;here to draw the black block with the give x,y upper left coordinates of the required block
mov di,dx
add di,15
mov si,cx
add si,32
mov al,0 
mov ah,0ch
loopDblack:
int 10h
inc cx
cmp cx,si
jnz loopDblack
sub cx,32
inc dx
cmp dx,di
jnz loopDblack 

inc blockscount        ;ever time the procedure executed increment the number of the black blocks till it reaches 27

cmp blockscount,27
jz  dummywin
    
    ret 
    drawblockblack endp    
;----------------------------------------------------------------

blockindex proc           ;this procedure calculate the block index that the ball crashed with 
    push ballx
    push bally
    mov bh,0
    
    sub ballx,2           ;calculate with the left side of the ball
    cmp  ballx,32
    jbe  setcolumn0       ;the ball is at the first column  and so on
    cmp ballx,68
    jbe setcolumn1
    cmp ballx,104
    jbe dummy2col 
     cmp ballx,140
    jbe dummy3
     cmp ballx,176
    jbe dummy4
     cmp ballx,212
    jbe dummy5
     cmp ballx,248
    jbe dummy6
     cmp ballx,284
    jbe dummy7
     cmp ballx,320
    jmp setcolumn8 
    
;------------------------------
dummy4:jmp setcolumn4    
dummy3:jmp setcolumn3    
dummy7:jmp setcolumn7
dummy5:jmp setcolumn5 
dummy6:jmp setcolumn6 
dummy2col:jmp setcolumn2    
;------------------------------    
setcolumn0:
mov blockindexX,0             ;set the x index with the index of the hit column
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx            ;set the y index with the height of the column
jmp exit2

;----------------------------
setcolumn1:
mov blockindexX,1
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx
jmp exit2

setcolumn2: 
mov blockindexX,2
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx
jmp exit2


setcolumn3:
mov blockindexX,3
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx 
jmp exit2


setcolumn4:
mov blockindexX,4
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx
jmp exit2


setcolumn5:
mov blockindexX,5
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx
jmp exit2

setcolumn6:
mov blockindexX,6
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx
jmp exit2


setcolumn7:
mov blockindexX,7
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx
jmp exit2 


setcolumn8:
mov blockindexX,8
mov si,blockindexX
mov bl, blocksheight[si]
mov blockindexY,bx


    

exit2:
    
    
    pop bally
    pop ballx
    ret
    blockindex endp 
    
;----------------------------------------------------------------------
input proc                    ;this procedure check if the player is moving right and left
     
    mov ah,1
    int 16h
    jz cont
    mov ah,0
    int 16h 
    
cont:
    mov button,ah 
    cmp button,75           ;scan code of the left button is 75
    jz  shiftleft
    cmp button,77            ;scan code of the right button is 77
    jz dummyright
    jmp exit3
;-------------------------    
dummyright:jmp shiftright
dummyexit3:jmp exit3
;--------------------------    
shiftleft:
    cmp barx,0            ;if the player wants to move left and the bar at the left side of the screen
    jz  dummyexit3
    drawbar barx,bary,0   ;clear the bar
    sub barx,2
    drawbar barx,bary,0ch ;draw the bar again with new x coordinate
    jmp exit3
    
shiftright:
    cmp barx,290          ;if the player wants to move right and the bar at the right side of the screen
    jz exit3 
    drawbar barx,bary,0   
    add barx,2
    drawbar barx,bary,0ch

exit3:

    ret
    input endp 
;-------------------------------------------- 

checkOrder proc              ;this procedure check the order of the assembly istructions it must be "mov ax, 12h 
                             ;                                                                       INC  BX    "     otherwise the player will lose the game
    
    cmp blockindexX,0        ;"mov" at block index where x=0
    jz  checky0
    cmp blockindexX,4        ;"AX" at block index where x=4
    jz checky4
    cmp blockindexX,5        ;"12" at block index where x=5
    jz checky5
    cmp blockindexX,8        ;"," at block index where x=8
    jz checky8   
    cmp blockindexX,3        ;"BX" at block index where x=3
    jz checky3
    cmp blockindexX,6        ;"INC" at block index where x=6
    jz checky6
    
    
    
    
    jmp exitcheck 
    
   
    
 checky0:
 cmp blockindexY,2    ;"mov" at block index where y=2
 jz checkcurr0
 jmp exitcheck
 checkcurr0:
 cmp currindex,0      ;it must be the first word
jnz dummylose
inc currindex
jmp exitcheck
 
 
 checky4:
  cmp blockindexY,0   ;"AX" at block index where y=0
 jz checkcurr4
 jmp exitcheck
 checkcurr4:
 cmp currindex,1       ;it must be the second word
jnz dummylose
inc currindex
jmp exitcheck
 
 checky5:
  cmp blockindexY,1     ;"12" at block index where y=1
 jz checkcurr5
 jmp exitcheck
 checkcurr5:
 cmp currindex,3         ;it must be the 4th word
jnz dummylose
inc currindex
jmp exitcheck
;----------------------
 dummylose:jmp lose
;-----------------------  
 checky8:
  cmp blockindexY,1     ;"," at block index where y=1
 jz checkcurr8
 jmp exitcheck
 checkcurr8:
 cmp currindex,2         ;it must be the third word
 jnz dummylose
 inc currindex
 jmp exitcheck
 
  checky3:
  cmp blockindexY,1   ;"BX" at block index where y=1
 jz checkcurr3
 jmp exitcheck
 checkcurr3:
 cmp currindex,5        ;it must be the 6th word
 jnz dummylose
 inc currindex
 jmp exitcheck 
 
  checky6:
  cmp blockindexY,0  ;"INC" at block index where y=0
 jz checkcurr6
 jmp exitcheck
 checkcurr6:
 cmp currindex,4      ;it must be the fifth word
 jnz dummylose
 inc currindex
 jmp exitcheck
 

exitcheck:    
    ret
    checkOrder endp

;----------------------------------------------------------
end main                

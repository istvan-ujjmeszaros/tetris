{$G+}
Unit MyGraph;


INTERFACE

 Uses BITmuv;

 Const SegA000:word=$A000;
       Ink:byte=01;
       Paper:byte=00;
       Over:byte=01;
       Vspace:word=8;
       Cadr:word=0000;

 Procedure OutStrXY(hx,hy:word;s:string);
 Procedure PutPixel(X,Y:word;Color:byte);
 Function  GetPixel(X,Y:word):byte;
 Procedure Line(x1,y1,x2,y2:word;Color:byte);
 Procedure SetRGBreg(regnum,Red,Green,Blue:byte);
 Procedure Bar(x1,y1,x2,y2:word;Color:byte);
 Procedure Box(x1,y1,x2,y2:word;Color:byte);
 Procedure InitScreen;
 Procedure ClearScreen;
 Procedure BarXOR(x1,y1,x2,y2:word);


IMPLEMENTATION

 Const Lsize=320;
       Ntab:Array[0..11] of integer=(-321,-320,-319,000,
                                     -001, 000, 001,000,
                                      319, 320, 321,000);
 Var r0,r1,r2,r3:word;
     r4,r5,r6,r7:word;

     c:array[32..163,1..5] of byte;

 Const charcolor=25;


 Procedure Tolt;
 Var f:file;
 Begin
  Assign(f,'char.dat');
  {$I-}
  Reset(f,1);
  if IOResult=0 then
  begin
   BlockRead(f,c,sizeof(c));
   Close(f);
  end;
  {I+}
 End;

 Procedure Kirak(hx,hy:word;ch:char);
 Var x,y,cbyte:byte;
 Begin
  cbyte:=ord(UpCase(ch));
  for x:=1 to 5 do
   for y:=1 to 8 do
    if Bit(c[cbyte,x],y) then PutPixel(hx+x-1,hy+y-1,charcolor+y-1);
 End;

 Procedure OutStrXY(hx,hy:word;s:string);
 Var meret,i:byte;
     s1:string[1];
     c:char;
 Begin
  meret:=Length(s);
  if meret>0 then
   for i:=1 to meret do
   begin
    s1:=Copy(s,i,1);
    c:=s1[1];
    Kirak(hx+(i-1)*6,hy,c);
   end;
 End;

 Procedure PutPixel(X,Y:word;Color:byte);Assembler;
 Asm
    mov  ax,Lsize
    mul  Y
    add  ax,X
    mov  di,ax
    mov  ES,SegA000
    mov  al,Color
    mov  ES:[di],al
 End;

 Function Getpixel(X,Y:word):byte;Assembler;
 Asm
    mov  ax,Lsize
    mul  Y
    add  ax,X
    mov  di,ax
    mov  ES,SegA000
    mov  al,ES:[di]
 End;

 Procedure Line(x1,y1,x2,y2:word;Color:byte);Assembler;
 Asm
    mov  ES,SegA000
    mov  ax,Lsize
    mul  y1
    add  ax,x1
    mov  di,ax
    mov  al,Color
    mov  ES:[di],al
    mov  bx,0101h
    mov  dx,X2
    sub  dx,X1
    jnc  @t1
    neg  dx
    mov  bl,255
 @t1:
    mov  si,Y2
    sub  si,Y1
    jnc  @t2
    neg  si
    mov  bh,255
 @t2:
    mov  cx,si
    mov  r2,bx
    cmp  dx,si
    jnc  @x_ge_y
    mov  r1,dx
    xor  bl,bl
    jmp  @t3
 @x_ge_y:
    test dx,dx
    jz   @exit
    mov  r1,si
    mov  cx,dx
    xor  bh,bh
 @t3:
    mov  r3,cx
    mov  ax,cx
    shr  ax,1
 @line_loop:
    add  ax,r1
    jc   @diag
    cmp  ax,r3
    jc   @vhl
 @diag:
    sub  ax,r3
    mov  r4,ax
    mov  ax,r2
    jmp  @nextplot
 @vhl:
    mov  r4,ax
    mov  ax,bx
 @nextplot:
    mov  r5,bx
    inc  al
    shl  al,1
    inc  ah
    shl  ah,3
    add  al,ah
    xor  ah,ah
    lea  bx,Ntab
    add  bx,ax
    add  di,[bx]
    mov  al,Color
    mov  ES:[di],al
    mov  ax,r4
    mov  bx,r5
    loop @line_loop
 @exit:
 End;

 Procedure SetRGBreg(regnum,Red,Green,Blue:byte);Assembler;
 Asm
    mov  dx,03C8h
    mov  al,regnum
    out  dx,al
    inc  dx
    mov  al,Red
    out  dx,al
    mov  al,Green
    out  dx,al
    mov  al,Blue
    out  dx,al
 End;

 Procedure Bar(x1,y1,x2,y2:word;Color:byte);Assembler;
 Asm
    mov  ES,SegA000
    cld
    mov  ax,X1
    mov  cx,X2
    cmp  ax,cx
    jc   @t1
    xchg ax,cx
    mov  X1,ax
 @t1:
    sub  cx,ax
    inc  cx
    mov  di,ax
    mov  si,Y2
    mov  ax,Y1
    cmp  ax,si
    jc   @t2
    xchg ax,si
    mov  Y1,ax
 @t2:
    sub  si,ax
    inc  si
    mov  bx,Lsize
    mul  bx
    add  di,ax
    mov  al,Color
    sub  bx,cx
    mov  dx,cx
 @cikl1:
    mov  cx,dx
    rep stosb
    add  di,bx
    dec  si
    jnz  @cikl1
 End;

 Procedure Box(x1,y1,x2,y2:word;Color:byte);Assembler;
 Asm
    mov  ES,SegA000
    cld
    mov  ax,X1
    mov  cx,X2
    cmp  ax,cx
    jc   @t1
    xchg ax,cx
    mov  X1,ax
 @t1:
    sub  cx,ax
    inc  cx
    mov  di,ax
    mov  si,Y2
    mov  ax,Y1
    cmp  ax,si
    jc   @t2
    xchg ax,si
    mov  Y1,ax
 @t2:
    sub  si,ax
    inc  si
    mov  bx,Lsize
    mul  bx
    add  di,ax
    mov  al,Color
    mov  dx,cx
    mov  bx,di
    rep stosb
    dec  di
    mov  cx,si
    dec  cx
    jz   @exit
 @cikl:
    mov  ES:[bx],al
    mov  ES:[di],al
    add  bx,Lsize
    add  di,Lsize
    loop @cikl
    mov  di,bx
    mov  cx,dx
    rep stosb
 @exit:
 End;

 Procedure InitScreen;Assembler;
 Asm
    mov  ax,0013h
    int  10h
 End;

 Procedure ClearScreen;Assembler;
 Asm
    cld
    xor  ax,ax
    mov  cx,32000
    mov  di,ax
    mov  ES,SegA000
    rep stosw
 End;

 Procedure BarXOR(x1,y1,x2,y2:word);
 Var s,x,y:word;
 Begin
  if x1>x2 then
  begin
   s:=x1;
   x1:=x2;
   x2:=s;
  end;
  if y1>y2 then
  begin
   s:=y1;
   y1:=y2;
   y2:=s;
  end;
  for y:=y1 to y2 do
   for x:=x1 to x2 do PutPixel(x,y,GetPixel(x,y) xor $FF);
 End;


BEGIN
 Tolt;
END.
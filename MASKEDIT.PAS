Uses crt;
Const verzio='1.00';
Var a:array[1..7,1..4,1..4,1..4] of boolean;
    ch:char;
    ssz,irany:byte;
    Kx,Ky:byte;

Procedure Negyzet(x,y:byte);
Var xx,yy:byte;
Begin
 GotoXY(x,y);
 Write('⁄ƒƒƒƒø');
 for yy:=y+1 to y+4 do
 begin
  GotoXY(x,yy);
  Write('≥    ≥');
 end;
 GotoXY(x,y+5);
 Write('¿ƒƒƒƒŸ');
End;

Procedure Ment;
Var f:file;
Begin
 Assign(f,'alak.dat');
 Rewrite(f,1);
 BlockWrite(f,a,sizeof(a));
 Close(f);
End;

Procedure Tolt;
Var f:file;
Begin
 Assign(f,'alak.dat');
 {$I-}
 Reset(f,1);
 if IOResult=0 then
 begin
  BlockRead(f,a,sizeof(a));
  Close(f);
 end;
 {I+}
End;

Procedure Kilep;
Begin
 TextColor(7);
 TextMode(c80);
 Halt;
End;

Function PosX(x:byte):byte;
Begin
 case irany of 1:PosX:=x+15;
               2:PosX:=x+30;
               3:PosX:=x+15;
               4:PosX:=x+30;
 end;
End;

Function PosY(y:byte):byte;
Begin
 case irany of 1:PosY:=y+10;
               2:PosY:=y+10;
               3:PosY:=y+20;
               4:PosY:=y+20;
 end;
End;

Procedure Frissit;
Var i,x,y:byte;
Begin
 i:=irany;
 for irany:=1 to 4 do
  for x:=1 to 4 do
   for y:=1 to 4 do
   begin
    GotoXY(PosX(x),PosY(y));
    if a[ssz,irany,x,y] then Write('X') else Write(' ');
   end;
 irany:=i;
End;

Procedure Elforgatas;
Var x,y:byte;
Begin
 for y:=1 to 4 do
  for x:=1 to 4 do
  begin
   case irany of 1:begin
                    a[ssz,2,y,5-x]:=a[ssz,1,x,y];
                    a[ssz,3,5-x,5-y]:=a[ssz,1,x,y];
                    a[ssz,4,5-y,x]:=a[ssz,1,x,y];
                   end;
                 2:begin
                    a[ssz,1,5-y,x]:=a[ssz,2,x,y];
                    a[ssz,3,y,5-x]:=a[ssz,2,x,y];
                    a[ssz,4,5-x,5-y]:=a[ssz,2,x,y];
                   end;
                 3:begin
                    a[ssz,1,5-x,5-y]:=a[ssz,3,x,y];
                    a[ssz,2,5-y,x]:=a[ssz,3,x,y];
                    a[ssz,4,y,5-x]:=a[ssz,3,x,y];
                   end;
                 4:begin
                    a[ssz,1,y,5-x]:=a[ssz,4,x,y];
                    a[ssz,2,5-x,5-y]:=a[ssz,4,x,y];
                    a[ssz,3,5-y,x]:=a[ssz,4,x,y];
                   end;
   end;
  end;
End;

Procedure Billentyu;
Begin
 ch:=UpCase(ReadKey);
 case ch of #32:if a[ssz,irany,Kx,Ky] then a[ssz,irany,Kx,Ky]:=false else a[ssz,irany,Kx,Ky]:=true;
            #72:if Ky>1 then Dec(Ky);
            #75:if Kx>1 then Dec(Kx);
            #77:if Kx<4 then Inc(Kx);
            #80:if Ky<4 then Inc(Ky);
            '1':irany:=1;
            '2':irany:=2;
            '3':irany:=3;
            '4':irany:=4;
            '+':if ssz<7 then Inc(ssz);
            '-':if ssz>1 then Dec(ssz);
            #61:Tolt;
            #60:Ment;
            #67:Elforgatas;
            #27:Kilep;
 end;
 Frissit;
End;

Procedure Felirat;
 procedure Ir(x,y:byte;szoveg:string);
 begin
  GotoXY(x,y);
  Write(szoveg);
 end;
Begin
 Ir(50,10,'Alak  :');
 Ir(50,12,'Ir†ny :');
 Ir(10,29,'BillentyÅk :');
 Ir(25,32,'Poz°cion†l†s');
 Ir(25,34,'KijelîlÇs/kijelîlÇs megszÅntetÇse');
 Ir(25,36,'Ir†nyv†laszt†s');
 Ir(25,38,'Adatok mentÇse');
 Ir(25,40,'Adatok tîltÇse');
 Ir(25,42,'Az aktu†lis ir†nyhoz viszony°tott elforgat†sok');
 Ir(25,44,'KilÇpÇs');
 TextColor(15);
 Ir(15,32,' Kurzor :');
 Ir(15,34,'  SPACE :');
 Ir(15,36,'1,2,3,4 :');
 Ir(15,38,'     F2 :');
 Ir(15,40,'     F3 :');
 Ir(15,42,'     F9 :');
 Ir(15,44,'    ESC :');
End;

Procedure Csinal;
Begin
 ssz:=1;
 irany:=1;
 Kx:=1;
 Ky:=1;
 Felirat;
 Tolt;
 Frissit;
 repeat
  GotoXY(58,10);
  Write(ssz);
  GotoXY(58,12);
  Write(irany);
  GotoXY(PosX(Kx),PosY(Ky));
  Billentyu;
 until False;
End;


BEGIN
 TextMode(300);
 ClrScr;
 GotoXY(75,50);
 TextColor(8);
 Write('v',verzio);
 GotoXY(27,2);
 TextColor(15);
 Write('MASZK EDITOR');
 TextColor(7);
 Write(' a TETRIS-hez');
 GotoXY(15,9);Write('1.');Negyzet(15,10);
 GotoXY(30,9);Write('2.');Negyzet(30,10);
 GotoXY(15,19);Write('3.');Negyzet(15,20);
 GotoXY(30,19);Write('4.');Negyzet(30,20);
 Csinal;
END.


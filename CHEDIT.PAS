uses crt,bitmuv;
var c:array[32..163,1..5] of byte;
    ch:char;
    ssz:byte;
    kx,ky:byte;

procedure ment;
var f:file;
begin
 assign(f,'char.dat');
 rewrite(f,1);
 blockwrite(f,c,sizeof(c));
 close(f);
end;

Procedure tolt;
var f:file;
begin
 assign(f,'char.dat');
 {$I-}
 reset(f,1);
 if ioresult=0 then
 begin
  blockread(f,c,sizeof(c));
  close(f);
 end;
 {I+}
end;

procedure billentyu;
var y:byte;

 procedure frissit;
 var x,y:byte;
 begin
  for x:=1 to 5 do
   for y:=1 to 8 do
   begin
    gotoxy(x+11,y+10);
    if bit(c[ssz,x],y) then write('X') else write(' ');
   end;
 end;

begin
 case ch of #32:if bit(c[ssz,kx],ky) then bitedit(c[ssz,kx],ky,false) else bitedit(c[ssz,kx],ky,true);
            #72:if ky>1 then dec(ky);
            #75:if kx>1 then dec(kx);
            #77:if kx<5 then inc(kx);
            #80:if ky<8 then inc(ky);
            '+':if ssz<163 then
                begin
                 inc(ssz);
                 frissit;
                 gotoxy(42,11);
                 write(ssz,'  ');
                end;
            '-':if ssz>32 then
                begin
                 dec(ssz);
                 frissit;
                 gotoxy(42,11);
                 write(ssz,'  ');
                end;
            'S':ment;
            'L':begin tolt;frissit;end;
 end;
 frissit;
 gotoxy(kx+11,ky+10);
end;

procedure csinal;
begin
 Tolt;
 kx:=1;
 ky:=1;
 ssz:=32;
 gotoxy(30,11);
 write('ASCII k¢d :');
 textcolor(15);
 gotoxy(42,11);
 write(ssz,'  ');
 gotoxy(11+kx,10+ky);
 repeat
  ch:=upcase(readkey);
  billentyu;
 until ch=#27;
end;

begin
 textmode(300);
 clrscr;
 gotoxy(27,2);
 textcolor(15);
 write('KARAKTER EDITOR');
 textcolor(7);
 write(' a TETRIS-hez');
 gotoxy(1,10);
 writeln('          ÚÄÄÄÄÄ¿');
 writeln('          ³     ³');
 writeln('          ³     ³');
 writeln('          ³     ÃÄ');
 writeln('          ³     ³');
 writeln('          ³     ³');
 writeln('          ³     ³');
 writeln('          ³     ÃÄ');
 writeln('          ³     ³');
 writeln('          ÀÄÄÄÄÄÙ');
 csinal;
 textmode(c80);
 clrscr;
 textcolor(7);
end.


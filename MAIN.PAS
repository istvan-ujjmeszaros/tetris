Unit Main;

INTERFACE

 Uses MyGraph,MyCrt,Crt,Menuk;

 Const szintabla:array[0..8,1..3] of byte=((0,0,0),(1,2,3),(4,5,6),
                                           (7,8,9),(10,11,12),(13,14,15),
                                           (16,17,18),(19,20,21),(22,23,24));

 Var meret:byte;
     sarokX,sarokY,pont:word;
     startszint,speed:byte;

 Procedure InitPal;
 Procedure Palya;
 Procedure Bar3D(x,y,xmeret,ymeret:word;s,mode:byte);
 Procedure Iranyit;
 Procedure UjraRajzol(tobbi:boolean);



IMPLEMENTATION

 Var tabla:array[1..10,1..20] of byte;
     maszk:array[1..7,1..4,0..3,0..3] of boolean;
     darab:array[1..7] of word;
     alak,irany,kovetkezo:byte;
     oldpont:word;
     Xp,Yp:shortint;
     leert,halal:boolean;
     start,idozito:longint;
     pstr:string;

 Procedure InitPal;
 Var f:file;
     olvas:array[0..767] of byte;
     b:byte;
  procedure Kilep;
  begin
   WriteLn('Nyomj egy billentyÅt a kilÇpÇshez ...');
   ReadKey;
   if InstalledTimer then UninstallTimer;
   Halt;
  end;
 Begin
  Assign(f,'pal.dat');
  {$I-}
  Reset(f,1);
  if IOResult<>0 then
  begin
   TextMode(c80);
   WriteLn('S£lyos hiba !');
   WriteLn('Nem tal†lom a ''PAL.DAT'' file-t !!!');
   Kilep;
  end;
  {$I+}
  if FileSize(f)<>768 then
  begin
   TextMode(c80);
   WriteLn('S£lyos hiba !');
   WriteLn('Hib†s a ''PAL.DAT'' file !!!');
   Kilep;
  end;
  BlockRead(f,olvas,768);
  Close(f);
  for b:=0 to 255 do SetRGBreg(b,olvas[b*3],olvas[b*3+1],olvas[b*3+2]);
 End;

 Procedure Tolt;
 Var f:file;
 Begin
  Assign(f,'alak.dat');
  {$I-}
  Reset(f,1);
  if IOResult=0 then
  begin
   BlockRead(f,maszk,sizeof(maszk));
   Close(f);
  end;
  {I+}
 End;

 Procedure Bar3D(x,y,Xmeret,Ymeret:word;s,mode:byte);
 Var c1,c2,c3:byte;
 Begin
  case mode of 0:begin
                  c1:=szintabla[s,1];
                  c2:=szintabla[s,2];
                  c3:=szintabla[s,3];
                 end;
               1:begin
                  c1:=szintabla[s,3];
                  c2:=szintabla[s,2];
                  c3:=szintabla[s,1];
                 end;
  end;
  Box(x,y,x+Xmeret,y+Ymeret,c1);
  Box(x+1,y+1,x+Xmeret,y+Ymeret,c3);
  Bar(x+1,y+1,x+Xmeret-1,y+Ymeret-1,c2);
  PutPixel(x,y+Ymeret,c2);
  PutPixel(x+Xmeret,y,c2);
 End;

 Function PosX(x:byte):word;
 Begin
  PosX:=sarokX+(meret+1)*(x-1)+1;
 End;

 Function PosY(y:byte):word;
 Begin
  PosY:=sarokY+(meret+1)*(y-1)+1;
 End;

 Function Belul(x,y:shortint):boolean;
 Begin
  if (x<1) or (x>10) or (y<1) or (y>20) then Belul:=false else Belul:=true;
 End;

 Function Szabad(xx,yy:shortint;i:byte):boolean;
 Var b:boolean;
     x,y:byte;
 Begin
  if i=0 then i:=4;
  if i=5 then i:=1;
  b:=true;
  for y:=0 to 3 do
   for x:=0 to 3 do
    if (yy+y<>0) and (maszk[alak,i,x,y]) then
     if (belul(xx+x,yy+y)) then
     begin
      if (tabla[xx+x,yy+y]<>0) then b:=false;
     end else b:=false;
  Szabad:=b;
 End;

 Procedure Kirak(xx,yy,a,i:byte);
 Var x,y:byte;
 Begin
  for y:=0 to 3 do
   for x:=0 to 3 do
    if (maszk[a,i,x,y]) and (belul(xx+x,yy+y)) then Bar3d(PosX(xx+x),PosY(yy+y),meret,meret,a,0);
 End;

 Procedure Rajzol(xx,yy,a,i,m:byte);
 Var x,y:byte;
 Begin
  for y:=0 to 3 do
   for x:=0 to 3 do
    if (maszk[a,i,x,y]) then Bar3d(xx+x*(m+1),yy+y*(m+1),m,m,a,0);
 End;

 Procedure PontKiir;
 Begin
  if oldpont<>pont then
  begin
   Bar(70,10,120,18,0);
   OutStrXY(70,10,sztring(pont));
   oldpont:=pont;
  end;
 End;

 Procedure SzintKiir;
 Begin
  Bar(70,25,80,32,0);
  OutStrXY(70,25,Sztring(11-speed));
 End;

 Procedure KovetkezoRajzol(melyik:byte);
 Begin
  Bar(40,100,40+32,100+32,0);
  Rajzol(40,100,melyik,1,7);
 End;

 Procedure Statisztika;
 Const x=255;
       y=15;
 Var b:byte;
     osszesitett:word;
     s:string[4];
 Begin
  Bar(x+10,y+5,x+35,y+180,0);
  osszesitett:=0;
  for b:=1 to 7 do
  begin
   s:=Sztring(darab[b]);
   if darab[b]<10 then s:=' '+s;
   if darab[b]<100 then s:=' '+s;
   OutStrXY(x,y+(b-1)*25+5,': '+s);
   osszesitett:=osszesitett+darab[b];
  end;
  OutStrXY(x+12,y+162,'___');
  s:=Sztring(osszesitett);
  if osszesitett<10 then s:=' '+s;
  if osszesitett<100 then s:=' '+s;
  OutStrXY(x+12,y+172,s);
 End;

 Procedure Keret;
 Begin
  Bar3d(sarokX-1,sarokY-1,10*(meret+1)+3,20*(meret+1)+3,8,0);
  Bar3d(sarokX,sarokY,10*(meret+1)+1,20*(meret+1)+1,8,1);
 End;

 Procedure Palya;
 Const y=15;
 Var b:byte;
 Begin
  ClearScreen;
  for b:=1 to 7 do Rajzol(230,y+(b-1)*25,b,1,5);
  Keret;
  BarXOR(8,8,100,35);
  OutStrXY(10,10,'pontsz†m :0');
  OutStrXY(10,25,'szint    :');
  OutStrXY(30,90,'kîvetkezì:');
  OutStrXY(55,110,'?');
 End;

 Procedure Athelyez(xx,yy,i:byte);
 Var x,y:byte;
 Begin
  if i=0 then i:=4;
  if i=5 then i:=1;
  for y:=0 to 3 do
   for x:=0 to 3 do
    if Belul(Xp+x,Yp+y) then
     if tabla[Xp+x,Yp+y]<>0 then Bar3d(PosX(Xp+x),PosY(Yp+y),meret,meret,tabla[Xp+x,Yp+y],0)
                            else Bar(PosX(Xp+x),PosY(Yp+y),PosX(Xp+x)+meret,PosY(Yp+y)+meret,23);
  Kirak(xx,yy,alak,i);
  irany:=i;
  Xp:=xx;
  Yp:=yy;
 End;

 Procedure SorVizsgalat;
 Var b:boolean;
     db:byte;
  procedure Lejjebb(var y:shortint);
  var xx,yy:byte;
  begin
   for yy:=y downto 2 do
    for xx:=1 to 10 do tabla[xx,yy]:=tabla[xx,yy-1];
   Inc(y);
   Inc(db);
   for yy:=1 to 20 do
    for xx:=1 to 10 do
     if tabla[xx,yy]<>0 then Bar3d(PosX(xx),PosY(yy),meret,meret,tabla[xx,yy],0)
                       else Bar(PosX(xx),PosY(yy),PosX(xx)+meret,PosY(yy)+meret,23);
  end;
 Begin
  db:=0;
  for Yp:=20 downto 1 do
  begin
   b:=true;
   for Xp:=1 to 10 do if tabla[Xp,Yp]=0 then b:=false;
   if b then
   begin
    Lejjebb(Yp);
   end;
  end;
  pont:=pont+db*(100+db*20);
 End;

 Procedure Pause;
 Const x=150;
       y=80;
 Var i:longint;
     ch:char;
 Begin
  i:=szamlalo;
  Box(x,y,x+55,y+20,2);
  BarXOR(x+1,y+1,x+54,y+19);
  OutStrXY(x+14,y+6,'pauza');
  while not KeyPressed do ;
  while KeyPressed do ch:=ReadKey;
  if ch=#68 then Vege;
  start:=start+(szamlalo-i);
  Bar(x,y,x+55,y+20,0);
  UjraRajzol(false);
  Kirak(Xp,Yp,alak,irany);
 End;

 Procedure Billentyu;
 Var ch:char;
 Begin
  ch:=UpCase(ReadKey);
  case ch of #72:if Szabad(Xp,Yp,Succ(irany)) then Athelyez(Xp,Yp,succ(irany));
             #80:if Szabad(Xp,Yp,Pred(irany)) then Athelyez(Xp,Yp,pred(irany));
             #75:if Szabad(Pred(Xp),Yp,irany) then Athelyez(Pred(Xp),Yp,irany);
             #77:if Szabad(Succ(Xp),Yp,irany) then Athelyez(Succ(Xp),Yp,irany);
             #32:begin
                  while Szabad(Xp,Succ(Yp),irany) do
                  begin
                   Delay(7);
                   pont:=pont+10;
                   Athelyez(Xp,Yp+1,irany);
                  end;
                  if mozgat=false then leert:=true else idozito:=szamlalo;
                 end;
             #27:Pause;
             #68:Vege;
  end;
 End;

 Procedure Iranyit;
 Var x,y:byte;
 Begin
  halal:=false;
  pont:=0;
  for Yp:=1 to 20 do
   for Xp:=1 to 10 do tabla[Xp,Yp]:=0;
  for Xp:=1 to 7 do darab[Xp]:=0;
  start:=szamlalo;
  kovetkezo:=Succ(random(7));
  while KeyPressed do ReadKey;
  repeat
   Xp:=4;
   Yp:=0;
   alak:=kovetkezo;
   Inc(darab[alak]);
   kovetkezo:=Random(7)+1;
   irany:=1;
   leert:=false;
   speed:=(szamlalo-start) div (700)+startszint-1;
   if speed<10 then speed:=10-speed else speed:=1;
   SzintKiir;
   Statisztika;
   idozito:=szamlalo;
   if Szabad(Xp,Yp,irany)=false then Exit;
   if info then KovetkezoRajzol(kovetkezo);
   Athelyez(Xp,Yp,irany);
   repeat
    if szamlalo-idozito>=speed then
    begin
     idozito:=szamlalo;
     pont:=pont+5;
     if Szabad(Xp,Succ(Yp),irany) then Athelyez(Xp,Succ(Yp),irany) else leert:=true;
    end;
    PontKiir;
    if KeyPressed then Billentyu;
   until leert;
   for y:=0 to 3 do
    for x:=0 to 3 do
     if (maszk[alak,irany,x,y]) then tabla[Xp+x,Yp+y]:=alak;
   SorVizsgalat;
  until False;
 End;

 Procedure UjraRajzol(tobbi:boolean);
 Var x,y:byte;
 Begin
  if tobbi then
  begin
   Palya;
   oldpont:=pont+1;
   PontKiir;
   SzintKiir;
   if info then KovetkezoRajzol(alak);
   Statisztika;
  end;
  Keret;
  for y:=1 to 20 do
   for x:=1 to 10 do if tabla[x,y]<>0 then Bar3d(PosX(x),PosY(y),meret,meret,tabla[x,y],0)
                                      else Bar(PosX(x),PosY(y),PosX(x)+meret,PosY(y)+meret,23)
 End;


BEGIN
 for Yp:=1 to 20 do
  for Xp:=1 to 10 do tabla[Xp,Yp]:=0;
 if paramstr(1)='meret' then pstr:=paramstr(2);
 val(pstr,meret,oldpont);
 oldpont:=0;
 if (meret<1) or (meret>8) then meret:=8; { ÇrtÇke 1..8 lehet !!! }
 sarokX:=(319-10*(meret+1)) div 2+10;
 sarokY:=(199-20*(meret+1)) div 2+5;
 Tolt;
END.

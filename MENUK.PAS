Unit Menuk;

INTERFACE

 Var mozgat,info:boolean;

 Procedure MenuKezel;
 Procedure Vege;

IMPLEMENTATION

 Uses MyGraph,Main,Crt,MyCrt;

 Type Top10Type=record
                 nev:string[8];
                 psz:longint;
                end;
 Var aktualis:byte;
     TopTomb:array[1..10] of Top10Type;
     s:byte;
     resz:byte;

 Procedure Tolt;
 Var f:file of Top10Type;
 Begin
  Assign(f,'tetris.dat');
  {$I-}
  Reset(f);
  if IOResult<>0 then Exit;
  for s:=1 to 10 do Read(f,TopTomb[s]);
  Close(f);
  {$I+}
 End;

 Procedure Ment;
 Var f:file of Top10Type;
     ERROR:word;
 Begin
  Assign(f,'tetris.dat');
  {$I-}
  ReWrite(f);
  if IOResult<>0 then Exit;
  for s:=1 to 10 do Write(f,TopTomb[s]);
  Close(f);
  {$I+}
 End;

 Procedure Jatek;
 Begin
  if aktualis=4 then aktualis:=0;
  Palya;
  Iranyit;
  Box(116,92,210,119,3);
  BarXOR(117,93,209,118);
  OutStrXY(120,100,'    vÇged !');
  Delay(1500);
  while KeyPressed do ReadKey;
 End;

 Procedure Alapoz(x1,y1,x2,y2:word);
 Begin
  Box(x1,y1,x2,y2,2);
  BarXOR(x1+1,y1+1,x2-1,y2-1);
 End;

 Procedure HelpScreen;
 Const x=112;
       y=59;
 Begin
  aktualis:=2;
  UjraRajzol(true);
  Alapoz(x,y,x+114,y+86);
  OutStrXY(x+5,y+5,'F2 - segÇdlet:');
  OutStrXY(x+5,y+7,'_____________');
  OutStrXY(x+7,y+20,' F1: £j j†tÇk');
  OutStrXY(x+7,y+30,' F2: ez a menÅ');
  OutStrXY(x+7,y+40,' F3: top 10');
  OutStrXY(x+7,y+50,' F4: be†ll°t†sok');
  OutStrXY(x+7,y+60,' F5: billentyÄk');
  OutStrXY(x+7,y+72,'F10: kilÇpÇs');
 End;

 Procedure Top10;
 Const x=111;
       y=40;
 Var yy:byte;
     str:string;
 Begin
  aktualis:=3;
  UjraRajzol(true);
  Alapoz(x,y,x+116,y+121);
  OutStrXY(x+5,y+5,'F3 - top 10:');
  OutStrXY(x+5,y+7,'___________');
  for yy:=1 to 10 do
  begin
   if yy<10 then str:=' '+Sztring(yy)+'.'+TopTomb[yy].nev
            else str:=Sztring(yy)+'.'+TopTomb[yy].nev;
   OutStrXY(x+8,y+(yy+1)*10,str);
   OutStrXY(x+68,y+(yy+1)*10,':'+Sztring(TopTomb[yy].psz));
  end;
 End;

 Procedure Options;
 Const x=113;
       y=60;
 Begin
  if aktualis<>4 then
  begin
   aktualis:=4;
   UjraRajzol(true);
   Alapoz(x,y,x+112,y+85);
   OutStrXY(x+5,y+5,'F4 - be†ll°t†sok:');
   OutStrXY(x+5,y+7,'________________');
   OutStrXY(x+9,y+25,'kezdÇsi szint:');
   OutStrXY(x+9,y+40,'ejtÇs  ut†ni');
   OutStrXY(x+9,y+50,'mozgat†s:');
   OutStrXY(x+9,y+65,'seg°tsÇg:');
   OutStrXY(x+55,y+75,'(ò,ô,ñ,ó)');
  end;
  Bar(x+95,y+25,x+105,y+35,0);
  Bar(x+3,y+25,x+8,y+35,0);
  Bar(x+3,y+50,x+8,y+60,0);
  Bar(x+3,y+65,x+8,y+75,0);
  Bar(x+65,y+50,x+75,y+60,0);
  Bar(x+65,y+65,x+75,y+75,0);
  OutStrXY(x+95,y+25,Sztring(startszint));
  if mozgat then OutStrXY(x+65,y+50,'be') else OutStrXY(x+65,y+50,'ki');
  if info then OutStrXY(x+65,y+65,'be') else OutStrXY(x+65,y+65,'ki');
  case resz of 1:OutStrXY(x+3,y+25,'>');
               2:OutStrXY(x+3,y+50,'>');
               3:OutStrXY(x+3,y+65,'>');
  end;
 End;

 Procedure Billentyuk;
 Const x=114;
       y=60;
 Begin
  aktualis:=5;
  UjraRajzol(true);
  Alapoz(x,y,x+110,y+76);
  OutStrXY(x+5,y+5,'F5 - billentyÄk:');
  OutStrXY(x+5,y+7,'_______________');
  OutStrXY(x+7,y+20,'  ñ,ó: eltol†s');
  OutStrXY(x+7,y+30,'  ò,ô: forgat†s');
  OutStrXY(x+7,y+40,'SPACE: ejtÇs');
  OutStrXY(x+7,y+50,'  ESC: pihenì');
  OutStrXY(x+7,y+60,'  F10: kilÇpÇs');
 End;

 Procedure Menu(melyik:byte);
 Begin
  case melyik of 2:HelpScreen;
                 3:Top10;
                 4:Options;
                 5:Billentyuk;
  end;
 End;

 Procedure PontVizsgalat;
 Var hely:byte;
  function NevBeKer:string;
  const x=109;
        y=50;
  var ch:char;
      s:string[7];
      b:byte;
  begin
   UjraRajzol(true);
   Alapoz(x,y,x+120,y+70);
   OutStrXY(x+5,y+7,'   gratul†lok !');
   OutStrXY(x+5,y+20,'felkerÅltÇl a top-');
   OutStrXY(x+5,y+30,'list†ra !');
   OutStrXY(x+5,y+45,'°rd be a neved:');
   b:=0;
   s:='';
   Bar(X+40,y+55,x+80,y+65,0);
   repeat
    ch:=ReadKey;
    if (b<7) and (ord(ch)>31) then
    begin
     Inc(b);
     s:=s+ch;
    end;
    if (ch=#8) and (b>0) then
    begin
     Dec(b);
     s:=Copy(s,1,b);
    end;
    Bar(X+40,y+55,x+80,y+65,0);
    OutStrXY(x+40,y+55,s);
   until ch=#13;
   NevBeker:=s;
  end;
 Begin
  hely:=0;
  if pont<TopTomb[10].psz then Exit;
  for s:=10 downto 1 do if pont>TopTomb[s].psz then hely:=s;
  if hely<>0 then
  begin
   for s:=10 downto hely+1 do
   begin
    TopTomb[s].psz:=TopTomb[s-1].psz;
    TopTomb[s].nev:=TopTomb[s-1].nev;
   end;
   TopTomb[hely].nev:=NevBeKer;
   TopTomb[hely].psz:=pont;
  end;
  Ment;
 End;

 Procedure MenuKezel;
 Var ch:char;
     ujmenu:byte;
 Begin
  Palya;
  HelpScreen;
  resz:=1;
  repeat
   ch:=UpCase(ReadKey);
   case ch of #59:begin
                   Jatek;
                   PontVizsgalat;
                   Menu(aktualis);
                  end;
              #60:ujmenu:=2;
              #61:ujmenu:=3;
              #62:ujmenu:=4;
              #63:ujmenu:=5;
              #68:Vege;
   end;
   if aktualis=4 then
   begin
    case ch of #72:if resz>1 then Dec(resz) else resz:=3;
               #80:if resz<3 then Inc(resz) else resz:=1;
               #75:case resz of 1:if (startszint>1) then Dec(startszint);
                                2:mozgat:=mozgat=false;
                                3:info:=info=false;
                   end;
               #77:case resz of 1:if (startszint<10) then Inc(startszint);
                                2:mozgat:=mozgat=false;
                                3:info:=info=false;
                   end;
    end;
    Options;
   end;
   if aktualis<>ujmenu then Menu(ujmenu);
  until False;
 End;

 Procedure Vege;
 Begin
  if InstalledTimer then UninstallTimer;
  while KeyPressed do ReadKey;
  TextMode(c80);
  Halt;
 End;


BEGIN
 startszint:=1;
 speed:=10-startszint+1;
 mozgat:=false;
 info:=true;
 Tolt;
END.

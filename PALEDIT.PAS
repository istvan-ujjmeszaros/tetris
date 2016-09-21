Uses mygraph,crt,mycrt,main;
Var t:array[0..255,1..3] of byte;
    f:file;
    ssz:byte;
    ch:char;

Procedure Ment;
var b:byte;
Begin
 for b:=128 to 255 do
 begin
  t[b,1]:=t[255-b,1] div 3;
  t[b,2]:=t[255-b,2] div 3;
  t[b,3]:=t[255-b,3] div 3;
 end;
 Assign(f,'pal.dat');
 ReWrite(f,1);
 BlockWrite(f,t,sizeof(t));
 Close(f);
End;

Procedure Tolt;
Begin
 Assign(f,'pal.dat');
 {$I-}
 Reset(f,1);
 if IOresult=0 then
 begin
  BlockRead(f,t,sizeof(t));
  Close(f);
 end;
 {I+}
End;

Procedure Billentyu;
Begin
 ch:=upcase(ReadKey);
 case ch of '+':if ssz<127 then inc(ssz);
            '-':if ssz>0 then dec(ssz);
            '7':if t[ssz,1]<63 then inc(t[ssz,1]);
            '8':if t[ssz,2]<63 then inc(t[ssz,2]);
            '9':if t[ssz,3]<63 then inc(t[ssz,3]);
            '1':if t[ssz,1]>0 then dec(t[ssz,1]);
            '2':if t[ssz,2]>0 then dec(t[ssz,2]);
            '3':if t[ssz,3]>0 then dec(t[ssz,3]);
            'S':Ment;
            'L':Tolt;
 end;
  Bar(80,80,150,90,0);
  OutStrXY(80,80,sztring(ssz));
  OutStrXY(110,80,sztring(t[ssz,1]));
  OutStrXY(125,80,sztring(t[ssz,2]));
  OutStrXY(140,80,sztring(t[ssz,3]));
  t[255-ssz,1]:=t[ssz,1] div 3;
  t[255-ssz,2]:=t[ssz,2] div 3;
  t[255-ssz,3]:=t[ssz,3] div 3;
  SetRGBreg(255,t[ssz,1],t[ssz,2],t[ssz,3]);
  SetRGBreg(254,t[255-ssz,1],t[255-ssz,2],t[255-ssz,3]);
End;

BEGIN
 InitScreen;
 Tolt;
 InitPal;
 SetRGBreg(255,0,0,0);
 SetRGBreg(254,0,0,0);
 ssz:=0;
 OutStrXY(70,10,'paletta editor a tetris-hez');
 OutStrXY(80,80,sztring(ssz));
 OutStrXY(110,80,sztring(t[ssz,1]));
 OutStrXY(125,80,sztring(t[ssz,2]));
 OutStrXY(140,80,sztring(t[ssz,3]));
 Bar(170,80,190,90,255);
 Bar(200,80,220,90,254);
 repeat
  Billentyu;
 until ch=#27;
 TextMode(c80);
END.

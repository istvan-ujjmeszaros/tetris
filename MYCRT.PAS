Unit MyCrt;

INTERFACE

 Uses dos,crt;

 Var szamlalo          : longint;
     InstalledTimer    : boolean;

 Procedure InstallTimer;
 Procedure UninstallTimer;
 Procedure MyDelay(i:word);
 Function  Sztring(w:word):string;


IMPLEMENTATION

 Var old:procedure;

 Procedure Timer; interrupt;
 Begin
  szamlalo:=szamlalo+1;
 End;

 Procedure InstallTimer;
 Begin
  GetintVec($1C,@old);
  SetintVec($1C,addr(Timer));
  szamlalo:=0;
  InstalledTimer:=true;
 End;

 Procedure UninstallTimer;
 Begin
  SetintVec($1C,@old);
  InstalledTimer:=false;
 End;

 Procedure MyDelay(i:word);
 Var b:longint;
 Begin
  b:=szamlalo;
  while szamlalo<b+i do ;
 End;

 Function Sztring(w:word):string;
 Var s:string;
 Begin
  str(w,s);
  Sztring:=s;
 End;

BEGIN
 InstalledTimer:=false;
END.

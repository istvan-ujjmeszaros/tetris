Unit BITmuv;


INTERFACE

 Type str17=string[17];

 Function  Bit(w:word;i:byte):boolean;
 Function  Kettes(b:byte):str17;
 Procedure BitEdit(var b:byte;hanyadik:byte;mire:boolean);


IMPLEMENTATION

 Function Bit(w:word;i:byte):boolean;
 Begin
  bit:=(w shr (i-1) and 1)=1;
 End;

 Function Kettes(b:byte):str17;
 Var i:byte;
     s1:str17;
     bitv:boolean;
 Begin
  s1:='';
  for i:=16 downto 1 do
  begin
   bitv:=(b shr (i-1) and 1)=1;
   if bitv=true then s1:=s1+'1' else s1:=s1+'0';
   if i=9 then s1:=s1+' ';
  end;
  kettes:=s1;
 End;

 Procedure BitEdit(var b:byte;hanyadik:byte;mire:boolean);
 Var mivel:word;
     c:boolean;
 Begin
  mivel:=1 shl (hanyadik-1);
  c:=bit(b,hanyadik);
  case (c) of false:if mire=true then b:=b xor mivel;
              true:if mire=false then b:=b xor mivel;
  end;
 End;

END.

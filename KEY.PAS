Uses crt;
Var ch:char;

Procedure Billentyu;
Begin
 repeat
  ch:=ReadKey;
  gotoxy(31,1);
  write(ord(ch),'  ');
  gotoxy(30,1);
 until ch=#27;
End;

BEGIN
 Textmode(c80);
 Write('A lenyomott billentyÅ k¢dja : ');
 Billentyu;
END.

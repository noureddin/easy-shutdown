program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1 {, Unix, SysUtils} ;

{$R *.res}
{ // All Commented Code (expect the 'Interfaces, Line') is for the CLI,..
procedure power(action: string);
begin
//copy it from the unit :P
end;
}
begin
// Will be Added Later, Because it needs a lot of modifications
{  case LowerCase(ParamStr(1)) of
   'logout','lockscreen','shutdown','restart','suspend','hibernate':
     begin
        fpsystem('sleep ' + IntToStr(StrToInt(ParamStr(2)) * 60) + ' 2>/dev/null');
        power(ParamStr(1));
//        Application.Destroy;
     end;
  '','-exit':
    begin}
      Application.Title:='easy-shutdown';
      RequireDerivedFormResource := True;
      Application.Initialize;
      Application.CreateForm(TForm1, Form1);
      Application.Run;
//    end;
//  end;
end.


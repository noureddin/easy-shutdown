program easy_shutdown;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, GUIForm, PowerUnit, SysUtils // For Sleep()
  ;

{$R *.res}
begin
  if (ParamStr(1) <> '') and (ParamStr(1) <> '-exit') then
  begin
    try
      Sleep(StrToInt(ParamStr(2))*60*1000);
    except
      // Add more options (like HH:MM and ##h ##m ##s)
    end;
    Power(ParamStr(1));
  end
  else
  begin
    RequireDerivedFormResource := True;
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  end;
end.


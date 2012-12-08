program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unix;

{$R *.res}

procedure power(action: string);
begin
  case lowercase(action) of
  'logout': fpsystem('killall `w -f | grep tty | awk ''{print $7 }''`');
  'lockscreen': fpsystem('for i in `ls /usr/bin/*screensaver`; do if [ ! -z `pidof $i` ] ; then ${i}-command -l ; fi ;done');
  'shutdown': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop');
  'restart': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart');
  'suspend': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend');
  'hibernate': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate');
  { //for testing only
  'logout': WriteLn('Logout');
  'lockscreen': WriteLn('LockScreen');
  'shutdown': WriteLn('Shudown');
  'restart': WriteLn('Restart');
  'suspend': WriteLn('Suspend');
  'hibernate': WriteLn('Hibernate');}
  end;
end;

begin
  case LowerCase(ParamStr(1)) of
   'logout','lockscreen','shutdown','restart','suspend','hibernate':
     begin
        fpsystem('sleep ' + ParamStr(2) + ' 2>/dev/null');
        power(ParamStr(1));
//        Application.Destroy;
     end;
  '','-exit':
    begin
      Application.Title:='easy-shutdown';
      RequireDerivedFormResource := True;
      Application.Initialize;
      Application.CreateForm(TForm1, Form1);
      Application.Run;
    end;
  end;
end.


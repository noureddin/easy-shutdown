unit PowerUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils
  {$ifdef Unix} ,Unix {$endif}
  {$ifdef Windows} ,Process{$endif}
  ;
var
  spt: array [1 .. 7] of Boolean; // spt stands for supported, See TFrom1.FormCreate()
{$ifdef Windows}
  AProcess: TProcess;
{$endif}

procedure power(action: string);
procedure checkspt();
implementation

{$ifdef Windows} //This is cross-platform, but fpsystem is better with unix ;)
procedure executecmd(cmd: string);
begin
  AProcess := TProcess.Create(nil);
  AProcess.CommandLine := cmd;
  AProcess.Options := AProcess.Options + [poWaitOnExit];
  AProcess.Execute;
  AProcess.Free;
end;
{$endif}

procedure power(action: string);
begin
{$ifdef Unix}
  case lowercase(action) of
  'logout': fpsystem('killall -u $USER');
  'lockscreen': fpsystem('for i in `ls /usr/bin/*screensaver`; do if [ ! -z `pidof $i` ] ; then ${i}-command -l ; fi ;done');
  'switchuser': fpsystem('for i in `ls /usr/sbin/*dm`; do if [ ! -z "`pidof $i`" ] ; then case $i in /usr/sbin/lightdm)dm-tool switch-to-greeter;;/usr/sbin/mdm)mdmflexiserver;;/usr/sbin/gdm)gdmflexiserver;;esac;fi;done');
  'shutdown': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop');
  'restart': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart');
  'suspend': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend');
  'hibernate': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate');
  end;
{$endif}{$ifdef Windows}
  case lowercase(action) of
  'logout': executecmd('shutdown /l');
  'lockscreen': executecmd('rundll32.exe user32.dll,LockWorkStation');
  'switchuser': executecmd('');
  'shutdown': executecmd('shutdown /s');
  'restart': executecmd('shutdown /r');
  'suspend': executecmd('rundll32.exe powrprof.dll,SetSuspendState Standby');
  'hibernate': executecmd('shutdown /h');
  end;
{$endif}
end;

procedure checkspt();
begin
//Begin: Check what actions supported
//Note: 1~7 is logout, switchuser, lockscreen, shutdown, restart, suspend, hibernate (sorted)
{$ifdef Unix}
    spt[1]:=True;
    if fpsystem('for i in `ls /usr/sbin/*dm`; do if [ ! -z "`pidof $i`" ] ; then case $i in /usr/sbin/lightdm);;/usr/sbin/mdm);;/usr/sbin/gdm);;*)exit 2;;esac;fi;done') = 0 then
       spt[2]:=True;
    if fpsystem('for i in `ls /usr/bin/*screensaver`; do if [ ! -z `pidof $i` ] ; then if [ ! -e "${i}-command" ] ; then exit 2 ;fi;fi;done') = 0 then
       spt[3]:=True;
    spt[4]:=True;
    spt[5]:=True;
    spt[6]:=True;
    spt[7]:=True;
{$endif}
{$ifdef Windows}
    spt[1]:=True;
    if 1 = 0 then
       spt[2]:=True;
//    if fpsystem('') = 0 then
       spt[3]:=True;
    spt[4]:=True;
    spt[5]:=True;
    spt[6]:=True;
    spt[7]:=True;
{$endif}

//End
end;

end.


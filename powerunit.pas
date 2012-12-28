unit PowerUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unix;
var
  Spt: array [1 .. 7] of Boolean; // Spt stands for Supported

procedure Power(action: string);
procedure CheckSpt();
implementation

procedure Power(action: string);
begin
  Case lowercase(action) of
    'logout': fpsystem('killall -u $USER');
    'lockscreen': fpsystem('for i in `ls /usr/bin/*screensaver`; do if [ ! -z `pidof $i` ] ; then ${i}-command -l ; fi ;done');
    'switchuser': fpsystem('for i in `ls /usr/sbin/*dm`; do if [ ! -z "`pidof $i`" ] ; then case $i in /usr/sbin/lightdm)dm-tool switch-to-greeter;;/usr/sbin/mdm)mdmflexiserver;;/usr/sbin/gdm)gdmflexiserver;;esac;fi;done');
    'shutdown': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop');
    'restart': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart');
    'suspend': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend');
    'hibernate': fpsystem('dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate');
  end;
end;

procedure CheckSpt();
begin
//Begin: Check what actions are supported
//Note: 1~7 is logout, switchuser, lockscreen, shutdown, restart, suspend, hibernate (sorted)
  Spt[1]:=True;
  if fpsystem('for i in `ls /usr/sbin/*dm`; do if [ ! -z "`pidof $i`" ] ; then case $i in /usr/sbin/lightdm);;/usr/sbin/mdm);;/usr/sbin/gdm);;*)exit 2;;esac;fi;done') = 0 then
     Spt[2]:=True;
  if fpsystem('for i in `ls /usr/bin/*screensaver`; do if [ ! -z `pidof $i` ] ; then if [ ! -e "${i}-command" ] ; then exit 2 ;fi;fi;done') = 0 then
     Spt[3]:=True;
  Spt[4]:=True;
  Spt[5]:=True;
  Spt[6]:=True;
  Spt[7]:=True;
//End
end;

end.


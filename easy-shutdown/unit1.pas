unit Unit1;

{$mode objfpc}{$H+}

{ Licence: GNU GPL }
{ The Four Actions (Shutdown, Restart, Suspend, Hibernate) were taken from:
      https://gist.github.com/988104
}
{TODO:

SwitchUser support
Windows Support
Internationalization (Be MultiLingual)
Add a Time bar (to show how much remain)
Add an 'About' and 'LanguageSetting' Screens
Support Pressing ESC to Exit
Improve the Icon ;)

}
{ After Compiling: do 'strip' and 'upx' to make it smaller }
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, ComCtrls, Buttons, Unix;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MyPopUpMenu: TPopupMenu;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    SysTrayIcon: TTrayIcon;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1KeyUp(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure SysTrayIconClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  job: string;
  i: integer;
implementation

{$R *.lfm}

{ TForm1 }

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
  'logout': showmessage('Logout');
  'lockscreen': showmessage('LockScreen');
  'shutdown': showmessage('Shudown');
  'restart': showmessage('Restart');
  'suspend': showmessage('Suspend');
  'hibernate': showmessage('Hibernate');}
  end;
end;

{procedure PressBtn(action: string); // Causes errors
begin
try
    if (ComboBox2.text <> '') and (strtofloat(ComboBox2.Text)<> 0) then
    begin
      Timer1.Enabled:=true;
      Timer1.Interval:=strtoint(floattostr(strtofloat(ComboBox2.Text) * 60000));
      job:=action;
    end
    else
      power(action);

      Hide;
    SysTrayIcon.Show;

except
    showmessage('Please, Enter a Number!');
    combobox2.SetFocus;
end;
end;}
{procedure comboauto(combo, key: string); //ComboBoxAutoComplete
begin
     comb
end;
 }
procedure TForm1.Button1Click(Sender: TObject);
begin
   case combobox1.text of
    'Logout','LockScreen','Shutdown','Restart','Suspend','Hibernate':
     begin
      try
//          PressBtn(ComboBox1.Text);
    if (ComboBox2.text <> '') and (strtofloat(ComboBox2.Text)<> 0) then
    begin
      Timer1.Enabled:=true;
      Timer1.Interval:=strtoint(floattostr(strtofloat(ComboBox2.Text) * 60000));
      job:=ComboBox1.Text;
      Hide;
      SysTrayIcon.Show;
    end
    else
    begin
      power(ComboBox1.Text);
      Close;
    end;

      except
          ShowMessage('Please, Enter a Number!');
          ComboBox2.SetFocus;
end;
     end
   else
        ShowMessage('Please, Choose want you want to do!');
        ComboBox1.SetFocus;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
//       PressBtn('Shutdown');
         ComboBox1.Text:='Shutdown';
         Button1Click(Button1)
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  //     PressBtn('Restart');
         ComboBox1.Text:='Restart';
         Button1Click(Button1)
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
    //    PressBtn('Logout');
          ComboBox1.Text:='Logout';
          Button1Click(Button1)
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
      //PressBtn('Suspend');
        ComboBox1.Text:='Suspend';
        Button1Click(Button1)
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
//      PressBtn('Hibernate');
        ComboBox1.Text:='Hibernate';
        Button1Click(Button1)
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  //    PressBtn('LockScreen');
        ComboBox1.Text:='LockScreen';
        Button1Click(Button1)
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   Close;
end;
procedure TForm1.ComboBox1KeyUp(Sender: TObject);
begin
  case lowercase(copy(combobox1.Text,1,3)) of
       'log':
         combobox1.text:='Logout';
       'loc':
         combobox1.text:='LockScreen';
       'sh','shu':
         combobox1.Text:='Shutdown';
       'r','re','res':
         combobox1.text:='Restart';
       'su','sus':
         combobox1.text:='Suspend';
       'h','hi','hib':
         combobox1.text:='Hibernate';
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
     if ParamStr(1) = '' then
        ComboBox1.SetFocus;
     for i in [1,2,3,5,7,10,15,20,30,40,45,60] do
             combobox2.AddItem(inttostr(i),combobox2);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
      case ParamStr(1) of
           '-exit':
           begin
            BorderStyle:=bsNone;
            ComboBox1.Visible:=False;
            Button1.Visible:=False;
            Button2.Top:=224;
            Button2.Left:=264;
            Height:=264;
            Width:=375;
            BitBtn1.Visible:=True;
            BitBtn2.Visible:=True;
            BitBtn3.Visible:=True;
            BitBtn4.Visible:=True;
            BitBtn5.Visible:=True;
            BitBtn6.Visible:=True;
            Label1.Left:=40;
            ComboBox2.Left:=69;
            Label2.Left:=154;
            Label1.Top:=229;
            ComboBox2.Top:=224;
            Label2.Top:=229;
           end;
      end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
     Show;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
     Close;
end;

procedure TForm1.SysTrayIconClick(Sender: TObject);
begin
     case Visible of
          True:
            Hide;
          False:
            Show;
     end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  power(job);
  Close;
end;

end.

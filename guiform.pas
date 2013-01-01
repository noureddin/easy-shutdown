unit GUIForm;

{$mode objfpc}{$H+}

{ Licence: GNU GPL }

{ The Four Actions (Shutdown, Restart, Suspend, Hibernate) were taken from:
      https://gist.github.com/988104

  The Action Images were taken from 'BRIT ICONS' icons set.
}

{TODO:

When type in the combobox and it completes what typed, Don't move the pointer to the beginning. (done)
Windows Support (Remeved Utterly)
Internationalization (Be MultiLingual) (began)
Add a Time bar (to show how much remain)
Add an 'About' and 'LanguageSetting' Screens
CLI Support (userpower is enough ;) ) (not yet finished)
Support 'Stop and Close' in CLI when pressing ^C , ^X or ... (done until now)
Improve the Icon ;) (slightly done)
Show the tray popup menu above the bar not over it (works well in windows!)
Remote Control (needs server)
Support delaying to time (like: shutdown at 8:00 am) (done)
Support Scheduling (like: shutdown everyday at 10:00 pm) (needs to be autostart)
}

{ After Compiling on Unix: do 'strip' and 'upx' to make it smaller }

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, ComCtrls, Buttons, MaskEdit, PowerUnit;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MyPopUpMenu: TPopupMenu;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Timer1: TTimer;
    SysTrayIcon: TTrayIcon;
    Timer2: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MaskEdit1Change(Sender: TObject);
    procedure MaskEdit2Change(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure SysTrayIconClick(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
{ // For Translating (Not ready yet)
resourcestring
  title='Easy Shutdown';
  hour='h';
  minute='m';
  second='s';
  pleasechose='Please, Choose want you want to do!';
  logout='Logout';
  switchuser='SwitchUser';
  lockscreen='LockScreen';
  shutdown='Shutdown';
  restart='Restart';
  suspend='Suspend';
  hibernate='Hibernate';
  wait='Wait';
  waituntil='Wait until';
  hour24='(24-hour)';
  selectaction='Select action to do ..';
  ok='OK';
  cancel='Cancel';
  show='Show';
  stopclose='Stop and Close';
}
var
  Form1: TForm1;
  job: string;
  D: TDateTime;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var Str:String; hh:Integer; nn:Integer;
begin
  case LowerCase(ComboBox1.Text) of
    'logout', 'switchuser', 'lockscreen', 'shutdown', 'restart', 'suspend', 'hibernate':
    begin
      if RadioButton1.Checked = True then // If First is Checked
      begin
        if Copy(MaskEdit1.Text, 1, 2) + Copy(MaskEdit1.Text, 5, 2) + Copy(MaskEdit1.Text, 9, 2) <>
          '      ' then
        begin
          Timer1.Enabled := True;
          Str:= StringReplace(MaskEdit1.Text, ' ', '0', [rfReplaceAll]);
          Timer1.Interval :=
            (StrToInt(Copy(Str, 1, 2)) * 60 * 60 * 1000) +
            (StrToInt(Copy(Str, 5, 2)) * 60 * 1000) +
            (StrToInt(Copy(Str, 9, 2)) * 1000);
          job := ComboBox1.Text;
          Hide;
          SysTrayIcon.Show;
        end
        else
        begin
          Power(ComboBox1.Text);
          Close;
        end;
      end
      else // If Second is Checked
      begin
        if Copy(MaskEdit2.Text, 1, 2) + Copy(MaskEdit1.Text, 4, 2) <> '    ' then
        begin
          Timer1.Enabled := True;
          Str := StringReplace(MaskEdit2.Text, ' ', '0', [rfReplaceAll]);
          hh := (StrToInt(Copy(Str, 1, 2)) - StrToInt(FormatDateTime('hh', Time)));
          nn := (StrToInt(Copy(Str, 4, 2)) - StrToInt(FormatDateTime('nn', Time)));
          if hh < 0 then
            hh := hh + 24;
          if nn < 0 then
            nn := nn + 60;
          Timer1.Interval:= (hh * 60 * 60 * 1000) + (nn * 60 * 1000);
          job := ComboBox1.Text;
          Hide;
          SysTrayIcon.Show;
        end
        else
        begin
          Power(ComboBox1.Text);
          Close;
        end;
      end;
    end
    else
      ShowMessage('Please, Choose want you want to do!');
      ComboBox1.SetFocus;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  ComboBox1.Text := 'Shutdown';
  Button1Click(Button1);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  ComboBox1.Text := 'Restart';
  Button1Click(Button1);
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  ComboBox1.Text := 'Logout';
  Button1Click(Button1);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  ComboBox1.Text := 'Suspend';
  Button1Click(Button1);
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  ComboBox1.Text := 'Hibernate';
  Button1Click(Button1);
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  ComboBox1.Text := 'SwitchUser';
  Button1Click(Button1);
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
begin
  ComboBox1.Text := 'LockScreen';
  Button1Click(Button1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if ParamStr(1) = '' then
  begin
    ComboBox1.SetFocus;
    if Spt[1] = True then
      ComboBox1.AddItem('Logout', Self);
    if Spt[2] = True then
      ComboBox1.AddItem('SwitchUser', Self);
    if Spt[3] = True then
      ComboBox1.AddItem('LockScreen', Self);
    if Spt[4] = True then
      ComboBox1.AddItem('Shutdown', Self);
    if Spt[5] = True then
      ComboBox1.AddItem('Restart', Self);
    if Spt[6] = True then
      ComboBox1.AddItem('Suspend', Self);
    if Spt[7] = True then
      ComboBox1.AddItem('Hibernate', Self);
  end;
  RadioButton1.Checked := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CheckSpt();
  case LowerCase(ParamStr(1)) of
    '-exit':
    begin
      BorderStyle := bsNone;
      ComboBox1.Visible := False;
      Button1.Visible := False;
      Button2.Top := 203;      Button2.Left := 280;
      Button2.Width := 91;
      Height := 240;           Width := 408;
      MaskEdit1.Top := 176;
      MaskEdit2.Top := 203;
      RadioButton1.Top := 176;
      RadioButton2.Top := 203;
      Label1.Top := 206;
      BitBtn1.Visible := True;
      BitBtn2.Visible := True;
      BitBtn3.Visible := True;
      BitBtn4.Visible := True;
      BitBtn5.Visible := True;
      BitBtn6.Visible := True;
      BitBtn7.Visible := True;
      // Enable supported and disable unspported
                                 // Bit Spt
      BitBtn1.Enabled := Spt[4]; // shu log
      BitBtn2.Enabled := Spt[5]; // res swi
      BitBtn3.Enabled := Spt[1]; // log loc
      BitBtn4.Enabled := Spt[6]; // sus shu
      BitBtn5.Enabled := Spt[7]; // hib res
      BitBtn6.Enabled := Spt[2]; // swi sus
      BitBtn7.Enabled := Spt[3]; // loc hib
    end;
  end;
//  Left := (Screen.Width - Width) div 2;
//  Top := (Screen.Height - Height) div 2;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = 27 then { 27 refers to ESCAPE, See VK_ESCAPE in LCLType }
    Close;
end;

procedure TForm1.MaskEdit1Change(Sender: TObject);
begin
  RadioButton1.Checked := True;
end;

procedure TForm1.MaskEdit2Change(Sender: TObject);
begin
  RadioButton2.Checked := True;
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

procedure TForm1.Timer1StartTimer(Sender: TObject);
begin
  //  d:=now();
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Power(job);
  Close;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  //    ProgressBar1.position:=Timer1.Interval { past time - interval (gives remain) / interval (gives the percentage for the remain) * 100 ( to convert .5 to 50) [ and all toInt() ;) ]
end;

end.

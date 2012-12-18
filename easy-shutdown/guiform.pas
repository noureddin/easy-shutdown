unit GUIForm;

{$mode objfpc}{$H+}

{ Licence: GNU GPL }

{ The Four Actions (Shutdown, Restart, Suspend, Hibernate) were taken from:
      https://gist.github.com/988104

  The Action Images were taken from 'BRIT ICONS' icons set.
}

{TODO:

When type in the combobox and it completes what typed, Don't move the pointer to the beginning.
Windows Support (not finished yet)
Internationalization (Be MultiLingual)
Add a Time bar (to show how much remain)
Add an 'About' and 'LanguageSetting' Screens
CLI Support
Support 'Stop and Close' in CLI when pressing ^C , ^X or ...
Improve the Icon ;)
Show the tray popup menu above the bar not over it
Remote Control
Support delaying to time (like: shutdown at 8:00 am)
Support Scheduling (like: shutdown everyday at 10:00 pm)

}

{ After Compiling: do 'strip' and 'upx' to make it smaller }

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, ComCtrls, Buttons, PowerUnit;

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
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MyPopUpMenu: TPopupMenu;
    ProgressBar1: TProgressBar;
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
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word);
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

var
  Form1: TForm1;
  job: string;
  i: integer;
  D: TDateTime;
implementation

{$R *.lfm}

{ TForm1 }



{procedure comboauto(combo, key: string); // ComboBoxAutoComplete Procedure
begin

end;}

procedure TForm1.Button1Click(Sender: TObject);
begin
   case LowerCase(ComboBox1.Text) of
    'logout','switchuser','lockscreen','shutdown','restart','suspend','hibernate':
     begin
      try
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
         ComboBox1.Text:='Shutdown';
         Button1Click(Button1);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
         ComboBox1.Text:='Restart';
         Button1Click(Button1);
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
          ComboBox1.Text:='Logout';
          Button1Click(Button1);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
        ComboBox1.Text:='Suspend';
        Button1Click(Button1);
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
        ComboBox1.Text:='Hibernate';
        Button1Click(Button1);
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
     ComboBox1.Text:='SwitchUser';
     Button1Click(Button1);
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
begin
     ComboBox1.Text:='LockScreen';
     Button1Click(Button1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   Close;
end;

procedure TForm1.ComboBox1KeyUp(Sender: TObject; var Key: Word);
begin
  case LowerCase(Copy(ComboBox1.Text,1,3)) of
       'log':
         ComboBox1.Text:='Logout';
       'sw','swi':
         if spt[2] then
            ComboBox1.Text:='SwitchUser';
       'loc':
         if spt[3] then
            ComboBox1.Text:='LockScreen';
       'sh','shu':
         ComboBox1.Text:='Shutdown';
       'r','re','res':
         ComboBox1.Text:='Restart';
       'su','sus':
         ComboBox1.Text:='Suspend';
       'h','hi','hib':
         ComboBox1.Text:='Hibernate';
  end;
  if Key = 27 then { 27 refers to ESCAPE, See VK_ESCAPE in LCLType }
     Close;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
     if ParamStr(1) = '' then
     begin
          ComboBox1.SetFocus;
          ComboBox1.AddItem('Logout',ComboBox1);
          if spt[2] = True then
                    ComboBox1.AddItem('SwitchUser',ComboBox1);
          if spt[3] = True then
                    ComboBox1.AddItem('LockScreen',ComboBox1);
          ComboBox1.AddItem('Shutdown',ComboBox1);
          ComboBox1.AddItem('Restart',ComboBox1);
          ComboBox1.AddItem('Suspend',ComboBox1);
          ComboBox1.AddItem('Hibernate',ComboBox1);
     end;
     for i in [1,2,3,5,7,10,15,20,30,40,45,60] do
             ComboBox2.AddItem(inttostr(i),ComboBox2);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  checkspt();
  case ParamStr(1) of
     '-exit':
     begin
      BorderStyle:=bsNone;
      ComboBox1.Visible:=False;
      Button1.Visible:=False;
      Button2.Top:=229;
      Button2.Left:=280;
      Button2.Width:=91;
      Height:=264;
      Width:=392;
      BitBtn1.Visible:=True;
      BitBtn2.Visible:=True;
      BitBtn3.Visible:=True;
      BitBtn4.Visible:=True;
      BitBtn5.Visible:=True;
      BitBtn6.Visible:=True;
      if spt[2] = True then
           BitBtn6.Enabled:=True;
      BitBtn7.Visible:=True;
      if spt[3] = True then
           BitBtn7.Enabled:=True;
      Label1.Left:=40;
      ComboBox2.Left:=69;
      Label2.Left:=154;
      Label1.Top:=229;
      ComboBox2.Top:=224;
      Label2.Top:=229;
     end;
  end;
  Left:=(Screen.Width - Width) Div 2;
  Top:=(Screen.Height - Height) Div 2;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word);
begin
  if Key = 27 then { 27 refers to ESCAPE, See VK_ESCAPE in LCLType }
   Close;
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

  Timer1.Enabled:=False;
  power(job);
  Close;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
//    ProgressBar1.position:=Timer1.Interval { past time - interval (gives remain) / interval (gives the percentage for the remain) * 100 ( to convert .5 to 50) [ and all toInt() ;) ]
end;

end.


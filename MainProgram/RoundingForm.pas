unit RoundingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TfRoundingForm = class(TForm)
    sePosition: TSpinEdit;
    seVelocity: TSpinEdit;
    seAcceleration: TSpinEdit;
    lblPosition: TLabel;
    lblVelocity: TLabel;
    lblAcceleration: TLabel;
    btnAccept: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fRoundingForm: TfRoundingForm;

implementation

{$R *.dfm}

uses
  MainForm;

procedure TfRoundingForm.FormShow(Sender: TObject);
begin
sePosition.Value := fMainForm.Settings.Rounding.Position;
seVelocity.Value := fMainForm.Settings.Rounding.Velocity;
seAcceleration.Value := fMainForm.Settings.Rounding.Acceleration;
end;

//------------------------------------------------------------------------------

procedure TfRoundingForm.btnAcceptClick(Sender: TObject);
begin
fMainForm.Settings.Rounding.Position := sePosition.Value;
fMainForm.Settings.Rounding.Velocity := seVelocity.Value;
fMainForm.Settings.Rounding.Acceleration := seAcceleration.Value;
Close;
end;

end.

unit ColorsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  MainForm;

type
  TfColorsForm = class(TForm)
    dColors: TColorDialog;
    lblLoadPresetColors: TLabel;
    cbPresets: TComboBox;
    lblBackground: TLabel;
    pnlBackground: TPanel;
    lblHints: TLabel;
    pnlHints: TPanel;
    lblOriginCross: TLabel;
    pnlOriginCross: TPanel;
    lblFocusCross: TLabel;
    pnlFocusCross: TPanel;
    lblSelectRect: TLabel;
    pnlSelectRect: TPanel;
    lblOrbitTrails: TLabel;
    pnlOrbitTrails: TPanel;
    btnApply: TButton;
    btnAccept: TButton;
    procedure FormShow(Sender: TObject);
    procedure cbPresetsChange(Sender: TObject);
    procedure pnlBackgroundClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);    
    procedure btnAcceptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadColors(Colors: TSettings_Colors);
  end;

var
  fColorsForm: TfColorsForm;

implementation

{$R *.dfm}

procedure TfColorsForm.LoadColors(Colors: TSettings_Colors);
begin
pnlBackground.Color := Colors.Background;
pnlHints.Color := Colors.Hints;
pnlOriginCross.Color := Colors.OriginCross;
pnlFocusCross.Color := Colors.FocusCross;
pnlSelectRect.Color := Colors.SelectRect;
pnlOrbitTrails.Color := Colors.OrbitTrails;
end;

//==============================================================================

procedure TfColorsForm.FormShow(Sender: TObject);
begin
LoadColors(fMainForm.Settings.Colors);
end;

//------------------------------------------------------------------------------

procedure TfColorsForm.cbPresetsChange(Sender: TObject);
begin
case cbPresets.ItemIndex of
  0:  LoadColors(def_Settings_Colors_White);
  1:  LoadColors(def_Settings_Colors_Black);
end;
end;

//------------------------------------------------------------------------------

procedure TfColorsForm.pnlBackgroundClick(Sender: TObject);
begin
If Sender is TPanel then
  begin
    dColors.Color := TPanel(Sender).Color;
    If dColors.Execute then
      TPanel(Sender).Color := dColors.Color;
  end;
end;

//------------------------------------------------------------------------------

procedure TfColorsForm.btnApplyClick(Sender: TObject);
begin
fMainForm.Settings.Colors.Background := pnlBackground.Color;
fMainForm.Settings.Colors.Hints := pnlHints.Color;
fMainForm.Settings.Colors.OriginCross := pnlOriginCross.Color;
fMainForm.Settings.Colors.FocusCross := pnlFocusCross.Color;
fMainForm.Settings.Colors.SelectRect := pnlSelectRect.Color;
fMainForm.Settings.Colors.OrbitTrails := pnlOrbitTrails.Color;
fMainForm.DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfColorsForm.btnAcceptClick(Sender: TObject);
begin
btnApply.OnClick(nil);
Close;
end;

end.

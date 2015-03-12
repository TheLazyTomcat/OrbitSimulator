unit InfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfInfoForm = class(TForm)
    lblName: TLabel;
    shpColor1: TShape;
    shpColor2: TShape;
    shpColor3: TShape;
    lblMassC: TLabel;
    lblMass: TLabel;
    lblReducedMassC: TLabel;
    lblReducedMass: TLabel;
    lblRadiusC: TLabel;
    lblRadius: TLabel;
    lblPeriapsisC: TLabel;
    lblPeriapsis: TLabel;
    lblApoapsisC: TLabel;
    lblApoapsis: TLabel;
    lvlSemiMajorAxisC: TLabel;
    lblSemiMajorAxis: TLabel;
    lblEccentricityC: TLabel;
    lblEccentricity: TLabel;
    lblInclinationC: TLabel;
    lblInclination: TLabel;
    lblOrbitalPeriodC: TLabel;
    lblOrbitalPeriod: TLabel;
    lblApAVelocityC: TLabel;
    lblApAVelocity: TLabel;
    lblPeAVelocityC: TLabel;
    lblPeAVelocity: TLabel;
    lblMeanVelocityC: TLabel;
    lblMeanVelocity: TLabel;
    lblOrbitsC: TLabel;
    lblOrbits: TLabel;
    lblPerturbatingBodies: TLabel;
    mePerturbatingBodies: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fInfoForm: TfInfoForm;

implementation

uses Math, MainForm, BodiesInfo;

{$R *.dfm}

procedure TfInfoForm.FormShow(Sender: TObject);
var
  i:        Integer;
  TempStr:  String;
begin
If fMainForm.lbBodies.ItemIndex >= 0 then
  begin
    with PBodyInfo(fMainForm.OrbitalSystem.Bodies[fMainForm.lbBodies.ItemIndex].Data)^ do
      begin
        lblName.Caption := Name;
        shpColor1.Brush.Color := DrawInfo.Color1;
        shpColor2.Brush.Color := DrawInfo.Color2;
        shpColor3.Brush.Color := DrawInfo.Color3;
        lblMass.Caption := FloatToStr(Mass);
        lblReducedMass.Caption := FloatToStr(ReducedMass);
        lblRadius.Caption := FloatToStr(Radius / 1000);
        lblPeriapsis.Caption := FloatToStr(Periapsis / 1000);
        lblApoapsis.Caption := FloatToStr(Apoapsis / 1000);
        lblSemiMajorAxis.Caption := FloatToStr(SemiMajorAxis / 1000);
        lblEccentricity.Caption := FloatToStr(Eccentricity);
        lblInclination.Caption := FloatToStr(Inclination);
        lblOrbitalPeriod.Caption := FloatToStr(RoundTo(OrbitalPeriod / 86400,-6));
        lblPeAVelocity.Caption := FloatToStr(PeAOrbitalVelocity);
        lblApAVelocity.Caption := FloatToStr(ApAOrbitalVelocity);
        lblMeanVelocity.Caption := FloatToStr(MeanOrbitalVelocity);
      end;
    If Assigned(fMainForm.OrbitalSystem.Bodies[fMainForm.lbBodies.ItemIndex].CenterBody) then
      lblOrbits.Caption := fMainForm.OrbitalSystem.Bodies[fMainForm.lbBodies.ItemIndex].CenterBody.Name
    else
      lblOrbits.Caption := 'n/e';
    TempStr := '';
    For i := 0 to Pred(fMainForm.OrbitalSystem.Bodies[fMainForm.lbBodies.ItemIndex].InteractingBodiesCount) do
      begin
        TempStr := TempStr + fMainForm.OrbitalSystem.Bodies[fMainForm.lbBodies.ItemIndex].InteractingBodies[i].Name;
        If i < Pred(fMainForm.OrbitalSystem.Bodies[fMainForm.lbBodies.ItemIndex].InteractingBodiesCount) then
          TempStr := TempStr + ', ';
      end;
    mePerturbatingBodies.Text := TempStr;
  end;
end;

end.

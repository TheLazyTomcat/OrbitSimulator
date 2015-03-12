program OrbitSimulator;

uses
  Forms,
  MainForm in 'MainForm.pas' {fMainForm},
  OrbitalSystem in 'OrbitalSystem.pas',
  BodiesInfo in 'BodiesInfo.pas',
  RoundingForm in 'RoundingForm.pas' {fRoundingForm},
  ColorsForm in 'ColorsForm.pas' {fColorsForm},
  InfoForm in 'InfoForm.pas' {fInfoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Orbit Simulator';
  Application.CreateForm(TfMainForm, fMainForm);
  Application.CreateForm(TfRoundingForm, fRoundingForm);
  Application.CreateForm(TfColorsForm, fColorsForm);
  Application.CreateForm(TfInfoForm, fInfoForm);
  Application.Run;
end.

unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XPMan,
  OrbitalSystem;

type
  TSettings_Rounding = record
    Position:     Integer;
    Velocity:     Integer;
    Acceleration: Integer;
  end;

  TSettings_Colors = record
    Background:   TColor;
    Hints:        TColor;
    OriginCross:  TColor;
    FocusCross:   TColor;
    SelectRect:   TColor;
    OrbitTrails:  TColor;
  end;

  TSettings_Rendering = record
    RenderingPlane: Integer;
    Hints:          Boolean;
    OriginCross:    Boolean;
    FocusCross:     Boolean;
    SelectRect:     Boolean;
    OrbitTrails:    Boolean;
    BodiesFirst:    Boolean;
  end;

  TSettings = record
    FocusedBodyIdx: Integer;
    ListVector:     Integer;
    Rounding:       TSettings_Rounding;
    SimTimeStep:    Integer;
    TimeWarp:       Integer;
    AnimFreq:       Integer;
    Colors:         TSettings_Colors;
    Rendering:      TSettings_Rendering;
    UserZoom:       Boolean;
    UserZoomRadius: Extended;
  end;

const
  init_FocusPoint: TVector3e = (0.0,0.0,0.0);
  init_ZoomRadius: Extended = 2e11;

  cOrbitTrailLength = 0.75;

  def_Settings_Rounding: TSettings_Rounding = (
    Position:     -1;
    Velocity:     -6;
    Acceleration: -10;
  );

  def_Settings_Rendering: TSettings_Rendering = (
    Hints:        True;
    OriginCross:  True;
    FocusCross:   True;
    SelectRect:   True;
    OrbitTrails:  True;
    BodiesFirst:  False;
  );

  def_Settings_Colors_White: TSettings_Colors = (
    Background:   clWhite;
    Hints:        clBlack;
    OriginCross:  clSilver;
    FocusCross:   clSilver;
    SelectRect:   clBlack;
    OrbitTrails:  clSilver;
  );

  def_Settings_Colors_Black: TSettings_Colors = (
    Background:   clBlack;
    Hints:        clWhite;
    OriginCross:  clSilver;
    FocusCross:   clSilver;
    SelectRect:   clWhite;
    OrbitTrails:  clSilver;
  );

type
  TfMainForm = class(TForm)
    btnStartStop: TButton;
    lblPresetSystem: TLabel;
    cbPresetSystem: TComboBox;
    lblBodies: TLabel;
    lbBodies: TListBox;
    rgShownVector: TRadioGroup;
    btnFocusOrigin: TButton;
    btnRounding: TButton;
    btnAddBody: TButton;
    btnRemoveBody: TButton;
    gbBodyInfo: TGroupBox;
    lblName: TLabel;
    lblIdentifier: TLabel;
    shpColor1: TShape;
    shpColor2: TShape;
    shpColor3: TShape;
    lblMassC: TLabel;
    lblMass: TLabel;
    lblPerturbatiosC: TLabel;
    lblPerturbations: TLabel;
    btnMoreInfo: TButton;    
    lblPositionC: TLabel;
    lblPosition: TLabel;
    lblVelocityC: TLabel;
    lblVelocity: TLabel;
    lblAccelerationC: TLabel;
    lblAcceleration: TLabel;
    gbSpeeds: TGroupBox;
    lblSimStep: TLabel;
    tbSimStep: TTrackBar;
    eSimStep: TEdit;
    lblTimeWarp: TLabel;
    tbTimeWarp: TTrackBar;
    eTimeWarp: TEdit;
    lblAnimationFrequency: TLabel;
    tbAnimationFrequency: TTrackBar;
    eAnimationFrequency: TEdit;
    gbRenderingSettings: TGroupBox;
    cbRenderHints: TCheckBox;
    cbRenderBodiesFirst: TCheckBox;
    cbRenderOriginCross: TCheckBox;
    cbRenderFocusCross: TCheckBox;
    cbRenderSelectRect: TCheckBox;
    cbRenderOrbitTrails: TCheckBox;
    btnColors: TButton;
    lblRenderPlane: TLabel;
    cbRenderingPlane: TComboBox;
    cbUserZoom: TCheckBox;
    tbZoomFactor: TTrackBar;
    eZoomFactor: TEdit;
    imgMainImage: TImage;
    bvlVertSplit: TBevel;
    tmrAnimTimer: TTimer;
    tmrSimTimer: TTimer;
    oXPManifest: TXPManifest;
    sbStatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
    procedure lbBodiesClick(Sender: TObject);
    procedure lbBodiesDblClick(Sender: TObject);
    procedure lbBodiesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure rgShownVectorClick(Sender: TObject);
    procedure btnFocusOriginClick(Sender: TObject);
    procedure btnRoundingClick(Sender: TObject);
    procedure btnAddBodyClick(Sender: TObject);
    procedure btnRemoveBodyClick(Sender: TObject);
    procedure btnMoreInfoClick(Sender: TObject);    
    procedure tbSimStepChange(Sender: TObject);
    procedure tbTimeWarpChange(Sender: TObject);
    procedure tbAnimationFrequencyChange(Sender: TObject);
    procedure cbRenderHintsClick(Sender: TObject);
    procedure btnColorsClick(Sender: TObject);
    procedure cbRenderingPlaneChange(Sender: TObject);
    procedure cbUserZoomClick(Sender: TObject);
    procedure tbZoomFactorChange(Sender: TObject);
    procedure tmrAnimTimerTimer(Sender: TObject);
    procedure tmrSimTimerTimer(Sender: TObject);
    procedure cbPresetSystemChange(Sender: TObject);
  private
    { Private declarations }
  public
    OrbitalSystem:  TOrbitalSystem;
    Settings:       TSettings;
    procedure BodyInit(Sender: TObject; Body: TBody);
    procedure BodyFinal(Sender: TObject; Body: TBody);
    procedure InitializeSystem(SystemNumber: Integer);
    procedure UpdateInfo;
    procedure DrawImage;
  end;

var
  fMainForm: TfMainForm;

implementation

{$R *.dfm}

uses
  Math, BodiesInfo, RoundingForm, ColorsForm, InfoForm;

//******************************************************************************

procedure TfMainForm.BodyInit(Sender: TObject; Body: TBody);
begin
Body.Data := AllocMem(SizeOf(TBodyInfo));
end;

procedure TfMainForm.BodyFinal(Sender: TObject; Body: TBody);
begin
Dispose(PBodyInfo(Body.Data));
end;

//==============================================================================

procedure TfMainForm.InitializeSystem(SystemNumber: Integer);
var
  i:        Integer;
  Sun:      TBody;
  Earth:    TBody;
  Mars:     TBody;
  Jupiter:  TBody;
  Saturn:   TBody;
  Neptune:  TBody;
  Pluto:    TBody;

  Function AddBodyToSystem(CenterBody: TBody; BodyInfo: TBodyInfo): TBody;
  begin
    Result := OrbitalSystem.AddBody(CenterBody,BodyInfo.ReducedMass,Vector3e(BodyInfo.Periapsis,0,0),Vector3e(0,0,-BodyInfo.PeAOrbitalVelocity));
    Result.Name := BodyInfo.Name;
    PBodyInfo(Result.Data)^ := BodyInfo;
    If Assigned(CenterBody) then
      Result.TrailTime := Round(BodyInfo.OrbitalPeriod * cOrbitTrailLength)
    {$message 'todo: inclination, proper initial position and velocity'}  
  end;

  procedure PrepareSystem_000;  (* Empty *)
  begin
  end;

  procedure PrepareSystem_001;  (* Sun - Earth *)
  begin
    Sun := AddBodyToSystem(nil,cSunInfo);
    PBodyInfo(Sun.Data)^.DrawInfo.ZoomRadius := 200000000000;    
    Earth := AddBodyToSystem(Sun,cEarthInfo);
  end;

  procedure PrepareSystem_002;  (* Sun - Earth - Moon *)
  begin
    PrepareSystem_001;
    PBodyInfo(Earth.Data)^.DrawInfo.ZoomRadius := 500000000;    
    AddBodyToSystem(Earth,cMoonInfo);
  end;

  procedure PrepareSystem_003;  (* Earth - Moon *)
  begin
    Earth := AddBodyToSystem(nil,cEarthInfo);
    Earth.Position := ZeroVector3e;
    Earth.Velocity := ZeroVector3e;
    PBodyInfo(Earth.Data)^.DrawInfo.ZoomRadius := 500000000;
    AddBodyToSystem(Earth,cMoonInfo);
  end;

  procedure PrepareSystem_004;  (* Mars - moons *)
  begin
    Mars := AddBodyToSystem(nil,cMarsInfo);
    Mars.Position := ZeroVector3e;
    Mars.Velocity := ZeroVector3e;
    AddBodyToSystem(Mars,cPhobosInfo);
    AddBodyToSystem(Mars,cDeimosInfo);
  end;

  procedure PrepareSystem_005;  (* Jupiter - moons *)
  begin
    Jupiter := AddBodyToSystem(nil,cJupiterInfo);
    Jupiter.Position := ZeroVector3e;
    Jupiter.Velocity := ZeroVector3e;
    PBodyInfo(Jupiter.Data)^.DrawInfo.ZoomRadius := 2000000000;
    AddBodyToSystem(Jupiter,cIoInfo);
    AddBodyToSystem(Jupiter,cEuropaInfo);
    AddBodyToSystem(Jupiter,cGanymedeInfo);
    AddBodyToSystem(Jupiter,cCallistoInfo);
  end;

  procedure PrepareSystem_006;  (* Saturn - Titan *)
  begin
    Saturn := AddBodyToSystem(nil,cSaturnInfo);
    Saturn.Position := ZeroVector3e;
    Saturn.Velocity := ZeroVector3e;
    PBodyInfo(Saturn.Data)^.DrawInfo.ZoomRadius := 1.5e9;
    AddBodyToSystem(Saturn,cTitanInfo);
  end;

  procedure PrepareSystem_007;  (* Neptune - Triton *)
  begin
    Neptune := AddBodyToSystem(nil,cNeptuneInfo);
    Neptune.Position := ZeroVector3e;
    Neptune.Velocity := ZeroVector3e;
    PBodyInfo(Neptune.Data)^.DrawInfo.ZoomRadius := 4e8;
    AddBodyToSystem(Neptune,cTritonInfo);
  end;

  procedure PrepareSystem_008;  (* Inner SOL planets - Moon *)
  begin
    Sun := AddBodyToSystem(nil,cSunInfo);
    PBodyInfo(Sun.Data)^.DrawInfo.ZoomRadius := 250000000000;
    AddBodyToSystem(Sun,cMercuryInfo);
    AddBodyToSystem(Sun,cVenusInfo);
    Earth := AddBodyToSystem(Sun,cEarthInfo);
    PBodyInfo(Earth.Data)^.DrawInfo.ZoomRadius := 500000000;
    AddBodyToSystem(Earth,cMoonInfo);
    AddBodyToSystem(Sun,cMarsInfo);
  end;

  procedure PrepareSystem_009;  (* Outer SOL planets - Pluto*)
  begin
    Sun := AddBodyToSystem(nil,cSunInfo);
    PBodyInfo(Sun.Data)^.DrawInfo.ZoomRadius := 7.4e12;
    AddBodyToSystem(Sun,cJupiterInfo);
    AddBodyToSystem(Sun,cSaturnInfo);
    AddBodyToSystem(Sun,cUranusInfo);
    AddBodyToSystem(Sun,cNeptuneInfo);
    Pluto := AddBodyToSystem(Sun,cPlutoInfo);
    Pluto.PositionZ := -Pluto.PositionX;
    Pluto.PositionX := 0;
    Pluto.VelocityX := Pluto.VelocityZ;
    Pluto.VelocityZ := 0;
  end;

begin
lbBodies.Items.Clear;
OrbitalSystem.ClearBodies;
case SystemNumber of
  1:  PrepareSystem_001;
  2:  PrepareSystem_002;
  3:  PrepareSystem_003;
  4:  PrepareSystem_004;
  5:  PrepareSystem_005;
  6:  PrepareSystem_006;
  7:  PrepareSystem_007;
  8:  PrepareSystem_008;
  9:  PrepareSystem_009;
else
  PrepareSystem_000;
end;
OrbitalSystem.SetReducedMode(True);
For i := 1 to OrbitalSystem.BodiesCount do lbBodies.Items.Add('');
If lbBodies.Items.Count > 0 then
  begin
    lbBodies.ItemIndex := 0;
    Settings.FocusedBodyIdx := 0;
  end
else Settings.FocusedBodyIdx := -1;
lbBodies.OnClick(nil);
lbBodies.OnDblClick(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.UpdateInfo;
begin
If lbBodies.ItemIndex >= 0 then
  begin
    lblPosition.Caption := Vector3eToStr(OrbitalSystem.Bodies[lbBodies.ItemIndex].Position,Settings.Rounding.Position);
    lblVelocity.Caption := Vector3eToStr(OrbitalSystem.Bodies[lbBodies.ItemIndex].Velocity,Settings.Rounding.Velocity);
    lblAcceleration.Caption := Vector3eToStr(OrbitalSystem.Bodies[lbBodies.ItemIndex].Acceleration,Settings.Rounding.Acceleration);
  end
else
  begin
    lblPosition.Caption := '';
    lblVelocity.Caption := '';
    lblAcceleration.Caption := '';
  end;
sbStatusBar.Panels[0].Text := 'Simulated bodies: ' + IntToStr(OrbitalSystem.BodiesCount);
sbStatusBar.Panels[1].Text := 'Simulation time [s]: ' + IntToStr(OrbitalSystem.ElapsedTime);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.DrawImage;
var
  XPlane,YPlane:      Integer;
  XFlip,YFlip:        Integer;
  Image:              TBitmap;
  ImageCenter:        TPoint;
  FocusPoint:         TVector3e;
  ZoomRadius:         Extended;
  ZoomCoef:           Extended;
  i:                  Integer;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure ResolvePlanes;
  begin
    case Settings.Rendering.RenderingPlane of
      1:  begin
            XPlane := 0;  YPlane := 2;
            XFlip := 1;   YFlip := -1;
          end;
      2:  begin
            XPlane := 0;  YPlane := 1;
            XFlip := 1;   YFlip := -1;
          end;
      3:  begin
            XPlane := 0;  YPlane := 1;
            XFlip := -1;  YFlip := -1;
          end;
      4:  begin
            XPlane := 2;  YPlane := 1;
            XFlip := -1;  YFlip := -1;
          end;
      5:  begin
            XPlane := 2;  YPlane := 1;
            XFlip := 1;   YFlip := -1;
          end;
    else
      XPlane := 0; YPlane := 2;
      XFlip := 1;  YFlip := 1;
    end;
  end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure ResolveFocusAndZoom;
  begin
    If Settings.FocusedBodyIdx >= 0 then
      begin
        FocusPoint := OrbitalSystem.Bodies[Settings.FocusedBodyIdx].Position;
        ZoomRadius := PBodyInfo(OrbitalSystem.Bodies[Settings.FocusedBodyIdx].Data)^.DrawInfo.ZoomRadius;
      end
    else
      begin
        FocusPoint := init_FocusPoint;
        ZoomRadius := init_ZoomRadius;
      end;
    If Settings.UserZoom then ZoomRadius := Settings.UserZoomRadius;
    If ImageCenter.X < ImageCenter.Y then
      ZoomCoef := ZoomRadius / ImageCenter.X
    else
      ZoomCoef := ZoomRadius / ImageCenter.Y;
  end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure DrawHints;
  var
    TempStr:      String;
    Scale:        Extended;
    ScaleLength:  Integer;
    StrSize:      TPoint;
  begin
    // draw axis hint
    Image.Canvas.Pen.Style := psSolid;
    Image.Canvas.Pen.Color := Settings.Colors.Hints;
    Image.Canvas.Brush.Style := bsClear;
    Image.Canvas.Font.Color := Settings.Colors.Hints;
    Image.Canvas.MoveTo(5,Image.Height - 5);
    Image.Canvas.LineTo(20,Image.Height - 5);
    Image.Canvas.LineTo(15,Image.Height - 8);
    Image.Canvas.MoveTo(20,Image.Height - 5);
    Image.Canvas.LineTo(15,Image.Height - 2);
    Image.Canvas.MoveTo(5,Image.Height - 5);
    Image.Canvas.LineTo(5,Image.Height - 20);
    Image.Canvas.LineTo(2,Image.Height - 15);
    Image.Canvas.MoveTo(5,Image.Height - 20);
    Image.Canvas.LineTo(8,Image.Height - 15);
    case XPlane of
      0:  TempStr := 'x';
      1:  TempStr := 'y';
      2:  TempStr := 'z';
    end;
    If XFlip < 0 then TempStr := '-' + TempStr;
    Image.Canvas.TextOut(23,Image.Height - 5 - Image.Canvas.TextHeight(TempStr),TempStr);
    case YPlane of
      0:  TempStr := 'x';
      1:  TempStr := 'y';
      2:  TempStr := 'z';
    end;
    If YFlip > 0 then TempStr := '-' + TempStr;
    Image.Canvas.TextOut(5,Image.Height - 20 - Image.Canvas.TextHeight(TempStr) - 3,TempStr);
    // draw zoom hint (scale)
    Scale := Power(10,Int(Log10(ZoomRadius)));
    ScaleLength := Round(Scale / ZoomCoef);
    Image.Canvas.MoveTo(Image.Width - 5,Image.Height - 8);
    Image.Canvas.LineTo(Image.Width - 5,Image.Height - 2);
    Image.Canvas.MoveTo(Image.Width - 5 - ScaleLength,Image.Height - 8);
    Image.Canvas.LineTo(Image.Width - 5 - ScaleLength,Image.Height - 2);
    Image.Canvas.MoveTo(Image.Width - 5,Image.Height - 5);
    Image.Canvas.LineTo(Image.Width - 5 - ScaleLength,Image.Height - 5);
    TempStr := FloatToStr(Scale / 1000) + ' km';
    StrSize.X := Image.Canvas.TextWidth(TempStr);
    StrSize.Y := Image.Canvas.TextHeight(TempStr);
    Image.Canvas.TextOut(Image.Width - 8 - StrSize.X,Image.Height - 11 - StrSize.Y,TempStr);
  end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure DrawOriginCross;
  var
    TempPos:  TPoint;
  begin
    TempPos.X := ImageCenter.X + Round(-FocusPoint[XPlane] / ZoomCoef);
    TempPos.Y := ImageCenter.Y + Round(-FocusPoint[YPlane] / ZoomCoef);
    Image.Canvas.Pen.Style := psSolid;
    Image.Canvas.Pen.Color := Settings.Colors.OriginCross;
    Image.Canvas.MoveTo(TempPos.X,TempPos.Y - 20);
    Image.Canvas.LineTo(TempPos.X,TempPos.Y + 20);
    Image.Canvas.MoveTo(TempPos.X - 20,TempPos.Y);
    Image.Canvas.LineTo(TempPos.X + 20,TempPos.Y);
  end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure DrawFocusCross;
  begin
    Image.Canvas.Pen.Style := psSolid;
    Image.Canvas.Pen.Color := Settings.Colors.FocusCross;
    Image.Canvas.MoveTo(ImageCenter.X - 20,ImageCenter.Y - 20);
    Image.Canvas.LineTo(ImageCenter.X + 20,ImageCenter.Y + 20);
    Image.Canvas.MoveTo(ImageCenter.X + 20,ImageCenter.Y - 20);
    Image.Canvas.LineTo(ImageCenter.X - 20,ImageCenter.Y + 20);
  end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure DrawOrbitTrail(Body: TBody);
  var
    RelativePosition: TVector3e;
    ii:               Integer;
    TrailPt1:         TPoint;
    TrailPt2:         TPoint;
  begin
    If Body.TrailCount > 0 then
      For ii := Body.TrailCount downto 1 do
        begin
          If ii >= Body.TrailCount then
            RelativePosition := SubstractVectors(Body.Position,FocusPoint)
          else
            begin
              If Assigned(Body.CenterBody) then
                RelativePosition := SubstractVectors(AddVectors(Body.Trail[ii],Body.CenterBody.Position),FocusPoint)
              else
                RelativePosition := SubstractVectors(Body.Trail[ii],FocusPoint);
            end;
          TrailPt1.X := ImageCenter.X + Round(RelativePosition[XPlane] / ZoomCoef) * XFlip;
          TrailPt1.Y := ImageCenter.Y + Round(RelativePosition[YPlane] / ZoomCoef) * YFlip;
          If Assigned(Body.CenterBody) then
            RelativePosition := SubstractVectors(AddVectors(Body.Trail[Pred(ii)],Body.CenterBody.Position),FocusPoint)
          else
            RelativePosition := SubstractVectors(Body.Trail[Pred(ii)],FocusPoint);
          TrailPt2.X := ImageCenter.X + Round(RelativePosition[XPlane] / ZoomCoef) * XFlip;
          TrailPt2.Y := ImageCenter.Y + Round(RelativePosition[YPlane] / ZoomCoef) * YFlip;
          Image.Canvas.Pen.Style := psSolid;
          Image.Canvas.Pen.Color := PBodyInfo(Body.Data)^.DrawInfo.Color1;
          Image.Canvas.MoveTo(TrailPt1.X,TrailPt1.Y);
          Image.Canvas.LineTo(TrailPt2.X,TrailPt2.Y);
        end;
  end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

  procedure DrawBody(Body: TBody; Selected: Boolean);
  var
    RelativePosition: TVector3e;
    ImagePosition:    TPoint;
    BodyRadius:       Integer;
    Outline:          TRect;
  begin
    RelativePosition := SubstractVectors(Body.Position,FocusPoint);
    ImagePosition.X := ImageCenter.X + Round(RelativePosition[XPlane] / ZoomCoef) * XFlip;
    ImagePosition.Y := ImageCenter.Y + Round(RelativePosition[YPlane] / ZoomCoef) * YFlip;
    BodyRadius := Max(Round(PBodyInfo(Body.Data)^.Radius / ZoomCoef),3);
    Image.Canvas.Pen.Style := psSolid;
    Image.Canvas.Pen.Color := PBodyInfo(Body.Data)^.DrawInfo.Color3;
    Image.Canvas.Brush.Style := bsSolid;
    Image.Canvas.Brush.Color := PBodyInfo(Body.Data)^.DrawInfo.Color2;
    Image.Canvas.Ellipse(ImagePosition.X - BodyRadius,ImagePosition.Y - BodyRadius,
                         ImagePosition.X + BodyRadius,ImagePosition.Y + BodyRadius);
    If Selected and Settings.Rendering.SelectRect then
      begin
        Outline.Left := ImagePosition.X - BodyRadius - 2;
        Outline.Top := ImagePosition.Y - BodyRadius - 2;
        Outline.Right := ImagePosition.X + BodyRadius + 2;
        Outline.Bottom := ImagePosition.Y + BodyRadius + 2;
        Image.Canvas.Pen.Style := psDot;
        Image.Canvas.Pen.Color := Settings.Colors.SelectRect;
        Image.Canvas.Brush.Style := bsClear;
        Image.Canvas.Rectangle(Outline);
      end;
   end;

//---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

begin
Image := TBitmap.Create;
try
  {$message 'todo: Z ordering'}
  ResolvePlanes;
  // prepare image
  Image.Width := imgMainImage.Width;
  Image.Height := ImgMainImage.Height;
  // get image center
  ImageCenter.X := Image.Width div 2;
  ImageCenter.Y := Image.Height div 2;
  // get focuspoint and zoom radius
  ResolveFocusAndZoom;
  // clear the picture
  Image.Canvas.Brush.Style := bsSolid;
  Image.Canvas.Brush.Color := Settings.Colors.Background;
  Image.Canvas.FillRect(Rect(0,0,Image.Width,Image.Height));
  // draw bodies
  If Settings.Rendering.BodiesFirst then
    For i := 0 to Pred(OrbitalSystem.BodiesCount) do
      DrawBody(OrbitalSystem.Bodies[i],i = lbBodies.ItemIndex);
  // draw hints
  If Settings.Rendering.Hints then DrawHints;
  // draw center cross
  If Settings.Rendering.OriginCross then DrawOriginCross;
  // draw focus cross
  If Settings.Rendering.FocusCross then DrawFocusCross;
  // draw orbit trails
  If Settings.Rendering.OrbitTrails then
    For i := 0 to Pred(OrbitalSystem.BodiesCount) do
      DrawOrbitTrail(OrbitalSystem.Bodies[i]);
  // draw bodies
  If not Settings.Rendering.BodiesFirst then
    For i := 0 to Pred(OrbitalSystem.BodiesCount) do
      DrawBody(OrbitalSystem.Bodies[i],i = lbBodies.ItemIndex);
  // show image
  imgMainImage.Picture.Assign(Image);
finally
  Image.Free;
end;
end;

//==============================================================================

procedure TfMainForm.FormCreate(Sender: TObject);
begin
lbBodies.DoubleBuffered := True;
sbStatusBar.DoubleBuffered := True;
OrbitalSystem := TOrbitalSystem.Create;
OrbitalSystem.OnBodyCreate := BodyInit;
OrbitalSystem.OnBodyDestroy := BodyFinal;
cbPresetSystem.ItemIndex := 0;
InitializeSystem(cbPresetSystem.ItemIndex);
rgShownVector.OnClick(nil);
Settings.Rounding := def_Settings_Rounding;
tbSimStep.OnChange(nil);
tbTimeWarp.OnChange(nil);
tbAnimationFrequency.OnChange(nil);
Settings.Rendering := def_Settings_Rendering;
cbRenderHints.Checked := Settings.Rendering.Hints;
cbRenderOriginCross.Checked := Settings.Rendering.OriginCross;
cbRenderFocusCross.Checked := Settings.Rendering.FocusCross;
cbRenderSelectRect.Checked := Settings.Rendering.SelectRect;
cbRenderOrbitTrails.Checked := Settings.Rendering.OrbitTrails;
cbRenderBodiesFirst.Checked := Settings.Rendering.BodiesFirst;
Settings.Colors := def_Settings_Colors_White;
cbRenderingPlane.ItemIndex := 0;
cbRenderingPlane.OnChange(nil);
cbUserZoom.OnClick(nil);
tbZoomFactor.OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormDestroy(Sender: TObject);
begin
OrbitalSystem.Free;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.FormResize(Sender: TObject);
begin
DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnStartStopClick(Sender: TObject);
begin
tmrSimTimer.Enabled := not tmrSimTimer.Enabled;
If tmrSimTimer.Enabled then btnStartStop.Caption := 'Stop simulation'
  else btnStartStop.Caption := 'Start simulation';
end;

//------------------------------------------------------------------------------

procedure TfMainForm.cbPresetSystemChange(Sender: TObject);
begin
InitializeSystem(cbPresetSystem.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.lbBodiesClick(Sender: TObject);
begin
If lbBodies.ItemIndex >= 0 then
  begin
    lblName.Caption := OrbitalSystem.Bodies[lbBodies.ItemIndex].Name;
    lblIdentifier.Caption := GUIDToString(OrbitalSystem.Bodies[lbBodies.ItemIndex].Identifier);
    shpColor1.Brush.Color := PBodyInfo(OrbitalSystem.Bodies[lbBodies.ItemIndex].Data)^.DrawInfo.Color1;
    shpColor2.Brush.Color := PBodyInfo(OrbitalSystem.Bodies[lbBodies.ItemIndex].Data)^.DrawInfo.Color2;
    shpColor3.Brush.Color := PBodyInfo(OrbitalSystem.Bodies[lbBodies.ItemIndex].Data)^.DrawInfo.Color3;
    If OrbitalSystem.Bodies[lbBodies.ItemIndex].ReducedValues then
      lblMass.Caption := FloatToStr(OrbitalSystem.Bodies[lbBodies.ItemIndex].Mass * 10e11)
    else
      lblMass.Caption := FloatToStr(OrbitalSystem.Bodies[lbBodies.ItemIndex].Mass);
    lblPerturbations.Caption := IntToStr(OrbitalSystem.Bodies[lbBodies.ItemIndex].InteractingBodiesCount);
  end
else
  begin
    lblName.Caption := '';
    lblIdentifier.Caption := '';
    shpColor1.Brush.Color := gbBodyInfo.Color;
    shpColor2.Brush.Color := gbBodyInfo.Color;
    shpColor3.Brush.Color := gbBodyInfo.Color;
    lblMass.Caption := '';
    lblPerturbations.Caption := '';
  end;
btnMoreInfo.Enabled := lbBodies.ItemIndex >= 0;
UpdateInfo;
DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.lbBodiesDblClick(Sender: TObject);
begin
If lbBodies.ItemIndex >= 0 then
  begin
    Settings.FocusedBodyIdx := lbBodies.ItemIndex;
    If not Settings.UserZoom then
      begin
        tbZoomFactor.Position := Round(Log10(PBodyInfo(OrbitalSystem.Bodies[Settings.FocusedBodyIdx].Data)^.DrawInfo.ZoomRadius) * 50);
        tbZoomFactor.OnChange(nil);
      end;
    lbBodies.Repaint;
    DrawImage;
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.lbBodiesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  TempStr:  String;
begin
lbBodies.Canvas.Pen.Style := psSolid;
lbBodies.Canvas.Brush.Style := bsSolid;
lbBodies.Canvas.Brush.Color := PBodyInfo(OrbitalSystem.Bodies[Index].Data)^.DrawInfo.Color1;
lbBodies.Canvas.FillRect(Rect);
lbBodies.Canvas.Brush.Color := PBodyInfo(OrbitalSystem.Bodies[Index].Data)^.DrawInfo.Color2;
lbBodies.Canvas.FillRect(Classes.Rect(Rect.Left,Rect.Top,Rect.Left + 10,Rect.Bottom));
If odSelected in State then
  begin
    lbBodies.Canvas.Pen.Color := PBodyInfo(OrbitalSystem.Bodies[Index].Data)^.DrawInfo.Color3;
    lbBodies.Canvas.Brush.Style := bsClear;
    lbBodies.Canvas.Rectangle(Rect);
  end;
If Index = Settings.FocusedBodyIdx then
  begin
    lbBodies.Canvas.Brush.Color := PBodyInfo(OrbitalSystem.Bodies[Index].Data)^.DrawInfo.Color3;
    lbBodies.Canvas.FillRect(Classes.Rect(Rect.Right - 5,Rect.Top,Rect.Right,Rect.Bottom));
  end;
lbBodies.Canvas.Brush.Style := bsClear;  
lbBodies.Canvas.Font := lbBodies.Font;
lbBodies.Canvas.TextOut(Rect.Left + 15,Rect.Top + 1,OrbitalSystem.Bodies[Index].Name);
TempStr := GUIDToString(OrbitalSystem.Bodies[Index].Identifier);
lbBodies.Canvas.Font.Color := clGrayText;
lbBodies.Canvas.TextOut(Rect.Right - 5 - lbBodies.Canvas.TextWidth(TempStr),Rect.Top + 1,TempStr);
lbBodies.Canvas.Font := lbBodies.Font;
case Settings.ListVector of
  0:  TempStr := 'Position [m]: ' + Vector3eToStr(OrbitalSystem.Bodies[Index].Position,Settings.Rounding.Position);
  1:  TempStr := 'Velocity [m/s]: ' + Vector3eToStr(OrbitalSystem.Bodies[Index].Velocity,Settings.Rounding.Velocity);
  2:  TempStr := 'Acceleration [m/s^2]: ' + Vector3eToStr(OrbitalSystem.Bodies[Index].Acceleration,Settings.Rounding.Acceleration);
end;
lbBodies.Canvas.TextOut(Rect.Left + 15,Rect.Bottom - 1 - lbBodies.Canvas.TextHeight(TempStr),TempStr);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.rgShownVectorClick(Sender: TObject);
begin
Settings.ListVector := rgShownVector.ItemIndex;
lbBodies.Repaint;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnFocusOriginClick(Sender: TObject);
begin
Settings.FocusedBodyIdx := -1;
If not Settings.UserZoom then
  begin
    tbZoomFactor.Position := Round(Log10(init_ZoomRadius) * 50);
    tbZoomFactor.OnChange(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnRoundingClick(Sender: TObject);
begin
fRoundingForm.ShowModal;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnAddBodyClick(Sender: TObject);
begin
{$message 'todo'}
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnRemoveBodyClick(Sender: TObject);
begin
{$message 'todo'}
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnMoreInfoClick(Sender: TObject);
begin
fInfoForm.ShowModal;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.tbSimStepChange(Sender: TObject);
begin
Settings.SimTimeStep := tbSimStep.Position;
eSimStep.Text := IntToStr(Settings.SimTimeStep);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.tbTimeWarpChange(Sender: TObject);
begin
Settings.TimeWarp := tbTimeWarp.Position;
eTimeWarp.Text := IntToStr(Settings.TimeWarp);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.tbAnimationFrequencyChange(Sender: TObject);
begin
Settings.AnimFreq := tbAnimationFrequency.Position;
eAnimationFrequency.Text := IntToStr(Settings.AnimFreq);
tmrAnimTimer.Interval := Round(1000 / Settings.AnimFreq);
end;

//------------------------------------------------------------------------------

procedure TfMainForm.cbRenderHintsClick(Sender: TObject);
begin
If Sender is TCheckBox then
  case TCheckBox(Sender).Tag of
    0:  Settings.Rendering.Hints := TCheckBox(Sender).Checked;
    1:  Settings.Rendering.BodiesFirst := TCheckBox(Sender).Checked;
    2:  Settings.Rendering.OriginCross := TCheckBox(Sender).Checked;
    3:  Settings.Rendering.FocusCross := TCheckBox(Sender).Checked;
    4:  Settings.Rendering.SelectRect := TCheckBox(Sender).Checked;
    5:  Settings.Rendering.OrbitTrails := TCheckBox(Sender).Checked;
  end;
DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.btnColorsClick(Sender: TObject);
begin
fColorsForm.ShowModal;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.cbRenderingPlaneChange(Sender: TObject);
begin
Settings.Rendering.RenderingPlane := cbRenderingPlane.ItemIndex;
DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.cbUserZoomClick(Sender: TObject);
begin
Settings.UserZoom := cbUserZoom.Checked;
If not Settings.UserZoom then
  begin
    If Settings.FocusedBodyIdx >= 0 then
      tbZoomFactor.Position := Round(Log10(PBodyInfo(OrbitalSystem.Bodies[Settings.FocusedBodyIdx].Data)^.DrawInfo.ZoomRadius) * 50)
    else
      tbZoomFactor.Position := Round(Log10(init_ZoomRadius) * 50);
    tbZoomFactor.OnChange(nil);
  end;
tbZoomFactor.Enabled := cbUserZoom.Checked;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.tbZoomFactorChange(Sender: TObject);
begin
Settings.UserZoomRadius := Power(10,tbZoomFactor.Position / 50);
eZoomFactor.Text := FloatToStr(Int(Settings.UserZoomRadius));
If Settings.UserZoom then DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.tmrAnimTimerTimer(Sender: TObject);
begin
lbBodies.Repaint;
UpdateInfo;
DrawImage;
end;

//------------------------------------------------------------------------------

procedure TfMainForm.tmrSimTimerTimer(Sender: TObject);
var
  i:  Integer;
begin
For i := 1 to Settings.TimeWarp do
  OrbitalSystem.ProcessStep(Settings.SimTimeStep);
end;

end.

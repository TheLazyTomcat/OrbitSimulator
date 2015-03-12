object fInfoForm: TfInfoForm
  Left = 681
  Top = 243
  BorderStyle = bsDialog
  Caption = 'Body information'
  ClientHeight = 297
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    577
    297)
  PixelsPerInch = 96
  TextHeight = 13
  object shpColor1: TShape
    Left = 0
    Top = 0
    Width = 578
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    Pen.Style = psClear
  end
  object lblName: TLabel
    Left = 8
    Top = 8
    Width = 562
    Height = 25
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lblName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Layout = tlCenter
  end
  object shpColor2: TShape
    Left = 529
    Top = 0
    Width = 25
    Height = 41
    Anchors = [akTop, akRight]
    Pen.Style = psClear
  end
  object shpColor3: TShape
    Left = 553
    Top = 0
    Width = 25
    Height = 41
    Anchors = [akTop, akRight]
    Pen.Style = psClear
  end
  object lblMassC: TLabel
    Left = 103
    Top = 56
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = 'Mass [kg]:'
  end
  object lblMass: TLabel
    Left = 160
    Top = 56
    Width = 34
    Height = 13
    Caption = 'lblMass'
  end
  object lblReducedMassC: TLabel
    Left = 15
    Top = 80
    Width = 138
    Height = 13
    Alignment = taRightJustify
    Caption = 'Reduced mass [10^+11 kg]:'
  end
  object lblReducedMass: TLabel
    Left = 160
    Top = 80
    Width = 76
    Height = 13
    Caption = 'lblReducedMass'
  end
  object lblRadiusC: TLabel
    Left = 93
    Top = 104
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Radius [km]:'
  end
  object lblPeriapsisC: TLabel
    Left = 83
    Top = 128
    Width = 70
    Height = 13
    Alignment = taRightJustify
    Caption = 'Periapsis [km]:'
  end
  object lblApoapsisC: TLabel
    Left = 82
    Top = 152
    Width = 71
    Height = 13
    Alignment = taRightJustify
    Caption = 'Apoapsis [km]:'
  end
  object lblInclinationC: TLabel
    Left = 334
    Top = 80
    Width = 107
    Height = 13
    Alignment = taRightJustify
    Caption = 'Orbit inclination [deg]:'
  end
  object lblEccentricityC: TLabel
    Left = 355
    Top = 56
    Width = 86
    Height = 13
    Alignment = taRightJustify
    Caption = 'Orbit eccentricity:'
  end
  object lblOrbitalPeriodC: TLabel
    Left = 338
    Top = 104
    Width = 103
    Height = 13
    Alignment = taRightJustify
    Caption = 'Orbital period [days]:'
  end
  object lvlSemiMajorAxisC: TLabel
    Left = 54
    Top = 176
    Width = 99
    Height = 13
    Alignment = taRightJustify
    Caption = 'Semimajor axis [km]:'
  end
  object lblApAVelocityC: TLabel
    Left = 296
    Top = 152
    Width = 145
    Height = 13
    Alignment = taRightJustify
    Caption = 'Minimum orbital velocity [m/s]:'
  end
  object lblPeAVelocityC: TLabel
    Left = 292
    Top = 128
    Width = 149
    Height = 13
    Alignment = taRightJustify
    Caption = 'Maximum orbital velocity [m/s]:'
  end
  object lblMeanVelocityC: TLabel
    Left = 310
    Top = 176
    Width = 131
    Height = 13
    Alignment = taRightJustify
    Caption = 'Mean orbital velocity [m/s]:'
  end
  object lblRadius: TLabel
    Left = 160
    Top = 104
    Width = 42
    Height = 13
    Caption = 'lblRadius'
  end
  object lblPeriapsis: TLabel
    Left = 160
    Top = 128
    Width = 52
    Height = 13
    Caption = 'lblPeriapsis'
  end
  object lblApoapsis: TLabel
    Left = 160
    Top = 152
    Width = 53
    Height = 13
    Caption = 'lblApoapsis'
  end
  object lblSemiMajorAxis: TLabel
    Left = 160
    Top = 176
    Width = 79
    Height = 13
    Caption = 'lblSemiMajorAxis'
  end
  object lblEccentricity: TLabel
    Left = 448
    Top = 56
    Width = 65
    Height = 13
    Caption = 'lblEccentricity'
  end
  object lblInclination: TLabel
    Left = 448
    Top = 80
    Width = 59
    Height = 13
    Caption = 'lblInclination'
  end
  object lblOrbitalPeriod: TLabel
    Left = 448
    Top = 104
    Width = 72
    Height = 13
    Caption = 'lblOrbitalPeriod'
  end
  object lblPeAVelocity: TLabel
    Left = 448
    Top = 128
    Width = 66
    Height = 13
    Caption = 'lblPeAVelocity'
  end
  object lblApAVelocity: TLabel
    Left = 448
    Top = 152
    Width = 67
    Height = 13
    Caption = 'lblApAVelocity'
  end
  object lblMeanVelocity: TLabel
    Left = 448
    Top = 176
    Width = 73
    Height = 13
    Caption = 'lblMeanVelocity'
  end
  object lblOrbitsC: TLabel
    Left = 371
    Top = 200
    Width = 70
    Height = 13
    Alignment = taRightJustify
    Caption = 'Orbits around:'
  end
  object lblOrbits: TLabel
    Left = 448
    Top = 200
    Width = 39
    Height = 13
    Caption = 'lblOrbits'
  end
  object lblPerturbatingBodies: TLabel
    Left = 8
    Top = 216
    Width = 98
    Height = 13
    Caption = 'Perturbating bodies:'
  end
  object mePerturbatingBodies: TMemo
    Left = 8
    Top = 232
    Width = 561
    Height = 57
    TabStop = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end

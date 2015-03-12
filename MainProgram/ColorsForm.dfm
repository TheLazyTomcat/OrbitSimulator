object fColorsForm: TfColorsForm
  Left = 993
  Top = 161
  BorderStyle = bsDialog
  Caption = 'Colors'
  ClientHeight = 168
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblHints: TLabel
    Left = 213
    Top = 48
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'Hints:'
  end
  object lblOriginCross: TLabel
    Left = 40
    Top = 80
    Width = 65
    Height = 13
    Alignment = taRightJustify
    Caption = 'Center cross:'
  end
  object lblFocusCross: TLabel
    Left = 181
    Top = 80
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Focus cross:'
  end
  object lblBackground: TLabel
    Left = 45
    Top = 48
    Width = 60
    Height = 13
    Alignment = taRightJustify
    Caption = 'Background:'
  end
  object lblSelectRect: TLabel
    Left = 10
    Top = 112
    Width = 95
    Height = 13
    Alignment = taRightJustify
    Caption = 'Selection rectangle:'
  end
  object lblOrbitTrails: TLabel
    Left = 187
    Top = 112
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = 'Orbit trails:'
    Visible = False
  end
  object lblLoadPresetColors: TLabel
    Left = 29
    Top = 10
    Width = 92
    Height = 13
    Alignment = taRightJustify
    Caption = 'Load preset colors:'
  end
  object btnAccept: TButton
    Left = 192
    Top = 136
    Width = 81
    Height = 25
    Caption = 'Accept'
    TabOrder = 0
    OnClick = btnAcceptClick
  end
  object pnlBackground: TPanel
    Left = 112
    Top = 40
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 3
    OnClick = pnlBackgroundClick
  end
  object pnlOriginCross: TPanel
    Left = 112
    Top = 72
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 5
    OnClick = pnlBackgroundClick
  end
  object pnlSelectRect: TPanel
    Left = 112
    Top = 104
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 7
    OnClick = pnlBackgroundClick
  end
  object pnlHints: TPanel
    Left = 248
    Top = 40
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 4
    OnClick = pnlBackgroundClick
  end
  object pnlFocusCross: TPanel
    Left = 248
    Top = 72
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 6
    OnClick = pnlBackgroundClick
  end
  object pnlOrbitTrails: TPanel
    Left = 248
    Top = 104
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    ParentBackground = False
    TabOrder = 8
    Visible = False
    OnClick = pnlBackgroundClick
  end
  object cbPresets: TComboBox
    Left = 128
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = 'White background'
    OnChange = cbPresetsChange
    Items.Strings = (
      'White background'
      'Black background')
  end
  object btnApply: TButton
    Left = 112
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 1
    OnClick = btnApplyClick
  end
  object dColors: TColorDialog
    Options = [cdFullOpen]
    Left = 8
    Top = 136
  end
end

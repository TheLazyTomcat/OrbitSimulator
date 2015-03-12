object fRoundingForm: TfRoundingForm
  Left = 1117
  Top = 469
  BorderStyle = bsDialog
  Caption = 'Rounding'
  ClientHeight = 144
  ClientWidth = 144
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
  object lblPosition: TLabel
    Left = 32
    Top = 12
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Position:'
  end
  object lblVelocity: TLabel
    Left = 32
    Top = 44
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'Velocity:'
  end
  object lblAcceleration: TLabel
    Left = 10
    Top = 76
    Width = 63
    Height = 13
    Alignment = taRightJustify
    Caption = 'Acceleration:'
  end
  object sePosition: TSpinEdit
    Left = 80
    Top = 8
    Width = 57
    Height = 22
    MaxValue = 100
    MinValue = -100
    TabOrder = 0
    Value = 0
  end
  object seVelocity: TSpinEdit
    Left = 80
    Top = 40
    Width = 57
    Height = 22
    MaxValue = 100
    MinValue = -100
    TabOrder = 1
    Value = 0
  end
  object seAcceleration: TSpinEdit
    Left = 80
    Top = 72
    Width = 57
    Height = 22
    MaxValue = 100
    MinValue = -100
    TabOrder = 2
    Value = 0
  end
  object btnAccept: TButton
    Left = 64
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Accept'
    TabOrder = 3
    OnClick = btnAcceptClick
  end
end

object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Gurux DLMS Simulator'
  ClientHeight = 270
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = OnCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Output: TMemo
    Left = 0
    Top = 0
    Width = 635
    Height = 270
    Align = alClient
    TabOrder = 0
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 4059
    OnConnect = IdTCPServer1Connect
    OnDisconnect = IdTCPServer1Disconnect
    OnExecute = IdTCPServer1Execute
    Left = 576
    Top = 208
  end
end

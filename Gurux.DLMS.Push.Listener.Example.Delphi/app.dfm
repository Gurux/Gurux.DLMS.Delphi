object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Gurux DLMS Push listener example'
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
    Width = 560
    Height = 270
    Align = alClient
    TabOrder = 0
  end
  object SendPushBtn: TButton
    Left = 560
    Top = 0
    Width = 75
    Height = 270
    Align = alRight
    Caption = 'Send push'
    TabOrder = 1
    OnClick = SendPushBtnClick
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    Host = 'localhost'
    Port = 4059
    ReadTimeout = -1
    Left = 592
    Top = 40
  end
  object IdTCPServer1: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 4059
    OnConnect = OnClientConnect
    OnDisconnect = OnClientDisconnect
    OnExecute = OnReceived
    Left = 568
    Top = 216
  end
end

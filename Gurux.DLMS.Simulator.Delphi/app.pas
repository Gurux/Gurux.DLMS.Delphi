unit app;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Gurux.DLMS.GXDLMSServer, Gurux.DLMS.GXDLMSTranslator,
  GXByteBuffer, Gurux.DLMS.GXReplyData,
  Gurux.DLMS.Authentication, Gurux.DLMS.InterfaceType, GXDLMSMeter,
  Gurux.DLMS.GXServerReply;

type
  TForm3 = class(TForm)
    ServerSocket1: TServerSocket;
    Output: TMemo;
    procedure OnCreate(Sender: TObject);
    procedure OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnReceived(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
    Reply: TGXByteBuffer;
    FMeter: TGXDLMSMeter;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.OnClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Output.Lines.Add('Client connect');
end;

procedure TForm3.OnClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Output.Lines.Add('Client disconnect');
  Reply.Clear();
end;

procedure TForm3.OnCreate(Sender: TObject);
begin
  Reply:= TGXByteBuffer.Create();
  ServerSocket1.Port := 4061;
  ServerSocket1.Active := true;
  FMeter := TGXDLMSMeter.Create;
  Output.Lines.Add('Meter created to port: ' + IntToStr(ServerSocket1.Port));
end;

procedure TForm3.OnReceived(Sender: TObject; Socket: TCustomWinSocket);
var
  available: Longint;
  bytes: TBytes;
  data: TGXReplyData;
  t: TGXDLMSTranslator;
  sr: TGXServerReply;
begin
   t := Nil;
  try
    available:= Socket.ReceiveLength;
    bytes := TBytes.Create();
    SetLength(bytes, available);
    Socket.ReceiveBuf(bytes[0], available);
    Output.Lines.Add(TGXByteBuffer.ToHexString(bytes));
    sr := TGXServerReply.Create(bytes);
    try
      FMeter.HandleRequest(sr);
    finally
      FreeAndNil(sr);
    end;

  finally
    FreeAndNil(data);
    FreeAndNil(t);
  end;
end;

end.

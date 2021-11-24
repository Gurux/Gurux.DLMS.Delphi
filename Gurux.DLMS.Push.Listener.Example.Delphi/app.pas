unit app;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Gurux.DLMS.GXDLMSClient, Gurux.DLMS.GXDLMSTranslator,
  GXByteBuffer, Gurux.DLMS.GXReplyData,
  Gurux.DLMS.Authentication, Gurux.DLMS.InterfaceType;

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
    Notify : TGXReplyData;
    Client: TGXDLMSClient;
    Reply: TGXByteBuffer;
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
  ServerSocket1.Port := 4059;
  ServerSocket1.Active := true;
  Client := TGXDLMSClient.Create(True, -1, -1, TAuthentication.atNone, Nil, TInterfaceType.HDLC);
  Notify := TGXReplyData.Create();
end;

procedure TForm3.OnReceived(Sender: TObject; Socket: TCustomWinSocket);
var
  available: Longint;
  bytes: TBytes;
  data: TGXReplyData;
  xml: string;
  t: TGXDLMSTranslator;
begin
   t := Nil;
  try
    available:= Socket.ReceiveLength;
    bytes := TBytes.Create();
    SetLength(bytes, available);
    Socket.ReceiveBuf(bytes[0], available);
    Output.Lines.Add(TGXByteBuffer.ToHexString(bytes));
    reply.SetArray(bytes);
    //Example handles only notify messages.
    data := TGXReplyData.Create;
    Client.GetData(reply, data, Notify);
    // If all data is received.
    if (Notify.Complete) then
    begin
      reply.Clear();
      if Not notify.IsMoreData then
      begin
        //Show data as XML.
        t := TGXDLMSTranslator.Create();
        xml := t.DataToXml(notify.Data);
       Output.Lines.Add(xml);
      end;
    end;
  finally
    notify.Clear;
    FreeAndNil(data);
    FreeAndNil(t);
  end;
end;

end.

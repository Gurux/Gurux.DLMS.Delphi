unit app;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Gurux.DLMS.GXDLMSClient, Gurux.DLMS.GXDLMSTranslator,
  GXByteBuffer, Gurux.DLMS.GXReplyData,
  Gurux.DLMS.GXDLMSSecureNotify,
  Gurux.DLMS.Authentication, Gurux.DLMS.InterfaceType, IdCustomTCPServer,
  IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdContext, IdGlobal,
  Gurux.DLMS.GXDateTime,
  Gurux.DLMS.GXDLMSCaptureObject,
  Gurux.DLMS.Objects.GXDLMSPushSetup,
  Gurux.DLMS.Objects.GXDLMSClock;

type
  TForm3 = class(TForm)
    Output: TMemo;
    IdTCPClient1: TIdTCPClient;
    IdTCPServer1: TIdTCPServer;
    SendPushBtn: TButton;
    procedure OnCreate(Sender: TObject);
    procedure SendPushBtnClick(Sender: TObject);
    procedure OnReceived(AContext: TIdContext);
    procedure OnClientConnect(AContext: TIdContext);
    procedure OnClientDisconnect(AContext: TIdContext);
  
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


procedure TForm3.SendPushBtnClick(Sender: TObject);
var
  clock : TGXDLMSClock;
  p: TGXDLMSPushSetup;
  ANotify : TGXDLMSSecureNotify;
  ret : TArray<TBytes>;
  it: TBytes;
  RawBytes: TIdBytes;
  b: byte;
begin
  ANotify := TGXDLMSSecureNotify.Create(true, 16, 1, TInterfaceType.HDLC);
  try
    p := TGXDLMSPushSetup.Create('0.7.25.9.0.255');
    clock := TGXDLMSClock.Create('0.0.1.0.0.255');
    clock.Time := TGXDateTime.Create(Date);

    //Push setup is added as a first object.
    p.PushObjectList.Add(TGXDLMSCaptureObject.Create(p, 2, 0));

    //Add date and time of the clock object.
    p.PushObjectList.Add(TGXDLMSCaptureObject.Create(clock, 2, 0));
    ret := ANotify.GeneratePushSetupMessages(Nil, p);
  finally
    FreeAndNil(ANotify);
    FreeAndNil(p);
    FreeAndNil(clock);
  end;
  //Send the data.
  IdTCPClient1.Connect;
  for it in ret do
  begin
    RawBytes := RawToBytes(it[0], Length(it));
    IdTCPClient1.Socket.Write(RawBytes);
  end;
  IdTCPClient1.Disconnect;
end;

procedure TForm3.OnClientConnect(AContext: TIdContext);
begin
  Output.Lines.Add('Client connect');
end;

procedure TForm3.OnClientDisconnect(AContext: TIdContext);
begin
  Output.Lines.Add('Client disconnect');
  Reply.Clear();
end;

procedure TForm3.OnCreate(Sender: TObject);
begin
  Client := TGXDLMSClient.Create(True, -1, -1, TAuthentication.atNone, Nil, TInterfaceType.HDLC);
  Reply:= TGXByteBuffer.Create();
  Notify := TGXReplyData.Create;
end;


procedure TForm3.OnReceived(AContext: TIdContext);
var
  RawBytes: TIdBytes;
  available: Longint;
  bytes: TBytes;
  data: TGXReplyData;
  xml: string;
  t: TGXDLMSTranslator;
begin
   t := Nil;
  try
    if AContext.Connection.IOHandler.InputBufferIsEmpty Then
    begin
      AContext.Connection.IOHandler.CheckForDataOnSource(10);
      if AContext.Connection.IOHandler.InputBufferIsEmpty then Exit;
    end;
    RawBytes:= TIdBytes.Create();
    AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(RawBytes);
    bytes := TBytes.Create();
    SetLength(bytes, Length(RawBytes));
    BytesToRaw(RawBytes, bytes[0], Length(RawBytes));
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

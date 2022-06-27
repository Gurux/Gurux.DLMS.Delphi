unit app;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Gurux.DLMS.GXDLMSServer, Gurux.DLMS.GXDLMSTranslator,
  GXByteBuffer, Gurux.DLMS.GXReplyData,
  Gurux.DLMS.Authentication, Gurux.DLMS.InterfaceType, GXDLMSMeter,
  Gurux.DLMS.GXServerReply, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, IdContext, IdGlobal;

type
  TForm3 = class(TForm)
    Output: TMemo;
    IdTCPServer1: TIdTCPServer;
    procedure OnCreate(Sender: TObject);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure IdTCPServer1Execute(AContext: TIdContext);
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

procedure TForm3.IdTCPServer1Connect(AContext: TIdContext);
begin
  Output.Lines.Add('Client connect');
end;

procedure TForm3.IdTCPServer1Disconnect(AContext: TIdContext);
begin
  if (Output <> Nil)  then
  begin
    Output.Lines.Add('Client disconnect');
  end;
  Reply.Clear();
end;

procedure TForm3.IdTCPServer1Execute(AContext: TIdContext);
var
  RawBytes: TIdBytes;
  available: Longint;
  bytes: TBytes;
  sr: TGXServerReply;
begin
  try
   if AContext.Connection.IOHandler.InputBufferIsEmpty Then
    begin
      AContext.Connection.IOHandler.CheckForDataOnSource(10);
      if AContext.Connection.IOHandler.InputBufferIsEmpty then Exit;
    end;
    RawBytes := TIdBytes.Create();
    AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(RawBytes);
    bytes := TBytes.Create();
    SetLength(bytes, Length(RawBytes));
    BytesToRaw(RawBytes, bytes[0], Length(RawBytes));
    Output.Lines.Add('RX: ' + TGXByteBuffer.ToHexString(bytes));
    sr := TGXServerReply.Create(bytes);
    try
      FMeter.HandleRequest(sr);
      //Reply is null if we do not want to send any data to the client.
      //This is done if client try to make connection with wrong device ID.
      if sr.Reply <> Nil Then
      begin
        Output.Lines.Add('TX: ' + TGXByteBuffer.ToHexString(sr.Reply));
        RawBytes :=RawToBytes(sr.Reply[0], Length(sr.Reply));
        AContext.Connection.IOHandler.Write(RawBytes);
      end;
    finally
      FreeAndNil(sr);
    end;
  finally
  end;
end;

procedure TForm3.OnCreate(Sender: TObject);
begin
  Reply:= TGXByteBuffer.Create();
  IdTCPServer1.DefaultPort := 4061;
  IdTCPServer1.Active := true;
  FMeter := TGXDLMSMeter.Create;
  Output.Lines.Add('Meter created to port: ' + IntToStr(IdTCPServer1.DefaultPort));
end;

end.

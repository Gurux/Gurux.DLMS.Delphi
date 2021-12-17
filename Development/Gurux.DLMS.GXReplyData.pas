//
// --------------------------------------------------------------------------
//  Gurux Ltd
// 
//
//
// Filename:        $HeadURL$
//
// Version:         $Revision$,
//                  $Date$
//                  $Author$
//
// Copyright (c) Gurux Ltd
//
//---------------------------------------------------------------------------
//
//  DESCRIPTION
//
// This file is a part of Gurux Device Framework.
//
// Gurux Device Framework is Open Source software; you can redistribute it
// and/or modify it under the terms of the GNU General Public License 
// as published by the Free Software Foundation; version 2 of the License.
// Gurux Device Framework is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
// See the GNU General Public License for more details.
//
// This code is licensed under the GNU General Public License v2. 
// Full text may be retrieved at http://www.gnu.org/licenses/gpl-2.0.txt
//---------------------------------------------------------------------------

unit Gurux.DLMS.GXReplyData;

interface
uses SysUtils, Rtti, Gurux.DLMS.DataType, Gurux.DLMS.Command,
GXByteBuffer, Gurux.DLMS.RequestTypes, Gurux.DLMS.ErrorCode, GXCommon,
Gurux.DLMS.GXDLMSTranslatorStructure,
Gurux.DLMS.GXDLMSGateway;

type
  TGXReplyData = class

  FDataType : TDataType;
  // Read value.
  FValue: TValue;
  // Last read position. This is used in peek to solve how far data is read.
  FReadPosition : Integer;
  // Packet length.
  FPacketLength : Integer;
  // Received command.
  FCommand : TCommand;
  FCipheredCommand : TCommand;
  // Received command type.
  FCommandType : Byte;
  // Received data.
  FData: TGXByteBuffer;
  // Is frame complete.
  FComplete: Boolean;
  // HDLC frame ID.
  FFrameId : Byte;
  // Received invoke ID.
  InvokeId : LongWord;
  // Received error.
  FError: SmallInt;
  // Expected count of elements in the array.
  FTotalCount: Integer;
  // Cipher index is position where data is decrypted.
  FCipherIndex : Integer;
  // Data notification date time.
  FTime: TDateTime;
  // Is more data available. Return None if more data is not available or Frame or Block type.
  FMoreData: TRequestTypes;
  // Is value try to peek.
  FPeek: Boolean;
  FXml: TGXDLMSTranslatorStructure;

  // Is GBT streaming in use.
  FStreaming: Boolean;
  //GBT Window size.
  FGbtWindowSize: BYTE;
  //GBT block number.
  FBlockNumber: BYTE;
  //GBT block number ACK.
  FBlockNumberAck: BYTE;
  // Client address of the notification message.
  FClientAddress: Integer;
  //Server address of the notification message.
  FServerAddress: Integer;
  //Is HDLC streaming in progress.
  FHdlcStreaming: Boolean;
  public
  // Gateway information.
  Gateway: TGXDLMSGateway;

  // Constructor.
  // more: Is more data available.
  // cmd:  Received command.
  // buff: Received data.
  // complete: Is frame complete.
  // error: Received error ID.
  constructor Create(AMore: TRequestTypes; ACommand: TCommand; buff: TGXByteBuffer; AComplete: Boolean; error: Byte);overload;

  // Constructor.
  constructor Create();overload;

  //Destructor
  destructor Destroy; override;

  // Reset data values to default.
  procedure Clear;

  // Is more data available.
  function IsMoreData: Boolean;

  function ErrorMessage : String;

  // Get count of read elements. If this method is used peek must be set true.
  function Count: Integer;
  // Get content of reply data as string.
  function ToString: String;override;

  // Is frame complete.
  property Complete: Boolean read FComplete write FComplete;
  // Is more data available. Return None if more data is not available or Frame or Block type.
  property MoreData: TRequestTypes read FMoreData write FMoreData;
  // Packet length.
  property PacketLength: Integer read FPacketLength write FPacketLength;
  // Received error.
  property Error: SmallInt read FError write FError;
  // Received command.
  property Command: TCommand read FCommand write FCommand;
  // Received command.
  property CipheredCommand: TCommand read FCipheredCommand write FCipheredCommand;

  //  Is HDLC streaming in progress.
  property HdlcStreaming: Boolean read FHdlcStreaming write FHdlcStreaming;

  // Received command type.
  property CommandType: Byte read FCommandType write FCommandType;
  // Received data.
  property Data: TGXByteBuffer read FData write FData;
  property ValueType : TDataType read FDataType write FDataType;

  // Expected count of elements in the array.
  property TotalCount: Integer read FTotalCount write FTotalCount;
  // Last read position. This is used in peek to solve how far data is read.
  property ReadPosition : Integer read FReadPosition write FReadPosition;
  // Read value.
  property Value: TValue read FValue write FValue;
  // Data notification date time.
  property Time: TDateTime read FTime write FTime;
  // Is value try to peek.
  property Peek: Boolean read FPeek write FPeek;
  // Cipher index is position where data is decrypted.
  property CipherIndex : Integer read FCipherIndex write FCipherIndex;
   // HDLC frame ID.
  property FrameId : Byte read FFrameId write FFrameId;

  property Xml: TGXDLMSTranslatorStructure read FXml write FXml;

  //Is GBT streaming in use.
  property Streaming: Boolean read FStreaming write FStreaming;
  //GBT Window size.
  property GbtWindowSize : Byte read FGbtWindowSize write FGbtWindowSize;
  //GBT block number.
  property BlockNumber : Byte read FBlockNumber write FBlockNumber;
  //GBT block number ACK.
  property BlockNumberAck : Byte read FBlockNumberAck write FBlockNumberAck;

  // Client address of the notification message.
  property ClientAddress : Integer read FClientAddress write FClientAddress;
  //Server address of the notification message.
  property ServerAddress : Integer read FServerAddress write FServerAddress;

  // Is GBT or HDLC streaming used.
  function IsStreaming: Boolean;
end;

implementation

constructor TGXReplyData.Create(AMore: TRequestTypes; ACommand: TCommand; buff:
  TGXByteBuffer; AComplete: Boolean; error: Byte);
begin
  FData := TGXByteBuffer.Create();
  Clear();
  FMoreData := AMore;
  FCommand := ACommand;
  FData := buff;
  FComplete := AComplete;
  FError := error;
  FClientAddress := 0;
  FServerAddress := 0;
  FHdlcStreaming := False;
end;

constructor TGXReplyData.Create();
begin
  FData := TGXByteBuffer.Create();
  Clear();
end;

destructor TGXReplyData.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

procedure TGXReplyData.Clear;
begin
  FMoreData := TRequestTypes.rtNone;
  FCommand := TCommand.None;
  FCommandType := 0;
  FData.Capacity(0);
  FComplete := false;
  FError := 0;
  FTotalCount := 0;
  FValue := Nil;
  FReadPosition := 0;
  FPacketLength := 0;
  FDataType := TDataType.dtNone;
  FCipherIndex := 0;
  FTime := 0;
  FStreaming := False;
  FGbtWindowSize := 0;
  FXml := Nil;
end;

function TGXReplyData.ToString : String;
begin
  if FData <> Nil Then
    Result := TGXByteBuffer.ToHexString(FData.GetData(), true, 0, FData.Size);
end;

function TGXReplyData.IsMoreData: Boolean;
begin
  Result:= (FMoreData <> TRequestTypes.rtNone) and (FError = 0);
end;

function TGXReplyData.Count: Integer;
begin
  if FValue.IsArray Then
    Result := FValue.GetArrayLength
  else
    Result := 0;
end;

function TGXReplyData.ErrorMessage : String;
begin
  Result:= TGXCommon.GetDescription(FError);
end;

/// <summary>
/// Is GBT or HDLC streaming used.
/// </summary>
/// <returns></returns>
function TGXReplyData.IsStreaming: Boolean;
begin
    Result := (((Integer(MoreData) and Integer(TRequestTypes.rtFrame)) = 0) and
        FStreaming and ((BlockNumberAck * GbtWindowSize) + 1 > BlockNumber)) or
        (((Integer(MoreData) and Integer(TRequestTypes.rtFrame)) = Integer(TRequestTypes.rtFrame)) and FHdlcStreaming);
end;
end.

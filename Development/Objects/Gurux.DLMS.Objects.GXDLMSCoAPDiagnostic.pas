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

unit Gurux.DLMS.Objects.GXDLMSCoAPDiagnostic;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.GXCoapMessagesCounter, GXByteBuffer,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.Objects.GXCoapRequestResponseCounter,
Gurux.DLMS.Objects.GXCoapBtCounter,
Gurux.DLMS.Objects.GXCoapCaptureTime;

type
TGXDLMSCoAPDiagnostic = class(TGXDLMSObject)
  // CoAP messages counter.
  FMessagesCounter: TGXCoapMessagesCounter;
  // CoAP request response counter.
  FRequestResponseCounter: TGXCoapRequestResponseCounter;
  // Bt counter.
  FBtCounter: TGXCoapBtCounter;
  // CoAP Capture time.
  FCaptureTime : TGXCoapCaptureTime;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // CoAP messages counter.
  property MessagesCounter: TGXCoapMessagesCounter read FMessagesCounter;
  // CoAP request response counter.
  property RequestResponseCounter: TGXCoapRequestResponseCounter read FRequestResponseCounter;
  // Bt counter.
  property BtCounter: TGXCoapBtCounter read FBtCounter;
  // CoAP Capture time.
  property CaptureTime: TGXCoapCaptureTime read FCaptureTime;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
end;

implementation

constructor TGXDLMSCoAPDiagnostic.Create;
begin
  Create('0.0.25.17.0.255', 0);
end;

constructor TGXDLMSCoAPDiagnostic.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSCoAPDiagnostic.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otCoAPDiagnostic, ln, sn);
    FMessagesCounter := TGXCoapMessagesCounter.Create;
    FRequestResponseCounter := TGXCoapRequestResponseCounter.Create;
    FBtCounter := TGXCoapBtCounter.Create;
    FCaptureTime := TGXCoapCaptureTime.Create;
end;

function TGXDLMSCoAPDiagnostic.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName,
    FMessagesCounter,
    FRequestResponseCounter,
    FBtCounter,
    FCaptureTime);
end;

function TGXDLMSCoAPDiagnostic.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //MessagesCounter
    if All or CanRead(2) then
      items.Add(2);
    //RequestResponseCounter
    if all or CanRead(3) then
      items.Add(3);
    //BtCounter
    if all or CanRead(4) then
      items.Add(4);
    // CaptureTime
    if all or CanRead(5) then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSCoAPDiagnostic.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSCoAPDiagnostic.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSCoAPDiagnostic.GetDataType(index: Integer): TDataType;
begin
 case index of
    1: Result := TDataType.dtOctetString;
    2 .. 5: Result := TDataType.dtStructure;
    else raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSCoAPDiagnostic.GetValue(e: TValueEventArgs): TValue;
var
  buff : TGXByteBuffer;
begin
  if (e.Index = 1) then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if (e.Index = 2) then
  begin
    buff := TGXByteBuffer.Create;
    try
      buff.SetUInt8(Integer(TDataType.dtStructure));
      TGXCommon.SetObjectCount(10, buff);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.Tx);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.Rx);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.TxResend);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.TxReset);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.RxReset);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.TxAck);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.RxAck);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.RxDrop);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.TxNonPiggybacked);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FMessagesCounter.MaxRtxExceeded);
      Result := TValue.From(buff.ToArray());
    finally
      buff.Free;
    end;
  end
  else if (e.Index = 3) then
  begin
    buff := TGXByteBuffer.Create;
    try
      buff.SetUInt8(Integer(TDataType.dtStructure));
      TGXCommon.SetObjectCount(8, buff);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.RxRequests);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.TxRequests);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.RxResponse);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.TxResponse);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.TxClientError);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.RxClientError);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.TxServerError);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FRequestResponseCounter.RxServerError);
      Result := TValue.From(buff.ToArray());
    finally
      buff.Free;
    end;
  end
  else if (e.Index = 4) then
  begin
    buff := TGXByteBuffer.Create;
    try
      buff.SetUInt8(Integer(TDataType.dtStructure));
      TGXCommon.SetObjectCount(3, buff);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FBtCounter.BlockWiseTransferStarted);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FBtCounter.BlockWiseTransferCompleted);
      TGXCommon.SetData(buff, TDataType.dtUInt32, FBtCounter.BlockWiseTransferTimeout);
      Result := TValue.From(buff.ToArray());
    finally
      buff.Free;
    end;
  end
  else if (e.Index = 5) then
  begin
    buff := TGXByteBuffer.Create;
    try
      buff.SetUInt8(Integer(TDataType.dtStructure));
      TGXCommon.SetObjectCount(2, buff);
      TGXCommon.SetData(buff, TDataType.dtUInt8, FCaptureTime.AttributeId);
      TGXCommon.SetData(buff, TDataType.dtDateTime, FCaptureTime.TimeStamp);
      Result := TValue.From(buff.ToArray());
    finally
      buff.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSCoAPDiagnostic.SetValue(e: TValueEventArgs);
var
  s: TArray<TValue>;
begin
  if (e.Index = 1) then
    FLogicalName := TGXCommon.ToLogicalName(e.Value)
  else if (e.Index = 2) then
     if Not e.Value.IsEmpty Then
     begin
        s := e.Value.AsType<TArray<TValue>>();
        FMessagesCounter.Tx := s[0].AsType<UInt32>;
        FMessagesCounter.Rx:= s[1].AsType<UInt32>;
        FMessagesCounter.TxResend := s[2].AsType<UInt32>;
        FMessagesCounter.TxReset := s[3].AsType<UInt32>;
        FMessagesCounter.RxReset:= s[4].AsType<UInt32>;
        FMessagesCounter.TxAck := s[5].AsType<UInt32>;
        FMessagesCounter.RxAck := s[6].AsType<UInt32>;
        FMessagesCounter.RxDrop := s[7].AsType<UInt32>;
        FMessagesCounter.TxNonPiggybacked:= s[8].AsType<UInt32>;
        FMessagesCounter.MaxRtxExceeded := s[9].AsType<UInt32>;
     end
  else if (e.Index = 3) then
     if Not e.Value.IsEmpty Then
      begin
        s := e.Value.AsType<TArray<TValue>>();
        RequestResponseCounter.RxRequests := s[0].AsType<UInt32>;
        RequestResponseCounter.TxRequests := s[1].AsType<UInt32>;
        RequestResponseCounter.RxResponse := s[2].AsType<UInt32>;
        RequestResponseCounter.TxResponse := s[3].AsType<UInt32>;
        RequestResponseCounter.TxClientError := s[4].AsType<UInt32>;
        RequestResponseCounter.RxClientError := s[5].AsType<UInt32>;
        RequestResponseCounter.TxServerError := s[6].AsType<UInt32>;
        RequestResponseCounter.RxServerError := s[7].AsType<UInt32>;
     end
  else if (e.Index = 4) then
     if Not e.Value.IsEmpty Then
      begin
        s := e.Value.AsType<TArray<TValue>>();
        FBtCounter.BlockWiseTransferStarted := s[0].AsType<UInt32>;
        FBtCounter.BlockWiseTransferCompleted := s[1].AsType<UInt32>;
        FBtCounter.BlockWiseTransferTimeout := s[2].AsType<UInt32>;
     end
  else if (e.Index = 5) then
     if Not e.Value.IsEmpty Then
      begin
        s := e.Value.AsType<TArray<TValue>>();
        FCaptureTime.AttributeId := s[0].AsType<Byte>;
        FCaptureTime.TimeStamp := s[1].AsType<TGXDateTime>;
     end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSCoAPDiagnostic.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

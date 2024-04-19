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

unit Gurux.DLMS.Objects.GXDLMSCoAPSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.GXDLMSTcpUdpSetup,
Gurux.DLMS.Objects.Enums.TransportMode;

type
TGXDLMSCoAPSetup = class(TGXDLMSObject)
public
  // TCP-UDP setup object.
  UdpReference : TGXDLMSTcpUdpSetup;

  // The minimum initial ACK timeout in milliseconds.
  AckTimeout: UInt16;

  // The random factor to apply for randomness of the initial ACK timeout.
  AckRandomFactor: UInt16;

  // The maximum number of retransmissions for a confirmable message.
  MaxRetransmit: UInt16;

  // The amount of simultaneous outstanding CoAP request messages.
  NStart: UInt16;

  // Delay acknowledge timeout in milliseconds.
  DelayAckTimeout: UInt16;

  // Exponential back off.
  ExponentialBackOff: UInt16;

  // Probing rate.
  ProbingRate: UInt16;

  // CoAP Uri path.
  CoAPUriPath: string;

  // CoAP transport mode.
  TransportMode: TTransportMode;

  // The version of the DLMS/COSEM CoAP wrapper.
  WrapperVersion: TValue;

  // The length of the Token.
  TokenLength: byte;


  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

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

constructor TGXDLMSCoAPSetup.Create;
begin
  Create('0.0.25.16.0.255', 0);
end;

constructor TGXDLMSCoAPSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSCoAPSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otCoAPSetup, ln, sn);
end;

function TGXDLMSCoAPSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName,
    UdpReference,
    AckTimeout,
    AckRandomFactor,
    MaxRetransmit,
    NStart,
    DelayAckTimeout,
    ExponentialBackOff,
    ProbingRate,
    CoAPUriPath,
    Integer(TransportMode),
    WrapperVersion,
    TokenLength);
end;

function TGXDLMSCoAPSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //UdpReference
    if All or CanRead(2) then
      items.Add(2);
    // AckTimeout
    if all or CanRead(3) then
      items.Add(3);

    // AckRandomFactor
    if all or CanRead(4) then
      items.Add(4);

    // MaxRetransmit
    if all or CanRead(5) then
      items.Add(5);

    // NStart
    if all or CanRead(6) then
      items.Add(6);

    // DelayAckTimeout
    if all or CanRead(7) then
      items.Add(7);

    // ExponentialBackOff
    if all or CanRead(8) then
      items.Add(8);

    // ProbingRate
    if all or CanRead(9) then
      items.Add(9);

    // CoAPUriPath
    if all or CanRead(10) then
      items.Add(10);

    // TransportMode
    if all or CanRead(11) then
      items.Add(11);

    // WrapperVersion
    if all or CanRead(12) then
      items.Add(12);

    // TokenLength
    if all or CanRead(13) then
      items.Add(13);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSCoAPSetup.GetAttributeCount: Integer;
begin
  Result := 13;
end;

function TGXDLMSCoAPSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSCoAPSetup.GetDataType(index: Integer): TDataType;
begin
  case index of
    1, 2, 10: Result := TDataType.dtOctetString;
    3, 4, 5, 6, 7, 8, 9: Result := TDataType.dtUInt16;
    11: Result := TDataType.dtEnum;
    12: begin
    Result := inherited GetDataType(index);
    if (Result = TDataType.dtNone) and (WrapperVersion.IsEmpty = False) Then
        Result := TGXCommon.GetDLMSDataType(WrapperVersion);
    end;
    13: Result := TDataType.dtUInt8;
    else raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSCoAPSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if (e.Index = 1) then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if (e.Index = 2) then
  begin
    if UdpReference <> Nil then
     Result := TValue.From(TGXDLMSObject.GetLogicalName(UdpReference.LogicalName))
    else
      Result := Nil;
  end
  else if (e.Index = 3) then
     Result := AckTimeout
  else if (e.Index = 4) then
     Result := AckRandomFactor
  else if (e.Index = 5) then
     Result := MaxRetransmit
  else if (e.Index = 6) then
     Result := NStart
  else if (e.Index = 7) then
     Result := DelayAckTimeout
  else if (e.Index = 8) then
     Result := ExponentialBackOff
  else if (e.Index = 9) then
     Result := ProbingRate
  else if (e.Index = 10) then
     Result := CoAPUriPath
  else if (e.Index = 11) then
     Result := Integer(TransportMode)
  else if (e.Index = 12) then
     Result := WrapperVersion
  else if (e.Index = 13) then
     Result := TokenLength
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSCoAPSetup.SetValue(e: TValueEventArgs);
var
  ln: string;
begin
  if (e.Index = 1) then
    FLogicalName := TGXCommon.ToLogicalName(e.Value)
  else if (e.Index = 2) then
  begin
    ln := TGXCommon.ToLogicalName(e.Value);
    UdpReference := TGXDLMSTcpUdpSetup(e.Settings.Objects.FindByLN(TObjectType.otTcpUdpSetup, ln));
    if UdpReference = Nil Then
      UdpReference := TGXDLMSTcpUdpSetup.Create(ln);
  end
  else if (e.Index = 3) then
  begin
   AckTimeout := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 4) then
  begin
   AckRandomFactor := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 5) then
  begin
   MaxRetransmit := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 6) then
  begin
   NStart := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 7) then
  begin
   DelayAckTimeout := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 8) then
  begin
   ExponentialBackOff := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 9) then
  begin
   ProbingRate := e.Value.AsType<UInt16>;
  end
  else if (e.Index = 10) then
  begin
   CoAPUriPath := TEncoding.ASCII.GetString(e.Value.AsType<TBytes>);
  end
  else if (e.Index = 11) then
  begin
   TransportMode := TTransportMode(e.Value.AsInteger);
  end
  else if (e.Index = 12) then
  begin
   WrapperVersion := e.Value.AsType<TValue>;
  end
  else if (e.Index = 13) then
  begin
   TokenLength := e.Value.AsType<UInt16>;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSCoAPSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

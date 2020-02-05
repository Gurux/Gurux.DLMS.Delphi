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

unit Gurux.DLMS.Objects.GXDLMSHdlcSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections, Gurux.DLMS.BaudRate,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSHdlcSetup = class(TGXDLMSObject)
  FCommunicationSpeed: TBaudRate;
  FDeviceAddress, FInactivityTimeout, FInterCharachterTimeout, FMaximumInfoLengthReceive, FMaximumInfoLengthTransmit, FWindowSizeReceive, FWindowSizeTransmit : Integer;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property CommunicationSpeed: TBaudRate read FCommunicationSpeed write FCommunicationSpeed;

  property WindowSizeTransmit: Integer read FWindowSizeTransmit write FWindowSizeTransmit;

  property WindowSizeReceive: Integer read FWindowSizeReceive write FWindowSizeReceive;

  property MaximumInfoLengthTransmit: Integer read FMaximumInfoLengthTransmit write FMaximumInfoLengthTransmit;

  property MaximumInfoLengthReceive: Integer read FMaximumInfoLengthReceive write FMaximumInfoLengthReceive;

  property InterCharachterTimeout: Integer read FMaximumInfoLengthReceive write FMaximumInfoLengthReceive;

  property InactivityTimeout: Integer read FInactivityTimeout write FInactivityTimeout;

  property DeviceAddress: Integer read FDeviceAddress write FDeviceAddress;

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

constructor TGXDLMSHdlcSetup.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSHdlcSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSHdlcSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otIecHdlcSetup, ln, 0);
end;

function TGXDLMSHdlcSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FCommunicationSpeed),
                FWindowSizeTransmit, FWindowSizeReceive,
                FMaximumInfoLengthTransmit, FMaximumInfoLengthReceive,
                FInterCharachterTimeout, FInactivityTimeout, FDeviceAddress );
end;

function TGXDLMSHdlcSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //CommunicationSpeed
    if All or Not IsRead(2) Then
      items.Add(2);
    //WindowSizeTransmit
    if All or Not IsRead(3) Then
      items.Add(3);
    //WindowSizeReceive
    if All or Not IsRead(4) Then
      items.Add(4);
    //MaximumInfoLengthTransmit
    if All or Not IsRead(5) Then
      items.Add(5);
    //MaximumInfoLengthReceive
    if All or Not IsRead(6) Then
      items.Add(6);
    //InterCharachterTimeout
    if All or Not IsRead(7) Then
      items.Add(7);
    //InactivityTimeout
    if All or Not IsRead(8) Then
      items.Add(8);
    //DeviceAddress
    if All or Not IsRead(9) Then
      items.Add(9);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSHdlcSetup.GetAttributeCount: Integer;
begin
  Result := 9;
end;

function TGXDLMSHdlcSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSHdlcSetup.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 7 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSHdlcSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(FCommunicationSpeed);
  end
  else if e.Index = 3 Then
  begin
    Result := FWindowSizeTransmit;
  end
  else if e.Index = 4 Then
  begin
    Result := FWindowSizeReceive;
  end
  else if e.Index = 5 Then
  begin
    Result := FMaximumInfoLengthTransmit;
  end
  else if e.Index = 6 Then
  begin
    Result := FMaximumInfoLengthReceive;
  end
  else if e.Index = 7 Then
  begin
    Result := FInterCharachterTimeout;
  end
  else if e.Index = 8 Then
  begin
    Result := FInactivityTimeout;
  end
  else if e.Index = 9 Then
  begin
    Result := FDeviceAddress;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSHdlcSetup.SetValue(e: TValueEventArgs);
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 then
  begin
    FCommunicationSpeed := TBaudRate(e.Value.AsInteger);
  end
  else if e.Index = 3 then
  begin
    FWindowSizeTransmit := e.Value.AsInteger;
  end
  else if e.Index = 4 then
  begin
    FWindowSizeReceive := e.Value.AsInteger;
  end
  else if e.Index = 5 then
  begin
    FMaximumInfoLengthTransmit := e.Value.AsInteger;
  end
  else if e.Index = 6 then
  begin
    FMaximumInfoLengthReceive := e.Value.AsInteger;
  end
  else if e.Index = 7 then
  begin
    FInterCharachterTimeout := e.Value.AsInteger;
  end
  else if e.Index = 8 then
  begin
    FInactivityTimeout := e.Value.AsInteger;
  end
  else if e.Index = 9 then
  begin
    FDeviceAddress := e.Value.AsInteger;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSHdlcSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

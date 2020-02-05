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

unit Gurux.DLMS.Objects.GXDLMSMBusSlavePortSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DMLS.AddressState, Gurux.DLMS.BaudRate;

type
TGXDLMSMBusSlavePortSetup = class(TGXDLMSObject)
  FDefaultBaud: TBaudRate;
  FAvailableBaud: TBaudRate;
  FAddressState : TAddressState;
  FBusAddress : Integer;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Defines the baud rate for the opening sequence.
  property DefaultBaud: TBaudRate read FDefaultBaud write FDefaultBaud;

  // Defines the baud rate for the opening sequence.
  property AvailableBaud: TBaudRate read FAvailableBaud write FAvailableBaud;

  // Defines whether or not the device has been assigned an address
  // since last power up of the device.
  property AddressState: TAddressState read FAddressState write FAddressState;

  // Defines the baud rate for the opening sequence.
  property BusAddress : Integer read FBusAddress write FBusAddress;

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

constructor TGXDLMSMBusSlavePortSetup.Create;
begin
  inherited Create(TObjectType.otMBusSlavePortSetup);
end;

constructor TGXDLMSMBusSlavePortSetup.Create(ln: string);
begin
  inherited Create(TObjectType.otMBusSlavePortSetup, ln, 0);
end;

constructor TGXDLMSMBusSlavePortSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otMBusSlavePortSetup, ln, 0);
end;

function TGXDLMSMBusSlavePortSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FDefaultBaud),
          Integer(FAvailableBaud), Integer(FAddressState), FBusAddress);
end;

function TGXDLMSMBusSlavePortSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //DefaultBaud
    if All or Not IsRead(2) Then
      items.Add(2);
    //AvailableBaud
    if All or Not IsRead(3) Then
      items.Add(3);
    //AddressState
    if All or Not IsRead(4) Then
      items.Add(4);
    //BusAddress
    if All or Not IsRead(5) Then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSMBusSlavePortSetup.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSMBusSlavePortSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSMBusSlavePortSetup.GetDataType(index: Integer): TDataType;
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
    Result := TDataType.dtEnum;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSMBusSlavePortSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(DefaultBaud);
  end
  else if e.Index = 3 Then
  begin
    Result := Integer(AvailableBaud);
  end
  else if e.Index = 4 Then
  begin
    Result := Integer(AddressState);
  end
  else if e.Index = 5 Then
  begin
    Result := BusAddress;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSMBusSlavePortSetup.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    if e.Value.IsEmpty Then
    begin
      FDefaultBaud := TBaudRate.Baudrate300;
    end
    else
    begin
      FDefaultBaud := TBaudRate(e.Value.AsInteger);
    end;
  end
  else if e.Index = 3 Then
  begin
    if e.Value.IsEmpty Then
    begin
      FAvailableBaud := TBaudRate.Baudrate300;
    end
    else
    begin
      FAvailableBaud := TBaudRate(e.Value.AsInteger);
    end;
  end
  else if e.Index = 4 Then
  begin
    if e.Value.IsEmpty Then
    begin
      FAddressState := TAddressState.None;
    end
    else
    begin
      FAddressState := TAddressState(e.Value.AsInteger);
    end;
  end
  else if e.Index = 5 Then
  begin
    if e.Value.IsEmpty Then
    begin
      FBusAddress := 0;
    end
    else
    begin
      FBusAddress := e.Value.AsInteger;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSMBusSlavePortSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

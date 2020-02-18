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

unit Gurux.DLMS.Objects.GXDLMSIp6Setup;

interface

uses GXCommon, IdGlobal, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject, GXByteBuffer;

type

// Enumerated Address config modes.
TAddressConfigMode = (
  // Auto Configuration.
  Auto = 0,
  // DHCP v6.
  DHCPv6,
  // Manual
  Manual,
  // Neighbour Discovery.
  NeighbourDiscovery
);

// Contains the configuration to be used for both routers and hosts to support the Neighbor Discovery protocol for IPv6.
TGXNeighborDiscoverySetup = class
  public
    MaxRetry: BYTE;
    RetryWaitTime: UInt16;
    SendPeriod: UInt32;
end;

TGXDLMSIp6Setup = class(TGXDLMSObject)
  FDataLinkLayerReference : string;
  FAddressConfigMode: TAddressConfigMode;
  FUnicastIPAddress : TArray<TIdIPv6Address>;
  FMulticastIPAddress : TArray<TIdIPv6Address>;
  FGatewayIPAddress : TArray<TIdIPv6Address>;
  FPrimaryDNSAddress : TIdIPv6Address;
  FSecondaryDNSAddress : TIdIPv6Address;
  FTrafficClass: BYTE;
  FNeighborDiscoverySetup: TArray<TGXNeighborDiscoverySetup>;

  class function GetIPv6AddressArray(AList: TValue): TArray<TIdIPv6Address>;
  class function AddressToBytes(AAddress: TIdIPv6Address): TBytes;

  public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property DataLinkLayerReference: string read FDataLinkLayerReference write FDataLinkLayerReference;
  property AddressConfigMode: TAddressConfigMode read FAddressConfigMode write FAddressConfigMode;
  property UnicastIPAddress: TArray<TIdIPv6Address> read FUnicastIPAddress write FUnicastIPAddress;
  property MulticastIPAddress: TArray<TIdIPv6Address> read FMulticastIPAddress write FMulticastIPAddress;
  property GatewayIPAddress: TArray<TIdIPv6Address> read FGatewayIPAddress write FGatewayIPAddress;
  property PrimaryDNSAddress: TIdIPv6Address read FPrimaryDNSAddress write FPrimaryDNSAddress;
  property SecondaryDNSAddress: TIdIPv6Address read FSecondaryDNSAddress write FSecondaryDNSAddress;
  property TrafficClass: BYTE read FTrafficClass write FTrafficClass;
  property NeighborDiscoverySetup: TArray<TGXNeighborDiscoverySetup> read FNeighborDiscoverySetup write FNeighborDiscoverySetup;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
  public
    destructor Destroy; override;
end;

implementation

constructor TGXDLMSIp6Setup.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSIp6Setup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSIp6Setup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otIp4Setup, ln, 0);
end;

destructor TGXDLMSIp6Setup.Destroy;
begin
  inherited;
end;

function TGXDLMSIp6Setup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FDataLinkLayerReference,
        TValue.From(FAddressConfigMode), TValue.From(FUnicastIPAddress),
        TValue.From(FMulticastIPAddress),
        TValue.From(FGatewayIPAddress), TValue.From(FPrimaryDNSAddress), TValue.From(FSecondaryDNSAddress),
        FTrafficClass, TValue.From(FNeighborDiscoverySetup));
end;

function TGXDLMSIp6Setup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //DataLinkLayerReference
    if All or Not IsRead(2) Then
      items.Add(2);
    //AddressConfigMode
    if All or Not IsRead(3) Then
      items.Add(3);
    //UnicastIPAddress
   if All or Not IsRead(4) Then
      items.Add(4);
    //MulticastIPAddress
    if All or Not IsRead(5) Then
      items.Add(5);
    //GatewayIPAddress
    if All or Not IsRead(6) Then
      items.Add(6);
    //PrimaryDNSAddress
    if All or Not IsRead(7) Then
      items.Add(7);
    //SecondaryDNSAddress
    if All or Not IsRead(8) Then
      items.Add(8);
    //TrafficClass
   if All or Not IsRead(9) Then
      items.Add(9);
    //NeighborDiscoverySetup
    if All or Not IsRead(10) Then
      items.Add(10);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSIp6Setup.GetAttributeCount: Integer;
begin
  Result := 10;
end;

function TGXDLMSIp6Setup.GetMethodCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSIp6Setup.GetDataType(index: Integer): TDataType;
begin
  case index of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtOctetString;
  3: Result := TDataType.dtEnum;
  4: Result := TDataType.dtArray;
  5: Result := TDataType.dtArray;
  6: Result := TDataType.dtArray;
  7: Result := TDataType.dtOctetString;
  8: Result := TDataType.dtOctetString;
  9: Result := TDataType.dtUInt8;
  10: Result := TDataType.dtArray;
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

class function TGXDLMSIp6Setup.AddressToBytes(AAddress: TIdIPv6Address): TBytes;
var
  tmp: array[0..15] of Byte absolute AAddress;
begin
  SetLength(Result, 16);
  System.Move(tmp[0], Result[0], 16);
end;

function TGXDLMSIp6Setup.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  s: TIdIPv6Address;
  it: TGXNeighborDiscoverySetup;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FDataLinkLayerReference));
  end
  else if e.Index = 3 then
  begin
    Result := Integer(FAddressConfigMode);
  end
  else if e.Index = 4 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.SetUInt8(Integer(TDataType.dtArray));
      if FUnicastIPAddress = Nil Then
      begin
        //Object count is zero.
        data.SetUInt8(0);
      end
      else
      begin
        TGXCommon.SetObjectCount(Length(FUnicastIPAddress), data);
        for s in FUnicastIPAddress do
        begin
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(AddressToBytes(s)));
        end;
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 5 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.SetUInt8(Integer(TDataType.dtArray));
      if FMulticastIPAddress = Nil Then
      begin
        //Object count is zero.
        data.SetUInt8(0);
      end
      else
      begin
        TGXCommon.SetObjectCount(Length(FMulticastIPAddress), data);
        for s in FMulticastIPAddress do
        begin
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(AddressToBytes(s)));
        end;
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 6 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.SetUInt8(Integer(TDataType.dtArray));
      if FGatewayIPAddress = Nil Then
      begin
        //Object count is zero.
        data.SetUInt8(0);
      end
      else
      begin
        TGXCommon.SetObjectCount(Length(FGatewayIPAddress), data);
        for s in FGatewayIPAddress do
        begin
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(AddressToBytes(s)));
        end;
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 7 then
  begin
    Result := TValue.From(AddressToBytes(FPrimaryDNSAddress));
  end
  else if e.Index = 8 then
  begin
    Result := TValue.From(AddressToBytes(FSecondaryDNSAddress));
  end
  else if e.Index = 9 then
  begin
    Result := FTrafficClass;
  end
  else if e.Index = 10 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.SetUInt8(Integer(TDataType.dtArray));
      if FNeighborDiscoverySetup = Nil Then
        //Object count is zero.
        data.SetUInt8(0)
      else
      begin
        TGXCommon.SetObjectCount(Length(FNeighborDiscoverySetup), data);
        for it in FNeighborDiscoverySetup do
        begin
            data.SetUInt8(Integer(TDataType.dtStructure));
            data.SetUInt8(3);
            TGXCommon.SetData(data, TDataType.dtUInt8, it.MaxRetry);
            TGXCommon.SetData(data, TDataType.dtUInt16, it.RetryWaitTime);
            TGXCommon.SetData(data, TDataType.dtUInt32, it.SendPeriod);
        end;
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

class function TGXDLMSIp6Setup.GetIPv6AddressArray(AList: TValue): TArray<TIdIPv6Address>;
var
  data : TList<TIdIPv6Address>;
  it : TValue;
  tmp: TIdIPv6Address;
begin
  data := TList<TIdIPv6Address>.Create;
  try
    if Not AList.IsEmpty Then
    begin
      for it in AList.AsType<TArray<TValue>> do
      begin
        BytesToIPv6(TIdBytes(it.AsType<TBytes>()), tmp);
        data.Add(tmp);
      end
    end;
    Result := data.ToArray();
  finally
    FreeAndNil(data);
  end;
end;

procedure TGXDLMSIp6Setup.SetValue(e: TValueEventArgs);
var
  it : TValue;
  item: TGXNeighborDiscoverySetup;
  list: TList<TGXNeighborDiscoverySetup>;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 then
  begin
    FDataLinkLayerReference := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 3 then
  begin
    FAddressConfigMode := TAddressConfigMode(e.Value.AsInteger);
  end
  else if e.Index = 4 then
  begin
    FUnicastIPAddress := GetIPv6AddressArray(e.Value);
  end
  else if e.Index = 5 then
  begin
    FMulticastIPAddress := GetIPv6AddressArray(e.Value);
  end
  else if e.Index = 6 then
  begin
    FGatewayIPAddress := GetIPv6AddressArray(e.Value);
  end
  else if e.Index = 7 then
  begin
    if Not e.Value.IsEmpty then
      BytesToIPv6(TIdBytes(e.Value.AsType<TBytes>()), FPrimaryDNSAddress);
  end
  else if e.Index = 8 then
  begin
    if Not e.Value.IsEmpty then
      BytesToIPv6(TIdBytes(e.Value.AsType<TBytes>()), FSecondaryDNSAddress);
  end
  else if e.Index = 9 then
  begin
    FTrafficClass := e.Value.AsInteger();
  end
  else if e.Index = 10 then
  begin
    list := TList<TGXNeighborDiscoverySetup>.Create();
    try
    if Not e.Value.IsEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
      begin
        item := TGXNeighborDiscoverySetup.Create();
        item.MaxRetry := it.AsType<TArray<TValue>>()[0].AsInteger();
        item.RetryWaitTime := it.AsType<TArray<TValue>>()[1].AsInteger();
        item.SendPeriod := it.AsType<TArray<TValue>>()[2].AsInteger();
        list.Add(item);
      end
    end;
    FNeighborDiscoverySetup := list.ToArray();
  finally
    FreeAndNil(list);
  end;
  end
  else
  begin
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end
end;

function TGXDLMSIp6Setup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

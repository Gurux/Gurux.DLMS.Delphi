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

unit Gurux.DLMS.Objects.GXDLMSIp4Setup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject, GXByteBuffer,
IdGlobal;

type

TGXDLMSIp4SetupIpOptionType =
(
    // If this option is present, the device shall be allowed to send security,
    // compartmentation, handling restrictions and TCC (closed user group)
    // parameters within its IP Datagrams. The value of the IP-Option-
    // Length Field must be 11, and the IP-Option-Data shall contain the
    // value of the Security, Compartments, Handling Restrictions and
    // Transmission Control Code values, as specified in STD0005 / RFC791.
    Security = $82,
    // If this option is present, the device shall supply routing information to be
    // used by the gateways in forwarding the datagram to the destination, and to
    // record the route information.
    // The IP-Option-length and IP-Option-Data values are specified in STD0005 / RFC 791.
    LooseSourceAndRecordRoute = $83,
    // If this option is present, the device shall supply routing information to be
    // used by the gateways in forwarding the datagram to the destination, and to
    // record the route information.
    // The IP-Option-length and IP-Option-Data values are specified in STD0005 / RFC 791.
    StrictSourceAndRecordRoute = $89,
    // If this option is present, the device shall as well:
    // send originated IP Datagrams with that option, providing means
    // to record the route of these Datagrams;
    // as a router, send routed IP Datagrams with the route option
    // adjusted according to this option.
    // The IP-Option-length and IP-Option-Data values are specified in
    // STD0005 / RFC 791.
    RecordRoute = $07,
    // If this option is present, the device shall as well:
    // send originated IP Datagrams with that option, providing means
    // to time-stamp the datagram in the route to its destination;
    // as a router, send routed IP Datagrams with the time-stamp option
    // adjusted according to this option.
    // The IP-Option-length and IP-Option-Data values are specified in STD0005 / RFC 791.
    InternetTimestamp = $44
);

TGXDLMSIp4SetupIpOption = class
  FType : TGXDLMSIp4SetupIpOptionType;
  FLength : Byte;
  FData : TBytes;

  property &Type: TGXDLMSIp4SetupIpOptionType read FType write FType;
  property &Length: Byte read FLength write FLength;
  property Data: TBytes read FData write FData;
end;

TGXDLMSIp4Setup = class(TGXDLMSObject)
  FDataLinkLayerReference: String;
  FPrimaryDNSAddress, FGatewayIPAddress, FSubnetMask, FIPAddress : string;
  FSecondaryDNSAddress: string;
  FMulticastIPAddress : TArray<String>;
  FIPOptions : TArray<TGXDLMSIp4SetupIpOption>;
  FUseDHCP : Boolean;
  function ToAddressString(value: TValue): String;
  function FromAddressString(value: String): LongWord;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property DataLinkLayerReference: string read FDataLinkLayerReference write FDataLinkLayerReference;

  property IPAddress: String read FIPAddress write FIPAddress;

  property MulticastIPAddress: TArray<String> read FMulticastIPAddress write FMulticastIPAddress;

  property IPOptions: TArray<TGXDLMSIp4SetupIpOption> read FIPOptions write FIPOptions;

  property SubnetMask: String read FSubnetMask write FSubnetMask;

  property GatewayIPAddress: String read FGatewayIPAddress write FGatewayIPAddress;

  property UseDHCP: Boolean read FUseDHCP write FUseDHCP;

  property PrimaryDNSAddress: String read FPrimaryDNSAddress write FPrimaryDNSAddress;

  property SecondaryDNSAddress: String read FSecondaryDNSAddress write FSecondaryDNSAddress;

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

constructor TGXDLMSIp4Setup.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSIp4Setup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSIp4Setup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otIp4Setup, ln, 0);
end;

destructor TGXDLMSIp4Setup.Destroy;
var
  i: Integer;
begin
  if Assigned(FIPOptions) then
    for i := 0 to Length(FIPOptions) - 1 do
      FIPOptions[i].Free;
  inherited;
end;

function TGXDLMSIp4Setup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FDataLinkLayerReference, FIPAddress,
                Tvalue.From(FMulticastIPAddress), Tvalue.From(FIPOptions), FSubnetMask, FGatewayIPAddress,
                FUseDHCP, FPrimaryDNSAddress, FSecondaryDNSAddress );
end;

function TGXDLMSIp4Setup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
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
    //IPAddress
    if All or CanRead(3) Then
      items.Add(3);
    //MulticastIPAddress
    if All or CanRead(4) Then
      items.Add(4);
    //IPOptions
    if All or CanRead(5) Then
      items.Add(5);
    //SubnetMask
    if All or CanRead(6) Then
      items.Add(6);
    //GatewayIPAddress
    if All or CanRead(7) Then
      items.Add(7);
    //UseDHCP
    if All or Not IsRead(8) Then
      items.Add(8);
    //PrimaryDNSAddress
    if All or CanRead(9) Then
      items.Add(9);
    //SecondaryDNSAddress
    if All or CanRead(10) Then
      items.Add(10);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSIp4Setup.GetAttributeCount: Integer;
begin
  Result := 10;
end;

function TGXDLMSIp4Setup.GetMethodCount: Integer;
begin
  Result := 3;
end;

function TGXDLMSIp4Setup.GetDataType(index: Integer): TDataType;
begin
  case index of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtOctetString;
  3: Result := TDataType.dtUInt32;
  4: Result := TDataType.dtArray;
  5: Result := TDataType.dtArray;
  6: Result := TDataType.dtUInt32;
  7: Result := TDataType.dtUInt32;
  8: Result := TDataType.dtBoolean;
  9: Result := TDataType.dtUInt32;
  10: Result := TDataType.dtUInt32;
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSIp4Setup.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TGXDLMSIp4SetupIpOption;
  s: String;
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
    Result := FromAddressString(FIPAddress);
  end
  else if e.Index = 4 then
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
          TGXCommon.SetData(data, TDataType.dtUInt32, FromAddressString(s));
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
      if FIPOptions = Nil Then
      begin
          data.Add(1);
      end
      else
      begin
        TGXCommon.SetObjectCount(Length(FIPOptions), data);
        for it in IPOptions do
        begin
            data.Add(Integer(TDataType.dtStructure));
            data.Add(3);
            TGXCommon.SetData(data, TDataType.dtUInt8, Integer(it.&Type));
            TGXCommon.SetData(data, TDataType.dtUInt8, it.Length);
            TGXCommon.SetData(data, TDataType.dtOctetString, Tvalue.From(it.Data));
        end
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 6 then
  begin
    Result := FromAddressString(FSubnetMask);
  end
  else if e.Index = 7 then
  begin
    Result := FromAddressString(FGatewayIPAddress);
  end
  else if e.Index = 8 then
  begin
    Result := FUseDHCP;
  end
  else if e.Index = 9 then
  begin
    Result := FromAddressString(FPrimaryDNSAddress);
  end
  else if e.Index = 10 then
  begin
    Result := FromAddressString(FSecondaryDNSAddress);
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

function TGXDLMSIp4Setup.ToAddressString(value: TValue): String;
var
  tmp: Integer;
begin
  tmp := value.AsInteger;
  Result := IntToStr((tmp shr 24) and $FF) + '.' +
    IntToStr((tmp shr 16) and $FF) + '.' +
    IntToStr((tmp shr 8) and $FF) + '.' + IntToStr(tmp and $FF);
end;

function TGXDLMSIp4Setup.FromAddressString(value: String): LongWord;
var
  items: TArray<string>;
begin
  items := value.Split(['.']);
  if Length(items) <> 4 Then
      raise EArgumentException.Create('Invalid IP address.');
  Result := StrToInt(items[3]);
  Result := Result + StrToInt(items[2]) shl 8;
  Result := Result + StrToInt(items[1]) shl 16;
  Result := Result + StrToInt(items[0]) shl 24;
end;

procedure TGXDLMSIp4Setup.SetValue(e: TValueEventArgs);
var
  data1 : TList<String>;
  data2 : TList<TGXDLMSIp4SetupIpOption>;
  it : TValue;
  item : TGXDLMSIp4SetupIpOption;
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
    FIPAddress := ToAddressString(e.Value);
  end
  else if e.Index = 4 then
  begin
    data1 := TList<String>.Create;
    try
      if Not e.Value.IsEmpty Then
      begin
        for it in e.Value.AsType<TArray<TValue>> do
        begin
          data1.Add(ToAddressString(it));
        end
      end;
      FMulticastIPAddress := data1.ToArray();
    finally
      FreeAndNil(data1);
    end;
  end
  else if e.Index = 5 then
  begin
    data2 := TList<TGXDLMSIp4SetupIpOption>.Create;
    try
      if Not e.Value.IsEmpty Then
      begin
        for it in e.Value.AsType<TArray<TValue>> do
        begin
          item := TGXDLMSIp4SetupIpOption.Create;
          try
            item.&Type := TGXDLMSIp4SetupIpOptionType(it.GetArrayElement(0).AsType<TValue>.AsInteger);
            item.Length := it.GetArrayElement(1).AsType<TValue>.AsInteger;
            item.Data := it.GetArrayElement(2).AsType<TValue>.AsType<TBytes>;
            except
            item.Free;
            raise;
          end;
          data2.Add(item);
        end
      end;
      FIPOptions := data2.ToArray();
    finally
      FreeAndNil(data2);
    end;
  end
  else if e.Index = 6 then
  begin
    FSubnetMask := ToAddressString(e.Value);
  end
  else if e.Index = 7 then
  begin
    FGatewayIPAddress := ToAddressString(e.Value);
  end
  else if e.Index = 8 then
  begin
    FUseDHCP := e.Value.AsBoolean;
  end
  else if e.Index = 9 then
  begin
    FPrimaryDNSAddress := ToAddressString(e.Value);
  end
  else if e.Index = 10 then
  begin
    FSecondaryDNSAddress := ToAddressString(e.Value);
  end
  else
  begin
  raise Exception.Create('SetValue failed. Invalid attribute index.');
  end
end;

function TGXDLMSIp4Setup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

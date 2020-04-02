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

unit Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData;

interface

uses GXCommon,
SysUtils,
Rtti,
GXByteBuffer,
System.Generics.Collections,
Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.GXMacMulticastEntry,
Gurux.DLMS.Objects.GXMacDirectTable,
Gurux.DLMS.Objects.GXMacAvailableSwitch,
Gurux.DLMS.Objects.GXMacPhyCommunication;

type
// Online help:
// https://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData
TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData = class(TGXDLMSObject)
  // List of entries in multicast switching table.
  FMulticastEntries: TObjectList<TGXMacMulticastEntry>;
  // Switch table.
  FSwitchTable: TList<Int16>;
  // List of entries in multicast switching table.
  FDirectTable: TObjectList<TGXMacDirectTable>;
  // List of available switches.
  FAvailableSwitches: TObjectList<TGXMacAvailableSwitch>;
  // List of PHY communication parameters.
  FCommunications: TObjectList<TGXMacPhyCommunication>;

  function GetMulticastEntries(): TBytes;
  function GetSwitchTable(): TBytes;
  function GetDirectTable(): TBytes;
  function GetAvailableSwitches(): TBytes;
  function GetCommunications(): TBytes;

  procedure SetMulticastEntry(value: TArray<TValue>);
  procedure SetSwitchTable(value: TArray<TValue>);
  procedure SetDirectTable(value: TArray<TValue>);
  procedure SetAvailableSwitches(value: TArray<TValue>);
  procedure SetCommunications(value: TArray<TValue>);

  public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

    // List of entries in multicast switching table.
  property MulticastEntries: TObjectList<TGXMacMulticastEntry> read FMulticastEntries;
  // Switch table.
  property SwitchTable: TList<Int16> read FSwitchTable;
  // List of entries in multicast switching table.
  property DirectTable: TObjectList<TGXMacDirectTable> read FDirectTable;
  // List of available switches.
  property AvailableSwitches: TObjectList<TGXMacAvailableSwitch> read FAvailableSwitches;
  // List of PHY communication parameters.
  property Communications: TObjectList<TGXMacPhyCommunication> read FCommunications;

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

constructor TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.Create;
begin
  Create('0.0.28.5.0.255', 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPrimeNbOfdmPlcMacNetworkAdministrationData, ln, sn);
  FMulticastEntries := TObjectList<TGXMacMulticastEntry>.Create;
  FSwitchTable := TList<Int16>.Create;
  FDirectTable := TObjectList<TGXMacDirectTable>.Create;
  FAvailableSwitches := TObjectList<TGXMacAvailableSwitch>.Create;
  FCommunications := TObjectList<TGXMacPhyCommunication>.Create;
end;

destructor TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.Destroy;
begin
  FreeAndNil(FMulticastEntries);
  FreeAndNil(FSwitchTable);
  FreeAndNil(FDirectTable);
  FreeAndNil(FAvailableSwitches);
  FreeAndNil(FCommunications);
  inherited;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, MulticastEntries, SwitchTable, DirectTable, AvailableSwitches, Communications);
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //MulticastEntries
    if All or CanRead(2) then
      items.Add(2);
    // SwitchTables
    if All or CanRead(3) then
      items.Add(3);
    // DirectTable
    if All or CanRead(4) then
      items.Add(4);
    // AvailableSwitches
    if All or CanRead(5) then
      items.Add(5);
    // Communications
    if All or CanRead(6) then
      items.Add(6);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetAttributeCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetDataType(index: Integer): TDataType;
begin
case index of
  1: Result := TDataType.dtOctetString;
  2..6: Result := TDataType.dtArray;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetMulticastEntries(): TBytes;
var
  it: TGXMacMulticastEntry;
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
  try
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(MulticastEntries.Count, bb);
    for it in MulticastEntries do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(2);
      TGXCommon.SetData(bb, TDataType.dtInt8, it.Id);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.Members);
    end;
    Result := bb.ToArray;
  finally
    bb.Free();
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetSwitchTable(): TBytes;
var
  it: Int16;
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
  try
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(SwitchTable.Count, bb);
    for it in SwitchTable do
    begin
      TGXCommon.SetData(bb, TDataType.dtInt8, it);
    end;
    Result := bb.ToArray;
  finally
    bb.Free();
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetDirectTable(): TBytes;
var
  it: TGXMacDirectTable;
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
  try
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(DirectTable.Count, bb);
    for it in DirectTable do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(7);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.SourceSId);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.SourceLnId);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.SourceLcId);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.DestinationSId);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.DestinationLnId);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.DestinationLcId);
      TGXCommon.SetData(bb, TDataType.dtOctetString, TValue.From(it.Did));
    end;
    Result := bb.ToArray;
  finally
    bb.Free();
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetAvailableSwitches(): TBytes;
var
  it: TGXMacAvailableSwitch;
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
  try
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(AvailableSwitches.Count, bb);
    for it in AvailableSwitches do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(5);
      TGXCommon.SetData(bb, TDataType.dtOctetString, TValue.From(it.Sna));
      TGXCommon.SetData(bb, TDataType.dtInt32, it.LsId);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.Level);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.RxLevel);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.RxSnr);
    end;
    Result := bb.ToArray;
  finally
    bb.Free();
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetCommunications(): TBytes;
var
  it: TGXMacPhyCommunication;
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
  try
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(Communications.Count, bb);
    for it in Communications do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(9);
      TGXCommon.SetData(bb, TDataType.dtOctetString, TValue.From(it.Eui));
      TGXCommon.SetData(bb, TDataType.dtInt16, it.TxPower);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.TxCoding);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.RxCoding);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.RxLvl);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.Snr);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.TxPowerModified);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.TxCodingModified);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.RxCodingModified);
    end;
    Result := bb.ToArray;
  finally
    bb.Free();
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.GetValue(e: TValueEventArgs): TValue;
begin
  case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := TValue.From(GetMulticastEntries());
  3: Result := TValue.From(GetSwitchTable());
  4: Result := TValue.From(GetDirectTable());
  5: Result :=  TValue.From(GetAvailableSwitches());
  6: Result := TValue.From(GetCommunications());
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.SetMulticastEntry(value: TArray<TValue>);
var
  it: TValue;
  v: TGXMacMulticastEntry;
  tmp: TArray<TValue>;
begin
  MulticastEntries.Clear();
  if value <> Nil then
  begin
    for it in value do
    begin
      tmp := it.AsType<TArray<TValue>>();
      v := TGXMacMulticastEntry.Create();
      v.Id := tmp[0].AsInteger;
      v.Members := tmp[1].AsInteger;
      MulticastEntries.Add(v);
    end;
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.SetSwitchTable(value: TArray<TValue>);
var
  it: TValue;
begin
  SwitchTable.Clear();
  if value <> Nil then
  begin
    for it in value do
    begin
      SwitchTable.Add(it.AsInteger);
    end;
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.SetDirectTable(value: TArray<TValue>);
var
  it: TValue;
  v: TGXMacDirectTable;
  tmp: TArray<TValue>;
begin
  DirectTable.Clear();
  if value <> Nil then
  begin
    for it in value do
    begin
      tmp := it.AsType<TArray<TValue>>();
      v := TGXMacDirectTable.Create();
      v.SourceSId := tmp[0].AsInteger;
      v.SourceLnId := tmp[1].AsInteger;
      v.SourceLcId := tmp[2].AsInteger;
      v.DestinationSId := tmp[3].AsInteger;
      v.DestinationLnId := tmp[4].AsInteger;
      v.DestinationLcId := tmp[5].AsInteger;
      v.Did := tmp[6].AsType<TBytes>;
      DirectTable.Add(v);
    end;
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.SetAvailableSwitches(value: TArray<TValue>);
var
  it: TValue;
  v: TGXMacAvailableSwitch;
  tmp: TArray<TValue>;
begin
  AvailableSwitches.Clear();
  if value <> Nil then
  begin
    for it in value do
    begin
      tmp := it.AsType<TArray<TValue>>();
      v := TGXMacAvailableSwitch.Create();
      v.Sna := tmp[0].AsType<TBytes>;
      v.LsId := tmp[1].AsInteger;
      v.Level := tmp[2].AsInteger;
      v.RxLevel := tmp[3].AsInteger;
      v.RxSnr := tmp[4].AsInteger;
      AvailableSwitches.Add(v);
    end;
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.SetCommunications(value: TArray<TValue>);
var
  it: TValue;
  v: TGXMacPhyCommunication;
  tmp: TArray<TValue>;
begin
  Communications.Clear();
  if value <> Nil then
  begin
    for it in value do
    begin
      tmp := it.AsType<TArray<TValue>>();
      v := TGXMacPhyCommunication.Create();
      v.Eui := tmp[0].AsType<TBytes>;
      v.TxPower := tmp[1].AsInteger;
      v.TxCoding := tmp[2].AsInteger;
      v.RxCoding := tmp[3].AsInteger;
      v.RxLvl := tmp[4].AsInteger;
      v.Snr := tmp[5].AsInteger;
      v.TxPowerModified := tmp[6].AsInteger;
      v.TxCodingModified := tmp[7].AsInteger;
      v.RxCodingModified := tmp[8].AsInteger;
      Communications.Add(v);
    end;
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.SetValue(e: TValueEventArgs);
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: SetMulticastEntry(e.Value.AsType<TArray<TValue>>);
  3: SetSwitchTable(e.Value.AsType<TArray<TValue>>);
  4: SetDirectTable(e.Value.AsType<TArray<TValue>>);
  5: SetAvailableSwitches(e.Value.AsType<TArray<TValue>>);
  6: SetCommunications(e.Value.AsType<TArray<TValue>>);
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

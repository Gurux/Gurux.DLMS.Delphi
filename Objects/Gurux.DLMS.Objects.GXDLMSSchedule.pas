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

unit Gurux.DLMS.Objects.GXDLMSSchedule;

interface

uses GXCommon,
System.Generics.Collections,
SysUtils,
Rtti,
Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
GXByteBuffer,
Gurux.DLMS.Objects.Enums.Weekdays,
Gurux.DLMS.GXBitString,
Gurux.DLMS.GXTime,
Gurux.DLMS.GXDate,
Gurux.DLMS.Objects.GXScheduleEntry;

type
TGXDLMSSchedule = class(TGXDLMSObject)
  FEntries: TObjectList<TGXScheduleEntry>;
  procedure AddEntry(it: TGXScheduleEntry; data: TGXByteBuffer);
  function CreateEntry(it: TArray<TValue>): TGXScheduleEntry;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property Entries: TObjectList<TGXScheduleEntry> read FEntries write FEntries;

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

constructor TGXDLMSSchedule.Create;
begin
  Create('0.0.12.0.0.255', 0);
end;

constructor TGXDLMSSchedule.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSSchedule.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otSchedule, ln, sn);
  FEntries := TObjectList<TGXScheduleEntry>.Create();
end;

function TGXDLMSSchedule.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FEntries);
end;

function TGXDLMSSchedule.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //Entries
    if All or CanRead(2) then
      items.Add(2);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSSchedule.GetAttributeCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSSchedule.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSSchedule.GetDataType(index: Integer): TDataType;
begin
  if index = 1 then
    Result := TDataType.dtOctetString
  else if index = 2 then
    Result := TDataType.dtArray
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSSchedule.AddEntry(it: TGXScheduleEntry; data: TGXByteBuffer);
var
  bs: TGXBitString;
begin
  data.SetUInt8(Integer(TDataType.dtStructure));
  data.SetUInt8(10);
  //Add index.
  data.SetUInt8(Integer(TDataType.dtUInt16));
  data.SetUInt16(it.Index);
  //Add enable.
  data.SetUInt8(Integer(TDataType.dtBoolean));
  data.SetUInt8(Integer(it.Enable));
  //Add logical Name.
  data.SetUInt8(Integer(TDataType.dtOctetString));
  data.SetUInt8(6);
  data.SetArray(TGXCommon.LogicalNameToBytes(it.LogicalName));
  //Add script selector.
  data.SetUInt8(Integer(TDataType.dtUInt16));
  data.SetUInt16(it.ScriptSelector);
  //Add switch time.
  TGXCommon.SetData(data, TDataType.dtOctetString, it.SwitchTime);
  //Add validity window.
  data.SetUInt8(Integer(TDataType.dtUInt16));
  data.SetUInt16(it.ValidityWindow);
  //Add exec week days.
  bs := TGXBitString.Create(Integer(it.ExecWeekdays), 7);
  try
    TGXCommon.SetData(data, TDataType.dtBitString, bs.ToString());
  finally
    bs.Free();
  end;
  //Add exec spec days.
  TGXCommon.SetData(data, TDataType.dtBitString, it.ExecSpecDays);
  //Add begin date.
  TGXCommon.SetData(data, TDataType.dtOctetString, it.BeginDate);
  //Add end date.
  TGXCommon.SetData(data, TDataType.dtOctetString, it.EndDate);
end;

function TGXDLMSSchedule.GetValue(e: TValueEventArgs): TValue;
var
  data: TGXByteBuffer;
  it: TGXScheduleEntry;
begin
  if (e.Index = 1) then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if (e.Index = 2) then
  begin
    data := TGXByteBuffer.Create();
    try
      data.SetUInt8(Integer(TDataType.dtArray));
      TGXCommon.SetObjectCount(FEntries.Count, data);
      for it in FEntries do
        AddEntry(it, data);
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

function TGXDLMSSchedule.CreateEntry(it: TArray<TValue>): TGXScheduleEntry;
begin
  Result := TGXScheduleEntry.Create();
  Result.Index := it[0].AsInteger();
  Result.Enable := it[1].AsBoolean;
  Result.LogicalName := TGXCommon.ToLogicalName(it[2]);
  Result.ScriptSelector := it[3].AsInteger;
  Result.SwitchTime := TGXCommon.ChangeType(it[4].AsType<TValue>.AsType<TBytes>, TDataType.dtTime).AsType<TGXTime>;
  Result.ValidityWindow := it[5].AsInteger;
  Result.ExecWeekdays := TWeekdays(it[6].AsType<TGXBitString>.AsInteger());
  Result.ExecSpecDays := it[7].AsType<TGXBitString>.ToString();
  Result.BeginDate := TGXCommon.ChangeType(it[8].AsType<TValue>.AsType<TBytes>, TDataType.dtDate).AsType<TGXDate>();
  Result.EndDate := TGXCommon.ChangeType(it[9].AsType<TValue>.AsType<TBytes>, TDataType.dtDate).AsType<TGXDate>();
end;

procedure TGXDLMSSchedule.SetValue(e: TValueEventArgs);
var
  it: TValue;
begin
  if (e.Index = 1) then
    FLogicalName := TGXCommon.ToLogicalName(e.Value)
  else if (e.Index = 2) then
  begin
    FEntries.Clear();
    for it in e.Value.AsType<TArray<TValue>> do
      FEntries.Add(CreateEntry(it.AsType<TArray<TValue>>()));
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSSchedule.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

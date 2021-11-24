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

unit Gurux.DLMS.Objects.GXDLMSActionSchedule;

interface

uses GXCommon,
DateUtils,
SysUtils,
Rtti,
System.Generics.Collections,
Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.SingleActionScheduleType,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDate,
Gurux.DLMS.GXTime,
Gurux.DLMS.DateTimeSkips,
GXByteBuffer,
Gurux.DLMS.Enums.DateTimeExtraInfo;

type
TGXDLMSActionSchedule = class(TGXDLMSObject)
  FExecutedScriptSelector : Word;
  FExecutedScriptLogicalName: string;
  FType : TSingleActionScheduleType;
  FExecutionTime : TObjectList<TGXDateTime>;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property ExecutedScriptLogicalName: string read FExecutedScriptLogicalName write FExecutedScriptLogicalName;

  property ExecutedScriptSelector: Word read FExecutedScriptSelector write FExecutedScriptSelector;

  property &Type: TSingleActionScheduleType read FType write FType;

  property ExecutionTime: TObjectList<TGXDateTime> read FExecutionTime;

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

constructor TGXDLMSActionSchedule.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSActionSchedule.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSActionSchedule.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otActionSchedule, ln, 0);
  FExecutionTime := TObjectList<TGXDateTime>.Create;
end;

destructor TGXDLMSActionSchedule.Destroy;
begin
  inherited;
  FreeAndNil(FExecutionTime);
end;

function TGXDLMSActionSchedule.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName,
        FExecutedScriptLogicalName + ' ' + FExecutedScriptSelector.ToString,
        Integer(FType), TValue.From(FExecutionTime));
end;

function TGXDLMSActionSchedule.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //ExecutedScriptLogicalName is static and read only once.
    if All or Not IsRead(2) Then
      items.Add(2);
    //Type is static and read only once.
    if All or Not IsRead(3) Then
      items.Add(3);
    //ExecutionTime is static and read only once.
    if All or Not IsRead(4) Then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSActionSchedule.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSActionSchedule.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSActionSchedule.GetDataType(index: Integer): TDataType;
begin
  case index of
    1: Result := TDataType.dtOctetString;
    2: Result := TDataType.dtStructure;
    3: Result := TDataType.dtEnum;
    4: Result := TDataType.dtArray;
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSActionSchedule.GetValue(e: TValueEventArgs): TValue;
var
  stream : TGXByteBuffer;
  it, tmp : TGXDateTime;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    stream := TGXByteBuffer.Create();
    try
      stream.Add(Integer(TDataType.dtStructure));
      stream.Add(2);
      TGXCommon.SetData(stream, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes(ExecutedScriptLogicalName)));
      TGXCommon.SetData(stream, TDataType.dtUInt16, ExecutedScriptSelector);
      Result := TValue.From(stream.ToArray());
    finally
      stream.Free;
    end;
  end
  else if e.Index = 3 Then
  begin
    Result := Integer(FType);
  end
  else if e.Index = 4 Then
  begin
    stream := TGXByteBuffer.Create();
    try
      stream.Add(Integer(TDataType.dtArray));
      if ExecutionTime = Nil Then
      begin
        TGXCommon.SetObjectCount(0, stream);
      end
      else
      begin
        TGXCommon.SetObjectCount(FExecutionTime.Count, stream);
        for it in ExecutionTime do
        begin
          stream.Add(Integer(TDataType.dtStructure));
          stream.Add(2); //Count
          tmp := TGXTime.Create(it);
          try
            TGXCommon.SetData(stream, TDataType.dtOctetString, tmp); //Time
          finally
            FreeAndNil(tmp);
          end;
          tmp := TGXDate.Create(it);
          try
            TGXCommon.SetData(stream, TDataType.dtOctetString, tmp); //Date
          finally
            FreeAndNil(tmp);
          end;
        end
      end;
      Result := TValue.From(stream.ToArray());
    finally
      stream.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSActionSchedule.SetValue(e: TValueEventArgs);
var
  it: TValue;
  tm, date : TGXDateTime;
  Y, M, D : Word;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FExecutedScriptLogicalName := TGXCommon.ToLogicalName(e.Value.GetArrayElement(0));
    FExecutedScriptSelector := e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
  end
  else if e.Index = 3 Then
  begin
    FType := TSingleActionScheduleType(e.Value.AsInteger);
  end
  else if e.Index = 4 Then
  begin
    FExecutionTime.Clear;
    if Not e.Value.isEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
      begin
        tm := TGXCommon.ChangeType(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtTime).AsType<TGXDateTime>;
        date := TGXCommon.ChangeType(it.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtDate).AsType<TGXDateTime>;
        if Not date.Skip.Contains(TDateTimeSkips.dkYear) Then
        begin
          DecodeDate(date.Time, Y, M, D);
          if Not date.Skip.Contains(TDateTimeSkips.dkYear) Then
            tm.Time := IncYear(tm.Time, Y - 1);
          if Not date.Skip.Contains(TDateTimeSkips.dkMonth) Then
          tm.Time := IncMonth(tm.Time, M - 1);
          if Not date.Skip.Contains(TDateTimeSkips.dkDay) Then
            tm.Time := IncDay(tm.Time, D - 1);
        end;
        if date.Skip.Contains(TDateTimeSkips.dkYear) Then
          tm.Skip.Add(TDateTimeSkips.dkYear);
        if date.Skip.Contains(TDateTimeSkips.dkMonth) Then
          tm.Skip.Add(TDateTimeSkips.dkMonth);
        if date.Skip.Contains(TDateTimeSkips.dkDay) Then
          tm.Skip.Add(TDateTimeSkips.dkDay);
        if date.Skip.Contains(TDateTimeSkips.dkDayOfWeek) Then
          tm.Skip.Add(TDateTimeSkips.dkDayOfWeek);
        if date.Skip.Contains(TDateTimeSkips.dkDeviation) Then
          tm.Skip.Add(TDateTimeSkips.dkDeviation);

        tm.Extra := TDateTimeExtraInfo(Integer(tm.Extra) or Integer(date.Extra));
        FExecutionTime.Add(tm);
        FreeAndNil(date);
      end;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSActionSchedule.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSProfileGeneric;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.GXDLMSRegister, DateUtils,
GXByteBuffer,
Gurux.DLMS.GXDLMSCaptureObject, Gurux.DLMS.GXDateTime;

type

TAccessRange = (Entry, Last, Range);

TSortMethod = (FiFo = 1, LiFo, Largest, Smallest, NearestToZero, FarestFromZero);

TGXDLMSProfileGeneric = class(TGXDLMSObject)
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
  procedure SetBuffer(e: TValueEventArgs);

  protected
  FFreeObjects : TObjectList<TObject>;
  FBuffer: TList<TValue>;
  FCaptureObjects : TObjectList<TGXDLMSCaptureObject>;
  FCapturePeriod : Integer;
  FSortMethod : TSortMethod;
  FSortObject : TGXDLMSObject;
  FEntriesInUse, FProfileEntries: Integer;
  FSortAttributeIndex:Integer;
  FSortDataIndex:Integer;

  function GetColumns() : TBytes;

  public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  procedure Reset();

  //Data of profile generic.
  property Buffer: TList<TValue> read FBuffer;

  //Captured Objects.
  property CaptureObjects: TObjectList<TGXDLMSCaptureObject> read FCaptureObjects write FCaptureObjects;

  // How often values are captured.
  property CapturePeriod: Integer read FCapturePeriod;

  // How columns are sorted.
  property SortMethod: TSortMethod read FSortMethod;

  // Column that is used for sorting.
  property SortObject : TGXDLMSObject read FSortObject;

  // Entries (rows) in Use.
  property EntriesInUse : Integer read FEntriesInUse;

  // Maximum Entries (rows) count.
  property ProfileEntries : Integer read FProfileEntries;

  //Sort object's attribute index.
  property SortAttributeIndex: Integer read FSortAttributeIndex write FSortAttributeIndex;
  //Sort object's data index.
  property SortDataIndex: Integer read FSortDataIndex write FSortDataIndex;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;

  // Get captured objects.
  function GetCaptureObject(): TArray<TGXDLMSObject>;

end;

implementation
uses GXObjectFactory;

constructor TGXDLMSProfileGeneric.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSProfileGeneric.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSProfileGeneric.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otProfileGeneric, ln, 0);
  FCaptureObjects := TObjectList<TGXDLMSCaptureObject>.Create();
  FBuffer := TList<TValue>.Create();
  FFreeObjects := TObjectList<TObject>.Create();
end;

// Get captured objects.
function TGXDLMSProfileGeneric.GetCaptureObject(): TArray<TGXDLMSObject>;
var
  list: TList<TGXDLMSObject>;
  it: TGXDLMSCaptureObject;
begin
  list := TList<TGXDLMSObject>.Create();
  try
    for it in FCaptureObjects do
      list.Add(it.Target);
    Result := list.ToArray;
  finally
    FreeAndNil(list);
  end;
end;

procedure TGXDLMSProfileGeneric.Reset();
begin
  FBuffer.Clear();
  FEntriesInUse := 0;
end;

//Release added objects.
destructor TGXDLMSProfileGeneric.Destroy;
begin
  inherited;
  FreeAndNil(FFreeObjects);
  FreeAndNil(FBuffer);
  FreeAndNil(FCaptureObjects);
end;

function TGXDLMSProfileGeneric.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FBuffer), TValue.From(FCaptureObjects),
                FCapturePeriod, TValue.From(FSortMethod),
                TValue.From(FSortObject), FEntriesInUse, FProfileEntries);
end;

function TGXDLMSProfileGeneric.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //CaptureObjects
    if (FCaptureObjects.Count = 0) and (Not IsRead(3)) then
      items.Add(3);

    //Buffer
    items.Add(2);
    //CapturePeriod
    if Not IsRead(4) then
      items.Add(4);

    //SortMethod
    if Not IsRead(5) then
      items.Add(5);

    //SortObject
    if Not IsRead(6) then
      items.Add(6);

    //EntriesInUse
    items.Add(7);
    //ProfileEntries
    if Not IsRead(8) Then
      items.Add(8);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSProfileGeneric.GetAttributeCount: Integer;
begin
  Result := 8;
end;

function TGXDLMSProfileGeneric.GetMethodCount: Integer;
begin
  Result := 1;
end;

// Returns captured objects.
function TGXDLMSProfileGeneric.GetColumns() : TBytes;
var
  data : TGXByteBuffer;
  it : TGXDLMSCaptureObject;
begin
  data := TGXByteBuffer.Create;
  try
    data.Add(Integer(TDataType.dtArray));
    //Add count
    TGXCommon.SetObjectCount(CaptureObjects.Count, data);
    for it in FCaptureObjects do
    begin
        data.Add(Integer(TDataType.dtStructure));
        //Count
        data.Add(4);
        //ClassID
        TGXCommon.SetData(data, TDataType.dtUInt16, Integer(it.Target.ObjectType));
        //LN
        TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(it.Target.LogicalName)));
        //Selected Attribute Index
        TGXCommon.SetData(data, TDataType.dtInt8, it.AttributeIndex);
        //Selected Data Index
        TGXCommon.SetData(data, TDataType.dtUInt16, it.DataIndex);
    end;
    Result := data.ToArray();
  finally
    data.Free;
  end;
end;

function TGXDLMSProfileGeneric.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 3 then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 4 then
  begin
    Result := TDataType.dtInt8;
  end
  else if index = 5 then
  begin
    Result := TDataType.dtInt8;
  end
  else if index = 6 then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 7 then
  begin
    Result := TDataType.dtInt8;
  end
  else if index = 8 then
  begin
    Result := TDataType.dtInt8;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSProfileGeneric.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  emptyLn : array[0..5] of byte;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 then
  begin
    //This can not be implemented because delphi do not know data type in TValue.
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end
  else if e.Index = 3 then
  begin
      Result := TValue.From(GetColumns());
  end
  else if e.Index = 4 then
  begin
      Result := FCapturePeriod;
  end
  else if e.Index = 5 then
  begin
      Result := TValue.From(FSortMethod);
  end
  else if e.Index = 6 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtStructure));
      data.Add(4); //Count
      if FSortObject = Nil then
      begin
        TGXCommon.SetData(data, TDataType.dtUInt16, 0); //ClassID
        TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(emptyLn)); //LN
        TGXCommon.SetData(data, TDataType.dtInt8, 0); //Selected Attribute Index
        TGXCommon.SetData(data, TDataType.dtUInt16, 0); //Selected Data Index
      end
      else
      begin
        TGXCommon.SetData(data, TDataType.dtUInt16, TValue.From(SortObject.ObjectType)); //ClassID
        TGXCommon.SetData(data, TDataType.dtOctetString, SortObject.LogicalName); //LN
        //Sort Attribute Index
        TGXCommon.SetData(data, TDataType.dtInt8, FSortAttributeIndex);
        //Sort Data Index
        TGXCommon.SetData(data, TDataType.dtUInt16, FSortDataIndex);
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 7 then
  begin
      Result := FEntriesInUse;
  end
  else if e.Index = 8 then
  begin
      Result := FProfileEntries;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSProfileGeneric.SetBuffer(e: TValueEventArgs);
var
  it, row : TValue;
  index2, pos : Integer;
  tmp : TArray<TValue>;
  tp : TDataType;
  scaler, d : double;
  cols: TList<TGXDLMSCaptureObject>;
  lastDate: TDateTime;
  tmp2: TGXDateTime;
begin
  lastDate := 0;
  cols := FCaptureObjects;

  if e.Value.IsType<TArray<TValue>> then
  begin
    for row in e.Value.AsType<TArray<TValue>> do
    begin
      if row.GetArrayLength <> cols.Count then
      begin
        raise Exception.Create('Number of columns do not match.');
      end;
      for pos := 0 to row.GetArrayLength - 1 do
      begin
        tmp := row.AsType<TArray<TValue>>;
        if (cols = Nil) or (cols.Count = 0) Then
          index2 := 0
        else
          index2 := cols[pos].AttributeIndex;

        //Actaris SL 7000 and ACE 6000 returns 0.
        if index2 <> 0 Then
          tp := cols[pos].Target.GetUIDataType(index2)
        else
          tp := TDataType.dtNone;

        if Not tmp[pos].IsEmpty and tmp[pos].IsType<TBytes> then
        begin
          it := TGXCommon.ChangeType(row.AsType<TArray<TValue>>[pos].AsType<TBytes>, tp);
          if it.IsType<TGXDateTime> then
          begin
            lastDate := it.AsType<TGXDateTime>.LocalTime;
          end;

          //Add objects like GXdateTime to own list so they are released at the end.
          if it.IsObject then
            FFreeObjects.Add(it.AsObject);
          row.SetArrayElement(pos, it);
        end
        else if (tp = TDataType.dtDateTime) and tmp[pos].IsEmpty and (FCapturePeriod <> 0) Then
        begin
          if (lastDate = 0) and (FBuffer.Count <> 0) Then
          begin
            tmp := FBuffer[FBuffer.Count - 1].AsType<TArray<TValue>>;
            lastDate := tmp[pos].AsType<TGXDateTime>.LocalTime;
          end;
          if (lastDate <> 0) Then
          begin
            lastDate := IncSecond(lastDate, FCapturePeriod);
            tmp2 := TGXDateTime.Create(lastDate);
            row.SetArrayElement(pos, tmp2);
            FFreeObjects.Add(tmp2);
          end
        end;
        if (FCaptureObjects[pos].Target is TGXDLMSRegister) and
            (CaptureObjects[pos].AttributeIndex = 2) then
        begin
          scaler := (CaptureObjects[pos].Target as TGXDLMSRegister).Scaler;
          if scaler <> 1 then
          begin
            try
              d := row.GetArrayElement(pos).AsType<TValue>.AsCurrency * scaler;
              row.SetArrayElement(pos, TValue.From(d));
            except
            on Exception do
              begin
                //Skip error
              end;
            end;
          end;
        end;
        tmp := Nil;
      end;
      FBuffer.Add(row);
    end;
  end;
end;

procedure TGXDLMSProfileGeneric.SetValue(e: TValueEventArgs);
var
  it: TValue;
  ot : TObjectType;
  tmp : TArray<TValue>;
  ln : string;
  attributeIndex, dataIndex : Integer;
  obj : TGXDLMSObject;
  item: TGXDLMSCaptureObject;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 then
    SetBuffer(e)
  else if e.Index = 3 then
  begin
    FBuffer.Clear();
    FCaptureObjects.Clear();
    for it in e.Value.AsType<TArray<TValue>> do
    begin
      tmp := it.AsType<TArray<TValue>>;
      if Length(tmp) <> 4 then
        raise Exception.Create('Invalid structure format.');

      ot := TObjectType(tmp[0].AsInteger);
      ln := TGXDLMSObject.toLogicalName(tmp[1].ASType<TBytes>);
      attributeIndex := tmp[2].AsInteger;
      dataIndex := tmp[3].AsInteger;
      obj := e.Settings.Objects.FindByLN(ot, ln);
      if obj = Nil then
      begin
        obj := TGXObjectFactory.CreateObject(ot);
        obj.LogicalName := ln;
      end;
      item := TGXDLMSCaptureObject.Create(obj, attributeIndex, dataIndex);
      FCaptureObjects.Add(item);
    end;
  end
  else if e.Index = 4 then
  begin
    FCapturePeriod := e.Value.AsInteger;
  end
  else if e.Index = 5 then
  begin
    FSortMethod := TSortMethod(e.Value.AsInteger);
  end
  else if e.Index = 6 then
  begin
    tmp := e.Value.AsType<TArray<TValue>>;
    if Length(tmp) <> 4 then
      raise Exception.Create('SetValue failed. Invalid structure format.');
    ot := TObjectType(tmp[0].AsInteger);
    ln := TGXDLMSObject.toLogicalName(tmp[1].AsType<TBytes>);
    FSortAttributeIndex := tmp[2].AsInteger;
    FSortDataIndex := tmp[3].AsInteger;
    FSortObject := Nil;
    for item in FCaptureObjects do
    begin
        if (item.Target.ObjectType = ot) and (item.Target.LogicalName = ln) Then
        begin
          FSortObject := item.Target;
          break;
        end;
    end;
    if FSortObject = Nil Then
    begin
      FSortObject := TGXObjectFactory.CreateObject(ot);
      FSortObject.LogicalName := ln;
    end;
  end
  else if e.Index = 7 then
  begin
    FEntriesInUse := e.Value.AsInteger;
  end
  else if e.Index = 8 then
  begin
    FProfileEntries := e.Value.AsInteger;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSProfileGeneric.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

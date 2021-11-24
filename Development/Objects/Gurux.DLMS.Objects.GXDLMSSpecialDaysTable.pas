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

unit Gurux.DLMS.Objects.GXDLMSSpecialDaysTable;

interface

uses GXCommon,
SysUtils,
Rtti,
System.Generics.Collections,
Gurux.DLMS.GXDate,
Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDLMSSpecialDay,
GXByteBuffer;

type
TGXDLMSSpecialDaysTable = class(TGXDLMSObject)
  FEntries : TObjectList<TGXDLMSSpecialDay>;

  destructor Destroy; override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property Entries: TObjectList<TGXDLMSSpecialDay> read FEntries;

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

constructor TGXDLMSSpecialDaysTable.Create;
begin
  inherited Create(TObjectType.otSpecialDaysTable);
  FEntries := TObjectList<TGXDLMSSpecialDay>.Create;
end;

constructor TGXDLMSSpecialDaysTable.Create(ln: string);
begin
  inherited Create(TObjectType.otSpecialDaysTable, ln, 0);
  FEntries := TObjectList<TGXDLMSSpecialDay>.Create;
end;

constructor TGXDLMSSpecialDaysTable.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otSpecialDaysTable, ln, 0);
  FEntries := TObjectList<TGXDLMSSpecialDay>.Create;
end;

destructor TGXDLMSSpecialDaysTable.Destroy;
begin
  inherited;
  FreeAndNil(FEntries);
end;

function TGXDLMSSpecialDaysTable.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FEntries));
end;

function TGXDLMSSpecialDaysTable.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //Value
    if All or CanRead(2) then
      items.Add(2);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSSpecialDaysTable.GetAttributeCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSSpecialDaysTable.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSSpecialDaysTable.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if (index = 2) then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;


function TGXDLMSSpecialDaysTable.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TGXDLMSSpecialDay;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if (e.Index = 2) then
  begin
    data := TGXByteBuffer.Create();
    try
      data.Add(Integer(TDataType.dtArray));
      //Add count
      TGXCommon.SetObjectCount(FEntries.Count, data);
      for it in Entries do
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(3); //Count
        TGXCommon.SetData(data, TDataType.dtUInt16, it.Index);
        TGXCommon.SetData(data, TDataType.dtOctetString, it.Date);
        TGXCommon.SetData(data, TDataType.dtUInt8, it.DayId);
      end;
      Result := TValue.From(data.ToArray());
    finally
      FreeAndNil(data);
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSSpecialDaysTable.SetValue(e: TValueEventArgs);
var
  tmp, item : TValue;
  it : TGXDLMSSpecialDay;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if (e.Index = 2) then
  begin
    FEntries.Clear;
    if Not e.Value.IsEmpty then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
          it := TGXDLMSSpecialDay.Create();
          try
            it.Index := item.GetArrayElement(0).AsType<TValue>.AsInteger;
            tmp := item.GetArrayElement(1).AsType<TValue>;
            it.Date := TGXCommon.ChangeType(tmp.AsType<TBytes>, TDataType.dtDate).AsType<TGXDate>();
            it.DayId := item.GetArrayElement(2).AsType<TValue>.AsInteger;
          except
            it.Free;
            raise;
          end;
          FEntries.Add(it);
      end;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSSpecialDaysTable.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

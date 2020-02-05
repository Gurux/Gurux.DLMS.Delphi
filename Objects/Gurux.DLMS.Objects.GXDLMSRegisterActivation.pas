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

unit Gurux.DLMS.Objects.GXDLMSRegisterActivation;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDLMSObjectDefinition, GXByteBuffer;

type
TGXDLMSRegisterActivation = class(TGXDLMSObject)
  FRegisterAssignment : TObjectList<TGXDLMSObjectDefinition>;
  FActiveMask : string;
  FMaskList : TDictionary<TBytes, TBytes>;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property RegisterAssignment: TObjectList<TGXDLMSObjectDefinition> read FRegisterAssignment;

  property MaskList: TDictionary<TBytes, TBytes> read FMaskList;
  property ActiveMask: string read FActiveMask write FActiveMask;

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

constructor TGXDLMSRegisterActivation.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSRegisterActivation.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSRegisterActivation.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otRegisterActivation, ln, 0);
  FRegisterAssignment := TObjectList<TGXDLMSObjectDefinition>.Create();
  FMaskList := TDictionary<TBytes, TBytes>.Create();
end;

destructor TGXDLMSRegisterActivation.Destroy;
begin
  inherited;
  FreeAndNil(FRegisterAssignment);
  FreeAndNil(FMaskList);
end;

function TGXDLMSRegisterActivation.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FRegisterAssignment),
            FMaskList, FActiveMask);
end;

function TGXDLMSRegisterActivation.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //RegisterAssignment
    if All or Not IsRead(2) Then
      items.Add(2);
    //MaskList
    if All or Not IsRead(3) Then
      items.Add(3);
    //ActiveMask
    if All or Not IsRead(4) Then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;

end;

function TGXDLMSRegisterActivation.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSRegisterActivation.GetMethodCount: Integer;
begin
  Result := 3;
end;

function TGXDLMSRegisterActivation.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSRegisterActivation.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TGXDLMSObjectDefinition;
  b : byte;
  Pair: TPair<TBytes, TBytes>;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(byte(TDataType.dtArray));
      if RegisterAssignment = Nil Then
      begin
          data.Add(0);
      end
      else
      begin
          data.Add(FRegisterAssignment.Count);
          for it in RegisterAssignment do
          begin
            data.Add(byte(TDataType.dtStructure));
            data.Add(2);
            TGXCommon.SetData(data, TDataType.dtUInt16, Integer(it.ClassId));
            TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(it.LogicalName)));
          end
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 3 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(byte(TDataType.dtArray));
      data.Add(FMaskList.Count);
      for pair in FMaskList do
      begin
        data.Add(byte(TDataType.dtStructure));
        data.Add(2);
        TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(pair.Key));
        data.Add(byte(TDataType.dtArray));
        data.Add(Length(pair.Value));
        for b in pair.Value do
          TGXCommon.SetData(data, TDataType.dtUInt8, b);
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 4 Then
  begin
    Result := TValue.From(TGXCommon.GetBytes(ActiveMask));
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSRegisterActivation.SetValue(e: TValueEventArgs);
var
  it, it2 : TValue;
  item : TGXDLMSObjectDefinition;
  tmp, index_list : TBytes;
  tmp2 : TArray<TValue>;
  pos : Integer;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FRegisterAssignment.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for it in  e.Value.AsType<TArray<TValue>> do
      begin
        item := TGXDLMSObjectDefinition.Create;
        try
          item.ClassId := TObjectType(it.GetArrayElement(0).AsType<TValue>.AsInteger);
          item.LogicalName := TGXDLMSObject.ToLogicalName(it.GetArrayElement(1).AsType<TValue>.AsType<TBytes>);
        except
          item.Free;
          raise;
        end;
        FRegisterAssignment.Add(item);
      end
    end;
  end
  else if e.Index = 3 then
  begin
    MaskList.Clear();
    if Not e.Value.IsEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
      begin
        tmp := it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>;
        tmp2 := it.GetArrayElement(1).AsType<TValue>.AsType<TArray<TValue>>();
        SetLength(index_list, Length(tmp2));
        pos := 0;
        for it2 in tmp2 do
        begin
          index_list[pos] := it2.AsInteger;
          pos := pos + 1;
        end;
        FMaskList.Add(tmp, index_list);
      end;
    end
  end
  else if e.Index = 4 Then
  begin
    if Not e.Value.IsEmpty Then
      FActiveMask := ''
    else
      FActiveMask := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString();
  end
  else
   raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSRegisterActivation.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

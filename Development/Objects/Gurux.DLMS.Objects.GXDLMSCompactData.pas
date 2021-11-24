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

unit Gurux.DLMS.Objects.GXDLMSCompactData;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSCaptureObject,
Gurux.DLMS.GXDLMSObject, Gurux.DLMS.CaptureMethod, GXByteBuffer;

type
TGXDLMSCompactData = class(TGXDLMSObject)
private
  FBuffer: TBytes;
  FCaptureObjects : TObjectList<TGXDLMSCaptureObject>;
  FTemplateId: BYTE;
  FTemplateDescription: TBytes;
  FCaptureMethod: TCaptureMethod;
  // Returns captured objects.
  function GetCaptureObjects(): TBytes;
  procedure SetCaptureObjects(e: TValueEventArgs);
public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  //Compact buffer.
  property Buffer: TBytes read FBuffer write FBuffer;
  //Captured Objects.
  property CaptureObjects: TObjectList<TGXDLMSCaptureObject> read FCaptureObjects write FCaptureObjects;
  //Template ID.
  property TemplateId: BYTE read FTemplateId write FTemplateId;
  //Template description.
  property TemplateDescription: TBytes read FTemplateDescription write FTemplateDescription;
  //Capture method.
  property CaptureMethod: TCaptureMethod read FCaptureMethod write FCaptureMethod;

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
uses GXObjectFactory;

constructor TGXDLMSCompactData.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSCompactData.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSCompactData.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otCompactData, ln, sn);
end;

function TGXDLMSCompactData.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FBuffer),
          TValue.From(FCaptureObjects),
          FTemplateId, TValue.From(FTemplateDescription),
          TValue.From(FCaptureMethod));
end;

function TGXDLMSCompactData.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    // Buffer
    if All or CanRead(2) then
      items.Add(2);
    // CaptureObjects
    if All or CanRead(3) then
      items.Add(3);
    // TemplateId
    if All or CanRead(4) then
      items.Add(4);
    // TemplateDescription
    if All or CanRead(5) then
      items.Add(5);
    // CaptureMethod
    if All or CanRead(6) then
      items.Add(6);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSCompactData.GetAttributeCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSCompactData.GetMethodCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSCompactData.GetDataType(index: Integer): TDataType;
begin
  case index of
    1: Result := TDataType.dtOctetString;
    2: Result := TDataType.dtOctetString;
    3: Result := TDataType.dtArray;
    4: Result := TDataType.dtUInt8;
    5: Result := TDataType.dtOctetString;
    6: Result := TDataType.dtEnum;
    else raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSCompactData.GetCaptureObjects(): TBytes;
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

function TGXDLMSCompactData.GetValue(e: TValueEventArgs): TValue;
begin
  case e.Index of
    1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
    2: Result := TValue.From(FBuffer);
    3: Result := TValue.From(GetCaptureObjects());
    4: Result := FTemplateId;
    5: Result := TValue.From(FTemplateDescription);
    6: Result := Integer(FCaptureMethod);
    else raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSCompactData.SetCaptureObjects(e: TValueEventArgs);
var
  it: TValue;
  ot : WORD;
  tmp : TArray<TValue>;
  ln : string;
  attributeIndex, dataIndex : Integer;
  obj : TGXDLMSObject;
  item: TGXDLMSCaptureObject;
begin
  FCaptureObjects.Clear();
  for it in e.Value.AsType<TArray<TValue>> do
  begin
    tmp := it.AsType<TArray<TValue>>;
    if Length(tmp) <> 4 then
      raise Exception.Create('Invalid structure format.');

    ot := tmp[0].AsInteger;
    ln := TGXDLMSObject.toLogicalName(tmp[1].ASType<TBytes>);
    attributeIndex := tmp[2].AsInteger;
    dataIndex := tmp[3].AsInteger;
    obj := e.Settings.Objects.FindByLN(TObjectType(ot), ln);
    if obj = Nil then
    begin
      obj := TGXObjectFactory.CreateObject(ot);
      obj.LogicalName := ln;
    end;
    item := TGXDLMSCaptureObject.Create(obj, attributeIndex, dataIndex);
    FCaptureObjects.Add(item);
  end;
end;

procedure TGXDLMSCompactData.SetValue(e: TValueEventArgs);
begin
  case e.Index of
    1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
    2:
        if e.Value.IsType<TBytes> Then
          FBuffer := e.Value.ASType<TBytes>
        else if e.Value.IsType<String> Then
          FBuffer := TGXByteBuffer.HexToBytes(e.Value.ASType<String>);
    3: SetCaptureObjects(e);
    4: FTemplateId := e.Value.AsInteger;
    5: FTemplateDescription := e.Value.ASType<TBytes>;
    6: FCaptureMethod := TCaptureMethod(e.Value.AsInteger);
    else raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSCompactData.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

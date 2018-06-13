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

unit Gurux.DLMS.Objects.GXDLMSScriptTable;

interface

uses GXCommon, SysUtils, Rtti,
System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDLMSScriptAction, Gurux.DLMS.GXDLMSScriptActionType,
GXByteBuffer, Gurux.DLMS.Objects.GXDLMSScript;

type
  TGXDLMSScriptTable = class(TGXDLMSObject)
  private
  FScripts: TObjectList<TGXDLMSScript>;

  public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  destructor Destroy;override;

  property Scripts: TObjectList<TGXDLMSScript> read FScripts;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;  
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
end;

implementation

constructor TGXDLMSScriptTable.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSScriptTable.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSScriptTable.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otClock, ln, 0);
  FScripts := TObjectList<TGXDLMSScript>.Create();
end;

destructor TGXDLMSScriptTable.Destroy;
begin
  inherited;
  FreeAndNil(FScripts);
end;

function TGXDLMSScriptTable.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FScripts.ToArray()));
end;

function TGXDLMSScriptTable.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //Scripts
    if Not IsRead(2) Then
      items.Add(2);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSScriptTable.GetAttributeCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSScriptTable.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSScriptTable.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSScriptTable.GetValue(e: TValueEventArgs): TValue;
var
  cnt : Integer;
  data : TGXByteBuffer;
  a : TGXDLMSScriptAction;
  s : TGXDLMSScript;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    cnt := FScripts.Count;
    data := TGXByteBuffer.Create();
    try
      data.Add(Integer(TDataType.dtArray));
      //Add count
      TGXCommon.SetObjectCount(cnt, data);
      if cnt <> 0 Then
      begin
        for s in Scripts do
        begin
          data.Add(Integer(TDataType.dtStructure));
          data.Add(2); //Count
          TGXCommon.SetData(data, TDataType.dtUInt16, s.ID); //Script_identifier:
          data.Add(Integer(TDataType.dtArray));
          data.SetUInt8(s.Actions.Count); //Count
          for a in s.Actions do
          begin
            data.Add(Integer(TDataType.dtArray));
            data.Add(5); //Count
            TGXCommon.SetData(data, TDataType.dtEnum, Integer(a.&Type)); //service_id
            TGXCommon.SetData(data, TDataType.dtUInt16, Integer(a.ObjectType)); //class_id
            TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(a.LogicalName))); //logical_name
            TGXCommon.SetData(data, TDataType.dtInt8, a.Index); //index
            TGXCommon.SetData(data, TGXCommon.GetDLMSDataType(a.Parameter), a.Parameter); //parameter
          end;
        end
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSScriptTable.SetValue(e: TValueEventArgs);
var
  it: TGXDLMSScriptAction;
  item, item2: TValue;
  s: TGXDLMSScript;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FScripts.Clear();
    //xemex do not return values as table as it should be.
    if e.Value.IsArray Then
    begin
      if e.Value.GetArrayElement(0).AsType<TValue>.IsType<TArray<TValue>> then
      begin
        for item in e.Value.AsType<TArray<TValue>> do
        begin
          s := TGXDLMSScript.Create();
          s.ID := item.GetArrayElement(0).AsType<TValue>.AsInteger;
          if item.GetArrayLength = 2 Then
            for item2 in item.GetArrayElement(1).AsType<TValue>.AsType<TArray<TValue>> do
            begin
              it := TGXDLMSScriptAction.Create();
              it.&Type := TGXDLMSScriptActionType(item2.GetArrayElement(0).AsType<TValue>.AsInteger);
              it.ObjectType := TObjectType(item2.GetArrayElement(1).AsType<TValue>.AsInteger);
              it.LogicalName := TGXCommon.ToLogicalName(item2.GetArrayElement(2));
              it.Index := item2.AsType<TValue>.GetArrayElement(3).AsType<TValue>.AsInteger;
              it.Parameter := item2.GetArrayElement(4).AsType<TValue>;
              s.Actions.Add(it);
            end;
          FScripts.Add(s);
        end;
      end;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSScriptTable.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

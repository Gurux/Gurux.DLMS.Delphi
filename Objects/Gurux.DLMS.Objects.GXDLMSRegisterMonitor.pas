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

unit Gurux.DLMS.Objects.GXDLMSRegisterMonitor;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDLMSMonitoredValue, Gurux.DLMS.GXDLMSActionSet, GXByteBuffer;

type
TGXDLMSRegisterMonitor = class(TGXDLMSObject)
  FThresholds: TArray<TValue>;
  FMonitoredValue : TGXDLMSMonitoredValue;
  FActions : TObjectList<TGXDLMSActionSet>;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property Thresholds: TArray<TValue> read FThresholds write FThresholds;

  property MonitoredValue: TGXDLMSMonitoredValue read FMonitoredValue;

  property Actions: TObjectList<TGXDLMSActionSet> read FActions;

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

constructor TGXDLMSRegisterMonitor.Create;
begin
  inherited Create(TObjectType.otRegisterMonitor);
  FMonitoredValue := TGXDLMSMonitoredValue.Create();
  FActions := TObjectList<TGXDLMSActionSet>.Create();
end;

constructor TGXDLMSRegisterMonitor.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSRegisterMonitor.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otRegisterMonitor, ln, sn);
  FMonitoredValue := TGXDLMSMonitoredValue.Create();
  FActions := TObjectList<TGXDLMSActionSet>.Create();
end;

destructor TGXDLMSRegisterMonitor.Destroy;
begin
  inherited;
  FreeAndNil(FMonitoredValue);
  FreeAndNil(FActions);
end;

function TGXDLMSRegisterMonitor.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FThresholds), TValue.From(FMonitoredValue), TValue.From(FActions));
end;

function TGXDLMSRegisterMonitor.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //Thresholds
    if Not IsRead(2) Then
      items.Add(2);

    //MonitoredValue
    if Not IsRead(3) Then
      items.Add(3);

    //Actions
    if Not IsRead(4) Then
      items.Add(4);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;

end;

function TGXDLMSRegisterMonitor.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSRegisterMonitor.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSRegisterMonitor.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 then
  begin
    Result := inherited GetDataType(index);
  end
  else if index = 3 then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 4 then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSRegisterMonitor.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TGXDLMSActionSet;
  it2 : TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      data.setUint8(Length(FThresholds));
      for it2 in FThresholds do
      begin
        TGXCommon.SetData(data, TGXCommon.GetDLMSDataType(it2), it2);
      end;
    finally
      data.Free;
    end;
  end
  else if e.Index = 3 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtStructure));
      data.Add(3);
      TGXCommon.SetData(data, TDataType.dtUInt16, Integer(MonitoredValue.ObjectType)); //ClassID
      //Logical name.
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(MonitoredValue.LogicalName)));
      TGXCommon.SetData(data, TDataType.dtInt8, MonitoredValue.AttributeIndex); //Attribute Index
      Result := TValue.From(data.ToArray());
    finally
      FreeAndNil(data);
    end;
  end
  else if e.Index = 4 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtStructure));
      if Actions = Nil Then
      begin
        data.Add(0);
      end
      else
      begin
          data.Add(FActions.Count);
          for it in Actions do
          begin
            data.Add(Integer(TDataType.dtStructure));
            data.Add(2);
            data.Add(Integer(TDataType.dtStructure));
            data.Add(2);
            TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(it.ActionUp.LogicalName))); //Logical name.
            TGXCommon.SetData(data, TDataType.dtUInt16, it.ActionUp.ScriptSelector); //ScriptSelector
            data.Add(Integer(TDataType.dtStructure));
            data.Add(2);
            TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(it.ActionDown.LogicalName))); //Logical name.
            TGXCommon.SetData(data, TDataType.dtUInt16, it.ActionDown.ScriptSelector); //ScriptSelector
          end
      end;
      Result := TValue.From(data.ToArray());
    finally
      FreeAndNil(data);
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSRegisterMonitor.SetValue(e: TValueEventArgs);
var
  action_set : TValue;
  set1 : TGXDLMSActionSet;
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FThresholds := e.Value.AsType<TArray<TValue>>;
  end
  else if e.Index = 3 Then
  begin
    FMonitoredValue.ObjectType := TObjectType(e.Value.GetArrayElement(0).AsType<TValue>.AsInteger);
    FMonitoredValue.LogicalName := TGXCommon.ToLogicalName(e.Value.GetArrayElement(1));
    FMonitoredValue.AttributeIndex := e.Value.GetArrayElement(2).AsType<TValue>.AsInteger;
  end
  else if e.Index = 4 Then
  begin
    FActions.Clear;
    if Not e.Value.IsEmpty Then
      for action_set in e.Value.AsType<TArray<TValue>> do
      begin
        set1 := TGXDLMSActionSet.Create();
        set1.ActionUp.LogicalName := TGXCommon.ToLogicalName(action_set.GetArrayElement(0));
        set1.ActionUp.ScriptSelector := action_set.GetArrayElement(0).AsType<TValue>.GetArrayElement(1).AsType<TValue>.AsInteger;
        set1.ActionDown.LogicalName := TGXCommon.ToLogicalName(action_set.GetArrayElement(1));
        set1.ActionDown.ScriptSelector := action_set.GetArrayElement(1).AsType<TValue>.GetArrayElement(1).AsType<TValue>.AsInteger;
        FActions.Add(set1);
      end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSRegisterMonitor.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

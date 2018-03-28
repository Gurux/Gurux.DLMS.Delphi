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

unit Gurux.DLMS.Objects.GXDLMSLimiter;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDLMSActionItem,
Gurux.DLMS.GXDLMSEmergencyProfile,
GXByteBuffer,
Gurux.DLMS.ErrorCode;

type
TGXDLMSLimiter = class(TGXDLMSObject)
  private
  FMonitoredValue: TGXDLMSObject;
  FThresholdActive, FThresholdNormal, FThresholdEmergency : TValue;
  FMinOverThresholdDuration, FMinUnderThresholdDuration : UInt32;
  FEmergencyProfile: TGXDLMSEmergencyProfile;
  FEmergencyProfileActive: Boolean;
  FActionOverThreshold, FActionUnderThreshold : TGXDLMSActionItem;
  FEmergencyProfileGroupIDs: TList<UInt16>;
  //Attribute index of monitored value.
  FMonitoredAttributeIndex: Byte;

  public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Defines an attribute of an object to be monitored.
  property MonitoredValue: TGXDLMSObject read FMonitoredValue write FMonitoredValue;

  //Provides the active threshold value to which the attribute monitored is compared.
  property ThresholdActive: TValue read FThresholdActive write FThresholdActive;

  // Provides the threshold value to which the attribute monitored
  // is compared when in normal operation.
  property ThresholdNormal: TValue read FThresholdNormal write FThresholdNormal;

  // Provides the threshold value to which the attribute monitored
  // is compared when an emergency profile is active.
  property ThresholdEmergency: TValue read FThresholdEmergency write FThresholdEmergency;

  //Defines minimal over threshold duration in seconds required
  // to execute the over threshold action.
  property MinOverThresholdDuration: UInt32 read FMinOverThresholdDuration write FMinOverThresholdDuration;

  // Defines minimal under threshold duration in seconds required to
  // execute the under threshold action.
  property MinUnderThresholdDuration: UInt32 read FMinUnderThresholdDuration write FMinUnderThresholdDuration;

  property EmergencyProfile: TGXDLMSEmergencyProfile read FEmergencyProfile write FEmergencyProfile;

  property EmergencyProfileGroupIDs: TList<UInt16> read FEmergencyProfileGroupIDs;

  //Is Emergency Profile active.
  property EmergencyProfileActive: Boolean read FEmergencyProfileActive write FEmergencyProfileActive;

  // Defines the scripts to be executed when the monitored value
  // crosses the threshold for minimal duration time.
  property ActionOverThreshold: TGXDLMSActionItem read FActionOverThreshold write FActionOverThreshold;

  // Defines the scripts to be executed when the monitored value
  // crosses the threshold for minimal duration time.
  property ActionUnderThreshold: TGXDLMSActionItem read FActionUnderThreshold write FActionUnderThreshold;

  //Attribute index of monitored value.
  property MonitoredAttributeIndex: Byte read FMonitoredAttributeIndex write FMonitoredAttributeIndex;

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

constructor TGXDLMSLimiter.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSLimiter.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSLimiter.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otLimiter, ln, 0);
  FEmergencyProfileGroupIDs := TList<UInt16>.Create();
  FActionOverThreshold := TGXDLMSActionItem.Create();
  FActionUnderThreshold := TGXDLMSActionItem.Create();
  FEmergencyProfile := TGXDLMSEmergencyProfile.Create();
end;

destructor TGXDLMSLimiter.Destroy;
begin
  inherited;
  FreeAndNil(FEmergencyProfileGroupIDs);
  FreeAndNil(FActionOverThreshold);
  FreeAndNil(FActionUnderThreshold);
  FreeAndNil(FEmergencyProfile);
end;

function TGXDLMSLimiter.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FMonitoredValue,
          FThresholdActive, FThresholdNormal, FThresholdEmergency,
            FMinOverThresholdDuration, FMinUnderThresholdDuration,
            FEmergencyProfile, FEmergencyProfileGroupIDs, FEmergencyProfileActive,
            TValue.From(TArray<TValue>.Create(FActionOverThreshold, FActionUnderThreshold)));
end;

function TGXDLMSLimiter.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //MonitoredValue
  if CanRead(2) Then
    items.Add(2);

  //ThresholdActive
  if CanRead(3) Then
    items.Add(3);

  //ThresholdNormal
  if CanRead(4) Then
    items.Add(4);

  //ThresholdEmergency
  if CanRead(5) Then
    items.Add(5);

  //MinOverThresholdDuration
  if CanRead(6) Then
    items.Add(6);

  //MinUnderThresholdDuration
  if CanRead(7) Then
    items.Add(7);

  //EmergencyProfile
  if CanRead(8) Then
    items.Add(8);

  //EmergencyProfileGroup
  if CanRead(9) Then
    items.Add(9);

  //EmergencyProfileActive
  if CanRead(10) Then
    items.Add(10);

  //Actions
  if CanRead(11) Then
    items.Add(11);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSLimiter.GetAttributeCount: Integer;
begin
  Result := 11;
end;

function TGXDLMSLimiter.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSLimiter.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
      Result := TDataType.dtStructure;
  end
  else if index = 3 Then
  begin
      Result := inherited GetDataType(index);
  end
  else if index = 4 Then
  begin
      Result := inherited GetDataType(index);
  end
  else if index = 5 Then
  begin
      Result := inherited GetDataType(index);
  end
  else if index = 6 Then
  begin
      Result := TDataType.dtUInt32;
  end
  else if index = 7 Then
  begin
      Result := TDataType.dtUInt32;
  end
  else if index = 8 Then
  begin
      Result := TDataType.dtStructure;
  end
  else if index = 9 Then
  begin
      Result := TDataType.dtArray;
  end
  else if index = 10 Then
  begin
      Result := TDataType.dtBoolean;
  end
  else if index = 11 Then
  begin
      Result := TDataType.dtStructure;
  end
  else
	  raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSLimiter.GetValue(e: TValueEventArgs): TValue;
var
  data: TGXByteBuffer;
  it: UInt16;
begin
  if (e.Index = 1) then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if (e.Index = 2) Then
  begin
    data := TGXByteBuffer.Create();
    data.SetUInt8(Integer(TDataType.dtStructure));
    data.SetUInt8(3);
    if (MonitoredValue = Nil) Then
    begin
      TGXCommon.SetData(data, TDataType.dtInt16, 0);
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes('')));
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
    end
    else
    begin
      TGXCommon.SetData(data, TDataType.dtInt16, TValue.From(FMonitoredValue.ObjectType));
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes(FMonitoredValue.LogicalName)));
      TGXCommon.SetData(data, TDataType.dtUInt8, FMonitoredAttributeIndex);
    end;
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else if (e.Index = 3) Then
    Result := FThresholdActive
  else if (e.Index = 4) Then
    Result := FThresholdNormal
  else if (e.Index = 5) Then
    Result := FThresholdEmergency
  else if (e.Index = 6) Then
    Result := FMinOverThresholdDuration
  else if (e.Index = 7) Then
    Result := FMinUnderThresholdDuration
  else if (e.Index = 8) Then
  begin
    data := TGXByteBuffer.Create();
    data.SetUInt8(Integer(TDataType.dtStructure));
    data.SetUInt8(3);
    TGXCommon.SetData(data, TDataType.dtUInt16, EmergencyProfile.ID);
    TGXCommon.SetData(data, TDataType.dtOctetString, EmergencyProfile.ActivationTime);
    TGXCommon.SetData(data, TDataType.dtUInt32, EmergencyProfile.Duration);
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else if (e.Index = 9) Then
  begin
    data := TGXByteBuffer.Create();
    data.SetUInt8(Integer(TDataType.dtArray));
    if (EmergencyProfileGroupIDs = Nil) Then
      data.SetUInt8(0)
    else
    begin
      data.SetUInt8(FEmergencyProfileGroupIDs.Count);
      for it in FEmergencyProfileGroupIDs do
        TGXCommon.SetData(data, TDataType.dtUInt16, it);
    end;
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else if (e.Index = 10) Then
    Result := FEmergencyProfileActive
  else if (e.Index = 11) Then
  begin
    data := TGXByteBuffer.Create();
    data.SetUInt8(Integer(TDataType.dtStructure));
    data.SetUInt8(2);
    data.SetUInt8(Integer(TDataType.dtStructure));
    data.SetUInt8(2);
    TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes(ActionOverThreshold.LogicalName)));
    TGXCommon.SetData(data, TDataType.dtUInt16, ActionOverThreshold.ScriptSelector);
    data.SetUInt8(Integer(TDataType.dtStructure));
    data.SetUInt8(2);
    TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes(ActionUnderThreshold.LogicalName)));
    TGXCommon.SetData(data, TDataType.dtUInt16, ActionUnderThreshold.ScriptSelector);
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else
    e.Error := TErrorCode.ecReadWriteDenied;
end;

procedure TGXDLMSLimiter.SetValue(e: TValueEventArgs);
var
  ot : TObjectType;
  ln : string;
  it, tmp : TValue;
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    ot := TObjectType(e.Value.GetArrayElement(0).AsType<TValue>.AsInteger);
    ln := TGXCommon.ToLogicalName(e.Value.GetArrayElement(1));
    FMonitoredValue := e.Settings.Objects.FindByLN(ot, ln);
    FMonitoredAttributeIndex := e.Value.GetArrayElement(2).AsType<TValue>.AsInteger;
  end
  else if e.Index = 3 Then
  begin
    FThresholdActive := e.Value;
  end
  else if e.Index = 4 Then
  begin
    FThresholdNormal := e.Value;
  end
  else if e.Index = 5 Then
  begin
    FThresholdEmergency := e.Value;
  end
  else if e.Index = 6 Then
  begin
    FMinOverThresholdDuration := e.Value.AsInteger;
  end
  else if e.Index = 7 Then
  begin
    FMinUnderThresholdDuration := e.Value.AsInteger;
  end
  else if e.Index = 8 Then
  begin
    FEmergencyProfile.ID := e.Value.GetArrayElement(0).AsType<TValue>.AsInteger;
    FEmergencyProfile.ActivationTime := TGXCommon.ChangeType(e.Value.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
    FEmergencyProfile.Duration := e.Value.GetArrayElement(2).AsType<TValue>.AsInteger;
  end
  else if e.Index = 9 Then
  begin
    for it in e.Value.AsType<TArray<TValue>> do
    begin
      FEmergencyProfileGroupIDs.Add(it.AsInteger);
    end;
  end
  else if e.Index = 10 Then
  begin
    EmergencyProfileActive := e.Value.AsBoolean;
  end
  else if e.Index = 11 Then
  begin
    tmp := e.Value.GetArrayElement(0).AsType<TValue>;
    FActionOverThreshold.LogicalName := TGXCommon.ToLogicalName(tmp.GetArrayElement(0));
    FActionOverThreshold.ScriptSelector := tmp.GetArrayElement(1).AsType<TValue>.AsInteger;
    tmp := e.Value.GetArrayElement(1).AsType<TValue>;
    FActionUnderThreshold.LogicalName := TGXCommon.ToLogicalName(tmp.GetArrayElement(0));
    FActionUnderThreshold.ScriptSelector := tmp.GetArrayElement(1).AsType<TValue>.AsInteger;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSLimiter.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

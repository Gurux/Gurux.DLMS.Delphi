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

unit Gurux.DLMS.Objects.GXDLMSActivityCalendar;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDLMSSeasonProfile,
Gurux.DLMS.GXDLMSWeekProfile,
Gurux.DLMS.GXDLMSDayProfile,
Gurux.DLMS.GXDLMSDayProfileAction, GXByteBuffer;

type
TGXDLMSActivityCalendar = class(TGXDLMSObject)
  FCalendarNameActive: string;
  FSeasonProfileActive : TObjectList<TGXDLMSSeasonProfile>;
  FWeekProfileTableActive : TObjectList<TGXDLMSWeekProfile>;
  FDayProfileTableActive: TObjectList<TGXDLMSDayProfile>;

  FCalendarNamePassive: string;
  FSeasonProfilePassive : TObjectList<TGXDLMSSeasonProfile>;
  FWeekProfileTablePassive : TObjectList<TGXDLMSWeekProfile>;
  FDayProfileTablePassive: TObjectList<TGXDLMSDayProfile>;
  FTime: TGXDateTime;

private
  function GetSeasonProfile(profile: TObjectList<TGXDLMSSeasonProfile>): TValue;
  function GetWeekProfile(profile: TObjectList<TGXDLMSWeekProfile>): TValue;
  function GetDayProfile(profile: TObjectList<TGXDLMSDayProfile>): TValue;

public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property CalendarNameActive: string read FCalendarNameActive write FCalendarNameActive;

  property SeasonProfileActive: TObjectList<TGXDLMSSeasonProfile> read FSeasonProfileActive;

  property WeekProfileTableActive: TObjectList<TGXDLMSWeekProfile> read FWeekProfileTableActive;

  property DayProfileTableActive: TObjectList<TGXDLMSDayProfile> read FDayProfileTableActive;

  property CalendarNamePassive: string read FCalendarNamePassive write FCalendarNamePassive;

  property SeasonProfilePassive: TObjectList<TGXDLMSSeasonProfile> read FSeasonProfilePassive;

  property WeekProfileTablePassive: TObjectList<TGXDLMSWeekProfile> read FWeekProfileTablePassive;

  property DayProfileTablePassive: TObjectList<TGXDLMSDayProfile> read FDayProfileTablePassive;

  property Time: TGXDateTime read FTime write FTime;

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

constructor TGXDLMSActivityCalendar.Create;
begin
  Create('0.0.13.0.0.255', 0);
end;

constructor TGXDLMSActivityCalendar.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSActivityCalendar.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otActivityCalendar, ln, 0);
  FSeasonProfileActive := TObjectList<TGXDLMSSeasonProfile>.Create();
  FWeekProfileTableActive := TObjectList<TGXDLMSWeekProfile>.Create();
  FDayProfileTableActive := TObjectList<TGXDLMSDayProfile>.Create();
  FSeasonProfilePassive := TObjectList<TGXDLMSSeasonProfile>.Create();
  FWeekProfileTablePassive := TObjectList<TGXDLMSWeekProfile>.Create();
  FDayProfileTablePassive := TObjectList<TGXDLMSDayProfile>.Create();
end;

destructor TGXDLMSActivityCalendar.Destroy;
begin
  inherited;
  FreeAndNil(FSeasonProfileActive);
  FreeAndNil(FWeekProfileTableActive);
  FDayProfileTableActive.Clear;
  FreeAndNil(FDayProfileTableActive);
  FreeAndNil(FSeasonProfilePassive);
  FreeAndNil(FWeekProfileTablePassive);
  FreeAndNil(FDayProfileTablePassive);
  FreeAndNil(FTime);
end;


function TGXDLMSActivityCalendar.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FCalendarNameActive,
                TValue.From(FSeasonProfileActive),
                TValue.From(FWeekProfileTableActive),
                TValue.From(FDayProfileTableActive),
                TValue.From(FCalendarNamePassive),
                TValue.From(FSeasonProfilePassive),
                TValue.From(FWeekProfileTablePassive),
                TValue.From(FDayProfileTablePassive), FTime);
end;

function TGXDLMSActivityCalendar.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //CalendarNameActive
  if CanRead(2) Then
    items.Add(2);

  //SeasonProfileActive
  if CanRead(3) Then
    items.Add(3);

  //WeekProfileTableActive
  if CanRead(4) Then
    items.Add(4);

  //DayProfileTableActive
  if CanRead(5) Then
    items.Add(5);

  //CalendarNamePassive
  if CanRead(6) Then
    items.Add(6);

  //SeasonProfileActive
  if CanRead(7) Then
    items.Add(7);

  //WeekProfileTableActive
  if CanRead(8) Then
    items.Add(8);

  //DayProfileTableActive
  if CanRead(9) Then
    items.Add(9);

  //Time.
  if CanRead(10) Then
    items.Add(10);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSActivityCalendar.GetAttributeCount: Integer;
begin
  Result := 10;
end;

function TGXDLMSActivityCalendar.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSActivityCalendar.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtOctetString;
  end
  //
  else if index = 7 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 10 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSActivityCalendar.GetSeasonProfile(profile: TObjectList<TGXDLMSSeasonProfile>): TValue;
var
  data : TGXByteBuffer;
  it : TGXDLMSSeasonProfile;
begin
  data := TGXByteBuffer.Create();
  data.Add(Integer(TDataType.dtArray));
  if profile = Nil Then
  begin
    //Add count
    TGXCommon.SetObjectCount(0, data);
  end
  else
  begin
    //Add count
    TGXCommon.SetObjectCount(profile.Count, data);
    for it in profile do
    begin
      data.Add(Integer(TDataType.dtStructure));
      data.Add(3);
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(it.Name)));
      TGXCommon.SetData(data, TDataType.dtOctetString, it.Start);
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(it.WeekName)));
    end
  end;
  Result := TValue.From(data.ToArray());
  FreeAndNil(data);
end;

function TGXDLMSActivityCalendar.GetWeekProfile(profile: TObjectList<TGXDLMSWeekProfile>): TValue;
var
  data : TGXByteBuffer;
  wp : TGXDLMSWeekProfile;
begin
  data := TGXByteBuffer.Create;
  data.Add(Integer(TDataType.dtArray));
  if profile = Nil Then
  begin
    //Add count
    TGXCommon.SetObjectCount(0, data);
  end
  else
  begin
    //Add count
    TGXCommon.SetObjectCount(profile.Count, data);
    for wp in profile do
    begin
      data.Add(Integer(TDataType.dtStructure));
      data.Add(8);
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(wp.Name)));
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Monday);
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Tuesday);
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Wednesday);
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Thursday);
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Friday);
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Saturday);
      TGXCommon.SetData(data, TDataType.dtUInt8, wp.Sunday);
    end
  end;
  Result := TValue.From(data.ToArray());
  FreeAndNil(data);
end;

function TGXDLMSActivityCalendar.GetDayProfile(profile: TObjectList<TGXDLMSDayProfile>): TValue;
var
  data : TGXByteBuffer;
  dp : TGXDLMSDayProfile;
  action : TGXDLMSDayProfileAction;
begin
  data := TGXByteBuffer.Create;
  data.Add(Integer(TDataType.dtArray));
  if DayProfileTableActive = Nil Then
  begin
    //Add count
    TGXCommon.SetObjectCount(0, data);
  end
  else
  begin
    //Add count
    TGXCommon.SetObjectCount(DayProfileTableActive.Count, data);
    for dp in FDayProfileTableActive do
    begin
      data.Add(Integer(TDataType.dtStructure));
      data.Add(2);
      TGXCommon.SetData(data, TDataType.dtUInt8, dp.DayId);
      data.Add(Integer(TDataType.dtArray));
      //Add count
      TGXCommon.SetObjectCount(dp.DaySchedules.Count, data);
      for action in dp.DaySchedules do
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(3);
        TGXCommon.SetData(data, TDataType.dtTime, action.StartTime);
        TGXCommon.SetData(data, TDataType.dtOctetString,
                  TValue.From(TGXCommon.LogicalNameToBytes(action.ScriptLogicalName)));
        TGXCommon.SetData(data, TDataType.dtUInt16, action.ScriptSelector);
      end
    end
  end;
  Result := TValue.From(data.ToArray());
  FreeAndNil(data);
end;

function TGXDLMSActivityCalendar.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := TGXCommon.ChangeType(TGXCommon.GetBytes(FCalendarNameActive), TDataType.dtOctetString);
  end
  else if e.Index = 3 Then
  begin
    Result := GetSeasonProfile(FSeasonProfileActive);
  end
  else if e.Index = 4 Then
  begin
    Result := GetWeekProfile(FWeekProfileTableActive);
  end
  else if e.Index = 5 Then
  begin
    Result := GetDayProfile(FDayProfileTableActive);
  end
  else if e.Index = 6 Then
    Result := TGXCommon.ChangeType(TGXCommon.GetBytes(CalendarNamePassive),
              TDataType.dtOctetString)
  else if e.Index = 7 Then
    Result := GetSeasonProfile(FSeasonProfilePassive)
  else if e.Index = 8 Then
    Result := GetWeekProfile(FWeekProfileTablePassive)
  else if e.Index = 9 Then
    Result := GetDayProfile(FDayProfileTablePassive)
  else if e.Index = 10 Then
  begin
    Result := Time;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSActivityCalendar.SetValue(e: TValueEventArgs);
var
  item, it : TValue;
  sp : TGXDLMSSeasonProfile;
  wp : TGXDLMSWeekProfile;
  dp : TGXDLMSDayProfile;
  ac : TGXDLMSDayProfileAction;
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    if e.Value.IsType<TBytes> Then
      FCalendarNameActive := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString()
    else
      FCalendarNameActive := e.Value.ToString;
  end
  else if e.Index = 3 Then
  begin
    FSeasonProfileActive.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        sp := TGXDLMSSeasonProfile.Create();
        sp.Name := TGXCommon.ChangeType(item.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
        sp.Start := TGXCommon.ChangeType(item.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        sp.WeekName := TGXCommon.ChangeType(item.GetArrayElement(2).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
        FSeasonProfileActive.Add(sp);
      end;
    end;
  end
  else if e.Index = 4 Then
  begin
    FWeekProfileTableActive.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        wp := TGXDLMSWeekProfile.Create();
        wp.Name := TGXCommon.ChangeType(item.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
        wp.Monday := item.GetArrayElement(1).AsType<TValue>.AsInteger;
        wp.Tuesday := item.GetArrayElement(2).AsType<TValue>.AsInteger;
        wp.Wednesday := item.GetArrayElement(3).AsType<TValue>.AsInteger;
        wp.Thursday := item.GetArrayElement(4).AsType<TValue>.AsInteger;
        wp.Friday := item.GetArrayElement(5).AsType<TValue>.AsInteger;
        wp.Saturday := item.GetArrayElement(6).AsType<TValue>.AsInteger;
        wp.Sunday := item.GetArrayElement(7).AsType<TValue>.AsInteger;
        FWeekProfileTableActive.Add(wp);
      end;
    end;
  end
  else if e.Index = 5 Then
  begin
    FDayProfileTableActive.Clear;
    if Not e.Value.IsEmpty Then
    begin
    for item in e.Value.AsType<TArray<TValue>> do
    begin
      dp := TGXDLMSDayProfile.Create();
      dp.DayId := item.GetArrayElement(0).AsType<TValue>.AsInteger;
      for it in item.GetArrayElement(1).AsType<TValue>.AsType<TArray<TValue>> do
      begin
        ac := TGXDLMSDayProfileAction.Create();
        ac.StartTime := TGXCommon.ChangeType(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtTime).AsType<TGXDateTime>;
        ac.ScriptLogicalName := TGXCommon.ToLogicalName(it.GetArrayElement(1));
        ac.ScriptSelector := it.GetArrayElement(2).AsType<TValue>.AsInteger;
        dp.DaySchedules.Add(ac);
      end;
      FDayProfileTableActive.Add(dp);
    end;
    end;
  end
  else if e.Index = 6 Then
  begin
    if e.Value.IsType<TBytes> Then
      FCalendarNamePassive := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString()
    else
      FCalendarNamePassive := e.Value.ToString;
  end
  else if e.Index = 7 Then
  begin
    FSeasonProfilePassive.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        sp := TGXDLMSSeasonProfile.Create();
        sp.Name := TGXCommon.ChangeType(item.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
        sp.Start := TGXCommon.ChangeType(item.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        sp.WeekName := TGXCommon.ChangeType(item.GetArrayElement(2).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
        FSeasonProfilePassive.Add(sp);
      end;
    end;
  end
  else if e.Index = 8 Then
  begin
    FWeekProfileTablePassive.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        wp := TGXDLMSWeekProfile.Create();
        wp.Name := TGXCommon.ChangeType(item.GetArrayElement(0).AsType<TValue>.AsType<TBytes>,
                  TDataType.dtString).ToString();
        wp.Monday := item.GetArrayElement(1).AsType<TValue>.AsInteger;
        wp.Tuesday := item.GetArrayElement(2).AsType<TValue>.AsInteger;
        wp.Wednesday := item.GetArrayElement(3).AsType<TValue>.AsInteger;
        wp.Thursday := item.GetArrayElement(4).AsType<TValue>.AsInteger;
        wp.Friday := item.GetArrayElement(5).AsType<TValue>.AsInteger;
        wp.Saturday := item.GetArrayElement(6).AsType<TValue>.AsInteger;
        wp.Sunday := item.GetArrayElement(7).AsType<TValue>.AsInteger;
        FWeekProfileTablePassive.Add(wp);
      end;
    end;
  end
  else if e.Index = 9 Then
  begin
    FDayProfileTablePassive.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        dp := TGXDLMSDayProfile.Create();
        dp.DayId := item.GetArrayElement(0).AsType<TValue>.AsInteger;
        for it in item.GetArrayElement(1).AsType<TValue>.AsType<TArray<TValue>> do
        begin
          ac := TGXDLMSDayProfileAction.Create();
          ac.StartTime := TGXCommon.ChangeType(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtTime).AsType<TGXDateTime>;
          ac.ScriptLogicalName := TGXCommon.ToLogicalName(it.GetArrayElement(1));
          ac.ScriptSelector := it.GetArrayElement(2).AsType<TValue>.AsInteger;
          dp.DaySchedules.Add(ac);
        end;
        FDayProfileTablePassive.Add(dp);
      end;
    end;
  end
  else if e.Index = 10 Then
  begin
    FreeAndNil(FTime);
    if e.Value.IsType<TBytes> Then
    begin
      FTime := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
    end
    else
    begin
      FTime := e.Value.AsType<TGXDateTime>;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSActivityCalendar.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

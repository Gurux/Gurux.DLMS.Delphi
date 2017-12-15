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

unit Gurux.DLMS.Objects.GXDLMSClock;

interface

uses GXCommon, SysUtils, Rtti,
System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.ClockStatus,
Gurux.DLMS.ClockBase;

type
TGXDLMSClock = class(TGXDLMSObject)
  private
  FTime: TGXDateTime;
  FTimeZone: Integer;
  FStatus: TClockStatus;
  FBegin: TGXDateTime;
  FEnd: TGXDateTime;
  FDeviation: Integer;
  FEnabled: Boolean;
  FClockBase: TClockBase;

  public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  destructor Destroy; override;

  property Time: TGXDateTime read FTime write FTime;
  property TimeZone: Integer read FTimeZone write FTimeZone;
  property Status: TClockStatus read FStatus write FStatus;
  property &Begin: TGXDateTime read FBegin write FBegin;
  property &End: TGXDateTime read FEnd write FEnd;
  property Deviation: Integer read FDeviation write FDeviation;
  property Enabled: Boolean read FEnabled write FEnabled;
  property ClockBase: TClockBase read FClockBase write FClockBase;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
  function GetUIDataType(index : Integer) : TDataType;override;
end;

implementation

constructor TGXDLMSClock.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSClock.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSClock.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otClock, ln, 0);
end;

destructor TGXDLMSClock.Destroy;
begin
  inherited;
  FreeAndNil(FTime);
  FreeAndNil(FBegin);
  FreeAndNil(FEnd);
end;

function TGXDLMSClock.GetUIDataType(index : Integer) : TDataType;
begin
  if index = 2 then
      Result := TDataType.dtDateTime
  else
    Result := inherited GetUIDataType(index);
end;

function TGXDLMSClock.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FTime, FTimeZone, Integer(FStatus),
            FBegin, FEnd, FDeviation, FEnabled, Integer(FClockBase));
end;

function TGXDLMSClock.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //Time
  if CanRead(2) Then
    items.Add(2);

  //TimeZone
  if Not IsRead(3) Then
    items.Add(3);

  //Status
  if CanRead(4) Then
    items.Add(4);

  //Begin
  if Not IsRead(5) Then
    items.Add(5);

  //End
  if Not IsRead(6) Then
    items.Add(6);

  //Deviation
  if Not IsRead(7) Then
    items.Add(7);

  //Enabled
  if Not IsRead(8) Then
    items.Add(8);

  //ClockBase
  if Not IsRead(9) Then
      items.Add(9);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSClock.GetAttributeCount: Integer;
begin
  Result := 9;
end;

function TGXDLMSClock.GetMethodCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSClock.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
    else if index = 2 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtInt16;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else if index = 7 Then
  begin
    Result := TDataType.dtInt8;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtBoolean;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtEnum;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSClock.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
    else if e.Index = 2 Then
  begin
    Result := FTime;
  end
  else if e.Index = 3 Then
  begin
    Result := FTimeZone;
  end
  else if e.Index = 4 Then
  begin
    Result := TValue.From(FStatus);
  end
  else if e.Index = 5 Then
  begin
    Result := FBegin;
  end
  else if e.Index = 6 Then
  begin
    Result := FEnd;
  end
  else if e.Index = 7 Then
  begin
    Result := FDeviation;
  end
  else if e.Index = 8 Then
  begin
    Result := FEnabled;
  end
  else if e.Index = 9 Then
  begin
    Result := Integer(FClockBase);
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSClock.SetValue(e: TValueEventArgs);
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
      if e.Value.IsEmpty Then
        FTime := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
      begin
        if e.Value.IsType<TBytes> Then
          e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
        FTime := e.Value.AsType<TGXDateTime>;
      end;
  end
  else if e.Index = 3 Then
  begin
    FTimeZone := e.Value.AsInteger;
  end
  else if e.Index = 4 Then
  begin
    FStatus := TClockStatus(e.Value.AsInteger);
  end
  else if e.Index = 5 Then
  begin
    if e.Value.IsEmpty Then
      FBegin := TGXDateTime.Create(TGXDateTime.MinDateTime)
    else
    begin
      if e.Value.IsType<TBytes> Then
        e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
      FBegin := e.Value.AsType<TGXDateTime>;
    end;
  end
  else if e.Index = 6 Then
  begin
    if e.Value.IsEmpty Then
      FEnd := TGXDateTime.Create(TGXDateTime.MinDateTime)
    else
    begin
      if e.Value.IsType<TBytes> Then
        e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
      FEnd := e.Value.AsType<TGXDateTime>;
    end;
  end
  else if e.Index = 7 Then
  begin
    FDeviation := e.Value.AsInteger;
  end
  else if e.Index = 8 Then
  begin
    FEnabled := e.Value.AsBoolean;
  end
  else if e.Index = 9 Then
  begin
    FClockBase := TClockBase(e.Value.AsInteger);
  end
  else
  begin
  raise Exception.Create('SetValue failed. Invalid attribute index.');
  end
end;

function TGXDLMSClock.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

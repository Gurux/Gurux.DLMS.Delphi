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

unit Gurux.DLMS.Objects.GXDLMSExtendedRegister;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.Objects.GXDLMSRegister;

type
TGXDLMSExtendedRegister = class(TGXDLMSRegister)
  FStatus: TValue;
  FCaptureTime: TDateTime;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Status
  property Status: TValue read FStatus write FStatus;

  // Capture time.
  property CaptureTime: TDateTime read FCaptureTime write FCaptureTime;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;override;
  function GetAttributeCount: Integer;override;

  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
  function GetUIDataType(index : Integer) : TDataType;override;
end;

implementation

constructor TGXDLMSExtendedRegister.Create;
begin
  inherited Create(TObjectType.otExtendedRegister);
end;

constructor TGXDLMSExtendedRegister.Create(ln: string);
begin
  inherited Create(TObjectType.otExtendedRegister, ln, 0);
end;

constructor TGXDLMSExtendedRegister.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otExtendedRegister, ln, 0);
end;

destructor TGXDLMSExtendedRegister.Destroy;
begin
  inherited;
  FreeAndNil(FCaptureTime);
end;

function TGXDLMSExtendedRegister.GetUIDataType(index : Integer) : TDataType;
begin
  if index = 5 then
      Result := TDataType.dtDateTime
  else
    Result := inherited GetUIDataType(index);
end;

function TGXDLMSExtendedRegister.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FValue,
  'Scaler: ' + FloatToStr(GetScaler()) + ' Unit: ' + TGXCommon.UnitToString(FUnit),
  Status, CaptureTime);
end;

function TGXDLMSExtendedRegister.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //ScalerUnit
    if All or Not IsRead(3) Then
      items.Add(3);
    //Value
    if All or CanRead(2) Then
      items.Add(2);
    //Status
    if All or CanRead(4) Then
      items.Add(4);
    //CaptureTime
    if All or CanRead(5) Then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSExtendedRegister.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSExtendedRegister.GetDataType(index: Integer): TDataType;
begin
  if (index < 4) then
    Result := inherited GetDataType(index)
  else if (index = 4) then
  begin
    Result := inherited GetDataType(index);
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSExtendedRegister.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index < 4 then
    Result := inherited GetValue(e)
  else if e.Index = 4 then
  begin
    Result := FStatus;
  end
  else if e.Index = 5 Then
  begin
    Result := FCaptureTime;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSExtendedRegister.SetValue(e: TValueEventArgs);
var
  tm : TGXDateTime;
begin
 if e.Index < 4 then
   inherited SetValue(e)
  else if e.Index = 4 then
  begin
    FStatus := value;
  end
  else if e.Index = 5 then
  begin
    if e.Value.IsEmpty Then
    begin
      FCaptureTime := TGXDateTime.MinDateTime;
    end
    else
    begin
      if e.Value.IsType<TBytes> Then
      begin
        tm := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        FCaptureTime := tm.LocalTime;
        FreeAndNil(tm);
      end
      else
        FCaptureTime := e.Value.AsType<TGXDateTime>.LocalTime;
    end;
  end
  else
  begin
  raise Exception.Create('SetValue failed. Invalid attribute index.');
  end
end;

function TGXDLMSExtendedRegister.Invoke(e: TValueEventArgs): TBytes;
begin
  // Resets the value to the default value.
  // The default value is an instance specific constant.
  if e.Index = 1 then
  begin
    FValue := Nil;
    FCaptureTime := Now;
  end
  else
    raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

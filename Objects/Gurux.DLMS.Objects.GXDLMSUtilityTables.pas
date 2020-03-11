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

unit Gurux.DLMS.Objects.GXDLMSUtilityTables;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
//////////////////////////////////////////////////////////////////////////////
// Online help:
// https://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSUtilityTables
//////////////////////////////////////////////////////////////////////////////
TGXDLMSUtilityTables = class(TGXDLMSObject)
  FTableId: BYTE;
  FBuffer: TBytes;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property TableId: BYTE read FTableId write FTableId;
  property Buffer: TBytes read FBuffer write FBuffer;

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

constructor TGXDLMSUtilityTables.Create;
begin
  Create('0.0.65.0.0.255', 0);
end;

constructor TGXDLMSUtilityTables.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSUtilityTables.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otUtilityTables, ln, sn);
end;

function TGXDLMSUtilityTables.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FTableId, Length(FBuffer), TValue.From(FBuffer));
end;

function TGXDLMSUtilityTables.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //TableId
    if All or CanRead(2) then
      items.Add(2);
    //Length
    if All or CanRead(3) then
      items.Add(3);
    //Buffer
    if All or CanRead(4) then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSUtilityTables.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSUtilityTables.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSUtilityTables.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
    Result := TDataType.dtOctetString
  else if (index = 2) then
    Result := TDataType.dtUInt16
  else if (index = 3) then
    Result := TDataType.dtUInt32
  else if (index = 4) then
    Result := TDataType.dtOctetString
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

function TGXDLMSUtilityTables.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if e.Index = 2 then
    Result := FTableId
  else if e.Index = 3 then
    Result := Length(FBuffer)
  else if e.Index = 4 then
    Result := TValue.From(FBuffer)
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSUtilityTables.SetValue(e: TValueEventArgs);
begin
  if e.Index = 1 then
    FLogicalName := TGXCommon.ToLogicalName(e.Value)
  else if e.Index = 2 then
    FTableId := e.Value.AsInteger
  else if e.Index = 3 then
    // Skip len.
    Exit
  else if e.Index = 4 then
    FBuffer := e.Value.AsType<TBytes>()
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSUtilityTables.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

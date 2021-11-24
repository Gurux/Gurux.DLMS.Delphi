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

unit Gurux.DLMS.Objects.GXDLMSData;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSData = class(TGXDLMSObject)
  FValue: TValue;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property Value: TValue read FValue write FValue;

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

constructor TGXDLMSData.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSData.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSData.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otData, ln, sn);
end;

function TGXDLMSData.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FValue);
end;

function TGXDLMSData.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
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

function TGXDLMSData.GetAttributeCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSData.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSData.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if (index = 2) then
  begin
    Result := inherited GetDataType(index);
    if (Result = TDataType.dtNone) and (FValue.IsEmpty = False) Then
        Result := TGXCommon.GetDLMSDataType(FValue);
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

function TGXDLMSData.GetValue(e: TValueEventArgs): TValue;
begin
  if (e.Index = 1) then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if (e.Index = 2) then
  begin
    Result := FValue;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSData.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
    FLogicalName := TGXCommon.ToLogicalName(e.Value)
  else if (e.Index = 2) then
    FValue := e.Value
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSData.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSLlcSscsSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

// Online help:
// https://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSLlcSscsSetup
type
TGXDLMSLlcSscsSetup = class(TGXDLMSObject)
  FServiceNodeAddress: WORD;
  FBaseNodeAddress: WORD;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  //Address assigned to the service node during its registration by the base node.
  property ServiceNodeAddress: WORD read FServiceNodeAddress write FServiceNodeAddress;
  //Base node address to which the service node is registered.
  property BaseNodeAddress: WORD read FBaseNodeAddress write FBaseNodeAddress;

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

constructor TGXDLMSLlcSscsSetup.Create;
begin
  Create('0.0.28.0.0.255', 0);
end;

constructor TGXDLMSLlcSscsSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSLlcSscsSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otLlcSscsSetup, ln, sn);
end;

function TGXDLMSLlcSscsSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FServiceNodeAddress, FBaseNodeAddress);
end;

function TGXDLMSLlcSscsSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //ServiceNodeAddress
    if All or CanRead(2) then
      items.Add(2);
    //BaseNodeAddress
    if All or CanRead(3) then
      items.Add(3);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSLlcSscsSetup.GetAttributeCount: Integer;
begin
  Result := 3;
end;

function TGXDLMSLlcSscsSetup.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSLlcSscsSetup.GetDataType(index: Integer): TDataType;
begin
  case index of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtUInt16;
  3: Result := TDataType.dtUInt16;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSLlcSscsSetup.GetValue(e: TValueEventArgs): TValue;
begin
  case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := FServiceNodeAddress;
  3: Result := FBaseNodeAddress;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSLlcSscsSetup.SetValue(e: TValueEventArgs);
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: FServiceNodeAddress := e.Value.AsInteger;
  3: FBaseNodeAddress := e.Value.AsInteger;
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSLlcSscsSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  // Resets the value to the default value.
  // The default value is an instance specific constant.
  if e.Index = 1 then
  begin
    FServiceNodeAddress := 0;
    FBaseNodeAddress := 0;
  end
  else
    raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

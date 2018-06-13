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

unit Gurux.DLMS.Objects.GXDLMSMacAddressSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
GXByteBuffer;

type
TGXDLMSMacAddressSetup = class(TGXDLMSObject)
  FMacAddress: string;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property MacAddress: string read FMacAddress write FMacAddress;

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

constructor TGXDLMSMacAddressSetup.Create;
begin
  inherited Create(TObjectType.otMacAddressSetup, '0.0.25.2.0.255', 0);
end;

constructor TGXDLMSMacAddressSetup.Create(ln: string);
begin
  inherited Create(TObjectType.otMacAddressSetup, ln, 0);
end;

constructor TGXDLMSMacAddressSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otMacAddressSetup, ln, 0);
end;

function TGXDLMSMacAddressSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FMacAddress);
end;

function TGXDLMSMacAddressSetup.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //MacAddress
    if CanRead(2) then
      items.Add(2);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSMacAddressSetup.GetAttributeCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSMacAddressSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSMacAddressSetup.GetDataType(index: Integer): TDataType;
begin
 if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if (index = 2) then
  begin
    Result := TDataType.dtOctetString;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSMacAddressSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if (e.Index = 2) then
  begin
    Result := FMacAddress.Replace(':', '.');
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSMacAddressSetup.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if (e.Index = 2) then
  begin
    FMacAddress := TGXByteBuffer.ToHexString(e.Value.AsType<TBytes>);
    FMacAddress := FMacAddress.Replace('.', ':');
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSMacAddressSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcApplicationsIdentification;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSPrimeNbOfdmPlcApplicationsIdentification = class(TGXDLMSObject)
  // Textual description of the firmware version running on the device.
  FFirmwareVersion: String;
  // Unique vendor identifier assigned by PRIME Alliance.
  FVendorId: UInt16 ;
  // Vendor assigned unique identifier for specific product.
  FProductId: UInt16;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Textual description of the firmware version running on the device.
  property FirmwareVersion: String read FFirmwareVersion write FFirmwareVersion;
  // Unique vendor identifier assigned by PRIME Alliance.
  property VendorId: UInt16 read FVendorId write FVendorId;
  // Vendor assigned unique identifier for specific product.
  property ProductId: UInt16 read FProductId write FProductId;

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

constructor TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.Create;
begin
  Create('0.0.28.7.0.255', 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPrimeNbOfdmPlcApplicationsIdentification, ln, sn);
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FirmwareVersion, VendorId, ProductId);
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //FirmwareVersion
    if All or CanRead(2) then
      items.Add(2);
    //VendorId
    if All or CanRead(3) then
      items.Add(3);
    //ProductId
    if All or CanRead(4) then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.GetDataType(index: Integer): TDataType;
begin
  case index of
  1..2: Result := TDataType.dtOctetString;
  3..4: Result := TDataType.dtUInt16;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.GetValue(e: TValueEventArgs): TValue;
begin
 case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := TValue.From(TGXCommon.GetBytes(FFirmwareVersion));
  3: Result := FVendorId;
  4: Result := FProductId
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.SetValue(e: TValueEventArgs);
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: FFirmwareVersion := TEncoding.ASCII.GetString(e.Value.AsType<TBytes>);
  3: FVendorId := e.Value.AsInteger;
  4: FProductId := e.Value.AsInteger;
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

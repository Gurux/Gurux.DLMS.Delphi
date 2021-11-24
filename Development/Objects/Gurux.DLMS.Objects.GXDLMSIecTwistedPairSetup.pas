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

unit Gurux.DLMS.Objects.GXDLMSIecTwistedPairSetup;

interface

uses GXCommon,
SysUtils,
Rtti,
System.Generics.Collections,
Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
GXByteBuffer,
Gurux.DLMS.Objects.Enums.IecTwistedPairSetupMode,
Gurux.DLMS.BaudRate;

type
TGXDLMSIecTwistedPairSetup = class(TGXDLMSObject)
  // Working mode.
  FMode: TIecTwistedPairSetupMode;

  // Communication speed.
  FSpeed: TBaudRate;

  // List of Primary Station Addresses.
  FPrimaryAddresses : TArray<UInt8>;

  // List of the TAB(i) for which the real equipment has been programmed
  // in the case of forgotten station call.
  FTabis : TArray<Int8>;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Working mode.
  property Mode: TIecTwistedPairSetupMode read FMode write FMode;
  // Communication speed.
  property Speed: TBaudRate read FSpeed write FSpeed;
   // List of Primary Station Addresses.
  property PrimaryAddresses: TArray<UInt8> read FPrimaryAddresses write FPrimaryAddresses;
  // List of the TAB(i) for which the real equipment has been programmed
  // in the case of forgotten station call.
  property Tabis: TArray<Int8> read FTabis write FTabis;

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

constructor TGXDLMSIecTwistedPairSetup.Create;
begin
  Create('0.0.23.0.0.255', 0);
end;

constructor TGXDLMSIecTwistedPairSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSIecTwistedPairSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otIecTwistedPairSetup, ln, sn);
end;

function TGXDLMSIecTwistedPairSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FMode), TValue.From(FSpeed),
            TValue.From(FPrimaryAddresses), TValue.From(FTabis));
end;

function TGXDLMSIecTwistedPairSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //Mode
    if All or CanRead(2) then
      items.Add(2);

    //Speed
    if All or CanRead(3) then
      items.Add(3);
    //PrimaryAddresses
    if All or CanRead(4) then
      items.Add(4);
    //Tabis
    if All or CanRead(5) then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSIecTwistedPairSetup.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSIecTwistedPairSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSIecTwistedPairSetup.GetDataType(index: Integer): TDataType;
begin
 if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSIecTwistedPairSetup.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it: BYTE;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(FMode);
  end
  else if e.Index = 3 Then
  begin
    Result := Integer(FSpeed);
  end
  else if e.Index = 4 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      if PrimaryAddresses = Nil Then
      begin
        data.SetUInt8(0);
      end
      else
      begin
        data.SetUInt8(Length(FPrimaryAddresses));
        for it in FPrimaryAddresses do
        begin
          data.SetUInt8(Integer(TDataType.dtUInt8));
          data.SetUInt8(it);
        end;
      end;
    finally
      data.Free;
    end;
  end
  else if e.Index = 5 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      if FTabis = Nil Then
      begin
        data.SetUInt8(0);
      end
      else
      begin
        data.SetUInt8(Length(FTabis));
        for it in FTabis do
        begin
          data.SetUInt8(Integer(TDataType.dtInt8));
          data.SetUInt8(it);
        end;
      end;
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSIecTwistedPairSetup.SetValue(e: TValueEventArgs);
var
  it: TValue;
  list1: TList<UInt8>;
  list2: TList<Int8>;
begin
   if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FMode := TIecTwistedPairSetupMode(e.Value.AsInteger);
  end
  else if e.Index = 3 Then
  begin
    FSpeed := TBaudRate(e.Value.AsInteger);
  end
  else if e.Index = 4 Then
  try
    list1 := TList<UInt8>.Create;
    for it in e.Value.AsType<TArray<TValue>> do
      list1.Add((it.AsType<UInt8>()));
    FPrimaryAddresses := list1.ToArray;
  finally
    FreeAndNil(list1);
  end
  else if e.Index = 5 Then
  try
    list2 := TList<Int8>.Create;
    for it in e.Value.AsType<TArray<TValue>> do
      list2.Add((it.AsType<Int8>()));
    FTabis := list2.ToArray;
  finally
    FreeAndNil(list2);
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSIecTwistedPairSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

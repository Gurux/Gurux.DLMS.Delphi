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

unit Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSPrimeNbOfdmPlcMacSetup = class(TGXDLMSObject)
  // PIB attribute 0x0010.
  FMacMinSwitchSearchTime: BYTE;

  // PIB attribute 0x0011.
  FMacMaxPromotionPdu: BYTE;

  // PIB attribute 0x0012.
  FMacPromotionPduTxPeriod: BYTE;

  // PIB attribute 0x0013.
  FMacBeaconsPerFrame: BYTE;

  // PIB attribute 0x0014.
  FMacScpMaxTxAttempts: BYTE;

  // PIB attribute 0x0015.
  FMacCtlReTxTimer: BYTE;

  // PIB attribute 0x0018.
  FMacMaxCtlReTx: BYTE;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // PIB attribute 0x0010.
  property MacMinSwitchSearchTime: BYTE read FMacMinSwitchSearchTime write FMacMinSwitchSearchTime;

  // PIB attribute 0x0011.
  property MacMaxPromotionPdu: BYTE read FMacMaxPromotionPdu write FMacMaxPromotionPdu;

  // PIB attribute 0x0012.
  property MacPromotionPduTxPeriod: BYTE read FMacPromotionPduTxPeriod write FMacPromotionPduTxPeriod;

  // PIB attribute 0x0013.
  property MacBeaconsPerFrame: BYTE read FMacBeaconsPerFrame write FMacBeaconsPerFrame;

  // PIB attribute 0x0014.
  property MacScpMaxTxAttempts: BYTE read FMacScpMaxTxAttempts write FMacScpMaxTxAttempts;

  // PIB attribute 0x0015.
  property MacCtlReTxTimer: BYTE read FMacCtlReTxTimer write FMacCtlReTxTimer;

  // PIB attribute 0x0018.
  property MacMaxCtlReTx: BYTE read FMacMaxCtlReTx write FMacMaxCtlReTx;


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

constructor TGXDLMSPrimeNbOfdmPlcMacSetup.Create;
begin
  Create('0.0.28.2.0.255', 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPrimeNbOfdmPlcMacSetup, ln, sn);
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, MacMinSwitchSearchTime,
            MacMaxPromotionPdu, MacPromotionPduTxPeriod, MacBeaconsPerFrame,
            MacScpMaxTxAttempts, MacCtlReTxTimer, MacMaxCtlReTx);
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    // MacMinSwitchSearchTime
    if All or CanRead(2) then
      items.Add(2);
    // MacMaxPromotionPdu
    if All or CanRead(3) then
      items.Add(3);
    // MacPromotionPduTxPeriod
    if All or CanRead(4) then
      items.Add(4);
    // MacBeaconsPerFrame
    if All or CanRead(5) then
      items.Add(5);
    // MacScpMaxTxAttempts
    if All or CanRead(6) then
      items.Add(6);
    // MacCtlReTxTimer
    if All or CanRead(7) then
      items.Add(7);
    // MacMaxCtlReTx
    if All or CanRead(8) then
      items.Add(8);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.GetAttributeCount: Integer;
begin
  Result := 8;
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.GetDataType(index: Integer): TDataType;
begin
 case index of
  1: Result := TDataType.dtOctetString;
  2..8: Result := TDataType.dtUInt8;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.GetValue(e: TValueEventArgs): TValue;
begin
  case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := FMacMinSwitchSearchTime;
  3: Result := FMacMaxPromotionPdu;
  4: Result := FMacPromotionPduTxPeriod;
  5: Result := FMacBeaconsPerFrame;
  6: Result := FMacScpMaxTxAttempts;
  7: Result := FMacCtlReTxTimer;
  8: Result := FMacMaxCtlReTx;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacSetup.SetValue(e: TValueEventArgs);
begin
 case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: FMacMinSwitchSearchTime := e.Value.AsInteger;
  3: FMacMaxPromotionPdu := e.Value.AsInteger;
  4: FMacPromotionPduTxPeriod := e.Value.AsInteger;
  5: FMacBeaconsPerFrame := e.Value.AsInteger;
  6: FMacScpMaxTxAttempts := e.Value.AsInteger;
  7: FMacCtlReTxTimer := e.Value.AsInteger;
  8: FMacMaxCtlReTx := e.Value.AsInteger;
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;
end.

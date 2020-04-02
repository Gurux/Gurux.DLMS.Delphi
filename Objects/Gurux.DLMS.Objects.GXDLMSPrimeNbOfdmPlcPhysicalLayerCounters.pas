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

unit Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcPhysicalLayerCounters;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

// Online help:
// http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcPhysicalLayerCounters
type
TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters = class(TGXDLMSObject)
  // Number of bursts received on the physical layer for which the CRC was
  // incorrect.
  FCrcIncorrectCount: WORD;
  // Number of bursts received on the physical layer for which the CRC was
  // correct, but the Protocol field of PHY header had invalid value.
  FCrcFailedCount: WORD;
  // Number of times when PHY layer received new data to transmit.
  FTxDropCount: WORD;
  // Number of times when the PHY layer received new data on the channel.
  FRxDropCount: WORD;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Number of bursts received on the physical layer for which the CRC was
  // incorrect.
  property CrcIncorrectCount: WORD read FCrcIncorrectCount write FCrcIncorrectCount;
  // Number of bursts received on the physical layer for which the CRC was
  // correct, but the Protocol field of PHY header had invalid value.
  property CrcFailedCount: WORD read FCrcFailedCount write FCrcFailedCount;
  // Number of times when PHY layer received new data to transmit.
  property TxDropCount: WORD read FTxDropCount write FTxDropCount;
  // Number of times when the PHY layer received new data on the channel.
  property RxDropCount: WORD read FRxDropCount write FRxDropCount;

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

constructor TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.Create;
begin
  Create('0.0.28.1.0.255', 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPrimeNbOfdmPlcPhysicalLayerCounters, ln, sn);
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FCrcIncorrectCount,
            FCrcFailedCount, FTxDropCount, FRxDropCount);
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //CrcIncorrectCount
    if All or CanRead(2) then
      items.Add(2);
    //CrcFailedCount
    if All or CanRead(3) then
      items.Add(3);
    //TxDropCount
    if All or CanRead(4) then
      items.Add(4);
    //RxDropCount
    if All or CanRead(5) then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.GetDataType(index: Integer): TDataType;
begin
  case index of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtUInt16;
  3: Result := TDataType.dtUInt16;
  4: Result := TDataType.dtUInt16;
  5: Result := TDataType.dtUInt16;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.GetValue(e: TValueEventArgs): TValue;
begin
 case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := FCrcIncorrectCount;
  3: Result := FCrcFailedCount;
  4: Result := FTxDropCount;
  5: Result := FRxDropCount;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.SetValue(e: TValueEventArgs);
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: FCrcIncorrectCount := e.Value.AsInteger;
  3: FCrcFailedCount := e.Value.AsInteger;
  4: FTxDropCount := e.Value.AsInteger;
  5: FRxDropCount := e.Value.AsInteger;
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

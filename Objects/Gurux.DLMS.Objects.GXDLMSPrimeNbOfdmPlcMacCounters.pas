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

unit Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacCounters;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSPrimeNbOfdmPlcMacCounters = class(TGXDLMSObject)
  // Count of successfully transmitted MSDUs.
  FTxDataPktCount: UInt32;
  // Count of successfully received MSDUs whose destination address was this node.
  FRxDataPktCount: UInt32;
  // Count of successfully transmitted MAC control packets.
  FTxCtrlPktCount: UInt32;
  // Count of successfully received MAC control packets whose destination was this node.
  FRxCtrlPktCount: UInt32;
  // Count of failed CSMA transmit attempts.
  FCsmaFailCount: UInt32;
  // Count of number of times this node has to back off SCP transmission due to channel busy state.
  FCsmaChBusyCount: UInt32;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  // Count of successfully transmitted MSDUs.
  property TxDataPktCount: UInt32 read FTxDataPktCount write FTxDataPktCount;
  // Count of successfully received MSDUs whose destination address was this node.
  property RxDataPktCount: UInt32 read FRxDataPktCount write FRxDataPktCount;
  // Count of successfully transmitted MAC control packets.
  property TxCtrlPktCount: UInt32 read FTxCtrlPktCount write FTxCtrlPktCount;
  // Count of successfully received MAC control packets whose destination was this node.
  property RxCtrlPktCount: UInt32 read FRxCtrlPktCount write FRxCtrlPktCount;
  // Count of failed CSMA transmit attempts.
  property CsmaFailCount: UInt32 read FCsmaFailCount write FCsmaFailCount;
  // Count of number of times this node has to back off SCP transmission due to channel busy state.
  property CsmaChBusyCount: UInt32 read FCsmaChBusyCount write FCsmaChBusyCount;

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

constructor TGXDLMSPrimeNbOfdmPlcMacCounters.Create;
begin
  Create('0.0.28.4.0.255', 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacCounters.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacCounters.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPrimeNbOfdmPlcMacCounters, ln, sn);
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TxDataPktCount, RxDataPktCount, TxCtrlPktCount, RxCtrlPktCount, CsmaFailCount, CsmaChBusyCount);
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //TxDataPktCount
    if All or CanRead(2) then
      items.Add(2);
    // RxDataPktCount
    if All or CanRead(3) then
      items.Add(3);
    // TxCtrlPktCount
    if All or CanRead(4) then
      items.Add(4);
    // RxCtrlPktCount
    if All or CanRead(5) then
      items.Add(5);
    // CsmaFailCount
    if All or CanRead(6) then
      items.Add(6);
    // CsmaChBusyCount
    if All or CanRead(7) then
      items.Add(7);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.GetAttributeCount: Integer;
begin
  Result := 7;
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.GetDataType(index: Integer): TDataType;
begin
  case index of
  1: Result := TDataType.dtOctetString;
  2..7: Result := TDataType.dtUInt32;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.GetValue(e: TValueEventArgs): TValue;
begin
 case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := TxDataPktCount;
  3: Result := RxDataPktCount;
  4: Result := TxCtrlPktCount;
  5: Result := RxCtrlPktCount;
  6: Result := CsmaFailCount;
  7: Result := CsmaChBusyCount;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacCounters.SetValue(e: TValueEventArgs);
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: TxDataPktCount := e.Value.AsInteger;
  3: RxDataPktCount := e.Value.AsInteger;
  4: TxCtrlPktCount := e.Value.AsInteger;
  5: RxCtrlPktCount := e.Value.AsInteger;
  6: CsmaFailCount := e.Value.AsInteger;
  7: CsmaChBusyCount := e.Value.AsInteger;
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacCounters.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

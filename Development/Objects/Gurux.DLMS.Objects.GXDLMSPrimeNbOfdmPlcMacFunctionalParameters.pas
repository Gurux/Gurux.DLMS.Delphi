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

unit Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacFunctionalParameters;

interface

uses GXCommon,
SysUtils,
Rtti,
System.Generics.Collections,
Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.Enums.MacState,
Gurux.DLMS.Objects.Enums.MacCapabilities;

type
TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters = class(TGXDLMSObject)

  // LNID allocated to this node at time of its registration.
  FLnId: SmallInt;

  // LSID allocated to this node at the time of its promotion.
  FLsId: BYTE;

  // SID of the switch node through which this node is connected to the subnetwork.
  FSId: BYTE;

  // Subnetwork address to which this node is registered.
  FSna: TBytes;

  // Present functional state of the node.
  FState: TMacState;

  // The SCP length, in symbols, in present frame.
  FScpLength: SmallInt;

  // Level of this node in subnetwork hierarchy.
  FNodeHierarchyLevel: BYTE;

  // Number of beacon slots provisioned in present frame structure.
  FBeaconSlotCount: BYTE;

  // Beacon slot in which this device’s switch node transmits its beacon.
  FBeaconRxSlot: BYTE;

  // Beacon slot in which this device transmits its beacon.
  FBeaconTxSlot: BYTE;

  // Number of frames between receptions of two successive beacons.
  FBeaconRxFrequency: BYTE;

  // Number of frames between transmissions of two successive beacons.
  FBeaconTxFrequency: BYTE ;

  // This attribute defines the capabilities of the node.
  FCapabilities: TMacCapabilities;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // LNID allocated to this node at time of its registration.
  property LnId: SmallInt read FLnId write FLnId;

  // LSID allocated to this node at the time of its promotion.
  property LsId: BYTE read FLsId write FLsId;

  // SID of the switch node through which this node is connected to the subnetwork.
  property SId: BYTE read FSId write FSId;

  // Subnetwork address to which this node is registered.
  property Sna: TBytes read FSna write FSna;

  // Present functional state of the node.
  property State: TMacState read FState write FState;

  // The SCP length, in symbols, in present frame.
  property ScpLength: SmallInt read FScpLength write FScpLength;

  // Level of this node in subnetwork hierarchy.
  property NodeHierarchyLevel: BYTE read FNodeHierarchyLevel write FNodeHierarchyLevel;

  // Number of beacon slots provisioned in present frame structure.
  property BeaconSlotCount: BYTE read FBeaconSlotCount write FBeaconSlotCount;

  // Beacon slot in which this device’s switch node transmits its beacon.
  property BeaconRxSlot: BYTE read FBeaconRxSlot write FBeaconRxSlot;

  // Beacon slot in which this device transmits its beacon.
  property BeaconTxSlot: BYTE read FBeaconTxSlot write FBeaconTxSlot;

  // Number of frames between receptions of two successive beacons.
  property BeaconRxFrequency: BYTE read FBeaconRxFrequency write FBeaconRxFrequency;

  // Number of frames between transmissions of two successive beacons.
  property BeaconTxFrequency: BYTE read FBeaconTxFrequency write FBeaconTxFrequency;

  // This attribute defines the capabilities of the node.
  property Capabilities: TMacCapabilities read FCapabilities write FCapabilities;

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

constructor TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.Create;
begin
  Create('0.0.28.3.0.255', 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPrimeNbOfdmPlcMacFunctionalParameters, ln, sn);
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, LnId, LsId, SId, TValue.From(Sna), TValue.From(State),
            ScpLength, NodeHierarchyLevel, BeaconSlotCount,
            BeaconRxSlot, BeaconTxSlot, BeaconRxFrequency ,
            BeaconTxFrequency, TValue.From(FCapabilities));
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    // LnId
    if All or CanRead(2) then
      items.Add(2);
    // LsId
    if All or CanRead(3) then
      items.Add(3);
    // SId
    if All or CanRead(4) then
      items.Add(4);
    // Sna
    if All or CanRead(5) then
      items.Add(5);
    // State
    if All or CanRead(6) then
      items.Add(6);
    // ScpLength
    if All or CanRead(7) then
      items.Add(7);
    // NodeHierarchyLevel
    if All or CanRead(8) then
      items.Add(8);
    // BeaconSlotCount
    if All or CanRead(9) then
      items.Add(9);
    // BeaconRxSlot
    if All or CanRead(10) then
      items.Add(10);
    // BeaconTxSlot
    if All or CanRead(11) then
      items.Add(11);
    // BeaconRxFrequency
    if All or CanRead(12) then
      items.Add(12);
    // BeaconTxFrequency
    if All or CanRead(13) then
      items.Add(13);
    // Capabilities
    if All or CanRead(14) then
      items.Add(14);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.GetAttributeCount: Integer;
begin
  Result := 14;
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.GetDataType(index: Integer): TDataType;
begin
  case index of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtUInt16;
  3: Result := TDataType.dtUInt8;
  4: Result := TDataType.dtUInt8;
  5: Result := TDataType.dtOctetString;
  6: Result := TDataType.dtEnum;
  7: Result := TDataType.dtUInt16;
  8: Result := TDataType.dtUInt8;
  9: Result := TDataType.dtUInt8;
  10: Result := TDataType.dtUInt8;
  11: Result := TDataType.dtUInt8;
  12: Result := TDataType.dtUInt8;
  13: Result := TDataType.dtUInt8;
  14: Result := TDataType.dtUInt16;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.GetValue(e: TValueEventArgs): TValue;
begin
 case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := FLnId;
  3: Result := FLsId;
  4: Result := FSId;
  5: Result := TValue.From(FSna);
  6: Result := Integer(FState);
  7: Result := FScpLength;
  8: Result := FNodeHierarchyLevel;
  9: Result := FBeaconSlotCount;
  10: Result := FBeaconRxSlot;
  11: Result := FBeaconTxSlot;
  12: Result := FBeaconRxFrequency;
  13: Result := FBeaconTxFrequency;
  14: Result := Integer(FCapabilities);
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.SetValue(e: TValueEventArgs);
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: FLnId := e.Value.AsInteger;
  3: FLsId := e.Value.AsInteger;
  4: FSId := e.Value.AsInteger;
  5: FSna := e.Value.AsType<TBytes>;
  6: FState := TMacState(e.Value.AsInteger);
  7: FScpLength := e.Value.AsInteger;
  8: FNodeHierarchyLevel := e.Value.AsInteger;
  9: FBeaconSlotCount := e.Value.AsInteger;
  10: FBeaconRxSlot := e.Value.AsInteger;
  11: FBeaconTxSlot := e.Value.AsInteger;
  12: FBeaconRxFrequency := e.Value.AsInteger;
  13: FBeaconTxFrequency := e.Value.AsInteger;
  14: FCapabilities := TMacCapabilities(e.Value.AsInteger);
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSCharge;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.ChargeType, Gurux.DLMS.GXUnitCharge,
Gurux.DLMS.GXDateTime, GXByteBuffer, Gurux.DLMS.GXChargeTable;

type
//Online help:
//  http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
TGXDLMSCharge = class(TGXDLMSObject)
private
  {
     Total amount paid.
     }
    FTotalAmountPaid: Integer;

    {
     Charge type.
     }
    FChargeType: TChargeType;
    {
     Priority.
     }
    FPriority: Byte;
    {
     Unit charge active.
     }
    FUnitChargeActive: TGXUnitCharge;
    {
     Unit charge passive.
     }
    FUnitChargePassive: TGXUnitCharge;
    {
     Unit charge activation time.
     }
    FUnitChargeActivationTime: TGXDateTime;
    {
     Period.
     }
    FPeriod: Integer;
    {
     Charge configuration.
     }
    FChargeConfiguration: string;
    {
     Last collection time.
     }
    FLastCollectionTime: TGXDateTime;

    {
     Last collection amount.
     }
    FLastCollectionAmount: Integer;
    {
     Total amount remaining.
     }
    FTotalAmountRemaining: Integer;
    {
     Proportion.
     }
    FProportion: Integer;

    class procedure SetUnitCharge(charge: TGXUnitCharge; e: TValueEventArgs);
    class function GetUnitCharge(charge: TGXUnitCharge): TValue;

    public

    constructor Create; overload;
    constructor Create(ln: string); overload;
    constructor Create(ln: string; sn: System.UInt16); overload;
    destructor Destroy; override;

  {
   Total amount paid.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property TotalAmountPaid: Integer read FTotalAmountPaid write FTotalAmountPaid;

  {
   Charge type.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property ChargeType: TChargeType read FChargeType write FChargeType;
  {
   Priority.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property Priority: Byte read FPriority write FPriority;
  {
   Unit charge active.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property UnitChargeActive: TGXUnitCharge read FUnitChargeActive write FUnitChargeActive;
  {
   Unit charge passive.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property UnitChargePassive: TGXUnitCharge read FUnitChargePassive write FUnitChargePassive;
  {
   Unit charge activation time.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property UnitChargeActivationTime: TGXDateTime read FUnitChargeActivationTime write FUnitChargeActivationTime;
  {
   Period.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property Period: Integer read FPeriod write FPeriod;
  {
   Charge configuration.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property ChargeConfiguration: string read FChargeConfiguration write FChargeConfiguration;
  {
   Last collection time.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property LastCollectionTime: TGXDateTime read FLastCollectionTime write FLastCollectionTime;

  {
   Last collection amount.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property LastCollectionAmount: Integer read FLastCollectionAmount write FLastCollectionAmount;
  {
   Total amount remaining.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property TotalAmountRemaining: Integer read FTotalAmountRemaining write FTotalAmountRemaining;
  {
   Proportion.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
   }
  property Proportion: Integer read FProportion write FProportion;

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

constructor TGXDLMSCharge.Create;
begin
  Create('0.0.19.20.0.255', 0);
end;

constructor TGXDLMSCharge.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSCharge.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otCharge, ln, sn);
  FUnitChargeActive := TGXUnitCharge.Create();
  FUnitChargePassive := TGXUnitCharge.Create();
end;

destructor TGXDLMSCharge.Destroy;
begin
  inherited;
  FreeandNil(FUnitChargeActive);
  FreeandNil(FUnitChargePassive);
  FreeandNil(FUnitChargeActivationTime);
  FreeandNil(FLastCollectionTime);
end;

function TGXDLMSCharge.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FTotalAmountPaid, Integer(FChargeType),
  FPriority, FUnitChargeActive, FUnitChargePassive, FUnitChargeActivationTime,
  FPeriod, FChargeConfiguration, FLastCollectionTime, FLastCollectionAmount,
  FTotalAmountRemaining, FProportion);
end;

function TGXDLMSCharge.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    // TotalAmountPaid
    if CanRead(2) Then
      items.Add(2);

    // ChargeType
    if CanRead(3) Then
      items.Add(3);

    // Priority
    if CanRead(4) Then
      items.Add(4);

    // UnitChargeActive
    if CanRead(5) Then
      items.Add(5);

    // UnitChargePassive
    if CanRead(6) Then
      items.Add(6);

    // UnitChargeActivationTime
    if CanRead(7) Then
      items.Add(7);

    // Period
    if CanRead(8) Then
      items.Add(8);

    // ChargeConfiguration
    if CanRead(9) Then
      items.Add(9);

    // LastCollectionTime
    if CanRead(10) Then
      items.Add(10);

    // LastCollectionAmount
    if CanRead(11) Then
      items.Add(11);

    // TotalAmountRemaining
    if CanRead(12) Then
      items.Add(12);

    // Proportion
    if CanRead(13) Then
      items.Add(13);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSCharge.GetAttributeCount: Integer;
begin
  Result := 13;
end;

function TGXDLMSCharge.GetMethodCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSCharge.GetDataType(index: Integer): TDataType;
begin
 case index Of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtInt32;
  3: Result := TDataType.dtEnum;
  4: Result := TDataType.dtUInt8;
  5: Result := TDataType.dtStructure;
  6: Result := TDataType.dtStructure;
  7: Result := TDataType.dtOctetString;
  8: Result := TDataType.dtUInt32;
  9: Result := TDataType.dtBitString;
  10: Result := TDataType.dtOctetString;
  11: Result := TDataType.dtInt32;
  12: Result := TDataType.dtInt32;
  13: Result := TDataType.dtUInt16;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSCharge.GetValue(e: TValueEventArgs): TValue;
begin
 case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := FTotalAmountPaid;
  3: Result := Integer(FChargeType);
  4: Result := FPriority;
  5: Result := GetUnitCharge(unitChargeActive);
  6: Result := GetUnitCharge(unitChargePassive);
  7: Result := FUnitChargeActivationTime;
  8: Result := FPeriod;
  9: Result := FChargeConfiguration;
  10: Result := FLastCollectionTime;
  11: Result := FLastCollectionAmount;
  12: Result := FTotalAmountRemaining;
  13: Result := FProportion;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSCharge.SetValue(e: TValueEventArgs);
begin
  case e.Index of
    1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
    2: FTotalAmountPaid := e.Value.AsInteger;
    3: FChargeType := TChargeType(e.Value.AsInteger);
    4: FPriority := e.Value.AsInteger;
    5: SetUnitCharge(FUnitChargeActive, e);
    6: SetUnitCharge(FUnitChargePassive, e);
    7:
    begin
      FreeAndNil(FUnitChargeActivationTime);
      if e.Value.IsEmpty Then
        FUnitChargeActivationTime := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
      begin
        if e.Value.IsType<TBytes> Then
          e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);

        FUnitChargeActivationTime := e.Value.AsType<TGXDateTime>;
      end;
    end;
    8: FPeriod := e.Value.AsInteger;
    9: FChargeConfiguration := e.Value.ToString;
    10:
    begin
      FreeAndNil(FLastCollectionTime);
      if e.Value.IsEmpty Then
        FLastCollectionTime := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
      begin
        if e.Value.IsType<TBytes> Then
          e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);

        FLastCollectionTime := e.Value.AsType<TGXDateTime>;
      end;
    end;
    11:FLastCollectionAmount := e.Value.AsInteger;
    12:FTotalAmountRemaining := e.Value.AsInteger;
    13:FProportion := e.Value.AsInteger;
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;
end;

function TGXDLMSCharge.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

class procedure TGXDLMSCharge.SetUnitCharge(charge: TGXUnitCharge; e: TValueEventArgs);
var
  ot: TObjectType;
  ln: string;
  it: TValue;
  item: TGXChargeTable;
  tmp: TArray<TValue>;
  tmp2: TArray<TValue>;
begin
  tmp := e.Value.AsType<TArray<TValue>>;
  tmp2 := tmp[0].AsType<TArray<TValue>>;
  charge.ChargePerUnitScaling.CommodityScale := tmp2[0].AsType<TValue>.AsInteger;
  charge.ChargePerUnitScaling.PriceScale := tmp2[1].AsType<TValue>.AsInteger;
  tmp2 := tmp[1].AsType<TArray<TValue>>;
  ot := TObjectType(tmp2[0].AsType<TValue>.AsInteger);
  ln := TGXCommon.ToLogicalName(tmp2[1]);
  charge.Commodity.Target := e.settings.Objects.FindByLN(ot, ln);
  charge.Commodity.Index := tmp2[2].AsType<TValue>.AsInteger;
  charge.ChargeTables.Clear();
  if Length(tmp) > 2 then
  begin
    tmp2 := tmp[2].AsType<TArray<TValue>>;
    for it in tmp2 do
    begin
      item := TGXChargeTable.Create();
      try
        item.Index := TEncoding.ASCII.GetString(it.AsType<TArray<TValue>>[0].AsType<TBytes>);
        item.ChargePerUnit := it.AsType<TArray<TValue>>[1].AsInteger;
      except
        item.Free;
        raise;
      end;
      charge.ChargeTables.Add(item);
    end;
  end;
end;

class function TGXDLMSCharge.GetUnitCharge(charge: TGXUnitCharge): TValue;
var
   bb: TGXByteBuffer;
   it: TGXChargeTable;
begin
  bb := TGXByteBuffer.Create();
  try
    bb.SetUInt8(Integer(TDataType.dtStructure));
    bb.SetUInt8(3);
    bb.SetUInt8(Integer(TDataType.dtStructure));
    bb.SetUInt8(2);
    TGXCommon.SetData(bb, TDataType.dtInt8, charge.ChargePerUnitScaling.CommodityScale);
    TGXCommon.SetData(bb, TDataType.dtInt8, charge.ChargePerUnitScaling.PriceScale);
    bb.SetUInt8(Integer(TDataType.dtStructure));
    bb.SetUInt8(3);
    if charge.Commodity.Target = Nil Then
    begin
        TGXCommon.SetData(bb, TDataType.dtUInt16, 0);
        bb.setUInt8(Integer(TDataType.dtOctetString));
        bb.setUInt8(6);
        bb.setUInt8(0);
        bb.setUInt8(0);
        bb.setUInt8(0);
        bb.setUInt8(0);
        bb.setUInt8(0);
        bb.setUInt8(0);
        TGXCommon.SetData(bb, TDataType.dtInt8, 0);
    end
    else
    begin
        TGXCommon.SetData(bb, TDataType.dtUInt16, Integer(charge.Commodity.Target.ObjectType));
        TGXCommon.SetData(bb, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(charge.Commodity.Target.LogicalName)));
        TGXCommon.SetData(bb, TDataType.dtInt8, charge.Commodity.Index);
    end;
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(charge.ChargeTables.Count, bb);
    for it in charge.ChargeTables do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(2);
      TGXCommon.SetData(bb, TDataType.dtOctetString, it.Index);
      TGXCommon.SetData(bb, TDataType.dtInt16, it.ChargePerUnit);
    end;
    Result := TValue.From(bb.ToArray());
  finally
    freeAndNil(bb);
  end;
end;

end.

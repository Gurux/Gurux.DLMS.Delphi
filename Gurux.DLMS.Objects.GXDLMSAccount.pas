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

unit Gurux.DLMS.Objects.GXDLMSAccount;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
GXByteBuffer, Gurux.DLMS.PaymentMode, Gurux.DLMS.AccountStatus,
Gurux.DLMS.AccountCreditStatus, Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXCreditChargeConfiguration,
Gurux.DLMS.GXTokenGatewayConfiguration,
Gurux.DLMS.CreditCollectionConfiguration,
Gurux.DLMS.GXCurrency, Gurux.DLMS.Currency;

type
TGXDLMSAccount = class(TGXDLMSObject)
private
    //Payment mode.
    FPaymentMode: TPaymentMode;
    //Account status.
    FAccountStatus: TAccountStatus;
    // Credit In Use.
    FCurrentCreditInUse: BYTE;
    //Credit status.
    FCurrentCreditStatus: TAccountCreditStatus;

    FAvailableCredit: Integer;
    //Amount to clear.
    FAmountToClear: Integer;

    {
     * Conjunction with the amount to clear, and is included in the description
     * of that attribute.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    FClearanceThreshold: Integer;

    //Aggregated debt.
    FAggregatedDebt: Integer;

    //Credit references.
    FCreditReferences: TList<String>;

    //Charge references.
    FChargeReferences: TList<String>;

    //Credit charge configurations.
    FCreditChargeConfigurations: TObjectList<TGXCreditChargeConfiguration>;

    //Token gateway configurations.
    FTokenGatewayConfigurations : TObjectList<TGXTokenGatewayConfiguration>;

    //Account activation time.
    FAccountActivationTime : TGXDateTime;

    //Account closure time.
    FAccountClosureTime: TGXDateTime;

    //Currency.
    FCurrency: TGXCurrency;

    // Low credit threshold.
    FLowCreditThreshold: Integer;

    //Next credit available threshold.
    FNextCreditAvailableThreshold: Integer;

    //Max Provision.
    FMaxProvision: Integer;

    //Max provision period.
    FMaxProvisionPeriod: Integer;

  public

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  destructor Destroy; override;
   {
   * Payment mode.
   * Online help:
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
   }
   property PaymentMode: TPaymentMode read FPaymentMode write FPaymentMode;

    {
     * Account status.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property AccountStatus: TAccountStatus read FAccountStatus write FAccountStatus;

    {
     * Credit In Use.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property CurrentCreditInUse: BYTE read FCurrentCreditInUse write FCurrentCreditInUse;

    {
     * Credit status.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
     }
    property CurrentCreditStatus: TAccountCreditStatus read FCurrentCreditStatus write FCurrentCreditStatus;

    {
     * The available_credit attribute is the sum of the positive current credit
     * amount values in the instances of the Credit class.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property AvailableCredit: Integer read FAvailableCredit write FAvailableCredit;

    {
     * Amount to clear.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
     }
    property AmountToClear: Integer read FAmountToClear write FAmountToClear;

    {
     * Conjunction with the amount to clear, and is included in the description
     * of that attribute.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property ClearanceThreshold: Integer read FClearanceThreshold write FClearanceThreshold;

    {
     * Aggregated debt.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property AggregatedDebt: Integer read FAggregatedDebt write FAggregatedDebt;

    {
     * Credit references.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property CreditReferences: TList<String> read FCreditReferences write FCreditReferences;

    {
     * Charge references.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property ChargeReferences: TList<String> read FChargeReferences write FChargeReferences;

    {
     * Credit charge configurations.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property CreditChargeConfigurations: TObjectList<TGXCreditChargeConfiguration> read FCreditChargeConfigurations;

    {
     * Token gateway configurations.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property TokenGatewayConfigurations : TObjectList<TGXTokenGatewayConfiguration> read FTokenGatewayConfigurations;

    {
     * Account activation time.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property AccountActivationTime : TGXDateTime read FAccountActivationTime write FAccountActivationTime;

    {
     * Account closure time.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property AccountClosureTime: TGXDateTime read FAccountClosureTime write FAccountClosureTime;

    {
     * Currency.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property Currency: TGXCurrency read FCurrency;

    {
     * Low credit threshold.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property LowCreditThreshold: Integer read FLowCreditThreshold write FLowCreditThreshold;

    {
     * Next credit available threshold.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property NextCreditAvailableThreshold: Integer read FNextCreditAvailableThreshold write FNextCreditAvailableThreshold;

    {
     * Max Provision.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property MaxProvision: Integer read FMaxProvision write FMaxProvision;

    {
     * Max provision period.
     * Online help:
     * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSAccount
    }
    property MaxProvisionPeriod: Integer read FMaxProvisionPeriod write FMaxProvisionPeriod;

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

constructor TGXDLMSAccount.Create;
begin
  Create('0.0.19.0.0.255', 0);
end;

constructor TGXDLMSAccount.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSAccount.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otAccount, ln, sn);
  FCurrency := TGXCurrency.Create();
  FCreditReferences := TList<String>.Create;
  FChargeReferences := TList<String>.Create;
  FCreditChargeConfigurations := TObjectList<TGXCreditChargeConfiguration>.Create;
  FTokenGatewayConfigurations := TObjectList<TGXTokenGatewayConfiguration>.Create;
end;

destructor TGXDLMSAccount.Destroy;
begin
  inherited;
  FreeAndNil(FCreditReferences);
  FreeAndNil(FChargeReferences);
  FreeAndNil(FCreditChargeConfigurations);
  FreeAndNil(FTokenGatewayConfigurations);
  FreeAndNil(FAccountActivationTime);
  FreeAndNil(FAccountClosureTime);
  FreeAndNil(FCurrency);
end;

function TGXDLMSAccount.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName,
  TValue.From(TArray<TValue>.Create(Integer(FPaymentMode), Integer(FAccountStatus))),
  FCurrentCreditInUse,
  Integer(FCurrentCreditStatus), FAvailableCredit, FAmountToClear, FClearanceThreshold,
  FAggregatedDebt, FCreditReferences, FChargeReferences, FCreditChargeConfigurations,
  FTokenGatewayConfigurations, FAccountActivationTime, FAccountClosureTime,
  FCurrency, FLowCreditThreshold, FNextCreditAvailableThreshold, FMaxProvision,
  FMaxProvisionPeriod);
end;

function TGXDLMSAccount.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

     // PaymentMode, AccountStatus
    if CanRead(2) Then
        items.Add(2);

    // CurrentCreditInUse
    if CanRead(3) Then
        items.Add(3);

    // CurrentCreditStatus
    if CanRead(4) Then
        items.Add(4);

    // AvailableCredit
    if CanRead(5) Then
        items.Add(5);

    // AmountToClear
    if CanRead(6) Then
        items.Add(6);

    // ClearanceThreshold
    if CanRead(7) Then
        items.Add(7);

    // AggregatedDebt
    if CanRead(8) Then
        items.Add(8);

    // CreditReferences
    if CanRead(9) Then
        items.Add(9);

    // ChargeReferences
    if CanRead(10) Then
        items.Add(10);

    // CreditChargeConfigurations
    if CanRead(11) Then
        items.Add(11);

    // TokenGatewayConfigurations
    if CanRead(12) Then
        items.Add(12);

    // AccountActivationTime
    if CanRead(13) Then
        items.Add(13);

    // AccountClosureTime
    if CanRead(14) Then
        items.Add(14);

    // Currency
    if CanRead(15) Then
        items.Add(15);

    // LowCreditThreshold
    if CanRead(16) Then
        items.Add(16);

    // NextCreditAvailableThreshold
    if CanRead(17) Then
        items.Add(17);

    // MaxProvision
    if CanRead(18) Then
        items.Add(18);

    // MaxProvisionPeriod
    if CanRead(19) Then
        items.Add(19);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSAccount.GetAttributeCount: Integer;
begin
  Result := 19;
end;

function TGXDLMSAccount.GetMethodCount: Integer;
begin
  Result := 3;
end;

function TGXDLMSAccount.GetDataType(index: Integer): TDataType;
begin
 case index of
   1: Result := TDataType.dtOctetString;
   2: Result := TDataType.dtStructure;
   3: Result := TDataType.dtUint8;
   4: Result := TDataType.dtBitString;
   5: Result := TDataType.dtInt32;
   6: Result := TDataType.dtInt32;
   7: Result := TDataType.dtInt32;
   8: Result := TDataType.dtInt32;
   9: Result := TDataType.dtArray;
   10: Result := TDataType.dtArray;
   11: Result := TDataType.dtArray;
   12: Result := TDataType.dtArray;
   13: Result := TDataType.dtOctetString;
   14: Result := TDataType.dtOctetString;
   15: Result := TDataType.dtStructure;
   16: Result := TDataType.dtInt32;
   17: Result := TDataType.dtInt32;
   18: Result := TDataType.dtUInt16;
   19: Result := TDataType.dtInt32;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
 end;
end;

function TGXDLMSAccount.GetValue(e: TValueEventArgs): TValue;
var
  bb : TGXByteBuffer;
  index : Integer;
  str: string;
  it : TGXCreditChargeConfiguration;
  it2: TGXTokenGatewayConfiguration;
begin
  index := e.Index;
  case index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2:
    try
      bb:= TGXByteBuffer.Create();
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(2);
      bb.SetUInt8(Integer(TDataType.dtEnum));
      bb.SetUInt8(Integer(FAccountStatus));
      bb.SetUInt8(Integer(TDataType.dtEnum));
      bb.SetUInt8(Integer(FPaymentMode));
      Result:= TValue.From(bb.ToArray());
    finally
      FreeAndNil(bb);
    end;
  3: Result := FCurrentCreditInUse;
  4: Result := Byte(FCurrentCreditStatus);
  5: Result := FAvailableCredit;
  6: Result := FAmountToClear;
  7: Result := FClearanceThreshold;
  8: Result := FAggregatedDebt;
  9:
  try
    bb := TGXByteBuffer.Create();
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(FCreditReferences.Count, bb);
    for str in FCreditReferences do
    begin
      bb.SetUInt8(Integer(TDataType.dtOctetString));
      bb.SetUInt8(6);
      bb.SetArray(TGXDLMSObject.GetLogicalName(str));
    end;
    Result:= TValue.From(bb.ToArray());
   finally
      FreeAndNil(bb);
    end;
  10:
  try
    bb := TGXByteBuffer.Create();
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(FChargeReferences.Count, bb);
    for str in chargeReferences do
    begin
      bb.SetUInt8(Integer(TDataType.dtOctetString));
      bb.SetUInt8(6);
      bb.SetArray(TGXDLMSObject.GetLogicalName(str));
    end;
    Result:= TValue.From(bb.ToArray());
  finally
    FreeAndNil(bb);
  end;
  11:
  try
    bb := TGXByteBuffer.Create();
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(FCreditChargeConfigurations.Count, bb);
    for it in FCreditChargeConfigurations do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(3);
      bb.SetUInt8(Integer(TDataType.dtOctetString));
      bb.SetUInt8(6);
      bb.SetArray(TGXDLMSObject.GetLogicalName(it.CreditReference));
      bb.SetUInt8(Integer(TDataType.dtOctetString));
      bb.SetUInt8(6);
      bb.SetArray(TGXDLMSObject.GetLogicalName(it.ChargeReference));
      TGXCommon.SetData(bb, TDataType.dtBITSTRING, Integer(it.CollectionConfiguration));
    end;
    Result:= TValue.From(bb.ToArray());
  finally
    FreeAndNil(bb);
  end;
  12:
  try
    bb := TGXByteBuffer.Create();
    bb.SetUInt8(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(FTokenGatewayConfigurations.Count, bb);
    for it2 in FTokenGatewayConfigurations do
    begin
      bb.SetUInt8(Integer(TDataType.dtStructure));
      bb.SetUInt8(2);
      bb.SetUInt8(Integer(TDataType.dtOctetString));
      bb.SetUInt8(6);
      bb.SetArray(TGXDLMSObject.GetLogicalName(it2.CreditReference));
      bb.SetUInt8(Integer(TDataType.dtUINT8));
      bb.SetUInt8(it2.TokenProportion);
    end;
    Result:= TValue.From(bb.ToArray());
  finally
    FreeAndNil(bb);
  end;
  13: Result := FAccountActivationTime;
  14: Result := FAccountClosureTime;
  15:
  try
    bb := TGXByteBuffer.Create();
    bb.SetUInt8(Integer(TDataType.dtStructure));
    bb.SetUInt8(3);
    TGXCommon.SetData(bb, TDataType.dtStringUtf8, currency.Name);
    TGXCommon.SetData(bb, TDataType.dtInt8, currency.Scale);
    TGXCommon.SetData(bb, TDataType.dtEnum, Integer(currency.&Unit));
    Result:= TValue.From(bb.ToArray());
  finally
    FreeAndNil(bb);
  end;
  16: Result := FLowCreditThreshold;
  17: Result := FNextCreditAvailableThreshold;
  18: Result := FMaxProvision;
  19: Result := FMaxProvisionPeriod;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end
end;

procedure TGXDLMSAccount.SetValue(e: TValueEventArgs);
var
  it: TValue;
  item: TGXCreditChargeConfiguration;
  item2: TGXTokenGatewayConfiguration;
  bb: TGXByteBuffer;
begin
  case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2:
  begin
    FAccountStatus := TAccountStatus(e.Value.GetArrayElement(0).AsType<TValue>.AsInteger);
    FPaymentMode := TPaymentMode(e.Value.GetArrayElement(1).AsType<TValue>.AsInteger);
  end;
  3: FCurrentCreditInUse := Integer(e.Value.AsInteger);
  4:
  try
    bb := TGXByteBuffer.Create();
    TGXCommon.SetBitString(bb, e.Value);
    FCurrentCreditStatus := TAccountCreditStatus(bb.GetUInt8(1));
  finally
    FreeAndNil(bb);
  end;
  5: FAvailableCredit := e.Value.AsInteger;
  6: FAmountToClear := e.Value.AsInteger;
  7: FClearanceThreshold := e.Value.AsInteger;
  8: FAggregatedDebt := e.Value.AsInteger;
  9:
  begin
    FCreditReferences.Clear();
    if Not e.Value.IsEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
        FCreditReferences.Add(TGXCommon.ToLogicalName(it));
    end;
  end;
  10:
  begin
    FChargeReferences.Clear();
     if Not e.Value.IsEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
        FChargeReferences.Add(TGXDLMSObject.ToLogicalName(it.AsType<TBytes>));
    end;
  end;
  11:
  try
    FCreditChargeConfigurations.Clear();
    if Not e.Value.IsEmpty Then
    begin
      bb := TGXByteBuffer.Create();
      for it in e.Value.AsType<TArray<TValue>> do
      begin
        bb.Clear();
        item := TGXCreditChargeConfiguration.Create();
        item.CreditReference :=  TGXDLMSObject.ToLogicalName(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>);
        item.ChargeReference :=  TGXDLMSObject.ToLogicalName(it.GetArrayElement(1).AsType<TValue>.AsType<TBytes>);
        TGXCommon.SetBitString(bb, it.GetArrayElement(2).AsType<TValue>);
        item.CollectionConfiguration := TCreditCollectionConfiguration(bb.GetUInt8(1));
        FCreditChargeConfigurations.Add(item);
      end;
    end;
  finally
    FreeAndNil(bb);
  end;
  12:
  begin
  FTokenGatewayConfigurations.Clear();
  if Not e.Value.IsEmpty Then
    for it in e.Value.AsType<TArray<TValue>> do
    begin
      item2 := TGXTokenGatewayConfiguration.Create();
      item2.CreditReference := TGXDLMSObject.ToLogicalName(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>);
      item2.TokenProportion := it.GetArrayElement(1).AsType<TValue>.AsInteger;
      FTokenGatewayConfigurations.Add(item2);
    end;
  end;
  13:
  begin
    FreeAndNil(FAccountActivationTime);
    if e.Value.IsEmpty Then
    begin
      FAccountActivationTime := TGXDateTime.Create(TGXDateTime.MinDateTime);
    end
    else
    begin
      if e.Value.IsType<TBytes> Then
        e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
      FAccountActivationTime := e.Value.AsType<TGXDateTime>;
    end;
  end;
  14:
  begin
    FreeAndNil(FAccountClosureTime);
    if e.Value.IsEmpty Then
    begin
      FAccountClosureTime := TGXDateTime.Create(TGXDateTime.MinDateTime);
    end
    else
    begin
      if e.Value.IsType<TBytes> Then
        e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
      FAccountClosureTime := e.Value.AsType<TGXDateTime>;
    end;
  end;
  15:
  begin
    Currency.Name := e.Value.GetArrayElement(0).AsType<TValue>.AsString;
    Currency.Scale :=  e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
    Currency.&Unit := TCurrency(e.Value.GetArrayElement(2).AsType<TValue>.AsInteger);
  end;
  16: FLowCreditThreshold := e.Value.AsInteger;
  17: FNextCreditAvailableThreshold := e.Value.AsInteger;
  18: FMaxProvision := e.Value.AsInteger;
  19: FMaxProvisionPeriod :=  e.Value.AsInteger;
  else
      raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSAccount.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

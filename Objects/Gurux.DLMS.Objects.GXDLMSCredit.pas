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

unit Gurux.DLMS.Objects.GXDLMSCredit;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.CreditType, Gurux.DLMS.CreditConfiguration,
Gurux.DLMS.CreditStatus, Gurux.DLMS.GXDateTime, GXByteBuffer;

type
TGXDLMSCredit = class(TGXDLMSObject)
  // Current credit amount. Online help:<br>
  FCurrentCreditAmount: Integer;

  // Type. Online help:<br>
  FType: TCreditType;

  // Priority. Online help:<br>
  FPriority: Byte;

  // Warning threshold. Online help:<br>
  FWarningThreshold: Integer;

  // Limit. Online help:<br>
  FLimit: Integer;

  // Credit configuration. Online help:<br>
  FCreditConfiguration: TCreditConfiguration ;

  // Status. <br>
  FStatus: TCreditStatus;

  // Preset credit amount. <br>
  FPresetCreditAmount: Integer;

  // Credit available threshold.<br>
  FCreditAvailableThreshold: Integer;

  // Period.<br>
  FPeriod: TGXDateTime;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  destructor Destroy; override;

  {
   * Current credit amount. Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property CurrentCreditAmount: Integer read FCurrentCreditAmount write FCurrentCreditAmount;
  {
   * Type. Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property &Type: TCreditType read FType write FType;
  {
   * Priority. Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property Priority: Byte read FPriority write FPriority;
  {
   * Warning threshold. Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property WarningThreshold: Integer read FWarningThreshold write FWarningThreshold;

  {
   * Limit. Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property Limit: Integer read FLimit write FLimit;
  {
   * Credit configuration. Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property CreditConfiguration: TCreditConfiguration read FCreditConfiguration write FCreditConfiguration;
  {
   * Status. <br>
   * Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property Status: TCreditStatus read FStatus write FStatus;
  {
   * Preset credit amount. <br>
   * Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property PresetCreditAmount: Integer read FPresetCreditAmount write FPresetCreditAmount;
  {
   * Credit available threshold.<br>
   * Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property CreditAvailableThreshold: Integer read FCreditAvailableThreshold write FCreditAvailableThreshold;
  {
   * Period.<br>
   * Online help:<br>
   * http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCredit
   }
  property Period: TGXDateTime read FPeriod write FPeriod;


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

constructor TGXDLMSCredit.Create;
begin
  Create('0.0.19.10.0.255', 0);
end;

constructor TGXDLMSCredit.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSCredit.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otCredit, ln, sn);
end;

destructor TGXDLMSCredit.Destroy;
begin
  inherited;
  FreeAndNil(FPeriod);
end;

function TGXDLMSCredit.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FCurrentCreditAmount, Integer(FType),
  FPriority, FWarningThreshold, FLimit, Integer(FCreditConfiguration),
  Integer(FStatus), FPresetCreditAmount, FCreditAvailableThreshold, FPeriod);
end;

function TGXDLMSCredit.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //CurrentCreditAmount
    if All or CanRead(2) Then
      items.Add(2);
    //Type
    if All or CanRead(3) Then
      items.Add(3);
    //Priority
    if All or CanRead(4) Then
      items.Add(4);
    //WarningThreshold
    if All or CanRead(5) Then
      items.Add(5);
    //Limit
    if All or CanRead(6) Then
      items.Add(6);
    //creditConfiguration
    if All or CanRead(7) Then
      items.Add(7);
    //Status
    if All or CanRead(8) Then
      items.Add(8);
    //PresetCreditAmount
    if All or CanRead(9) Then
      items.Add(9);
    //CreditAvailableThreshold
    if All or CanRead(10) Then
      items.Add(10);
    //Period
    if All or CanRead(11) Then
      items.Add(11);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSCredit.GetAttributeCount: Integer;
begin
  Result := 11;
end;

function TGXDLMSCredit.GetMethodCount: Integer;
begin
  Result := 3;
end;

function TGXDLMSCredit.GetDataType(index: Integer): TDataType;
begin
 case index Of
  1: Result := TDataType.dtOctetString;
  2: Result := TDataType.dtInt32;
  3: Result := TDataType.dtEnum;
  4: Result := TDataType.dtUInt8;
  5: Result := TDataType.dtInt32;
  6: Result := TDataType.dtInt32;
  7: Result := TDataType.dtBitString;
  8: Result := TDataType.dtEnum;
  9: Result := TDataType.dtInt32;
  10: Result := TDataType.dtInt32;
  11: Result := TDataType.dtOctetString;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;
end;

function TGXDLMSCredit.GetValue(e: TValueEventArgs): TValue;
begin
  case e.Index Of
    1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
    2: Result := FCurrentCreditAmount;
    3: Result := Integer(FType);
    4: Result := FPriority;
    5: Result := FWarningThreshold;
    6:  Result := FLimit;
    7:  Result := Integer(FCreditConfiguration);
    8:  Result := Integer(FStatus);
    9:  Result := FPresetCreditAmount;
    10: Result := FCreditAvailableThreshold;
    11: Result := FPeriod;
    else
      raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSCredit.SetValue(e: TValueEventArgs);
var
  bb: TGXByteBuffer;
begin
  case e.Index Of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2: FCurrentCreditAmount := e.Value.AsInteger;
  3: FType := TCreditType(e.Value.AsInteger);
  4: FPriority := e.Value.AsInteger;
  5: FWarningThreshold := e.Value.AsInteger;
  6: FLimit := e.Value.AsInteger;
  7:
    begin
      bb := TGXByteBuffer.Create();
      try
        TGXCommon.SetBitString(bb, e.Value, True);
        FCreditConfiguration := TCreditConfiguration(bb.GetUInt8(1));
      finally
        FreeAndNil(bb);
      end;
    end;
  8: FStatus := TCreditStatus(e.Value.AsInteger);
  9: FPresetCreditAmount := e.Value.AsInteger;
  10: FCreditAvailableThreshold := e.Value.AsInteger;
  11:
    begin
      FreeAndNil(FPeriod);
      if e.Value.IsEmpty Then
        FPeriod := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
        begin
          if e.Value.IsType<TBytes> Then
            e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);

          FPeriod := e.Value.AsType<TGXDateTime>;
        end;
    end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSCredit.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSDemandRegister;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.TUnit, System.Math, GXByteBuffer;

type
TGXDLMSDemandRegister = class(TGXDLMSObject)
  FScaler : Integer;
  FLastAvarageValue, FCurrentAvarageValue: TValue;
  FUnit : TUnit;
  FPeriod, FNumberOfPeriods : Integer;
  FStatus : TValue;
  FCaptureTime, FStartTimeCurrent : TDateTime;
  function IsRead(index : Integer) : Boolean;override;
  function GetScaler : double;
  procedure SetScaler(value : double);

  destructor Destroy;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;

  public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  //Current avarage value of COSEM Data object.
  property CurrentAvarageValue: TValue read FCurrentAvarageValue write FCurrentAvarageValue;

  //Last avarage value of COSEM Data object.
  property LastAvarageValue:  TValue read FLastAvarageValue write FLastAvarageValue;

  // Scaler of COSEM Register object.
  property Scaler : double read GetScaler write SetScaler;

  // Unit of COSEM Register object.
  property &Unit : TUnit read FUnit write FUnit;

  // Provides Demand register specific status information.
  property Status: TValue read FStatus write FStatus;

  // Capture time of COSEM Register object.
  property CaptureTime: TDateTime read FCaptureTime write FCaptureTime;

  // Current start time of COSEM Register object.
  property StartTimeCurrent: TDateTime read FStartTimeCurrent write FStartTimeCurrent;


  // Period is the interval between two successive updates of the Last Average Value.
  // (NumberOfPeriods * Period is the denominator for the calculation of the demand).
  property Period: Integer read FPeriod write FPeriod;

  //The number of periods used to calculate the LastAvarageValue.
  // NumberOfPeriods >= 1 NumberOfPeriods > 1 indicates that the LastAvarageValue represents “sliding demand”.
  // NumberOfPeriods = 1 indicates that the LastAvarageValue represents "block demand".
  // The behaviour of the meter after writing a new value to this attribute shall be
  // specified by the manufacturer.
  property NumberOfPeriods: Integer read FNumberOfPeriods write FNumberOfPeriods;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
end;

implementation

constructor TGXDLMSDemandRegister.Create;
begin
  inherited Create(TObjectType.otDemandRegister);
end;

constructor TGXDLMSDemandRegister.Create(ln: string);
begin
  inherited Create(TObjectType.otDemandRegister, ln, 0);
end;

constructor TGXDLMSDemandRegister.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otDemandRegister, ln, 0);
end;

destructor TGXDLMSDemandRegister.Destroy;
begin
  inherited;
end;

function TGXDLMSDemandRegister.GetScaler : double;
begin
  Result := System.Math.Power(10, FScaler);
end;

procedure TGXDLMSDemandRegister.SetScaler(value : double);
begin
  FScaler := Round(System.Math.Log10(value));
end;

function TGXDLMSDemandRegister.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FCurrentAvarageValue,
    FLastAvarageValue,
    'Scaler: ' + FloatToStr(GetScaler()) + ' Unit: ' + TGXCommon.UnitToString(FUnit),
    FStatus, FCaptureTime, FStartTimeCurrent, FPeriod, FNumberOfPeriods);
end;

function TGXDLMSDemandRegister.IsRead(index : Integer) : Boolean;
begin
  if index = 3 Then
    Result := FUnit <> TUnit.utNone
  else
    Result := inherited IsRead(index);
end;

function TGXDLMSDemandRegister.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if string.IsNullOrEmpty(LogicalName) then
    items.Add(1);

   //ScalerUnit
  if Not IsRead(4) Then
    items.Add(4);

  //CurrentAvarageValue
  if CanRead(2) Then
    items.Add(2);

  //LastAvarageValue
  if CanRead(3) Then
    items.Add(3);

  //Status
  if CanRead(5) Then
    items.Add(5);

  //CaptureTime
  if CanRead(6) Then
    items.Add(6);

  //StartTimeCurrent
  if CanRead(7) Then
    items.Add(7);

  //Period
  if CanRead(8) Then
    items.Add(8);

  //NumberOfPeriods
  if CanRead(9) Then
    items.Add(9);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSDemandRegister.GetAttributeCount: Integer;
begin
  Result := 9;
end;

function TGXDLMSDemandRegister.GetMethodCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSDemandRegister.GetDataType(index: Integer): TDataType;
begin
  if index = 1 then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := inherited GetDataType(index);
  end
  else if index = 3 Then
  begin
    Result := inherited GetDataType(index);
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 5 Then
  begin
    Result := inherited GetDataType(index);
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else if index = 7 Then
  begin
    Result := TDataType.dtDateTime;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtUInt32;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSDemandRegister.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := FCurrentAvarageValue;
  end
  else if e.Index = 3 Then
  begin
    Result := FLastAvarageValue;
  end
  else if e.Index = 4 Then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtStructure));
    data.Add(2);
    TGXCommon.SetData(data, TDataType.dtUInt8, FScaler);
    TGXCommon.SetData(data, TDataType.dtUInt8, Integer(FUnit));
    Result := TValue.From(data.ToArray());
  end
  else if e.Index = 5 Then
  begin
    Result := Status;
  end
  else if e.Index = 6 Then
  begin
    Result := FCaptureTime;
  end
  else if e.Index = 7 Then
  begin
    Result := FStartTimeCurrent;
  end
  else if e.Index = 8 Then
  begin
    Result := FPeriod;
  end
  else if e.Index = 9 Then
  begin
    Result := FNumberOfPeriods;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSDemandRegister.SetValue(e: TValueEventArgs);
var
  tm : TGXDateTime;
begin
  if e.Index = 1 then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    if Scaler <> 1 Then
    begin
      try
        FCurrentAvarageValue := e.Value.AsCurrency * Scaler;
      except
      on Exception do
        begin
          FCurrentAvarageValue := e.Value;
        end;
      end;
    end
    else
    begin
      FCurrentAvarageValue := e.Value;
    end;
  end
  else if e.Index = 3 Then
  begin
    if Scaler <> 1 Then
    begin
      try
        FLastAvarageValue := e.Value.AsCurrency * Scaler;
      except
      on Exception do
        FLastAvarageValue := e.Value;
      end;
    end
    else
    begin
      FLastAvarageValue := e.Value;
    end;
  end
  else if e.Index = 4 Then
  begin
    if e.Value.IsEmpty Then
    begin
      FScaler := 1;
      FUnit := TUnit.utNone;
    end
    else
    begin
      if e.Value.GetArrayLength <> 2 Then
        raise Exception.Create('SetValue failed. Invalid scaler unit value.');

      FScaler := e.Value.GetArrayElement(0).AsType<TValue>.AsInteger;
      FUnit := TUnit(e.Value.GetArrayElement(1).AsType<TValue>.AsInteger);
    end;
  end
  else if e.Index = 5 Then
  begin
    FStatus := e.Value.AsInteger;
  end
  else if e.Index = 6 Then
  begin
    if e.Value.IsEmpty Then
    begin
      FCaptureTime := TGXDateTime.MinDateTime;
    end
    else
    begin
      if e.Value.IsType<TBytes> Then
      begin
        tm := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        e.Value := tm;
      end;
      FCaptureTime := e.Value.AsType<TGXDateTime>.Value;
      FreeAndNil(tm);
    end;
  end
  else if e.Index = 7 Then
  begin
    if e.Value.isEmpty Then
      FStartTimeCurrent := TGXDateTime.MinDateTime
    else
    begin
      if e.Value.IsType<TBytes> Then
      begin
        tm := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        e.Value := tm;
      end;
      FStartTimeCurrent := e.Value.AsType<TGXDateTime>.Value;
      FreeAndNil(tm);
    end;
  end
  else if e.Index = 8 Then
  begin
    FPeriod := e.Value.AsInteger;
  end
  else if e.Index = 9 Then
  begin
    FNumberOfPeriods := e.Value.AsInteger;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSDemandRegister.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

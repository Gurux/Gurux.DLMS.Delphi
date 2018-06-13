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

unit Gurux.DLMS.Objects.GXDLMSRegister;

interface

uses GXCommon, SysUtils, Rtti, System.Math, GXByteBuffer,
System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.TUnit, System.TypInfo;

type
TGXDLMSRegister = class(TGXDLMSObject)

  FUnit : TUnit;
  FScaler : Integer;
  FValue : TValue;
  protected
  function GetScaler : double;
  procedure SetScaler(value : double);
  function IsRead(index : Integer) : Boolean;override;

  public

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  //Scaler of COSEM Register object.
  property Scaler : double read GetScaler write SetScaler;

  //Unit of COSEM Register object.
  property &Unit : TUnit read FUnit write FUnit;

  property Value: TValue read FValue write FValue;

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

constructor TGXDLMSRegister.Create;
begin
  inherited Create(TObjectType.otRegister);
  FScaler := 0;
end;

constructor TGXDLMSRegister.Create(ln: string);
begin
  inherited Create(TObjectType.otRegister, ln, 0);
  FScaler := 0;
end;

constructor TGXDLMSRegister.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otRegister, ln, 0);
  FScaler := 0;
end;

destructor TGXDLMSRegister.Destroy;
begin
  inherited;
  if FValue.IsObject then
    FreeAndNil(FValue)
  else
    FValue := Nil;
end;

function TGXDLMSRegister.GetScaler : double;
begin
  Result := System.Math.Power(10, FScaler);
end;

procedure TGXDLMSRegister.SetScaler(value : double);
begin
  FScaler := Round(System.Math.Log10(value));
end;

function TGXDLMSRegister.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FValue,
  'Scaler: ' + FloatToStr(GetScaler()) + ' Unit: ' + TGXCommon.UnitToString(FUnit));
end;

function TGXDLMSRegister.IsRead(index : Integer) : Boolean;
begin
  if index = 3 Then
    Result := FUnit <> TUnit.utNone
  else
    Result := inherited IsRead(index);
end;

function TGXDLMSRegister.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //ScalerUnit
    if Not IsRead(3) then
      items.Add(3);

    //Value
    if CanRead(2) then
      items.Add(2);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSRegister.GetAttributeCount: Integer;
begin
  Result := 3;
end;

function TGXDLMSRegister.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSRegister.GetDataType(index: Integer): TDataType;
begin
 if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if (index = 2) then
  begin
    Result := inherited GetDataType(index);
  end
  else if index = 3 then
  begin
    Result := TDataType.dtArray;
  end
  else if (index = 4) and (ObjectType = TObjectType.otExtendedRegister) then
  begin
    Result := inherited GetDataType(index);
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSRegister.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  tmp: TBytes;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 then
  begin
    //If client set new value.
    if FScaler <> 0 Then
    begin
      Result := TValue.From(FValue.AsCurrency / Scaler);
    end
    else
      Result := TValue.From(FValue);
  end
  else if e.Index = 3 then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtStructure));
      data.Add(2);
      TGXCommon.SetData(data, TDataType.dtInt8, FScaler);
      TGXCommon.SetData(data, TDataType.dtEnum, Integer(FUnit));
      tmp := data.ToArray();
    finally
      data.Free;
    end;
    Result := TValue.From(tmp);
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSRegister.SetValue(e: TValueEventArgs);
var
  arr : TArray<TValue>;
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 then
  begin
    try
      if (FScaler <> 0) Then
        FValue := e.Value.AsCurrency * Self.Scaler
      else
        FValue := e.Value;
    except
      on ex: Exception do
      //Sometimes scaler is set for wrong Object type.
      FValue := e.Value;
    end;
  end
  else if e.Index = 3 then
  begin
    if e.Value.IsEmpty then
    begin
      FScaler := 1;
      FUnit := TUnit.utNone;
    end
    else
    begin
      arr := e.Value.AsType<TArray<TValue>>();
      if System.Length(arr) <> 2 then
        raise Exception.Create('SetValue failed. Invalid scaler unit value.');
      FScaler := arr[0].AsInteger;
      FUnit := TUnit(arr[1].AsInteger and $FF);
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSRegister.Invoke(e: TValueEventArgs): TBytes;
begin
  // Resets the value to the default value.
  // The default value is an instance specific constant.
  if e.Index = 1 then
    FValue := TValue.Empty
  else
    raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

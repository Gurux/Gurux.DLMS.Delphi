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

unit Gurux.DLMS.Objects.GXDLMSGprsSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
GXByteBuffer;

type

TGXDLMSQosElement = class
  FPrecedence, FDelay, FReliability, FPeakThroughput, FMeanThroughput : Byte;

  property Precedence: byte read FPrecedence write FPrecedence;

  property Delay : byte read FDelay write FDelay;
  property Reliability : byte read FReliability write FReliability;
  property PeakThroughput : byte read FPeakThroughput write FPeakThroughput;
  property MeanThroughput : byte read FMeanThroughput write FMeanThroughput;

end;

TGXDLMSGprsSetup = class(TGXDLMSObject)
  FAPN: string;
  FPINCode : LongWord;
  FDefaultQualityOfService : TGXDLMSQosElement;
  FRequestedQualityOfService: TGXDLMSQosElement;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property APN: string read FAPN write FAPN;

  property PINCode: LongWord read FPINCode write FPINCode;

  property DefaultQualityOfService: TGXDLMSQosElement read FDefaultQualityOfService write FDefaultQualityOfService;

  property RequestedQualityOfService: TGXDLMSQosElement read FDefaultQualityOfService write FDefaultQualityOfService;

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

constructor TGXDLMSGprsSetup.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSGprsSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSGprsSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otGprsSetup, ln, 0);
  FDefaultQualityOfService := TGXDLMSQosElement.Create();
  FRequestedQualityOfService := TGXDLMSQosElement.Create();
end;

destructor TGXDLMSGprsSetup.Destroy;
begin
  inherited;
  FreeAndNil(FDefaultQualityOfService);
  FreeAndNil(FRequestedQualityOfService);
end;

function TGXDLMSGprsSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FAPN, FPINCode,
                TValue.From(TArray<TValue>.Create(TValue.From(FDefaultQualityOfService),
                TValue.From(FRequestedQualityOfService))));
end;

function TGXDLMSGprsSetup.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //APN
  if Not IsRead(2) Then
    items.Add(2);

  //PINCode
  if Not IsRead(3) Then
    items.Add(3);

  //DefaultQualityOfService + RequestedQualityOfService
  if Not IsRead(4) Then
    items.Add(4);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSGprsSetup.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSGprsSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSGprsSetup.GetDataType(index: Integer): TDataType;
begin
 if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 3 then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 4 then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSGprsSetup.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 then
  begin
    Result := FAPN;
  end
  else if e.Index = 3 then
  begin
    Result := FPINCode;
  end
  else if e.Index = 4 then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtStructure));
    //Add count
    data.Add(2);
    data.Add(Integer(TDataType.dtStructure));
    data.Add(5);
    if FDefaultQualityOfService <> Nil Then
    begin
      TGXCommon.SetData(data, TDataType.dtUInt8, DefaultQualityOfService.Precedence);
      TGXCommon.SetData(data, TDataType.dtUInt8, DefaultQualityOfService.Delay);
      TGXCommon.SetData(data, TDataType.dtUInt8, DefaultQualityOfService.Reliability);
      TGXCommon.SetData(data, TDataType.dtUInt8, DefaultQualityOfService.PeakThroughput);
      TGXCommon.SetData(data, TDataType.dtUInt8, DefaultQualityOfService.MeanThroughput);
    end
    else
    begin
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
    end;
    if FRequestedQualityOfService <> Nil Then
    begin
      TGXCommon.SetData(data, TDataType.dtUInt8, RequestedQualityOfService.Precedence);
      TGXCommon.SetData(data, TDataType.dtUInt8, RequestedQualityOfService.Delay);
      TGXCommon.SetData(data, TDataType.dtUInt8, RequestedQualityOfService.Reliability);
      TGXCommon.SetData(data, TDataType.dtUInt8, RequestedQualityOfService.PeakThroughput);
      TGXCommon.SetData(data, TDataType.dtUInt8, RequestedQualityOfService.MeanThroughput);
    end
    else
    begin
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
      TGXCommon.SetData(data, TDataType.dtUInt8, 0);
    end;
    Result := TValue.From(data.ToArray());
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSGprsSetup.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    if e.Value.IsType<string> Then
      FAPN := e.Value.ToString()
    else
      FAPN := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString();

  end
  else if e.Index = 3 Then
  begin
    FPINCode := e.Value.AsInteger;
  end
  else if e.Index = 4 Then
  begin
    DefaultQualityOfService.Precedence := 0;
    FDefaultQualityOfService.Delay := 0;
    FDefaultQualityOfService.Reliability := 0;
    FDefaultQualityOfService.PeakThroughput := 0;
    FDefaultQualityOfService.MeanThroughput := 0;
    RequestedQualityOfService.Precedence := 0;
    FRequestedQualityOfService.Delay := 0;
    FRequestedQualityOfService.Reliability := 0;
    FRequestedQualityOfService.PeakThroughput := 0;
    FRequestedQualityOfService.MeanThroughput := 0;
    if Not e.Value.IsEmpty Then
    begin
      DefaultQualityOfService.Precedence := e.Value.GetArrayElement(0).AsType<TValue>.GetArrayElement(0).AsType<TValue>.AsInteger;
      DefaultQualityOfService.Delay := e.Value.GetArrayElement(0).AsType<TValue>.GetArrayElement(1).AsType<TValue>.AsInteger;
      DefaultQualityOfService.Reliability := e.Value.GetArrayElement(0).AsType<TValue>.GetArrayElement(2).AsType<TValue>.AsInteger;
      DefaultQualityOfService.PeakThroughput := e.Value.GetArrayElement(0).AsType<TValue>.GetArrayElement(3).AsType<TValue>.AsInteger;
      DefaultQualityOfService.MeanThroughput := e.Value.GetArrayElement(0).AsType<TValue>.GetArrayElement(4).AsType<TValue>.AsInteger;
      RequestedQualityOfService.Precedence := e.Value.GetArrayElement(1).AsType<TValue>.GetArrayElement(0).AsType<TValue>.AsInteger;
      RequestedQualityOfService.Delay := e.Value.GetArrayElement(1).AsType<TValue>.GetArrayElement(1).AsType<TValue>.AsInteger;
      RequestedQualityOfService.Reliability := e.Value.GetArrayElement(1).AsType<TValue>.GetArrayElement(2).AsType<TValue>.AsInteger;
      RequestedQualityOfService.PeakThroughput := e.Value.GetArrayElement(1).AsType<TValue>.GetArrayElement(3).AsType<TValue>.AsInteger;
      RequestedQualityOfService.MeanThroughput := e.Value.GetArrayElement(1).AsType<TValue>.GetArrayElement(4).AsType<TValue>.AsInteger;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSGprsSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

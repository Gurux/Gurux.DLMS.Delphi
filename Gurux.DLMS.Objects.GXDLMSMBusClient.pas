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

unit Gurux.DLMS.Objects.GXDLMSMBusClient;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSMBusClient = class(TGXDLMSObject)
  private
  FMBusPortReference: string;
  FCaptureDefinition : TList<TPair<string, string>>;
  FCapturePeriod, FIdentificationNumber : UInt32;
  FPrimaryAddress, FDataHeaderVersion, FDeviceType, FAccessNumber,
  FStatus, FAlarm : Integer;
  FManufacturerID: UInt16;

  public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Provides reference to an “M-Bus master port setup” object, used to configure
  // an M-Bus port, each interface allowing to exchange data with one or more
  // M-Bus slave devices
  property MBusPortReference: string read FMBusPortReference write FMBusPortReference;

  property CaptureDefinition: TList<TPair<string, string>> read FCaptureDefinition;

  property CapturePeriod: UInt32 read FCapturePeriod write FCapturePeriod;

  property PrimaryAddress: Integer read FPrimaryAddress write FPrimaryAddress;

  property IdentificationNumber: UInt32 read FIdentificationNumber write FIdentificationNumber;

  property ManufacturerID: UInt16 read FManufacturerID write FManufacturerID;

  // Carries the Version element of the data header as specified in
  // EN 13757-3 sub-clause 5.6.
  property DataHeaderVersion: Integer read FDataHeaderVersion write FDataHeaderVersion;

  property DeviceType: Integer read FDeviceType write FDeviceType;

  property AccessNumber: Integer read FAccessNumber write FAccessNumber;

  property Status: Integer read FStatus write FStatus;

  property Alarm: Integer read FAlarm write FAlarm;

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

constructor TGXDLMSMBusClient.Create;
begin
  inherited Create(TObjectType.otMBusClient);
  FCaptureDefinition := TList<TPair<string, string>>.Create();
end;

constructor TGXDLMSMBusClient.Create(ln: string);
begin
  inherited Create(TObjectType.otMBusClient, ln, 0);
  FCaptureDefinition := TList<TPair<string, string>>.Create();
end;

constructor TGXDLMSMBusClient.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otMBusClient, ln, 0);
  FCaptureDefinition := TList<TPair<string, string>>.Create();
end;

destructor TGXDLMSMBusClient.Destroy;
begin
  inherited;
  FreeAndNil(FCaptureDefinition);
end;

function TGXDLMSMBusClient.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FMBusPortReference,
            FCaptureDefinition, FCapturePeriod,
            FPrimaryAddress, FIdentificationNumber, FManufacturerID, FDataHeaderVersion, DeviceType, AccessNumber,
            FStatus, FAlarm);
end;

function TGXDLMSMBusClient.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //MBusPortReference
    if CanRead(2) Then
      items.Add(2);

    //CaptureDefinition
    if CanRead(3) Then
      items.Add(3);

    //CapturePeriod
    if CanRead(4) Then
      items.Add(4);

    //PrimaryAddress
    if CanRead(5) Then
      items.Add(5);

    //IdentificationNumber
    if CanRead(6) Then
      items.Add(6);

    //ManufacturerID
    if CanRead(7) Then
      items.Add(7);

    //Version
    if CanRead(8) Then
      items.Add(8);

    //DeviceType
    if CanRead(9) Then
      items.Add(9);

    //AccessNumber
    if CanRead(10) Then
      items.Add(10);

    //Status
    if CanRead(11) Then
      items.Add(11);

    //Alarm
    if CanRead(12) Then
      items.Add(12);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSMBusClient.GetAttributeCount: Integer;
begin
  Result := 12;
end;

function TGXDLMSMBusClient.GetMethodCount: Integer;
begin
  Result := 8;
end;

function TGXDLMSMBusClient.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtUInt32;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtUInt32;
  end
  else if index = 7 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 10 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 11 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 12 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSMBusClient.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(MBusPortReference));
  end
  else if e.Index = 3 Then
  begin
    Result := CaptureDefinition;//TODO:
  end
  else if e.Index = 4 Then
  begin
    Result := CapturePeriod;
  end
  else if e.Index = 5 Then
  begin
    Result := PrimaryAddress;
  end
  else if e.Index = 6 Then
  begin
    Result := IdentificationNumber;
  end
  else if e.Index = 7 Then
  begin
    Result := ManufacturerID;
  end
  else if e.Index = 8 Then
  begin
    Result := DataHeaderVersion;
  end
  else if e.Index = 9 Then
  begin
    Result := DeviceType;
  end
  else if e.Index = 10 Then
  begin
    Result := AccessNumber;
  end
  else if e.Index = 11 Then
  begin
    Result := Status;
  end
  else if e.Index = 12 Then
  begin
    Result := Alarm;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSMBusClient.SetValue(e: TValueEventArgs);
var
  it : TValue;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    if e.Value.IsType<string> Then
    begin
        FMBusPortReference := e.Value.ToString();
    end
    else
    begin
        FMBusPortReference := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtOctetString).ToString();
    end;
  end
  else if e.Index = 3 Then
  begin
    FCaptureDefinition.Clear();
    for it in e.Value.AsType<TArray<TValue>> do
    begin
      FCaptureDefinition.Add(TPair<string, string>.Create(TGXCommon.ChangeType(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtOctetString).ToString(),
          TGXCommon.ChangeType(it.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtOctetString).ToString()));
    end;
  end
  else if e.Index = 4 Then
  begin
    FCapturePeriod := e.Value.AsInteger;
  end
  else if e.Index = 5 Then
  begin
    FPrimaryAddress := e.Value.AsInteger;
  end
  else if e.Index = 6 Then
  begin
    FIdentificationNumber := e.Value.AsInteger;
  end
  else if e.Index = 7 Then
  begin
    FManufacturerID := e.Value.AsInteger;
  end
  else if e.Index = 8 Then
  begin
    FDataHeaderVersion := e.Value.AsInteger;
  end
  else if e.Index = 9 Then
  begin
    FDeviceType := e.Value.AsInteger;
  end
  else if e.Index = 10 Then
  begin
    FAccessNumber := e.Value.AsInteger;
  end
  else if e.Index = 11 Then
  begin
    FStatus := e.Value.AsInteger;
  end
  else if e.Index = 12 Then
  begin
    FAlarm := e.Value.AsInteger;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSMBusClient.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

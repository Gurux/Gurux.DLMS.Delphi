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

unit Gurux.DLMS.Objects.GXDLMSIECOpticalPortSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.OpticalProtocolMode, Gurux.DLMS.BaudRate, Gurux.DLMS.LocalPortResponseTime;

type

TGXDLMSIECOpticalPortSetup = class(TGXDLMSObject)
  FDefaultMode: TOpticalProtocolMode;
  FProposedBaudrate, FDefaultBaudrate : TBaudRate;
  FResponseTime : TLocalPortResponseTime;
  FPassword1, FPassword2, FPassword5, FDeviceAddress: string;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  //Start communication mode.
  property DefaultMode: TOpticalProtocolMode read FDefaultMode write FDefaultMode;

  //Default Baudrate.
  property DefaultBaudrate: TBaudRate read FDefaultBaudrate write FDefaultBaudrate;

  //Default Baudrate.
  property ProposedBaudrate: TBaudRate read FProposedBaudrate write FProposedBaudrate;


  // Defines the minimum time between the reception of a request
  // (end of request telegram) and the transmission of the response (begin of response telegram).
  property ResponseTime: TLocalPortResponseTime read FResponseTime write FResponseTime;


  /// Device address according to IEC 62056-21.
  property DeviceAddress: string read FDeviceAddress write FDeviceAddress;


  /// Password 1 according to IEC 62056-21.
  property Password1: string read FPassword1 write FPassword1;

  /// Password 2 according to IEC 62056-21.
  property Password2: string read FPassword2 write FPassword2;

  /// Password W5 reserved for national applications.
  property Password5: string read FPassword5 write FPassword5;

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

constructor TGXDLMSIECOpticalPortSetup.Create;
begin
  inherited Create(TObjectType.otIecLocalPortSetup);
end;

constructor TGXDLMSIECOpticalPortSetup.Create(ln: string);
begin
  inherited Create(TObjectType.otIecLocalPortSetup, ln, 0);
end;

constructor TGXDLMSIECOpticalPortSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otIecLocalPortSetup, ln, 0);
end;

function TGXDLMSIECOpticalPortSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FDefaultMode), Integer(FDefaultBaudrate),
                Integer(FProposedBaudrate), Integer(FResponseTime), FDeviceAddress,
                FPassword1, FPassword2, FPassword5);
end;

function TGXDLMSIECOpticalPortSetup.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //DefaultMode
    if Not IsRead(2) Then
      items.Add(2);

    //DefaultBaudrate
    if Not IsRead(3) Then
      items.Add(3);

    //ProposedBaudrate
    if Not IsRead(4) Then
      items.Add(4);

    //ResponseTime
    if Not IsRead(5) Then
      items.Add(5);

    //DeviceAddress
    if Not IsRead(6) Then
      items.Add(6);

    //Password1
    if Not IsRead(7) Then
      items.Add(7);

    //Password2
    if Not IsRead(8) Then
      items.Add(8);

    //Password5
    if Not IsRead(9) Then
      items.Add(9);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSIECOpticalPortSetup.GetAttributeCount: Integer;
begin
  Result := 9;
end;

function TGXDLMSIECOpticalPortSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSIECOpticalPortSetup.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 7 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSIECOpticalPortSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(FDefaultMode);
  end
  else if e.Index = 3 Then
  begin
    Result := Integer(FDefaultBaudrate);
  end
  else if e.Index = 4 Then
  begin
    Result := Integer(FProposedBaudrate);
  end
  else if e.Index = 5 Then
  begin
    Result := Integer(FResponseTime);
  end
  else if e.Index = 6 Then
  begin
    Result := TValue.From(TGXCommon.GetBytes(DeviceAddress));
  end
  else if e.Index = 7 Then
  begin
    Result := TValue.From(TGXCommon.GetBytes(Password1));
  end
  else if e.Index = 8 Then
  begin
    Result := TValue.From(TGXCommon.GetBytes(Password2));
  end
  else if e.Index = 9 Then
  begin
    Result := TValue.From(TGXCommon.GetBytes(Password5));
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSIECOpticalPortSetup.SetValue(e: TValueEventArgs);
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FDefaultMode := TOpticalProtocolMode(e.Value.AsInteger);
  end
  else if e.Index = 3 Then
  begin
    FDefaultBaudrate := TBaudRate(e.Value.AsInteger);
  end
  else if e.Index = 4 Then
  begin
    FProposedBaudrate := TBaudRate(e.Value.AsInteger);
  end
  else if e.Index = 5 Then
  begin
    FResponseTime := TLocalPortResponseTime(e.Value.AsInteger);
  end
  else if e.Index = 6 Then
  begin
    if e.Value.isType<TBytes> Then
      FDeviceAddress := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString()
    else
      FDeviceAddress := e.Value.ToString;
  end
  else if e.Index = 7 Then
  begin
    if e.Value.isType<TBytes> Then
      FPassword1 := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString()
    else
      FPassword1 := e.Value.ToString;
  end
  else if e.Index = 8 Then
  begin
    if e.Value.isType<TBytes> Then
      Password2 := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString()
    else
      Password2 := e.Value.ToString;
  end
  else if e.Index = 9 Then
  begin
    if e.Value.isType<TBytes> Then
      FPassword5 := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtString).ToString()
    else
      FPassword5 := e.Value.ToString;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSIECOpticalPortSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSPppSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject, GXByteBuffer,
Gurux.DLMS.GXDLMSConverter;

type

TGXDLMSPppSetupPppAuthenticationType =
(
  // No authentication.
  None = 0,
  // PAP Login
  PAP = 1,
  // CHAP-algorithm
  CHAP = 2
);

TGXDLMSPppSetupLcpOptionType =
(
  MaxRecUnit = 1,
  AsyncControlCharMap = 2,
  AuthProtocol = 3,
  MagicNumber = 5,
  ProtocolFieldCompression = 7,
  AddressAndCtrCompression = 8,
  FCSAlternatives = 9,
  Callback = 13
);

TGXDLMSPppSetupLcpOption = class
  FType : TGXDLMSPppSetupLcpOptionType;
  FLength : Integer;
  FData : TValue;

public
  property &Type: TGXDLMSPppSetupLcpOptionType read FType write FType;
  property Length: Integer read FLength write FLength;
  property Data: TValue read FData write FData;
  function ToString: string; override;
end;

TGXDLMSPppSetupIPCPOptionType =
(
  IPCompressionProtocol = 2,
  PrefLocalIP = 3,
  PrefPeerIP = 20,
  GAO = 21,
  USIP = 22
);

TGXDLMSPppSetupIPCPOption = class
  FType : TGXDLMSPppSetupIPCPOptionType;
  FLength : Integer;
  FData : TValue;

public
  property &Type: TGXDLMSPppSetupIPCPOptionType read FType write FType;
  property Length: Integer read FLength write FLength;
  property Data: TValue read FData write FData;
  function ToString: string; override;
end;

TGXDLMSPppSetup = class(TGXDLMSObject)
  FPHYReference: string;
  FLCPOptions : TObjectList<TGXDLMSPppSetupLcpOption>;
  FIPCPOptions : TObjectList<TGXDLMSPppSetupIPCPOption>;
  FUserName, FPassword : TBytes;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property PHYReference: string read FPHYReference write FPHYReference;

  property LCPOptions: TObjectList<TGXDLMSPppSetupLcpOption> read FLCPOptions;

  property IPCPOptions: TObjectList<TGXDLMSPppSetupIPCPOption> read FIPCPOptions;

  // PPP authentication procedure user name.
  property UserName: TBytes read FUserName write FUserName;

  // PPP authentication procedure password.
  property Password: TBytes read FPassword write FPassword;

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

function TGXDLMSPppSetupLcpOption.ToString: string;
begin
  case FType of
    MaxRecUnit: Result := 'MaxRecUnit';
    AsyncControlCharMap: Result := 'AsyncControlCharMap';
    AuthProtocol: Result := 'AuthProtocol';
    MagicNumber: Result := 'MagicNumber';
    ProtocolFieldCompression: Result := 'ProtocolFieldCompression';
    AddressAndCtrCompression: Result := 'AddressAndCtrCompression';
    FCSAlternatives: Result := 'FCSAlternatives';
    Callback: Result := 'Callback';
  end;
  Result := Result + ' ' + FData.ToString();
end;

function TGXDLMSPppSetupIPCPOption.ToString: string;
begin
  case FType of
    IPCompressionProtocol: Result := 'IPCompressionProtocol';
    PrefLocalIP: Result := 'PrefLocalIP';
    PrefPeerIP: Result := 'PrefPeerIP';
    GAO: Result := 'GAO';
    USIP: Result := 'USIP';
  end;
//FType : TGXDLMSPppSetupIPCPOptionType;
//  FLength : Integer;
//  FData : TValue;
end;

constructor TGXDLMSPppSetup.Create;
begin
  inherited Create(TObjectType.otPppSetup);
  FLCPOptions := TObjectList<TGXDLMSPppSetupLcpOption>.Create;
  FIPCPOptions := TObjectList<TGXDLMSPppSetupIPCPOption>.Create;
end;

constructor TGXDLMSPppSetup.Create(ln: string);
begin
  inherited Create(TObjectType.otPppSetup, ln, 0);
  FLCPOptions := TObjectList<TGXDLMSPppSetupLcpOption>.Create;
  FIPCPOptions := TObjectList<TGXDLMSPppSetupIPCPOption>.Create;
end;

constructor TGXDLMSPppSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPppSetup, ln, 0);
  FLCPOptions := TObjectList<TGXDLMSPppSetupLcpOption>.Create;
  FIPCPOptions := TObjectList<TGXDLMSPppSetupIPCPOption>.Create;
end;

destructor TGXDLMSPppSetup.Destroy;
begin
  inherited;
  FreeAndNil(FLCPOptions);
  FreeAndNil(FIPCPOptions);
end;

function TGXDLMSPppSetup.GetValues() : TArray<TValue>;
var
  str : string;
begin
  str := '';
  if FUserName <> Nil then
    str := TEncoding.ASCII.GetString(FUserName);

  if FPassword <> Nil then
    str := str + ' ' + TEncoding.ASCII.GetString(FPassword);

  Result := TArray<TValue>.Create(FLogicalName, FPHYReference, TValue.From(FLCPOptions),
      TValue.From(FIPCPOptions), str);
end;

function TGXDLMSPppSetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //PHYReference
    if All or Not IsRead(2) Then
      items.Add(2);
    //LCPOptions
    if All or Not IsRead(3) Then
      items.Add(3);
    //IPCPOptions
    if All or Not IsRead(4) Then
      items.Add(4);
    //PPPAuthentication
    if All or Not IsRead(5) Then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSPppSetup.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSPppSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSPppSetup.GetDataType(index: Integer): TDataType;
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
    Result := TDataType.dtArray;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSPppSetup.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  lcp : TGXDLMSPppSetupLcpOption;
  ipc : TGXDLMSPppSetupIPCPOption;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FPHYReference));
  end
  else if e.Index = 3 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      data.Add(FIPCPOptions.Count);
      for lcp in FLCPOptions do
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(3);
        TGXCommon.SetData(data, TDataType.dtUInt8, Integer(lcp.&Type));
        TGXCommon.SetData(data, TDataType.dtUInt8, lcp.Length);
        TGXCommon.SetData(data, TGXDLMSConverter.GetDLMSDataType(lcp.Data), lcp.Data);
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 4 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      data.Add(FIPCPOptions.Count);
      for ipc in FIPCPOptions do
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(3);
        TGXCommon.SetData(data, TDataType.dtUInt8, Integer(ipc.&Type));
        TGXCommon.SetData(data, TDataType.dtUInt8, ipc.Length);
        TGXCommon.SetData(data, TGXDLMSConverter.GetDLMSDataType(ipc.Data), ipc.Data);
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 5 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtStructure));
      data.SetUInt8(2);
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(FUserName));
      TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(FPassword));
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSPppSetup.SetValue(e: TValueEventArgs);
var
  item : TValue;
  lcp : TGXDLMSPppSetupLcpOption;
  ipc : TGXDLMSPppSetupIPCPOption;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    PHYReference := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 3 Then
  begin
    FLCPOptions.Clear;
    if e.Value.IsType<TArray<TValue>> Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        lcp := TGXDLMSPppSetupLcpOption.Create();
        try
          lcp.&Type := TGXDLMSPppSetupLcpOptionType(item.GetArrayElement(0).AsType<TValue>.AsInteger);
          lcp.Length := item.GetArrayElement(1).AsType<TValue>.AsInteger;
          lcp.Data := item.GetArrayElement(2).AsType<TValue>;
        except
          lcp.Free;
          raise;
        end;
        FLCPOptions.Add(lcp);
      end
    end;
  end
  else if e.Index = 4 Then
  begin
    FIPCPOptions.Clear;
    if e.Value.IsType<TArray<TValue>> Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        ipc := TGXDLMSPppSetupIPCPOption.Create();
        try
          ipc.&Type := TGXDLMSPppSetupIPCPOptionType(item.GetArrayElement(0).AsType<TValue>.AsInteger);
          ipc.Length := item.GetArrayElement(1).AsType<TValue>.AsInteger;
          ipc.Data := item.GetArrayElement(2).AsType<TValue>;
        except
          ipc.Free;
          raise;
        end;
        FIPCPOptions.Add(ipc);
      end
    end;
  end
  else if e.Index = 5 Then
  begin
    if e.Value.IsEmpty then
    begin
      FUserName := Nil;
      FPassword := Nil;
    end
    else
    begin
      FUserName := e.Value.GetArrayElement(0).AsType<TValue>.AsType<TBytes>;
      FPassword := e.Value.GetArrayElement(1).AsType<TValue>.AsType<TBytes>;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSPppSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

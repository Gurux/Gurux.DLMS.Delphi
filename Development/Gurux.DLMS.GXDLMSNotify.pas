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

unit Gurux.DLMS.GXDLMSNotify;

interface

uses SysUtils,
GXByteBuffer,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Authentication,
Gurux.DLMS.InterfaceType,
Gurux.DLMS.Objects.GXDLMSPushSetup,
Gurux.DLMS.DataType;

type
 TGXDLMSNotify = class
 protected
    FSettings: TGXDLMSSettings;

    // Generates data notification message(s).
    function GenerateDataNotificationMessages(time: TGXDateTime; data: TGXByteBuffer) : TArray<TBytes>;
    function get_Authentication: TAuthentication;
    function get_InterfaceType: TInterfaceType;
    function get_ClientAddress: Integer;
    function get_ServerAddress: Integer;
    procedure set_Authentication(Value: TAuthentication);
    procedure set_InterfaceType(Value: TInterfaceType);
    procedure set_ClientAddress(Value: Integer);
    procedure set_ServerAddress(Value: Integer);
    function get_UseLogicalNameReferencing: Boolean;
    procedure set_UseLogicalNameReferencing(Value: Boolean);
 public
    property Authentication: TAuthentication read get_Authentication write set_Authentication;
    property InterfaceType: TInterfaceType read get_InterfaceType write set_InterfaceType;
    property ClientAddress : Integer read get_ClientAddress write set_ClientAddress;
    property ServerAddress : Integer read get_ServerAddress write set_ServerAddress;
    property UseLogicalNameReferencing: Boolean read get_UseLogicalNameReferencing write set_UseLogicalNameReferencing default False;

  destructor Destroy; override;

  constructor Create(
        //Is Logical or short name referencing used.
        UseLogicalNameReferencing : Boolean;
        //Client ID. Default is 0x10
				ClientAddress : Integer;
        //Server ID. Default is 1.
				ServerAddress : Integer;
	      //Interface type. Default is general.
				interfaceType : TInterfaceType);overload;

  // Generates push setup message.
  // date: Date time. Set to Nil if not added.
  // push: Target Push object.
  // Returns Generated data notification message(s).
  function GeneratePushSetupMessages(date: TGXDateTime; push: TGXDLMSPushSetup) : TArray<TBytes>;

end;
implementation

uses GXCommon, Rtti,
Gurux.DLMS.Conformance,
Gurux.DLMS.GXDLMS,
Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSConverter,
Gurux.DLMS.GXDLMSLNParameters,
Gurux.DLMS.GXDLMSSNParameters,
Gurux.DLMS.GXDLMSCaptureObject;

constructor TGXDLMSNotify.Create(
    UseLogicalNameReferencing : Boolean;
    //Client ID. Default is 0x10
    ClientAddress : Integer;
    //Server ID. Default is 1.
    ServerAddress : Integer;
    //Interface type. Default is general.
    interfaceType : TInterfaceType);
begin
  Create;
  FSettings := TGXDLMSSettings.Create(true, interfaceType);
  Self.UseLogicalNameReferencing := UseLogicalNameReferencing;
  Self.ClientAddress := ClientAddress;
  Self.ServerAddress := ServerAddress;
  Self.Authentication := Authentication;
end;

destructor TGXDLMSNotify.Destroy;
begin
  FreeAndNil(FSettings);
  inherited;
end;
 function TGXDLMSNotify.get_Authentication: TAuthentication;
begin
  Result := FSettings.Authentication;
end;

function TGXDLMSNotify.get_InterfaceType: TInterfaceType;
begin
  Result := FSettings.InterfaceType;
end;

procedure TGXDLMSNotify.set_Authentication(Value: TAuthentication);
begin
  FSettings.Authentication := value;
end;

procedure TGXDLMSNotify.set_InterfaceType(Value: TInterfaceType);
begin
  FSettings.InterfaceType := value;
end;

function TGXDLMSNotify.get_ClientAddress: Integer;
begin
  Result := FSettings.ClientAddress;
end;

function TGXDLMSNotify.get_ServerAddress: Integer;
begin
  Result := FSettings.ServerAddress;
end;

function TGXDLMSNotify.get_UseLogicalNameReferencing: Boolean;
begin
  Result := FSettings.UseLogicalNameReferencing;
end;

procedure TGXDLMSNotify.set_UseLogicalNameReferencing(Value: Boolean);
begin
  FSettings.UseLogicalNameReferencing := value;
end;

procedure TGXDLMSNotify.set_ClientAddress(Value: Integer);
begin
  FSettings.ClientAddress := value;
end;

procedure TGXDLMSNotify.set_ServerAddress(Value: Integer);
begin
  FSettings.ServerAddress := value;
end;

// Add value of COSEM object to byte buffer.
procedure AddData(settings: TGXDLMSSettings; obj: TGXDLMSObject; index: Integer; buff: TGXByteBuffer);
var
  dt: TDataType;
  value : TValue;
  va: TValueEventArgs;
begin
  va:= TValueEventArgs.Create(settings, obj, index, 0, Nil);
  try
    value := obj.GetValue(va);
    dt := obj.GetDataType(index);
    if (dt = TDataType.dtNone) and (not value.IsEmpty) Then
    begin
        dt := TGXDLMSConverter.GetDLMSDataType(value);
    end;
    TGXCommon.SetData(buff, dt, value);
  finally
    FreeAndNil(va);
  end;
end;
// Generates data notification message(s).
function TGXDLMSNotify.GenerateDataNotificationMessages(time: TGXDateTime; data: TGXByteBuffer) : TArray<TBytes>;
var
  ln: TGXDLMSLNParameters;
  sn: TGXDLMSSNParameters;
begin
   if UseLogicalNameReferencing Then
  begin
    try
    ln := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.DataNotification, 0, Nil, data, $ff, TCommand.None);
      ln.time := time;
      Result := TGXDLMS.GetLnMessages(ln);
    finally
      FreeAndNil(ln);
    end;
  end
  else
  begin
    try
      sn := TGXDLMSSNParameters.Create(FSettings, TCommand.DataNotification, 1, 0, data, Nil);
      Result := TGXDLMS.GetSnMessages(sn);
    finally
      FreeAndNil(sn);
    end;
  end;
  if ((Integer(FSettings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer)) = 0) and (Length(Result) <> 1) Then
  begin
      raise EArgumentException.Create('Data is not fit to one PDU. Use general block transfer.');
  end;
end;

function TGXDLMSNotify.GeneratePushSetupMessages(date: TGXDateTime; push: TGXDLMSPushSetup) : TArray<TBytes>;
var
  buff: TGXByteBuffer;
  it : TGXDLMSCaptureObject;
  index, count: Integer;
begin
  if push = Nil Then
  begin
    raise EArgumentException.Create('Push parameter is null.');
  end;
  buff := TGXByteBuffer.Create;
  try
   buff.SetUInt8(Integer(TDataType.dtStructure));
  TGXCommon.SetObjectCount(push.PushObjectList.Count, buff);
  for it in push.PushObjectList do
  begin
    if it.AttributeIndex = 0 Then
    begin
      buff.SetUInt8(Integer(TDataType.dtStructure));
      count := it.Target.GetAttributeCount();
      TGXCommon.SetObjectCount(count, buff);
      index := 1;
      while(index <= count) do
      begin
          AddData(FSettings, it.Target, index, buff);
          index := index + 1;
      end;
    end
    else
    begin
        AddData(FSettings, it.Target, it.AttributeIndex, buff);
    end;
  end;
  Result := GenerateDataNotificationMessages(date, buff);
  finally
     FreeAndNil(buff);
  end;
end;
end.

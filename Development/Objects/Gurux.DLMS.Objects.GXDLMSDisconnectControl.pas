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

unit Gurux.DLMS.Objects.GXDLMSDisconnectControl;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType,
Gurux.DLMS.ControlMode, Gurux.DLMS.ControlState,
Gurux.DLMS.GXDLMSObject, Gurux.DLMS.IGXDLMSClient;

type
TGXDLMSDisconnectControl = class(TGXDLMSObject)
  FOutputState: Boolean;
  FControlState : TControlState;
  FControlMode : TControlMode;

public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // Forces the disconnect control object into 'disconnected' state
  // if remote disconnection is enabled(control mode > 0).
  function RemoteDisconnect(client: IGXDLMSClient) : TArray<TBytes>;

  // Forces the disconnect control object into the 'ready_for_reconnection'
  // state if a direct remote reconnection is disabled(control_mode = 1, 3, 5, 6).
  // Forces the disconnect control object into the 'connected' state if
  // a direct remote reconnection is enabled(control_mode = 2, 4).
  function RemoteReconnect(client: IGXDLMSClient) : TArray<TBytes>;

  // Output state of COSEM Disconnect Control object.
  property OutputState: Boolean read FOutputState write FOutputState;

  // Output state of COSEM Disconnect Control object.
  property ControlState: TControlState read FControlState write FControlState;

  // Control mode of COSEM Disconnect Control object.
  property ControlMode: TControlMode read FControlMode write FControlMode;

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

constructor TGXDLMSDisconnectControl.Create;
begin
  inherited Create(TObjectType.otDisconnectControl);
end;

constructor TGXDLMSDisconnectControl.Create(ln: string);
begin
  inherited Create(TObjectType.otDisconnectControl, ln, 0);
end;

constructor TGXDLMSDisconnectControl.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otDisconnectControl, ln, 0);
  Version := 1;
end;

function TGXDLMSDisconnectControl.RemoteDisconnect(client: IGXDLMSClient) : TArray<TBytes>;
begin
  Result := client.Method(Self, 1, 0, TDataType.dtInt8);
end;

function TGXDLMSDisconnectControl.RemoteReconnect(client: IGXDLMSClient) : TArray<TBytes>;
begin
  Result := client.Method(Self, 2, 0, TDataType.dtInt8);
end;

function TGXDLMSDisconnectControl.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FOutputState,
                TValue.From(FControlState), TValue.From(FControlMode));
end;

function TGXDLMSDisconnectControl.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //OutputState
    if All or CanRead(2) Then
      items.Add(2);
    //ControlState
    if All or CanRead(3) Then
      items.Add(3);
    //ControlMode
    if All or CanRead(4) Then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSDisconnectControl.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSDisconnectControl.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSDisconnectControl.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtBoolean;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtEnum;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSDisconnectControl.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := FOutputState;
  end
  else if e.Index = 3 Then
  begin
    Result := Integer(FControlState);
  end
  else if e.Index = 4 Then
  begin
    Result := Integer(FControlMode);
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSDisconnectControl.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FOutputState := e.Value.AsBoolean;
  end
  else if e.Index = 3 Then
  begin
    FControlState := TControlState(e.Value.AsInteger);
  end
  else if e.Index = 4 Then
  begin
    FControlMode := TControlMode(e.Value.AsInteger);
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSDisconnectControl.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

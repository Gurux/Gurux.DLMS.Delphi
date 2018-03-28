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

unit Gurux.DLMS.Objects.GXDLMSTcpUdpSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSTcpUdpSetup = class(TGXDLMSObject)
  FInactivityTimeout, FMaximumSimultaneousConnections, FPort, FMaximumSegmentSize: Integer;
  FIPReference : string;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  // TCP/UDP port number on which the physical device is
  // listening for the DLMS/COSEM application.
  property Port: Integer read FPort write FPort;

  // References an IP setup object by its logical name. The referenced object
  // contains information about the IP Address settings of the IP layer
  // supporting the TCP-UDP layer.
  property IPReference: string read FIPReference write FIPReference;

  // TCP can indicate the maximum receive segment size to its partner.
  property MaximumSegmentSize: Integer read FMaximumSegmentSize write FMaximumSegmentSize;

  // TCP can indicate the maximum receive segment size to its partner.
  property MaximumSimultaneousConnections: Integer read FMaximumSimultaneousConnections write FMaximumSimultaneousConnections;

  // Defines the time, expressed in seconds over which, if no frame is
  // received from the COSEM client, the inactive TCP connection shall be aborted.
  // When this value is set to 0, this means that the inactivity_time_out is
  // not operational. In other words, a TCP connection, once established,
  // in normal conditions – no power failure, etc. – will never be aborted by the COSEM server.
  property InactivityTimeout: Integer read FInactivityTimeout write FInactivityTimeout;

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

constructor TGXDLMSTcpUdpSetup.Create;
begin
  inherited Create(TObjectType.otTcpUdpSetup, '0.0.25.0.0.255', 0);
  FPort := 4059;
  FInactivityTimeout := 180;
  FMaximumSegmentSize := 576;
end;

constructor TGXDLMSTcpUdpSetup.Create(ln: string);
begin
  inherited Create(TObjectType.otTcpUdpSetup, ln, 0);
  FPort := 4059;
  FInactivityTimeout := 180;
  FMaximumSegmentSize := 576;
end;

constructor TGXDLMSTcpUdpSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otTcpUdpSetup, ln, 0);
  FPort := 4059;
  FInactivityTimeout := 180;
  FMaximumSegmentSize := 576;
end;

function TGXDLMSTcpUdpSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FPort, FIPReference,
                FMaximumSegmentSize, FMaximumSimultaneousConnections,
                FInactivityTimeout);
end;

function TGXDLMSTcpUdpSetup.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //Port
  if Not IsRead(2) Then
    items.Add(2);

  //IPReference
  if Not IsRead(3) Then
    items.Add(3);

  //MaximumSegmentSize
  if Not IsRead(4) Then
    items.Add(4);

  //MaximumSimultaneousConnections
  if Not IsRead(5) Then
    items.Add(5);

  //InactivityTimeout
  if Not IsRead(6) Then
    items.Add(6);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSTcpUdpSetup.GetAttributeCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSTcpUdpSetup.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSTcpUdpSetup.GetDataType(index: Integer): TDataType;
begin
if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSTcpUdpSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := FPort;
  end
  else if e.Index = 3 Then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FIPReference));
  end
  else if e.Index = 4 Then
  begin
    Result := FMaximumSegmentSize;
  end
  else if e.Index = 5 Then
  begin
    Result := FMaximumSimultaneousConnections;
  end
  else if e.Index = 6 Then
  begin
    Result := FInactivityTimeout;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSTcpUdpSetup.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FPort := e.Value.AsInteger;
  end
  else if e.Index = 3 Then
  begin
    FIPReference := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 4 Then
  begin
    FMaximumSegmentSize := e.Value.AsInteger;
  end
  else if e.Index = 5 Then
  begin
    FMaximumSimultaneousConnections := e.Value.AsInteger;
  end
  else if e.Index = 6 Then
  begin
    FInactivityTimeout := e.Value.AsInteger;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSTcpUdpSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

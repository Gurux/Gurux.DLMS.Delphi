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

unit Gurux.DLMS.GXCiphering;

interface
uses SysUtils, Gurux.DLMS.Security, GXByteBuffer, Gurux.DLMS.AesGcmParameter,
Gurux.DLMS.GXDLMSChippering,
Gurux.DLMS.SecurityPolicy,
Gurux.DLMS.SecuritySuite;

type
TGXCiphering = class
  strict private
  FInvocationCounter: LongWord;
  FSecurity: TSecurity;
  FAuthenticationKey: TBytes;
  FSystemTitle: TBytes;
  FBlockCipherKey: TBytes;
  FSourceSystemTitle: TBytes;
  FDedicatedKey: TBytes;
  FSecurityPolicy: TSecurityPolicy;
  FSecuritySuite: TSecuritySuite;

  function get_SystemTitle: TBytes;
  function get_BlockCipherKey: TBytes;
  function get_AuthenticationKey: TBytes;
  procedure set_SystemTitle(Value: TBytes);
  procedure set_BlockCipherKey(Value: TBytes);
  procedure set_AuthenticationKey(Value: TBytes);
  function get_SourceSystemTitle: TBytes;
  procedure set_SourceSystemTitle(Value: TBytes);
  function get_DedicatedKey: TBytes;
  procedure set_DedicatedKey(Value: TBytes);
  public
    constructor Create(systemTitle: TBytes); overload;
    constructor Create(frameCounter: UInt32; systemTitle: TBytes; blockCipherKey: TBytes;
      authenticationKey: TBytes); overload;
    destructor Destroy;override;

    property Security: TSecurity read FSecurity write FSecurity;
    property InvocationCounter: LongWord read FInvocationCounter write FInvocationCounter;

    property SystemTitle: TBytes read get_SystemTitle write set_SystemTitle;

    property SourceSystemTitle: TBytes read get_SourceSystemTitle write set_SourceSystemTitle;

    property DedicatedKey: TBytes read get_DedicatedKey write set_DedicatedKey;

    property BlockCipherKey: TBytes read get_BlockCipherKey write set_BlockCipherKey;
    //Authentication Key is 16 bytes value.
    property AuthenticationKey: TBytes read get_AuthenticationKey write set_AuthenticationKey;

    property SecurityPolicy: TSecurityPolicy read FSecurityPolicy write FSecurityPolicy;
    property SecuritySuite: TSecuritySuite read FSecuritySuite write FSecuritySuite;



    function Encrypt(
        tag: Byte;
        title: TBytes;
        data: TBytes): TBytes;

    function Decrypt(
        title: TBytes;
        key: TBytes;
        data: TGXByteBuffer) : TAesGcmParameter;
    procedure Reset;

    function IsCiphered: Boolean;
end;

implementation

constructor TGXCiphering.Create(systemTitle: TBytes);
begin
  inherited Create;
  FSecurity := TSecurity.None;
  FSystemTitle := systemTitle;

  FBlockCipherKey := TBytes.Create($00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F);
  FAuthenticationKey := TBytes.Create($D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF);
end;

destructor TGXCiphering.Destroy;
begin
  inherited;
  FSystemTitle := Nil;
  FBlockCipherKey := Nil;
  FAuthenticationKey := Nil;
end;


constructor TGXCiphering.Create(frameCounter: UInt32; systemTitle: TBytes;
  blockCipherKey: TBytes; authenticationKey: TBytes);
begin
  inherited Create;
  Self.Security := TSecurity.None;
  Self.FInvocationCounter := frameCounter;
  Self.SystemTitle := systemTitle;
  Self.BlockCipherKey := blockCipherKey;
  Self.AuthenticationKey := authenticationKey;
end;

function TGXCiphering.get_SystemTitle: TBytes;
begin
  Result := FSystemTitle;
end;

function TGXCiphering.get_BlockCipherKey: TBytes;
begin
  Result := FBlockCipherKey;
end;

function TGXCiphering.get_AuthenticationKey: TBytes;
begin
  Result := FAuthenticationKey;
end;

procedure TGXCiphering.set_SystemTitle(Value: TBytes);
begin
  if ((value <> nil) and (Length(value) <> 8)) then
    raise Exception.Create('Invalid System Title.');
  FSystemTitle := value;
end;

function TGXCiphering.get_SourceSystemTitle: TBytes;
begin
  Result := FSourceSystemTitle;
end;

procedure TGXCiphering.set_SourceSystemTitle(Value: TBytes);
begin
  if ((value <> nil) and (Length(value) <> 8)) then
    raise Exception.Create('Invalid Source System Title.');
  FSourceSystemTitle := value;
end;

function TGXCiphering.get_DedicatedKey: TBytes;
begin
  Result := FDedicatedKey;
end;

procedure TGXCiphering.set_DedicatedKey(Value: TBytes);
begin
  if ((value <> nil) and (Length(value) <> 16)) then
    raise Exception.Create('Invalid Dedicated key.');
  FDedicatedKey := value;
end;

procedure TGXCiphering.set_BlockCipherKey(Value: TBytes);
begin
  if ((value <> nil) and (Length(value) <> 16)) then
    raise Exception.Create('Invalid Block Cipher Key.');
  FBlockCipherKey := value;
end;

procedure TGXCiphering.set_AuthenticationKey(Value: TBytes);
begin
  if ((value <> nil) and (Length(value) <> 16)) then
    raise Exception.Create('Invalid Authentication Key.');
  FAuthenticationKey := value;
end;

function TGXCiphering.Encrypt(tag: Byte; title: TBytes; data: TBytes): TBytes;
var
  p: TAesGcmParameter;
begin
  if Security <> TSecurity.None Then
  begin
    p := TAesGcmParameter.Create(tag, FSecurity, FInvocationCounter,
                                                title, FBlockCipherKey, FAuthenticationKey);
    try
      Result := TGXDLMSChippering.EncryptAesGcm(p, data);
    finally
      FreeAndNil(p);
    end;
    FInvocationCounter := FInvocationCounter + 1;
  end
  else
    Result := data;
end;

function TGXCiphering.Decrypt(
    title: TBytes;
    key: TBytes;
    data: TGXByteBuffer) : TAesGcmParameter;
var
  tmp: TBytes;
begin
  Result := TAesGcmParameter.Create(title, key, AuthenticationKey);
  tmp := TGXDLMSChippering.DecryptAesGcm(Result, data);
  data.Clear();
  data.SetArray(tmp);
end;

procedure TGXCiphering.Reset;
begin
  FSecurity := TSecurity.None;
  FInvocationCounter := 0;
end;

function TGXCiphering.IsCiphered: Boolean;
begin
  Result := FSecurity <> TSecurity.None;
end;

end.

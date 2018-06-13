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

unit Gurux.DLMS.AesGcmParameter;

interface
uses SysUtils, GXByteBuffer, Gurux.DLMS.Security, Gurux.DLMS.CountType;

type
  TAesGcmParameter = class
    FTag: Byte;
    FSecurity: TSecurity;
    FInvocationCounter: LongWord;
    FSystemTitle: TBytes;
    FBlockCipherKey: TBytes;
    FAuthenticationKey: TBytes;
    FType: TCountType;
    FCountTag: TBytes;
  public
    property Tag: Byte read FTag write FTag;
    property Security: TSecurity read FSecurity write FSecurity;
    property InvocationCounter: LongWord read FInvocationCounter write FInvocationCounter;
    property SystemTitle: TBytes read FSystemTitle write FSystemTitle;
    property BlockCipherKey: TBytes read FBlockCipherKey write FBlockCipherKey;
    property AuthenticationKey: TBytes read FAuthenticationKey write FAuthenticationKey;
    property &Type: TCountType read FType write FType;
    property CountTag: TBytes read FCountTag write FCountTag;

    // Constructor.
  // <param name='tag'>Command.
  // <param name='security
  // <param name='invocationCounter'>Invocation counter.
  // <param name='systemTitle
  // <param name='blockCipherKey
  // <param name='authenticationKey
  constructor Create(
      tag: Byte;
      Security: TSecurity;
      invocationCounter: LongWord;
      systemTitle: TBytes;
      blockCipherKey: TBytes;
      authenticationKey: TBytes)overload;

  // Constructor.
  // <param name='systemTitle
  // <param name='blockCipherKey
  // <param name='authenticationKey
  constructor Create(
      systemTitle: TBytes;
      blockCipherKey: TBytes;
      authenticationKey: TBytes)overload;

  function ToString: String;override;
end;

implementation

constructor TAesGcmParameter.Create(
  tag: Byte;
  Security: TSecurity;
  invocationCounter: LongWord;
  systemTitle: TBytes;
  blockCipherKey: TBytes;
  authenticationKey: TBytes)overload;
begin
  FTag := tag;
  FSecurity := security;
  FInvocationCounter := invocationCounter;
  FSystemTitle := systemTitle;
  FBlockCipherKey := blockCipherKey;
  FAuthenticationKey := authenticationKey;
  FType := TCountType.Packet;
end;

constructor TAesGcmParameter.Create(
  systemTitle: TBytes;
  blockCipherKey: TBytes;
  authenticationKey: TBytes)overload;
begin
  FSystemTitle := systemTitle;
  FBlockCipherKey := blockCipherKey;
  FAuthenticationKey := authenticationKey;
  FType := TCountType.Packet;
end;

function TAesGcmParameter.ToString : String;
var
  sb: TStringBuilder;
begin
  sb := TStringBuilder.create();
  try
    sb.Append('Security: ');
    sb.Append(Integer(FSecurity));
    sb.Append(' Invocation Counter: ');
    sb.Append(FInvocationCounter);
    sb.Append(' SystemTitle: ');
    sb.Append(TGXByteBuffer.ToHexString(FSystemTitle, true, 0, Length(FSystemTitle)));
    sb.Append(' AuthenticationKey: ');
    sb.Append(TGXByteBuffer.ToHexString(FAuthenticationKey, true, 0, Length(FAuthenticationKey)));
    sb.Append(' BlockCipherKey: ');
    sb.Append(TGXByteBuffer.ToHexString(FBlockCipherKey, true, 0, Length(FBlockCipherKey)));
    Result := sb.ToString();
  finally
    sb.Free;
  end;
end;

end.

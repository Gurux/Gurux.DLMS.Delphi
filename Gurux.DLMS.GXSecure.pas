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

unit Gurux.DLMS.GXSecure;

interface
uses SysUtils, GXByteBuffer, Gurux.DLMS.GXCiphering, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Authentication, Gurux.DLMS.AesGcmParameter, Gurux.DLMS.Security,
Gurux.DLMS.CountType, Gurux.DLMS.GXDLMSChippering, Gurux.GXMD5, Gurux.GXSha1,
Gurux.GXSha256, Gurux.DLMS.GXDLMSChipperingStream, System.Math;

type
  //Access describes access errors.
  TGXSecure = class
public
  class function GenerateChallenge() : TBytes;
  class function Secure(settings: TGXDLMSSettings; cipher: TGXCiphering; ic: LongWord; data: TBytes; secret: TBytes) : TBytes;

  end;

implementation

// Chipher text.
class function TGXSecure.Secure(settings: TGXDLMSSettings; cipher: TGXCiphering; ic: LongWord; data: TBytes; secret: TBytes) : TBytes;
var
  r, s, challenge: TGXByteBuffer;
  p: TAesGcmParameter;
  tmp: TBytes;
  len, pos: Integer;
begin
    if settings.Authentication = TAuthentication.atHigh Then
    begin
      len := Length(data);
      s := TGXByteBuffer.Create();
      try
        r := TGXByteBuffer.Create();
        try
          if len Mod 16 <> 0 Then
            len := len + (16 - (Length(data) Mod 16));

          if Length(secret) > Length(data) Then
          begin
            len := Length(secret);
            if len Mod 16 <> 0 Then
              len := len + (16 - (Length(secret) Mod 16));
          end;
          s.SetArray(secret);
          s.Zero(s.Size, len - s.Size);

          r.SetArray(data);
          r.Zero(r.Size, len - r.Size);
          for pos := 0 to len div 16 - 1 do
            TGXDLMSChipperingStream.Aes1Encrypt(r, pos * 16, s);
          Result := r.ToArray;
          SetLength(Result, 16);
        finally
          FreeAndNil(r);
        end;
      finally
       FreeAndNil(s);
      end;
      Exit;
    end;
    // Get server Challenge.
    challenge := TGXByteBuffer.Create();
    try
      // Get shared secret
      if settings.Authentication = TAuthentication.atHighGMAC Then
        challenge.SetArray(data)
      else if settings.Authentication = TAuthentication.atHighSHA256 Then
      begin
        challenge.SetArray(secret);
        challenge.SetArray(settings.Cipher.SystemTitle);
        challenge.SetArray(settings.SourceSystemTitle);
        if settings.IsServer Then
        begin
          challenge.SetArray(settings.CtoSChallenge);
          challenge.SetArray(settings.StoCChallenge);
        end
        else
        begin
          challenge.SetArray(settings.StoCChallenge);
          challenge.SetArray(settings.CtoSChallenge);
        end;
      end
      else
      begin
        challenge.SetArray(data);
        challenge.SetArray(secret);
      end;
      tmp := challenge.ToArray();
      if settings.Authentication = TAuthentication.atHighMD5 Then
        Result := TGXMD5.Encrypt(tmp)
      else if settings.Authentication = TAuthentication.atHighSHA1 Then
        Result := TGXSha1.Encrypt(challenge)
      else if settings.Authentication = TAuthentication.atHighSHA256 Then
        Result := TGXSha256.Encrypt(challenge)
      else if settings.Authentication = TAuthentication.atHighGMAC Then
      begin
        //SC is always Security.Authentication.
        p := TAesGcmParameter.Create(0, TSecurity.Authentication, ic,
            secret, cipher.BlockCipherKey, cipher.AuthenticationKey);
        try
          p.&Type := TCountType.Tag;
          challenge.Clear();
          challenge.SetUInt8(Byte(TSecurity.Authentication));
          challenge.SetUInt32(p.InvocationCounter);
          challenge.SetArray(TGXDLMSChippering.EncryptAesGcm(p, tmp));
          Result := challenge.ToArray();
        finally
          FreeAndNil(p);
        end;
      end
      else
        Result := data;
    finally
      FreeAndNil(challenge);
    end;


end;

class function TGXSecure.GenerateChallenge() : TBytes;
var
  len, pos : Integer;
begin
    // Random challenge is 8 to 64 bytes.
    // Texas Instruments accepts only 16 byte long challenge.
    // For this reason challenge size is 16 bytes at the moment.
    {
    repeat
      len := Random(64);
    until len > 7;
    }
    len := 16;
    SetLength(Result, len);
    for pos := 0 to len - 1 do
    begin
        // Allow printable characters only.
        repeat
          Result[pos] := Random($7A);
        until (Result[pos] > $21) and (Result[pos] < $7B);
    end;
end;

end.

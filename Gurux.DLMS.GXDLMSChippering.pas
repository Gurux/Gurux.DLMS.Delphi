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

unit Gurux.DLMS.GXDLMSChippering;

interface

uses SysUtils, Gurux.DLMS.Security, Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSChipperingStream, GXCommon, Gurux.DLMS.GXDLMSException,
GXByteBuffer, Gurux.DLMS.CountType, Gurux.DLMS.AesGcmParameter;

type

TGXDLMSChippering = class
  public

strict private
    class function GetNonse(FrameCounter: UInt32; systemTitle: TBytes): TBytes;static;
  public
    class function EncryptAesGcm(param: TAesGcmParameter; plainText: TBytes): TBytes;static;
  strict private
    class function GetAuthenticatedData(security: TSecurity; AuthenticationKey: TBytes;
      plainText: TBytes): TBytes;static;
  public
    class function DecryptAesGcm(p: TAesGcmParameter; data: TGXByteBuffer) :TBytes;static;

  end;

implementation
uses Gurux.DLMS.DataType, Gurux.DLMS.GXDateTime;

class function TGXDLMSChippering.GetNonse(FrameCounter: UInt32; systemTitle: TBytes): TBytes;
type
  TArrayOfArrayOfByte = array of array of Byte;
begin
  SetLength(Result, 12);
  Move(systemTitle[0], Result[0], Length(systemTitle));
  Result[8] := Byte(FrameCounter shr 24);
  Result[9] := Byte(FrameCounter shr 16);
  Result[10] := Byte(FrameCounter shr 8);
  Result[11] := Byte(FrameCounter);
end;

class function TGXDLMSChippering.EncryptAesGcm(param: TAesGcmParameter; plainText: TBytes): TBytes;
var
  ciphertext: TBytes;
  gcm: TGXDLMSChipperingStream;
  aad: TBytes;
  tmp: TBytes;
  data, data2 : TGXByteBuffer;
begin
  param.CountTag := nil;
  data := TGXByteBuffer.Create();
  try
    if (param.&Type = TCountType.Packet) then
      data.SetUInt8((Byte(param.Security)));

    SetLength(tmp, 4);
    tmp[0] := ((param.InvocationCounter shr 24) and $FF);
    tmp[1] := ((param.InvocationCounter shr 16) and $FF);
    tmp[2] := ((param.InvocationCounter shr 8) and $FF);
    tmp[3] := Byte(param.InvocationCounter);

  {$IFDEF DEBUG}
    // Will resolve in I/O error if no console to output to.
    // WriteLn('Encrypted data:' + TGXByteBuffer.ToHexString(plainText));
  {$ENDIF}

    aad := GetAuthenticatedData(param.Security, param.AuthenticationKey, plainText);
    gcm := TGXDLMSChipperingStream.Create(param.Security, True, param.BlockCipherKey, aad, GetNonse(param.InvocationCounter,
          param.SystemTitle), nil);
    try
      if (param.Security <> TSecurity.Authentication) then
        gcm.Write(plainText);
      ciphertext := gcm.FlushFinalBlock;
      if (param.Security = TSecurity.Authentication) then
      begin
        if (param.&Type = TCountType.Packet) then
          data.SetArray(tmp);
        if (Integer(param.&Type) and Integer(TCountType.Data)) <> 0 then
          data.SetArray(plainText);
        if (Integer(param.&Type) and Integer(TCountType.Tag)) <> 0 then
        begin
          param.CountTag := gcm.GetTag;
          data.SetArray(param.CountTag);
        end;
      end
      else
        if param.Security = TSecurity.Encryption then
        begin
          if param.&Type = TCountType.Packet Then
            data.SetArray(tmp);
          data.SetArray(ciphertext);
        end
        else
          if (param.Security = TSecurity.AuthenticationEncryption) then
          begin
            if (param.&Type = TCountType.Packet) then
              data.SetArray(tmp);
            if (Integer(param.&Type) and Integer(TCountType.Data)) <> 0 then
              data.SetArray(ciphertext);
            if (Integer(param.&Type) and Integer(TCountType.Tag)) <> 0 then
            begin
              param.CountTag := gcm.GetTag;
              data.SetArray(param.CountTag);
            end;
          end
          else
            raise Exception.Create('security');
      if (param.&Type = TCountType.Packet) then
      begin
        data2 := TGXByteBuffer.Create();
        try
          data2.SetUInt8(param.Tag);
          TGXCommon.SetObjectCount(data.Size,data2);
          data2.SetArray(data);
          Result := data2.ToArray;
        finally
          FreeAndNil(data2);
        end;
      end
      else
        Result := data.ToArray;
    finally
      FreeAndNil(gcm);
    end;
  finally
    FreeAndNil(data);
  end;


end;

class function TGXDLMSChippering.GetAuthenticatedData(security: TSecurity; AuthenticationKey: TBytes;
  plainText: TBytes): TBytes;
var
  tmp2 : TGXByteBuffer;
  begin
  Result := nil;
  if (security = TSecurity.Authentication) then
  begin
    tmp2 := TGXByteBuffer.Create();
    try
      tmp2.Add(Byte(security));
      tmp2.SetArray(AuthenticationKey);
      tmp2.SetArray(plainText);
      Result := tmp2.ToArray;
    finally
      FreeAndNil(tmp2);
    end;
    Exit;
  end
  else
    if (security = TSecurity.Encryption) then
      begin
        Result := AuthenticationKey;
        Exit;
      end
    else
      if (security = TSecurity.AuthenticationEncryption) then
      begin
        tmp2 := TGXByteBuffer.Create();
        try
          tmp2.Add(Byte(security));
          tmp2.SetArray(AuthenticationKey);
          Result := tmp2.ToArray;
        finally
          FreeAndNil(tmp2);
        end;
      end;
end;


// Decrypt data.
// p">Decryption parameters
// Returns Decrypted data.
class function TGXDLMSChippering.DecryptAesGcm(p: TAesGcmParameter; data: TGXByteBuffer) :TBytes;
var
  len, length: Integer;
  cmd: TCommand;
  encryptedData, tag, ciphertext, aad, iv: TBytes;
  gcm: TGXDLMSChipperingStream;
  tmp: TBytes;
  t: TGXByteBuffer;
  transactionId: UInt64;
  tm: TGXDateTime;
begin
  if (data = Nil) or (data.Size < 2) Then
    raise EArgumentException.Create('cryptedData');

  cmd := TCommand(data.GetUInt8());
  case cmd of
    TCommand.GeneralGloCiphering, TCommand.GeneralDedCiphering:
    begin
      len := TGXCommon.GetObjectCount(data);
      if len <> 0 Then
      begin
        SetLength(tag, len);
        data.Get(tag);
        p.SystemTitle := tag;
        tag := Nil;
      end;
    end;
    TCommand.GeneralCiphering,
    TCommand.GloInitiateRequest,
    TCommand.GloInitiateResponse,
    TCommand.GloReadRequest,
    TCommand.GloReadResponse,
    TCommand.GloWriteRequest,
    TCommand.GloWriteResponse,
    TCommand.GloGetRequest,
    TCommand.GloGetResponse,
    TCommand.GloSetRequest,
    TCommand.GloSetResponse,
    TCommand.GloMethodRequest,
    TCommand.GloMethodResponse,
    TCommand.GloEventNotificationRequest,
    TCommand.DedInitiateRequest,
    TCommand.DedInitiateResponse,
    TCommand.DedGetRequest,
    TCommand.DedGetResponse,
    TCommand.DedSetRequest,
    TCommand.DedSetResponse,
    TCommand.DedMethodRequest,
    TCommand.DedMethodResponse,
    TCommand.DedEventNotificationRequest,
    TCommand.DedReadRequest,
    TCommand.DedReadResponse,
    TCommand.DedWriteRequest,
    TCommand.DedWriteResponse:
      //Do nothing.
    else
      raise EArgumentException.Create('cryptedData');
  end;
  if cmd = TCommand.GeneralCiphering Then
  begin
    len := TGXCommon.GetObjectCount(data);
    SetLength(tmp, len);
    data.Get(tmp);
    t := TGXByteBuffer.Create(tmp);
    transactionId := t.GetUInt64();
    len := TGXCommon.GetObjectCount(data);
    SetLength(tmp, len);
    data.Get(tmp);
    p.SystemTitle := tmp;
    len := TGXCommon.GetObjectCount(data);
    SetLength(tmp, len);
    data.Get(tmp);
    p.RecipientSystemTitle := tmp;
    // Get date time.
    len := TGXCommon.GetObjectCount(data);
    if len <> 0 Then
    begin
      SetLength(tmp, len);
      data.Get(tmp);
      tm := TGXCommon.ChangeType(tmp, TDataType.dtDateTime).AsType<TGXDateTime>;
      p.DateTime := tm.LocalTime;
      FreeAndNil(tm);
    end;
    // other-information
    len := data.GetUInt8();
    if len <> 0 Then
    begin
      SetLength(tmp, len);
      data.Get(tmp);
      p.OtherInformation := tmp;
    end;
    // KeyInfo OPTIONAL
    //len :=
    data.GetUInt8();
    // AgreedKey CHOICE tag.
    data.GetUInt8();
    // key-parameters
    //len :=
    data.GetUInt8();
    p.KeyParameters := data.GetUInt8();
    if p.KeyParameters = 1 Then
    begin
        // KeyAgreement.ONE_PASS_DIFFIE_HELLMAN
        // key-ciphered-data
        len := TGXCommon.GetObjectCount(data);
        SetLength(tmp, len);
        data.Get(tmp);
        p.KeyCipheredData := tmp;
    end
    else if p.KeyParameters = 2 Then
    begin
        // KeyAgreement.STATIC_UNIFIED_MODEL
        len := TGXCommon.GetObjectCount(data);
        if len <> 0 Then
          raise EArgumentException.Create('Invalid key parameters');
    end
    else
      raise EArgumentException.Create('key-parameters');
  end;
  //len :=
  TGXCommon.GetObjectCount(data);
  p.Security := TSecurity(data.GetUInt8());
  p.InvocationCounter := data.GetUInt32();

  SetLength(tag, 12);
  if p.Security = TSecurity.Authentication Then
  begin
      length := data.Size - data.Position - 12;
      SetLength(encryptedData, length);
      data.Get(encryptedData);
      data.Get(tag);
      // Check tag.
      EncryptAesGcm(p, encryptedData);
      if Not TGXDLMSChipperingStream.TagsEquals(tag, p.CountTag) Then
          raise TGXDLMSException.Create('Decrypt failed. Invalid tag.');
      Result := encryptedData;
      Exit;
  end;
  ciphertext := Nil;
  if p.Security = TSecurity.Encryption Then
  begin
    length := data.Size - data.Position;
    SetLength(ciphertext, length);
    data.Get(ciphertext);
  end
  else if p.Security = TSecurity.AuthenticationEncryption Then
  begin
      length := data.Size - data.Position - 12;
      SetLength(ciphertext, length);
      data.Get(ciphertext);
      data.Get(tag);
  end;
  aad := GetAuthenticatedData(p.Security, p.AuthenticationKey, ciphertext);
  iv := GetNonse(p.InvocationCounter, p.SystemTitle);
  gcm := TGXDLMSChipperingStream.Create(p.Security, true, p.BlockCipherKey, aad, iv, tag);
  try
    gcm.Write(ciphertext);
    ciphertext := gcm.FlushFinalBlock();
  finally
    FreeAndNil(gcm);
  end;
  if p.Security = TSecurity.AuthenticationEncryption Then
  begin
      // Check tag.
      EncryptAesGcm(p, ciphertext);
      if Not TGXDLMSChipperingStream.TagsEquals(tag, p.CountTag) Then
      begin
          //    throw new GXDLMSException("Decrypt failed. Invalid tag.");
      end;
  end;
  Result := ciphertext;
end;

end.

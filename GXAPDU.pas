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

unit GXAPDU;

interface
uses SysUtils, GXByteBuffer, Gurux.DLMS.Authentication,
Gurux.DLMS.AssociationResult, GXCommon, Gurux.DLMS.SourceDiagnostic,
Gurux.DLMS.InterfaceType, Gurux.DLMS.GXDLMSException,
Gurux.DLMS.GXDLMSObject, Gurux.DLMS.GXCiphering, Gurux.DLMS.PduType,
Gurux.DLMS.BerType, Gurux.DLMS.Command, Gurux.DLMS.GXDLMSConfirmedServiceError,
Gurux.DLMS.ConfirmedServiceError, Gurux.DLMS.ServiceError, Gurux.DLMS.Initiate,
Gurux.DLMS.Conformance, Gurux.DLMS.Service, Gurux.DLMS.AesGcmParameter,
Gurux.DLMS.GXDLMSChippering, Gurux.DLMS.Security;

type

// The services to access the attributes and methods of COSEM objects are
// determined on DLMS/COSEM Application layer. The services are carried by
// Application Protocol Data Units (APDUs).
// <p />In DLMS/COSEM the meter is primarily a server, and the controlling system
// is a client. Also unsolicited (received without a request) messages are available.
TGXAPDU = class
  class procedure Parse(initiateRequest: Boolean; settings: TGXDLMSSettings;
    cipher: TGXCiphering; data: TGXByteBuffer; tag: WORD);

  class procedure ParseInitiate(initiateRequest: Boolean;
    settings: TGXDLMSSettings; cipher: TGXCiphering; data: TGXByteBuffer);
  // Parse User Information from PDU.
  class procedure ParseUserInformation(settings: TGXDLMSSettings; cipher: TGXCiphering; data: TGXByteBuffer);
  // Retrieves the string that indicates the level of authentication, if any.
  class procedure GetAuthenticationString(settings: TGXDLMSSettings; data: TGXByteBuffer);
  // Code application context name.
  class procedure GenerateApplicationContextName(settings: TGXDLMSSettings; data: TGXByteBuffer; cipher: TGXCiphering);
  // Generate User information initiate request.
  class procedure GetInitiateRequest(settings: TGXDLMSSettings; cipher: TGXCiphering; data: TGXByteBuffer);

  // Parse application context name.
  class function ParseApplicationContextName(settings: TGXDLMSSettings; buff: TGXByteBuffer): Boolean;

  class procedure UpdateAuthentication(settings: TGXDLMSSettings; buff: TGXByteBuffer);
  class procedure UpdatePassword(settings: TGXDLMSSettings; buff: TGXByteBuffer);

  class function GetUserInformation(settings: TGXDLMSSettings; cipher: TGXCiphering): TBytes;
  //Server generates AARE message.
  class procedure GenerateAARE(settings: TGXDLMSSettings; data: TGXByteBuffer;
      result: TAssociationResult; diagnostic: TSourceDiagnostic;
      cipher: TGXCiphering; encryptedData: TGXByteBuffer);

  public
  // Generate user information.
  class procedure GenerateUserInformation(settings: TGXDLMSSettings; cipher:
                TGXCiphering; encryptedData: TGXByteBuffer; data: TGXByteBuffer);

  // Generates Aarq.
  class procedure GenerateAarq(settings: TGXDLMSSettings; cipher: TGXCiphering;
                encryptedData: TGXByteBuffer; data: TGXByteBuffer);static;

  // Parse APDU.
  class function ParsePDU(settings: TGXDLMSSettings; cipher: TGXCiphering; buff: TGXByteBuffer): TSourceDiagnostic;

  class function ParsePDU2(settings: TGXDLMSSettings; cipher: TGXCiphering; buff: TGXByteBuffer): TSourceDiagnostic;

end;

implementation

class procedure TGXAPDU.GetAuthenticationString(settings: TGXDLMSSettings; data: TGXByteBuffer);
var
  len: Integer;
  callingAuthenticationValue: TBytes;
begin
  //If authentication is used.
  if settings.Authentication <> TAuthentication.atNone Then
  begin
    //Add sender ACSE-requirements field component.
    data.SetUInt8(Integer(TBerType.btContext) or Integer(TPduType.SenderAcseRequirements));
    data.SetUInt8(2);
    data.SetUInt8(Integer(TBerType.btBitString) or Integer(TBerType.btOctetString));
    data.SetUInt8($80);
    data.SetUInt8(Integer(TBerType.btContext) or Integer(TPduType.MechanismName));
    //Len
    data.SetUInt8(7);
    // OBJECT IDENTIFIER
    data.SetUInt8($60);
    data.SetUInt8($85);
    data.SetUInt8($74);
    data.SetUInt8($05);
    data.SetUInt8($08);
    data.SetUInt8($02);
    data.SetUInt8(Byte(settings.Authentication));
    //Add Calling authentication information.
    len := 0;
    callingAuthenticationValue := Nil;
    if settings.Authentication = TAuthentication.atLow Then
    begin
      if settings.Password <> Nil Then
      begin
        callingAuthenticationValue := settings.Password;
        len := Length(callingAuthenticationValue);
      end;
    end
    else
    begin
      callingAuthenticationValue := settings.CtoSChallenge;
      len := Length(callingAuthenticationValue);
    end;
    //$AC
    data.SetUInt8(Integer(TBerType.btContext) or Integer(TBerType.btConstructed) or Integer(TPduType.CallingAuthenticationValue));
    //Len
    data.SetUInt8(2 + len);
    //Add authentication information.
    data.SetUInt8(Integer(TBerType.btContext));
    //Len.
    data.SetUInt8(len);
    if len <> 0 Then
      data.SetArray(callingAuthenticationValue);
  end;
end;

class procedure TGXAPDU.GenerateApplicationContextName(settings: TGXDLMSSettings; data: TGXByteBuffer; cipher: TGXCiphering);
var
  ciphered: Boolean;
begin
  //Application context name tag
  data.SetUInt8(Integer(TBerType.btContext) or Integer(TBerType.btConstructed) or Integer(TPduType.ApplicationContextName));
  //Len
  data.SetUInt8($09);
  data.SetUInt8(Integer(TBerType.btObjectIdentifier));
  //Len
  data.SetUInt8($07);
  ciphered := (cipher <> Nil) and cipher.IsCiphered;
  if settings.UseLogicalNameReferencing Then
  begin
    if ciphered Then
      data.SetArray(LogicalNameObjectIdWithCiphering)
    else
      data.SetArray(GXCommon.LogicalNameObjectID);
  end
  else
  begin
    if ciphered Then
      data.SetArray(GXCommon.ShortNameObjectIdWithCiphering)
    else
      data.SetArray(GXCommon.ShortNameObjectID);
  end;
  //Add system title if cipher or GMAC authentication is used..
  if Not settings.IsServer and (ciphered or (settings.Authentication = TAuthentication.atHighGMAC)) Then
  begin
    if (cipher.SystemTitle = Nil) or (Length(cipher.SystemTitle) = 0) Then
      raise EArgumentException.Create('SystemTitle');

    //Add calling-AP-title
    data.SetUInt8(Integer(TBerType.btContext) or Integer(TBerType.btConstructed) or 6);
    //LEN
    data.SetUInt8(2 + Length(cipher.SystemTitle));
    data.SetUInt8(Integer(TBerType.btOctetString));
    //LEN
    data.SetUInt8(Length(cipher.SystemTitle));
    data.SetArray(cipher.SystemTitle);
  end;
end;

class procedure TGXAPDU.GetInitiateRequest(settings: TGXDLMSSettings; cipher: TGXCiphering; data: TGXByteBuffer);
var
  bb: TGXByteBuffer;
begin
  // Tag for xDLMS-Initiate request
  data.SetUInt8(Integer(TCommand.InitiateRequest));
  // Usage field for dedicated-key component. Not used
  data.SetUInt8($00);
  //encoding of the response-allowed component (BOOLEAN DEFAULT TRUE)
  // usage flag (FALSE, default value TRUE conveyed)
  data.SetUInt8(0);

  // Usage field of the proposed-quality-of-service component. Not used
  data.SetUInt8($00);
  data.SetUInt8(settings.DLMSVersion);
  // Tag for conformance block
  data.SetUInt8($5F);
  data.SetUInt8($1F);
  // length of the conformance block
  data.SetUInt8($04);
  // encoding the number of unused bits in the bit string
  data.SetUInt8($00);

  bb := TGXByteBuffer.Create(4);
  bb.SetUInt32(Integer(settings.ProposedConformance));
  data.SetArray(bb.SubArray(1, 3));
  data.SetUInt16(settings.MaxPduSize);
  FreeAndNil(bb);
end;

// Generate user information.
class procedure TGXAPDU.GenerateUserInformation(settings: TGXDLMSSettings;
  cipher: TGXCiphering; encryptedData: TGXByteBuffer; data: TGXByteBuffer);
var
  tmp: TGXByteBuffer;
  crypted: TBytes;
begin
  data.SetUInt8(Integer(TBerType.btContext) or Integer(TBerType.btConstructed) or Integer(TPduType.UserInformation));
  if (cipher = Nil) or Not cipher.IsCiphered() Then
  begin
    //Length for AARQ user field
    data.SetUInt8($10);
    //Coding the choice for user-information (Octet STRING, universal)
    data.SetUInt8(Byte(TBerType.btOctetString));
    //Length
    data.SetUInt8($0E);
    GetInitiateRequest(settings, cipher, data);
  end
  else
  begin
    if (encryptedData <> Nil) and (encryptedData.Size <> 0) Then
    begin
      //Length for AARQ user field
      data.SetUInt8(4 + encryptedData.Size);
      //Tag
      data.SetUInt8(Integer(TBerType.btOctetString));
      data.SetUInt8(2 + encryptedData.Size);
      //Coding the choice for user-information (Octet STRING, universal)
      data.SetUInt8(Integer(TCommand.GloInitiateRequest));
      data.SetUInt8(encryptedData.Size);
      data.SetArray(encryptedData);
    end
    else
    begin
      tmp := TGXByteBuffer.Create();
      GetInitiateRequest(settings, cipher, tmp);
      crypted := cipher.Encrypt(Integer(TCommand.GloInitiateRequest), cipher.SystemTitle, tmp.ToArray());
      FreeAndNil(tmp);
      //Length for AARQ user field
      data.SetUInt8(2 + Length(crypted));
      //Coding the choice for user-information (Octet STRING, universal)
      data.SetUInt8(Integer(TBerType.btOctetString));
      data.SetUInt8(Length(crypted));
      data.SetArray(crypted);
    end;
  end;
end;

// Generates Aarq.
class procedure TGXAPDU.GenerateAarq(settings: TGXDLMSSettings; cipher: TGXCiphering;
   encryptedData: TGXByteBuffer; data: TGXByteBuffer);
var
  offset: Integer;
begin
  //AARQ APDU Tag
  data.SetUInt8(Integer(TBerType.btApplication) or Integer(TBerType.btConstructed));
  //Length is updated later.
  offset := data.Size;
  data.SetUInt8(0);
  ///////////////////////////////////////////
  // Add Application context name.
  GenerateApplicationContextName(settings, data, cipher);
  GetAuthenticationString(settings, data);
  GenerateUserInformation(settings, cipher, encryptedData, data);
  data.SetUInt8(offset, data.Size - offset - 1);
end;

class procedure TGXAPDU.Parse(initiateRequest: Boolean; settings: TGXDLMSSettings;
    cipher: TGXCiphering; data: TGXByteBuffer; tag: WORD);
var
  len: Integer;
  response: Boolean;
  tmp: TBytes;
  bb: TGXByteBuffer;
  v: LongWord;
  pdu: WORD;
begin
  response := tag = Integer(TCommand.InitiateResponse);
  if response Then
  begin
    //Optional usage field of the negotiated quality of service component
    tag := data.GetUInt8();
    if tag <> 0 Then//Skip if used.
    begin
      len := data.GetUInt8();
      data.Position(data.Position + len);
    end;
  end
  else if tag = Byte(TCommand.InitiateRequest) Then
  begin
      //Optional usage field of the negotiated quality of service component
      tag := data.GetUInt8();
      if tag <> 0 Then
      begin
        len := data.GetUInt8();
        if initiateRequest Then
        begin
          SetLength(tmp, len);
          data.Get(tmp);
          settings.DedicatedKey := tmp;
          tmp := Nil
        end
        else
        begin
          // CtoS.
          SetLength(tmp, len);
          data.Get(tmp);
          settings.CtoSChallenge := tmp;
          tmp := Nil;
        end;
      end;
      //Optional usage field of the negotiated quality of service component
      tag := data.GetUInt8();
      if tag <> 0 Then
      begin
        //len :=
        data.GetUInt8();
      end;
      //Optional usage field of the proposed quality of service component
      tag := data.GetUInt8();
      if tag <> 0 Then//Skip if used.
      begin
        len := data.GetUInt8();
        data.Position(data.Position + len);
      end;
  end
  else if tag = Integer(TCommand.ConfirmedServiceError) Then
    raise TGXDLMSConfirmedServiceError.Create(
            TConfirmedServiceError(data.GetUInt8()),
            TServiceError(data.GetUInt8()), data.GetUInt8())
  else
    raise EArgumentException.Create('Invalid tag.');

  //Get DLMS version number.
  if Not response Then
  begin
    //ProposedDlmsVersionNumber
    if data.GetUInt8() <> 6 Then
    begin
      if settings.IsServer Then
      begin
          raise TGXDLMSConfirmedServiceError.Create(
              TConfirmedServiceError.InitiateError,
              TServiceError.Initiate,
              Byte(TInitiate.DlmsVersionTooLow));
      end;
      raise EArgumentException.Create('Invalid DLMS version number.');
    end;
  end
  else if data.GetUInt8() <> 6 Then
    raise EArgumentException.Create('Invalid DLMS version number.');

  //Tag for conformance block
  tag := data.GetUInt8();
  if tag <> $5F Then
    raise EArgumentException.Create('Invalid tag.');

  //Old Way...
  if data.GetUInt8(data.Position) = $1F Then
    data.GetUInt8();

  //len :=
  data.GetUInt8();
  //The number of unused bits in the bit string.
  //tag :=
  data.GetUInt8();
  bb := TGXByteBuffer.Create(4);
  SetLength(tmp, 3);
  data.Get(tmp);
  bb.SetUInt8(0);
  bb.SetArray(tmp);
  v := bb.GetUInt32();
  FreeAndNil(bb);
  if settings.IsServer Then
    settings.NegotiatedConformance := TConformance(v and Integer(settings.ProposedConformance))
  else
    settings.NegotiatedConformance := TConformance(v);

  if Not response Then
  begin
    //Proposed max PDU size.
    pdu := data.GetUInt16();
    //If PDU is too low.
    if pdu < 64 Then
      raise TGXDLMSConfirmedServiceError.Create(
                TConfirmedServiceError.InitiateError,
                TServiceError.Service, Integer(TService.PduSize));

    settings.MaxPduSize := pdu;
    //If client asks too high PDU.
    if settings.MaxPduSize > settings.MaxServerPDUSize Then
      settings.MaxPduSize := settings.MaxServerPDUSize;
  end
  else
    //Max PDU size.
    settings.MaxPduSize := data.GetUInt16();

  if response Then
  begin
      //VAA Name
      tag := data.GetUInt16();
      if tag = $0007 Then
      begin
          if initiateRequest Then
            settings.UseLogicalNameReferencing := true
          else if Not settings.UseLogicalNameReferencing Then
              // If LN
                  raise EArgumentException.Create('Invalid VAA.');
      end
      else if (tag = $FA00) Then
      begin
          // If SN
          if initiateRequest Then
            settings.UseLogicalNameReferencing := false
          else if settings.UseLogicalNameReferencing Then
            raise EArgumentException.Create('Invalid VAA.');
      end
      else
        // Unknown VAA.
        raise EArgumentException.Create('Invalid VAA.');
  end;
 end;

class procedure TGXAPDU.ParseInitiate(initiateRequest: Boolean;
    settings: TGXDLMSSettings; cipher: TGXCiphering; data: TGXByteBuffer);
var
  p: TAesGcmParameter;
  tag: Byte;
  tmp: TBytes;
begin
  //Tag for xDLMS-Initate.response
  p := Nil;
  try
    tag := data.GetUInt8();
    if tag = Integer(TCommand.GloInitiateResponse) Then
    begin
        data.Position( data.Position - 1);
        p := TAesGcmParameter.Create(settings.SourceSystemTitle, settings.Cipher.BlockCipherKey, settings.Cipher.AuthenticationKey);
        tmp := TGXDLMSChippering.DecryptAesGcm(p, data);
        data.Clear();
        data.SetArray(tmp);
        cipher.Security := p.Security;
        tag := data.GetUInt8();
    end
    else if tag = Integer(TCommand.GloInitiateRequest) Then
    begin
        data.Position(data.Position - 1);
        p := TAesGcmParameter.Create(settings.SourceSystemTitle, settings.Cipher.BlockCipherKey, settings.Cipher.AuthenticationKey);
        tmp := TGXDLMSChippering.DecryptAesGcm(p, data);
        data.Clear();
        data.SetArray(tmp);
        cipher.Security := p.Security;
        tag := data.GetUInt8();
    end;
    Parse(initiateRequest, settings, cipher, data, tag);
  finally
    FreeAndNil(p);
  end;
end;

class procedure TGXAPDU.ParseUserInformation(settings: TGXDLMSSettings; cipher: TGXCiphering; data: TGXByteBuffer);
var
  tag, len: Byte;
begin
    len := data.GetUInt8();
    if data.Size - data.Position < len Then
        raise EArgumentException.Create('Not enough data.');

    //Excoding the choice for user information
    tag := data.GetUInt8();
    if tag <> $4 Then
      raise EArgumentException.Create('Invalid tag.');

    len := data.GetUInt8();
    if data.Size - data.Position < len Then
        raise EArgumentException.Create('Not enough data.');

    ParseInitiate(false, settings, cipher, data);
end;

class function TGXAPDU.ParseApplicationContextName(settings: TGXDLMSSettings; buff: TGXByteBuffer): Boolean;
var
  len: Byte;
begin
    //Get length.
    len := buff.GetUInt8();
    if buff.Size - buff.Position < len Then
      raise EArgumentException.Create('Encoding failed. Not enough data.');

    if buff.GetUInt8() <> $6 Then
      raise EArgumentException.Create('Encoding failed. Not an Object ID.');

    if settings.IsServer and (settings.Cipher <> Nil) Then
      settings.Cipher.Security := TSecurity.None;

    //Object ID length.
    //len :=
    buff.GetUInt8();
    if settings.UseLogicalNameReferencing Then
    begin
      if buff.Compare(LogicalNameObjectID) Then
      begin
        Result := true;
        Exit;
      end;
      // If ciphering is used.
      Result := buff.Compare(LogicalNameObjectIdWithCiphering);
      Exit;
    end;
    if buff.Compare(ShortNameObjectID) Then
    begin
        Result := true;
        Exit;
    end;
    // If ciphering is used.
    Result := buff.Compare(GXCommon.ShortNameObjectIdWithCiphering);
end;

class procedure TGXAPDU.UpdateAuthentication(settings: TGXDLMSSettings; buff: TGXByteBuffer);
var
  tmp: Byte;
begin
    //len :=
    buff.GetUInt8();
    if buff.GetUInt8() <> $60 Then
      raise EArgumentException.Create('Invalid tag.');

    if buff.GetUInt8() <> $85 Then
      raise EArgumentException.Create('Invalid tag.');

    if buff.GetUInt8() <> $74 Then
      raise EArgumentException.Create('Invalid tag.');

    if buff.GetUInt8() <> $05 Then
      raise EArgumentException.Create('Invalid tag.');

    if buff.GetUInt8() <> $08 Then
      raise EArgumentException.Create('Invalid tag.');

    if buff.GetUInt8() <> $02 Then
        raise EArgumentException.Create('Invalid tag.');

    tmp := buff.GetUInt8();
    if (tmp > 7) Then
      raise EArgumentException.Create('Invalid tag.');

    settings.Authentication := TAuthentication(tmp);
end;

class function TGXAPDU.ParsePDU(settings: TGXDLMSSettings; cipher: TGXCiphering; buff: TGXByteBuffer): TSourceDiagnostic;
var
  size: Integer;
  len, tag: Byte;
begin
  // Get AARE tag and length
  tag := buff.GetUInt8();
  if settings.IsServer Then
  begin
    if tag <> (Integer(TBerType.btApplication) or Integer(TBerType.btConstructed) or Integer(TPduType.ProtocolVersion)) Then
      raise EArgumentException.Create('Invalid tag.');
  end
  else if tag <> (Integer(TBerType.btApplication) or Integer(TBerType.btConstructed) or Integer(TPduType.ApplicationContextName)) Then
    raise EArgumentException.Create('Invalid tag.');

  len := TGXCommon.GetObjectCount(buff);
  size := buff.Size - buff.Position;
  if len > size Then
    raise EArgumentException.Create('Not enough data.');

  //Opening tags
  Result := ParsePDU2(settings, cipher, buff);
end;

class function TGXAPDU.ParsePDU2(settings: TGXDLMSSettings; cipher: TGXCiphering; buff: TGXByteBuffer): TSourceDiagnostic;
var
  resultComponent: TAssociationResult;
  len, tag: Byte;
  tmp: TBytes;
begin
  resultComponent := TAssociationResult.Accepted;
  Result := TSourceDiagnostic.None;
  while buff.Position < buff.Size do
  begin
      tag := buff.GetUInt8();
      case tag of
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.ApplicationContextName)://$A1
        if Not ParseApplicationContextName(settings, buff) Then
            raise TGXDLMSException.Create(TAssociationResult.PermanentRejected, TSourceDiagnostic.ApplicationContextNameNotSupported);
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledApTitle)://$A2
      begin
        //Get len.
        if buff.GetUInt8() <> 3 Then
          raise EArgumentException.Create('Invalid tag.');

        //Choice for result (INTEGER, universal)
        if buff.GetUInt8() <> Byte(TBerType.btInteger) Then
            raise EArgumentException.Create('Invalid tag.');

        //Get len.
        if buff.GetUInt8() <> 1 Then
          raise EArgumentException.Create('Invalid tag.');

        resultComponent := TAssociationResult(buff.GetUInt8());
      end;
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledAeQualifier):////SourceDiagnostic $A3
      begin
        //len :=
        buff.GetUInt8();
        // ACSE service user tag.
        //tag :=
        buff.GetUInt8();
        //len :=
        buff.GetUInt8();
        // Result source diagnostic component.
        if buff.GetUInt8() <> Byte(TBerType.btInteger) Then
          raise EArgumentException.Create('Invalid tag.');

        if buff.GetUInt8() <> 1 Then
          raise EArgumentException.Create('Invalid tag.');

        Result := TSourceDiagnostic(buff.GetUInt8());
      end;
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledApInvocationId):
      begin
        //Result $A4
        //Get len.
        if buff.GetUInt8() <> $A Then
          raise EArgumentException.Create('Invalid tag.');

        //Choice for result (Universal, Octetstring type)
        if buff.GetUInt8() <> Byte(TBerType.btOctetString) Then
          raise EArgumentException.Create('Invalid tag.');

        //responding-AP-title-field
        //Get len.
        len := buff.GetUInt8();
        SetLength(tmp, len);
        buff.Get(tmp);
        settings.SourceSystemTitle := tmp;
        tmp := Nil;
      end;
      //Client Challenge.
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CallingApTitle)://$A6
      begin
        //len :=
        buff.GetUInt8();
        //tag :=
        buff.GetUInt8();
        len := buff.GetUInt8();
        SetLength(tmp, len);
        buff.Get(tmp);
        settings.SourceSystemTitle := tmp;
        tmp := Nil;
      end;
      //Server Challenge.
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.SenderAcseRequirements)://$AA
      begin
        //len :=
        buff.GetUInt8();
        //tag :=
        buff.GetUInt8();
        len := buff.GetUInt8();
        SetLength(tmp, len);
        buff.Get(tmp);
        settings.StoCChallenge := tmp;
        tmp := Nil;
      end;
      Byte(TBerType.btContext) or Byte(TPduType.SenderAcseRequirements),
      //$8A
      Byte(TBerType.btContext) or Byte(TPduType.CallingApInvocationId):
      //$88
      begin
        //Get sender ACSE-requirements field component.
        if buff.GetUInt8() <> 2 Then
        begin
            raise EArgumentException.Create('Invalid tag.');
        end;
        if buff.GetUInt8() <> Byte(TBerType.btObjectDescriptor) Then
        begin
            raise EArgumentException.Create('Invalid tag.');
        end;
        if buff.GetUInt8() <> $80 Then
        begin
            raise EArgumentException.Create('Invalid tag.');
        end;
      end;
      Byte(TBerType.btContext) or Byte(TPduType.MechanismName),//$8B
      Byte(TBerType.btContext) or Byte(TPduType.CallingAeInvocationId)://$89
        UpdateAuthentication(settings, buff);
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CallingAuthenticationValue)://$AC
        UpdatePassword(settings, buff);
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.UserInformation):
      begin
        //$BE
        //Check result component. Some meters are returning invalid user-information if connection failed.
        if (resultComponent <> TAssociationResult.Accepted) and
            (Result <> TSourceDiagnostic.None) Then
          raise TGXDLMSException.Create(resultComponent, Result);

        ParseUserInformation(settings, cipher, buff);
      end;
      else
      begin
        //Unknown tags.
        WriteLN('Unknown tag: ' + IntToStr(tag) + '.');
        if buff.Position < buff.Size Then
        begin
            len := buff.GetUInt8();
            buff.Position(buff.Position + len);
        end;
      end;
      end;
  end;
  //All meters don't send user-information if connection is failed.
  //For this reason result component is check again.
  if (resultComponent <> TAssociationResult.Accepted) and
      (Result <> TSourceDiagnostic.None) Then
    raise TGXDLMSException.Create(resultComponent, Result);
end;

class procedure TGXAPDU.UpdatePassword(settings: TGXDLMSSettings; buff: TGXByteBuffer);
var
  tmp: TBytes;
  len: Byte;
begin
  //len :=
  buff.GetUInt8();
  // Get authentication information.
  if buff.GetUInt8() <> $80 Then
      raise EArgumentException.Create('Invalid tag.');

  len := buff.GetUInt8();
  if settings.Authentication = TAuthentication.atLow Then
  begin
    SetLength(tmp, len);
    buff.Get(tmp);
    settings.Password := tmp;
  end
  else
  begin
    SetLength(tmp, len);
    buff.Get(tmp);
    settings.CtoSChallenge := tmp;
  end;
end;

class function TGXAPDU.GetUserInformation(settings: TGXDLMSSettings; cipher: TGXCiphering): TBytes;
var
  data, bb: TGXByteBuffer;
begin
    data:= TGXByteBuffer.Create();
    // Tag for xDLMS-Initiate response
    data.SetUInt8(Byte(TCommand.InitiateResponse));
    // NegotiatedQualityOfService (not used)
    data.SetUInt8($00);
    // DLMS Version Number
    data.SetUInt8(06);
    data.SetUInt8($5F);
    data.SetUInt8($1F);
    data.SetUInt8($04);// length of the conformance block
    data.SetUInt8($00);// encoding the number of unused bits in the bit string
    bb := TGXByteBuffer.Create();
    bb.SetUInt32(LongWord(settings.NegotiatedConformance));
    data.SetArray(bb.GetData(), 1, 3);
    FreeAndNil(bb);
    data.SetUInt16(settings.MaxPduSize);
    //VAA Name VAA name ($0007 for LN referencing and $FA00 for SN)
    if settings.UseLogicalNameReferencing Then
      data.SetUInt16($0007)
    else
      data.SetUInt16($FA00);

    if (cipher <> Nil) and cipher.IsCiphered Then
    begin
      Result := cipher.Encrypt(Byte(TCommand.GloInitiateResponse), cipher.SystemTitle, data.ToArray());
      Exit;
    end;
    Result := data.ToArray();
end;

//Server generates AARE message.
class procedure TGXAPDU.GenerateAARE(settings: TGXDLMSSettings; data: TGXByteBuffer;
  result: TAssociationResult; diagnostic: TSourceDiagnostic; cipher: TGXCiphering; encryptedData: TGXByteBuffer);
var
  offset: Integer;
  tmp: TBytes;
  tmp2: TGXByteBuffer;
begin
    offset := data.Size;
    // Set AARE tag and length
    data.SetUInt8(Byte(TBerType.btApplication) or Byte(TBerType.btConstructed) or Byte(TPduType.ApplicationContextName)); //$61
    // Length is updated later.
    data.SetUInt8(0);
    GenerateApplicationContextName(settings, data, cipher);
    //Result
    data.SetUInt8(Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TBerType.btInteger));//$A2
    data.SetUInt8(3); //len
    data.SetUInt8(Byte(TBerType.btInteger)); //Tag
    //Choice for result (INTEGER, universal)
    data.SetUInt8(1); //Len
    data.SetUInt8(Byte(result)); //ResultValue
    //SourceDiagnostic
    data.SetUInt8($A3);
    data.SetUInt8(5); //len
    data.SetUInt8($A1); //Tag
    data.SetUInt8(3); //len
    data.SetUInt8(2); //Tag
    // Choice for result (INTEGER, universal)
    data.SetUInt8(1); //Len
    data.SetUInt8(Byte(diagnostic)); //diagnostic

    //SystemTitle
    if (cipher <> Nil) and (cipher.IsCiphered or (settings.Authentication = TAuthentication.atHighGMAC)) Then
    begin
      data.SetUInt8(Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledApInvocationId));
      data.SetUInt8(2 + Length(cipher.SystemTitle));
      data.SetUInt8(Byte(TBerType.btOctetString));
      data.SetUInt8(Length(cipher.SystemTitle));
      data.SetArray(cipher.SystemTitle);
    end;

    if (result <> TAssociationResult.PermanentRejected) and (diagnostic = TSourceDiagnostic.AuthenticationRequired) Then
    begin
      //Add server ACSE-requirenents field component.
      data.SetUInt8($88);
      data.SetUInt8($02);  //Len.
      data.SetUInt16($0780);
      //Add tag.
      data.SetUInt8($89);
      data.SetUInt8($07);//Len
      data.SetUInt8($60);
      data.SetUInt8($85);
      data.SetUInt8($74);
      data.SetUInt8($05);
      data.SetUInt8($08);
      data.SetUInt8($02);
      data.SetUInt8(Byte(settings.Authentication));
      //Add tag.
      data.SetUInt8($AA);
      data.SetUInt8(2 + Length(settings.StoCChallenge));//Len
      data.SetUInt8(Byte(TBerType.btContext));
      data.SetUInt8(Length(settings.StoCChallenge));
      data.SetArray(settings.StoCChallenge);
    end;

    //Add User Information
    //Tag $BE
    data.SetUInt8(Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.UserInformation));
    if (encryptedData <> Nil) and (encryptedData.Size <> 0) Then
    begin
      tmp2 := TGXByteBuffer.Create(2 + encryptedData.Size);
      tmp2.SetUInt8(Byte(TCommand.GloInitiateResponse));
      TGXCommon.SetObjectCount(encryptedData.Size, tmp2);
      tmp2.SetArray(encryptedData);
      tmp := tmp2.ToArray();
      freeAndNil(tmp2);
    end
    else
      tmp := GetUserInformation(settings, cipher);

    data.SetUInt8(2 + Length(tmp));
    //Coding the choice for user-information (Octet STRING, universal)
    data.SetUInt8(Byte(TBerType.btOctetString));
    //Length
    data.SetUInt8(Length(tmp));
    data.SetArray(tmp);
    data.SetUInt8(offset + 1, data.Size - offset - 2);
    freeAndNil(tmp);
end;

end.

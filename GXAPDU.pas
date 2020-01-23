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
Gurux.DLMS.GXDLMSChippering, Gurux.DLMS.Security,
Gurux.DLMS.GXDLMSTranslatorStructure,
TranslatorOutputType,
TranslatorGeneralTags,
Gurux.DLMS.TranslatorTags, Gurux.DLMS.GXDLMSConverter;

type

// The services to access the attributes and methods of COSEM objects are
// determined on DLMS/COSEM Application layer. The services are carried by
// Application Protocol Data Units (APDUs).
// <p />In DLMS/COSEM the meter is primarily a server, and the controlling system
// is a client. Also unsolicited (received without a request) messages are available.
TGXAPDU = class
  class procedure Parse(
      initiateRequest: Boolean;
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      data: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      tag: WORD);

  class procedure ParseInitiate(
      initiateRequest: Boolean;
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      data: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure);

  // Parse User Information from PDU.
  class procedure ParseUserInformation(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      data: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure);

  // Retrieves the string that indicates the level of authentication, if any.
  class procedure GetAuthenticationString(
      settings: TGXDLMSSettings;
      data: TGXByteBuffer);

  // Code application context name.
  class procedure GenerateApplicationContextName(
      settings: TGXDLMSSettings;
      data: TGXByteBuffer;
      cipher: TGXCiphering);

  // Generate User information initiate request.
  class procedure GetInitiateRequest(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      data: TGXByteBuffer);

  // Parse application context name.
  class function ParseApplicationContextName(
      settings: TGXDLMSSettings;
      buff: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure): Boolean;

  class procedure UpdateAuthentication(
      settings: TGXDLMSSettings;
      buff: TGXByteBuffer);

  class procedure UpdatePassword(
      settings: TGXDLMSSettings;
      buff: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure);

  class function GetUserInformation(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering): TBytes;

  //Server generates AARE message.
  class procedure GenerateAARE(
      settings: TGXDLMSSettings;
      data: TGXByteBuffer;
      result: TAssociationResult;
      diagnostic: TSourceDiagnostic;
      cipher: TGXCiphering;
      encryptedData: TGXByteBuffer);

  class procedure AppendServerSystemTitleToXml(
      settings: TGXDLMSSettings;
      xml: TGXDLMSTranslatorStructure;
      tag: BYTE);

  public
  // Generate user information.
  class procedure GenerateUserInformation(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      encryptedData: TGXByteBuffer;
      data: TGXByteBuffer);

  // Generates Aarq.
  class procedure GenerateAarq(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      encryptedData: TGXByteBuffer;
      data: TGXByteBuffer);static;

  // Parse APDU.
  class function ParsePDU(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      buff: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure): TSourceDiagnostic;

  class function ParsePDU2(
      settings: TGXDLMSSettings;
      cipher: TGXCiphering;
      buff: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure): TSourceDiagnostic;

  class procedure GetConformance(
    value: UInt32;
    xml: TGXDLMSTranslatorStructure); static;

end;

implementation
uses TranslatorStandardTags, TranslatorSimpleTags;

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
  //ProtocolVersion
  if settings.ProtocolVersion <> '' Then
  begin
    data.SetUInt8(Integer(TBerType.btContext) or Integer(TPduType.ProtocolVersion));
    data.SetUInt8(2);
    data.SetUInt8(8 - Length(settings.protocolVersion));
    TGXCommon.SetBitString(data, settings.ProtocolVersion, False);
  end;
  //Application context name tag
  data.SetUInt8(Integer(TBerType.btContext) or Integer(TBerType.btConstructed) or Integer(TPduType.ApplicationContextName));
  //Len
  data.SetUInt8($09);
  data.SetUInt8(Integer(TBerType.btObjectIdentifier));
  //Len
  data.SetUInt8($07);
  ciphered := (cipher <> Nil) and cipher.IsCiphered;
  data.SetUInt8($60);
  data.SetUInt8($85);
  data.SetUInt8($74);
  data.SetUInt8($5);
  data.SetUInt8($8);
  data.SetUInt8($1);
  if settings.UseLogicalNameReferencing Then
    if ciphered then
      data.SetUInt8(3)
    else
      data.SetUInt8(1)
  else
    if ciphered then
      data.SetUInt8(4)
    else
      data.SetUInt8(2);

  //Add system title if cipher or GMAC authentication is used..
  if Not settings.IsServer and ciphered or (settings.Authentication = TAuthentication.atHighGMAC) Then
  begin
    if Length(cipher.SystemTitle) <> 8 Then
      raise EArgumentException.Create('Invalid SystemTitle');
    //Add calling-AP-title
    data.SetUInt8(BYTE(TBerType.btContext) or BYTE(TBerType.btConstructed) or BYTE(TPduType.CallingApTitle));
    //LEN
    data.SetUInt8(2 + Length(cipher.SystemTitle));
    data.SetUInt8(BYTE(TBerType.btOctetString));
    //LEN
    data.SetUInt8(Length(cipher.SystemTitle));
    data.SetArray(cipher.SystemTitle);
  end;
  //Add CallingAEInvocationId.
  if Not settings.IsServer and (settings.UserId <> 0) Then
  begin
    data.SetUInt8(BYTE(TBerType.btContext) or BYTE(TBerType.btConstructed) or BYTE(TPduType.CallingAeInvocationId));
    //LEN
    data.SetUInt8(3);
    data.SetUInt8(BYTE(TBerType.btInteger));
    //LEN
    data.SetUInt8(1);
    data.SetUInt8(settings.UserId);
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
  try
    bb.SetUInt32(Integer(settings.ProposedConformance));
    data.SetArray(bb.SubArray(1, 3));
    data.SetUInt16(settings.MaxPduSize);
  finally
    FreeAndNil(bb);
  end;
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
      try
        GetInitiateRequest(settings, cipher, tmp);
        crypted := cipher.Encrypt(Integer(TCommand.GloInitiateRequest), cipher.SystemTitle, tmp.ToArray());
      finally
        FreeAndNil(tmp);
      end;
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
  data.SetUInt8(offset, byte(data.Size - offset - 1));
end;

class procedure TGXAPDU.GetConformance(
    value: UInt32;
    xml: TGXDLMSTranslatorStructure);
var
  str: string;
  tmp: UInt32;
  it: BYTE;
begin
  tmp := 1;
  if xml.OutputType = TTranslatorOutputType.SimpleXml Then
  begin
    for it := 0 to 23 do
    begin
      if (tmp and value) <> 0 Then
      begin
        str := TTranslatorSimpleTags.ConformanceToString(TConformance(tmp));
        xml.AppendLine(UInt32(TTranslatorGeneralTags.ConformanceBit), 'Name', str);
      end;
      tmp := tmp shl 1;
    end;
  end
  else
  begin
    for it := 0 to 23 do
    begin
      if (tmp and value) <> 0 Then
      begin
        str := TTranslatorStandardTags.ConformanceToString(TConformance(tmp));
        str := str + ' ';
        xml.Append(str);
      end;
      tmp := tmp shl 1;
    end;
  end;
end;

class procedure TGXAPDU.Parse(
    initiateRequest: Boolean;
    settings: TGXDLMSSettings;
    cipher: TGXCiphering;
    data: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    tag: WORD);
var
  len: Integer;
  response: Boolean;
  tmp: TBytes;
  bb: TGXByteBuffer;
  v: LongWord;
  vaa, pdu: WORD;
  se: TServiceError;
  str, value: string;
  ver: BYTE;
begin
  response := tag = Integer(TCommand.InitiateResponse);
  if response Then
  begin
    //<InitiateResponse>
    if xml <> Nil Then
      xml.AppendStartTag(LONGWORD(TCommand.InitiateResponse));

    //Optional usage field of the negotiated quality of service component
    tag := data.GetUInt8();
    if tag <> 0 Then
    begin
      settings.QualityOfService := data.GetUInt8();
      //NegotiatedQualityOfService
      if xml <> Nil Then
          xml.AppendLine(UInt32(TranslatorGeneralTags.NegotiatedQualityOfService),
              '', xml.IntegerToHex(settings.QualityOfService, 2));
    end;
  end
  else if tag = Byte(TCommand.InitiateRequest) Then
  begin
      //<InitiateRequest>
      if xml <> Nil Then
        xml.AppendStartTag(LONGWORD(TCommand.InitiateRequest));
      //Optional usage field of dedicated key.
      tag := data.GetUInt8();
      if settings.Cipher <> Nil Then
        settings.Cipher.DedicatedKey := Nil;
      if tag <> 0 Then
      begin
          len := data.GetUInt8();
          SetLength(tmp, len);
          data.Get(tmp);
          if settings.Cipher <> Nil Then
            settings.Cipher.DedicatedKey := tmp;
          if xml <> Nil Then
              xml.AppendLine(LONGWORD(TTranslatorGeneralTags.DedicatedKey), '', TGXByteBuffer.ToHexString(tmp, False, 0, Length(tmp)));
      end;
      //Optional usage field of the negotiated quality of service component
      tag := data.GetUInt8();
      if tag <> 0 Then
      begin
          settings.QualityOfService := data.GetUInt8();
          if (xml <> Nil) and (initiateRequest or (xml.OutputType = TTranslatorOutputType.SimpleXml)) Then
              xml.AppendLine(LONGWORD(TranslatorGeneralTags.ProposedQualityOfService), '', IntToStr(settings.QualityOfService));
      end
      else
        if (xml <> Nil) and (xml.OutputType = TTranslatorOutputType.StandardXml) Then
            xml.AppendLine(LONGWORD(TTranslatorTags.ResponseAllowed), '', 'true');
      //Optional usage field of the proposed quality of service component
      tag := data.GetUInt8();
      if tag <> 0 Then
      begin
        settings.QualityOfService := data.GetUInt8();
        if (xml <> Nil) and (xml.OutputType = TTranslatorOutputType.SimpleXml) Then
            xml.AppendLine(LONGWORD(TranslatorGeneralTags.ProposedQualityOfService), '', IntToStr(settings.QualityOfService));
      end;
  end
  else if tag = Integer(TCommand.ConfirmedServiceError) Then
    if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TCommand.ConfirmedServiceError));
      if xml.OutputType = TTranslatorOutputType.StandardXml Then
      begin
        data.GetUInt8();
        xml.AppendStartTag(LONGWORD(TTranslatorTags.InitiateError));
        se := TServiceError(data.GetUInt8());
        str := TTranslatorStandardTags.ServiceErrorToString(se);
        value := TTranslatorStandardTags.GetServiceErrorValue(se, data.GetUInt8());
        xml.AppendLine('x:' + str, '', value);
        xml.AppendEndTag(LONGWORD(TTranslatorTags.InitiateError));
      end
      else
      begin
        xml.AppendLine(LONGWORD(TTranslatorTags.Service), '', xml.IntegerToHex(data.GetUInt8(), 2));
        se := TServiceError(data.GetUInt8());
        xml.AppendStartTag(LONGWORD(TTranslatorTags.ServiceError));
        xml.AppendLine(TTranslatorSimpleTags.ServiceErrorToString(se), '',
                TTranslatorSimpleTags.GetServiceErrorValue(se, data.GetUInt8()));
        xml.AppendEndTag(LONGWORD(TTranslatorTags.ServiceError));
      end;
      xml.AppendEndTag(LONGWORD(TCommand.ConfirmedServiceError));
      Exit;
    end
    else
      raise TGXDLMSConfirmedServiceError.Create(
              TConfirmedServiceError(data.GetUInt8()),
              TServiceError(data.GetUInt8()), data.GetUInt8())
  else
    raise EArgumentException.Create('Invalid tag.');

  //Get DLMS version number.
  if Not response Then
  begin
    //ProposedDlmsVersionNumber
    ver := data.GetUInt8();
    //ProposedDlmsVersionNumber
    if (xml <> Nil) and (initiateRequest or (xml.OutputType = TTranslatorOutputType.SimpleXml)) Then
        xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ProposedDlmsVersionNumber), '', xml.IntegerToHex(ver, 2))
    else if ver <> 6 Then
        raise TGXDLMSConfirmedServiceError.Create(
            TConfirmedServiceError.InitiateError,
            TServiceError.Initiate,
            Byte(TInitiate.DlmsVersionTooLow));
  end
  else
  begin
    ver := data.GetUInt8();
    if (xml <> Nil) and (initiateRequest or (xml.OutputType = TTranslatorOutputType.SimpleXml)) Then
        xml.AppendLine(LONGWORD(TTranslatorGeneralTags.NegotiatedDlmsVersionNumber), '', xml.IntegerToHex(ver, 2))
    else if ver <> 6 Then
      raise EArgumentException.Create('Invalid DLMS version number.');
  end;
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
  try
    SetLength(tmp, 3);
    data.Get(tmp);
    bb.SetUInt8(0);
    bb.SetArray(tmp);
    v := bb.GetUInt32();
  finally
    FreeAndNil(bb);
  end;
  if settings.IsServer Then
    if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TTranslatorGeneralTags.ProposedConformance));
      GetConformance(v, xml);
    end
    else
      settings.NegotiatedConformance := TConformance(v and Integer(settings.ProposedConformance))
  else
  begin
   if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TTranslatorGeneralTags.NegotiatedConformance));
      GetConformance(v, xml);
    end
    else
      settings.NegotiatedConformance := TConformance(v);
  end;

  if Not response Then
  begin
    //Proposed max PDU size.
    pdu := data.GetUInt16();
    //If PDU is too low.
    if xml <> Nil Then
    begin
      // ProposedConformance closing
      if xml.OutputType = TTranslatorOutputType.SimpleXml Then
        xml.AppendEndTag(LONGWORD(TTranslatorGeneralTags.ProposedConformance))
      else if initiateRequest Then
        xml.Append(LONGWORD(TTranslatorGeneralTags.ProposedConformance), false);
      // ProposedMaxPduSize
      xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ProposedMaxPduSize),
          '', xml.IntegerToHex(pdu, 4));
    end
    else if pdu < 64 Then
      raise TGXDLMSConfirmedServiceError.Create(
                TConfirmedServiceError.InitiateError,
                TServiceError.Service, Integer(TService.PduSize));

    settings.MaxPduSize := pdu;
    //If client asks too high PDU.
    if settings.MaxPduSize > settings.MaxServerPDUSize Then
      settings.MaxPduSize := settings.MaxServerPDUSize;
  end
  else
  begin
    //Max PDU size.
    settings.MaxPduSize := data.GetUInt16();
    if xml <> Nil Then
    begin
        // NegotiatedConformance closing
      if xml.OutputType = TTranslatorOutputType.SimpleXml Then
        xml.AppendEndTag(LONGWORD(TTranslatorGeneralTags.NegotiatedConformance))
      else if initiateRequest Then
        xml.Append(LONGWORD(TTranslatorGeneralTags.NegotiatedQualityOfService), False);
        // NegotiatedMaxPduSize
        xml.AppendLine(LONGWORD(TTranslatorGeneralTags.NegotiatedMaxPduSize),
            '', xml.IntegerToHex(settings.MaxPduSize, 4));
    end;
  end;
  if response Then
  begin
    // VAA Name
    vaa := data.GetUInt16();
    if xml <> Nil Then
    begin
      if initiateRequest or (xml.OutputType = TTranslatorOutputType.SimpleXml) Then
        xml.AppendLine(LONGWORD(TTranslatorGeneralTags.VaaName), '', xml.IntegerToHex(vaa, 4));
    end;
    if vaa = $0007 Then
    begin
      // If LN
      if initiateRequest Then
        settings.UseLogicalNameReferencing := True
      else if Not settings.UseLogicalNameReferencing and (xml = Nil) Then
        raise EArgumentException.Create('Invalid VAA.');
    end
    else if vaa = $FA00 Then
    begin
      // If SN
      if initiateRequest Then
        settings.UseLogicalNameReferencing := False
      else if settings.UseLogicalNameReferencing and (xml = Nil) Then
          raise EArgumentException.Create('Invalid VAA.');
    end
    else
      raise EArgumentException.Create('Invalid VAA.');
    if xml <> Nil Then
      xml.AppendEndTag(LONGWORD(TCommand.InitiateResponse));
  end
  else if xml <> Nil Then
    xml.AppendEndTag(LONGWORD(TCommand.InitiateRequest));
end;

class procedure TGXAPDU.ParseInitiate(
    initiateRequest: Boolean;
    settings: TGXDLMSSettings;
    cipher: TGXCiphering;
    data: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);
var
  p: TAesGcmParameter;
  tag1, tag: Byte;
  tmp: TBytes;
  pos, cnt, originalPos: Integer;
  encrypted, st: TBytes;
begin
  //Tag for xDLMS-Initate.response
  tag := data.GetUInt8();
  if (tag = Integer(TCommand.GloInitiateResponse)) or
    (tag = Integer(TCommand.GloInitiateRequest)) or
    (tag = Integer(TCommand.DedInitiateResponse)) or
    (tag = Integer(TCommand.DedInitiateRequest)) or
    (tag = Integer(TCommand.GeneralGloCiphering)) or
    (tag = Integer(TCommand.GeneralDedCiphering)) Then
  begin
    if xml <> Nil Then
    begin
      originalPos := data.Position;
      if (tag = Integer(TCommand.GeneralGloCiphering)) or
          (tag = Integer(TCommand.GeneralDedCiphering)) Then
      begin
        cnt := TGXCommon.GetObjectCount(data);
        SetLength(st, cnt);
        data.Get(st);
      end
      else
        st := settings.SourceSystemTitle;

      cnt := TGXCommon.GetObjectCount(data);
      SetLength(encrypted, cnt);
      data.Get(encrypted);
      if (st <> Nil) and (cipher <> Nil) and (xml.Comments) Then
      begin
        pos := xml.GetXmlLength();
        try
          data.Position := originalPos - 1;
          p := TAesGcmParameter.Create(st, settings.Cipher.BlockCipherKey, settings.Cipher.AuthenticationKey);
          p.Xml := xml;
          tmp := TGXDLMSChippering.DecryptAesGcm(p, data);
          data.Clear();
          data.SetArray(tmp);
          cipher.Security := p.Security;
          tag1 := data.GetUInt8();
          xml.StartComment('Decrypted data:');
          xml.AppendLine('Security: ' + TGXDLMSConverter.ToString(p.Security));
          xml.AppendLine('Invocation Counter: ' + IntToStr(p.InvocationCounter));
          Parse(initiateRequest, settings, cipher, data, xml, tag1);
          xml.EndComment();
        except
          // It's OK if this fails.
          xml.SetXmlLength(pos);
        end;
      end;
      xml.AppendLine(tag, '', TGXCommon.ToHexString(encrypted, False, 0, Length(encrypted)));
      Exit
    end
    else
    begin
      data.Position := (data.Position - 1);
      p := TAesGcmParameter.Create(settings.SourceSystemTitle, settings.Cipher.BlockCipherKey, settings.Cipher.AuthenticationKey);
      try
        tmp := TGXDLMSChippering.DecryptAesGcm(p, data);
        data.Clear();
        data.SetArray(tmp);
        cipher.Security := p.Security;
        tag := data.GetUInt8();
      finally
        p.Free;
      end;
    end;
  end;
  Parse(initiateRequest, settings, cipher, data, xml, tag);
end;

class procedure TGXAPDU.ParseUserInformation(
    settings: TGXDLMSSettings;
    cipher: TGXCiphering;
    data: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);
var
  tag, len: Byte;
begin
  len := data.GetUInt8();
  if data.Size - data.Position < len Then
  begin
    if xml = Nil Then
      raise EArgumentException.Create('Not enough data.');
    xml.AppendComment('Error: Invalid data size.');
  end;

  //Excoding the choice for user information
  tag := data.GetUInt8();
  if tag <> $4 Then
    raise EArgumentException.Create('Invalid tag.');

  len := data.GetUInt8();
  if data.Size - data.Position < len Then
  begin
    if xml = Nil Then
      raise EArgumentException.Create('Not enough data.');
    xml.AppendComment('Error: Invalid data size.');
  end;
  ParseInitiate(false, settings, cipher, data, xml);
end;

class function TGXAPDU.ParseApplicationContextName(
    settings: TGXDLMSSettings;
    buff: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure): Boolean;
var
  len: Byte;
  tmp: TBytes;
  name: Byte;
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
  len := buff.GetUInt8();
  SetLength(tmp, len);
  buff.Get(tmp);
  if (tmp[0] <> $60) or
      (tmp[1] <> $85) or
      (tmp[2] <> $74) or
      (tmp[3] <> $5) or
      (tmp[4] <> $8) or
      (tmp[5] <> $1) Then
      if xml <> Nil Then
      begin
          xml.AppendLine(UInt32(TTranslatorGeneralTags.ApplicationContextName), '', 'UNKNOWN');
          Result := true;
          Exit;
      end
      else
        raise EArgumentException.Create('Encoding failed. Invalid Application context name.');
  name := tmp[6];
  if xml <> Nil Then
  begin
    if name = 1 Then
    begin
        if xml.OutputType = TTranslatorOutputType.SimpleXml Then
            xml.AppendLine(LONGWORD(TranslatorGeneralTags.ApplicationContextName), '', 'LN')
        else
            xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', '1');
        settings.UseLogicalNameReferencing := True;
    end
    else if name = 3 Then
    begin
      if xml.OutputType = TTranslatorOutputType.SimpleXml Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', 'LN_WITH_CIPHERING')
      else
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', '3');
        settings.UseLogicalNameReferencing := true;
    end
    else if name = 2 Then
    begin
      if xml.OutputType = TTranslatorOutputType.SimpleXml Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', 'SN')
      else
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', '2');
      settings.UseLogicalNameReferencing := false;
    end
    else if name = 4 Then
    begin
      if xml.OutputType = TTranslatorOutputType.SimpleXml Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', 'SN_WITH_CIPHERING')
      else
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName),'', '4');
      settings.UseLogicalNameReferencing := false;
    end
    else
    begin
        if xml.OutputType = TTranslatorOutputType.SimpleXml Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', 'UNKNOWN')
        else
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ApplicationContextName), '', '5');
      Result := false;
      Exit;
    end;
    Result := True;
    Exit;
  end;
  if settings.UseLogicalNameReferencing Then
    Result := (name = 1) or (name = 3)
  else
    Result := (name = 2) or (name = 4);
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

class function TGXAPDU.ParsePDU(
    settings: TGXDLMSSettings;
    cipher: TGXCiphering;
    buff: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure): TSourceDiagnostic;
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
  if xml = Nil Then
    raise EArgumentException.Create('Not enough data.')
  else
    xml.AppendComment('Error: Invalid data size.');
  //Opening tags
  if xml <> Nil Then
    if settings.IsServer Then
      xml.AppendStartTag(LONGWORD(TCommand.Aarq))
    else
      xml.AppendStartTag(LONGWORD(TCommand.Aare));
  Result := ParsePDU2(settings, cipher, buff, xml);
  //Closing tags
  if xml <> Nil Then
    if settings.IsServer Then
      xml.AppendEndTag(LONGWORD(TCommand.Aarq))
    else
      xml.AppendEndTag(LONGWORD(TCommand.Aare));
end;

class function TGXAPDU.ParsePDU2(
    settings: TGXDLMSSettings;
    cipher: TGXCiphering;
    buff: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure): TSourceDiagnostic;
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
        if Not ParseApplicationContextName(settings, buff, xml) Then
            raise TGXDLMSException.Create(TAssociationResult.PermanentRejected, TSourceDiagnostic.ApplicationContextNameNotSupported);
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledApTitle)://$A2
      begin
        //Get len.
        if buff.GetUInt8() <> 3 Then
          raise EArgumentException.Create('Invalid tag.');

        if settings.IsServer Then
        begin
          //tag :=
          buff.GetUInt8();
          len := buff.GetUInt8();
          SetLength(tmp, len);
          buff.Get(tmp);
          settings.SourceSystemTitle := tmp;
          if xml <> Nil Then
            xml.AppendLine(LONGWORD(TTranslatorTags.CalledAPTitle), '',
              TGXCommon.ToHexString(tmp, False, 0, Length(tmp)));
          tmp := Nil;
        end
        else
        begin
          // Choice for result (INTEGER, universal)
          //tag :=
          buff.GetUInt8();
          //len :=
          buff.GetUInt8();
          tag := buff.GetUInt8();
          if xml <> Nil Then
          begin
            if tag <> 0 Then
              xml.AppendComment(TGXDLMSConverter.ToString(TAssociationResult(tag)));
            xml.AppendLine(LONGWORD(TTranslatorGeneralTags.AssociationResult), '',
                xml.IntegerToHex(tag, 2));
            xml.AppendStartTag(LONGWORD(TTranslatorGeneralTags.ResultSourceDiagnostic));
          end;
        end;
      end;
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledAeQualifier):////SourceDiagnostic $A3
      begin
        //len :=
        buff.GetUInt8();
        // ACSE service user tag.
        //tag :=
        buff.GetUInt8();
        len := buff.GetUInt8();
        if settings.IsServer Then
        begin
          SetLength(tmp, len);
          if xml <> Nil Then
            xml.AppendLine(LONGWORD(TTranslatorTags.CalledAEQualifier), '',
                TGXCommon.ToHexString(tmp, False, 0, Length(tmp)));
        end
        else
        begin
          // Result source diagnostic component.
          //tag :=
          buff.GetUInt8();
          len := buff.GetUInt8();
          if len <> 1 Then
            raise EArgumentException.Create('Invalid tag.');
          Result := TSourceDiagnostic(buff.GetUInt8());
          if xml <> Nil Then
          begin
            if Result <> TSourceDiagnostic.None Then
              xml.AppendComment(TGXDLMSConverter.ToString(Result));
            xml.AppendLine(LONGWORD(TTranslatorGeneralTags.ACSEServiceUser),
                '', xml.IntegerToHex(Integer(Result), 2));
            xml.AppendEndTag(LONGWORD(TTranslatorGeneralTags.ResultSourceDiagnostic));
          end;
        end;
      end;
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledApInvocationId):
      begin
        //Result $A4
        //Get len.
        if buff.GetUInt8() <> $A Then
          raise EArgumentException.Create('Invalid tag.');

        if settings.IsServer Then
        begin
          //tag :=
          buff.GetUInt8();
          //Choice for result (Universal, Integer)
          len := buff.GetUInt8();
          if len <> 1 Then
            raise EArgumentException.Create('Invalid tag.');
          //Get value.
          tag := buff.GetUInt8();
          if xml <> Nil Then
            xml.AppendLine(LONGWORD(TTranslatorTags.CalledAPInvocationId),
                '', xml.IntegerToHex(tag, 2));
        end
        else
        begin
          //tag :=
          buff.GetUInt8();
            // responding-AP-title-field
            // Get len.
          len := buff.GetUInt8();
          SetLength(tmp, len);
          buff.Get(tmp);
          settings.SourceSystemTitle := tmp;
          if xml <> Nil Then
            xml.AppendLine(LONGWORD(TTranslatorGeneralTags.RespondingAPTitle), '',
                TGXCommon.ToHexString(tmp, False, 0, Length(tmp)));
          tmp := Nil;
        end;
      end;
      //Client Client system title.
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
        if xml <> Nil Then
          //CallingAPTitle
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.CallingAPTitle), '',
              TGXCommon.ToHexString(tmp, False, 0, Length(tmp)));
        tmp := Nil;
      end;
      //Server system title.
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.SenderAcseRequirements)://$AA
      begin
        //len :=
        buff.GetUInt8();
        tag := buff.GetUInt8();
        len := buff.GetUInt8();
        SetLength(tmp, len);
        buff.Get(tmp);
        settings.StoCChallenge := tmp;
        tmp := Nil;
        AppendServerSystemTitleToXml(settings, xml, tag);
      end;
      //Client AEInvocationId.
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CallingAeInvocationId)://$A9
      begin
        //len :=
        buff.GetUInt8();
        //tag :=
        buff.GetUInt8();
        //len :=
        buff.GetUInt8();
        settings.UserID := buff.GetUInt8();
        if xml <> Nil Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.CallingAeInvocationId), '', xml.IntegerToHex(settings.UserID, 2));
      end;
      //Client CalledAeInvocationId.
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CalledAeInvocationId)://$A5
      begin
      if settings.IsServer Then
      begin
        tag := buff.GetUInt8();
        if tag <> 3 Then
          raise EArgumentException.Create('Invalid tag.');

        len := buff.GetUInt8();
        if len <> 2 Then
          raise EArgumentException.Create('Invalid tag.');
        tag := buff.GetUInt8();
        if tag <> 1 Then
          raise EArgumentException.Create('Invalid tag.');
        tag := buff.GetUInt8();
        if xml <> Nil Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.CalledAeInvocationId),
              '', xml.IntegerToHex(tag, 2));
      end
      else
      begin
        //len :=
        buff.GetUInt8();
        //tag :=
        buff.GetUInt8();
        //len :=
        buff.GetUInt8();
        settings.UserID := buff.GetUInt8();
        if xml <> Nil Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.CalledAeInvocationId), '',
              xml.IntegerToHex(settings.UserID, 2));
      end;
      end;
      //Server RespondingAEInvocationId.
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or 7://$A7
      begin
        //len :=
        buff.GetUInt8();
        //tag :=
        buff.GetUInt8();
        //len :=
        buff.GetUInt8();
        settings.UserID := buff.GetUInt8();
          if xml <> Nil Then
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.RespondingAeInvocationId), '',
              xml.IntegerToHex(settings.UserID, 2));
      end;
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CallingApInvocationId)://$A8
      begin
        len := buff.GetUInt8();
        if len <> 3 Then
          raise EArgumentException.Create('Invalid tag.');
        tag := buff.GetUInt8();
        if tag <> 2 Then
          raise EArgumentException.Create('Invalid tag.');
        len := buff.GetUInt8();
        if len <> 1 Then
          raise EArgumentException.Create('Invalid tag.');
        //Get value.
        tag := buff.GetUInt8();
        if xml <> Nil Then
          xml.AppendLine(LONGWORD(TTranslatorTags.CallingApInvocationId), '',
              xml.IntegerToHex(tag, 2));
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
        if xml <> Nil Then
          xml.AppendLine(tag, '', '1');
      end;
      Byte(TBerType.btContext) or Byte(TPduType.MechanismName),//$8B
      Byte(TBerType.btContext) or Byte(TPduType.CallingAeInvocationId)://$89
      begin
        UpdateAuthentication(settings, buff);
        if xml <> Nil Then
        begin
          if xml.OutputType = TTranslatorOutputType.SimpleXml Then
          begin
            xml.AppendLine(tag, '', TGXDLMSConverter.ToString(settings.Authentication));
          end
          else
          begin
            xml.AppendLine(tag, '', IntToStr(Integer(settings.Authentication)));
          end;
        end;
      end;
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.CallingAuthenticationValue)://$AC
        UpdatePassword(settings, buff, xml);
      Byte(TBerType.btContext) or Byte(TBerType.btConstructed) or Byte(TPduType.UserInformation):
      begin
        //$BE
        //Check result component. Some meters are returning invalid user-information if connection failed.
        if (resultComponent <> TAssociationResult.Accepted) and
            (Result <> TSourceDiagnostic.None) Then
          raise TGXDLMSException.Create(resultComponent, Result);

        ParseUserInformation(settings, cipher, buff, xml);
      end;
      else
      begin
        //Unknown tags.
        WriteLN('Unknown tag: ' + IntToStr(tag) + '.');
        if buff.Position < buff.Size Then
        begin
            len := buff.GetUInt8();
            buff.Position := (buff.Position + len);
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

class procedure TGXAPDU.UpdatePassword(
    settings: TGXDLMSSettings;
    buff: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);
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
  if xml <> Nil Then
  begin
    if xml.OutputType = TTranslatorOutputType.SimpleXml Then
    begin
      if settings.Authentication = TAuthentication.atLow Then
      begin
          if TGXCommon.IsAsciiString(settings.Password) Then
              xml.AppendComment(TEncoding.ASCII.GetString(settings.Password));
          xml.AppendLine(LONGWORD(TTranslatorGeneralTags.CallingAuthentication), '',
              TGXCommon.ToHexString(settings.Password, False, 0, Length(settings.Password)));
      end
      else
        xml.AppendLine(LONGWORD(TTranslatorGeneralTags.CallingAuthentication), '',
            TGXCommon.ToHexString(settings.CtoSChallenge, False, 0, Length(settings.CtoSChallenge)));
    end
    else
    begin
      xml.AppendStartTag(LONGWORD(TTranslatorGeneralTags.CallingAuthentication));
      xml.AppendStartTag(LONGWORD(TTranslatorGeneralTags.CharString));
      if settings.Authentication = TAuthentication.atLow Then
        xml.Append(TGXCommon.ToHexString(settings.Password, False, 0, Length(settings.Password)))
      else
        xml.Append(TGXCommon.ToHexString(settings.CtoSChallenge, False, 0, Length(settings.CtoSChallenge)));
      xml.AppendEndTag(LONGWORD(TTranslatorGeneralTags.CharString));
      xml.AppendEndTag(LONGWORD(TTranslatorGeneralTags.CallingAuthentication));
    end;
  end;
end;

class function TGXAPDU.GetUserInformation(settings: TGXDLMSSettings; cipher: TGXCiphering): TBytes;
var
  data, bb: TGXByteBuffer;
begin
  data := TGXByteBuffer.Create();
  try
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
    try
      bb.SetUInt32(LongWord(settings.NegotiatedConformance));
      data.SetArray(bb.GetData(), 1, 3);
    finally
      FreeAndNil(bb);
    end;
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
  finally
    data.Free;
  end;
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
      try
        tmp2.SetUInt8(Byte(TCommand.GloInitiateResponse));
        TGXCommon.SetObjectCount(encryptedData.Size, tmp2);
        tmp2.SetArray(encryptedData);
        tmp := tmp2.ToArray();
      finally
        FreeAndNil(tmp2);
      end;
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
end;

class procedure TGXAPDU.AppendServerSystemTitleToXml(
    settings: TGXDLMSSettings;
    xml: TGXDLMSTranslatorStructure;
    tag: BYTE);
begin
  if xml <> Nil Then
  begin
      // RespondingAuthentication
      if xml.OutputType = TTranslatorOutputType.SimpleXml Then
        xml.AppendLine(tag, '', TGXCommon.ToHexString(settings.StoCChallenge, False, 0, Length(settings.StoCChallenge)))
      else
      begin
        xml.Append(tag, true);
        xml.Append(LONGWORD(TTranslatorGeneralTags.CharString), true);
        xml.Append(TGXCommon.ToHexString(settings.StoCChallenge, False, 0, Length(settings.StoCChallenge)));
        xml.Append(LONGWORD(TTranslatorGeneralTags.CharString), false);
        xml.Append(tag, false);
        xml.Append(sLineBreak);
      end;
  end;
end;
end.

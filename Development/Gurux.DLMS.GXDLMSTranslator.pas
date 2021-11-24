//
// --------------------------------------------------------------------------
//  Gurux Ltd
//
//
//
// Filename:    $HeadURL$
//
// Version:     $Revision$,
//          $Date$
//          $Author$
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

unit Gurux.DLMS.GXDLMSTranslator;

interface
uses System.SysUtils, Generics.Collections, GXByteBuffer,
Gurux.DLMS.GXDLMSTranslatorStructure,
TranslatorOutputType, Gurux.DLMS.Security, Gurux.DLMS.SourceDiagnostic,
Gurux.DLMS.AssociationResult, Gurux.DLMS.GXReplyData, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Command, GXAPDU, HDLCInfo, Gurux.DLMS.LNCommandHandler,
Gurux.DLMS.SNCommandHandler, Gurux.DLMS.GXDLMS, ReleaseRequestReason,
ReleaseResponseReason, Gurux.DLMS.TranslatorTags, GXCommon, Gurux.DLMS.SecuritySuite,
Gurux.DLMS.ErrorCode,
GXDataInfo;

type
// Enumerates Translator output types.
TGXDLMSTranslator = class
  class procedure AddTag(list: TDictionary<LONGWORD, string>; value: LONGWORD; text: string); static;
private
  FSecurity: TSecurity;
  FSystemTitle: TBytes;
  FBlockCipherKey: TBytes;
  FAuthenticationKey: TBytes;
  FInvocationCounter: LongWord;
  FServerSystemTitle: TBytes;
  FDedicatedKey: TBytes;
  FOutputType: TTranslatorOutputType;
  FSAck, FRAck: WORD;
  FSending: Boolean;
  FSSendSequence: Byte;
  FSReceiveSequence: Byte;
  FRSendSequence: Byte;
  FRReceiveSequence: Byte;
  FComments: Boolean;
  FTags: TDictionary<LONGWORD, string>;
  FTagsByName: TDictionary<string, LONGWORD>;
  FPduOnly: Boolean;
  FCompletePdu: Boolean;
  FHex: Boolean;
  FShowStringAsHex: Boolean;
  FOmitXmlDeclaration: Boolean;
  FOmitXmlNameSpace: Boolean;
  // Sending data in multiple frames.
  FMultipleFrames: Boolean;

  class procedure GetTags(
    AType: TTranslatorOutputType;
    list: TDictionary<LONGWORD, string>;
    tagsByName: TDictionary<string, LONGWORD>);

  function PduToXml(
    value: TGXByteBuffer;
    omitDeclaration: boolean;
    omitNameSpace: boolean): string; overload;

  function PduToXml(
  xml: TGXDLMSTranslatorStructure;
  value: TGXByteBuffer;
  omitDeclaration: Boolean;
  omitNameSpace: Boolean;
  allowUnknownCommand: Boolean): string; overload;

  procedure GetCiphering(settings: TGXDLMSSettings; AForce: Boolean);
  procedure GetUa(data: TGXByteBuffer; xml: TGXDLMSTranslatorStructure);
public
  constructor Create(); overload;
  constructor Create(AType: TTranslatorOutputType); overload;

  destructor Destroy; override;

  // Are comments added.
  property Comments: Boolean read FComments write FComments;
  // Is only PDU shown when data is parsed with MessageToXml.
  property PduOnly: Boolean read FPduOnly write FPduOnly;
  //Used security.
  property Security: TSecurity read FSecurity write FSecurity;

  // System title.
  property SystemTitle: TBytes read FSystemTitle write FSystemTitle;
  // Block cipher key.
  property BlockCipherKey: TBytes read FBlockCipherKey write FBlockCipherKey;
  // Authentication key.
  property AuthenticationKey: TBytes read FAuthenticationKey write FAuthenticationKey;
  // Invocation Counter.
  property InvocationCounter: LongWord read FInvocationCounter write FInvocationCounter;
  // Server system title.
  property ServerSystemTitle: TBytes read FServerSystemTitle write FServerSystemTitle;
  // Dedicated key.
  property DedicatedKey: TBytes read FDedicatedKey write FDedicatedKey;

  // Convert bytes to xml.
  // value: Bytes to convert.
  // Returns Converted xml.
  function PduToXml(value: TGXByteBuffer): string; overload;

  function DataToXml(value: TGXByteBuffer): string;

  class function ErrorCodeToString(AType: TTranslatorOutputType; value: TErrorCode): string;
end;

implementation

uses TranslatorStandardTags, TranslatorSimpleTags, Gurux.DLMS.GXCiphering;

constructor TGXDLMSTranslator.Create();
begin
  Create(TTranslatorOutputType.SimpleXml);
end;

destructor TGXDLMSTranslator.Destroy;
begin
  if FTags <> Nil then
  begin
    FTags.Clear();
    FreeAndNil(FTags);
  end;
  if FTagsByName <> Nil then
  begin
    FTagsByName.Clear();
    FreeAndNil(FTagsByName);
  end;
  inherited;
end;

class procedure TGXDLMSTranslator.GetTags(
  AType: TTranslatorOutputType;
  list: TDictionary<LONGWORD, string>;
  tagsByName: TDictionary<string, LONGWORD>);
var
  lowercase: Boolean;
  it: TPair<LONGWORD, string>;
  str_: string;
begin
 if AType = TTranslatorOutputType.SimpleXml Then
 begin
  TTranslatorSimpleTags.GetGeneralTags(AType, list);
  TTranslatorSimpleTags.GetSnTags(AType, list);
  TTranslatorSimpleTags.GetLnTags(AType, list);
  TTranslatorSimpleTags.GetGloTags(AType, list);
  TTranslatorSimpleTags.GetDedTags(AType, list);
  TTranslatorSimpleTags.GetTranslatorTags(AType, list);
  TTranslatorSimpleTags.GetDataTypeTags(list);
  end
  else
  begin
  TTranslatorStandardTags.GetGeneralTags(AType, list);
  TTranslatorStandardTags.GetSnTags(AType, list);
  TTranslatorStandardTags.GetLnTags(AType, list);
  TTranslatorStandardTags.GetGloTags(AType, list);
  TTranslatorStandardTags.GetDedTags(AType, list);
  TTranslatorStandardTags.GetTranslatorTags(AType, list);
  TTranslatorStandardTags.GetDataTypeTags(list);
  end;
  // Simple is not case sensitive.
  lowercase := AType = TTranslatorOutputType.SimpleXml;
  for it in list do
  begin
  str_ := it.Value;
  if lowercase Then
    str_ := str_.ToLower();

  if Not tagsByName.ContainsKey(str_) Then
    tagsByName.Add(str_, it.Key);
  end;
end;

constructor TGXDLMSTranslator.Create(AType: TTranslatorOutputType);
begin
  FSecurity := TSecurity.None;
  FOutputType := AType;
  FTags := TDictionary<LONGWORD, string>.Create();
  FTagsByName := TDictionary<string, LONGWORD>.Create();
  GetTags(AType, FTags, FTagsByName);
  FSAck := 0;
  FRAck := 0;
  FSending := false;
  FSSendSequence := 0;
  FSReceiveSequence := 0;
  FRSendSequence := 0;
  FRReceiveSequence := 0;
  FComments := false;
  FPduOnly := false;
  FCompletePdu := false;
  FHex := false;
  FShowStringAsHex := false;
  FOmitXmlDeclaration := false;
  FOmitXmlNameSpace := false;
  FMultipleFrames := false;
  FSystemTitle := TEncoding.ASCII.GetBytes('ABCDEFGH');
  FServerSystemTitle := TEncoding.ASCII.GetBytes('ABCDEFGH');
  FBlockCipherKey := TBytes.Create($00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F);
  FAuthenticationKey := TBytes.Create($D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF);
  if AType = TTranslatorOutputType.SimpleXml Then FHex := true;
end;

class procedure TGXDLMSTranslator.AddTag(list: TDictionary<LONGWORD, string>; value: LONGWORD; text: string);
begin
  list.Add(value, text);
end;

function TGXDLMSTranslator.PduToXml(value: TGXByteBuffer; omitDeclaration: boolean; omitNameSpace: boolean): string;
var
  xml: TGXDLMSTranslatorStructure;
begin
  xml := TGXDLMSTranslatorStructure.Create(FOutputType, FOmitXmlNameSpace, FHex,
      FShowStringAsHex, FComments, FTags);
  try
    Result := PduToXml(xml, value, omitDeclaration, FOmitXmlNameSpace, True);
  finally
    FreeAndNil(xml);
  end;
end;

procedure TGXDLMSTranslator.GetCiphering(settings: TGXDLMSSettings; AForce: Boolean);
begin
  if settings.Cipher <> Nil then
  begin
    settings.Cipher.Free();
    settings.Cipher := Nil;
  end;
  if FSecurity <> TSecurity.None Then
  begin
    settings.Cipher := TGXCiphering.Create(FSystemTitle);
    settings.Cipher.Security := FSecurity;
    settings.Cipher.BlockCipherKey := FBlockCipherKey;
    settings.Cipher.AuthenticationKey := FAuthenticationKey;
    settings.Cipher.InvocationCounter := FInvocationCounter;
    settings.Cipher.DedicatedKey := FDedicatedKey;
    settings.Cipher.SourceSystemTitle := FServerSystemTitle;
  end
end;

procedure TGXDLMSTranslator.GetUa(data: TGXByteBuffer; xml: TGXDLMSTranslatorStructure);
var
  len: BYTE;
  id: THDLCInfo;
  value: LONGWORD;
begin
  // Skip FromatID
  data.GetUInt8();
  // Skip Group ID.
  data.GetUInt8();
  // Skip Group len
  data.GetUInt8();
  while (data.Position < data.Size) do
  begin
    id := THDLCInfo(data.GetUInt8());
    len := data.GetUInt8();
    case len of
    1:
    begin
    value := data.GetUInt8();
    end;
    2:
    begin
    value := data.GetUInt16();
    end;
    4:
    begin
    value := data.GetUInt32();
    end;
    else
    raise EArgumentException.Create('Invalid parameter');
    end;
    case id of
    THDLCInfo.MaxInfoTX:
    begin
      xml.AppendLine('<MaxInfoTX Value="' + IntToStr(value) + '" />');
    end;
    HDLCInfo.MaxInfoRX:
    begin
      xml.AppendLine('<MaxInfoRX Value="' + IntToStr(value) + '" />');
    end;
    HDLCInfo.WindowSizeTX:
    begin
      xml.AppendLine('<WindowSizeTX Value="' + IntToStr(value) + '" />');
    end;
    HDLCInfo.WindowSizeRX:
    begin
      xml.AppendLine('<WindowSizeRX Value="' + IntToStr(value) + '" />');
    end;
    else
    raise EArgumentException.Create('Invalid parameter');
    end;
  end;
end;

function TGXDLMSTranslator.PduToXml(
  xml: TGXDLMSTranslatorStructure;
  value: TGXByteBuffer;
  omitDeclaration: Boolean;
  omitNameSpace: Boolean;
  allowUnknownCommand: Boolean): string;
var
  str_: string;
  data: TGXReplyData;
  ch: BYTE;
  cmd: BYTE;
  len: WORD;
  cnt: Integer;
  settings: TGXDLMSSettings;
  s: TGXDLMSSettings;
  tmpStr: string;
  originalPosition, len2: Integer;
  st: TBytes;
begin
  settings := TGXDLMSSettings.Create(True);
  try
  GetCiphering(settings, False);
  cmd := value.GetUInt8();
  //If UA
  if cmd = $81 then
  begin
    value.Position := 0;
    GetUa(value, xml);
  end
  else
  case TCommand(cmd) of
  TCommand.AARQ:
  begin
    value.Position := 0;
    TGXAPDU.ParsePDU(settings, settings.Cipher, value, xml);
  end;
  TCommand.InitiateRequest:
  begin
    value.Position := 0;
    TGXAPDU.ParseInitiate(true, settings, settings.Cipher, value, xml);
  end;
  TCommand.InitiateResponse:
begin
    value.Position := 0;
    s := TGXDLMSSettings.Create(false);
  try
    GetCiphering(s, True);
    TGXAPDU.ParseInitiate(true, s, s.Cipher, value, xml);
  finally
    FreeAndNil(s);
  end;
  end;
  TCommand.AARE:
  begin
    value.Position := 0;
    s := TGXDLMSSettings.Create(false);
    try
      GetCiphering(s, True);
      TGXAPDU.ParsePDU(s, s.Cipher, value, xml);
    finally
      FreeAndNil(s);
    end;
  end;
  TCommand.GetRequest:
    TGXDLMSLNCommandHandler.HandleGetRequest(settings, Nil, value, Nil, xml, TCommand.None);
  TCommand.SetRequest:
    TGXDLMSLNCommandHandler.HandleSetRequest(settings, Nil, value, Nil, xml, TCommand.None);
  TCommand.ReadRequest:
    TGXDLMSSNCommandHandler.HandleReadRequest(settings, Nil, value, Nil, xml, TCommand.None);
  TCommand.MethodRequest:
    TGXDLMSLNCommandHandler.HandleMethodRequest(settings, Nil, value, Nil, Nil, xml, TCommand.None);
  TCommand.WriteRequest:
     TGXDLMSSNCommandHandler.HandleWriteRequest(settings, Nil, value, Nil, xml, TCommand.None);
  TCommand.AccessRequest:
    TGXDLMSLNCommandHandler.HandleAccessRequest(settings, Nil, value, Nil, xml, TCommand.None);
  TCommand.DataNotification:
  begin
    data := TGXReplyData.Create();
    try
      data.Xml := xml;
      data.Data := value;
      value.Position := 0;
      TGXDLMS.GetPdu(settings, data);
    finally
      data.Data := Nil;
      FreeAndNil(data);
    end;
  end;
  TCommand.InformationReport:
  begin
    data := TGXReplyData.Create();
    try
      data.Xml := xml;
      data.Data := value;
      TGXDLMSSNCommandHandler.HandleInformationReport(settings, data);
    finally
      data.Data := Nil;
      FreeAndNil(data);
    end;
  end;
  TCommand.EventNotification:
  begin
    data := TGXReplyData.Create();
    try
      data.Xml := xml;
      data.Data := value;
      TGXDLMSLNCommandHandler.HandleEventNotification(settings, data);
    finally
      data.Data := Nil;
      FreeAndNil(data);
    end;
  end;
  TCommand.ReadResponse, TCommand.WriteResponse, TCommand.GetResponse, TCommand.SetResponse, TCommand.MethodResponse, TCommand.AccessResponse, TCommand.GeneralBlockTransfer:
  begin
    data := TGXReplyData.Create();
    try
      data.Xml := xml;
      data.Data := value;
      value.Position := 0;
      TGXDLMS.GetPdu(settings, data);
    finally
      data.Data := Nil;
      FreeAndNil(data);
    end;
  end;
  TCommand.GeneralCiphering:
  begin
    data := TGXReplyData.Create();
    try
      data.Xml := xml;
      data.Data := value;
      value.Position := 0;
      TGXDLMS.GetPdu(settings, data);
    finally
      data.Data := Nil;
      FreeAndNil(data);
    end;
  end;
  TCommand.ReleaseRequest:
  begin
    xml.AppendStartTag(cmd);
    value.GetUInt8();
    // Len.
    if value.Available() <> 0 Then
    begin
    // BerType
    value.GetUInt8();
    // Len.
    value.GetUInt8();
    ch := value.GetUInt8();
    if xml.OutputType = TTranslatorOutputType.SimpleXml Then
      str_ := TTranslatorSimpleTags.ReleaseRequestReasonToString(TReleaseRequestReason(ch))
    else
      str_ := TTranslatorStandardTags.ReleaseRequestReasonToString(TReleaseRequestReason(ch));
    xml.AppendLine(LONGWORD(TTranslatorTags.Reason), '', str_);
    if value.Available() <> 0 Then
      try
        TGXAPDU.ParsePDU2(settings, settings.Cipher, value, xml);
      except
        // It's OK if this fails. Ciphering settings are not correct.
      end;
    end;
    xml.AppendEndTag(cmd);
  end;
  TCommand.ReleaseResponse:
  begin
    xml.AppendStartTag(cmd);
    ch := value.GetUInt8();
    if ch <> 0 Then
    begin
    //BerType
    value.GetUInt8();
    //Len.
    value.GetUInt8();
    ch := value.GetUInt8();
    if xml.OutputType = TTranslatorOutputType.SimpleXml Then
      str_ := TTranslatorSimpleTags.ReleaseResponseReasonToString(TReleaseResponseReason(ch))
    else
      str_ := TTranslatorStandardTags.ReleaseResponseReasonToString(TReleaseResponseReason(ch));
    xml.AppendLine(LONGWORD(TTranslatorTags.Reason), '', str_);
    if value.Available() <> 0 Then
      TGXAPDU.ParsePDU2(settings, settings.Cipher, value, xml);
    end;
    xml.AppendEndTag(cmd);
  end;
  TCommand.GloReadRequest, TCommand.GloWriteRequest,TCommand.GloGetRequest,TCommand.GloSetRequest, TCommand.GloMethodRequest,
  TCommand.GloReadResponse, TCommand.GloWriteResponse,TCommand.GloGetResponse,TCommand.GloSetResponse,TCommand.GloMethodResponse,
  TCommand.DedGetRequest, TCommand.DedSetRequest,TCommand.DedMethodRequest,
  TCommand.DedGetResponse,TCommand.DedSetResponse,TCommand.DedMethodResponse:
  begin
    if (settings.Cipher <> Nil) and FComments Then
    begin
      originalPosition := value.Position;
      len2 := xml.GetXmlLength();
      value.Position := value.Position - 1;
      case TCommand(cmd) of
      TCommand.GloReadRequest,
      TCommand.GloWriteRequest,
      TCommand.GloGetRequest,
      TCommand.GloSetRequest,
      TCommand.GloMethodRequest,
      TCommand.DedInitiateRequest,
      TCommand.DedGetRequest,
      TCommand.DedSetRequest,
      TCommand.DedMethodRequest:
        st := settings.Cipher.SystemTitle;
      else
        st := settings.SourceSystemTitle;
      end;
      if Length(st) <> 0 Then
      try
      settings.Cipher.Decrypt(st, settings.Cipher.BlockCipherKey, value);
      xml.StartComment('Decrypt data: ' + value.ToString());
      Result := PduToXml(xml, value, omitDeclaration, omitNameSpace, false);
      xml.EndComment();
      except
        // It's OK if this fails. Ciphering settings are not correct.
        xml.SetXmlLength(len2);
      end;
      value.Position := originalPosition;
    end;
    cnt := TGXCommon.GetObjectCount(value);
    if cnt <> (value.Size - value.Position) Then
    begin
    tmpStr := 'Invalid length: ';
    tmpStr := tmpStr + IntToStr(cnt);
    tmpStr := tmpStr + '. It should be: ';
    tmpStr := tmpStr + IntToStr(value.Available());
    xml.AppendComment(tmpStr);
    end;
    str_ := value.ToHex(False, value.Position, value.Available());
    xml.AppendLine(cmd, '', str_);
  end;
  TCommand.GeneralGloCiphering:
  begin
    if (settings.Cipher <> Nil) and FComments Then
    begin
      len2 := xml.GetXmlLength();
      originalPosition := value.Position;
      value.Position := value.Position - 1;
      //Check is this client msg.
      st := settings.Cipher.SystemTitle;
      if Length(st) <> 0 Then
      begin
        data.Data.Position := data.Data.Position - 1;
        settings.Cipher.Decrypt(settings.SourceSystemTitle,
          settings.Cipher.BlockCipherKey, data.Data);
        xml.StartComment('Decrypt data: ' + data.Data.ToHex(False, data.Data.Position, data.Data.Available));
        PduToXml(xml, data.Data, omitDeclaration, omitNameSpace, false);
        xml.EndComment();
      end;
      xml.SetXmlLength(len2);
      value.Position := originalPosition;
      value.Position := value.Position - 1;
      //Check is this server msg.
      st := settings.SourceSystemTitle;
      if Length(st) <> 0 Then
      begin
      try
        settings.Cipher.Decrypt(settings.SourceSystemTitle, settings.Cipher.BlockCipherKey, data.Data);
        xml.StartComment('Decrypt data: ' + data.Data.ToString());
        Result := PduToXml(xml, data.Data, omitDeclaration, omitNameSpace, False);
        xml.EndComment();
      except
        // It's OK if this fails. Ciphering settings are not correct.
        xml.SetXmlLength(len2);
      end;
      end;
      value.Position := originalPosition;
    end;
    len := TGXCommon.GetObjectCount(value);
    xml.AppendStartTag(LONGWORD(TCommand.GeneralGloCiphering));
    str_ := value.ToHex(False, value.Position, len);
    xml.AppendLine(LONGWORD(TTranslatorTags.SystemTitle), '', str_);
    len := TGXCommon.GetObjectCount(value);
    str_ := value.ToHex(False, value.Position, len);
    xml.AppendLine(LONGWORD(TTranslatorTags.CipheredService), '', str_);
    xml.AppendEndTag(LONGWORD(TCommand.GeneralGloCiphering));
  end;
  TCommand.ConfirmedServiceError:
  begin
    data := TGXReplyData.Create();
    try
      data.Xml := xml;
      data.Data := value;
      TGXDLMS.HandleConfirmedServiceError(data);
    finally
      data.Data := Nil;
      FreeAndNil(data);
    end;
  end
  else
  begin
    if Not allowUnknownCommand Then
     raise EArgumentException.Create('Invalid command.');
    str_ := '<Data="';
    value.Position := value.Position - 1;
    str_ := str_ + value.ToHex(False, value.Position, value.Available());
    str_ := str_ +'" />';
    xml.AppendLine(str_);
  end;
  end;
  if xml.OutputType = TTranslatorOutputType.StandardXml Then
  begin
    if Not omitDeclaration Then
      Result := Result + '<?xml version="1.0" encoding="utf-8"?>\r\n';
    if Not omitNameSpace Then
    begin
      if (TCommand(cmd) <> TCommand.Aare) and (TCommand(cmd) <> TCommand.Aarq) Then
      Result := Result + '<x:xDLMS-APDU xmlns:x="http://www.dlms.com/COSEMpdu">\r\n'
      else
      Result := Result + '<x:aCSE-APDU xmlns:x="http://www.dlms.com/COSEMpdu">\r\n';
    end;
    Result := Result + xml.ToString();
    if Not omitNameSpace Then
    begin
      if (TCommand(cmd) <> TCommand.Aare) and (TCommand(cmd) <> TCommand.Aarq) Then
      Result := Result + '</x:xDLMS-APDU>\r\n'
      else
      Result := Result + '</x:aCSE-APDU>\r\n';
    end;
    Exit;
  end;
  Result := xml.ToString();
finally
  FreeAndNil(settings);
end;
end;

function TGXDLMSTranslator.PduToXml(value: TGXByteBuffer): string;
begin
  Result := PduToXml(value, FOmitXmlDeclaration, FOmitXmlNameSpace);
end;

class function TGXDLMSTranslator.ErrorCodeToString(AType: TTranslatorOutputType; value: TErrorCode): string;
begin
  if AType = TTranslatorOutputType.StandardXml Then
    Result := TTranslatorStandardTags.ErrorCodeToString(value)
  else
    Result := TTranslatorSimpleTags.ErrorCodeToString(value);
end;

function TGXDLMSTranslator.DataToXml(value: TGXByteBuffer): string;
var
  di: TGXDataInfo;
  p: TGXDLMSTranslatorStructure;
begin
try
  di := TGXDataInfo.Create();
  try
  p := TGXDLMSTranslatorStructure.Create(FOutputType, FOmitXmlNameSpace, FHex,
      FShowStringAsHex, FComments, FTags);
      di.Xml := p;
  TGXCommon.GetData(value, di);
  Result := di.xml.ToString();
  finally
    FreeAndNil(p);
  end;
  finally
    FreeAndNil(di);
 end;
end;

end.

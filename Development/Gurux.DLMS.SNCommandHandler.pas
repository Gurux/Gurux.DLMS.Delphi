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

unit Gurux.DLMS.SNCommandHandler;

interface
uses SysUtils,
Rtti,
Gurux.DLMS.ObjectType,
Gurux.DLMS.GXDLMSTranslatorStructure,
Gurux.DLMS.TranslatorTags,
Gurux.DLMS.GXDLMSConverter,
Gurux.DLMS.GXDLMSObject,
GXByteBuffer,
Gurux.DLMS.ErrorCode,
GXDataInfo,
GXCommon,
Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSLNParameters,
TranslatorOutputType,
AccessServiceCommandType,
Gurux.DLMS.GXReplyData,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.VariableAccessSpecification,
Gurux.DLMS.GXDLMSSNParameters,
Gurux.DLMS.GXDLMS,
Gurux.DLMS.GXDLMSServerNotifier;

type
  TGXDLMSSNCommandHandler = class

  class procedure HandleReadRequest(
      settings: TGXDLMSSettings;
      server: TGXDLMSServerNotifier;
      data: TGXByteBuffer;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);

  class procedure HandleWriteRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);

  class procedure HandleRead(
    settings: TGXDLMSSettings;
    t: TVariableAccessSpecification;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);

 class procedure HandleReadBlockNumberAccess(
    settings: TGXDLMSSettings;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);

  class procedure HandleReadDataBlockAccess(
    settings: TGXDLMSSettings;
    command: TCommand;
    data: TGXByteBuffer;
    cnt: Integer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);

class procedure ReturnSNError(
    settings: TGXDLMSSettings;
    cmd: TCommand;
    error: TErrorCode;
    replyData: TGXByteBuffer);

  // Handle Information Report.
  class procedure HandleInformationReport(
      settings: TGXDLMSSettings;
      reply: TGXReplyData);

end;
implementation
uses Gurux.DLMS.GetCommandType, Gurux.DLMS.SingleReadResponse,
Gurux.DLMS.SetRequestType, Gurux.DLMS.ActionRequestType;

class procedure TGXDLMSSNCommandHandler.HandleReadRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  pos, cnt: Integer;
  ch: BYTE;
begin
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
    xml.AppendStartTag(LONGWORD(TCommand.ReadRequest), 'Qty', xml.IntegerToHex(cnt, 2), False);
  for pos := 1 to cnt do
  begin
    ch := data.GetUInt8();
    case TVariableAccessSpecification(ch) of
    TVariableAccessSpecification.VariableName, TVariableAccessSpecification.ParameterisedAccess:
      HandleRead(settings, TVariableAccessSpecification(ch), data, replyData, xml);
    TVariableAccessSpecification.BlockNumberAccess:
      HandleReadBlockNumberAccess(settings, data, replyData, xml);
    TVariableAccessSpecification.ReadDataBlockAccess:
      HandleReadDataBlockAccess(settings, TCommand.ReadResponse, data, cnt, replyData, xml, cipheredCommand);
    else
      ReturnSNError(settings, TCommand.ReadResponse, TErrorCode.ecReadWriteDenied, replyData);
    end;
  end;
  if xml <> Nil Then
    xml.AppendEndTag(LONGWORD(TCommand.ReadRequest));
end;

class procedure TGXDLMSSNCommandHandler.HandleWriteRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  pos, cnt: Integer;
  ch: BYTE;
  sn: WORD;
  di: TGXDataInfo;
begin
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
  begin
    xml.AppendStartTag(LONGWORD(TCommand.WriteRequest));
    xml.AppendStartTag(LONGWORD(TTranslatorTags.ListOfVariableAccessSpecification), 'Qty', xml.IntegerToHex(cnt, 2), False);
    if xml.OutputType = TTranslatorOutputType.StandardXml Then
      xml.AppendStartTag(LONGWORD(TTranslatorTags.VariableAccessSpecification));
  end;
  for pos := 1 to cnt do
  begin
    ch := data.GetUInt8();
    case TVariableAccessSpecification(ch) of
    TVariableAccessSpecification.VariableName:
    begin
      sn := data.GetUInt16();
      if xml <> Nil Then
          xml.AppendLine((LONGWORD(TCommand.WriteRequest) shl 8) or LONGWORD(TVariableAccessSpecification.VariableName),
              '', xml.IntegerToHex(sn, 4));
    end;
    TVariableAccessSpecification.WriteDataBlockAccess:
      HandleReadDataBlockAccess(settings, TCommand.WriteResponse, data, cnt, replyData, xml, cipheredCommand);
    end;
  end;
  if xml <> Nil Then
  begin
    if xml.OutputType = TTranslatorOutputType.StandardXml Then
        xml.AppendEndTag(LONGWORD(TTranslatorTags.VariableAccessSpecification));
    xml.AppendEndTag(LONGWORD(TTranslatorTags.ListOfVariableAccessSpecification));
  end;
  // Get data count.
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
    xml.AppendStartTag(LONGWORD(TTranslatorTags.ListOfData), 'Qty', xml.IntegerToHex(cnt, 2), False);

  di := TGXDataInfo.Create();
  try
  di.Xml := xml;
  for pos := 1 to cnt do
  begin
    di.Clear();
    if xml <> Nil Then
    begin
      if xml.OutputType = TTranslatorOutputType.StandardXml Then
          xml.AppendStartTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
      TGXCommon.GetData(data, di);
      if Not di.Complete Then
        xml.AppendLine(xml.GetDataType(di.&Type), '', data.ToHex(False, data.Position, data.Available()));

      if xml.OutputType = TTranslatorOutputType.StandardXml Then
        xml.AppendEndTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
    end;
  end;
  finally
    FreeAndNil(di);
  end;
  if xml <> Nil Then
  begin
    xml.AppendEndTag(LONGWORD(TTranslatorTags.ListOfData));
    xml.AppendEndTag(LONGWORD(TCommand.WriteRequest));
  end;
end;

class procedure TGXDLMSSNCommandHandler.HandleRead(
    settings: TGXDLMSSettings;
    t: TVariableAccessSpecification;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);
var
  ch: BYTE;
  sn: UInt16;
  di: TGXDataInfo;
begin
  sn := data.GetUInt16();
  if xml <> Nil Then
  begin
      if xml.OutputType = TTranslatorOutputType.StandardXml Then
          xml.AppendStartTag(LONGWORD(TTranslatorTags.VariableAccessSpecification));
      if t = TVariableAccessSpecification.ParameterisedAccess Then
      begin
        xml.AppendStartTag(TCommand.ReadRequest, LONGWORD(TVariableAccessSpecification.ParameterisedAccess));
        xml.AppendLine(
            (LONGWORD(TCommand.ReadRequest) shl 8) or LONGWORD(TVariableAccessSpecification.VariableName),
            '', xml.IntegerToHex(sn, 4));
        ch := data.GetUInt8();
        xml.AppendLine(LONGWORD(TTranslatorTags.Selector), '', xml.IntegerToHex(ch, 2));
        xml.AppendStartTag(LONGWORD(TTranslatorTags.Parameter));
        di := TGXDataInfo.Create();
        try
          di.Xml := xml;
          TGXCommon.GetData(data, di);
        finally
          FreeAndNil(di);
        end;
        xml.AppendEndTag(LONGWORD(TTranslatorTags.Parameter));
        xml.AppendEndTag(TCommand.ReadRequest, LONGWORD(TVariableAccessSpecification.ParameterisedAccess));
      end
      else
      begin
        xml.AppendLine((Integer(TCommand.ReadRequest) shl 8) or Integer(TVariableAccessSpecification.VariableName),
            '', xml.IntegerToHex(sn, 4));
      end;
      if xml.OutputType = TTranslatorOutputType.StandardXml Then
        xml.AppendEndTag(LONGWORD(TTranslatorTags.VariableAccessSpecification));
  end;
end;

class procedure TGXDLMSSNCommandHandler.HandleReadBlockNumberAccess(
    settings: TGXDLMSSettings;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure);
var
  bb: TGXByteBuffer;
  blockNumber: UInt16;
  p: TGXDLMSSNParameters;
begin
  blockNumber := data.GetUInt16();
   if xml <> Nil Then
   begin
    xml.AppendStartTag(TCommand.ReadRequest, LONGWORD(TVariableAccessSpecification.BlockNumberAccess));
    xml.AppendLine('<BlockNumber Value="' + xml.IntegerToHex(blockNumber, 4) + '" />');
    xml.AppendEndTag(TCommand.ReadRequest, LONGWORD(TVariableAccessSpecification.BlockNumberAccess));
    Exit
  end;
  if blockNumber <> settings.BlockIndex Then
  begin
      bb := TGXByteBuffer.Create();
      p:= TGXDLMSSNParameters.Create(settings, TCommand.ReadResponse, 1,
            BYTE(TSingleReadResponse.DataAccessError), bb, Nil);
      try
        bb.SetUInt8(BYTE(TErrorCode.ecDataBlockNumberInvalid));
        TGXDLMS.GetSNPdu(p, replyData);
      finally
        FreeAndNil(bb);
        FreeAndNil(p);
      end;
      settings.ResetBlockIndex();
      Exit;
  end;
end;

class procedure TGXDLMSSNCommandHandler.HandleReadDataBlockAccess(
    settings: TGXDLMSSettings;
    command: TCommand;
    data: TGXByteBuffer;
    cnt: Integer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  lastBlock, blockNumber: UInt16;
begin
  lastBlock := data.GetUInt8();
  blockNumber := data.GetUInt16();
  if xml <> Nil Then
  begin
    if command = TCommand.WriteResponse Then
      xml.AppendStartTag(LONGWORD(TTranslatorTags.WriteDataBlockAccess))
    else
        xml.AppendStartTag(LONGWORD(TTranslatorTags.ReadDataBlockAccess));
    xml.AppendLine('<LastBlock Value="' + xml.IntegerToHex(lastBlock, 2) + '" />');
    ;
    xml.AppendLine('<BlockNumber Value="' + xml.IntegerToHex(blockNumber, 4) + '" />');
    if command = TCommand.WriteResponse Then
        xml.AppendEndTag(LONGWORD(TTranslatorTags.WriteDataBlockAccess))
    else
        xml.AppendEndTag(LONGWORD(TTranslatorTags.ReadDataBlockAccess));
  end;
end;

class procedure TGXDLMSSNCommandHandler.ReturnSNError(
    settings: TGXDLMSSettings;
    cmd: TCommand;
    error: TErrorCode;
    replyData: TGXByteBuffer);
begin
  settings.ResetBlockIndex();
end;

// Handle Information Report.
class procedure TGXDLMSSNCommandHandler.HandleInformationReport(
    settings: TGXDLMSSettings;
    reply: TGXReplyData);
var
  ch: BYTE;
  sn: UInt16;
  pos, count: Integer;
  tmp: TBytes;
  value: TGXDateTime;
  di: TGXDataInfo;
begin
  value := Nil;
  reply.Time := 0;
  ch := reply.Data.GetUInt8();
  // If date time is given.
  if ch <> 0 Then
  begin
    SetLength(tmp, ch);
    reply.Data.Get(tmp);
    value := TGXCommon.ChangeType(tmp, TDataType.dtDateTime).AsType<TGXDateTime>;
    reply.Time := value.LocalTime;
  end;
  count := TGXCommon.GetObjectCount(reply.Data);
  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendStartTag(LONGWORD(TCommand.InformationReport));
    if (reply.Time <> 0) and (value <> Nil) Then
    begin
      reply.Xml.AppendComment(value.ToString());
      if reply.Xml.OutputType = TTranslatorOutputType.SimpleXml Then
      begin
        reply.Xml.AppendLine(LONGWORD(TTranslatorTags.CurrentTime), '', TGXCommon.ToHexString(tmp, false, 0, Length(tmp)));
      end
      else
      begin
        //str = TGXCommon.GeneralizedTime(reply.GetTime());
        //reply.Xml.AppendLine(TTranslatorTags.CurrentTime, '', str);
      end;
    end;
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.ListOfVariableAccessSpecification),
        'Qty', reply.Xml.IntegerToHex(count, 2), False);
  end;
  for pos := 1 to count do
  begin
    ch := reply.Data.GetUInt8();
    if ch = Integer(TVariableAccessSpecification.VariableName) Then
    begin
      sn := reply.Data.GetUInt16();
      if reply.Xml <> Nil Then
        reply.Xml.AppendLine(
            (LONGWORD(TCommand.WriteRequest) shl 8) or LONGWORD(TVariableAccessSpecification.VariableName),
            '', reply.Xml.IntegerToHex(sn, 4));
    end;
  end;
  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.ListOfVariableAccessSpecification));
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.ListOfData), 'Qty', reply.Xml.IntegerToHex(count, 2), False);
  end;
  //Get values.
  count := TGXCommon.GetObjectCount(reply.Data);
  di := TGXDataInfo.Create();
  try
    di.Xml := reply.Xml;
    for pos := 1 to count do
    begin
      di.Clear();
      if reply.Xml <> Nil Then
        TGXCommon.GetData(reply.Data, di);
    end;
  finally
    FreeAndNil(di);
  end;
  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.ListOfData));
    reply.Xml.AppendEndTag(LONGWORD(TCommand.InformationReport));
  end;
end;
end.

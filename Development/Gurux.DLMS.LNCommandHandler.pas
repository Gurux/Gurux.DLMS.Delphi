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

unit Gurux.DLMS.LNCommandHandler;

interface
uses SysUtils, Rtti, Gurux.DLMS.ObjectType, Gurux.DLMS.GXDLMSTranslatorStructure,
Gurux.DLMS.TranslatorTags, Gurux.DLMS.GXDLMSConverter, Gurux.DLMS.GXDLMSObject,
GXByteBuffer, Gurux.DLMS.ErrorCode, GXDataInfo, GXCommon, Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSLNParameters, TranslatorOutputType, AccessServiceCommandType,
Gurux.DLMS.GXReplyData, Gurux.DLMS.DataType, Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDLMSServerNotifier,
Gurux.DLMS.ActionRequestType,
Gurux.DLMS.GXDLMSConnectionEventArgs;

type

TGXDLMSLNCommandHandler = class
private
  class procedure MethodRequest(
    settings: TGXDLMSSettings;
    tp: TActionRequestType;
    invokeId: BYTE;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    connectionInfo: TGXDLMSConnectionEventArgs;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);

  class procedure AppendAttributeDescriptor(
      xml: TGXDLMSTranslatorStructure; ci:
      Integer;
      ln: TBytes;
      attributeIndex: BYTE);

  class procedure AppendMethodDescriptor(
      xml: TGXDLMSTranslatorStructure;
      ci: Integer;
      ln: TBytes;
      attributeIndex: BYTE);

  class procedure GetRequestNormal(
      settings: TGXDLMSSettings;
      server: TGXDLMSServerNotifier;
      invokeID: BYTE;
      data: TGXByteBuffer;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);

  class procedure GetRequestWithList(
      settings: TGXDLMSSettings;
      invokeID: BYTE;
      data: TGXByteBuffer;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);


  class procedure HandleSetRequestNormal(
      settings: TGXDLMSSettings;
      data: TGXByteBuffer;
      ct: BYTE;
      p: TGXDLMSLNParameters;
      xml: TGXDLMSTranslatorStructure);

  class procedure HanleSetRequestWithDataBlock(
      settings: TGXDLMSSettings;
      data: TGXByteBuffer;
      p: TGXDLMSLNParameters;
      xml: TGXDLMSTranslatorStructure);

  class procedure HanleSetRequestWithList(
      settings: TGXDLMSSettings;
      invoke: BYTE;
      data: TGXByteBuffer;
      p: TGXDLMSLNParameters;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);

public
  class procedure GetRequestNextDataBlock(
      settings: TGXDLMSSettings;
      server: TGXDLMSServerNotifier;
      invokeID: BYTE;
      data: TGXByteBuffer;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      streaming: Boolean;
      cipheredCommand: TCommand);

  class procedure HandleGetRequest(
      settings: TGXDLMSSettings;
      server: TGXDLMSServerNotifier;
      data: TGXByteBuffer ;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);

  class procedure HandleSetRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);

  // Handle action request.
  class procedure HandleMethodRequest(
      settings: TGXDLMSSettings;
      server: TGXDLMSServerNotifier;
      data: TGXByteBuffer;
      connectionInfo: TGXDLMSConnectionEventArgs;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);

  class procedure HandleAccessRequest(
      settings: TGXDLMSSettings;
      server: TGXDLMSServerNotifier;
      data: TGXByteBuffer;
      replyData: TGXByteBuffer;
      xml: TGXDLMSTranslatorStructure;
      cipheredCommand: TCommand);

  // Handle Event Notification.
  class procedure HandleEventNotification(
      settings: TGXDLMSSettings;
      reply: TGXReplyData);

end;
implementation
uses Gurux.DLMS.GetCommandType, Gurux.DLMS.SingleReadResponse,
Gurux.DLMS.SetRequestType,
Gurux.DLMS.Objects.GXDLMSAssociationLogicalName,
Gurux.DLMS.Objects.GXDLMSAssociationShortName,
Gurux.DLMS.Objects.GXDLMSProfileGeneric,
Gurux.DLMS.GXDLMS,
Gurux.DLMS.ActionResponseType,
Gurux.DLMS.ConnectionState,
Gurux.DLMS.GXDLMSConfirmedServiceError,
Gurux.DLMS.ConfirmedServiceError,
Gurux.DLMS.ServiceError,
Gurux.DLMS.Service,
Gurux.DLMS.Enums.MethodAccessMode3,
Gurux.DLMS.GXDLMSLongTransaction,
Gurux.DLMS.AssociationStatus,
Gurux.DLMS.Objects.GXDLMSSecuritySetup,
Gurux.DLMS.AccessMode;

class procedure TGXDLMSLNCommandHandler.AppendAttributeDescriptor(
    xml: TGXDLMSTranslatorStructure;
    ci: Integer;
    ln: TBytes;
    attributeIndex: BYTE);
var
  tmp: String;
begin
  xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptor));
  if xml.Comments Then
    xml.AppendComment(TGXDLMSConverter.ToString(TObjectType(ci)));

  tmp := xml.IntegerToHex(LONGWORD(ci), 4);
  xml.AppendLine(LONGWORD(TTranslatorTags.ClassId), '', tmp);
  if xml.Comments Then
    xml.AppendComment(TGXDLMSObject.toLogicalName(ln));
  tmp := TGXByteBuffer.ToHexString(ln, False, 0, 6);
  xml.AppendLine(LONGWORD(TTranslatorTags.InstanceId), '', tmp);
  tmp := xml.IntegerToHex(attributeIndex, 2);
  xml.AppendLine(LONGWORD(TTranslatorTags.AttributeId), '', tmp);
  xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptor));
end;

class procedure TGXDLMSLNCommandHandler.AppendMethodDescriptor(
    xml: TGXDLMSTranslatorStructure;
    ci: Integer;
    ln: TBytes;
    attributeIndex: BYTE);
var
  tmp: String;
begin
  xml.AppendStartTag(LONGWORD(TTranslatorTags.MethodDescriptor));
  if xml.Comments Then
    xml.AppendComment(TGXDLMSConverter.ToString(TObjectType(ci)));

  tmp := xml.IntegerToHex(LONGWORD(ci), 4);
  xml.AppendLine(LONGWORD(TTranslatorTags.ClassId), '', tmp);
  tmp := TGXDLMSObject.toLogicalName(ln);
  xml.AppendComment(tmp);
  tmp := TGXCommon.ToHexString(ln, False, 0, 6);
  xml.AppendLine(LONGWORD(TTranslatorTags.InstanceId), '', tmp);
  tmp := xml.IntegerToHex(attributeIndex, 2);
  xml.AppendLine(LONGWORD(TTranslatorTags.MethodId), '', tmp);
  xml.AppendEndTag(LONGWORD(TTranslatorTags.MethodDescriptor));
end;

class procedure TGXDLMSLNCommandHandler.GetRequestNormal(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    invokeID: BYTE;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  attributeIndex: BYTE;
  ln: TBytes;
  ci : TObjectType;
  selection, selector: BYTE;
  info: TGXDataInfo;
  obj: TGXDLMSObject;
  parameters : TValue;
  e: TValueEventArgs;
  mode: Integer;
  status: TErrorCode;
  p: TGXDLMSLNParameters;
  value: TValue;
  bb : TGXByteBuffer;
  args : TArray<TValueEventArgs>;
begin
   // Get type.
  status := TErrorCode.ecOk;
  settings.count := 0;
  settings.Index := 0;
  settings.ResetBlockIndex();
  // CI
  ci := TObjectType(data.GetUInt16());
  SetLength(ln, 6);
  data.Get(ln);
  // Attribute Id
  attributeIndex := data.GetUInt8();
  // Access selection
  selection := data.GetUInt8();
  selector := 0;
  if selection <> 0 Then
    selector := data.GetUInt8();

  if xml <> Nil Then
  begin
    AppendAttributeDescriptor(xml, Integer(ci), ln, attributeIndex);
    if selection <> 0 Then
    begin
        xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessSelection));
        xml.AppendLine(LONGWORD(TTranslatorTags.AccessSelector), '',
            xml.IntegerToHex(selector, 2));
        xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessParameters));
        info := TGXDataInfo.Create();
        try
          info.Xml := xml;
          TGXCommon.GetData(data, info);
        finally
          FreeAndNil(info);
        end;
        xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessParameters));
        xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessSelection));
    end;
  end;
  if selection <> 0 Then
  begin
    parameters := TGXCommon.GetData(data, info);
  end;

  obj := Nil;
  if (ci = TObjectType.otAssociationLogicalName) and (TGXCommon.ToLogicalName(ln) = '0.0.40.0.0.255') Then
  begin
      obj := settings.GetAssignedAssociation();
  end;
  if obj = Nil Then
  begin
      obj := settings.Objects.FindByLN(ci, TGXCommon.ToLogicalName(ln));
  end;
  if obj = Nil Then
  begin
      obj := server.FindObject(ci, 0, TGXCommon.ToLogicalName(ln));
  end;
  bb := TGXByteBuffer.Create();
  e := TValueEventArgs.Create(obj, attributeIndex, selector, parameters);
  args := TArray<TValueEventArgs>.Create(e);
  try
    e.InvokeId := invokeID;
    mode := 0;
    if obj = Nil Then
    begin
      // "Access Error : Device reports a undefined object."
      status := TErrorCode.ecUndefinedObject;
    end
    else
    begin
        if (Integer(server.GetAttributeAccess(e)) and Integer(TAccessMode.Read)) = 0 Then
        begin
            //Read Write denied.
            status := TErrorCode.ecReadWriteDenied;
        end
        else
        begin
            if settings.GetAssignedAssociation() <> Nil Then
            begin
              //TODO: mode := Integer(settings.GetAssignedAssociation.GetAccess3(obj, attributeIndex));
            end;
            // Handle default Association LN read as a special case.
            if ((obj is TGXDLMSAssociationLogicalName)
                    or (obj is TGXDLMSAssociationShortName)) and (attributeIndex = 1) Then
            begin
                TGXDLMS.AppendData(obj, attributeIndex, bb, TValue.From(TBytes.Create(0, 0, 40, 0, 0, 255)));
            end
            else
            begin
                server.PreRead(args);
                if e.Handled Then
                begin
                  value := e.Value;
                end
                else
                begin
                    settings.Count := e.RowEndIndex - e.RowBeginIndex;
                    value := obj.GetValue(e);
                end;
                if e.ByteArray then
                begin
                    bb.SetArray(value.AsType<TBytes>());
                end
                else
                begin
                    TGXDLMS.AppendData(obj, attributeIndex, bb, value);
                end;
                server.PostRead(args);
                status := e.Error;
            end;
        end;
    end;
    p := TGXDLMSLNParameters.Create(settings, e.InvokeId, TCommand.GetResponse, 1, Nil, bb, BYTE(status), cipheredCommand);
    p.AccessMode := mode;
    TGXDLMS.GetLNPdu(p, replyData);
    if (settings.Count <> settings.Index) or (bb.Size <> bb.Position) Then
    begin
     //TODO: server.Transaction := TGXDLMSLongTransaction.Create(args, TCommand.GetRequest, bb);
    end;
   finally
   FreeAndNil(bb);
   FreeAndNil(e);
  end;
end;

class procedure TGXDLMSLNCommandHandler.GetRequestNextDataBlock(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    invokeID: BYTE;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    streaming: Boolean;
    cipheredCommand: TCommand);
var
  index: LONGWORD;
begin
  if Not streaming Then
  begin
      // Get block index.
      index := data.GetUInt32();
      if xml <> Nil Then
      begin
        xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', xml.IntegerToHex(index, 8));
      end;
  end;
end;

class procedure TGXDLMSLNCommandHandler.GetRequestWithList(
    settings: TGXDLMSSettings;
    invokeID: BYTE;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  pos, cnt: LONGWORD;
  ci: TObjectType;
  ln: TBytes;
  selection, attributeIndex: BYTE;
  info: TGXDataInfo;
  tmp: string;
begin
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
  begin
    xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptorList), 'Qty', xml.IntegerToHex(cnt, 2), false);
  end;
  SetLength(ln, 6);
  for pos := 0 to cnt do
  begin
    ci := TObjectType(data.GetUInt16());
    data.Get(ln);
    attributeIndex := data.GetUInt8();
    // AccessSelection
    selection := data.GetUInt8();
    if selection <> 0 Then
    begin
      //selector :=
      data.GetUInt8();
      info := TGXDataInfo.Create;
      try
        info.Xml := xml;
        TGXCommon.GetData(data, info);
      finally
        FreeAndNil(info);
      end;
    end;
    if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptorWithSelection));
      xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptor));
      xml.AppendComment(TGXDLMSConverter.ToString(ci));
      xml.AppendLine(LONGWORD(TTranslatorTags.ClassId), '', xml.IntegerToHex(LONGWORD(ci), 4));

      tmp := TGXDLMSObject.toLogicalName(ln);
      xml.AppendComment(tmp);
      tmp := TGXByteBuffer.ToHexString(ln);
      xml.AppendLine(LONGWORD(TTranslatorTags.InstanceId), '', tmp);
      tmp := xml.IntegerToHex(attributeIndex, 2);
      xml.AppendLine(LONGWORD(TTranslatorTags.AttributeId), '', tmp);
      xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptor));
      xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptorWithSelection));
    end;
  end;
  if xml <> Nil Then
    xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptorList));
end;

class procedure TGXDLMSLNCommandHandler.HandleGetRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer ;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  ct: TGetCommandType;
  invokeID: Byte;
  tmp: string;
begin
  invokeID := 0;
  ct := TGetCommandType.ctNormal;
  //If GBT is used data is empty.
  if data.Size <> 0 Then
  begin
    // Get type.
    ct := TGetCommandType(data.GetUInt8());
    // Get invoke ID and priority.
    invokeID := data.GetUInt8();
    settings.UpdateInvokeId(invokeID);
    if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TCommand.GetRequest));
      xml.AppendStartTag(TCommand.GetRequest, LONGWORD(ct));
      tmp := xml.IntegerToHex(invokeID, 2);
      xml.AppendLine(LONGWORD(TTranslatorTags.InvokeId), '', tmp);
    end;
  end;
  // GetRequest normal
  if ct = TGetCommandType.ctNormal Then
      GetRequestNormal(settings, server, invokeID, data, replyData, xml, cipheredCommand)
  else if ct = TGetCommandType.ctNextDataBlock Then
    // Get request for next data block
    GetRequestNextDataBlock(settings, server, invokeID, data, replyData, xml, false, cipheredCommand)
  else if ct = TGetCommandType.ctWithList Then
    // Get request with a list.
    GetRequestWithList(settings, invokeID, data, replyData, xml, cipheredCommand)
  else
  if xml <> Nil Then
  begin
    xml.AppendEndTag(TCommand.GetRequest, LONGWORD(ct));
    xml.AppendEndTag(LONGWORD(TCommand.GetRequest));
  end;
end;

class procedure TGXDLMSLNCommandHandler.HandleSetRequestNormal(
    settings: TGXDLMSSettings;
    data: TGXByteBuffer;
    ct: BYTE;
    p: TGXDLMSLNParameters;
    xml: TGXDLMSTranslatorStructure);
var
  info: TGXDataInfo;
  ci: UInt16;
  ln: TBytes;
  lastBlock, index: Byte;
  realSize, size, blockNumber: LONGWORD;
  str: string;
begin
  // Get type.
  ci := data.GetUInt16();
  SetLength(ln, 6);
  data.Get(ln);
  // Attribute index.
  index := data.GetUInt8();
  // Get Access Selection.
  //ch :=
  data.GetUInt8();
  if ct = 2 Then
  begin
    lastBlock := data.GetUInt8();
    p.MultipleBlocks := lastBlock = 0;
    blockNumber := data.GetUInt32();

    if blockNumber <> settings.BlockIndex Then
    begin
      p.Status := Byte(TErrorCode.ecDataBlockNumberInvalid);
      Exit;
    end;
    settings.IncreaseBlockIndex();
    size := TGXCommon.GetObjectCount(data);
    realSize := data.Size - data.Position;
    if size <> realSize Then
    begin
      p.Status := Byte(TErrorCode.ecDataBlockUnavailable);
      Exit;
    end;
    if xml <> Nil Then
    begin
      AppendAttributeDescriptor(xml, ci, ln, index);
      xml.AppendStartTag(LONGWORD(TTranslatorTags.DataBlock));
      str := xml.IntegerToHex(lastBlock, 2);
      xml.AppendLine(LONGWORD(TTranslatorTags.LastBlock), '', str);
      str := xml.IntegerToHex(blockNumber, 8);
      xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', str);
      str := data.ToHex(false, data.Position, data.Available());
      xml.AppendLine(LONGWORD(TTranslatorTags.RawData), '', str);
      xml.AppendEndTag(LONGWORD(TTranslatorTags.DataBlock));
    end;
    Exit;
  end;
  if xml <> Nil Then
  begin
    AppendAttributeDescriptor(xml, ci, ln, index);
    xml.AppendStartTag(LONGWORD(TTranslatorTags.Value));
    info := TGXDataInfo.Create;
    try
      info.Xml := xml;
      TGXCommon.GetData(data, info);
    finally
      FreeAndNil(info);
    end;
    xml.AppendEndTag(LONGWORD(TTranslatorTags.VALUE));
    Exit;
  end;
end;

class procedure TGXDLMSLNCommandHandler.HanleSetRequestWithDataBlock(
    settings: TGXDLMSSettings;
    data: TGXByteBuffer;
    p: TGXDLMSLNParameters;
    xml: TGXDLMSTranslatorStructure);
var
  lastBlock: Byte;
  realSize, size, blockNumber: LONGWORD;
  str: string;
begin
  lastBlock := data.GetUInt8();
  p.MultipleBlocks := lastBlock = 0;
  blockNumber := data.GetUInt32();
  if (xml = Nil) and (blockNumber <> settings.BlockIndex) Then
  begin
     p.Status := Byte(TErrorCode.ecDataBlockNumberInvalid);
  end
  else
  begin
    settings.IncreaseBlockIndex();
    size := TGXCommon.GetObjectCount(data);
    realSize := data.Size - data.Position;
    if size <> realSize Then
    begin
      p.Status := Byte(TErrorCode.ecDataBlockUnavailable);
      Exit;
    end;
    if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TTranslatorTags.DataBlock));
      str := xml.IntegerToHex(lastBlock, 2);
      xml.AppendLine(LONGWORD(TTranslatorTags.LastBlock), '', str);
      str := xml.IntegerToHex(blockNumber, 8);
      xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', str);
      str := data.ToHex(false, data.Position, data.Available());
      xml.AppendLine(LONGWORD(TTranslatorTags.RawData), '', str);
      xml.AppendEndTag(LONGWORD(TTranslatorTags.DataBlock));
      Exit;
    end;
  end;
end;

class procedure TGXDLMSLNCommandHandler.HanleSetRequestWithList(
    settings: TGXDLMSSettings;
    invoke: BYTE;
    data: TGXByteBuffer;
    p: TGXDLMSLNParameters;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  ci: UInt16;
  ln: TBytes;
  attributeIndex, selection: Byte;
  pos, cnt: LONGWORD;
  str: string;
  di: TGXDataInfo;
begin
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
  begin
    str := xml.IntegerToHex(cnt, 2);
    xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptorList), 'Qty', str, false);
  end;
  SetLength(ln, 6);
  for pos := 1 to cnt do
  begin
    ci := data.GetUInt16();
    data.Get(ln);
    // Attribute Id
    attributeIndex := data.GetUInt8();
    // AccessSelection
    selection := data.GetUInt8();
    if selection <> 0 Then
    begin
      //selector :=
      data.GetUInt8();
      di := TGXDataInfo.Create;
      try
        di.Xml := xml;
        TGXCommon.GetData(data, di);
      finally
        FreeAndNil(di);
      end;
    end;
    if xml <> Nil Then
    begin
      xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptorWithSelection));
      xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeDescriptor));
      xml.AppendComment(TGXDLMSConverter.ToString(TObjectType(ci)));
      xml.AppendLine(LONGWORD(TTranslatorTags.ClassId), '', xml.IntegerToHex(ci, 4));
      xml.AppendComment(TGXDLMSObject.toLogicalName(ln));
      xml.AppendLine(LONGWORD(TTranslatorTags.InstanceId), '', TGXCommon.ToHexString(ln, False, 0, 6));
      xml.AppendLine(LONGWORD(TTranslatorTags.AttributeId), '', xml.IntegerToHex(attributeIndex, 2));
      xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptor));
      xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptorWithSelection));
    end;
  end;
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
  begin
    xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeDescriptorList));
    str := xml.IntegerToHex(cnt, 2);
    xml.AppendStartTag(LONGWORD(TTranslatorTags.ValueList), 'Qty', str, false);
  end;
  for pos := 1 to cnt do
  begin
    if (xml <> Nil) and (xml.OutputType = TTranslatorOutputType.StandardXml) Then
    begin
      xml.AppendStartTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
    end;
    di := TGXDataInfo.Create;
    try
      di.Xml := xml;
      TGXCommon.GetData(data, di);
    finally
      FreeAndNil(di);
    end;
    if (xml <> Nil) and (xml.OutputType = TTranslatorOutputType.StandardXml) Then
        xml.AppendEndTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
  end;
  if xml <> Nil Then
      xml.AppendEndTag(LONGWORD(TTranslatorTags.ValueList));
end;

class procedure TGXDLMSLNCommandHandler.HandleSetRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  invoke: Byte;
  str: string;
  tp: TSetRequestType;
  p: TGXDLMSLNParameters;
begin
    // Get type.
    tp := TSetRequestType(data.GetUInt8());
    // Get invoke ID and priority.
    invoke := data.GetUInt8();
    settings.UpdateInvokeId(invoke);
    if xml <> Nil Then begin
        xml.AppendStartTag(Integer(TCommand.SetRequest));
        xml.AppendStartTag(TCommand.SetRequest, Integer(tp));
        // InvokeIdAndPriority
        str := xml.IntegerToHex(invoke, 2);
        xml.AppendLine(Integer(TTranslatorTags.InvokeId), '', str);
    end;

    p := TGXDLMSLNParameters.Create(settings, invoke, TCommand.SetResponse, BYTE(tp), Nil, Nil, 0, cipheredCommand);
    if (tp = TSetRequestType.stNormal) or (tp = TSetRequestType.stFirstDataBlock) Then
        HandleSetRequestNormal(settings, data, BYTE(tp), p, xml)
    else if tp = TSetRequestType.stWithDataBlock Then
        // Set Request With Data Block
        HanleSetRequestWithDataBlock(settings, data, p, xml)
    else if tp = TSetRequestType.stWithList Then
        // Set Request With Data Block
        HanleSetRequestWithList(settings, invoke, data, p, xml, cipheredCommand)
    else
    begin
        settings.ResetBlockIndex();
        p.Status := Byte(TErrorCode.ecHardwareFault);
    end;
    if xml <> Nil Then
    begin
        xml.AppendEndTag(TCommand.SetRequest, Integer(tp));
        xml.AppendEndTag(Integer(TCommand.SetRequest));
    end;
end;

class procedure TGXDLMSLNCommandHandler.MethodRequest(
    settings: TGXDLMSSettings;
    tp: TActionRequestType;
    invokeId: BYTE;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    connectionInfo: TGXDLMSConnectionEventArgs;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  error : TErrorCode;
  bb: TGXByteBuffer;
  ci: TObjectType;
  ln: TBytes;
  id: BYTE;
  selection: BYTE;
  lastBlock: BYTE;
  p: TGXDLMSLNParameters;
  info: TGXDataInfo;
  di: TGXDataInfo;
  size: Integer;
  realSize: Integer;
  obj: TGXDLMSObject;
  e: TValueEventArgs;
  args: TArray<TValueEventArgs>;
  actionReply: TBytes;
  parameters: TValue;
  blockNumber: UINT32;
begin
    error := TErrorCode.ecOk;
    bb := TGXByteBuffer.Create();
    // CI
    ci := TObjectType(data.GetUInt16());
    SetLength(ln, 6);
    data.Get(ln);
    // Attribute Id
    id := data.GetUInt8();
    parameters := Nil;
    p := TGXDLMSLNParameters.Create(settings, invokeId, TCommand.MethodResponse,
        Integer(TActionResponseType.Normal),
        Nil, bb, 0, cipheredCommand);
    if tp = TActionRequestType.arNormal Then
    begin
        // Get parameters.
        selection := data.GetUInt8();
        if xml <> Nil Then
        begin
            AppendMethodDescriptor(xml, Integer(ci), ln, id);
            if selection <> 0 Then
            begin
                //MethodInvocationParameters
                xml.AppendStartTag(LONGWORD(TTranslatorTags.MethodInvocationParameters));
                di := TGXDataInfo.Create();
                di.xml := xml;
                TGXCommon.GetData(data, di);
                xml.AppendEndTag(LONGWORD(TTranslatorTags.MethodInvocationParameters));
            end;
            Exit;
        end;
        if selection <> 0 Then
        begin
            info := TGXDataInfo.Create();
            parameters := TGXCommon.GetData(data, info);
        end;
    end
    else if tp = TActionRequestType.arWithFirstBlock Then
    begin
        p.requestType := BYTE(TActionResponseType.NextBlock);
        p.status := $FF;
        lastBlock := data.GetUInt8();
        p.multipleBlocks := lastBlock = 0;
        blockNumber := data.GetUInt32();
        if (xml = Nil) and (blockNumber <> settings.BlockIndex) Then
        begin
            p.status := BYTE(TErrorCode.ecDataBlockNumberInvalid);
            Exit;
        end;
        settings.IncreaseBlockIndex();
        size := TGXCommon.GetObjectCount(data);
        realSize := data.Size - data.Position;
        if size <> realSize Then
        begin
            if xml = Nil Then
            begin
                p.status := BYTE(TErrorCode.ecDataBlockUnavailable);
                Exit;
            end;
            xml.AppendComment('Invalid block size.');
        end;
        if xml <> Nil Then
        begin
            AppendMethodDescriptor(xml, Integer(ci), ln, id);
            xml.AppendStartTag(LONGWORD(TTranslatorTags.DataBlock));
            xml.AppendLine(LONGWORD(TTranslatorTags.LastBlock), '', xml.IntegerToHex(lastBlock, 2));
            xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', xml.IntegerToHex(blockNumber, 8));
            xml.AppendLine(LONGWORD(TTranslatorTags.RawData), '', data.RemainingHexString(false));
            xml.AppendEndTag(LONGWORD(TTranslatorTags.DataBlock));
            exit;
        end;
    end;

    obj := Nil;
    if (ci = TObjectType.otAssociationLogicalName) and (TGXCommon.ToLogicalName(ln) = '0.0.40.0.0.255') Then
    begin
      obj := settings.GetAssignedAssociation();
    end;
    if obj = Nil Then
    begin
      obj := settings.Objects.FindByLN(ci, TGXCommon.ToLogicalName(ln));
    end;
    if ((Integer(settings.Connected) and Integer(TConnectionState.csDlms)) = 0) and
     (cipheredCommand = TCommand.None) and ((ci <> TObjectType.otAssociationLogicalName) or (id <> 1)) Then
    begin
      //TODO:  replyData.SetArray(TGXDLMSServer.GenerateConfirmedServiceError(TConfirmedServiceError.InitiateError,
      //                TServiceError.Service, BYTE(TService.Unsupported)));
        Exit;
    end;
    e := Nil;
    if obj = Nil Then
    begin
      obj := server.FindObject(ci, 0, TGXCommon.ToLogicalName(ln));
    end;
    if obj = Nil Then
    begin
      // Device reports a undefined object.
      error := TErrorCode.ecUndefinedObject;
    end
    else
    begin
        if settings.GetAssignedAssociation() <> Nil Then
        begin
          //TODO: p.AccessMode := Integer(settings.GetAssignedAssociation().GetMethodAccess3(obj, id));
        end;
        e := TValueEventArgs.Create(obj, id, 0, parameters);
        e.FSettings := settings;
        args := TArray<TValueEventArgs>.Create(e);
        e.InvokeId := invokeId;
        if ((Integer(server.GetMethodAccess(e)) and Integer(TMethodAccessMode3.Access)) = 0) Then
        begin
            error := TErrorCode.ecReadWriteDenied;
        end
        else
        begin
            try
            begin
                if p.multipleBlocks Then
                begin
                  server.SetTransaction(TGXDLMSLongTransaction.Create(args, TCommand.MethodRequest, data));
                end
                //Check transaction so invoke is not called multiple times.
                //This might happen when all data can't fit to one PDU.
                else if server.GetTransaction() = Nil Then
                begin
                    p.requestType := BYTE(TActionResponseType.Normal);
                    server.PreAction(args);
                    if e.Handled Then
                    begin
                      actionReply := e.Value.AsType<TBytes>();
                    end
                    else
                    begin
                      actionReply := obj.Invoke(e);
                      server.PostAction(args);
                    end;
                    //Set default action reply if not given.
                    if (actionReply <> Nil) and (e.Error = TErrorCode.ecOk) Then
                    begin
                      //Add return parameters
                      bb.SetUInt8(1);
                      //Add parameters error code.
                      bb.SetUInt8(0);
                      TGXCommon.SetData(bb, TGXDLMSConverter.GetDLMSDataType(TValue.From(actionReply)), TValue.From(actionReply));
                    end
                    else
                    begin
                      error := e.Error;
                      //Add return parameters
                      bb.SetUInt8(0);
                    end;
                end;
            end;
            except
             on E: Exception do
             begin
              error := TErrorCode.ecReadWriteDenied;
              //Add return parameters
              bb.SetUInt8(0);
            end;
        end;
        p.InvokeId := e.InvokeId;
    end;
    if error <> TErrorCode.ecOk Then
    begin
        p.status := BYTE(error);
    end;
    TGXDLMS.GetLNPdu(p, replyData);
    //If all reply data doesn't fit to one PDU.
    if (server.GetTransaction() = Nil) and (p.data.Available <> 0) Then
    begin
      server.SetTransaction(TGXDLMSLongTransaction.Create(args, TCommand.MethodResponse, p.data));
    end;
    //If High level authentication fails.
    if (error = TErrorCode.ecOk) and (obj is TGXDLMSAssociationLogicalName) and (id = 1) Then
    begin
        if TGXDLMSAssociationLogicalName(obj).AssociationStatus = TAssociationStatus.Associated Then
        begin
          server.Connected(connectionInfo);
          Settings.Connected := TConnectionState(Integer(Settings.Connected) or Integer(TConnectionState.csDlms));
        end
        else
        begin
          server.InvalidConnection(connectionInfo);
          settings.Connected := TConnectionState(Integer(Settings.Connected) and not Integer(TConnectionState.csDlms));
        end;
    end;
    //Start to use new keys.
    if (e <> Nil) and (error = TErrorcode.ecOk) and (obj is TGXDLMSSecuritySetup) and (id = 2) Then
    begin
      //TODO: TGXDLMSSecuritySetup(obj).ApplyKeys(settings, e);
    end;
end;
end;

// Handle action request.
class procedure TGXDLMSLNCommandHandler.HandleMethodRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    connectionInfo: TGXDLMSConnectionEventArgs;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  id, invokeId, selection, tp: BYTE;
  ci: UInt16;
  ln: TBytes;
  di: TGXDataInfo;
  str: string;
begin
  // Get type.
  tp := data.GetUInt8();
  // Get invoke ID and priority.
  invokeId := data.GetUInt8();
  settings.UpdateInvokeId(invokeId);
  if xml <> Nil Then
  begin
      xml.AppendStartTag(LONGWORD(TCommand.MethodRequest));
      if tp = Byte(TActionRequestType.arNormal) Then
      begin
          xml.AppendStartTag(TCommand.MethodRequest, tp);
          str := xml.IntegerToHex(invokeId, 2);
          xml.AppendLine(Integer(TTranslatorTags.InvokeId), '', str);
          AppendMethodDescriptor(xml, ci, ln, id);
          if selection <> 0 Then
          begin
              //MethodInvocationParameters
              xml.AppendStartTag(LONGWORD(TTranslatorTags.MethodInvocationParameters));
              di := TGXDataInfo.Create;
              try
                di.Xml := xml;
                TGXCommon.GetData(data, di);
              finally
                FreeAndNil(di);
              end;
              xml.AppendEndTag(LONGWORD(TTranslatorTags.MethodInvocationParameters));
          end;
          xml.AppendEndTag(TCommand.MethodRequest, tp);
      end;
      xml.AppendEndTag(LONGWORD(TCommand.MethodRequest));
  end;
  MethodRequest(settings, TActionRequestType(tp), invokeID, server, data, connectionInfo, replyData, xml, cipheredCommand);
end;

class procedure TGXDLMSLNCommandHandler.HandleAccessRequest(
    settings: TGXDLMSSettings;
    server: TGXDLMSServerNotifier;
    data: TGXByteBuffer;
    replyData: TGXByteBuffer;
    xml: TGXDLMSTranslatorStructure;
    cipheredCommand: TCommand);
var
  attributeIndex: BYTE;
  pos, len, cnt: Integer;
  tmp: TBytes;
  tmp2: string;
  ln: TBytes;
  tp: TAccessServiceCommandType;
  ci : TObjectType;
  value: TValue;
  di: TGXDataInfo;
begin
  //Get long invoke id and priority.
  settings.LongInvokeID := data.GetUInt32();
  len := TGXCommon.GetObjectCount(data);
  // If date time is given.
  if len <> 0 Then
  begin
    SetLength(tmp, len);
    data.Get(tmp);
  end;
  // Get object count.
  cnt := TGXCommon.GetObjectCount(data);
  if xml <> Nil Then
  begin
    tmp2 := xml.IntegerToHex(settings.LongInvokeID, 4, false);
    xml.AppendStartTag(LONGWORD(TCommand.AccessRequest));
    xml.AppendLine(LONGWORD(TTranslatorTags.LongInvokeId), '', tmp2);
    tmp2 := TGXByteBuffer.ToHexString(tmp, false, 0, Length(tmp));
    xml.AppendLine(LONGWORD(TTranslatorTags.DateTime), '', tmp2);
    xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessRequestBody));
    tmp2 := xml.IntegerToHex(cnt, 2);
    xml.AppendStartTag(LONGWORD(TTranslatorTags.ListOfAccessRequestSpecification), 'Qty', tmp2, false);
  end;
  SetLength(ln, 6);
  for pos := 0 to cnt - 1 do
  begin
    tp := TAccessServiceCommandType(data.GetUInt8());
    if not((tp = TAccessServiceCommandType.asGet) or
        (tp = TAccessServiceCommandType.asSet) or
        (tp = TAccessServiceCommandType.asAction)) Then
    begin
        raise EArgumentException.Create('Invalid access service command type.');
    end;
    // CI
    ci := TObjectType(data.GetUInt16());
    data.Get(ln);
    // Attribute Id
    attributeIndex := data.GetUInt8();
    if xml <> Nil Then
    begin
        xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessRequestSpecification));
        xml.AppendStartTag(TCommand.AccessRequest, LONGWORD(tp));
        AppendAttributeDescriptor(xml, Integer(ci), ln, attributeIndex);
        xml.AppendEndTag(TCommand.AccessRequest, LONGWORD(tp));
        xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessRequestSpecification));

    end;
  end;
  if xml <> Nil Then
  begin
    tmp2 := xml.IntegerToHex(cnt, 2);
    xml.AppendEndTag(LONGWORD(TTranslatorTags.ListOfAccessRequestSpecification));
    xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessRequestListOfData), 'Qty', tmp2, False);
  end;
  // Get data count.
  cnt := TGXCommon.GetObjectCount(data);
  for pos := 1 to cnt do
  begin
      if (xml <> Nil) and (xml.OutputType = TTranslatorOutputType.StandardXml) Then
      begin
          xml.AppendStartTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
      end;
      di := TGXDataInfo.Create;
      try
        di.Xml := xml;
        value := TGXCommon.GetData(data, di);
      finally
        FreeAndNil(di);
      end;
      if (xml <> Nil) and (xml.OutputType = TTranslatorOutputType.StandardXml) Then
      begin
          xml.AppendEndTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
      end;
  end;
  if xml <> Nil Then
  begin
      xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessRequestListOfData));
      xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessRequestBody));
      xml.AppendEndTag(LONGWORD(TCommand.AccessRequest));
  end;
end;

// Handle Event Notification.
class procedure TGXDLMSLNCommandHandler.HandleEventNotification(
    settings: TGXDLMSSettings;
    reply: TGXReplyData);
var
  ch: BYTE;
  tmp: TBytes;
  value: TValue;
  ci : TObjectType;
  ln: TBytes;
  di: TGXDataInfo;
  str: String;
begin
  reply.Time := 0;
  ch := reply.Data.GetUInt8();
  // If date time is given.
  if ch <> 0 Then
  begin
    ch := reply.Data.GetUInt8();
    SetLength(tmp, ch);
    reply.Data.Get(tmp);
    value := TGXCommon.ChangeType(tmp, TDataType.dtDateTime);
    reply.Time := value.AsType<TGXDateTime>.LocalTime;
  end;
  if reply.Xml <> Nil Then
  begin
      reply.Xml.AppendStartTag(LONGWORD(TCommand.EventNotification));
      if reply.Time <> 0 Then
      begin
        reply.Xml.AppendComment(DateTimeToStr(reply.Time));
        str := TGXByteBuffer.ToHexString(tmp, false, 0, Length(tmp));
        reply.Xml.AppendLine(LONGWORD(TTranslatorTags.Time), '', str);
      end;
  end;
  ci := TObjectType(reply.Data.GetUInt16());
  SetLength(ln, 6);
  reply.Data.Get(ln);
  ch := reply.Data.GetUInt8();
  if reply.Xml <> Nil Then
  begin
    AppendAttributeDescriptor(reply.Xml, Integer(ci), ln, ch);
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.AttributeValue));
  end;
  di := TGXDataInfo.Create;
  try
    di.Xml := reply.Xml;
    TGXCommon.GetData(reply.Data, di);
  finally
    FreeAndNil(di);
  end;
  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.AttributeValue));
    reply.Xml.AppendEndTag(LONGWORD(TCommand.EventNotification));
  end;
end;

end.

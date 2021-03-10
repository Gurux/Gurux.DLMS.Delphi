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

unit Gurux.DLMS.GXDLMS;

interface

uses SysUtils, Rtti, Gurux.DLMS.DataType, Gurux.DLMS.ObjectType, Gurux.DLMS.Authentication,
Gurux.DLMS.Priority, Gurux.DLMS.ServiceClass, Gurux.DLMS.InterfaceType,
Gurux.DLMS.GXDLMSLimits, Gurux.DLMS.RequestTypes, Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSException, GXCommon, GXFCS16,
Gurux.DLMS.ServiceError, Gurux.DLMS.StateError,
Gurux.DLMS.ActionType,
System.Variants,
Gurux.DLMS.Security,
Gurux.DLMS.GXCiphering,
Gurux.DLMS.GXDLMSChippering,
Gurux.DLMS.GXDLMSObject,
GXByteBuffer,
Gurux.DLMS.ErrorCode,
Gurux.DLMS.GXDLMSLNParameters,
Gurux.DLMS.GXDLMSConverter,
Gurux.DLMS.Conformance,
System.Types,
System.Generics.Collections,
Gurux.DLMS.GXDLMSSNParameters,
Gurux.DLMS.VariableAccessSpecification,
Gurux.DLMS.Objects.SingleReadResponse,
Gurux.DLMS.GXReplyData,
Gurux.DLMS.HdlcFrameType,
Gurux.DLMS.HdlcControlFrame,
Gurux.DLMS.GXDateTime,
GXDataInfo,
Gurux.DLMS.SetResponseType,
Gurux.DLMS.GetCommandType,
Gurux.DLMS.ConfirmedServiceError,
Gurux.DLMS.AesGcmParameter,
Gurux.DLMS.GXDLMSConfirmedServiceError,
Gurux.DLMS.TranslatorTags,
TranslatorOutputType,
AccessServiceCommandType,
Gurux.DLMS.Enums.ExceptionStateError,
Gurux.DLMS.Enums.ExceptionServiceError,
Gurux.DLMS.GXDLMSExceptionResponse;

const
  CIPHERING_HEADER_SIZE = 7 + 12 + 3;
  DATA_TYPE_OFFSET = $FF0000;
  DEFAULT_MAX_INFO_TX = 128;
  DEFAULT_MAX_INFO_RX = 128;
  DEFAULT_WINDOWS_SIZE_TX = 1;
  DEFAULT_WINDOWS_SIZE_RX = 1;
type
  TGXDLMS = class
  class procedure VerifyInvokeId(settings: TGXDLMSSettings; reply: TGXReplyData);

  class procedure GetActionInfo(objectType: TObjectType; value: PInteger; count: PInteger);static;
  class function GetInvokeIDPriority(settings : TGXDLMSSettings; AIncrease: Boolean): Byte; static;
  class function GetLongInvokeIDPriority(settings : TGXDLMSSettings) : Cardinal; static;
  // Get HDLC frame for data.
  class function GetHdlcFrame(settings: TGXDLMSSettings; frame : Byte; data: TGXByteBuffer) : TBytes;static;
  class procedure CheckInit(settings: TGXDLMSSettings);static;
  class procedure AppendData(obj : TGXDLMSObject; index: Integer; bb: TGXByteBuffer; value: TValue);static;
  //Get used glo message.
  class function GetGloMessage(command : TCommand): TCommand;static;
  // Add LLC bytes to generated message.
  class procedure AddLLCBytes(settings: TGXDLMSSettings; data: TGXByteBuffer);static;
  // Check is all data fit to one data block.
  class procedure MultipleBlocks(p : TGXDLMSLNParameters; reply: TGXByteBuffer; ciphering: Boolean);static;
  // Get next logical name PDU.
  class procedure GetLNPdu(p: TGXDLMSLNParameters; reply: TGXByteBuffer);
  // Cipher using security suite 0.
  class procedure Cipher0(p: TGXDLMSLNParameters; reply: TGXByteBuffer);
  // Get all Logical name messages. Client uses this to generate messages.
  class function GetLnMessages(p: TGXDLMSLNParameters): TArray<TBytes>;
  // Get all Short Name messages. Client uses this to generate messages.
  class function GetSnMessages(p: TGXDLMSSNParameters): TArray<TBytes>;
  class procedure GetSNPdu(p: TGXDLMSSNParameters; reply: TGXByteBuffer);
  class function AppendMultipleSNBlocks(p: TGXDLMSSNParameters; header: TGXByteBuffer; reply: TGXByteBuffer): Integer;
  class function CheckWrapperAddress(
      settings: TGXDLMSSettings;
      buff: TGXByteBuffer;
      notify: TGXReplyData): Boolean;
  // Get data from Block.
  class function GetDataFromBlock(data: TGXByteBuffer; index: Integer) : Integer;
  // Handle read response and get data from block and/or update error status.
  class function HandleReadResponse(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer) : Boolean;
  // Get value from data.
  class procedure GetValueFromData(settings: TGXDLMSSettings; reply: TGXReplyData);

  class function GetData(
      settings: TGXDLMSSettings;
      reply: TGXByteBuffer;
      data: TGXReplyData;
      notify: TGXReplyData) : Boolean;

  // Get data from HDLC or wrapper frame.
  class procedure GetDataFromFrame(
    reply: TGXByteBuffer;
    info: TGXReplyData;
    hdlc: Boolean);

  class procedure HandleAccessResponse(settings: TGXDLMSSettings; reply: TGXReplyData);
  // Handle set response and update error status.
  class procedure HandleSetResponse(settings: TGXDLMSSettings; data: TGXReplyData);
  // Handle write response and update error status.
  class procedure HandleWriteResponse(data: TGXReplyData);
  // Handle get response with list.
  class procedure HandleGetResponseWithList(
      settings: TGXDLMSSettings;
      reply: TGXReplyData);

  // Handle get response and get data from block and/or update error status.
  class function HandleGetResponse(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer): Boolean;
  // Handle General block transfer message.
  class procedure HandleGbt(settings : TGXDLMSSettings; data: TGXReplyData);
  // Get PDU from the packet.
  class procedure GetPdu(settings : TGXDLMSSettings; data: TGXReplyData);

  // Split DLMS PDU to wrapper frames.
  class function GetWrapperFrame(settings: TGXDLMSSettings; data: TGXByteBuffer): TBytes;static;
  class function GetAddress(value: LongWord; size: WORD): Variant;static;
  class function GetAddressBytes(value: LongWord; size: WORD): TBytes;static;
  // Get data from HDLC frame.
  class function GetHdlcData(
      server: Boolean;
      settings: TGXDLMSSettings;
      reply: TGXByteBuffer;
      data: TGXReplyData;
      notify: TGXReplyData): Byte;static;
  // Get data from TCP/IP frame.
  class function GetTcpData(
      settings: TGXDLMSSettings;
      buff: TGXByteBuffer;
      data: TGXReplyData;
      notify: TGXReplyData): Boolean;static;
  // Check that client and server address match.
  class function CheckHdlcAddress(
      server: Boolean;
      settings: TGXDLMSSettings;
      reply: TGXByteBuffer;
      index: Integer;
      source: PInteger;
      target: PInteger): Boolean;

 // Get physical and logical address from server address.
  class procedure GetServerAddress(address: Integer; logical: PInteger; physical: PInteger);static;
  //Handle read response data block result.
  class function ReadResponseDataBlockResult(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer): Boolean;
  // Handle method response and get data from block and/or update error status.
  class procedure HandleMethodResponse(settings: TGXDLMSSettings; data: TGXReplyData);

  class procedure HandleDataNotification(settings: TGXDLMSSettings; reply: TGXReplyData);
  class procedure HandleGeneralCiphering(settings: TGXDLMSSettings; data: TGXReplyData);

  class procedure HandleExceptionResponse(data: TGXReplyData);
  class procedure HandleConfirmedServiceError(data : TGXReplyData);
  class function HandleGloRequest(settings: TGXDLMSSettings; data: TGXReplyData; cmd: Byte) : Integer;
  class procedure HandleGloDedResponse(settings: TGXDLMSSettings; data: TGXReplyData; index: Integer);

  protected

  public
  class function ReceiverReady(settings: TGXDLMSSettings; t: TRequestTypes): TBytes;static;
  // Check LLC bytes.
  class function GetLLCBytes(server: Boolean; data: TGXByteBuffer) : Boolean;static;
  // Handle push and get data from block and/or update error status.
  class procedure HandlePush(reply: TGXReplyData);

  class procedure AppendHdlcParameter(data: TGXByteBuffer; value: Integer);static;

end;

implementation
uses Gurux.DLMS.GXDLMSTranslator, TranslatorStandardTags, TranslatorSimpleTags;

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

class function TGXDLMS.GetInvokeIDPriority(settings: TGXDLMSSettings; AIncrease: Boolean) : Byte;
begin
  Result := 0;
  if settings.Priority = TPriority.prHigh Then
    Result := $80;

  if settings.ServiceClass = TServiceClass.scConfirmed Then
    Result := Result or $40;

  if AIncrease Then
    settings.InvokeID := ((settings.InvokeID + 1) and $F);
  Result := Result or settings.InvokeId;
end;

// Generates Invoke ID and priority.
class function TGXDLMS.GetLongInvokeIDPriority(settings: TGXDLMSSettings): Cardinal;
begin
  Result := 0;
  if settings.Priority = TPriority.prHigh Then
    Result := $80000000;

  if settings.ServiceClass = TServiceClass.scConfirmed Then
    Result := Result or $40000000;

  Result := Result or (settings.LongInvokeID and $FFFFFF);
  settings.LongInvokeID := settings.LongInvokeID + 1;
end;

// Generates an acknowledgment message, with which the server is informed to send next packets.
class function TGXDLMS.ReceiverReady(settings: TGXDLMSSettings; t : TRequestTypes): TBytes;
var
  p: TObject;
  bb : TGXByteBuffer;
  cmd : TCommand;
begin
  if t = TRequestTypes.rtNone then
      raise EArgumentException.Create('Invalid receiverReady RequestTypes parameter.');

  // Get next frame.
  if (Integer(t) and Integer(TRequestTypes.rtFrame)) <> 0 then
  begin
    Result := getHdlcFrame(settings, settings.ReceiverReady(), Nil);
    Exit;
  end;
  if settings.UseLogicalNameReferencing Then
  begin
    if settings.isServer Then
      cmd := TCommand.GetResponse
    else
      cmd := TCommand.GetRequest;
  end
  else
  begin
    if settings.isServer Then
      cmd := TCommand.ReadResponse
    else
      cmd := TCommand.ReadRequest;
  end;
  // Get next block.
  bb := TGXByteBuffer.Create(6);
  try
    if settings.UseLogicalNameReferencing Then
      bb.SetUInt32(settings.BlockIndex)
    else
      bb.SetUInt16(settings.BlockIndex);

    settings.IncreaseBlockIndex();
    if settings.UseLogicalNameReferencing Then
    begin
      p := TGXDLMSLNParameters.Create(settings, 0, cmd,
        Byte(TGetCommandType.ctNextDataBlock), bb, Nil, $ff, TCommand.None);
      try
        Result := GetLnMessages(p as TGXDLMSLNParameters)[0];
      finally
        p.Free;
      end;
    end
    else
    begin
      p := TGXDLMSSNParameters.Create(settings, cmd, 1,
        Byte(TVariableAccessSpecification.BlockNumberAccess), bb, Nil);
      try
        Result := GetSnMessages(p as TGXDLMSSNParameters)[0];
      finally
        p.Free;
      end;
    end;
  finally
    FreeAndNil(bb);
  end;
end;

// Reserved for internal use.
class procedure TGXDLMS.CheckInit(settings: TGXDLMSSettings);
begin
  if settings.ClientAddress = 0 Then
      raise EArgumentException.Create('Invalid Client Address.');

  if settings.ServerAddress = 0 Then
      raise EArgumentException.Create('Invalid Server Address.');
end;

class procedure TGXDLMS.AppendData(obj : TGXDLMSObject; index : Integer; bb : TGXByteBuffer; value : TValue);
var
  ui, tp: TDataType;
begin
    tp := obj.GetDataType(index);
    if tp = TDataType.dtArray Then
    begin
      if value.IsType<TBytes> Then
      begin
        if tp <> TDataType.dtOctetString Then
        begin
          bb.SetArray(value.AsType<TBytes>);
          Exit;
        end;
      end;
    end
    else
    begin
      if tp = TDataType.dtNone Then
      begin
          tp := TGXDLMSConverter.GetDLMSDataType(value);
          // If data type is not defined for Date Time it is write as octet string.
          if tp = TDataType.dtDateTime Then
            tp := TDataType.dtOctetString;
      end
      else if value.IsType<String> and (tp = TDataType.dtOctetString) Then
      begin
          ui := obj.GetUIDataType(index);
          if ui = TDataType.dtString Then
          begin
            TGXCommon.SetData(bb, tp, TValue.From(value.ToString.ToCharArray));
            Exit;
          end;
      end;
    end;
    TGXCommon.SetData(bb, tp, value);
end;

class function TGXDLMS.GetGloMessage(command: TCommand): TCommand;
begin
    case command of
    TCommand.ReadRequest: Result := TCommand.GloReadRequest;
    TCommand.GetRequest: Result := TCommand.GloGetRequest;
    TCommand.WriteRequest: Result := TCommand.GloWriteRequest;
    TCommand.SetRequest: Result := TCommand.GloSetRequest;
    TCommand.MethodRequest: Result := TCommand.GloMethodRequest;
    TCommand.ReadResponse: Result := TCommand.GloReadResponse;
    TCommand.GetResponse: Result := TCommand.GloGetResponse;
    TCommand.WriteResponse: Result := TCommand.GloWriteResponse;
    TCommand.SetResponse: Result := TCommand.GloSetResponse;
    TCommand.MethodResponse: Result := TCommand.GloMethodResponse;
    TCommand.DataNotification: Result := TCommand.GeneralGloCiphering;
    TCommand.ReleaseRequest: Result := TCommand.ReleaseRequest;
    TCommand.ReleaseResponse: Result := TCommand.ReleaseResponse;
    else
      raise EArgumentException.Create('Invalid GLO command.');
    end;
end;

class procedure TGXDLMS.AddLLCBytes(settings: TGXDLMSSettings; data: TGXByteBuffer);
begin
  data.Move(0, 3, data.Size);
  if settings.isServer Then
    System.Move(LLCReplyBytes, data.GetData()[0], 3)
  else
    System.Move(LLCSendBytes, data.GetData()[0], 3);
end;

class procedure TGXDLMS.MultipleBlocks(p : TGXDLMSLNParameters; reply: TGXByteBuffer; ciphering: Boolean);
var
  len: Integer;
begin
    // Check is all data fit to one message if data is given.
    len := p.Data.Size - p.Data.Position;
    if p.AttributeDescriptor <> Nil Then
        len := len + p.AttributeDescriptor.Size;

    if ciphering Then
        len := len + CIPHERING_HEADER_SIZE;

    if p.MultipleBlocks = False Then
    begin
        // Add command type and invoke and priority.
        p.MultipleBlocks := 2 + reply.Size + len > p.Settings.MaxPduSize;
    end;
    if p.MultipleBlocks = True Then
        // Add command type and invoke and priority.
        p.LastBlock := Not(8 + reply.Size + len > p.Settings.MaxPduSize);

    if p.LastBlock = True Then
        // Add command type and invoke and priority.
        p.LastBlock := Not(8 + reply.Size + len > p.Settings.MaxPduSize);
end;

// Get next logical name PDU.
class procedure TGXDLMS.GetLNPdu(p: TGXDLMSLNParameters; reply: TGXByteBuffer);
var
  len, pos, totalLength: Integer;
  ciphering : Boolean;
  tmp: TGXByteBuffer;
  value: byte;
  bb: TGXByteBuffer;
begin
    ciphering := (p.Command <> TCommand.AARQ)
            and (p.Command <> TCommand.AARE)
            and (p.Settings.Cipher <> Nil)
            and (p.Settings.Cipher.Security <> TSecurity.NONE);
    len := 0;
    if p.Command = TCommand.AARQ Then
    begin
     if (p.Settings.Gateway <> nil) and (p.Settings.Gateway.PhysicalDeviceAddress <> Nil) Then
     begin
       reply.SetUInt8(Integer(TCommand.GatewayRequest));
       reply.SetUInt8(p.Settings.Gateway.NetworkId);
       reply.SetUInt8(Length(p.Settings.Gateway.PhysicalDeviceAddress));
       reply.SetArray(p.Settings.Gateway.PhysicalDeviceAddress);
    end;
    reply.SetArray(p.AttributeDescriptor);
  end
  else
  begin
      // Add command.
      if (p.Command <> TCommand.GeneralBlockTransfer) Then
        reply.SetUInt8(Integer(p.Command));

      if (p.Command = TCommand.DataNotification) or
          (p.Command = TCommand.EventNotification) or
          (p.Command = TCommand.AccessRequest) or
          (p.Command = TCommand.AccessResponse) Then
      begin
        // Add Long-Invoke-Id-And-Priority
        if p.Command <> TCommand.DataNotification then
        begin
          if (p.InvokeId <> 0) Then
              reply.SetUInt32(p.InvokeId)
          else
            reply.SetUInt32(GetLongInvokeIDPriority(p.Settings));
        end;

        // Add date time.
        if p.Time = Nil Then
          reply.SetUInt8(Integer(TDataType.dtNone))
        else
        begin
            // Data is send in octet string. Remove data type.
            pos := reply.Size;
            TGXCommon.setData(reply, TDataType.dtOctetString, p.Time);
            reply.Move(pos + 1, pos, reply.Size - pos - 1);
        end;
        multipleBlocks(p, reply, ciphering);
      end
      else if (p.Command <> TCommand.ReleaseRequest) Then
      begin
        // Get request size can be bigger than PDU size.
        if (p.Command <> TCommand.GetRequest) and (p.Data <> Nil) and (p.Data.Size <> 0) Then
          multipleBlocks(p, reply, ciphering);

        // Change Request type if Set request and multiple blocks is needed.
        if (p.Command = TCommand.SetRequest) Then
        begin
          if p.MultipleBlocks and
            (Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer) = 0) Then
          begin
            if p.RequestType = 1 Then
              p.RequestType := 2
            else if p.RequestType = 2 Then
              p.RequestType := 3;
          end;
        end;
        // Change request type If get response and multiple blocks is needed.
        if p.Command = TCommand.GetResponse Then
          if (p.MultipleBlocks) and (Integer(TConformance.cfGeneralBlockTransfer) = 0) Then
            if p.RequestType = 1 Then
              p.RequestType := 2;
        if p.Command <> TCommand.GeneralBlockTransfer Then
        begin
          reply.SetUInt8(p.RequestType);
          // Add Invoke Id And Priority.
          if p.InvokeId <> 0 Then
            reply.SetUInt8(p.InvokeId)
          else
            reply.SetUInt8(GetInvokeIDPriority(p.Settings, p.Settings.AutoIncreaseInvokeID));
        end;
      end;
      // Add attribute descriptor.
      reply.SetArray(p.AttributeDescriptor);
      // If multiple blocks.
      if p.multipleBlocks and
        (Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer) = 0) Then
      begin
        // Is last block.
        if p.LastBlock Then
        begin
          reply.SetUInt8(1);
          p.Settings.Count := 0;
          p.Settings.Index := 0;
        end
        else
          reply.SetUInt8(0);

        // Block index.
        reply.SetUInt32(p.BlockIndex);
        p.BlockIndex := p.BlockIndex + 1;
        // Add status if reply.
        if p.Status <> $FF Then
        begin
          if (p.Status <> 0) and (p.Command = TCommand.GetResponse) Then
            reply.SetUInt8(1);

          reply.SetUInt8(p.Status);
        end;
        // Block size.
        if p.Data <> Nil Then
          len := p.Data.Size - p.Data.Position
        else
          len := 0;

        totalLength := len + reply.Size;
        if ciphering = True Then
          totalLength := totalLength + CIPHERING_HEADER_SIZE;


        if totalLength > p.Settings.MaxPduSize Then
        begin
            len := p.Settings.MaxPduSize - reply.Size;
            if ciphering Then
              len := len - CIPHERING_HEADER_SIZE;

            len := len - TGXCommon.GetObjectCountSizeInBytes(len);
        end;
        TGXCommon.SetObjectCount(len, reply);
        reply.SetArray(p.Data, len);
      end;
      // Add data that fits to one block.
      if len = 0 Then
      begin
        // Add status if reply.
        if (p.Status <> $FF) and (p.command <> TCommand.GeneralBlockTransfer) Then
        begin
            if (p.Status <> 0) and (p.Command = TCommand.GetResponse) Then
              reply.setUInt8(1);

            reply.setUInt8(p.Status);
        end;
        if (p.Data <> Nil) and (p.Data.Size <> 0) Then
        begin
          len := p.Data.Size - p.Data.Position;
          if (p.settings.Gateway <> Nil) and (p.settings.Gateway.PhysicalDeviceAddress <> Nil) Then
          begin
            if (3 + len + Length(p.settings.Gateway.PhysicalDeviceAddress)) > p.settings.MaxPduSize Then
                len := len - (3 + Length(p.settings.Gateway.PhysicalDeviceAddress));

            tmp := TGXByteBuffer.Create;
            try
              tmp.SetArray(reply);
              reply.Size := 0;
              reply.SetUInt8(Integer(TCommand.GatewayRequest));
              reply.SetUInt8(p.settings.Gateway.NetworkId);
              reply.SetUInt8(Length(p.settings.Gateway.PhysicalDeviceAddress));
              reply.SetArray(p.settings.Gateway.PhysicalDeviceAddress);
              reply.SetArray(tmp);
            finally
              FreeAndNil(tmp);
            end;

          end;

          // Get request size can be bigger than PDU size.
          if (Integer(p.settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer)) <> 0  Then
          begin
            if (7 + len + reply.Size > p.settings.MaxPduSize) Then
              len := p.settings.MaxPduSize - reply.Size - 7;

            //Cipher data only once.
            if ciphering and (p.command <> TCommand.GeneralBlockTransfer) Then
            begin
              reply.SetArray(p.data);
              Cipher0(p, reply);
              p.Data.Size := 0;
              p.Data.SetArray(reply);
              reply.Size := 0;
              len := p.Data.Size;
              if (7 + len > p.settings.MaxPduSize) Then
                len := p.settings.MaxPduSize - 7;
            end;
          end
          else if (p.Command <> TCommand.GetRequest) and (len + reply.Size > p.Settings.MaxPduSize) Then
              len := p.Settings.MaxPduSize - reply.Size;

          reply.SetArray(p.Data, len);
        end
        else if (((p.Settings.Gateway <> Nil) and (p.Settings.Gateway.PhysicalDeviceAddress <> Nil)) and
           Not ((p.Command = TCommand.GeneralBlockTransfer) or (p.multipleBlocks and ((Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer)) <> 0)))) Then
        begin
          if (3 + len + Length(p.settings.Gateway.PhysicalDeviceAddress)) > p.settings.MaxPduSize Then
              len := len - (3 + Length(p.settings.Gateway.PhysicalDeviceAddress));

          tmp := TGXByteBuffer.Create;
          try
            tmp.SetArray(reply);
            reply.Size := 0;
            reply.SetUInt8(Integer(TCommand.GatewayRequest));
            reply.SetUInt8(p.settings.Gateway.NetworkId);
            reply.SetUInt8(Length(p.settings.Gateway.PhysicalDeviceAddress));
            reply.SetArray(p.settings.Gateway.PhysicalDeviceAddress);
            reply.SetArray(tmp);
          finally
            FreeAndNil(tmp);
          end;
        end;
      end;

      if ciphering and (reply.Size <> 0) and (p.command <> TCommand.ReleaseRequest) and
        ((Not p.multipleBlocks) or
        ((Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer)) = 0)) Then
      begin
        //GBT ciphering is done for all the data, not just block.
        Cipher0(p, reply);
      end;

      if (p.command = TCommand.GeneralBlockTransfer) or (p.multipleBlocks and ((Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer)) <> 0)) Then
      begin
        bb := TGXByteBuffer.Create();
        try
          bb.SetArray(reply);
          reply.Clear();
          reply.SetUInt8(Integer(TCommand.GeneralBlockTransfer));
          value := 0;
          // Is last block
          if p.lastBlock then
            value := $80
          else if p.Streaming Then
            value := $40;

          value := value or p.WindowSize;
          reply.SetUInt8(value);
          // Set block number sent.
          reply.SetUInt16(p.blockIndex);
          p.blockIndex := p.blockIndex + 1;
          // Set block number acknowledged
          if (p.command <> TCommand.DataNotification) and (p.blockNumberAck <> 0) Then
          begin
            // Set block number acknowledged
            reply.SetUInt16(p.blockNumberAck);
            p.blockNumberAck := p.blockNumberAck + 1;
          end
          else
          begin
            p.blockNumberAck := $FFFF;
            reply.SetUInt16(0);
          end;
          //Add data length.
          TGXCommon.SetObjectCount(bb.Size, reply);
          reply.SetArray(bb);
        finally
          bb.Free;
        end;

        p.blockNumberAck := p.blockNumberAck + 1;
        if p.command <> TCommand.GeneralBlockTransfer Then
        begin
          p.command := TCommand.GeneralBlockTransfer;
         // p.BlockNumberAck := p.settings.BlockNumberAck + 1;
        end;
        if (p.settings.Gateway <> Nil) and (p.Settings.Gateway.PhysicalDeviceAddress <> Nil) Then
        begin
          if (3 + len + Length(p.settings.Gateway.PhysicalDeviceAddress)) > p.settings.MaxPduSize Then
            len := len - (3 + Length(p.settings.Gateway.PhysicalDeviceAddress));

          tmp := TGXByteBuffer.Create;
          try
            tmp.SetArray(reply);
            reply.Size := 0;
            reply.SetUInt8(Integer(TCommand.GatewayRequest));
            reply.SetUInt8(p.settings.Gateway.NetworkId);
            reply.SetUInt8(Length(p.settings.Gateway.PhysicalDeviceAddress));
            reply.SetArray(p.settings.Gateway.PhysicalDeviceAddress);
            reply.SetArray(tmp);
          finally
            FreeAndNil(tmp);
          end;
        end;

    end;
  end;
  if p.Settings.InterfaceType = TInterfaceType.HDLC Then
    AddLLCBytes(p.Settings, reply);
end;

class procedure TGXDLMS.Cipher0(p: TGXDLMSLNParameters; reply: TGXByteBuffer);
var
  cmd: BYTE;
  tmp: TBytes;
begin
  if (Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralProtection)) = 0 Then
    cmd := Byte(GetGloMessage(p.Command))
  else
    cmd := Byte(TCommand.GeneralGloCiphering);

  tmp := p.Settings.Cipher.Encrypt(cmd,
          p.Settings.Cipher.SystemTitle, reply.ToArray());
  reply.size := 0;
  if p.Settings.InterfaceType = TInterfaceType.HDLC Then
      AddLLCBytes(p.Settings, reply);

  if (p.Command = TCommand.DataNotification) or
  (Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralProtection) <> 0) Then
  begin
      // Add command.
      reply.setUInt8(tmp[0]);
      // Add system title.
      TGXCommon.SetObjectCount(Length(p.Settings.Cipher.SystemTitle), reply);
      reply.SetArray(p.Settings.Cipher.SystemTitle);
      // Add data.
      reply.SetArray(tmp, 1, Length(tmp) - 1);
  end
  else
    reply.SetArray(tmp);
end;

// Get all Logical name messages. Client uses this to generate messages.
class function TGXDLMS.GetLnMessages(p: TGXDLMSLNParameters): TArray<TBytes>;
var
  frame: Byte;
  bb: TGXByteBuffer;
  list: TList<TBytes>;
begin

  bb := TGXByteBuffer.Create();
  try

    list := TList<TBytes>.Create();
    try

      frame := 0;
      if (p.Command = TCommand.EventNotification) or (p.Command = TCommand.DataNotification) Then
        frame := $13;
      repeat
      begin
        GetLNPdu(p, bb);
        p.LastBlock := True;
        if p.AttributeDescriptor = Nil Then
          p.Settings.increaseBlockIndex();

        if (p.Command = TCommand.AARQ) and (p.Command = TCommand.GetRequest) Then
            assert (Not(p.Settings.MaxPduSize < bb.Size));

        while (bb.Position <> bb.Size) do
        begin
            if p.Settings.InterfaceType = TInterfaceType.WRAPPER Then
                list.Add(GetWrapperFrame(p.Settings, bb))
            else if (p.Settings.InterfaceType = TInterfaceType.HDLC) Then
            begin
                list.Add(GetHdlcFrame(p.Settings, frame, bb));
                if bb.Position <> bb.Size Then
                  frame := p.Settings.NextSend(false);
            end
            else if (p.Settings.InterfaceType = TInterfaceType.PDU) Then
            begin
              list.add(bb.ToArray());
              break;
            end
            else
              raise EArgumentException.Create('InterfaceType');
        end;
        bb.Clear();
        frame := 0;
      end;
      until (p.Data = Nil) or (p.Data.position = p.Data.Size);
      Result := list.ToArray();
    finally
      list.Free;
    end;

  finally
    bb.Free;
  end;

end;

// Get all Short Name messages. Client uses this to generate messages.
class function TGXDLMS.GetSnMessages(p: TGXDLMSSNParameters): TArray<TBytes>;
var
  frame: Byte;
  bb: TGXByteBuffer;
  list: TList<TBytes>;
begin
  bb := TGXByteBuffer.Create();
  try
    list := TList<TBytes>.Create();
    try
      frame := $0;
      if (p.Command = TCommand.InformationReport) or (p.Command = TCommand.DataNotification) Then
        frame := $13;
      repeat
      begin
        GetSNPdu(p, bb);
        if (p.Command <> TCommand.AARQ) and (p.Command <> TCommand.AARE) Then
          Assert(Not (p.Settings.MaxPduSize > bb.Size));

        // Command is not add to next PDUs.
        while (bb.Position <> bb.Size) do
        begin
          if p.Settings.InterfaceType = TInterfaceType.WRAPPER Then
            list.Add(GetWrapperFrame(p.Settings, bb))
          else if p.Settings.InterfaceType = TInterfaceType.HDLC Then
          begin
            list.add(GetHdlcFrame(p.Settings, frame, bb));
            if bb.position <> bb.Size Then
              frame := p.Settings.NextSend(false);
          end
          else if p.Settings.InterfaceType = TInterfaceType.PDU Then
          begin
            list.Add(bb.ToArray());
            break;
          end
          else
            raise EArgumentException.Create('InterfaceType');
        end;
        bb.clear();
        frame := 0;
      end;
      until (p.Data = Nil) or (p.Data.Position = p.Data.Size);
      Result := list.ToArray;
    finally
      list.Free;
    end;
  finally
    bb.Free;
  end;
end;

class function TGXDLMS.AppendMultipleSNBlocks(p: TGXDLMSSNParameters; header: TGXByteBuffer; reply: TGXByteBuffer): Integer;
var
  hSize: Integer;
  ciphering : Boolean;
begin
  ciphering := (p.Settings.Cipher <> Nil) and (p.Settings.Cipher.Security <> TSecurity.None);
  hSize := reply.Size + 3;
  if (header <> Nil) Then
    hSize := hSize + header.Size;

  // Add LLC bytes.
  if (p.Command = TCommand.WriteRequest) or (p.Command = TCommand.ReadRequest) Then
    hSize := hSize + 1 + TGXCommon.GetObjectCountSizeInBytes(p.Count);

  Result := p.Settings.MaxPduSize - hSize;
  if ciphering = True Then
  begin
    Result := Result - CIPHERING_HEADER_SIZE;
    if (p.Settings.InterfaceType = TInterfaceType.HDLC) Then
      Result := Result - 3;
  end;
  Result := Result - TGXCommon.GetObjectCountSizeInBytes(Result);
  if (p.Data.Size - p.Data.Position > Result) Then
    // More blocks.
    reply.SetUInt8(0)
  else
  begin
    // Last block.
    reply.setUInt8(1);
    Result := p.Data.Size - p.Data.Position;
  end;
  // Add block index.
  reply.SetUInt16(p.BlockIndex);
  if p.Command = TCommand.WriteRequest Then
  begin
    p.BlockIndex := p.BlockIndex + 1;
    TGXCommon.SetObjectCount(p.Count, reply);
    reply.SetUInt8(Integer(TDataType.dtOctetString));
  end
  else if p.Command = TCommand.ReadRequest Then
    p.BlockIndex := p.BlockIndex + 1;

  if (header <> Nil) Then
  begin
    TGXCommon.SetObjectCount(Result + header.Size, reply);
    reply.SetArray(header);
  end
  else
    TGXCommon.SetObjectCount(Result, reply);
end;

class procedure TGXDLMS.GetSNPdu(p: TGXDLMSSNParameters; reply: TGXByteBuffer);
var
  ciphering: Boolean;
  pos, offset, cnt, cipherSize: Integer;
  tmp: TBytes;
begin
    cnt := 0;
    cipherSize := 0;
    ciphering := (p.Settings.Cipher <> Nil) and (p.Settings.Cipher.Security <> TSecurity.NONE);
    if ((Not ciphering or (p.Command = TCommand.AARQ)
            or (p.Command = TCommand.AARE))
            and (p.Settings.InterfaceType = TInterfaceType.HDLC)) Then
    begin
      if p.Settings.isServer Then
        TGXDLMS.AddLLCBytes(p.Settings, reply)
      else if reply.Size = 0 Then
        TGXDLMS.AddLLCBytes(p.Settings, reply);
    end;

    if ciphering Then
        cipherSize := CIPHERING_HEADER_SIZE;
    if p.Data <> Nil Then
        cnt := p.Data.Size - p.Data.Position;

    // Add command.
    if p.Command = TCommand.InformationReport Then
    begin
      reply.SetUInt8(Byte(p.Command));
      // Add date time.
      if p.Time = 0 Then
        reply.SetUInt8(Byte(TDataType.dtNONE))
      else
      begin
        // Data is send in octet string. Remove data type.
        pos := reply.size;
        TGXCommon.SetData(reply, TDataType.dtOctetString, p.Time);
        reply.move(pos + 1, pos, reply.Size - pos - 1);
      end;
      TGXCommon.SetObjectCount(p.Count, reply);
      reply.SetArray(p.AttributeDescriptor);
    end
    else if (p.Command <> TCommand.AARQ) and (p.Command <> TCommand.AARE) Then
    begin
      reply.SetUInt8(Byte(p.Command));
      if p.Count <> $FF Then
        TGXCommon.SetObjectCount(p.Count, reply);

      if p.RequestType <> $FF Then
        reply.SetUInt8(Byte(p.RequestType));

      reply.SetArray(p.AttributeDescriptor);

      if Not p.MultipleBlocks Then
      begin
        p.MultipleBlocks := reply.Size + cipherSize + cnt > p.Settings.MaxPduSize;
        // If reply data is not fit to one PDU.
        if p.MultipleBlocks Then
        begin
          reply.Size := 0;
          if Not ciphering and (p.Settings.InterfaceType = TInterfaceType.HDLC) Then
          begin
            if p.Settings.isServer Then
              TGXDLMS.AddLLCBytes(p.Settings, reply)
            else if reply.Size = 0 Then
              TGXDLMS.AddLLCBytes(p.Settings, reply);
          end;
          if p.Command = TCommand.WriteRequest Then
            p.RequestType := Byte(TVariableAccessSpecification.WriteDataBlockAccess)
          else if p.Command = TCommand.ReadRequest Then
            p.RequestType := Byte(TVariableAccessSpecification.ReadDataBlockAccess)
          else if p.Command = TCommand.ReadResponse Then
            p.RequestType := Byte(TSingleReadResponse.DataBlockResult)
          else
            raise EArgumentException.Create('Invalid command.');

          reply.setUInt8(Integer(p.Command));
          // Set object count.
          reply.setUInt8(1);
          if p.RequestType <> $FF Then
            reply.setUInt8(p.RequestType);

          cnt := AppendMultipleSNBlocks(p, Nil, reply);
        end;
      end
    else
      cnt := appendMultipleSNBlocks(p, Nil, reply);
    end;
    // Add data.
    reply.SetArray(p.Data, cnt);
    // If all data is transfered.
    if (p.Data <> Nil) and (p.Data.Position = p.Data.Size) Then
    begin
      p.Settings.Index := 0;
      p.Settings.Count := 0;
    end;
    // If Ciphering is used.
    if ciphering and (p.Command <> TCommand.AARQ) and (p.Command <> TCommand.AARE) Then
    begin
        tmp := p.Settings.Cipher.Encrypt(Byte(GetGloMessage(p.Command)),
                p.Settings.Cipher.SystemTitle, reply.ToArray());
        assert(Not p.Settings.MaxPduSize < Length(tmp));
        reply.size := 0;
        if p.Settings.InterfaceType = TInterfaceType.HDLC Then
        begin
          if p.Settings.IsServer Then
            TGXDLMS.AddLLCBytes(p.Settings, reply)
          else if reply.Size = 0 Then
            TGXDLMS.AddLLCBytes(p.Settings, reply);
        end;
        reply.SetArray(tmp);
    end;
end;

class function TGXDLMS.GetAddress(value: LongWord; size: WORD): Variant;
begin
  if (size < 2) and (value < $80) Then
    Result := Byte((value shl 1) or 1)
  else if (size < 4) and (value < $4000) Then
      Result := WORD(((value and $3F80) shl 2) or ((value and $7F) shl 1) or 1)
  else if (value < $10000000) Then
      Result := LONGWORD(((value and $FE00000) shl 4) or ((value and $1FC000) shl 3)
                      or ((value and $3F80) shl 2) or ((value and $7F) shl 1) or 1)
  else
    raise EArgumentException.Create('Invalid address.');
end;

class function TGXDLMS.GetAddressBytes(value: LongWord; size: WORD): TBytes;
var
  tmp: Variant;
  bb: TGXByteBuffer;
begin
  tmp := GetAddress(value, size);
  bb := TGXByteBuffer.Create();
  try
    if VarType(tmp) = VarByte Then
      bb.SetUInt8(tmp)
    else if VarType(tmp) = VarWord Then
      bb.SetUInt16(tmp)
    else if VarType(tmp) = VarLongWord Then
      bb.SetUInt32(tmp)
    else
      raise EArgumentException.Create('Invalid address type.');
    Result := bb.ToArray();
  finally
    FreeAndNil(bb);
  end;
end;

// Split DLMS PDU to wrapper frames.
class function TGXDLMS.GetWrapperFrame(settings: TGXDLMSSettings; data: TGXByteBuffer): TBytes;
var
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
  try
    // Add version.
    bb.setUInt16(1);
    if settings.IsServer Then
    begin
      bb.setUInt16(settings.ServerAddress);
      bb.setUInt16(settings.ClientAddress);
    end
    else
    begin
      bb.setUInt16(settings.ClientAddress);
      bb.setUInt16(settings.ServerAddress);
    end;
    if data = Nil Then
      // Data length.
      bb.setUInt16(0)
    else
    begin
      // Data length.
      bb.SetUInt16(data.Size);
      // Data
      bb.SetArray(data);
    end;
    // Remove sent data in server side.
    if settings.IsServer Then
    begin
        if data.Size = data.position Then
          data.clear()
        else
        begin
          data.Move(data.position, 0, data.Size - data.position);
          data.Position := 0;
        end;
    end;
    Result := bb.ToArray();
  finally
    FreeAndNil(bb);
  end;
end;

// Get HDLC frame for data.
class function TGXDLMS.GetHdlcFrame(settings: TGXDLMSSettings; frame: Byte; data: TGXByteBuffer) : TBytes;
var
  bb: TGXByteBuffer;
  crc, frameSize, len: Integer;
  primaryAddress, secondaryAddress: TBytes;
begin
  bb := TGXByteBuffer.Create();
  try
    len := 0;
    if settings.IsServer Then
    begin
      primaryAddress := getAddressBytes(settings.ClientAddress, 0);
      secondaryAddress := getAddressBytes(settings.ServerAddress,
        settings.ServerAddressSize);
    end
    else
    begin
      primaryAddress := getAddressBytes(settings.ServerAddress,
          settings.ServerAddressSize);
      secondaryAddress := getAddressBytes(settings.ClientAddress, 0);
    end;
    // Add BOP
    bb.setUInt8(HDLCFrameStartEnd);
    frameSize := Integer(settings.Limits.MaxInfoTX);
    if (data <> Nil) and (data.Position = 0) Then
      frameSize := frameSize - 3;

    len := 0;
    // If no data
    if (data = Nil) or (data.Size = 0) Then
      bb.setUInt8($A0)
    else if (data.Size - data.Position <= frameSize) Then
    begin
      len := data.Size - data.position;
      // Is last packet.
      bb.SetUInt8($A0 or (((7 + Length(primaryAddress) + Length(secondaryAddress) + len) shr 8) and $7));
    end
    else
    begin
      len := frameSize;
      // More data to left.
      bb.SetUInt8($A8 or ((len shr 8) and $7));
    end;
    // Frame len.
    if (len = 0) Then
      bb.setUInt8(5 + Length(primaryAddress) + Length(secondaryAddress) + len)
    else
      bb.setUInt8(7 + Length(primaryAddress) + Length(secondaryAddress) + len);

    // Add primary address.
    bb.SetArray(primaryAddress);
    // Add secondary address.
    bb.SetArray(secondaryAddress);

    // Add frame ID.
    if frame = 0 Then
      bb.setUInt8(settings.NextSend(true))
    else
      bb.setUInt8(frame);

    // Add header CRC.
    crc := TGXFCS16.CountFCS16(bb.GetData, 1, bb.Size - 1);
    bb.SetUInt16(crc);
    if len <> 0 Then
    begin
        // Add data.
        bb.SetArray(data, len);
        // Add data CRC.
        crc := TGXFCS16.CountFCS16(bb.GetData, 1, bb.Size - 1);
        bb.SetUInt16(crc);
    end;
    // Add EOP
    bb.SetUInt8(HDLCFrameStartEnd);
    // Remove sent data in server side.
    if settings.isServer Then
    begin
        if data <> Nil Then
        begin
            if data.Size = data.Position Then
                data.clear()
            else
            begin
              data.move(data.Position, 0, data.Size - data.Position);
              data.Position := 0;
            end;
        end;
    end;
    Result := bb.ToArray();
  finally
    FreeAndNil(bb);
  end;

end;

class function TGXDLMS.GetLLCBytes(server: Boolean; data: TGXByteBuffer) : Boolean;
begin
  if server Then
    Result := data.Compare(LLCSendBytes)
  else
    Result :=data.Compare(LLCReplyBytes);
end;

class function TGXDLMS.GetHdlcData(
    server: Boolean;
    settings: TGXDLMSSettings;
    reply: TGXByteBuffer;
    data: TGXReplyData;
    notify: TGXReplyData): Byte;
var
  ch, frame: Byte;
  tmp, crc, crcRead: WORD;
  source, target, pos, eopPos, packetStartID, frameLen: Integer;
  isNotify: Boolean;
begin
  isNotify := False;
  packetStartID := reply.Position;
  frameLen := 0;
  // If whole frame is not received yet.
  if (reply.Size - reply.Position < 9) Then
  begin
    data.Complete := false;
    Result := 0;
    Exit;
  end;
  data.Complete := true;
  if notify <> Nil Then
    notify.Complete := True;

  // Find start of HDLC frame.
  for pos := reply.Position to reply.Size - 1 do
  begin
    ch := reply.GetUInt8();
    if ch = HDLCFrameStartEnd Then
    begin
      packetStartID := pos;
      break;
    end;
  end;
  // Not a HDLC frame.
  // Sometimes meters can send some strange data between DLMS frames.
  if reply.position = reply.Size Then
  begin
    data.Complete := false;
    if notify <> Nil Then
      notify.Complete := True;
    // Not enough data to parse;
    Result := 0;
    Exit;
  end;
  frame := reply.GetUInt8();
  if (frame and $F0) <> $A0 Then
  begin
    // If same data.
    Result := getHdlcData(server, settings, reply, data, notify);
    Exit;
  end;

  // Check frame length.
  if (frame and $7) <> 0 Then
    frameLen := (frame and $7) shl 8;

  ch := reply.GetUInt8();
  // If not enough data.
  frameLen := frameLen + ch;
  if (reply.Size - reply.Position + 1 < frameLen) Then
  begin
    data.Complete := false;
    reply.Position := packetStartID;
    // Not enough data to parse;
    Result :=  0;
    Exit;
  end;
  eopPos := frameLen + packetStartID + 1;
  ch := reply.getUInt8(eopPos);
  if ch <> HDLCFrameStartEnd Then
  begin
    reply.Position := reply.Position - 2;
    Result := GetHdlcData(server, settings, reply, data, notify);
    Exit;
  end;
  // Check addresses.
  if Not CheckHdlcAddress(server, settings, reply, eopPos, @source, @target) Then
  begin
    //If not notify.
    if Not ((reply.Position < reply.Size) and (reply.GetUInt8(reply.Position) = $13)) Then
    begin
      //If echo.
      reply.Position := 1 + eopPos;
      Result := GetHdlcData(server, settings, reply, data, notify);
      Exit;
    end
    else if notify <> Nil Then
    begin
      isNotify := true;
      notify.ClientAddress := target;
      notify.ServerAddress := source;
    end;

  end;

  // Is there more data available.
  if ((frame and $8) <> 0) Then
    if isNotify Then
      notify.MoreData := TRequestTypes(Integer(data.MoreData) or Integer(TRequestTypes.rtFrame))
    else
      data.MoreData := TRequestTypes(Integer(data.MoreData) or Integer(TRequestTypes.rtFrame))
  else
    if isNotify Then
      notify.MoreData := TRequestTypes(Integer(data.MoreData) and Not Integer(TRequestTypes.rtFrame))
    else
      data.MoreData := TRequestTypes(Integer(data.MoreData) and Not Integer(TRequestTypes.rtFrame));

  // Get frame type.
  frame := reply.GetUInt8();
  if Not settings.CheckFrame(frame) Then
  begin
    reply.Position := (eopPos + 1);
    Result := GetHdlcData(server, settings, reply, data, notify);
    Exit;
  end;
  // Check that header CRC is correct.
  crc := TGXFCS16.CountFCS16(reply.GetData, packetStartID + 1, reply.position - packetStartID - 1);
  crcRead := reply.getUInt16();
  if (crc <> crcRead) Then
    raise TGXDLMSException.Create('Wrong CRC.');

  // Check that packet CRC match only if there is a data part.
  if (reply.Position <> packetStartID + frameLen + 1) Then
  begin
    crc := TGXFCS16.CountFCS16(reply.GetData, packetStartID + 1, frameLen - 2);
    crcRead := reply.GetUInt16(packetStartID + frameLen - 1);
    if crc <> crcRead Then
      raise TGXDLMSException.Create('Wrong CRC.');
    // Remove CRC and EOP from packet length.
    if isNotify Then
      notify.PacketLength := eopPos - 2
    else
      data.PacketLength := eopPos - 2;
  end
  else
    if isNotify Then
      notify.PacketLength := reply.Position + 1
    else
      data.PacketLength := reply.Position + 1;

  if (frame <> $13) and ((frame and Integer(THdlcFrameType.Uframe)) = Integer(THdlcFrameType.Uframe)) Then
  begin
    // Get Eop if there is no data.
    if (reply.Position = packetStartID + frameLen + 1) Then
      // Get EOP.
      reply.GetUInt8();

    if frame = $97 Then
      data.Error := Integer(TErrorCode.ecUnacceptableFrame)
    else if frame = $1f Then
      data.Error := Integer(TErrorCode.ecDisconnectMode);

    data.Command := TCommand(frame);
  end
  else if (frame <> $13) and ((frame and Integer(THdlcFrameType.Sframe)) = Integer(THdlcFrameType.Sframe)) Then
  begin
      // If S-frame
      tmp := (frame shr 2) and $3;
      // If frame is rejected.
      if tmp = Integer(THdlcControlFrame.cfReject) Then
        data.Error := Integer(TErrorCode.ecRejected)
      else if tmp = Integer(THdlcControlFrame.cfReceiveNotReady) Then
        data.Error := Integer(TErrorCode.ecReceiveNotReady)
      else if tmp = Integer(THdlcControlFrame.cfReceiveReady) Then
        data.Error := Integer(TErrorCode.ecOK);
      // Get next frame.

      // Get Eop if there is no data.
      if (reply.Position = packetStartID + frameLen + 1) Then
        // Get EOP.
        reply.GetUInt8();
  end
  else
  begin
    // I-frame
    // Get Eop if there is no data.
    if (reply.Position = packetStartID + frameLen + 1) Then
    begin
      // Get EOP.
      reply.GetUInt8();
      if (frame and $1) = $1 Then
        data.MoreData := TRequestTypes.rtFrame;
    end
    else if Not GetLLCBytes(server, reply) Then
      GetLLCBytes(Not server, reply);
  end;
  Result := frame;
end;

// Get physical and logical address from server address.
class procedure TGXDLMS.GetServerAddress(address: Integer; logical: PInteger; physical: PInteger);
begin
  if (address < $4000) then
  begin
      logical^ := address shr 7;
      physical^ := address and $7F;
  end
  else
  begin
      logical^ := address shr 14;
      physical^ := address and $3FFF;
  end;
end;

// Check that client and server address match.
class function TGXDLMS.CheckHdlcAddress(
    server: Boolean;
    settings: TGXDLMSSettings;
    reply: TGXByteBuffer;
    index: Integer;
    source: PInteger;
    target: PInteger): Boolean;
var
  readLogical, readPhysical, logical, physical: Integer;
begin
  // Get destination and source addresses.
  target^ := TGXCommon.GetHDLCAddress(reply);
  source^ := TGXCommon.GetHDLCAddress(reply);
  if server Then
  begin
      // Check that server addresses match.
      if (settings.ServerAddress <> 0) and (settings.ServerAddress <> target^) Then
      begin
        if reply.GetUInt8(reply.Position) = Integer(TCommand.SNRM) Then
          settings.ServerAddress := target^
        else
          raise TGXDLMSException.Create('Server addresses do not match. It is '
                + IntToStr(target^) + '. It should be '
                + IntToStr(settings.ServerAddress)
                + '.');

      end;
      settings.ServerAddress := target^;

      // Check that client addresses match.
      if (settings.ClientAddress <> 0) and (settings.ClientAddress <> source^) Then
      begin
        if reply.GetUInt8(reply.Position) = Integer(TCommand.SNRM) Then
          settings.ClientAddress := source^
        else
          raise TGXDLMSException.Create(
            'Client addresses do not match. It is '
                    + IntToStr(source^) + '. It should be '
                    + IntToStr(settings.ClientAddress)
                    + '.');
      end
      else
        settings.ClientAddress := source^;
  end
  else
  begin
    // Check that client addresses match.
    if settings.ClientAddress <> target^ Then
    begin
        // If echo.
        if (settings.ClientAddress = source^) and (settings.ServerAddress = target^) Then
        begin
          reply.Position := (index + 1);
          Result := false;
          Exit;
        end;
        raise TGXDLMSException.Create(
                'Destination addresses do not match. It is '
                        + IntToStr(target^) + '. It should be '
                        + IntToStr(settings.ClientAddress)
                        + '.');
    end;
    // Check that server addresses match.
    if (settings.ServerAddress <> source^) and
        // If All-station (Broadcast).
        (settings.ServerAddress <> $7F) and (settings.ServerAddress <> $3FFF) Then
    begin
        // Check logical and physical address separately.
        // This is done because some meters might send four bytes
        // when only two bytes is needed.
        GetServerAddress(source^, @readLogical, @readPhysical);
        GetServerAddress(settings.ServerAddress, @logical, @physical);
        if (readLogical <> logical) or (readPhysical <> physical) Then
            raise TGXDLMSException.Create(
                    'Source addresses do not match. It is '
                            + IntToStr(source^) + '. It should be '
                            + IntToStr(
                                    settings.ServerAddress)
                            + '.');

    end;
end;
  Result := true;
end;

class function TGXDLMS.GetTcpData(
    settings: TGXDLMSSettings;
    buff: TGXByteBuffer;
    data: TGXReplyData;
    notify: TGXReplyData): Boolean;
var
  pos, value : Integer;
begin
  Result := True;
  // If whole frame is not received yet.
  if buff.Size - buff.position < 8 Then
  begin
    data.Complete := false;
    Exit;
  end;
  pos := buff.Position;
  data.Complete := false;
  if notify <> Nil Then
    notify.Complete := false;

  while buff.Available > 1 do
  begin
    // Get version
    value := buff.GetUInt16();
    if value = 1 Then
    begin
      // Check TCP/IP addresses.
      if Not CheckWrapperAddress(settings, buff, notify) Then
      begin
        data := notify;
        Result := false;
      end;
      // Get length.
      value := buff.getUInt16();
      data.Complete := Not((buff.Size - buff.Position) < value);
      if Not data.Complete Then
        buff.Position := pos
      else
        data.PacketLength := buff.Position + value;
      break;
    end
    else
      buff.Position := buff.Position - 1;
  end;
end;

class function TGXDLMS.CheckWrapperAddress(
    settings: TGXDLMSSettings;
    buff: TGXByteBuffer;
    notify: TGXReplyData): Boolean;
var
  value: Integer;
begin
  Result := True;
  if settings.IsServer Then
  begin
    value := buff.GetUInt16();
    // Check that client addresses match.
    if (settings.ClientAddress <> 0) and (settings.ClientAddress <> value) Then
      raise TGXDLMSException.Create(
                'Source addresses do not match. It is '
                        + IntToStr(value) + '. It should be '
                        + IntToStr(settings.ClientAddress)
                        + '.')
    else
      settings.ClientAddress := value;

    value := buff.GetUInt16();
    // Check that server addresses match.
    if (settings.ServerAddress <> 0) and (settings.ServerAddress <> value) Then
      raise TGXDLMSException.Create(
                'Destination addresses do not match. It is '
                        + IntToStr(value) + '. It should be '
                        + IntToStr(settings.ServerAddress)
                        + '.')
    else
      settings.ServerAddress := value;
  end
  else
  begin
    value := buff.getUInt16();
    // Check that server addresses match.
    if (settings.ClientAddress <> 0) and (settings.ServerAddress <> value) Then
    begin
      if notify = Nil Then
        raise TGXDLMSException.Create(
                  'Source addresses do not match. It is '
                          + IntToStr(value) + '. It should be '
                          + IntToStr(settings.ServerAddress)
                          + '.');
      notify.ServerAddress := value;
      Result := False;
    end
    else
      settings.ServerAddress := value;

    value := buff.getUInt16();
    // Check that client addresses match.
    if (settings.ClientAddress <> 0) and (settings.ClientAddress <> value) Then
    begin
      if notify = Nil Then
        raise TGXDLMSException.Create(
                'Destination addresses do not match. It is '
                        + IntToStr(value) + '. It should be '
                        + IntToStr(settings.ClientAddress)
                        + '.');
      notify.ClientAddress := value;
      Result := False;
    end
    else
      settings.ClientAddress := value;
  end;
end;

// Handle read response data block result.
class function TGXDLMS.ReadResponseDataBlockResult(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer): Boolean;
var
  lastBlock: Byte;
  expectedIndex, number, blockLength: Integer;
begin
    reply.Error := 0;
    lastBlock := reply.Data.GetUInt8();
    // Get Block number.
    number := reply.Data.GetUInt16();
    blockLength := TGXCommon.GetObjectCount(reply.Data);
    // Check block length when all data is received.
    if Integer(reply.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
    begin
        if (blockLength <> (reply.Data.Size - reply.Data.position)) Then
            raise EArgumentException.Create('Invalid block length.');
        reply.Command := TCommand.NONE;
    end;
    GetDataFromBlock(reply.Data, index);
    // Is Last block.
    if lastBlock = 0 Then
    begin
      reply.MoreData := TRequestTypes(Integer(reply.MoreData) or Integer(TRequestTypes.rtDataBlock));
       reply.TotalCount := 0;
    end
    else
      reply.MoreData := TRequestTypes(Integer(reply.MoreData) and Not Integer(TRequestTypes.rtDataBlock));

    // If meter's block index is zero based.
    if (number <> 1) and (settings.BlockIndex = 1) Then
      settings.BlockIndex := number;

    expectedIndex := settings.BlockIndex;
    if (number <> expectedIndex) Then
        raise TGXDLMSException.Create('Invalid Block number. It is ' + IntToStr(number)
                + ' and it should be ' + IntToStr(expectedIndex) + '.');

    // If last packet and data is not try to peek.
    if reply.MoreData = TRequestTypes.rtNone Then
    begin
        reply.Data.Position := 0;
        reply.CommandType := byte(TSingleReadResponse.Data);
        HandleReadResponse(settings, reply, index);
        settings.ResetBlockIndex();
    end;
    Result := true;
end;

// Handle read response and get data from block and/or update error status.
class function TGXDLMS.HandleReadResponse(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer) : Boolean;
var
  number, pos, cnt: Integer;
  values: TList<TValue>;
  standardXml, first: Boolean;
  tp: TSingleReadResponse;
  di: TGXDataInfo;
begin
  values := nil;
  try
  cnt := reply.TotalCount;
  // If we are reading value first time or block is handed.
  first := (reply.TotalCount = 0) or (reply.CommandType = BYTE(TSingleReadResponse.DataBlockResult));
  if first Then
  begin
    cnt := TGXCommon.GetObjectCount(reply.Data);
    reply.TotalCount := cnt;
  end;
  values := Nil;
  if cnt <> 1 Then
  begin
      //Parse data after all data is received when readlist is used.
      if reply.IsMoreData Then
      begin
        GetDataFromBlock(reply.Data, 0);
        Result := false;
        Exit;
      end;
      if not first Then
      begin
        reply.Data.Position := 0;
        first := true;
      end;
    values := TList<TValue>.Create();
    if reply.Value.IsArray and (reply.Value.GetArrayLength <> 0) Then
      values.AddRange(reply.Value.AsType<TArray<TValue>>);
    reply.Value := Nil;
  end;
  if reply.Xml <> Nil Then
    reply.Xml.AppendStartTag(LONGWORD(TCommand.ReadResponse), 'Qty', reply.Xml.IntegerToHex(cnt, 2), False);

    standardXml := (reply.Xml <> Nil) and (reply.Xml.OutputType = TTranslatorOutputType.StandardXml);
    for pos := 0 to cnt - 1 do
    begin
      // Get status code. Status code is begin of each PDU.
      if first Then
      begin
        tp := TSingleReadResponse(reply.Data.GetUInt8());
        reply.CommandType := BYTE(tp);
      end
      else
        tp := TSingleReadResponse(reply.CommandType);
      case tp of
      TSingleReadResponse.Data:
      begin
          reply.Error := 0;
          if reply.Xml <> Nil Then
          begin
            if standardXml Then
              reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Choice));
            reply.Xml.AppendStartTag(TCommand.ReadResponse, LONGWORD(TSingleReadResponse.Data));
            di := TGXDataInfo.Create();
            try
              di.xml := reply.Xml;
              TGXCommon.GetData(reply.Data, di);
            finally
              FreeAndNil(di);
            end;
            reply.Xml.AppendEndTag(TCommand.ReadResponse, LONGWORD(TSingleReadResponse.Data));
            if standardXml Then
                reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.Choice));
          end
          else if cnt = 1 Then
            GetDataFromBlock(reply.Data, 0)
          else
          begin
            reply.ReadPosition := reply.Data.Position;
            GetValueFromData(settings, reply);
            reply.Data.Position := reply.ReadPosition;
            values.Add(reply.Value);
            reply.Value := Nil;
          end;
      end;
      TSingleReadResponse.DataAccessError:
      begin
        // Get error code.
        reply.Error := reply.Data.GetUInt8();
        if reply.Xml <> Nil Then
        begin
          if standardXml Then
              reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Choice));

          reply.Xml.AppendLine(
              (Integer(TCommand.ReadResponse) shl 8) or Integer(TSingleReadResponse.DataAccessError),
              '', TGXDLMSTranslator.ErrorCodeToString(
                  reply.Xml.OutputType, TErrorCode(reply.Error)));
          if standardXml Then
            reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.Choice));
        end
      end;
      TSingleReadResponse.DataBlockResult:
      begin
        if Not ReadResponseDataBlockResult(settings, reply, index) Then
        begin
          //If xml only received bytes are shown. Data is not try to parse.
          if reply.Xml <> Nil Then
            reply.Xml.AppendEndTag(LONGWORD(TCommand.ReadResponse));
          Result := false;
          Exit;
        end;
      end;
      TSingleReadResponse.BlockNumber:
      begin
        // Get Block number.
        number := reply.Data.GetUInt16();
        if number <> settings.BlockIndex Then
            raise EArgumentException.create(
                'Invalid Block number. It is ' + IntToStr(number)
                + ' and it should be ' + IntToStr(settings.BlockIndex) + '.');

        settings.IncreaseBlockIndex();
        reply.MoreData := TRequestTypes(LONGWORD(reply.MoreData) or LONGWORD(TRequestTypes.rtDataBlock));
      end
      else
        raise TGXDLMSException.Create('HandleReadResponse failed. Invalid tag.');
    end;
    end;
    if reply.Xml <> Nil Then
    begin
      reply.Xml.AppendEndTag(LONGWORD(TCommand.ReadResponse));
      Result := true;
      Exit;
    end;
    if values <> Nil Then
      reply.Value := TValue.From(values.toArray());
    Result := cnt = 1;
  finally
    FreeAndNil(values);
  end;
end;

// Handle method response and get data from block and/or update error status.
class procedure TGXDLMS.HandleMethodResponse(
    settings: TGXDLMSSettings;
    data: TGXReplyData);
var
  ret, t: Byte;
  di: TGXDataInfo;
begin
  // Get type.
  t := data.Data.GetUInt8();
  // Get invoke ID and priority.
  data.InvokeId := data.Data.GetUInt8();
  TGXDLMS.VerifyInvokeId(settings, data);
  if data.Xml <> Nil Then
  begin
    data.Xml.AppendStartTag(LONGWORD(TCommand.MethodResponse));
    data.Xml.AppendStartTag(TCommand.MethodResponse, t);
    //InvokeIdAndPriority
    data.Xml.AppendLine(LONGWORD(TTranslatorTags.InvokeId), '',
        data.Xml.IntegerToHex(data.InvokeId, 2));
  end;
  if t = 1 Then
  begin
    // Get Action-Result
    ret := data.Data.GetUInt8();
    if data.Xml <> Nil Then
    begin
      if data.Xml.OutputType = TTranslatorOutputType.StandardXml Then
        data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.SingleResponse));

      data.Xml.AppendLine(LONGWORD(TTranslatorTags.Result), '',
          TGXDLMSTranslator.ErrorCodeToString(data.Xml.OutputType, TErrorCode(ret)));
    end;
    if ret <> 0 Then
        data.Error := ret;

    // Action-Response-Normal. Get data if exists. All meters do not
    // return data here.
    if (data.Error = 0) AND (data.Data.Position < data.Data.Size) Then
    begin
      // Get-Data-Result
      ret := data.Data.GetUInt8();
      if ret = 0 Then
        getDataFromBlock(data.Data, 0)
      else if ret = 1 Then
      begin
        // Get Data-Access-Result.
        ret := data.Data.GetUInt8();
        if ret <> 0 Then
        begin
          data.Error := data.Data.GetUInt8();
          // Handle Texas Instrument missing byte here.
          if (ret = 9) and (data.Error = 16) Then
          begin
            data.Data.Position := (data.Data.Position - 2);
            GetDataFromBlock(data.Data, 0);
            data.Error := 0;
            ret := 0;
          end;
        end
        else
          GetDataFromBlock(data.Data, 0);
      end
      else
        raise TGXDLMSException.Create('HandleActionResponseNormal failed. '
                          + 'Invalid tag.');

    if (data.Xml <> Nil) and ((data.Error <> 0) or (data.Data.Position < data.Data.Size)) Then
    begin
        data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.ReturnParameters));
        if ret <> 0 Then
        begin
          data.Xml.AppendLine(LONGWORD(TTranslatorTags.DataAccessError), '',
              TGXDLMSTranslator.ErrorCodeToString(data.Xml.OutputType, TErrorCode(data.Error)));
        end
        else
        begin
          data.Xml.AppendStartTag(TCommand.ReadResponse, LONGWORD(TSingleReadResponse.Data));
          di := TGXDataInfo.Create();
          try
            di.Xml := data.Xml;
            TGXCommon.GetData(data.Data, di);
          finally
            FreeAndNil(di);
          end;
          data.Xml.AppendEndTag(TCommand.ReadResponse, LONGWORD(TSingleReadResponse.Data));
        end;
        data.Xml.AppendEndTag(LONGWORD(TTranslatorTags.ReturnParameters));
        if data.Xml.OutputType = TTranslatorOutputType.StandardXml Then
          data.Xml.AppendEndTag(LONGWORD(TSingleReadResponse.Data));
    end;
  end;
  end
else if t = 2 Then
  // Action-Response-With-Pblock
  raise EArgumentException.Create('Invalid TCommand.')
else if t = 3 Then
  // Action-Response-With-List.
  raise EArgumentException.Create('Invalid TCommand.')
else if (t = 4) Then
  // Action-Response-Next-Pblock
  raise EArgumentException.Create('Invalid TCommand.')
else
  raise EArgumentException.Create('Invalid TCommand.');
end;

// Handle push and get data from block and/or update error status.
class procedure TGXDLMS.HandlePush(reply: TGXReplyData);
var
  len, last, index: Integer;
begin
  index := reply.Data.Position - 1;
  // Is last block
  last := reply.Data.GetUInt8();
  if (last and $80) = 0 Then
    reply.MoreData := TRequestTypes(Integer(reply.MoreData) or Integer(TRequestTypes.rtDataBlock))
  else
      reply.MoreData := TRequestTypes(Integer(reply.MoreData) and Not Integer(TRequestTypes.rtDataBlock));

  // Get block number sent.
  reply.Data.GetUInt8();
  // Get block number acknowledged
  reply.Data.GetUInt8();
  // Get APU tag.
  reply.Data.GetUInt8();
  // Addl fields
  reply.Data.GetUInt8();
  // Data-Notification
  if (reply.Data.GetUInt8() and $0F) = 0 Then
    raise EArgumentException.Create('Invalid data.');

  // Long-Invoke-Id-And-Priority
  reply.Data.GetUInt32();
  // Get date time and skip it if used.
  len := reply.Data.GetUInt8();
  if len <> 0 Then
    reply.Data.Position := (reply.Data.Position + len);

  GetDataFromBlock(reply.Data, index);
end;

class procedure TGXDLMS.HandleAccessResponse(settings: TGXDLMSSettings; reply: TGXReplyData);
var
  ct, err, ch: Byte;
  pos, len, invokeId: LongWord;
  tmp: TBytes;
  tm: TGXDateTime;
  di: TGXDataInfo;
  value: TValue;
begin
  // Get invoke id.
  invokeId := reply.Data.GetUInt32();
  len := reply.Data.GetUInt8();
  tmp := Nil;
  // If date time is given.
  if len <> 0 Then
  begin
      SetLength(tmp, len);
      reply.Data.Get(tmp);
      tm := TGXCommon.ChangeType(tmp, TDataType.dtDateTime).AsType<TGXDateTime>;
      reply.Time := tm.LocalTime;
      FreeAndNil(tm);
  end;
  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendStartTag(LONGWORD(TCommand.AccessResponse));
    reply.Xml.AppendLine(LONGWORD(TTranslatorTags.LongInvokeId), '', reply.Xml.IntegerToHex(invokeId, 8));
    if reply.Time <> 0 Then
    begin
      reply.Xml.AppendComment(DateTimeToStr(reply.Time));
    end;
    reply.Xml.AppendLine(LONGWORD(TTranslatorTags.DateTime), '', TGXByteBuffer.ToHexString(tmp, False, 0, Length(tmp)));
    //access-request-specification OPTIONAL
    ch := reply.Data.GetUInt8;
    len := TGXCommon.GetObjectCount(reply.Data);
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessResponseBody));
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessResponseListOfData), 'Qty', reply.Xml.IntegerToHex(len, 2), False);
    for pos := 1 to len do
    begin
      if reply.Xml.OutputType = TTranslatorOutputType.StandardXml Then
          reply.Xml.AppendStartTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
      begin
        di := TGXDataInfo.Create();
        try
          di.Xml := reply.Xml;
          TGXCommon.GetData(reply.Data, di);
        finally
          FreeAndNil(di);
        end;
      end;
      if reply.Xml.OutputType = TTranslatorOutputType.StandardXml Then
      begin
        reply.Xml.AppendEndTag(TCommand.WriteRequest, LONGWORD(TSingleReadResponse.Data));
      end;
    end;
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessResponseListOfData));
    //access-response-specification
    len := TGXCommon.GetObjectCount(reply.Data);
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.ListOfAccessResponseSpecification), 'Qty', reply.Xml.IntegerToHex(len, 2), False);
    for pos := 1 to len do
    begin
      ct := reply.Data.GetUInt8();
      err := reply.Data.GetUInt8();
      if err <> 0 Then
      begin
        err := reply.Data.GetUInt8();
      end;
      reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.AccessResponseSpecification));
      reply.Xml.AppendStartTag(TCommand.AccessResponse, LONGWORD(ct));
      reply.Xml.AppendLine(LONGWORD(TTranslatorTags.RESULT), '', TGXDLMSTranslator.ErrorCodeToString(reply.Xml.OutputType, TErrorCode(err)));
      reply.Xml.AppendEndTag(TCommand.AccessResponse, LONGWORD(ct));
      reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessResponseSpecification));
    end;
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.ListOfAccessResponseSpecification));
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.AccessResponseBody));
    reply.Xml.AppendEndTag(LONGWORD(TCommand.AccessResponse));
  end
  else
    // Skip access-request-specification
    reply.Data.GetUInt8();
end;

// Handle data notification get data from block and/or update error status.
class procedure TGXDLMS.HandleDataNotification(settings: TGXDLMSSettings; reply: TGXReplyData);
var
  len: Byte;
  start: Integer;
  invokeId: LongWord;
  tmp: TBytes;
  dt: TDataType;
  info: TGXDataInfo;
  ret: TValue;
  tmp2: TGXByteBuffer;
  di: TGXDataInfo;
begin
start := reply.Data.Position - 1;
  // Get invoke id.
  invokeId := reply.Data.GetUInt32();
  // Get date time.
  reply.Time := 0;
  len := reply.Data.GetUInt8();
  tmp := Nil;
  // If date time is given.
  if len <> 0 Then
  begin
    SetLength(tmp, len);
    reply.Data.Get(tmp);
    dt := TDataType.dtDateTime;
    if len = 4 Then
      dt := TDataType.dtTime
    else if len = 5 Then
      dt := TDataType.dtDate;

    info := TGXDataInfo.Create();
    try
      info.&Type := dt;
      tmp2 := TGXByteBuffer.Create();
      try
        tmp2.SetArray(tmp);
        ret := TGXCommon.GetData(tmp2, info);
      finally
        FreeAndNil(tmp2);
      end;
      reply.Time := ret.AsType<TGXDateTime>.LocalTime;
    finally
      if ret.IsType<TGXDateTime> then
        ret.AsType<TGXDateTime>.Free;
      info.Free;
    end;
  end;
  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendStartTag(LONGWORD(TCommand.DataNotification));
    reply.Xml.AppendLine(LONGWORD(TTranslatorTags.LongInvokeId), '',
        reply.Xml.IntegerToHex(invokeId, 8));
    if reply.Time <> 0 Then
        reply.Xml.AppendComment(DateTimeToStr(reply.Time));

    reply.Xml.AppendLine(LONGWORD(TTranslatorTags.DateTime), '',
        TGXCommon.ToHexString(tmp, False, 0, Length(tmp)));
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.NotificationBody));
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.DataValue));
    di := TGXDataInfo.Create();
    try
      di.Xml := reply.Xml;
      TGXCommon.GetData(reply.Data, di);
    finally
      FreeAndNil(di);
    end;
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.DataValue));
    reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.NotificationBody));
    reply.Xml.AppendEndTag(LONGWORD(TCommand.DataNotification));
  end
  else
  begin
    GetDataFromBlock(reply.Data, start);
    GetValueFromData(settings, reply);
  end;
end;

// Handle set response and update error status.
class procedure TGXDLMS.HandleSetResponse(
  settings: TGXDLMSSettings;
  data: TGXReplyData);
var
  pos, cnt: Integer;
  number: UInt32;
  err: Byte;
  t: TSetResponseType;
begin
  t := TSetResponseType(data.Data.GetUInt8());
  // Invoke ID and priority.
  data.InvokeId := data.Data.GetUInt8();
  TGXDLMS.VerifyInvokeId(settings, data);

  if data.Xml <> Nil Then
  begin
    data.Xml.AppendStartTag(LONGWORD(TCommand.SetResponse));
    data.Xml.AppendStartTag(TCommand.SetResponse, Integer(t));
    //InvokeIdAndPriority
    data.Xml.AppendLine(LONGWORD(TTranslatorTags.InvokeId), '', data.Xml.IntegerToHex(data.InvokeId, 2));
  end;
  // SetResponseNormal
  if t = TSetResponseType.srNormal Then
  begin
    data.Error := data.Data.GetUInt8();
    if data.Xml <> Nil Then
    begin
      // Result start tag.
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.Result), '',
          TGXDLMSTranslator.ErrorCodeToString(data.Xml.OutputType, TErrorCode(data.Error)));
    end;
  end
  else if t = TSetResponseType.srDataBlock Then
  begin
    number := data.Data.GetUInt32();
    if data.Xml <> Nil Then
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', data.Xml.IntegerToHex(number, 8));
  end
  else if t = TSetResponseType.srLastDataBlock Then
  begin
    data.Error := data.Data.GetUInt8();
    number := data.Data.GetUInt32();
    if data.Xml <> Nil Then
    begin
      // Result start tag.
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.Result), '',
                          TGXDLMSTranslator.ErrorCodeToString(
                              data.Xml.OutputType,
                              TErrorCode(data.Error)));
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', data.Xml.IntegerToHex(number, 8));
    end;
  end
  else if t = TSetResponseType.srWithList Then
  begin
    cnt := TGXCommon.GetObjectCount(data.Data);
    if data.Xml <> Nil Then
    begin
      data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Result), 'Qty', data.Xml.IntegerToHex(cnt, 2), False);
      for pos := 1 to cnt do
      begin
        data.Error := data.Data.GetUInt8();
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.DataAccessResult), '',
            TGXDLMSTranslator.ErrorCodeToString(data.Xml.OutputType, TErrorCode(data.Error)));
      end;
      data.Xml.AppendEndTag(LONGWORD(TTranslatorTags.Result));
    end
    else
      for pos := 1 to cnt do
      begin
        err := data.Data.GetUInt8();
        if (data.Error = 0) and (err <> 0) Then
            data.Error := err;
      end;
  end
  else
    raise EArgumentException.Create('Invalid data type.');
  if data.Xml <> Nil Then
  begin
      data.Xml.AppendEndTag(TCommand.SetResponse, LONGWORD(t));
      data.Xml.AppendEndTag(LONGWORD(TCommand.SetResponse));
  end;
end;

// Handle write response and update error status.
class procedure TGXDLMS.HandleWriteResponse(data: TGXReplyData);
var
  pos, ret, cnt: Integer;
begin
  cnt := TGXCommon.getObjectCount(data.Data);
  for pos := 0 to cnt - 1 do
  begin
    ret := data.Data.GetUInt8();
    if ret <> 0 Then
      data.Error := data.Data.GetUInt8();
  end;
end;

// Handle get response with list.
class procedure TGXDLMS.HandleGetResponseWithList(settings: TGXDLMSSettings; reply: TGXReplyData);
var
  ch: Byte;
  pos, cnt, blockLength: Integer;
  expectedIndex, number: LongWord;
  values: TList<TValue>;
  empty: Boolean;
  di: TGXDataInfo;
begin
  // Get object count.
  cnt := TGXCommon.GetObjectCount(reply.Data);
  values := TList<TValue>.Create();
  if reply.Xml <> Nil Then
  begin
    //Result start tag.
    reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Result), 'Qty', reply.Xml.IntegerToHex(cnt, 2), false);
  end;
  try
    for pos := 0 to cnt - 1 do
    begin
      // Result
      ch := reply.Data.GetUInt8();
      if ch <> 0 Then
        reply.Error := reply.Data.GetUInt8()
      else
      begin
        reply.Value := Nil;
        reply.ReadPosition := reply.Data.Position;
        GetValueFromData(settings, reply);
        reply.Data.Position := reply.ReadPosition;
        if reply.Value.IsArray then
          values.AddRange(reply.Value)
        else
          values.Add(reply.Value);
        reply.Value := Nil;
      end;
    end;
    reply.Value := TValue.From(values.ToArray());
  finally
    FreeAndNil(values);
  end;
end;

class procedure TGXDLMS.VerifyInvokeId(settings: TGXDLMSSettings; reply: TGXReplyData);
begin
  if (reply.Xml = Nil) and settings.AutoIncreaseInvokeID and
                (reply.InvokeId <> TGXDLMS.GetInvokeIDPriority(settings, False)) Then
            raise EArgumentException.Create(
                    'Invalid invoke ID. Expected: ' +
                    IntToHex(TGXDLMS.GetInvokeIDPriority(settings, False)) +
                    '. Actual: ' +
                    IntToHex(reply.InvokeId));
end;

// Handle get response and get data from block and/or update error status.
class function TGXDLMS.HandleGetResponse(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer): Boolean;
var
  ch: Byte;
  pos, cnt, blockLength: Integer;
  expectedIndex, number: LongWord;
  values: TList<TValue>;
  empty: Boolean;
  di: TGXDataInfo;
begin
  //long number;
  Result := true;
  empty := False;
  ch := 0;
  // Get type.
  reply.CommandType := reply.Data.GetUInt8();
  // Get invoke ID and priority.
  reply.InvokeId := reply.Data.GetUInt8();
  TGXDLMS.VerifyInvokeId(settings, reply);

  if reply.Xml <> Nil Then
  begin
    reply.Xml.AppendStartTag(LONGWORD(TCommand.GetResponse));
    reply.Xml.AppendStartTag(TCommand.GetResponse, LONGWORD(reply.CommandType));
    //InvokeIdAndPriority
    reply.Xml.AppendLine(LONGWORD(TTranslatorTags.InvokeId), '', reply.Xml.IntegerToHex(reply.InvokeId, 2));
  end;
  // Response normal
  if TGetCommandType(reply.CommandType) = TGetCommandType.ctNormal Then
  begin
    if reply.Data.Available() = 0 Then
    begin
      empty := True;
      GetDataFromBlock(reply.Data, 0);
    end
    else
    begin
      // Result
      ch := reply.Data.GetUInt8();
      if ch <> 0 Then
        reply.Error := reply.Data.GetUInt8();
      if reply.Xml <> Nil Then
      begin
        // Result start tag.
        reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Result));
        if reply.Error <> 0 Then
            reply.Xml.AppendLine(LONGWORD(TTranslatorTags.DataAccessError), '',
                TGXDLMSTranslator.ErrorCodeToString(reply.Xml.OutputType, TErrorCode(reply.Error)))
        else
        begin
          reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Data));
          di := TGXDataInfo.Create();
          try
            di.xml := reply.Xml;
            TGXCommon.GetData(reply.Data, di);
          finally
            FreeAndNil(di);
          end;
          reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.Data));
        end;
      end
      else
        GetDataFromBlock(reply.Data, 0);
    end;
  end
  else if TGetCommandType(reply.CommandType) = TGetCommandType.ctNextDataBlock Then
  begin
    // GetResponsewithDataBlock
    // Is Last block.
    ch := reply.Data.GetUInt8();
    if reply.Xml <> Nil Then
    begin
      //Result start tag.
      reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Result));
      //LastBlock
      reply.Xml.AppendLine(LONGWORD(TTranslatorTags.LastBlock), '', reply.Xml.IntegerToHex(ch, 2));
    end;
    if ch = 0 Then
      reply.MoreData := TRequestTypes(Integer(reply.MoreData) or Integer(TRequestTypes.rtDataBlock))
    else
      reply.MoreData := TRequestTypes(Integer(reply.MoreData) and Not Integer(TRequestTypes.rtDataBlock));

    // Get Block number.
    number := reply.Data.GetUInt32();
    //BlockNumber
    if reply.Xml <> Nil Then
        reply.Xml.AppendLine(LONGWORD(TTranslatorTags.BlockNumber), '', reply.Xml.IntegerToHex(number, 8))
    else
    begin
      // If meter's block index is zero based.
      if (number = 0) and (settings.BlockIndex = 1) Then
        settings.BlockIndex := 0;

      expectedIndex := settings.BlockIndex;
      if (number <> expectedIndex) Then
        raise EArgumentException.Create(
                  'Invalid Block number. It is ' + IntToStr(number)
                          + ' and it should be ' + IntToStr(expectedIndex)
                          + '.');
    end;
    // Get status.
    ch := reply.Data.GetUInt8();
    if ch <> 0 Then
      reply.Error := reply.Data.GetUInt8();

    if reply.Xml <> Nil Then
    begin
      //Result
      reply.Xml.AppendStartTag(LONGWORD(TTranslatorTags.Result));
      if reply.Error <> 0 Then
        reply.Xml.AppendLine(LONGWORD(TTranslatorTags.DataAccessResult), '',
            TGXDLMSTranslator.ErrorCodeToString(reply.Xml.OutputType, TErrorCode(reply.Error)))
      else if reply.Data.Available <> 0 Then
      begin
        // Get data size.
        blockLength := TGXCommon.GetObjectCount(reply.Data);
        // if whole block is read.
        if (Integer(reply.MoreData)) and Integer(TRequestTypes.rtFrame) = 0 Then
          // Check Block length.
          if blockLength > reply.Data.Available() Then
            reply.Xml.AppendComment('Block is not complete.' + IntToStr(reply.Data.Available()) + '/' + IntToStr(blockLength) + '.');

        reply.Xml.AppendLine(LONGWORD(TTranslatorTags.RawData), '',
                             reply.Data.ToHex(False, reply.Data.Position, reply.Data.Available()));
      end;
      reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.Result));
    end
    else if reply.Data.Available() <> 0 Then
    begin
        // Get data size.
        blockLength := TGXCommon.GetObjectCount(reply.Data);
        // if whole block is read.
        if Integer(reply.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
        begin
          // Check Block length.
          if (blockLength > reply.Data.Size - reply.Data.Position) Then
            raise EArgumentException.Create('Invalid block length.');

          reply.Command := TCommand.NONE;
        end;
        // If meter sends empty data block.
        if blockLength = 0 Then
          reply.Data.Size := index
        else
          GetDataFromBlock(reply.Data, index);

        // If last packet and data is not try to peek.
        if (reply.MoreData = TRequestTypes.rtNone) Then
        begin
          if Not reply.Peek Then
          begin
            reply.Data.Position := 0;
            settings.ResetBlockIndex();
          end;
        end;
        if (reply.MoreData = TRequestTypes.rtNone) and
            (settings.Command = TCommand.GetRequest) and
            (settings.CommandType = TGetCommandType.ctWithList) Then
        begin
          HandleGetResponseWithList(settings, reply);
          Result := False;
        end;
    end;
  end
  else if TGetCommandType(reply.CommandType) = TGetCommandType.ctWithList Then
  begin
    HandleGetResponseWithList(settings, reply);
    Result := False;
  end
  else
    raise EArgumentException.Create('Invalid Get response.');
  if reply.Xml <> Nil Then
  begin
    if Not empty Then
      reply.Xml.AppendEndTag(LONGWORD(TTranslatorTags.Result));
    reply.Xml.AppendEndTag(TCommand.GetResponse, reply.CommandType);
    reply.Xml.AppendEndTag(LONGWORD(TCommand.GetResponse));
  end;
end;

// Handle General block transfer message.
class procedure TGXDLMS.HandleGbt(
    settings : TGXDLMSSettings;
    data: TGXReplyData);
var
  ch: Byte;
  bn, bna: WORD;
  len, index: Integer;
begin
    index := data.Data.Position - 1;
    data.WindowSize := settings.WindowSize;
    //BlockControl
    ch := data.Data.GetUInt8();
    // Is streaming active.
    data.Streaming := (ch and $40) <> 0;
    //GBT Window size.
    data.WindowSize := (ch and $3F);
    //Block number.
    bn := data.Data.GetUInt16();
    //Block number acknowledged.
    bna := data.Data.GetUInt16();

    //Block number.
    data.BlockNumber := bn;
    //Block number acknowledged.
    data.BlockNumberAck := bna;
    if data.Xml <> Nil Then
    begin
      // Remove existing data when first block is received.
      if bn = 1 Then
        index := 0
      else if bna <> settings.BlockIndex - 1 Then
      begin
        // If this block is already received.
        data.Data.Size := index;
        data.Command := TCommand.None;
        Exit;
      end;
    end;

    settings.BlockNumberAck := data.BlockNumber;
    data.Command := TCommand.None;
    len := TGXCommon.GetObjectCount(data.Data);
    if len > data.Data.Available Then
    begin
      data.Complete := false;
      Exit;
    end;

    GetDataFromBlock(data.Data, index);
    //Is Last block,
    if (ch and $80) = 0 Then
      data.MoreData := TRequestTypes(Integer(data.MoreData) or Integer(TRequestTypes.rtGBT))
    else
    begin
        data.MoreData := TRequestTypes(Integer(data.MoreData) and Not Integer(TRequestTypes.rtGBT));
        if data.Data.Size <> 0 Then
        begin
            data.Data.Position := 0;
            GetPdu(settings, data);
        end;
        // Get data if all data is read or we want to peek data.
        if (data.Data.Position <> data.Data.Size) and
            ((data.Command = TCommand.ReadResponse) or (data.Command = TCommand.GetResponse))
             and ((data.MoreData = TRequestTypes.rtNone) or data.Peek) Then
        begin
            data.Data.Position := 0;
            GetValueFromData(settings, data);
        end;
    end;
end;

// Get PDU from the packet.
class procedure TGXDLMS.GetPdu(settings : TGXDLMSSettings; data: TGXReplyData);
var
  len, index: Integer;
  cmd: TCommand;
  pda: TBytes;
begin
    cmd := data.Command;
    // If header is not read yet or GBT message.
    if data.Command = TCommand.NONE Then
    begin
        // If PDU is missing.
        if data.Data.Size - data.Data.Position = 0 Then
          raise EArgumentException.Create('Invalid PDU.');

        index := data.Data.Position;
        // Get command.
        cmd := TCommand(data.Data.GetUInt8());
        data.Command := cmd;
        case cmd of
        TCommand.ReadResponse:
        begin
          if Not handleReadResponse(settings, data, index) Then
              Exit;
        end;
        TCommand.GetResponse:
        begin
          if Not handleGetResponse(settings, data, index) Then
              Exit;
        end;
        TCommand.SetResponse:
          HandleSetResponse(settings, data);
        TCommand.WriteResponse:
          HandleWriteResponse(data);
        TCommand.MethodResponse:
          HandleMethodResponse(settings, data);
        TCommand.AccessResponse:
          HandleAccessResponse(settings, data);
        TCommand.GeneralBlockTransfer:
          HandleGbt(settings, data);
        TCommand.AARQ, TCommand.AARE:
            // This is parsed later.
            data.Data.Position := (data.Data.Position - 1);
        TCommand.ReleaseResponse:
        begin
        //Do nothing.
        end;
        TCommand.ConfirmedServiceError:
            HandleConfirmedServiceError(data);
        TCommand.ExceptionResponse:
            HandleExceptionResponse(data);
        TCommand.GetRequest,
        TCommand.ReadRequest,
        TCommand.WriteRequest,
        TCommand.SetRequest,
        TCommand.MethodRequest,
        TCommand.ReleaseRequest:
          // Server handles this.
          if (Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) <> 0) Then
          begin
            //Do nothing.
          end;
        TCommand.GloReadRequest, TCommand.GloWriteRequest, TCommand.GloGetRequest,
        TCommand.GloSetRequest, TCommand.GloMethodRequest:
            cmd := TCommand(HandleGloRequest(settings, data, Byte(cmd)));
            // Server handles this.
        TCommand.GloReadResponse,
        TCommand.GloWriteResponse,
        TCommand.GloGetResponse,
        TCommand.GloSetResponse,
        TCommand.GloMethodResponse,
        TCommand.GeneralGloCiphering,
        TCommand.GloEventNotificationRequest:
            HandleGloDedResponse(settings, data, index);
        TCommand.DataNotification:
            HandleDataNotification(settings, data);
        TCommand.EventNotification:
          begin
          //Client handles this.
          end;
        TCommand.InformationReport:
          begin
          //Client handles this.
          end;
        TCommand.GeneralCiphering:
          HandleGeneralCiphering(settings, data);
        TCommand.GatewayRequest,
        TCommand.GatewayResponse:
        begin
          data.Data.GetUInt8();
          len := TGXCommon.GetObjectCount(data.Data);
          SetLength(pda, len);
          data.Data.Get(pda);
          GetDataFromBlock(data.Data, index);
          data.Command := TCommand.None;
          GetPdu(settings, data);
        end
        else
          raise EArgumentException.Create('Invalid TCommand.');
        end;
    end
    else if (Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0) Then
    begin
        // Is whole block is read and if last packet and data is not try to
        // peek.
        if Not data.Peek and (data.MoreData = TRequestTypes.rtNone) Then
        begin
          if (data.Command = TCommand.AARE) or (data.Command = TCommand.AARQ) Then
            data.Data.Position := 0
          else
            data.Data.Position := 1;
        end;
        // Get command if operating as a server.
        if settings.isServer Then
        begin
            // Ciphered messages are handled after whole PDU is received.
            case cmd of
              TCommand.GloReadRequest,
              TCommand.GloWriteRequest,
              TCommand.GloGetRequest,
              TCommand.GloSetRequest,
              TCommand.GloMethodRequest,
              TCommand.GloEventNotificationRequest:
              begin
                data.Command := TCommand.NONE;
                data.Data.Position := data.CipherIndex;
                GetPdu(settings, data);
              end;
            end;
        end
        else
        begin
            if (data.Command = TCommand.ReadResponse) and (Not data.isMoreData) Then
            begin
              data.Data.Position := 0;
              if data.CommandType = Byte(TSingleReadResponse.DataBlockResult) Then
                data.CommandType := Byte(TSingleReadResponse.Data);

              if Not HandleReadResponse(settings, data, 0) Then
                Exit;
            end;
            // Client do not need a command any more.
            data.Command := TCommand.None;
            // Ciphered messages are handled after whole PDU is received.
            case TCommand(cmd) of
              TCommand.GloReadResponse,
              TCommand.GloWriteResponse,
              TCommand.GloGetResponse,
              TCommand.GLOSetResponse,
              TCommand.GLOMethodResponse,
              TCommand.DedReadResponse,
              TCommand.DedWriteResponse,
              TCommand.DedGetResponse,
              TCommand.DedSetResponse,
              TCommand.DedMethodResponse,
              TCommand.GeneralGloCiphering,
              TCommand.GeneralDedCiphering,
              TCommand.GeneralCiphering,
              TCommand.AccessResponse:
              begin
                data.Data.Position := data.CipherIndex;
                GetPdu(settings, data);
              end;
            end;
        end;
    end;
    // Get data if all data is read or we want to peek data.
    if ((data.Error = 0) AND ((data.Data.Position <> data.Data.Size)
            and ((cmd = TCommand.ReadResponse) or (cmd = TCommand.GetResponse)
                    or (cmd = TCommand.MethodResponse))
            and ((data.MoreData = TRequestTypes.rtNone) or data.Peek))) Then
        getValueFromData(settings, data);
end;

class procedure TGXDLMS.HandleExceptionResponse(data: TGXReplyData);
var
  state: TExceptionStateError;
  error: TExceptionServiceError;
  value: TValue;
begin
  state := TExceptionStateError(data.Data.GetUInt8());
  error := TExceptionServiceError(data.Data.GetUInt8());
  value := Nil;
  if (error = TExceptionServiceError.InvocationCounterError) and (data.Data.Available > 3) Then
  begin
    value := TValue.From(data.Data.GetUInt32());
  end;
  if data.Xml <> Nil Then
  begin
    data.Xml.AppendStartTag(LONGWORD(TCommand.ExceptionResponse));
    if data.Xml.OutputType = TTranslatorOutputType.StandardXml Then
    begin
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.StateError), '',
          TTranslatorStandardTags.StateErrorToString(state));
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.ServiceError), '',
         TTranslatorStandardTags.ExceptionServiceErrorToString(error));
    end
    else
    begin
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.StateError), '',
          TTranslatorSimpleTags.StateErrorToString(state));
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.ServiceError), '',
          TTranslatorSimpleTags.ExceptionServiceErrorToString(error));
    end;
    data.Xml.AppendEndTag(LONGWORD(TCommand.ExceptionResponse));
  end
  else
  begin
    raise TGXDLMSExceptionResponse.Create(state, error, value);
  end;
end;

class procedure TGXDLMS.HandleConfirmedServiceError(data : TGXReplyData);
var
  service: TConfirmedServiceError;
  t: TServiceError;
  ch: BYTE;
begin
  if data.Xml <> Nil Then
  begin
    data.Xml.AppendStartTag(LONGWORD(TCommand.ConfirmedServiceError));
    if data.Xml.OutputType = TTranslatorOutputType.StandardXml Then
    begin
      ch := data.Data.GetUInt8();
      data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.InitiateError));
      ch := data.Data.GetUInt8();
      t := TServiceError(ch);
      ch := data.Data.GetUInt8();
      data.Xml.AppendLine('x:' + TTranslatorStandardTags.ServiceErrorToString(t), '', TTranslatorStandardTags.GetServiceErrorValue(t, ch));
      data.Xml.AppendEndTag(LONGWORD(TTranslatorTags.InitiateError));
    end
    else
    begin
      ch := data.Data.GetUInt8();
      data.Xml.AppendLine(LONGWORD(TTranslatorTags.Service), '', data.Xml.IntegerToHex(ch, 2));
      ch := data.Data.GetUInt8();
      t := TServiceError(ch);
      data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.ServiceError));
      ch := data.Data.GetUInt8();
      data.Xml.AppendLine(TTranslatorSimpleTags.ServiceErrorToString(t), '', TTranslatorSimpleTags.GetServiceErrorValue(t, ch));
      data.Xml.AppendEndTag(LONGWORD(TTranslatorTags.ServiceError));
    end;
    data.Xml.AppendEndTag(LONGWORD(TCommand.ConfirmedServiceError));
  end
  else
  begin
    service := TConfirmedServiceError(data.Data.GetUInt8());
    t := TServiceError(data.Data.GetUInt8());
    raise TGXDLMSConfirmedServiceError.Create(service, t, data.Data.GetUInt8());
  end;
end;

class function TGXDLMS.HandleGloRequest(settings: TGXDLMSSettings; data: TGXReplyData; cmd: Byte) : Integer;
begin
  if settings.Cipher = Nil Then
    raise EArgumentException.Create('Secure connection is not supported.');

  Result := cmd;
  // If all frames are read.
  if Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
  begin
    data.Data.Position := (data.Data.Position - 1);
    settings.Cipher.Decrypt(settings.SourceSystemTitle, settings.Cipher.BlockCipherKey, data.Data);
    // Get command.
    Result := data.Data.GetUInt8();
    data.Command := TCommand(Result);
  end
  else
    data.Data.Position := (data.Data.Position - 1);
end;

class procedure TGXDLMS.HandleGloDedResponse(
    settings: TGXDLMSSettings;
    data: TGXReplyData;
    index: Integer);
var
  bb: TGXByteBuffer;
begin
  if settings.Cipher = Nil Then
    raise EArgumentException.Create('Secure connection is not supported.');

  // If all frames are read.
  if Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
  begin
    data.Data.Position := (data.Data.Position - 1);
    bb := TGXByteBuffer.Create(data.Data);
    try
      data.Data.Position := index;
      data.Data.size := index;
      settings.Cipher.Decrypt(settings.SourceSystemTitle, settings.Cipher.BlockCipherKey, bb).Free;
      data.Data.SetArray(bb);
    finally
      FreeAndNil(bb);
    end;
    data.Command := TCommand.NONE;
    try
      GetPdu(settings, data);
    except on E: EArgumentException do
      //Skip data If keys are wrong.
    end;
    data.CipherIndex := data.Data.Size;
  end;
end;

class procedure TGXDLMS.HandleGeneralCiphering(
    settings: TGXDLMSSettings;
    data: TGXReplyData);
var
  p: TAesGcmParameter;
  origPos: Integer;
begin
  if settings.Cipher = Nil Then
    raise EArgumentException.Create('Secure connection is not supported.');

  // If all frames are read.
  if Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
  begin
    origPos := data.Xml.GetXmlLength();
    data.Data.Position := (data.Data.Position - 1);
    p := Nil;
    try
      try
        p := settings.Cipher.Decrypt(settings.SourceSystemTitle,
            settings.Cipher.BlockCipherKey, data.Data);
        data.Command := TCommand.None;
        data.CipheredCommand := TCommand.GeneralCiphering;
        if p.Security <> TSecurity.None Then
          GetPdu(settings, data);
      except
      on E: Exception do
      begin
        if data.Xml = Nil Then
          raise;
        data.Xml.SetXmlLength(origPos);
      end;
      end;
      if (data.Xml <> Nil) and (p <> Nil) Then
      begin
        data.Xml.AppendStartTag(LONGWORD(TCommand.GeneralCiphering));
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.TransactionId), '',
                data.Xml.IntegerToHex(p.InvocationCounter, 16, true));
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.OriginatorSystemTitle),
                '', TGXCommon.ToHexString(p.SystemTitle, false, 0, Length(p.SystemTitle)));
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.RecipientSystemTitle), '',
                TGXCommon.ToHexString(p.RecipientSystemTitle, false, 0, Length(p.RecipientSystemTitle)));
    //    data.Xml.AppendLine(LONGWORD(TTranslatorTags.DateTime), '',
    //            GXCommon.ToHex(p.DateTime, false));
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.OtherInformation), '',
                TGXCommon.ToHexString(p.OtherInformation, false, 0, Length(p.OtherInformation)));

        data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.KeyInfo));
        data.Xml.AppendStartTag(LONGWORD(TTranslatorTags.AgreedKey));
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.KeyParameters), '',
                data.Xml.IntegerToHex(p.KeyParameters, 2, true));
        data.Xml.AppendLine(LONGWORD(TTranslatorTags.KeyCipheredData), '',
                TGXCommon.ToHexString(p.KeyCipheredData, false, 0, Length(p.KeyCipheredData)));
        data.Xml.AppendEndTag(LONGWORD(TTranslatorTags.AgreedKey));
        data.Xml.AppendEndTag(LONGWORD(TTranslatorTags.KeyInfo));
       // data.Xml.AppendLine(LONGWORD(TTranslatorTags.CipheredContent), '',
       //         TGXCommon.ToHexString(p.CipheredContent, false, 0, Length(p.CipheredContent)));
        data.Xml.AppendEndTag(LONGWORD(TCommand.GeneralCiphering));
      end;
    finally
      FreeAndNil(p);
    end;
  end;
end;

// Get value from data.
class procedure TGXDLMS.GetValueFromData(settings: TGXDLMSSettings; reply: TGXReplyData);
var
  index: Integer;
  info: TGXDataInfo;
  value: TValue;
  list: TList<TValue>;
begin
  info := TGXDataInfo.Create();
  try
    if Not reply.Value.IsEmpty and reply.Value.IsType<TArray<TValue>> Then
    begin
      info.&Type := TDataType.dtArray;
      info.Count := reply.TotalCount;
      info.Index := reply.Count;
    end;
    index := reply.Data.Position;
    reply.Data.Position := reply.ReadPosition;
    try
      value := TGXCommon.GetData(reply.Data, info);
      if Not value.IsEmpty Then
      begin // If new data.
        if Not value.IsArray Then
        begin
          reply.ValueType := info.&Type;
          reply.Value := value;
          reply.TotalCount := 0;
          reply.ReadPosition := reply.Data.Position;
        end
        else
        begin
          if (value.GetArrayLength <> 0) Then
          begin
            if reply.Value.IsEmpty Then
              reply.Value := value
            else
            begin
              list := TList<TValue>.Create;
              try
                list.AddRange(reply.Value.AsType<TArray<TValue>>);
                list.AddRange(value.AsType<TArray<TValue>>);
                reply.Value := TValue.From(list.ToArray());
              finally
                FreeAndNil(list);
              end;
            end;
          end;
          reply.ReadPosition := reply.Data.Position;
          // Element count.
          reply.TotalCount := info.Count;
        end;
      end
      else if info.Complete and (reply.Command = TCommand.DataNotification) Then
        // If last item is null. This is a special case.
        reply.ReadPosition := reply.Data.Position;
    finally
      reply.Data.Position := index;
    end;

    // If last data frame of the data block is read.
    if (reply.Command <> TCommand.DataNotification) and info.Complete
            and (reply.MoreData = TRequestTypes.rtNone) Then
    begin
      // If all blocks are read.
      settings.ResetBlockIndex();
      reply.Data.Position := 0;
    end;
  finally
    FreeAndNil(info);
  end;
end;

class function TGXDLMS.GetData(
    settings: TGXDLMSSettings;
    reply: TGXByteBuffer;
    data: TGXReplyData;
    notify: TGXReplyData) : Boolean;
var
  frame, cnt : Integer;
  isLast: Boolean;
begin
  isLast := True;
  frame := 0;
  Result := True;
  // If DLMS frame is generated.
  if settings.InterfaceType = TInterfaceType.HDLC then
  begin
    frame := GetHdlcData(settings.isServer, settings, reply, data, notify);
    isLast := (frame and $10) <> 0;
    if (notify <> Nil) and (frame = $13) Then
    begin
      data := notify;
      Result := False;
    end;
    data.FrameId := frame;
  end
  else if settings.InterfaceType = TInterfaceType.WRAPPER Then
  begin
    if Not GetTcpData(settings, reply, data, notify) Then
    begin
      if notify <> Nil then
        data := notify;
      Result := False;
    end;
  end
  else if settings.InterfaceType = TInterfaceType.PDU Then
  begin
    data.PacketLength := reply.Size;
    data.Complete := true;
  end
  else
    raise EArgumentException.Create('Invalid Interface type.');
  // If all data is not read yet.
  if Not data.Complete then
  begin
    Result := false;
    Exit;
  end;

  GetDataFromFrame(reply, data, settings.InterfaceType = TInterfaceType.HDLC);
  // If keepalive or get next frame request.
  if ((data.Xml <> Nil) or ((frame <> $13) or data.IsMoreData) and ((frame and $1) <> 0)) Then
  begin
    Exit;
  end;
  GetPdu(settings, data);
  if (notify <> Nil) and Result Then
  begin
    //Check command to make sure it's not notify message.
    case data.Command of
      TCommand.DataNotification,
      TCommand.GloEventNotificationRequest,
      TCommand.InformationReport,
      TCommand.EventNotification,
      TCommand.DedInformationReportRequest,
      TCommand.DedEventNotificationRequest:
      begin
        Result := False;
        notify.Command := data.Command;
        data.Command := TCommand.None;
        notify.Time := data.Time;
        data.Time := 0;
        notify.Data.SetArray(data.Data);
        data.Data.Trim();
      end
    end;
  end;
  if Not isLast then
  begin
    Result := GetData(settings, reply, data, notify);
  end;
end;

// Get data from HDLC or wrapper frame.
class procedure TGXDLMS.GetDataFromFrame(
    reply: TGXByteBuffer;
    info: TGXReplyData;
    hdlc: Boolean);
var
  offset, cnt : Integer;
begin
    offset := info.Data.Size;
    cnt := info.PacketLength - reply.Position;
    if cnt <> 0 then
    begin
      info.Data.Capacity(offset + cnt);
      info.Data.SetArray(reply.GetData(), reply.Position, cnt);
      reply.Position := reply.Position + cnt;
      if hdlc then
        reply.Position := reply.Position + 3;
    end;
    // Set position to begin of new data.
    info.Data.Position := offset;
end;

// Get data from Block.
class function TGXDLMS.GetDataFromBlock(data: TGXByteBuffer; index: Integer) : Integer;
begin
  if data.Size = data.Position Then
  begin
    data.clear();
    Result := 0;
  end
  else
  begin
    Result := data.Position - index;
    Move(data.GetData()[data.Position], data.GetData()[data.Position - Result], data.Size - data.Position);
    data.Position := (data.Position - Result);
    data.size := (data.Size - Result);
  end;
end;

class procedure TGXDLMS.GetActionInfo(objectType: TObjectType; value: PInteger; count: PInteger);
begin
  count^ := 0;
  value^ := 0;
  case objectType of
    TObjectType.otActivityCalendar:
    begin
      value^ := $50;
      count^ := 1;
    end;
    TObjectType.otAssociationLogicalName:
    begin
      value^ := $60;
      count^ := 4;
    end;
    TObjectType.otAssociationShortName:
    begin
      value^ := $20;
      count^ := 8;
    end;
    TObjectType.otClock:
    begin
      value^ := $60;
      count^ := 6;
    end;
    TObjectType.otDemandRegister:
    begin
      value^ := $48;
      count^ := 2;
    end;
    TObjectType.otExtendedRegister:
    begin
      value^ := $38;
      count^ := 1;
    end;
    TObjectType.otIp4Setup:
    begin
      value^ := $60;
      count^ := 3;
    end;
    TObjectType.otMBusSlavePortSetup:
    begin
      value^ := $60;
      count^ := 8;
    end;
    TObjectType.otProfileGeneric:
    begin
      value^ := $58;
      count^ := 4;
    end;
    TObjectType.otRegister:
    begin
      value^ := $28;
      count^ := 1;
    end;
    TObjectType.otRegisterActivation:
    begin
      value^ := $30;
      count^ := 3;
    end;
    TObjectType.otRegisterTable:
    begin
      value^ := $28;
      count^ := 2;
    end;
    TObjectType.otSapAssignment:
    begin
      value^ := $20;
      count^ := 1;
    end;
    TObjectType.otScriptTable:
    begin
      value^ := $20;
      count^ := 1;
    end;
    TObjectType.otSpecialDaysTable:
    begin
      value^ := $10;
      count^ := 2;
    end
    else
      raise Exception.Create('Target do not support Action.');
  end;
end;

class procedure TGXDLMS.AppendHdlcParameter(data: TGXByteBuffer; value: Integer);
begin
  if value < $100 Then
  begin
    data.SetUInt8(1);
    data.SetUInt8(value);
  end
  else
  begin
    data.SetUInt8(2);
    data.SetUInt16(value);
  end;
end;

end.

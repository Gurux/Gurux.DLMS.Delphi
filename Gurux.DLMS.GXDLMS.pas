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
Gurux.DLMS.ActionType, System.Variants,
Gurux.DLMS.Security, Gurux.DLMS.GXCiphering, Gurux.DLMS.GXDLMSChippering,
Gurux.DLMS.GXDLMSObject, GXByteBuffer,
Gurux.DLMS.ErrorCode, Gurux.DLMS.GXDLMSLNParameters,
Gurux.DLMS.GXDLMSConverter, Gurux.DLMS.Conformance,
System.Types, System.Generics.Collections, Gurux.DLMS.GXDLMSSNParameters,
Gurux.DLMS.VariableAccessSpecification, Gurux.DLMS.Objects.SingleReadResponse,
Gurux.DLMS.GXReplyData, Gurux.DLMS.HdlcFrameType, Gurux.DLMS.HdlcControlFrame,
Gurux.DLMS.GXDateTime, GXDataInfo, Gurux.DLMS.SetResponseType,
Gurux.DLMS.GetCommandType, Gurux.DLMS.ExceptionServiceError,
Gurux.DLMS.ConfirmedServiceError, Gurux.DLMS.AesGcmParameter,
Gurux.DLMS.GXDLMSConfirmedServiceError;

const
  CIPHERING_HEADER_SIZE = 7 + 12 + 3;
  DATA_TYPE_OFFSET = $FF0000;
  DEFAULT_MAX_INFO_TX = 128;
  DEFAULT_MAX_INFO_RX = 128;
  DEFAULT_WINDOWS_SIZE_TX = 1;
  DEFAULT_WINDOWS_SIZE_RX = 1;
type
  TGXDLMS = class
  class procedure GetActionInfo(objectType: TObjectType; value: PInteger; count: PInteger);static;
  class function GetInvokeIDPriority(settings : TGXDLMSSettings): Byte; static;
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
  class procedure CheckWrapperAddress(settings: TGXDLMSSettings; buff: TGXByteBuffer; data: TGXReplyData);
  // Get data from Block.
  class function GetDataFromBlock(data: TGXByteBuffer; index: Integer) : Integer;
  // Handle read response and get data from block and/or update error status.
  class function HandleReadResponse(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer) : Boolean;
  // Get value from data.
  class procedure GetValueFromData(settings: TGXDLMSSettings; reply: TGXReplyData);
  class function GetData(settings: TGXDLMSSettings; reply: TGXByteBuffer; data: TGXReplyData) : Boolean;
  // Get data from HDLC or wrapper frame.
  class procedure GetDataFromFrame(reply: TGXByteBuffer; info: TGXReplyData);

  class procedure HandleAccessResponse(settings: TGXDLMSSettings; reply: TGXReplyData);
  // Handle set response and update error status.
  class procedure HandleSetResponse(settings: TGXDLMSSettings; data: TGXReplyData);
 // Handle write response and update error status.
  class procedure HandleWriteResponse(data: TGXReplyData);
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
  class function GetHdlcData(server: Boolean; settings: TGXDLMSSettings; reply: TGXByteBuffer; data: TGXReplyData): Byte;static;
  // Get data from TCP/IP frame.
  class procedure GetTcpData(settings: TGXDLMSSettings; buff: TGXByteBuffer; data: TGXReplyData);static;
  // Check that client and server address match.
  class function CheckHdlcAddress(server: Boolean; settings: TGXDLMSSettings; reply: TGXByteBuffer; index: Integer): Boolean;

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
  class procedure HandleGloResponse(settings: TGXDLMSSettings; data: TGXReplyData; index: Integer);

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

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

class function TGXDLMS.GetInvokeIDPriority(settings: TGXDLMSSettings) : Byte;
begin
  Result := 0;
  if settings.Priority = TPriority.prHigh Then
    Result := $80;

  if settings.ServiceClass = TServiceClass.scConfirmed Then
    Result := Result or $40;

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
  if settings.UseLogicalNameReferencing Then
    bb.SetUInt32(settings.BlockIndex)
  else
    bb.SetUInt16(settings.BlockIndex);

  settings.IncreaseBlockIndex();
  if settings.UseLogicalNameReferencing Then
  begin
    p := TGXDLMSLNParameters.Create(settings, 0, cmd,
      Byte(TGetCommandType.ctNextDataBlock), bb, Nil, $ff);
    Result := GetLnMessages(TGXDLMSLNParameters(p))[0];
  end
  else
  begin
    p := TGXDLMSSNParameters.Create(settings, cmd, 1,
      Byte(TVariableAccessSpecification.vaBlockNumberAccess), bb, Nil);
    Result := GetSnMessages(TGXDLMSSNParameters(p))[0];
  end;
  FreeAndNil(p);
  FreeAndNil(bb);
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
    else
      raise EArgumentException.Create('Invalid GLO command.');
    end;
end;

class procedure TGXDLMS.AddLLCBytes(settings: TGXDLMSSettings; data: TGXByteBuffer);
begin
  if settings.isServer Then
    data.SetArray(0, LLCReplyBytes)
  else
    data.SetArray(0, LLCSendBytes);
end;

class procedure TGXDLMS.MultipleBlocks(p : TGXDLMSLNParameters; reply: TGXByteBuffer; ciphering: Boolean);
var
  len: Integer;
begin
    // Check is all data fit to one message if data is given.
    len := p.Data.Size() - p.Data.Position();
    if p.AttributeDescriptor <> Nil Then
        len := len + p.AttributeDescriptor.Size();

    if ciphering Then
        len := len + CIPHERING_HEADER_SIZE;

    if p.MultipleBlocks = False Then
    begin
        // Add command type and invoke and priority.
        p.MultipleBlocks := 2 + reply.Size + len > p.Settings.MaxPduSize;
    end;
    if p.MultipleBlocks = True Then
        // Add command type and invoke and priority.
        p.LastBlock := Not(8 + reply.Size() + len > p.Settings.MaxPduSize);

    if p.LastBlock = True Then
        // Add command type and invoke and priority.
        p.LastBlock := Not(8 + reply.Size() + len > p.Settings.MaxPduSize);
end;

// Get next logical name PDU.
class procedure TGXDLMS.GetLNPdu(p: TGXDLMSLNParameters; reply: TGXByteBuffer);
var
  len, pos, totalLength: Integer;
  ciphering : Boolean;
begin
    ciphering := (p.Command <> TCommand.AARQ)
            and (p.Command <> TCommand.AARE)
            and (p.Settings.Cipher <> Nil)
            and (p.Settings.Cipher.Security <> TSecurity.NONE);
    len := 0;
    if (ciphering = False) and (p.Settings.InterfaceType = TInterfaceType.HDLC) Then
      AddLLCBytes(p.Settings, reply);

    if p.Command = TCommand.AARQ Then
      reply.SetArray(p.AttributeDescriptor)
    else
    begin
        if Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer) <> 0 Then
        begin
          reply.SetUInt8(Integer(TCommand.GeneralBlockTransfer));
          multipleBlocks(p, reply, ciphering);
          // Is last block
          if Not p.LastBlock Then
            reply.SetUInt8(0)
          else
            reply.SetUInt8($80);

          // Set block number sent.
          reply.SetUInt8(0);
          // Set block number acknowledged
          reply.SetUInt8(p.BlockIndex);
          p.BlockIndex := p.BlockIndex + 1;
          // Add APU tag.
          reply.SetUInt8(0);
          // Add Addl fields
          reply.SetUInt8(0);
        end;
        // Add command.
        reply.SetUInt8(Integer(p.Command));

        if (p.Command = TCommand.DataNotification)
                or (p.Command = TCommand.AccessRequest)
                or (p.Command = TCommand.AccessResponse) Then
        begin
          // Add Long-Invoke-Id-And-Priority
          if (p.InvokeId <> 0) Then
              reply.SetUInt32(p.InvokeId)
          else
            reply.SetUInt32(GetLongInvokeIDPriority(p.Settings));

          // Add date time.
          if p.Time = Nil Then
            reply.SetUInt8(Integer(TDataType.dtNone))
          else
          begin
              // Data is send in octet string. Remove data type.
              pos := reply.Size;
              TGXCommon.setData(reply, TDataType.dtOctetString, p.Time);
              reply.Move(pos + 1, pos, reply.Size() - pos - 1);
          end;
        end
        else
        begin
          // Get request size can be bigger than PDU size.
          if (p.Command <> TCommand.GetRequest) and (p.Data <> Nil) and (p.Data.Size() <> 0) Then
            multipleBlocks(p, reply, ciphering);

          // Change Request type if Set request and multiple blocks is needed.
          if (p.Command = TCommand.SetRequest) Then
          begin
            if p.MultipleBlocks Then
              if p.RequestType = 1 Then
                p.RequestType := 2
              else if p.RequestType = 2 Then
                p.RequestType := 3;
          end;
          // Change request type If get response and multiple blocks is needed.
          if p.Command = TCommand.GetResponse Then
            if p.MultipleBlocks Then
              if p.RequestType = 1 Then
                p.RequestType := 2;

          reply.SetUInt8(p.RequestType);
          // Add Invoke Id And Priority.
          if p.InvokeId <> 0 Then
            reply.SetUInt8(p.InvokeId)
          else
            reply.SetUInt8(GetInvokeIDPriority(p.Settings));
        end;
        // Add attribute descriptor.
        reply.SetArray(p.AttributeDescriptor);
        if (p.Command <> TCommand.DataNotification) and
          (Integer(p.Settings.NegotiatedConformance) and Integer(TConformance.cfGeneralBlockTransfer) = 0) Then
        begin
            // If multiple blocks.
            if (p.MultipleBlocks) Then
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
        end;
        // Add data that fits to one block.
        if len = 0 Then
        begin
            // Add status if reply.
            if (p.Status <> $FF) Then
            begin
                if (p.Status <> 0) and (p.Command = TCommand.GetResponse) Then
                  reply.setUInt8(1);

                reply.setUInt8(p.Status);
            end;
            if (p.Data <> Nil) and (p.Data.Size <> 0) Then
            begin
                len := p.Data.Size - p.Data.Position;
                // Get request size can be bigger than PDU size.
                if (p.Command <> TCommand.GetRequest) and (len + reply.Size > p.Settings.MaxPduSize) Then
                    len := p.Settings.MaxPduSize - reply.Size;

                reply.SetArray(p.Data, len);
            end;
        end;
        if ciphering = True Then
          Cipher0(p, reply);
    end;
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
  reply.size(0);
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
try
  bb := TGXByteBuffer.Create();
  list := TList<TBytes>.Create();
  frame := 0;
  if p.Command = TCommand.AARQ Then
    frame := $10
  else if (p.Command = TCommand.EventNotification) or (p.Command = TCommand.DataNotification) Then
    frame := $13;

  repeat
  begin
    GetLNPdu(p, bb);
    p.LastBlock := True;
    if p.AttributeDescriptor = Nil Then
      p.Settings.increaseBlockIndex();

    if (p.Command = TCommand.AARQ) and (p.Command = TCommand.GetRequest) Then
        assert (Not(p.Settings.MaxPduSize < bb.Size));

    while (bb.Position() <> bb.Size) do
    begin
        if p.Settings.InterfaceType = TInterfaceType.WRAPPER Then
            list.Add(GetWrapperFrame(p.Settings, bb))
        else if (p.Settings.InterfaceType = TInterfaceType.HDLC) Then
        begin
            list.Add(GetHdlcFrame(p.Settings, frame, bb));
            if bb.Position() <> bb.Size Then
            begin
              if (p.Settings.isServer) or (p.Command = TCommand.SetRequest) Then
                frame := 0
              else
                frame := p.Settings.NextSend(false);
            end;
        end
        else if (p.Settings.InterfaceType = TInterfaceType.PDU) Then
        begin
          list.add(bb.ToArray());
          frame := 0;
          break;
        end
        else
          raise EArgumentException.Create('InterfaceType');
    end;
    bb.Clear();
  end;
  until (p.Data = Nil) or (p.Data.position = p.Data.Size);
  Result := list.ToArray();
finally
  FreeAndNil(list);
  FreeAndNil(bb);
end;
end;

// Get all Short Name messages. Client uses this to generate messages.
class function TGXDLMS.GetSnMessages(p: TGXDLMSSNParameters): TArray<TBytes>;
var
  frame: Byte;
  bb: TGXByteBuffer;
  list: TList<TBytes>;
begin
  try
    bb := TGXByteBuffer.Create();
    list := TList<TBytes>.Create();
    frame := $0;
    if p.Command = TCommand.AARQ Then
      frame := $10
    else if p.Command = TCommand.InformationReport Then
      frame := $13
    else if p.Command = TCommand.NONE Then
      frame := p.Settings.NextSend(true);

    repeat
    begin
        GetSNPdu(p, bb);
        if (p.Command <> TCommand.AARQ) and (p.Command <> TCommand.AARE) Then
          Assert(Not p.Settings.MaxPduSize > bb.Size);

        // Command is not add to next PDUs.
        while (bb.Position() <> bb.Size) do
        begin
            if p.Settings.InterfaceType = TInterfaceType.WRAPPER Then
              list.Add(GetWrapperFrame(p.Settings, bb))
            else if p.Settings.InterfaceType = TInterfaceType.HDLC Then
            begin
                list.add(GetHdlcFrame(p.Settings, frame, bb));
                if bb.position <> bb.Size Then
                begin
                  if p.Settings.IsServer Then
                    frame := 0
                  else
                    frame := p.Settings.NextSend(false);
                end;
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
    end;
    until (p.Data = Nil) or (p.Data.Position = p.Data.Size);
    Result := list.ToArray;
  finally
    FreeAndNil(list);
    FreeAndNil(bb);
  end;
end;

class function TGXDLMS.AppendMultipleSNBlocks(p: TGXDLMSSNParameters; header: TGXByteBuffer; reply: TGXByteBuffer): Integer;
var
  hSize: Integer;
  ciphering : Boolean;
begin
  ciphering := (p.Settings.Cipher <> Nil) and (p.Settings.Cipher.Security <> TSecurity.None);
  hSize := reply.Size() + 3;
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
  if (p.Data.Size() - p.Data.Position() > Result) Then
    // More blocks.
    reply.SetUInt8(0)
  else
  begin
    // Last block.
    reply.setUInt8(1);
    Result := p.Data.Size() - p.Data.Position();
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
    TGXCommon.SetObjectCount(Result + header.Size(), reply);
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
        cnt := p.Data.Size - p.Data.Position();

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
        pos := reply.size();
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
          reply.Size(0);
          if Not ciphering and (p.Settings.InterfaceType = TInterfaceType.HDLC) Then
          begin
            if p.Settings.isServer Then
              TGXDLMS.AddLLCBytes(p.Settings, reply)
            else if reply.Size = 0 Then
              TGXDLMS.AddLLCBytes(p.Settings, reply);
          end;
          if p.Command = TCommand.WriteRequest Then
            p.RequestType := Byte(TVariableAccessSpecification.vaWriteDataBlockAccess)
          else if p.Command = TCommand.ReadRequest Then
            p.RequestType := Byte(TVariableAccessSpecification.vaReadDataBlockAccess)
          else if p.Command = TCommand.ReadResponse Then
            p.RequestType := Byte(TSingleReadResponse.srDataBlockResult)
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
        reply.size(0);
        if p.Settings.InterfaceType = TInterfaceType.HDLC Then
        begin
          if p.Settings.IsServer Then
            TGXDLMS.AddLLCBytes(p.Settings, reply)
          else if reply.Size = 0 Then
            TGXDLMS.AddLLCBytes(p.Settings, reply);
        end;
        reply.SetArray(tmp);
        FreeAndNil(tmp);
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
  if VarType(tmp) = VarByte Then
    bb.SetUInt8(tmp)
  else if VarType(tmp) = VarWord Then
    bb.SetUInt16(tmp)
  else if VarType(tmp) = VarLongWord Then
    bb.SetUInt32(tmp)
  else
    raise EArgumentException.Create('Invalid address type.');
  Result := bb.ToArray();
  FreeAndNil(bb);
end;

// Split DLMS PDU to wrapper frames.
class function TGXDLMS.GetWrapperFrame(settings: TGXDLMSSettings; data: TGXByteBuffer): TBytes;
var
  bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create();
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
        data.Position(0);
      end;
  end;
  Result := bb.ToArray();
  FreeAndNil(bb);
end;

// Get HDLC frame for data.
class function TGXDLMS.GetHdlcFrame(settings: TGXDLMSSettings; frame: Byte; data: TGXByteBuffer) : TBytes;
var
  bb: TGXByteBuffer;
  crc, frameSize, len: Integer;
  primaryAddress, secondaryAddress: TBytes;
begin
  bb := TGXByteBuffer.Create();
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
  frameSize := frameSize - 11;
  // If no data
  if (data = Nil) or (data.Size = 0) Then
    bb.setUInt8($A0)
  else if (data.Size - data.Position() <= frameSize) Then
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
          if data.Size = data.Position() Then
              data.clear()
          else
          begin
            data.move(data.Position(), 0, data.Size - data.Position());
            data.Position(0);
          end;
      end;
  end;
  Result := bb.ToArray();
  FreeAndNil(bb);
end;

class function TGXDLMS.GetLLCBytes(server: Boolean; data: TGXByteBuffer) : Boolean;
begin
  if server Then
    Result := data.Compare(LLCSendBytes)
  else
    Result :=data.Compare(LLCReplyBytes);
end;

class function TGXDLMS.GetHdlcData(server: Boolean; settings: TGXDLMSSettings; reply: TGXByteBuffer; data: TGXReplyData): Byte;
var
  ch, frame: Byte;
  tmp, crc, crcRead: WORD;
  pos, eopPos, packetStartID, frameLen: Integer;
begin
    packetStartID := reply.Position();
    frameLen := 0;
    // If whole frame is not received yet.
    if (reply.Size - reply.Position() < 9) Then
    begin
      data.Complete := false;
      Result := 0;
      Exit;
    end;
    data.Complete := true;
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
        // Not enough data to parse;
        Result := 0;
        Exit;
    end;
    frame := reply.GetUInt8();
    if (frame and $F0) <> $A0 Then
    begin
      // If same data.
      Result := getHdlcData(server, settings, reply, data);
      Exit;
    end;

    // Check frame length.
    if (frame and $7) <> 0 Then
      frameLen := (frame and $7) shl 8;

    ch := reply.GetUInt8();
    // If not enough data.
    frameLen := frameLen + ch;
    if (reply.Size - reply.Position() + 1 < frameLen) Then
    begin
      data.Complete := false;
      reply.Position(packetStartID);
      // Not enough data to parse;
      Result :=  0;
      Exit;
    end;
    eopPos := frameLen + packetStartID + 1;
    ch := reply.getUInt8(eopPos);
    if ch <> HDLCFrameStartEnd Then
      raise TGXDLMSException.Create('Invalid data format.');

    // Check addresses.
    if Not CheckHdlcAddress(server, settings, reply, eopPos) Then
    begin
        // If echo,
        Result := GetHdlcData(server, settings, reply, data);
        Exit;
    end;

    // Is there more data available.
    if ((frame and $8) <> 0) Then
        data.MoreData := TRequestTypes(Integer(data.MoreData) or Integer(TRequestTypes.rtFrame))
    else
        data.MoreData := TRequestTypes(Integer(data.MoreData) and Not Integer(TRequestTypes.rtFrame));

    // Get frame type.
    frame := reply.GetUInt8();
    if Not settings.CheckFrame(frame) Then
    begin
        reply.Position(eopPos + 1);
        Result := GetHdlcData(server, settings, reply, data);
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
      data.PacketLength := eopPos - 2;
    end
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
      if (reply.Position() = packetStartID + frameLen + 1) Then
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
class function TGXDLMS.CheckHdlcAddress(server: Boolean; settings: TGXDLMSSettings; reply: TGXByteBuffer; index: Integer): Boolean;
var
  readLogical, readPhysical, logical, physical, source, target: Integer;
begin
  // Get destination and source addresses.
  target := TGXCommon.GetHDLCAddress(reply);
  source := TGXCommon.GetHDLCAddress(reply);
  if server Then
  begin
      // Check that server addresses match.
      if (settings.ServerAddress <> 0) and (settings.ServerAddress <> target) Then
      begin
        if reply.GetUInt8(reply.Position) = Integer(TCommand.SNRM) Then
          settings.ServerAddress := target
        else
          raise TGXDLMSException.Create('Server addresses do not match. It is '
                + IntToStr(target) + '. It should be '
                + IntToStr(settings.ServerAddress)
                + '.');

      end;
      settings.ServerAddress := target;

      // Check that client addresses match.
      if (settings.ClientAddress <> 0) and (settings.ClientAddress <> source) Then
      begin
        if reply.GetUInt8(reply.Position) = Integer(TCommand.SNRM) Then
          settings.ClientAddress := source
        else
          raise TGXDLMSException.Create(
            'Client addresses do not match. It is '
                    + IntToStr(source) + '. It should be '
                    + IntToStr(settings.ClientAddress)
                    + '.');
      end
      else
        settings.ClientAddress := source;
  end
  else
  begin
    // Check that client addresses match.
    if settings.ClientAddress <> target Then
    begin
        // If echo.
        if (settings.ClientAddress = source) and (settings.ServerAddress = target) Then
        begin
          reply.Position(index + 1);
          Result := false;
          Exit;
        end;
        raise TGXDLMSException.Create(
                'Destination addresses do not match. It is '
                        + IntToStr(target) + '. It should be '
                        + IntToStr(settings.ClientAddress)
                        + '.');
    end;
    // Check that server addresses match.
    if settings.ServerAddress <> source Then
    begin
        // Check logical and physical address separately.
        // This is done because some meters might send four bytes
        // when only two bytes is needed.
        GetServerAddress(source, @readLogical, @readPhysical);
        GetServerAddress(settings.ServerAddress, @logical, @physical);
        if (readLogical <> logical) or (readPhysical <> physical) Then
            raise TGXDLMSException.Create(
                    'Source addresses do not match. It is '
                            + IntToStr(source) + '. It should be '
                            + IntToStr(
                                    settings.ServerAddress)
                            + '.');

    end;
end;
  Result := true;
end;

class procedure TGXDLMS.GetTcpData(settings: TGXDLMSSettings; buff: TGXByteBuffer; data: TGXReplyData);
var
  pos, value : Integer;
  compleate: Boolean;
begin
  // If whole frame is not received yet.
  if buff.Size - buff.position < 8 Then
  begin
    data.Complete := false;
    Exit;
  end;
  pos := buff.Position;
  // Get version
  value := buff.GetUInt16();
  if value <> 1 Then
    raise TGXDLMSException.Create('Unknown version.');


  // Check TCP/IP addresses.
  CheckWrapperAddress(settings, buff, data);
  // Get length.
  value := buff.getUInt16();
  compleate := Not((buff.Size - buff.Position()) < value);
  data.Complete := compleate;
  if Not compleate Then
    buff.Position(pos)
  else
    data.PacketLength := buff.Position + value;
end;

class procedure TGXDLMS.CheckWrapperAddress(settings: TGXDLMSSettings; buff: TGXByteBuffer; data: TGXReplyData);
var
  value: Integer;
begin
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
        raise TGXDLMSException.Create(
                  'Source addresses do not match. It is '
                          + IntToStr(value) + '. It should be '
                          + IntToStr(settings.ServerAddress)
                          + '.')
      else
        settings.ServerAddress := value;

      value := buff.getUInt16();
      // Check that client addresses match.
      if (settings.ClientAddress <> 0) and (settings.ClientAddress <> value) Then
        raise TGXDLMSException.Create(
                  'Destination addresses do not match. It is '
                          + IntToStr(value) + '. It should be '
                          + IntToStr(settings.ClientAddress)
                          + '.')
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
        reply.Data.Position(0);
        reply.CommandType := byte(TSingleReadResponse.srData);
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
  first: Boolean;
  tp: TSingleReadResponse;
begin
  values := nil;
  try
  {
    cnt := TGXCommon.GetObjectCount(reply.Data);
    // Set total count if not set yet.
    if reply.TotalCount = 0 Then
      reply.TotalCount := cnt;

    if cnt <> 1 Then
      values := TList<TValue>.Create();
   }
       cnt := reply.Count;
    if (reply.Count = 0) and (reply.TotalCount = 0) Then
      cnt := TGXCommon.GetObjectCount(reply.Data)
    else
      cnt := reply.TotalCount;

    //Set total count if not set yet.
    if reply.TotalCount = 0 Then
    begin
      first := true;
      reply.TotalCount := cnt;
    end
    else
      first := false;

    tp := TSingleReadResponse.srData;
    if cnt <> 1 Then
    begin
      values := TList<TValue>.Create();
      if reply.Value.GetArrayLength <> 0 Then
        values.AddRange(reply.Value.AsType<TArray<TValue>>);
        reply.Value := Nil;
    end;

    for pos := 0 to cnt - 1 do
    begin
      if reply.Data.Available = 0 Then
      begin
          reply.TotalCount := cnt;
          if cnt <> 1 Then
          begin
            GetDataFromBlock(reply.Data, 0);
            reply.Value := TValue.From(values.ToArray());
          end;
          Result := false;
          Exit;
      end;
      // Get status code.
      if (first) or (cnt <> 1) Then
        reply.CommandType := reply.Data.GetUInt8();

      tp := TSingleReadResponse(reply.CommandType);
      case(tp) of
      TSingleReadResponse.srData:
      begin
        reply.Error := 0;
        if cnt = 1 Then
          GetDataFromBlock(reply.Data, 0)
        else
        begin
            reply.ReadPosition := reply.Data.Position;
            GetValueFromData(settings, reply);
            if reply.Data.Position() = reply.ReadPosition Then
            begin
                // If multiple values remove command.
                if (cnt <> 1) and (reply.TotalCount = 0) Then
                  index := index + 1;

                reply.TotalCount := 0;
                reply.Data.Position(index);
                GetDataFromBlock(reply.Data, 0);
                reply.Value := Nil;
                // Ask that data is parsed after last block is received.
                reply.CommandType := Byte(TSingleReadResponse.srDataBlockResult);
                Result := false;
                Exit;
            end;
            reply.Data.Position(reply.ReadPosition);
            values.Add(reply.Value);
            reply.Value := Nil;
        end;
      end;
      TSingleReadResponse.srDataAccessError:
      begin
        // Get error code.
        reply.Error := reply.Data.GetUInt8();
      end;
      TSingleReadResponse.srDataBlockResult:
      begin
        if Not readResponseDataBlockResult(settings, reply, index) Then
        begin
            Result := false;
            Exit;
        end;
      end;
      TSingleReadResponse.srBlockNumber:
      begin
          // Get Block number.
          number := reply.Data.GetUInt16();
          if number <> settings.BlockIndex Then
            raise TGXDLMSException.Create('Invalid Block number. It is '
                      + IntToStr(number) + ' and it should be '
                      + IntToStr(settings.BlockIndex) + '.');

          settings.IncreaseBlockIndex();
          reply.MoreData := TRequestTypes(Integer(reply.MoreData) or Integer(TRequestTypes.rtDataBlock));
      end;
      else
        raise TGXDLMSException.Create('HandleReadResponse failed. Invalid tag.');
      end;
    end;

    if values <> Nil Then
      reply.Value := TValue.From(values.toArray());

    Result := cnt = 1;
  finally
    FreeAndNil(values);
  end;
end;

// Handle method response and get data from block and/or update error status.
class procedure TGXDLMS.HandleMethodResponse(settings: TGXDLMSSettings; data: TGXReplyData);
var
  ret, t, invoke: Byte;
begin
  // Get type.
  t := data.Data.GetUInt8();
  // Get invoke ID and priority.
  invoke := data.Data.GetUInt8();
  if t = 1 Then
  begin
      // Get Action-Result
      ret := data.Data.GetUInt8();
      if ret <> 0 Then
          data.Error := ret;

      // Action-Response-Normal. Get data if exists. All meters do not
      // return data here.
      if data.Data.Position < data.Data.Size Then
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
                      data.Data.Position(data.Data.Position() - 2);
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
  index := reply.Data.Position() - 1;
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
    reply.Data.Position(reply.Data.Position() + len);

  GetDataFromBlock(reply.Data, index);
end;

class procedure TGXDLMS.HandleAccessResponse(settings: TGXDLMSSettings; reply: TGXReplyData);
var
  len: Byte;
  invokeId: LongWord;
  tmp: TBytes;
  tm: TGXDateTime;
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
      reply.Time := tm.Value;
      FreeAndNil(tm);
  end;

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
begin
    start := reply.Data.Position() - 1;
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
      info.&Type := dt;
      tmp2 := TGXByteBuffer.Create();
      tmp2.SetArray(tmp);
      ret := TGXCommon.GetData(tmp2, info);
      freeAndNil(tmp2);
      reply.Time := ret.AsType<TGXDateTime>.Value;
    end;
    getDataFromBlock(reply.Data, start);
    getValueFromData(settings, reply);
end;

// Handle set response and update error status.
class procedure TGXDLMS.HandleSetResponse(settings: TGXDLMSSettings; data: TGXReplyData);
var
  invokeId: Byte;
  t: TSetResponseType;
begin
  t := TSetResponseType(data.Data.GetUInt8());
  // Invoke ID and priority.
  invokeId := data.Data.GetUInt8();
  // SetResponseNormal
  if t = TSetResponseType.srNormal Then
    data.Error := data.Data.GetUInt8()
  else if (t = TSetResponseType.srDataBlock) or (t = TSetResponseType.srLastDataBlock) Then
    data.Data.GetUInt32()
  else
    raise EArgumentException.Create('Invalid data type.');
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

// Handle get response and get data from block and/or update error status.
class function TGXDLMS.HandleGetResponse(settings: TGXDLMSSettings; reply: TGXReplyData; index: Integer): Boolean;
var
  ch: Byte;
  pos, cnt, blockLength: Integer;
  t: TGetCommandType;
  expectedIndex, number: LongWord;
  values: TList<TValue>;
begin
    //long number;
    Result := true;
    ch := 0;
    // Get type.
    t := TGetCommandType(reply.Data.GetUInt8());
    // Get invoke ID and priority.
    ch := reply.Data.GetUInt8();

    // Response normal
    if t = TGetCommandType.ctNormal Then
    begin
      // Result
      ch := reply.Data.GetUInt8();
      if ch <> 0 Then
        reply.Error := reply.Data.GetUInt8();
      GetDataFromBlock(reply.Data, 0);
    end
    else if t = TGetCommandType.ctNextDataBlock Then
    begin
        // GetResponsewithDataBlock
        // Is Last block.
        ch := reply.Data.GetUInt8();
        if ch = 0 Then
            reply.MoreData := TRequestTypes(Integer(reply.MoreData) or Integer(TRequestTypes.rtDataBlock))
        else
            reply.MoreData := TRequestTypes(Integer(reply.MoreData) and Not Integer(TRequestTypes.rtDataBlock));

        // Get Block number.
        number := reply.Data.GetUInt32();
        // If meter's block index is zero based.
        if (number = 0) and (settings.BlockIndex = 1) Then
          settings.BlockIndex := 0;

        expectedIndex := settings.BlockIndex;
        if (number <> expectedIndex) Then
          raise EArgumentException.Create(
                    'Invalid Block number. It is ' + IntToStr(number)
                            + ' and it should be ' + IntToStr(expectedIndex)
                            + '.');


        // Get status.
        ch := reply.Data.GetUInt8();
        if ch <> 0 Then
          reply.Error := reply.Data.GetUInt8();

        if reply.Data.Position() <> reply.Data.Size Then
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
              reply.Data.Size(index)
            else
              GetDataFromBlock(reply.Data, index);

            // If last packet and data is not try to peek.
            if (reply.MoreData = TRequestTypes.rtNone) Then
            begin
                if Not reply.Peek Then
                begin
                  reply.Data.Position(0);
                  settings.ResetBlockIndex();
                end;
            end;
        end;
    end
    else if t = TGetCommandType.ctWithList Then
    begin
      // Get object count.
      cnt := TGXCommon.GetObjectCount(reply.Data);
      values := TList<TValue>.Create();
      for pos := 0 to cnt - 1 do
      begin
        // Result
        ch := reply.Data.GetUInt8();
        if ch <> 0 Then
          reply.Error := reply.Data.GetUInt8()
        else
        begin
          reply.ReadPosition := reply.Data.Position();
          GetValueFromData(settings, reply);
          reply.Data.Position(reply.ReadPosition);
          if values <> Nil Then
            values.Add(reply.Value);

          reply.Value := Nil;
        end;
      end;
      reply.Value := TValue.From(values.ToArray());
      FreeAndNil(values);
      Result := false;
    end
    else
      raise EArgumentException.Create('Invalid Get response.');
end;

// Handle General block transfer message.
class procedure TGXDLMS.HandleGbt(settings : TGXDLMSSettings; data: TGXReplyData);
var
  window, bn, bna, ch: Byte;
  len, index: Integer;
begin
    data.Gbt := true;
    index := data.Data.Position() - 1;
    ch := data.Data.GetUInt8();
    // Is streaming active.
    // boolean streaming = (ch & $40) = 1;
    window := ch and $3F;
    // Block number.
    bn := data.Data.GetUInt8();
    // Block number acknowledged.
    bna := data.Data.GetUInt8();
    // Get APU tag.
    if data.Data.GetUInt8() <> 0 Then
      raise EArgumentException.Create('Invalid APU.');

    // Get Addl tag.
    if data.Data.GetUInt8() <> 0 Then
      raise EArgumentException.Create('Invalid APU.');

    data.Command := TCommand.NONE;
    if window <> 0 Then
    begin
      len := TGXCommon.GetObjectCount(data.Data);
      if (len <> data.Data.Size - data.Data.Position()) Then
      begin
        data.Complete := false;
        Exit;
      end;
    end;
    GetDataFromBlock(data.Data, index);
    GetPdu(settings, data);
    // Update Is Last block for GBT again. Get PDU might change it.
    if (ch and $80) = 0 Then
      data.MoreData := TRequestTypes(Integer(data.MoreData) or Integer(TRequestTypes.rtDataBlock))
    else
      data.MoreData := TRequestTypes(Integer(data.MoreData) and Not Integer(TRequestTypes.rtDataBlock));

    // Get data if all data is read or we want to peek data.
    if ((data.Data.Position() <> data.Data.Size)
            and ((data.Command = TCommand.ReadResponse) or (data.Command = TCommand.GetResponse))
            and ((data.MoreData = TRequestTypes.rtNone) or data.Peek)) Then
    begin
      data.Data.Position(0);
      getValueFromData(settings, data);
    end;
end;

// Get PDU from the packet.
class procedure TGXDLMS.GetPdu(settings : TGXDLMSSettings; data: TGXReplyData);
var
  index: Integer;
  cmd: TCommand;
begin
    cmd := data.Command;
    // If header is not read yet or GBT message.
    if (data.Command = TCommand.NONE) or (data.Gbt) Then
    begin
        // If PDU is missing.
        if data.Data.Size - data.Data.Position() = 0 Then
          raise EArgumentException.Create('Invalid PDU.');

        index := data.Data.Position();
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
            data.Data.Position(data.Data.Position() - 1);
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
            HandleGloResponse(settings, data, index);
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
            data.Data.Position(0)
          else
            data.Data.Position(1);
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
                data.Data.Position(data.CipherIndex);
                GetPdu(settings, data);
              end;
            end;
        end
        else
        begin
            if (data.Command = TCommand.ReadResponse) and (Not data.isMoreData) Then
            begin
              data.Data.Position(0);
              if data.CommandType = Byte(TSingleReadResponse.srDataBlockResult) Then
                data.CommandType := Byte(TSingleReadResponse.srData);

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
              TCommand.GLOMethodResponse:
              begin
                data.Data.Position(data.CipherIndex);
                GetPdu(settings, data);
              end;
            end;
        end;
    end;
    // Get data if all data is read or we want to peek data.
    if ((data.Data.Position() <> data.Data.Size)
            and ((cmd = TCommand.ReadResponse) or (cmd = TCommand.GetResponse)
                    or (cmd = TCommand.MethodResponse))
            and ((data.MoreData = TRequestTypes.rtNone) or data.Peek)) Then
        getValueFromData(settings, data);
end;

class procedure TGXDLMS.HandleExceptionResponse(data: TGXReplyData);
begin
  raise TGXDLMSException.Create(
          TStateError(data.Data.GetUInt8()),
          TExceptionServiceError(data.Data.GetUInt8()));
end;

class procedure TGXDLMS.HandleConfirmedServiceError(data : TGXReplyData);
var
  service: TConfirmedServiceError;
  t: TServiceError;
begin
  service := TConfirmedServiceError(data.Data.GetUInt8());
  t := TServiceError(data.Data.GetUInt8());
  raise TGXDLMSConfirmedServiceError.Create(service, t, data.Data.GetUInt8());
end;

class function TGXDLMS.HandleGloRequest(settings: TGXDLMSSettings; data: TGXReplyData; cmd: Byte) : Integer;
begin
  if settings.Cipher = Nil Then
    raise EArgumentException.Create('Secure connection is not supported.');

  Result := cmd;
  // If all frames are read.
  if Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
  begin
    data.Data.Position(data.Data.Position() - 1);
    settings.Cipher.Decrypt(settings.SourceSystemTitle, data.Data);
    // Get command.
    Result := data.Data.GetUInt8();
    data.Command := TCommand(Result);
  end
  else
    data.Data.Position(data.Data.Position() - 1);
end;

class procedure TGXDLMS.HandleGloResponse(settings: TGXDLMSSettings; data: TGXReplyData; index: Integer);
var
  bb: TGXByteBuffer;
  p: TAesGcmParameter;
begin
  if settings.Cipher = Nil Then
    raise EArgumentException.Create('Secure connection is not supported.');

  // If all frames are read.
  if Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
  begin
    data.Data.Position(data.Data.Position() - 1);
    bb := TGXByteBuffer.Create(data.Data);
    data.Data.Position(index);
    data.Data.size(index);
    p := settings.Cipher.Decrypt(settings.SourceSystemTitle, bb);
    FreeAndNil(p);
    data.Data.SetArray(bb);
    FreeAndNil(bb);
    data.Command := TCommand.NONE;
    GetPdu(settings, data);
    data.CipherIndex := data.Data.Size;
  end;
end;

class procedure TGXDLMS.HandleGeneralCiphering(settings: TGXDLMSSettings; data: TGXReplyData);
var
  p: TAesGcmParameter;
begin
  if settings.Cipher = Nil Then
    raise EArgumentException.Create('Secure connection is not supported.');

  // If all frames are read.
  if Integer(data.MoreData) and Integer(TRequestTypes.rtFrame) = 0 Then
  begin
    data.Data.Position(data.Data.Position() - 1);
    p := settings.Cipher.Decrypt(Nil, data.Data);
    data.Command := TCommand.NONE;
    if p.Security <> TSecurity.None Then
      GetPdu(settings, data);
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
  if Not reply.Value.IsEmpty and reply.Value.IsType<TArray<TValue>> Then
  begin
    info.&Type := TDataType.dtArray;
    info.Count := reply.TotalCount;
    info.Index := reply.Count;
  end;
  index := reply.Data.Position();
  reply.Data.Position(reply.ReadPosition);
  try
    value := TGXCommon.GetData(reply.Data, info);
    if Not value.IsEmpty Then
    begin // If new data.
      if Not value.IsArray Then
      begin
        reply.ValueType := info.&Type;
        reply.Value := value;
        reply.TotalCount := 0;
        reply.ReadPosition := reply.Data.Position();
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
            list.AddRange(reply.Value.AsType<TArray<TValue>>);
            list.AddRange(value.AsType<TArray<TValue>>);
            reply.Value := TValue.From(list.ToArray());
            FreeAndNil(list);
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
    reply.Data.Position(index);
  end;

  // If last data frame of the data block is read.
  if (reply.Command <> TCommand.DataNotification) and info.Complete
          and (reply.MoreData = TRequestTypes.rtNone) Then
  begin
    // If all blocks are read.
    settings.ResetBlockIndex();
    reply.Data.Position(0);
  end;
  FreeAndNil(info);
end;

class function TGXDLMS.GetData(settings: TGXDLMSSettings; reply: TGXByteBuffer; data: TGXReplyData) : Boolean;
var
    frame, cnt : Integer;
begin
  frame := 0;
  // If DLMS frame is generated.
  if settings.InterfaceType = TInterfaceType.HDLC then
  begin
    frame := GetHdlcData(settings.isServer, settings, reply, data);
    data.FrameId := frame;
  end
  else if settings.InterfaceType = TInterfaceType.WRAPPER Then
    GetTcpData(settings, reply, data)
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

  GetDataFromFrame(reply, data);

  // If keepalive or get next frame request.
  if ((frame <> $13) and ((frame and $1) <> 0)) Then
  begin
      if (settings.InterfaceType = TInterfaceType.HDLC) and
        ((data.Error = Byte(TErrorCode.ecRejected)) or (data.Data.Size <> 0)) Then
      begin
        if reply.Position <> reply.Size Then
          reply.Position (reply.Position + 3);
      end;
      Result := true;
      Exit;
  end;
  GetPdu(settings, data);
  if data.Command = TCommand.DataNotification Then
  begin
      // Check is there more messages left. This is Push message special case.
      if (reply.Position() = reply.Size) Then
      begin
          reply.clear();
      end
      else
      begin
          cnt := reply.Size - reply.Position;
          reply.Move(reply.Position, 0, cnt);
          reply.Position(0);
      end;
  end;
  Result := true;
end;

// Get data from HDLC or wrapper frame.
class procedure TGXDLMS.GetDataFromFrame(reply: TGXByteBuffer; info: TGXReplyData);
var
  offset, cnt : Integer;
begin
    offset := info.Data.Size();
    cnt := info.PacketLength - reply.Position;
    if cnt <> 0 then
    begin
      info.Data.Capacity(offset + cnt);
      info.Data.SetArray(reply.GetData(), reply.Position(), cnt);
      reply.Position(reply.Position() + cnt);
    end;
    // Set position to begin of new data.
    info.Data.Position(offset);
end;

// Get data from Block.
class function TGXDLMS.GetDataFromBlock(data: TGXByteBuffer; index: Integer) : Integer;
begin
  if data.Size = data.Position() Then
  begin
    data.clear();
    Result := 0;
  end
  else
  begin
    Result := data.Position() - index;
    Move(data.GetData()[data.Position()], data.GetData()[data.Position() - Result], data.Size - data.Position());
    data.Position(data.Position() - Result);
    data.size(data.Size - Result);
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

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

unit Gurux.DLMS.GXDLMSLNParameters;

interface
uses Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSObject,
GXByteBuffer,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.GetCommandType;

type
//LN Parameters
TGXDLMSLNParameters = class
  // DLMS settings.
  FSettings: TGXDLMSSettings;
  // DLMS Command.
  FCommand: TCommand;
  // Ciphered Command.
  FCipheredCommand: TCommand;
  // Request type.
  FRequestType: Byte;
  // Attribute descriptor.
  FAttributeDescriptor: TGXByteBuffer;
  // Data.
  FData: TGXByteBuffer;
  // Send date and time. This is used in Data notification messages.
  FTime: TGXDateTime;
  // Reply status.
  FStatus: Byte;
  // Are there more data to send or more data to receive.
  FMultipleBlocks: Boolean;
  // Is this last block in send.
  FLastBlock: Boolean;
  // Block index.
  FBlockIndex: Cardinal;
  //Block number ack.
  FBlockNumberAck: WORD;

  // Received invoke ID.
  FInvokeId: Cardinal;

  FWindowSize: Byte;

  FStreaming: Boolean;
  FAccessMode: Integer;

  // Constructor.
  // <param name="ASettings">DLMS settings.</param>
  // <param name="ACommand">Command.</param>
  // <param name="ACommandType">Command type.</param>
  // <param name="AAttributeDescriptor">Attribute descriptor,</param>
  // <param name="AData">Data,</param>
  constructor Create(
      ASettings: TGXDLMSSettings;
      invokeId: Cardinal;
      ACommand: TCommand;
      ACommandType: Byte;
      AAttributeDescriptor: TGXByteBuffer;
      AData: TGXByteBuffer;
      AStatus: Byte;
      ACipheredCommand:TCommand);

  // DLMS settings.
  property Settings: TGXDLMSSettings read FSettings write FSettings;

  // DLMS Command.
  property Command: TCommand read FCommand write FCommand;

  // Request type.
  property RequestType: Byte read FRequestType write FRequestType;

  // Attribute descriptor.
  property AttributeDescriptor: TGXByteBuffer read FAttributeDescriptor write FAttributeDescriptor;
  // Data.
  property Data: TGXByteBuffer read FData write FData;
  // Send date and time. This is used in Data notification messages.
  property Time: TGXDateTime read FTime write FTime;
  // Reply status.
  property Status: Byte read FStatus write FStatus;
  // Are there more data to send or more data to receive.
  property MultipleBlocks: Boolean read FMultipleBlocks write FMultipleBlocks;
  // Is this last block in send.
  property LastBlock: Boolean read FLastBlock write FLastBlock;
  // Block index.
  property BlockIndex: Cardinal read FBlockIndex write FBlockIndex;
  // Received invoke ID.
  property InvokeId: Cardinal read FInvokeId write FInvokeId;

  property WindowSize: Byte read FWindowSize write FWindowSize;
  property Streaming: Boolean read FStreaming write FStreaming;
  property AccessMode: Integer read FAccessMode write FAccessMode;

  property BlockNumberAck: WORD read FBlockNumberAck write FBlockNumberAck;
end;

implementation
  constructor TGXDLMSLNParameters.Create(ASettings: TGXDLMSSettings; invokeId: Cardinal;
  ACommand: TCommand; ACommandType: Byte; AAttributeDescriptor: TGXByteBuffer;
  AData: TGXByteBuffer; AStatus: Byte; ACipheredCommand:TCommand);
  begin
    FSettings := ASettings;
    FInvokeId := invokeId;
    FBlockIndex := ASettings.BlockIndex;
    FCommand := ACommand;
    FCipheredCommand := ACipheredCommand;
    FRequestType := ACommandType;
    FAttributeDescriptor := AAttributeDescriptor;
    FData := AData;
    FTime := Nil;
    FStatus := AStatus;
    FMultipleBlocks := ASettings.Count <> ASettings.Index;
    FLastBlock := ASettings.Count = ASettings.Index;
    FStreaming := false;
    WindowSize := 1;
    FBlockNumberAck := 0;
    if settings <> Nil Then
    begin
      settings.Command := ACommand;
      if (ACommand = TCommand.GetRequest) and (ACommandType <> BYTE(TGetCommandType.ctNextDataBlock)) Then
        settings.CommandType := TGetCommandType(ACommandType);
    end;
  end;
end.

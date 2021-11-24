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

unit Gurux.DLMS.GXDLMSSNParameters;

interface
uses Gurux.DLMS.GXDateTime, Gurux.DLMS.GXDLMSObject, Gurux.DLMS.Command,
GXByteBuffer;

type
//SN Parameters
TGXDLMSSNParameters = class
  // DLMS settings.
  FSettings: TGXDLMSSettings;
  // DLMS Command.
  FCommand: TCommand;
  // Request type.
  FRequestType: Byte;
  // Attribute descriptor.
  FAttributeDescriptor: TGXByteBuffer;
  // Data.
  FData: TGXByteBuffer;
  // Send date and time. This is used in Data notification messages.
  FTime: TDateTime;
  // Item Count.
  FCount: Integer;
  // Are there more data to send or more data to receive.
  FMultipleBlocks: Boolean;
  // Block index.
  FBlockIndex: WORD;

  public
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
  property Time: TDateTime read FTime write FTime;
  // Item Count.
  property Count: Integer read FCount write FCount;
  // Are there more data to send or more data to receive.
  property MultipleBlocks: Boolean read FMultipleBlocks write FMultipleBlocks;
  // Block index.
  property BlockIndex: WORD read FBlockIndex write FBlockIndex;

  // Constructor.
  // <param name="settings">DLMS settings.</param>
  // <param name="command">Command.</param>
  // <param name="commandType">Command type.</param>
  // <param name="attributeDescriptor"></param>
  // <param name="data">Attribute descriptor</param>
  // <returns>Generated messages.</returns>
  constructor Create(settings: TGXDLMSSettings; command: TCommand;
    count: Integer; CommandType: Byte; attributeDescriptor: TGXByteBuffer; data: TGXByteBuffer);
end;

implementation
  constructor TGXDLMSSNParameters.Create(settings: TGXDLMSSettings; command: TCommand;
    count: Integer; CommandType: Byte; attributeDescriptor: TGXByteBuffer; data: TGXByteBuffer);
  begin
      FSettings := settings;
      FBlockIndex := settings.BlockIndex;
      FCommand := command;
      FCount := count;
      FRequestType := commandType;
      FAttributeDescriptor := attributeDescriptor;
      FData := data;
      FTime := 0;
      FMultipleBlocks := false;
  end;
end.

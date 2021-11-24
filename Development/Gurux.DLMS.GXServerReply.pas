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

unit Gurux.DLMS.GXServerReply;

interface

uses SysUtils,
Gurux.DLMS.Command,
Gurux.DLMS.GXDLMSConnectionEventArgs,
Gurux.DLMS.GXDLMSGateway;

type
 TGXServerReply = class
 public
  // Server received data.
  Data: TBytes;
  // Server reply message.
  Reply: TBytes;
  //Message count to send.
  Count: WORD;
  // Received command.
  Command: TCommand;
  // Gateway information.
  Gateway: TGXDLMSGateway;
  // Connection info.
  ConnectionInfo: TGXDLMSConnectionEventArgs;

  constructor Create(AData: TBytes); overload;
  // Is GBT streaming in progress.
  function IsStreaming():BOOLEAN;

 end;
implementation
constructor TGXServerReply.Create(AData: TBytes);
begin
  Data := AData;
end;

function TGXServerReply.IsStreaming(): BOOLEAN;
begin
  Result := Count <> 0;
end;

end.

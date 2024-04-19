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

unit Gurux.DLMS.Objects.GXCoapMessagesCounter;

interface

type

//CoAP messages counter.
TGXCoapMessagesCounter = class
public
  // Transmit messages.
  Tx : UInt32;

  // Received messages.
  Rx: UInt32;

  // CoAP messages that have been re-sent.
  TxResend : UInt32;

  // Received CoAP reset messages.
  RxReset : UInt32;

  /// Transmit CoAP reset messages.
  TxReset : UInt32;
  // Received CoAP acknowledgement messages.
  RxAck : UInt32;

  /// Transmit CoAP acknowledgement messages.
  TxAck : UInt32;

  // The number of CoAP messages received but silently dropped
  // due to message format error or other reason.
  RxDrop: UInt32;

  /// The number of CoAP responses that were returned non-piggybacked.
  TxNonPiggybacked: UInt32;

  // The number of times transmission of a CoAP message
  // was abandoned due to exceed of the max retransmission counter of the CoAP
  // messaging layer.
  MaxRtxExceeded : UInt32;
end;

implementation

end.

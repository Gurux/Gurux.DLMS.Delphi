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

unit Gurux.DLMS.Objects.GXCoapRequestResponseCounter;

interface

type
TGXCoapRequestResponseCounter = class
public

  // CoAP requests received.
  RxRequests: UInt32;

  // CoAP requests sent.
  TxRequests: UInt32;

  // CoAP responses received.
  RxResponse : UInt32;

  // CoAP responses sent.
  TxResponse : UInt32;

  // CoAP client errors sent.
  TxClientError : UInt32;

  // CoAP client errors received.
  RxClientError: UInt32;

  //  CoAP server errors sent.
  TxServerError: UInt32;

  // CoAP server errors received.
  RxServerError: UInt32;
end;

implementation

end.

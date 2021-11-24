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

unit Gurux.DLMS.Enums.AccessMode3;

interface

type
  //  The AccessMode enumerates the access modes for Logical Name Association version 3.
  TAccessMode3 = (
    /// No access.
    NoAccess = 0,
    /// The client is allowed only reading from the server.
    Read = 1,
    /// The client is allowed only writing to the server.
    Write = 2,
    /// Request messages are authenticated.
    AuthenticatedRequest = 4,
    /// Request messages are encrypted.
    EncryptedRequest = 8,
    /// Request messages are digitally signed.
    DigitallySignedRequest = 16,
    /// Response messages are authenticated.
    AuthenticatedResponse = 32,
    /// Response messages are encrypted.
    EncryptedResponse = 64,
    /// Response messages are digitally signed.
    DigitallySignedResponse = 128
   );

implementation

end.

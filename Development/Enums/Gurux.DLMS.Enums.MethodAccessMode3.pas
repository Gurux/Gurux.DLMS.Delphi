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

unit Gurux.DLMS.Enums.MethodAccessMode3;

interface
type
    //The MethodAccessMode enumerates the method access modes for logical name association version 3.
    TMethodAccessMode3 = (
    /// Client can't use method.
    NoAccess = $0,
    /// Access is allowed.
    Access = $1,
    /// Authenticated request.
    AuthenticatedRequest = $4,
    /// Encrypted request.
    EncryptedRequest = $8,
    /// Digitally signed request.
    DigitallySignedRequest = $10,
    /// Authenticated response.
    AuthenticatedResponse = $20,
    /// Encrypted response
    EncryptedResponse = $40,
    /// Digitally signed response.
    DigitallySignedResponse = $80
    );

implementation

end.

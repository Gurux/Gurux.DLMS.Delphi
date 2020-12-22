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

unit Gurux.DLMS.MethodAccessMode;

interface
type
    TMethodAccessMode = (
    // Client can't use method.
    NoAccess = $0,
    //Method is allowed to use.
    Access = $1,
    //Authenticated access is allowed.
    AuthenticatedAccess = $2,
    // Authenticated request is allowed.
    AuthenticatedRequest = $4,
    // Encrypted request is allowed.
    EncryptedRequest = $8,
    // Digitally signed request is allowed.
    DigitallySignedRequest = $10,
    // Authenticated response is allowed.
    AuthenticatedResponse = $20,
    // Encrypted response is allowed.
    EncryptedResponse = $40,
    // Digitally signed response is allowed.
    DigitallySignedResponse = $80
    );

implementation

end.

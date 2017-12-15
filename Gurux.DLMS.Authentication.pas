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

unit Gurux.DLMS.Authentication;

interface
type
  //Authentication enumerates the authentication levels.
  TAuthentication = (
    // No authentication is used.
    atNone,
    // Low authentication is used.
    atLow,
    // High authentication is used.
    atHigh,
    // High authentication is used. Password is hashed with MD5.
    atHighMD5,
    // High authentication is used. Password is hashed with SHA1.
    atHighSHA1,
    // High authentication is used. Password is hashed with GMAC.
    atHighGMAC,
    // High authentication is used. Password is hashed with SHA-256.
    atHighSHA256,
    // High authentication is used. Password is hashed with ECDSA.
    atHighECDSA
    );

implementation

end.

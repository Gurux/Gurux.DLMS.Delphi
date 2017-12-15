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

unit Gurux.DLMS.BerType;

interface

type
  //BER encoding enumeration values.
  TBerType = (
    // End of Content.
    btEOC = $00,
    // Boolean.
    btBoolean = $1,
    // Integer.
    btInteger = $2,
    // Bit String.
    btBitString = $3,
    // Octet string.
    btOctetString = $4,
    // Null value.
    btNull = $5,
    // Object identifier.
    btObjectIdentifier = $6,
    // Object Descriptor.
    btObjectDescriptor = 7,
    // External
    btExternal = 8,
    // Real (float).
    btReal = 9,
    // Enumerated.
    btEnumerated = 10,
    // Utf8 String.
    btUtf8StringTag = 12,
    // Numeric string.
    btNumericString = 18,
    // Printable string.
    btPrintableString = 19,
    // Teletex string.
    btTeletexString = 20,
    // Videotex string.
    btVideotexString = 21,
    // Ia5 string
    btIa5String = 22,
    // Utc time.
    btUtcTime = 23,
    // Generalized time.
    btGeneralizedTime = 24,
    // Graphic string.
    btGraphicString = 25,
    // Visible string.
    btVisibleString = 26,
    // General string.
    btGeneralString = 27,
    // Universal string.
    btUniversalString = 28,
    // Bmp string.
    btBmpString = 30,
    // Application class.
    btApplication = $40,
    // Context class.
    btContext = $80,
    // Private class.
    btPrivate = $c0,
    // Constructed.
    btConstructed = $20
);

implementation

end.

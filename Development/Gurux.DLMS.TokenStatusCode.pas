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

unit Gurux.DLMS.TokenStatusCode;

interface

type
  //Enumerates token status codes.
  TTokenStatusCode = (
    // Token format result OK.
    FormatOk,
    // Authentication result OK.
    AuthenticationOk,
    // Validation result OK.
    ValidationOk,
    // Token execution result OK.
    TokenExecutionOk,
    // Token format failure.
    TokenFormatFailure,
    // Authentication failure.
    AuthenticationFailure,
    // Validation result failure.
    ValidationResultFailure,
    // Token execution result failure.
    TokenExecutionResultFailure,
    // Token received and not yet processed.
    TokenReceived
);

implementation

end.

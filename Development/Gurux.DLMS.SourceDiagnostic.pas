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

unit Gurux.DLMS.SourceDiagnostic;

interface

type
TSourceDiagnostic = (
  //OK.
  None = 0,
  // No reason is given.
  NoReasonGiven = 1,
  // The application context name is not supported.
  ApplicationContextNameNotSupported = 2,
  // Calling AP title not recognized.
  CallingApTitleNotRecognized = 3,
  // Calling AP invocation identifier not recognized.
  CallingApInvocationIdentifierNotRecognized = 4,
  // Calling AE qualifier not recognized
  CallingAeQualifierNotRecognized = 5,
  // Calling AE invocation identifier not recognized
  CallingAeInvocationIdentifierNotRecognized = 6,
  // Called AP title not recognized
  CalledApTitleNotRecognized = 7,
  // Called AP invocation identifier not recognized
  CalledApInvocationIdentifierNotRecognized = 8,
  // Called AE qualifier not recognized
  CalledAeQualifierNotRecognized = 9,
  // Called AE invocation identifier not recognized
  CalledAeInvocationIdentifierNotRecognized = 10,
  // The authentication mechanism name is not recognized.
  AuthenticationMechanismNameNotRecognised = 11,
  // Authentication mechanism name is required.
  AuthenticationMechanismNameReguired = 12,
  // Authentication failure.
  AuthenticationFailure = 13,
  // Authentication is required.
  AuthenticationRequired = 14);

implementation

end.

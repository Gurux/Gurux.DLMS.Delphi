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

unit Gurux.DLMS.PduType;

interface

type
  // APDU types.
  TPduType = (
    // IMPLICIT BIT STRING {version1 (0)} DEFAULT {version1}
    ProtocolVersion = 0,
    // Application-context-name
    ApplicationContextName,
    // AP-title OPTIONAL
    CalledApTitle,
    // AE-qualifier OPTIONAL.
    CalledAeQualifier,
    // AP-invocation-identifier OPTIONAL.
    CalledApInvocationId,
    // AE-invocation-identifier OPTIONAL
    CalledAeInvocationId,
    // AP-title OPTIONAL
    CallingApTitle,
    // AE-qualifier OPTIONAL
    CallingAeQualifier,
    // AP-invocation-identifier OPTIONAL
    CallingApInvocationId,
    // AE-invocation-identifier OPTIONAL
    CallingAeInvocationId,
    // The following field shall not be present if only the kernel is used.
    SenderAcseRequirements,
    // The following field shall only be present if the authentication functional unit is selected.
    MechanismName = 11,
    // The following field shall only be present if the authentication functional unit is selected.
    CallingAuthenticationValue = 12,
    // Implementation-data.
    ImplementationInformation = 29,
    // Association-information OPTIONAL
    UserInformation = 30
  );

implementation

end.

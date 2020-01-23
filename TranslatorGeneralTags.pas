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

unit TranslatorGeneralTags;

interface
type
TTranslatorGeneralTags =
(
  ApplicationContextName = $A1,
  NegotiatedQualityOfService = $BE00,
  ProposedDlmsVersionNumber = $BE01,
  ProposedMaxPduSize = $BE02,
  ProposedConformance = $BE03,
  VaaName = $BE04,
  NegotiatedConformance = $BE05,
  NegotiatedDlmsVersionNumber = $BE06,
  NegotiatedMaxPduSize = $BE07,
  ConformanceBit = $BE08,
  ProposedQualityOfService = $BE09,
  SenderACSERequirements = $8A,
  ResponderACSERequirement = $88,
  RespondingMechanismName = $89,
  CallingMechanismName = $8B,
  CallingAuthentication = $AC,
  RespondingAuthentication = $80,
  AssociationResult = $A2,
  ResultSourceDiagnostic = $A3,
  ACSEServiceUser = $A301,
  ACSEServiceProvider = $A302,
  CallingAPTitle = $A6,
  RespondingAPTitle = $A4,
  DedicatedKey = $A8,
  CallingAeInvocationId = $A9,
  CalledAeInvocationId = $A5,
  CallingAeQualifier = $A7,
  CharString = $AA,
  UserInformation = $AB,
  RespondingAeInvocationId = $AD
);
implementation

end.

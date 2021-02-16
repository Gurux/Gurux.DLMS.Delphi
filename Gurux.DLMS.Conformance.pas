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

unit Gurux.DLMS.Conformance;

interface

type
// Enumerates all comformance bits.
TConformance = (
  //Conformance is not used.
  cfNone = 0,
  // Reserved zero conformance bit.
  cfReservedZero = $1,
  // General protection conformance bit.
  cfGeneralProtection = $2,
  // General block transfer conformance bit.
  cfGeneralBlockTransfer = $4,
  // Read conformance bit.
  cfRead = $8,
  // Write conformance bit.
  cfWrite = $10,
  // Un confirmed write conformance bit.
  cfUnconfirmedWrite = $20,
  // Delta value encoding conformance bit.
  cfDeltaValueEncoding = $40,
  // Reserved seven conformance bit.
  cfReservedSeven = $80,
  // Attribute 0 supported with set conformance bit.
  cfAttribute0SupportedWithSet = $100,
  // Priority mgmt supported conformance bit.
  cfPriorityMgmtSupported = $200,
  // Attribute 0 supported with get conformance bit.
  cfAttribute0SupportedWithGet = $400,
  // Block transfer with get or read conformance bit.
  cfBlockTransferWithGetOrRead = $800,
  // Block transfer with set or write conformance bit.
  cfBlockTransferWithSetOrWrite = $1000,
  // Block transfer with action conformance bit.
  cfBlockTransferWithAction = $2000,
  // Multiple references conformance bit.
  cfMultipleReferences = $4000,
  // Information report conformance bit.
  cfInformationReport = $8000,
  // Data notification conformance bit.
  cfDataNotification = $10000,
  // Access conformance bit.
  cfAccess = $20000,
  // Parameterized access conformance bit.
  cfParameterizedAccess = $40000,
  // Get conformance bit.
  cfGet = $80000,
  // Set conformance bit.
  cfSet = $100000,
  // Selective access conformance bit.
  cfSelectiveAccess = $200000,
  // Event notification conformance bit.
  cfEventNotification = $400000,
  // Action conformance bit.
  cfAction = $800000
);

implementation

end.

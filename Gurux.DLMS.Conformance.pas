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
  /// Reserved zero conformance bit.
  cfReservedZero = 8388608,
  /// General protection conformance bit.
  cfGeneralProtection = 4194304,
  /// General block transfer conformance bit.
  cfGeneralBlockTransfer = 2097152,
  //Read conformance bit.
  cfRead = 1048576,
  //Write conformance bit.
  cfWrite = 524288,
  //Un confirmed write conformance bit.
  cfUnconfirmedWrite = 262144,
  //Reserved six conformance bit.
  cfReservedSix = 131072,
  //Reserved seven conformance bit.
  cfReservedSeven = 65536,
  //Attribute 0 supported with set conformance bit.
  cfAttribute0SupportedWithSet = 32768,
  //Priority mgmt supported conformance bit.
  cfPriorityMgmtSupported = 16384,
  //Attribute 0 supported with get conformance bit.
  cfAttribute0SupportedWithGet = 8192,
  //Block transfer with get or read conformance bit.
  cfBlockTransferWithGetOrRead = 4096,
  //Block transfer with set or write conformance bit.
  cfBlockTransferWithSetOrWrite = 2048,
  //Block transfer with action conformance bit.
  cfBlockTransferWithAction = 1024,
  //multiple references conformance bit.
  cfMultipleReferences = 512,
  //Information report conformance bit.
  cfInformationReport = 256,
  //Data notification conformance bit.
  cfDataNotification = 128,
  //Access conformance bit.
  cfAccess = 64,
  //Parameterized access conformance bit.
  cfParameterizedAccess = 32,
  //Get conformance bit.
  cfGet = 16,
  //Set conformance bit.
  cfSet = 8,
  //Selective access conformance bit.
  cfSelectiveAccess = 4,
  //Event notification conformance bit.
  cfEventNotification = 2,
  //Action conformance bit.
  cfAction = 1,
  //Conformance is not used.
  cfNone = 0
);

implementation

end.

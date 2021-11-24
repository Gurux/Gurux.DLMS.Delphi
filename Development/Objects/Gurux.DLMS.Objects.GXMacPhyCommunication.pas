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

unit Gurux.DLMS.Objects.GXMacPhyCommunication;

interface

uses SysUtils;
type
TGXMacPhyCommunication = class
  // EUI is the EUI-48 of the other device.
  Eui: TBytes;
  // The tx power of GPDU packets sent to the device
  TxPower: Int16;
  // The Tx coding of GPDU packets sent to the device;
  TxCoding: Int16;
  // The Rx coding of GPDU packets received from the device
  RxCoding: Int16;
  // The Rx power level of GPDU packets received from the device.
  RxLvl: Int16;
  // SNR of GPDU packets received from the device.
  Snr: Int16;
  // The number of times the Tx power was modified.
  TxPowerModified: Int16;
  // The number of times the Tx coding was modified.
  TxCodingModified: Int16;
  // The number of times the Rx coding was modified.
  RxCodingModified: Int16;
end;

implementation

end.

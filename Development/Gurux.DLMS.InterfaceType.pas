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

unit Gurux.DLMS.InterfaceType;

interface

type
  TInterfaceType = (
  //General interface type is used for meters that support
  // IEC 62056-46 Data link layer using HDLC protocol.
  HDLC,
  // Network interface type is used for meters that support
  // IEC 62056-47 COSEM transport layers for IPv4 networks.
  WRAPPER,
  //Plain PDU is returned.
  PDU,
  // IEC 62056-7-3 Wireless M-Bus profile is used.
  WirelessMBus,
  // IEC 62056-21 E-Mode is used to initialize communication before moving to HDLC protocol.
  HdlcWithModeE,
  // PLC Logical link control (LLC) profile is used with IEC 61334-4-32 connectionless LLC sublayer.
  // Blue Book: 10.4.4.3.3 The connectionless LLC sublayer.
  Plc,
  // PLC Logical link control (LLC) profile is used with HDLC.
  // Blue Book: 10.4.4.3.4 The HDLC based LLC sublayer.
  PlcHdlc,
  // LowPower Wide Area Networks (LPWAN) profile is used.
  LPWAN,
  // Wi-SUN FAN mesh network is used.
  WiSUN,
  // OFDM PLC PRIME is defined in IEC 62056-8-4.
  PlcPrime
  );

implementation

end.

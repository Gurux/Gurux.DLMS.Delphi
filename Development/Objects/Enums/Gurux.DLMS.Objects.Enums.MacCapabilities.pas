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

unit Gurux.DLMS.Objects.Enums.MacCapabilities;

interface

type
//Present functional state of the node.
TMacCapabilities =
(
  // Switch capable.
  SwitchCapable = 1,
  // Packet aggregation.
  PacketAggregation = 2,
  // Contention free period.
  ContentionFreePeriod = 4,
  // Direct connection.
  DirectConnection = 8,
  // Multicast.
  Multicast = $10,
  //  PHY Robustness Management.
  PhyRobustnessManagement = $20,
  // ARQ.
  Arq = $40,
  // Reserved for future use.
  ReservedForFutureUse = $80,
  //  Direct Connection Switching.
  DirectConnectionSwitching = $100,
  // Multicast Switching Capability.
  MulticastSwitchingCapability = $200,
  // PHY Robustness Management Switching Capability.
  PhyRobustnessManagementSwitchingCapability = $400,
  // ARQ Buffering Switching Capability.
  ArqBufferingSwitchingCapability = $800
);

implementation

end.

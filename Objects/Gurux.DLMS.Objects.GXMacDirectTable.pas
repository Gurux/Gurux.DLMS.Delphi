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

unit Gurux.DLMS.Objects.GXMacDirectTable;

interface
uses SysUtils;
type
// MAC direct table element.
TGXMacDirectTable = class
  // SID of switch through which the source service node is connected.
  SourceSId: Int16;
  //NID allocated to the source service node.
  SourceLnId: Int16;
  // LCID allocated to this connection at the source.
  SourceLcId: Int16;
  // SID of the switch through which the destination service node is connected.
  DestinationSId: Int16;
  // NID allocated to the destination service node.
  DestinationLnId: Int16 ;
  // LCID allocated to this connection at the destination.
  DestinationLcId: Int16;
  // Entry DID is the EUI-48 of the direct switch
  Did: TBytes;
end;

implementation

end.

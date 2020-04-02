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

unit Gurux.DLMS.Objects.GXMacAvailableSwitch;

interface

uses SysUtils;
type
//MAC available switch.
TGXMacAvailableSwitch = class
  // EUI-48 of the subnetwork.
  Sna: TBytes;
  // SID of this switch.
  LsId: Int32;
  // Level of this switch in subnetwork hierarchy.
  Level: Int16;
  // The received signal level for this switch;
  RxLevel: Int16;
  // The signal to noise ratio for this switch.
  RxSnr: Int16;
end;

implementation

end.

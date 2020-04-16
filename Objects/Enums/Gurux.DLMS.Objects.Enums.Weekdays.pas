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

unit Gurux.DLMS.Objects.Enums.Weekdays;

interface

type

//Defines the weekdays.
[FlagsAttribute]
TWeekdays =
(
  // No day of week is selected.
  wdNone = 0,
  // Indicates Monday.
  wdMonday = $1,
  // Indicates Tuesday.
  wdTuesday = $2,
  // Indicates Wednesday.
  wdWednesday = $4,
  // Indicates Thursday.
  wdThursday = $8,
  // Indicates Friday.
  wdFriday = $10,
  // Indicates Saturday.
  wdSaturday = $20,
  // Indicates Sunday.
  wdSunday = $40
);
implementation

end.

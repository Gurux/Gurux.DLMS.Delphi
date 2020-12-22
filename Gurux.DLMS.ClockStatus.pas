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

unit Gurux.DLMS.ClockStatus;

interface
type
TClockStatus =
(
    /// OK.
    ctNone = 0,
    /// Invalid a value,
    ctInvalidValue = $1,
    /// Doubtful b value
    ctDoubtfulValue = $2,
    /// Different clock base c
    ctDifferentClockBase = $4,
    /// Invalid clock status d
    ctInvalidClockStatus = $8,
    /// Daylight saving active.
    ctDaylightSavingActive = $80,
    /// Clock status is skipped on write.
    ctSkip = $FF
);

implementation

end.

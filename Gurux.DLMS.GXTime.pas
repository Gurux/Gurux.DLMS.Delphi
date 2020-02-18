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

unit Gurux.DLMS.GXTime;

interface
uses Gurux.DLMS.GXDateTime;

type
  TGXTime = class(TGXDateTime)
    constructor Create(hour: Integer; minute: Integer; second: Integer; millisecond: Integer); overload;
    constructor Create(value: TGXDateTime); overload;
    constructor Create(AValue: TDateTime = -1); overload;
  end;

implementation

uses SysUtils, Gurux.DLMS.DateTimeSkips;

constructor TGXTime.Create(hour: Integer; minute: Integer; second: Integer; millisecond: Integer);
begin
  inherited Create($FFFF, $FF, $FF, hour, minute, second, millisecond, $FF);
end;

constructor TGXTime.Create(value: TGXDateTime);
var
  hour, minute, second, millisecond : Word;
begin
  DecodeTime(value.Time, hour, minute, second, millisecond);
  inherited Create($FFFF, $FF, $FF, hour, minute, second, millisecond, $FF);
  Skip.Add(value.Skip);
  Extra := value.Extra;
end;

constructor TGXTime.Create(AValue: TDateTime = -1);
begin
  inherited Create(AValue);
  Skip.Add(TDateTimeSkips.dkYear);
  Skip.Add(TDateTimeSkips.dkMonth);
  Skip.Add(TDateTimeSkips.dkDay);
  Skip.Add(TDateTimeSkips.dkDayOfWeek);
  Skip.Add(TDateTimeSkips.dkDeviation);
end;
end.

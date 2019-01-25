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

unit Gurux.DLMS.GXDate;

interface
uses Gurux.DLMS.GXDateTime;

type
  TGXDate = class(TGXDateTime)
    constructor Create(year: Integer; month: Integer; day: Integer; dow: Integer = $FF); overload;
    constructor Create(value: TGXDateTime); overload;
    constructor Create(AValue: TDateTime = -1); overload;
  end;

implementation

uses SysUtils, Gurux.DLMS.DateTimeSkips;

constructor TGXDate.Create(year: Integer; month: Integer; day: Integer; dow: Integer);
begin
  inherited Create(year, month, day, $FF, $FF, $FF, $FF, dow);
end;

constructor TGXDate.Create(value: TGXDateTime);
var
  Y, M, D : Word;
begin
  DecodeDate(value.Time, Y, M, D);
  inherited Create(Y, M, D, $FF, $FF, $FF, $FF, $FF);
  Skip.Add(value.Skip);
end;

constructor TGXDate.Create(AValue: TDateTime = -1);
begin
  inherited Create(AValue);
  Skip.Add(TDateTimeSkips.dkHour);
  Skip.Add(TDateTimeSkips.dkMinute);
  Skip.Add(TDateTimeSkips.dkSecond);
  Skip.Add(TDateTimeSkips.dkMs);
end;
end.

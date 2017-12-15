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

unit Gurux.DLMS.GXDateTime;

interface

uses DateUtils, SysUtils, System.Generics.Collections,
Gurux.DLMS.DateTimeSkips, Gurux.DLMS.ClockStatus;

type
  TGXDateTime = class
  private
  FValue : TDateTime;
  FSkip : TDateTimeSkips;
  FDaylightSavingsBegin, FDaylightSavingsEnd : Boolean;
  FStatus : TClockStatus;
  FTimeZone : Integer;
  public
    //Minimum date time value.
    class function MinDateTime : TDateTime; static;

    constructor Create; overload;
    constructor Create(value: TDateTime); overload;
    constructor Create(year: Integer; month: Integer; day: Integer; hour: Integer;
      minute: Integer; second: Integer; millisecond: Integer); overload;

    property Value: TDateTime read FValue write FValue;
    property Skip: TDateTimeSkips read FSkip write FSkip;

    property DaylightSavingsBegin: Boolean read FDaylightSavingsBegin write FDaylightSavingsBegin;
    property DaylightSavingsEnd: Boolean read FDaylightSavingsEnd write FDaylightSavingsEnd;
    //Status of the clock.
    property Status: TClockStatus read FStatus write FStatus;

    //Used time zone. In default it's not used.
    property TimeZone: Integer read FTimeZone write FTimeZone;

    function ToString: string; override;
  end;

implementation

{$WARN SYMBOL_PLATFORM OFF}

class function TGXDateTime.MinDateTime : TDateTime;
var
v :Double;
begin
  v := 2;
  Result := TDateTime(v)//01 Jan 1900 has a days value of 2.
end;

constructor TGXDateTime.Create;
begin
  inherited Create;
  FStatus := TClockStatus.ctNone;
  FTimeZone := $8000;
end;

constructor TGXDateTime.Create(value: TDateTime);
begin
  Create;
  Self.Value := value;
end;

constructor TGXDateTime.Create(year: Integer; month: Integer; day: Integer;
      hour: Integer; minute: Integer; second: Integer; millisecond: Integer);
begin
  Create;
  FStatus := TClockStatus.ctNone;
  if ((year < 1) or (year = 65535)) then
  begin
    //01 Jan 1900 has a days value of 2.
    year := 2;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkYear));
  end;

  FDaylightSavingsBegin := month = $FE;
  FDaylightSavingsEnd := month = $FD;
  if (month < 1) or (month = 255) then
  begin
    month := 1;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkMonth));
  end
  else if (month = 254) or (month = 253) then
    month := 1;

  if (day < 1) or (day = 255) then
  begin
    day := 1;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkDay));
  end
  else if day = $FD then
  begin
    day := DaysInMonth(EncodeDate(year,month, 1)) -1;
  end
  else if day = $FE then//Last day of the month.
  begin
    day := DaysInMonth(EncodeDate(year,month, 1));
  end
  else if ((day < 1) or (day > 31)) then
    day := 1;

  if (hour < 0) or (hour > 24) then
  begin
    hour := 0;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkHour));
  end;
  if (minute < 0) or (minute > 60) then
  begin
    minute := 0;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkMinute));
  end;
  if (second < 0) or (second > 60) then
  begin
    second := 0;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkSecond));
  end;
  //If ms is Zero it's skipped.
  if (millisecond < 1) or (millisecond > 60) then
  begin
    millisecond := 0;
    FSkip := TDateTimeSkips(Integer(FSkip) + Integer(TDateTimeSkips.dkMs));
  end;
  Self.Value := EncodeDateTime(year, month, day, hour, minute, second, millisecond);
end;

function TGXDateTime.ToString: string;
var
  format: TList<string>;
  formatSettings : TFormatSettings;
  tmp : Integer;
begin
{$IFDEF MSWINDOWS}
  if (Self.Skip <> TDateTimeSkips.dkNone) then
  begin
    tmp := Integer(FSkip);
    formatSettings := TFormatSettings.Create();
    format := TList<string>.Create();
    format.AddRange(formatSettings.ShortDateFormat.Split(['/']));

    if (tmp and Integer(TDateTimeSkips.dkYear)) <> 0 then
      format.Remove('yyyy');
    if (tmp and Integer(TDateTimeSkips.dkMonth)) <> 0 then
      format.Remove('M');
    if (tmp and Integer(TDateTimeSkips.dkDay)) <> 0 then
      format.Remove('d');

    if format.Count = 0 then
      Result := ''
    else
    begin
      formatSettings.ShortDateFormat := string.Join(formatSettings.DateSeparator, format.ToArray());
      formatSettings.ShortDateFormat := formatSettings.ShortDateFormat;

      format.Clear;
      format.AddRange(formatSettings.LongTimeFormat.Split([':']));
      if (tmp and Integer(TDateTimeSkips.dkHour)) <> 0 then
        format.Remove('H');
      if (tmp and Integer(TDateTimeSkips.dkMinute)) <> 0 then
        format.Remove('mm');
      if (tmp and Integer(TDateTimeSkips.dkSecond)) <> 0 then
        format.Remove('ss');

      formatSettings.LongTimeFormat := string.Join(formatSettings.TimeSeparator, format.ToArray());
      formatSettings.ShortTimeFormat := formatSettings.LongTimeFormat;

      Result := DateTimeToStr(FValue, formatSettings);
    end;
    FreeAndNil(format);
  end
  else
    Result := DateTimeToStr(FValue);
{$ELSE}
  Result := DateTimeToStr(FValue);
{$ENDIF}
end;
end.

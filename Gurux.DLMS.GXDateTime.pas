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
    FDoW: Byte;
    FSkip : TDateTimeSkipsSet;
    FDaylightSavingsBegin, FDaylightSavingsEnd : Boolean;
    FStatus : TClockStatus;
    FTimeZone : Integer;
    function GetLocalTime : TDateTime;
  public
    //Minimum date time value.
    class function MinDateTime : TDateTime; static;

    constructor Create(AValue: TDateTime = -1); overload;
    constructor Create(year: Integer; month: Integer; day: Integer; hour: Integer; minute: Integer; second: Integer; millisecond: Integer; dow: Integer); overload;

    //Convert meter time to local time.
    property LocalTime: TDateTime read GetLocalTime;
    //Get meter time.
    property Time: TDateTime read FValue write FValue;
    property Skip: TDateTimeSkipsSet read FSkip write FSkip;

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

uses
  WinAPI.Windows;

function TGXDateTime.GetLocalTime : TDateTime;
var
  TZ: TTimeZoneInformation;
  UTC_TIME: TDateTime;
begin
  GetTimeZoneInformation(TZ);
  UTC_TIME := IncMinute(FValue, FTimeZone);
  Result := TTimeZone.Local.ToLocalTime(UTC_TIME);
end;

class function TGXDateTime.MinDateTime : TDateTime;
begin
  Result := EncodeDate(1900, 01, 01); //01 Jan 1900 has a days value of 2.
end;

constructor TGXDateTime.Create(AValue: TDateTime = -1);
var
  TZ: TTimeZoneInformation;
begin
  inherited Create;
  FStatus := TClockStatus.ctNone;
  FSkip.SetOnly(TDateTimeSkips.dkNone);

  if AValue < 0 then
    AValue := Now;

  GetTimeZoneInformation(TZ);
  if TTimeZone.Local.IsDaylightTime(AValue) then
    begin
      FStatus := TClockStatus.ctDaylightSavingActive;
      FTimeZone := (TZ.Bias + TZ.DaylightBias);
    end
  else
    begin
      FStatus := TClockStatus.ctNone;
      FTimeZone := (TZ.Bias);
    end;
  FValue := AValue;
end;

constructor TGXDateTime.Create(year: Integer; month: Integer; day: Integer; hour: Integer; minute: Integer; second: Integer; millisecond: Integer; dow: Integer);
begin
  Create;
  case year of
    0..65534: ;
    $FFFF:
    begin
      year := 1900;
      FSkip.Add(TDateTimeSkips.dkYear);
    end;
    else
      raise Exception.CreateFmt('Illegal year used for date. %d-%d-%d is not a valid date.',[Year,Month,Day]);
  end;

  FDaylightSavingsBegin := month = $FE;
  FDaylightSavingsEnd := month = $FD;

  case month of
    1..12: ;
    $FD: month := 1;
    $FE: month := 1;
    $FF:
    begin
      month := 1;
      FSkip.Add(TDateTimeSkips.dkMonth);
    end;
    else
      raise Exception.CreateFmt('Illegal month used for date. %d-%d-%d is not a valid date.',[Year,Month,Day]);
  end;

  case day of
    1..31: ;
    $FD: day := DaysInMonth(EncodeDate(year, month, 1)) - 1;
    $FE: day := DaysInMonth(EncodeDate(year, month, 1));
    $FF:
    begin
      day := 1;
      FSkip.Add(TDateTimeSkips.dkDay);
    end;
    else
      raise Exception.CreateFmt('Illegal day used for date. %d-%d-%d is not a valid date.',[Year,Month,Day]);
  end;

  case hour of
    0..23: ;
    $FF:
    begin
      hour := 0;
      FSkip.Add(TDateTimeSkips.dkHour);
    end;
    else
      raise Exception.CreateFmt('Illegal hour used. %d is not a valid hour.',[Hour]);
  end;

  case minute of
    0..59: ;
    $FF:
    begin
      minute := 0;
      FSkip.Add(TDateTimeSkips.dkMinute);
    end;
    else
      raise Exception.CreateFmt('Illegal minute used. %d is not a valid minute.',[Minute]);
  end;

  case second of
    0..59: ;
    $FF:
    begin
      second := 0;
      FSkip.Add(TDateTimeSkips.dkSecond);
    end;
    else
      raise Exception.CreateFmt('Illegal second used. %d is not a valid second.',[Second]);
  end;

  case millisecond of
    0..99: ;
    $FF:
    begin
      millisecond := 0;
      FSkip.Add(TDateTimeSkips.dkMs);
    end;
    else
      raise Exception.CreateFmt('Illegal hundreths used. %d is not a valid hundreths value.',[millisecond*10]);
  end;

  case dow of
    1 .. 7: FDoW := dow; // valid
    $FF:
    begin
      FDoW := dow;
      FSkip.Add(TDateTimeSkips.dkDayOfWeek);
    end;
    else
      raise Exception.CreateFmt('Illegal day of week used. %d is not a valid date.',[DoW]);
  end;

  FValue := EncodeDateTime(year, month, day, hour, minute, second, millisecond);

  if (dow <> DayOfTheWeek(FValue)) and (dow <> $FF) then
    if not FSkip.Contains(TDateTimeSkips.dkYear) then
      raise Exception.CreateFmt('Illegal day of week used. %s is not the %d-th day of the week.',[self.toString, dow]);
end;

function TGXDateTime.ToString: string;
var
  format: TList<string>;
  formatSettings : TFormatSettings;
begin
{$IFDEF MSWINDOWS}
  if FSkip.IsEmpty then
  begin
    formatSettings := TFormatSettings.Create();
    format := TList<string>.Create();
    try
      format.AddRange(formatSettings.ShortDateFormat.Split(['/']));

      if FSkip.Contains(TDateTimeSkips.dkYear) then
        format.Remove('yyyy');
      if FSkip.Contains(TDateTimeSkips.dkMonth) then
        format.Remove('M');
      if FSkip.Contains(TDateTimeSkips.dkDay) then
        format.Remove('d');

      if format.Count = 0 then
        Result := ''
      else
      begin
        formatSettings.ShortDateFormat := string.Join(formatSettings.DateSeparator, format.ToArray());
        formatSettings.ShortDateFormat := formatSettings.ShortDateFormat;

        format.Clear;
        format.AddRange(formatSettings.LongTimeFormat.Split([':']));
        if FSkip.Contains(TDateTimeSkips.dkHour) then
          format.Remove('H');
        if FSkip.Contains(TDateTimeSkips.dkMinute) then
          format.Remove('mm');
        if FSkip.Contains(TDateTimeSkips.dkSecond) then
          format.Remove('ss');

        formatSettings.LongTimeFormat := string.Join(formatSettings.TimeSeparator, format.ToArray());
        formatSettings.ShortTimeFormat := formatSettings.LongTimeFormat;

      Result := DateTimeToStr(LocalTime, formatSettings);
      end;

    finally
      FreeAndNil(format);
    end;

  end
  else
    Result := DateTimeToStr(LocalTime);
{$ELSE}
  Result := DateTimeToStr(LocalTime);
{$ENDIF}
end;

end.

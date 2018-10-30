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

unit Gurux.DLMS.DateTimeSkips;

interface

type
  TDateTimeSkips = (dkNone = 0, dkYear = 1, dkMonth = 2, dkDay = 4, dkDayOfWeek = 8, dkHour = 16,
      dkMinute = 32, dkSecond = 64, dkMs = 128,
      // Deviation is skipped on write.
      dkDeviation = $100,
      // Status is skipped on write.
      dkStatus = $200
      );

  TDateTimeSkipsSet = record
    strict private
      FSkips: Integer;

    private
      property AsInteger: Integer read FSkips;

    public
      procedure SetOnly(ASkip: TDateTimeSkips); overload;
      procedure SetOnly(ASkip: TDateTimeSkipsSet); overload;
      procedure Add(ASkip: TDateTimeSkips); overload;
      function Contains(ASkip: TDateTimeSkips): Boolean;
      function IsEmpty: Boolean;
    end;

implementation

{ TDateTimeSkipsSet }

procedure TDateTimeSkipsSet.Add(ASkip: TDateTimeSkips);
begin
  FSkips := FSkips or Ord(ASkip);
end;

function TDateTimeSkipsSet.Contains(ASkip: TDateTimeSkips): Boolean;
begin
  Result := (FSkips and Ord(ASkip)) > 0;
end;

function TDateTimeSkipsSet.IsEmpty: Boolean;
begin
  Result := (FSkips = 0);
end;

procedure TDateTimeSkipsSet.SetOnly(ASkip: TDateTimeSkipsSet);
begin
  FSkips := ASkip.AsInteger;
end;

procedure TDateTimeSkipsSet.SetOnly(ASkip: TDateTimeSkips);
begin
  FSkips := Ord(ASkip);
end;

end.

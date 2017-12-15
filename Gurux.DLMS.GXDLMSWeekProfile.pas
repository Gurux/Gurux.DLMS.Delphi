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

unit Gurux.DLMS.GXDLMSWeekProfile;

interface

type

TGXDLMSWeekProfile = class

constructor Create; overload;
  private
    FName: string;
    FMonday: Integer;
    FTuesday: Integer;
    FWednesday: Integer;
    FThursday: Integer;
    FFriday: Integer;
    FSaturday: Integer;
    FSunday: Integer;

    public

    constructor Create(name: string; monday: Integer; tuesday: Integer; wednesday: Integer;
      thursday: Integer; friday: Integer; saturday: Integer; sunday: Integer); overload;
    property Name: string read FName write FName;
    property Monday: Integer read FMonday write FMonday;
    property Tuesday: Integer read FTuesday write FTuesday;
    property Wednesday: Integer read FWednesday write FWednesday;
    property Thursday: Integer read FThursday write FThursday;
    property Friday: Integer read FFriday write FFriday;
    property Saturday: Integer read FSaturday write FSaturday;
    property Sunday: Integer read FSunday write FSunday;
    function ToString: string; override;

end;

implementation

constructor tGXDLMSWeekProfile.Create;
begin
  inherited Create;
end;

constructor TGXDLMSWeekProfile.Create(name: string; monday: Integer; tuesday: Integer;
  wednesday: Integer; thursday: Integer; friday: Integer; saturday: Integer;
  sunday: Integer);
begin
  inherited Create;
  Self.Name := name;
  Self.Monday := monday;
  Self.Tuesday := tuesday;
  Self.Wednesday := wednesday;
  Self.Thursday := thursday;
  Self.Friday := friday;
  Self.Saturday := saturday;
  Self.Sunday := sunday;
end;

function tGXDLMSWeekProfile.ToString: string;
begin
  Result := Self.Name;
end;
end.

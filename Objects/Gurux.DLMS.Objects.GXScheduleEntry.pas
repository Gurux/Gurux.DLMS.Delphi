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

unit Gurux.DLMS.Objects.GXScheduleEntry;

interface
uses Gurux.DLMS.GXTime,
Gurux.DLMS.GXDate,
Gurux.DLMS.Objects.Enums.Weekdays;

type
  //Executed script.
  TGXScheduleEntry = class
  private
  FIndex: UInt16;
  FEnable: Boolean;
  FLogicalName: String;
  FScriptSelector: UInt16;
  FSwitchTime: TGXTime;
  FValidityWindow: UInt16;
  FExecWeekdays: TWeekdays;
  FExecSpecDays: String;
  FBeginDate: TGXDate;
  FEndDate: TGXDate;
  public
    //Schedule entry index.
    property Index: UInt16 read FIndex write FIndex;
    //Is Schedule entry enabled.
    property Enable: Boolean read FEnable write FEnable;
    //Logical name of the Script table object.
    property LogicalName: String read FLogicalName write FLogicalName;
    //Schedule entry index.
    property ScriptSelector: UInt16 read FScriptSelector write FScriptSelector;
    //Schedule entry index.
    property SwitchTime: TGXTime read FSwitchTime write FSwitchTime;
    //Defines a period in minutes, in which an entry shall be processed after power fail.
    property ValidityWindow: UInt16 read FValidityWindow write FValidityWindow;
    //Days of the week on which the entry is valid.
    property ExecWeekdays: TWeekdays read FExecWeekdays write FExecWeekdays;
    //Perform the link to the IC "Special days table", day_id.
    property ExecSpecDays: String read FExecSpecDays write FExecSpecDays;
    // Date starting period in which the entry is valid.
    property BeginDate: TGXDate read FBeginDate write FBeginDate;
    // Date ending period in which the entry is valid.
    property EndDate: TGXDate read FEndDate write FEndDate;
end;

implementation

end.

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

unit Gurux.DLMS.GXDLMSMonitoredValue;

interface

uses Gurux.DLMS.ObjectType, System.SysUtils;

type

TGXDLMSMonitoredValue = class
  private
  FObjectType : TObjectType;
  FLogicalName : string;
  FAttributeIndex : Integer;

  public
  property ObjectType: TObjectType read FObjectType write FObjectType;
  property LogicalName: string read FLogicalName write FLogicalName;
  property AttributeIndex: Integer read FAttributeIndex write FAttributeIndex;
  function ToString: string; override;
end;
implementation

function TGXDLMSMonitoredValue.ToString: string;
begin
  Result := Integer(FObjectType).ToString() + ' ' + FLogicalName + ' ' + IntToStr(FAttributeIndex);
end;
end.

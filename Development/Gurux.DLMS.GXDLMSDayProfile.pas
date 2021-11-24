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

unit Gurux.DLMS.GXDLMSDayProfile;

interface

uses System.Generics.Collections, Classes, SysUtils, GXCommon, Gurux.DLMS.GXDLMSDayProfileAction;

type

TGXDLMSDayProfile = class
  FDayId : Integer;
  FDaySchedules : TObjectList<TGXDLMSDayProfileAction>;

  Destructor Destroy; override;
  Constructor Create;overload;

  property DayId: Integer read FDayId write FDayId;
  property DaySchedules: TObjectList<TGXDLMSDayProfileAction> read FDaySchedules;
  function ToString: string; override;
end;

implementation

constructor TGXDLMSDayProfile.Create;
begin
  FDaySchedules := TObjectList<TGXDLMSDayProfileAction>.Create();
end;

destructor TGXDLMSDayProfile.Destroy;
begin
  inherited;
  FreeAndNil(FDaySchedules);
end;

function TGXDLMSDayProfile.ToString : String;
var
  sb : TStringBuilder;
  it : TGXDLMSDayProfileAction;
begin
  sb := TStringBuilder.Create();
  try
    sb.Append(IntToStr(DayId));
    for it in FDaySchedules do
    begin
      sb.Append(' ');
      sb.Append(it.ToString());
    end;
    Result := sb.ToString();
  finally
    sb.Free;
  end;
end;

end.

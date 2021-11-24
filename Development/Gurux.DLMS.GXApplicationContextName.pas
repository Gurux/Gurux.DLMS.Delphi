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

unit Gurux.DLMS.GXApplicationContextName;

interface

uses SysUtils, GXCommon, Gurux.DLMS.Enums.ApplicationContextName;

type

TGXApplicationContextName = class
  FLogicalName : string;
  FJointIsoCtt, FCountry, FIdentifiedOrganization : byte;
  FDlmsUA, FApplicationContext: byte;
  FContextId : TApplicationContextName;
  FCountryName : Word;

 public
  property LogicalName: string read FLogicalName write FLogicalName;

  property JointIsoCtt: byte read FJointIsoCtt write FJointIsoCtt;

  property Country: byte read FCountry write FCountry;

  property IdentifiedOrganization: byte read FIdentifiedOrganization write FIdentifiedOrganization;

  property DlmsUA: byte read FDlmsUA write FDlmsUA;

  property ApplicationContext: byte read FApplicationContext write FApplicationContext;

  property ContextId: TApplicationContextName read FContextId write FContextId;

  property CountryName: Word read FCountryName write FCountryName;
  function ToString: string; override;
end;

implementation

function TGXApplicationContextName.ToString: string;
begin
  Result := FLogicalName + ' ' + IntToStr(FJointIsoCtt) + ' ' +
      IntToStr(FCountry) + ' ' + IntToStr(FCountryName) + ' ' +
      IntToStr(FIdentifiedOrganization) + ' ' + IntToStr(FDlmsUA) + ' ' +
      IntToStr(FApplicationContext) + ' ' + IntToStr(Integer(FContextId));
end;

end.

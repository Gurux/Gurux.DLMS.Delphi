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

uses SysUtils, GXCommon;

type

TGXApplicationContextName = class
  FLogicalName : string;
  FJointIsoCttElement, FCountryElement, FIdentifiedOrganizationElement : byte;
  FDlmsUAElement, FApplicationContextElement, FContextIdElement : byte;
  FCountryNameElement : Word;

 public
  property LogicalName: string read FLogicalName write FLogicalName;

  property JointIsoCttElement: byte read FJointIsoCttElement write FJointIsoCttElement;

  property CountryElement: byte read FCountryElement write FCountryElement;

  property IdentifiedOrganizationElement: byte read FIdentifiedOrganizationElement write FIdentifiedOrganizationElement;

  property DlmsUAElement: byte read FDlmsUAElement write FDlmsUAElement;

  property ApplicationContextElement: byte read FApplicationContextElement write FApplicationContextElement;

  property ContextIdElement: byte read FContextIdElement write FContextIdElement;

  property CountryNameElement: Word read FCountryNameElement write FCountryNameElement;
  function ToString: string; override;
end;

implementation

function TGXApplicationContextName.ToString: string;
begin
  Result := FLogicalName + ' ' + IntToStr(FJointIsoCttElement) + ' ' +
      IntToStr(FCountryElement) + ' ' + IntToStr(FCountryNameElement) + ' ' +
      IntToStr(FIdentifiedOrganizationElement) + ' ' + IntToStr(FDlmsUAElement) + ' ' +
      IntToStr(FApplicationContextElement) + ' ' + IntToStr(FContextIdElement);
end;

end.

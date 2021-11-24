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

unit Gurux.DLMS.GXDLMSScriptAction;

interface

uses SysUtils, Rtti, Gurux.DLMS.GXDLMSScriptActionType, Gurux.DLMS.ObjectType,
Gurux.DLMS.DataType;

type

TGXDLMSScriptAction = class
  FType: TGXDLMSScriptActionType;
  FObjectType: TObjectType;
  FLogicalName: string;
  FIndex: Integer;
  FParameter: TValue;
  FParameterType: TDataType;

  public
    property &Type: TGXDLMSScriptActionType read FType write FType;
    property ObjectType: TObjectType read FObjectType write FObjectType;
    property LogicalName: string read FLogicalName write FLogicalName;
    property Index: Integer read FIndex write FIndex;
    property Parameter: TValue read FParameter write FParameter;

    property ParameterType: TDataType read FParameterType write FParameterType;
  end;

implementation

end.

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

unit Gurux.DLMS.GXAttribute;

interface
uses Gurux.DLMS.GXAttributeCollection, Gurux.DLMS.DataType, Gurux.DLMS.AccessMode,
Gurux.DLMS.MethodAccessMode, Gurux.DLMS.GXObisValueItemCollection;

type
TGXDLMSAttributeSettings = class
var
    FIndex: Integer;
    FName: string;
    FParent : TGXAttributeCollection;
    FType : TDataType;
    FUIType : TDataType;
    FAccess: TAccessMode;
    FMethodAccess: TMethodAccessMode;
    FStatic: Boolean;
    FValues: TGXObisValueItemCollection;
    FOrder : Integer;
    FMinimumVersion : Integer;

    constructor Create(index: Integer); overload;
    constructor Create; overload;
    property Name: string read FName write FName;
    property Index: Integer read FIndex write FIndex;
    property Parent: TGXAttributeCollection read FParent;
    property &Type: TDataType read FType write FType;
    property UIType: TDataType read FUIType write FUIType;
    property Access: TAccessMode read FAccess write FAccess;
    property MethodAccess: TMethodAccessMode read FMethodAccess write FMethodAccess;
    property IsStatic: Boolean read FStatic write FStatic;
    property Values: TGXObisValueItemCollection read FValues write FValues;
    property Order: Integer read FOrder write FOrder;
    property MinimumVersion: Integer read FMinimumVersion write FMinimumVersion;
    procedure CopyTo(target: TGXDLMSAttributeSettings);
 //   function ToString: string; override;
  end;

implementation

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

constructor TGXDLMSAttributeSettings.Create(index: Integer);
begin
  inherited Create;
  Self.Index := index;
end;

constructor TGXDLMSAttributeSettings.Create;
begin
  inherited Create;
  Self.Access := TAccessMode.ReadWrite;
  Self.Values := TGXObisValueItemCollection.Create;
  Self.UIType := TDataType.dtNone;
end;

procedure TGXDLMSAttributeSettings.CopyTo(target: TGXDLMSAttributeSettings);
begin
  target.FName := Self.Name;
  target.FIndex := Self.Index;
  target.FType := Self.&Type;
  target.FUIType := Self.UIType;
  target.FAccess := Self.Access;
  target.FStatic := Self.IsStatic;
  target.FValues := Self.Values;
  target.FOrder := Self.Order;
  target.FMinimumVersion := Self.MinimumVersion;
end;

end.

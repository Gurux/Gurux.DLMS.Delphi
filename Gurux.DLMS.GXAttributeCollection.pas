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

unit Gurux.DLMS.GXAttributeCollection;

interface

uses SysUtils, Generics.Collections, Gurux.DLMS.DataType, Gurux.DLMS.AccessMode,
Gurux.DLMS.MethodAccessMode, Gurux.DLMS.GXObisValueItemCollection;

type
TGXAttributeCollection = class;

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

    destructor Destroy; override;
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
  end;

TGXAttributeCollection = class(TObjectList<TGXDLMSAttributeSettings>)
    FParent: TObject;
    property Parent: TObject read FParent;
    constructor Create; overload;
    function Find(index: Integer): TGXDLMSAttributeSettings;

end;

implementation

constructor TGXAttributeCollection.Create();
begin
  inherited Create;
end;

constructor TGXDLMSAttributeSettings.Create(index: Integer);
begin
  inherited Create;
  FIndex := index;
  FParent := Nil;
  FName := string.Empty;
  Self.Access := TAccessMode.ReadWrite;
  FValues := TGXObisValueItemCollection.Create;
  Self.UIType := TDataType.dtNone;
  FAccess := TAccessMode.ReadWrite;
  FMethodAccess := TMethodAccessMode.Access;
  FStatic := False;
  FOrder := 0;
  FMinimumVersion := 0;
end;

constructor TGXDLMSAttributeSettings.Create;
begin
  inherited Create;
  Self.Access := TAccessMode.ReadWrite;
  FValues := TGXObisValueItemCollection.Create;
  Self.UIType := TDataType.dtNone;
  FIndex := 0;
  FParent := Nil;
  FName := string.Empty;
  FAccess := TAccessMode.ReadWrite;
  FMethodAccess := TMethodAccessMode.Access;
  FStatic := False;
  FOrder := 0;
  FMinimumVersion := 0;
end;

destructor TGXDLMSAttributeSettings.Destroy;
begin
  inherited;
  FreeAndNil(FValues);
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

function TGXAttributeCollection.Find(index: Integer): TGXDLMSAttributeSettings;
var
  it: TGXDLMSAttributeSettings;
begin
  Result := Nil;
  if (index < 1) then
    raise Exception.Create('Invalid attribute Index.');

  for it in Self do
    if it.Index = index then
      begin
        Result := it;
        Exit;
      end;
end;

end.

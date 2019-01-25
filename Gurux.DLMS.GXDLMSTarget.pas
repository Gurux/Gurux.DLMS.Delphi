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

unit Gurux.DLMS.GXDLMSTarget;

interface
uses Rtti, SysUtils, System.Generics.Collections, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime;

type
  //Used currency.
  TGXDLMSTarget = class
   private
    {
     Target COSEM object.
     }
    FTarget: TGXDLMSObject;

    {
     Attribute Index of COSEM object.
     }
    FAttributeIndex: Integer;

    {
     Data index of COSEM object. All targets don't use this.
     }
    FDataIndex: Integer;

    {
     Data value of COSEM object. All targets don't use this.
     }
    FValue: TValue;


   public
  {
     Target COSEM object.
     }
    property Target: TGXDLMSObject read FTarget write FTarget;

    {
     Attribute Index of COSEM object.
     }
    property AttributeIndex: Integer read FAttributeIndex write FAttributeIndex;

    {
     Data index of COSEM object. All targets don't use this.
     }
    property DataIndex: Integer read FDataIndex write FDataIndex;

    {
     Data value of COSEM object. All targets don't use this.
     }
    property Value: TValue read FValue write FValue;

    constructor Create; overload;

    procedure Clear;
    destructor Destroy; override;
   end;
implementation

constructor TGXDLMSTarget.Create;
begin
  Clear;
end;

procedure TGXDLMSTarget.Clear;
begin
  if (FTarget <> Nil) and (FTarget.Parent = Nil) THen
    FreeAndNil(FTarget);
  Target := Nil;
  AttributeIndex := 0;
  DataIndex := 0;
  FValue := Nil;
end;

destructor TGXDLMSTarget.Destroy;
begin
  inherited;
  Clear;
end;

end.

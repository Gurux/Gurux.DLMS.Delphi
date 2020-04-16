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

unit Gurux.DLMS.GXBitString;

interface

type
 TGXBitString = class
   private
    //Bit string value.
    FValue: string;

   public
    //Bit string value.
    property Value: string read FValue write FValue;
    function ToString: string; override;
    //Convert Bit string to Integer value.
    function AsInteger: Integer;

    // Constructor.
    constructor Create(); overload;

    // Constructor.
    // Avalue : Bit string value.
    constructor Create(Avalue : String); overload;

    // Constructor.
    // Avalue : Integer value.
    // ACount : Bit count.
    constructor Create(Avalue : Integer; ACount: Integer); overload;

 end;
implementation

constructor TGXBitString.Create();
begin

end;

constructor TGXBitString.Create(Avalue : String);
begin
  FValue := AValue;
end;

constructor TGXBitString.Create(Avalue : Integer; ACount: Integer);
var
  pos: Integer;
begin
  for pos := 0 to ACount - 1 do
    if AValue and (1 shl pos) <> 0 Then
      FValue := FValue + '1'
    else
      FValue := FValue + '0';
end;

function TGXBitString.ToString: string;
begin
  Result := FValue;
end;

function TGXBitString.AsInteger: Integer;
var
  pos: Integer;
begin
  Result := 0;
  for pos := 1 to Length(FValue) do
    if FValue[pos] = '1' then
      Result := Result or (1 shl (pos - 1));
end;

end.

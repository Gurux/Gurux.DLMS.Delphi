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

unit Gurux.DLMS.GXStandardObisCode;

interface
uses System.SysUtils;

type
  TGXStandardObisCode = class
  var
  FOBIS : TArray<string>;
  FDescription : String;
  FInterfaces : String;
  FDataType : String;
  FUIDataType : String;
  public
    constructor Create; overload;
    constructor Create(obis: TArray<string>; desc: string; interfaces: string;
      dataType: string); overload;
    property OBIS: TArray<string> read FOBIS write FOBIS;
    property Description: string read FDescription write FDescription;
    property Interfaces: string read FInterfaces write FInterfaces;
    property DataType: string read FDataType write FDataType;
    property UIDataType: string read FUIDataType write FUIDataType;
    function ToString: string; override;
  end;

implementation

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

constructor TGXStandardObisCode.Create;
begin
  inherited Create;
end;

constructor TGXStandardObisCode.Create(obis: TArray<string>; desc: string; interfaces: string;
  dataType: string);
begin
  inherited Create;
  SetLength(FOBIS, 6);
  if (obis <> nil) then
    FOBIS := Copy(obis, Low(obis), Length(obis));
  Self.Description := desc;
  Self.Interfaces := interfaces;
  Self.DataType := dataType;
end;

function TGXStandardObisCode.ToString: string;
var
pos : Integer;
begin
  Result := '';
  for pos := Low(FOBIS) to Length(FOBIS) do
  begin
    Result := Result + FOBIS[pos];
    if pos <> Low(FOBIS) then
     Result := Result + '.';
  end;
  Result := Result + Self.Description;
  //Result := ((Join('.', Self.OBIS) + ' ') + Self.Description);
end;

end.

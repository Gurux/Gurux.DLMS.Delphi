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

unit Gurux.DLMS.GXDLMSLimits;

interface

type
  TGXDLMSLimits = class
  var
  private
    FMaxInfoTX : Variant;
    FMaxInfoRX : Variant;
    FWindowSizeTX : Variant;
    FWindowSizeRX : Variant;

  public
    constructor Create;
    destructor Destroy;override;

    property MaxInfoTX : Variant read FMaxInfoTX write FMaxInfoTX;
    property MaxInfoRX : Variant read FMaxInfoRX write FMaxInfoRX;
    property WindowSizeTX : Variant read FWindowSizeTX write FWindowSizeTX;
    property WindowSizeRX : Variant read FWindowSizeRX write FWindowSizeRX;
  end;

implementation

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

constructor TGXDLMSLimits.Create;
begin
  inherited Create;
  FMaxInfoTX := Variant(Byte(128));
  FMaxInfoRX := FMaxInfoTX;
  FWindowSizeTX := Variant(Byte(1));
  FWindowSizeRX := FWindowSizeTX;
end;

destructor TGXDLMSLimits.Destroy;
begin
  inherited;
  VarClear(FMaxInfoTX);
  VarClear(FMaxInfoRX);
  VarClear(FWindowSizeTX);
  VarClear(FWindowSizeRX);
end;

end.

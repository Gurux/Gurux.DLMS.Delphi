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

unit Gurux.DLMS.GXHdlcSettings;

interface

type
  TGXHdlcSettings = class
  var
  private
    FMaxInfoTX : UInt16;
    FMaxInfoRX : UInt16;
    FWindowSizeTX : BYTE;
    FWindowSizeRX : BYTE;

  public
    constructor Create;
    property MaxInfoTX : UInt16 read FMaxInfoTX write FMaxInfoTX;
    property MaxInfoRX : UInt16 read FMaxInfoRX write FMaxInfoRX;
    property WindowSizeTX : BYTE read FWindowSizeTX write FWindowSizeTX;
    property WindowSizeRX : BYTE read FWindowSizeRX write FWindowSizeRX;
  end;

implementation

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

constructor TGXHdlcSettings.Create;
begin
  inherited Create;
  FMaxInfoTX := 128;
  FMaxInfoRX := 128;
  FWindowSizeTX := 1;
  FWindowSizeRX := 1;
end;

end.

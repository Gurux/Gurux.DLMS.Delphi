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

unit GXFCS16;

interface
uses SysUtils;

const
  FCS16Table : array [0..255] of Word = ($0000, $1189, $2312, $329B, $4624, $57AD, $6536, $74BF,
            $8C48, $9DC1, $AF5A, $BED3, $CA6C, $DBE5, $E97E, $F8F7,
            $1081, $0108, $3393, $221A, $56A5, $472C, $75B7, $643E,
            $9CC9, $8D40, $BFDB, $AE52, $DAED, $CB64, $F9FF, $E876,
            $2102, $308B, $0210, $1399, $6726, $76AF, $4434, $55BD,
            $AD4A, $BCC3, $8E58, $9FD1, $EB6E, $FAE7, $C87C, $D9F5,
            $3183, $200A, $1291, $0318, $77A7, $662E, $54B5, $453C,
            $BDCB, $AC42, $9ED9, $8F50, $FBEF, $EA66, $D8FD, $C974,
            $4204, $538D, $6116, $709F, $0420, $15A9, $2732, $36BB,
            $CE4C, $DFC5, $ED5E, $FCD7, $8868, $99E1, $AB7A, $BAF3,
            $5285, $430C, $7197, $601E, $14A1, $0528, $37B3, $263A,
            $DECD, $CF44, $FDDF, $EC56, $98E9, $8960, $BBFB, $AA72,
            $6306, $728F, $4014, $519D, $2522, $34AB, $0630, $17B9,
            $EF4E, $FEC7, $CC5C, $DDD5, $A96A, $B8E3, $8A78, $9BF1,
            $7387, $620E, $5095, $411C, $35A3, $242A, $16B1, $0738,
            $FFCF, $EE46, $DCDD, $CD54, $B9EB, $A862, $9AF9, $8B70,
            $8408, $9581, $A71A, $B693, $C22C, $D3A5, $E13E, $F0B7,
            $0840, $19C9, $2B52, $3ADB, $4E64, $5FED, $6D76, $7CFF,
            $9489, $8500, $B79B, $A612, $D2AD, $C324, $F1BF, $E036,
            $18C1, $0948, $3BD3, $2A5A, $5EE5, $4F6C, $7DF7, $6C7E,
            $A50A, $B483, $8618, $9791, $E32E, $F2A7, $C03C, $D1B5,
            $2942, $38CB, $0A50, $1BD9, $6F66, $7EEF, $4C74, $5DFD,
            $B58B, $A402, $9699, $8710, $F3AF, $E226, $D0BD, $C134,
            $39C3, $284A, $1AD1, $0B58, $7FE7, $6E6E, $5CF5, $4D7C,
            $C60C, $D785, $E51E, $F497, $8028, $91A1, $A33A, $B2B3,
            $4A44, $5BCD, $6956, $78DF, $0C60, $1DE9, $2F72, $3EFB,
            $D68D, $C704, $F59F, $E416, $90A9, $8120, $B3BB, $A232,
            $5AC5, $4B4C, $79D7, $685E, $1CE1, $0D68, $3FF3, $2E7A,
            $E70E, $F687, $C41C, $D595, $A12A, $B0A3, $8238, $93B1,
            $6B46, $7ACF, $4854, $59DD, $2D62, $3CEB, $0E70, $1FF9,
            $F78F, $E606, $D49D, $C514, $B1AB, $A022, $92B9, $8330,
            $7BC7, $6A4E, $58D5, $495C, $3DE3, $2C6A, $1EF1, $0F78
    );

type

TGXFCS16 = class

    public
    class function CountFCS16(buff: TBytes; index: Integer; count: Integer): Word; static;

end;

implementation
class function TGXFCS16.CountFCS16(buff: TBytes; index: Integer; count: Integer): Word;
var
  pos: Integer;
  FCS16: Integer;
begin
  FCS16 := $FFFF;
  pos := index;
  while (pos < (index + count)) do
  begin
    FCS16 := (((FCS16 Shr 8) xor FCS16Table[(FCS16 xor buff[pos]) and $FF]) and $FFFF);
    pos := pos + 1;
  end;
  FCS16 := not FCS16;
  FCS16 := (FCS16 Shr 8 and $FF) or (FCS16 Shl 8);
  Result := FCS16;
end;
end.

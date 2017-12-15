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

unit Gurux.GXMD5;

interface
uses GXByteBuffer, SysUtils, Math;

const
  S11 = 7;
  S12 = 12;
  S13 = 17;
  S14 = 22;
  S21 = 5;
  S22 = 9;
  S23 = 14;
  S24 = 20;
  S31 = 4;
  S32 = 11;
  S33 = 16;
  S34 = 23;
  S41 = 6;
  S42 = 10;
  S43 = 15;
  S44 = 21;

  padding: array[0..63] of BYTE = (
      $80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  );

type
TGXMD5 = class
  class function F(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
  class function G(x: Cardinal; y: Cardinal; z: Cardinal) : Cardinal;
  class function H(x: Cardinal; y: Cardinal; z: Cardinal) : Cardinal;
  class function I(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
  class function RotateLeft(x: Cardinal; n: Cardinal): Cardinal;
  class procedure FF(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
  class procedure GG(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
  class procedure HH(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
  class procedure II(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
  class procedure Decode(output: PCardinal; input: PByte; len: WORD);
  class procedure Encode(output: PBYTE; input: Array of Cardinal; len: WORD);
  class procedure Transform(block: PByte; state: PCardinal);
  class procedure Update(data: TBytes; len: WORD; buffer: TBytes; count: PCardinal; state: PCardinal);

  public
   class function Encrypt(data: TBytes): TBytes;

end;
implementation

class function TGXMD5.F(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
begin
  Result := (x and y) or ((not x) and z);
end;

class function TGXMD5.G(x: Cardinal; y: Cardinal; z: Cardinal) : Cardinal;
begin
  Result := (x and z) or (y and (not z));
end;

class function TGXMD5.H(x: Cardinal; y: Cardinal; z: Cardinal) : Cardinal;
begin
  Result := x Xor y Xor z;
end;

class function TGXMD5.I(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
begin
  Result := y Xor (x or (not z));
end;

class function TGXMD5.RotateLeft(x: Cardinal; n: Cardinal): Cardinal;
begin
  Result := (x shl n) or (x shr (32 - n));
end;

class procedure TGXMD5.FF(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
var
  value: Cardinal;
begin
  value := F(b, c, d);
  a^ := Cardinal(RotateLeft(a^ + value + x + ac, s) + b);
end;

class procedure TGXMD5.GG(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
var
  value: Cardinal;
begin
  value := G(b, c, d);
  a^ := Cardinal(RotateLeft(a^ + value + x + ac, s) + b);
end;

class procedure TGXMD5.HH(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
begin
  a^ := Cardinal(RotateLeft(a^ + H(b, c, d) + x + ac, s) + b);
end;

class procedure TGXMD5.II(a: PCardinal; b: Cardinal; c: Cardinal; d: Cardinal; x: Cardinal; s: Cardinal; ac: Cardinal);
var
  value: Cardinal;
begin
  value := I(b, c, d);
  a^ := Cardinal(RotateLeft(a^ + value + x + ac, s) + b);
end;

class procedure TGXMD5.Decode(output: PCardinal; input: PByte; len: WORD);
var
  j: WORD;
begin
  j := 0;
  while j < len do
  begin
    output^ := Cardinal(input[j]) or Cardinal((input[j + 1]) shl 8) or
            Cardinal((input[j + 2]) shl 16) or Cardinal((input[j + 3]) shl 24);
    j := j + 4;
    Inc(output);
  end;
end;

class procedure TGXMD5.Encode(output: PBYTE; input: Array of Cardinal; len: WORD);
var
  i, pos: WORD;
begin
  pos := 0;
  for i := 0 to len - 1 do
  begin
    output[pos] := BYTE(input[i]);
    pos := pos + 1;
    output[pos] := (input[i] shr 8) and $ff;
    pos := pos + 1;
    output[pos] := (input[i] shr 16) and $ff;
    pos := pos + 1;
    output[pos] := (input[i] shr 24) and $ff;
    pos := pos + 1;
  end;
end;

class procedure TGXMD5.Transform(block: PByte; state: PCardinal);
var
  a, b, c, d: Cardinal;
  x : array [0..15] of Cardinal;
  p: PCardinal;
begin
  p := state;
  a := p^;
  Inc(p);
  b := p^;
  Inc(p);
  c := p^;
  Inc(p);
  d := p^;
  Decode(@x[0], block, 64);

  //Round 1.
  FF(@a, b, c, d, x[0], S11, $d76aa478);
  FF(@d, a, b, c, x[1], S12, $e8c7b756);
  FF(@c, d, a, b, x[2], S13, $242070db);
  FF(@b, c, d, a, x[3], S14, $c1bdceee);
  FF(@a, b, c, d, x[4], S11, $f57c0faf);
  FF(@d, a, b, c, x[5], S12, $4787c62a);
  FF(@c, d, a, b, x[6], S13, $a8304613);
  FF(@b, c, d, a, x[7], S14, $fd469501);
  FF(@a, b, c, d, x[8], S11, $698098d8);
  FF(@d, a, b, c, x[9], S12, $8b44f7af);
  FF(@c, d, a, b, x[10], S13, $ffff5bb1);
  FF(@b, c, d, a, x[11], S14, $895cd7be);
  FF(@a, b, c, d, x[12], S11, $6b901122);
  FF(@d, a, b, c, x[13], S12, $fd987193);
  FF(@c, d, a, b, x[14], S13, $a679438e);
  FF(@b, c, d, a, x[15], S14, $49b40821);

  // Round 2.
  GG(@a, b, c, d, x[1], S21, $f61e2562);
  GG(@d, a, b, c, x[6], S22, $c040b340);
  GG(@c, d, a, b, x[11], S23, $265e5a51);
  GG(@b, c, d, a, x[0], S24, $e9b6c7aa);
  GG(@a, b, c, d, x[5], S21, $d62f105d);
  GG(@d, a, b, c, x[10], S22, $2441453);
  GG(@c, d, a, b, x[15], S23, $d8a1e681);
  GG(@b, c, d, a, x[4], S24, $e7d3fbc8);
  GG(@a, b, c, d, x[9], S21, $21e1cde6);
  GG(@d, a, b, c, x[14], S22, $c33707d6);
  GG(@c, d, a, b, x[3], S23, $f4d50d87);
  GG(@b, c, d, a, x[8], S24, $455a14ed);
  GG(@a, b, c, d, x[13], S21, $a9e3e905);
  GG(@d, a, b, c, x[2], S22, $fcefa3f8);
  GG(@c, d, a, b, x[7], S23, $676f02d9);
  GG(@b, c, d, a, x[12], S24, $8d2a4c8a);

  //Round 3.
  HH(@a, b, c, d, x[5], S31, $fffa3942);
  HH(@d, a, b, c, x[8], S32, $8771f681);
  HH(@c, d, a, b, x[11], S33, $6d9d6122);
  HH(@b, c, d, a, x[14], S34, $fde5380c);
  HH(@a, b, c, d, x[1], S31, $a4beea44);
  HH(@d, a, b, c, x[4], S32, $4bdecfa9);
  HH(@c, d, a, b, x[7], S33, $f6bb4b60);
  HH(@b, c, d, a, x[10], S34, $bebfbc70);
  HH(@a, b, c, d, x[13], S31, $289b7ec6);
  HH(@d, a, b, c, x[0], S32, $eaa127fa);
  HH(@c, d, a, b, x[3], S33, $d4ef3085);
  HH(@b, c, d, a, x[6], S34, $4881d05);
  HH(@a, b, c, d, x[9], S31, $d9d4d039);
  HH(@d, a, b, c, x[12], S32, $e6db99e5);
  HH(@c, d, a, b, x[15], S33, $1fa27cf8);
  HH(@b, c, d, a, x[2], S34, $c4ac5665);

  // Round 4.
  II(@a, b, c, d, x[0], S41, $f4292244);
  II(@d, a, b, c, x[7], S42, $432aff97);
  II(@c, d, a, b, x[14], S43, $ab9423a7);
  II(@b, c, d, a, x[5], S44, $fc93a039);
  II(@a, b, c, d, x[12], S41, $655b59c3);
  II(@d, a, b, c, x[3], S42, $8f0ccc92);
  II(@c, d, a, b, x[10], S43, $ffeff47d);
  II(@b, c, d, a, x[1], S44, $85845dd1);
  II(@a, b, c, d, x[8], S41, $6fa87e4f);
  II(@d, a, b, c, x[15], S42, $fe2ce6e0);
  II(@c, d, a, b, x[6], S43, $a3014314);
  II(@b, c, d, a, x[13], S44, $4e0811a1);
  II(@a, b, c, d, x[4], S41, $f7537e82);
  II(@d, a, b, c, x[11], S42, $bd3af235);
  II(@c, d, a, b, x[2], S43, $2ad7d2bb);
  II(@b, c, d, a, x[9], S44, $eb86d391);

  p := state;
  p^ := p^ + a;
  Inc(p);
  p^ := p^ + b;
  Inc(p);
  p^ := p^ + c;
  Inc(p);
  p^ := p^ + d;
end;

class procedure TGXMD5.Update(data: TBytes; len: WORD; buffer: TBytes; count: PCardinal; state: PCardinal);
var
  i: WORD;
  index: Integer;
begin
  // Number of bytes.
  index := Floor(count^ / 8) Mod 64;

  // Update number of bits
  count^ := count^ + (len shl 3);
  i := count^;
  Inc(count);
  if i < (len shl 3) Then
    count^ := count^ + 1;

  count^ := count^ + (len shr 29);

  // number of bytes we need to fill in buffer
  i := 64 - index;
  // transform as many times as possible.
  if len >= i Then
  begin
    System.Move(data[0], buffer[index], i);
    Transform(@buffer[0], state);

    // Transform block
    while i <= len - 64 do
    begin
      Transform(@data[i], state);
      i := i + 64;
    end;
    index := 0;
  end
  else
    i := 0;

  System.Move(data[i], buffer[index], len - i);
end;

class function TGXMD5.Encrypt(data: TBytes): TBytes;
var
  buffer: TBytes;
  count: array[0..1] of Cardinal;
  state: array[0..3] of Cardinal;
  bits, tmp: TBytes;
  index, padLen: Cardinal;
begin
  if (data = Nil) or (Length(data) = 0) Then
     raise EArgumentException.Create('data');

  SetLength(buffer, 64);
  SetLength(bits, 8);
  count[0] := 0;
  count[1] := 0;
  // Digest
  state[0] := $67452301;
  state[1] := $efcdab89;
  state[2] := $98badcfe;
  state[3] := $10325476;
  Update(data, Length(data), buffer, @count[0], @state[0]);

  // Save number of bits
  Encode(@bits[0], count, 2);

  // Pad out to 56 mod 64.
  index := Floor(count[0] / 8) Mod 64;
  if index < 56 Then
    padLen := (56 - index)
  else
    padLen := (120 - index);

  tmp := TBytes.Create();
  SetLength(tmp, padLen);
  Move(padding[0], tmp[0], padLen);
  Update(tmp, padLen, buffer, @count[0], @state[0]);

  Update(bits, 8, buffer, @count[0], @state[0]);

  // Store state in digest
  SetLength(Result, 16);
  Encode(@Result[0], state, 4);
end;
end.

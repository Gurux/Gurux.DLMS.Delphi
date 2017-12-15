unit Gurux.GXSha1;

interface

uses GXByteBuffer, SysUtils, Math;

type
TGXSHA1 = class
  class function ROL(value: Cardinal; bits: Cardinal): Cardinal;
  class function BLK(block: PCardinal; i: Cardinal): Cardinal;
  class procedure R0(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
  class procedure R1(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
  class procedure R2(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
  class procedure R3(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
  class procedure R4(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
  // Hash block is a single 512-bit block.
  class procedure Transform(block: PCardinal; digest: PCardinal; transforms: PCardinal);
  class procedure Update(data: TGXByteBuffer; digest: PCardinal; transforms: PCardinal);
  class function final(data: TGXByteBuffer; digest: PCardinal; transforms: PCardinal): TBytes;

public
  class function Encrypt(data: TGXByteBuffer): TBytes;
end;

implementation

class function TGXSHA1.ROL(value: Cardinal; bits: Cardinal): Cardinal;
begin
  Result:= (((value) shl (bits)) or (((value) and  $ffffffff) shr (32 - (bits))))
end;

class function TGXSHA1.BLK(block: PCardinal; i: Cardinal): Cardinal;
var p1, p2, p3, p4: PCardinal;
begin
  p1 := PCardinal(Cardinal(block) + ((i and 15) * SizeOf(Cardinal)));
  p2 := PCardinal(Cardinal(block) + (((i + 13) and 15)* SizeOf(Cardinal)));
  p3 := PCardinal(Cardinal(block) + (((i+2) and 15)* SizeOf(Cardinal)));
  p4 := PCardinal(Cardinal(block) + (((i+8) and 15)* SizeOf(Cardinal)));
  p1^ := ROL((p2^ xor p4^ xor p3^ xor p1^), 1);
  Result:= p1^;
end;

class procedure TGXSHA1.R0(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
var p1: PCardinal;
begin
  p1 := PCardinal(Cardinal(block) + (i * SizeOf(Cardinal)));
  z^ := z^ + ((w^ and (x xor y)) xor y) + p1^ + $5a827999 + ROL(v, 5);
  w^ := ROL(w^, 30);
end;

class procedure TGXSHA1.R1(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
begin
 z^ := z^ + ((w^ and (x xor y)) xor y) + BLK(block, i) + $5a827999 + ROL(v, 5);
 w^ := ROL(w^, 30);
end;

class procedure TGXSHA1.R2(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
begin
  z^ := z^ + (w^ xor x xor y) + BLK(block, i) + $6ed9eba1 + ROL(v,5);
  w^ := ROL(w^, 30);
end;

class procedure TGXSHA1.R3(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
begin
  z^ := z^ + (((w^ or x) and y) or (w^ and x)) + BLK(block, i) + $8f1bbcdc + ROL(v,5);
  w^ := ROL(w^, 30);
end;

class procedure TGXSHA1.R4(block: PCardinal; v: Cardinal; w: PCardinal; x: Cardinal;y: Cardinal; z: PCardinal; i: Cardinal);
begin
  z^ := z^ + (w^ xor x xor y) + BLK(block, i) + $ca62c1d6 + ROL(v,5);
  w^ := ROL(w^, 30);
end;

// Hash block is a single 512-bit block.
class procedure TGXSHA1.Transform(block: PCardinal; digest: PCardinal; transforms: PCardinal);
var
 a, b, c, d, e: Cardinal;
 p: PCardinal;
begin
  p:= digest;
  a := p^;
  Inc(p);
  b := p^;
  Inc(p);
  c := p^;
  Inc(p);
  d := p^;
  Inc(p);
  e := p^;

  R0(block, a, @b, c, d, @e, 0);
  R0(block, e, @a, b, c, @d, 1);
  R0(block, d, @e, a, b, @c, 2);
  R0(block, c, @d, e, a, @b, 3);
  R0(block, b, @c, d, e, @a, 4);
  R0(block, a, @b, c, d, @e, 5);
  R0(block, e, @a, b, c, @d, 6);
  R0(block, d, @e, a, b, @c, 7);
  R0(block, c, @d, e, a, @b, 8);
  R0(block, b, @c, d, e, @a, 9);
  R0(block, a, @b, c, d, @e, 10);
  R0(block, e, @a, b, c, @d, 11);
  R0(block, d, @e, a, b, @c, 12);
  R0(block, c, @d, e, a, @b, 13);
  R0(block, b, @c, d, e, @a, 14);
  R0(block, a, @b, c, d, @e, 15);
  R1(block, e, @a, b, c, @d, 16);
  R1(block, d, @e, a, b, @c, 17);
  R1(block, c, @d, e, a, @b, 18);
  R1(block, b, @c, d, e, @a, 19);
  R2(block, a, @b, c, d, @e, 20);
  R2(block, e, @a, b, c, @d, 21);
  R2(block, d, @e, a, b, @c, 22);
  R2(block, c, @d, e, a, @b, 23);
  R2(block, b, @c, d, e, @a, 24);
  R2(block, a, @b, c, d, @e, 25);
  R2(block, e, @a, b, c, @d, 26);
  R2(block, d, @e, a, b, @c, 27);
  R2(block, c, @d, e, a, @b, 28);
  R2(block, b, @c, d, e, @a, 29);
  R2(block, a, @b, c, d, @e, 30);
  R2(block, e, @a, b, c, @d, 31);
  R2(block, d, @e, a, b, @c, 32);
  R2(block, c, @d, e, a, @b, 33);
  R2(block, b, @c, d, e, @a, 34);
  R2(block, a, @b, c, d, @e, 35);
  R2(block, e, @a, b, c, @d, 36);
  R2(block, d, @e, a, b, @c, 37);
  R2(block, c, @d, e, a, @b, 38);
  R2(block, b, @c, d, e, @a, 39);
  R3(block, a, @b, c, d, @e, 40);
  R3(block, e, @a, b, c, @d, 41);
  R3(block, d, @e, a, b, @c, 42);
  R3(block, c, @d, e, a, @b, 43);
  R3(block, b, @c, d, e, @a, 44);
  R3(block, a, @b, c, d, @e, 45);
  R3(block, e, @a, b, c, @d, 46);
  R3(block, d, @e, a, b, @c, 47);
  R3(block, c, @d, e, a, @b, 48);
  R3(block, b, @c, d, e, @a, 49);
  R3(block, a, @b, c, d, @e, 50);
  R3(block, e, @a, b, c, @d, 51);
  R3(block, d, @e, a, b, @c, 52);
  R3(block, c, @d, e, a, @b, 53);
  R3(block, b, @c, d, e, @a, 54);
  R3(block, a, @b, c, d, @e, 55);
  R3(block, e, @a, b, c, @d, 56);
  R3(block, d, @e, a, b, @c, 57);
  R3(block, c, @d, e, a, @b, 58);
  R3(block, b, @c, d, e, @a, 59);
  R4(block, a, @b, c, d, @e, 60);
  R4(block, e, @a, b, c, @d, 61);
  R4(block, d, @e, a, b, @c, 62);
  R4(block, c, @d, e, a, @b, 63);
  R4(block, b, @c, d, e, @a, 64);
  R4(block, a, @b, c, d, @e, 65);
  R4(block, e, @a, b, c, @d, 66);
  R4(block, d, @e, a, b, @c, 67);
  R4(block, c, @d, e, a, @b, 68);
  R4(block, b, @c, d, e, @a, 69);
  R4(block, a, @b, c, d, @e, 70);
  R4(block, e, @a, b, c, @d, 71);
  R4(block, d, @e, a, b, @c, 72);
  R4(block, c, @d, e, a, @b, 73);
  R4(block, b, @c, d, e, @a, 74);
  R4(block, a, @b, c, d, @e, 75);
  R4(block, e, @a, b, c, @d, 76);
  R4(block, d, @e, a, b, @c, 77);
  R4(block, c, @d, e, a, @b, 78);
  R4(block, b, @c, d, e, @a, 79);

  digest^ := digest^ + a;
  Inc(digest);
  digest^ := digest^ + b;
  Inc(digest);
  digest^ := digest^ + c;
  Inc(digest);
  digest^ := digest^ + d;
  Inc(digest);
  digest^ := digest^ + e;
  transforms^ := transforms^ + 1;
end;

class procedure TGXSHA1.Update(data: TGXByteBuffer; digest: PCardinal; transforms: PCardinal);
var
  pos: WORD;
  block: array [0..15] of Cardinal;
begin
  while (data.Size - data.Position) > 64 do
  begin
    for pos := 0 to 15 do
      block[pos] := data.GetUInt32();

    Transform(@block[0], digest, transforms);
  end;
end;

class function TGXSHA1.final(data: TGXByteBuffer; digest: PCardinal; transforms: PCardinal): TBytes;
var
  pos, orig_size: WORD;
  total_bits: UInt64;
  block: array [0..15] of Cardinal;
  reply: TGXByteBuffer;
begin
  reply := TGXByteBuffer.Create(transforms^ * 64);
  reply.SetArray(data.GetData(), 0, data.Size);
  //Total number of hashed bits.
  total_bits := UInt64((transforms^ * 64 + Cardinal(data.Size)) * 8);

  //Padding
  reply.SetUInt8($80);
  orig_size := reply.Size;
  reply.Zero(reply.Size, 64 - reply.Size);
  for pos := 0to 15 do
    block[pos] := reply.GetUInt32();

  if orig_size > 64 - 8 Then
  begin
    Transform(@block[0], digest, transforms);
    for pos := 0 to 16 - 2 do
      block[pos] := 0;
  end;

  // Append total_bits, split this uint64 into two uint32.
  block[16 - 1] := total_bits;
  block[16 - 2] := (total_bits shr 32);
  Transform(@block, digest, transforms);
  reply.Capacity(20);
  reply.Position(0);
  reply.Size(0);
  for pos := 0 to 4 do
    reply.SetUInt32(PCardinal(Cardinal(digest) + (pos * SizeOf(Cardinal)))^);
  Result := reply.ToArray();
  FreeAndNil(reply);
end;

class function TGXSHA1.Encrypt(data: TGXByteBuffer): TBytes;
var
  digest: array [0..4] of Cardinal;
  transforms: Cardinal;
begin
  digest[0] := $67452301;
  digest[1] := $efcdab89;
  digest[2] := $98badcfe;
  digest[3] := $10325476;
  digest[4] := $c3d2e1f0;
  transforms := 0;
  Update(data, @digest[0], @transforms);
  Result := Final(data, @digest[0], @transforms);
end;
end.

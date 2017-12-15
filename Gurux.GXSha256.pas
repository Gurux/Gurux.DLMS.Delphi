unit Gurux.GXSha256;

interface
uses GXByteBuffer, SysUtils, Math;

const
k: array[0..63] of Cardinal = (
$428a2f98, $71374491, $b5c0fbcf, $e9b5dba5,
$3956c25b, $59f111f1, $923f82a4, $ab1c5ed5,
$d807aa98, $12835b01, $243185be, $550c7dc3,
$72be5d74, $80deb1fe, $9bdc06a7, $c19bf174,
$e49b69c1, $efbe4786, $0fc19dc6, $240ca1cc,
$2de92c6f, $4a7484aa, $5cb0a9dc, $76f988da,
$983e5152, $a831c66d, $b00327c8, $bf597fc7,
$c6e00bf3, $d5a79147, $06ca6351, $14292967,
$27b70a85, $2e1b2138, $4d2c6dfc, $53380d13,
$650a7354, $766a0abb, $81c2c92e, $92722c85,
$a2bfe8a1, $a81a664b, $c24b8b70, $c76c51a3,
$d192e819, $d6990624, $f40e3585, $106aa070,
$19a4c116, $1e376c08, $2748774c, $34b0bcb5,
$391c0cb3, $4ed8aa4a, $5b9cca4f, $682e6ff3,
$748f82ee, $78a5636f, $84c87814, $8cc70208,
$90befffa, $a4506ceb, $bef9a3f7, $c67178f2 );

type
TGXSha256 = class
  class procedure UNPACK32(x: Cardinal; str: PByte);
  class procedure PACK32(str: PByte; x: PCardinal);
  class function SHFR(x: Cardinal; n: Cardinal): Cardinal;
  class function ROTR(x: Cardinal; n: Cardinal): Cardinal;
  class function ROTL(x: Cardinal; n: Cardinal): Cardinal;
  class function CH(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
  class function MAJ(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
  class function F1(x: Cardinal): Cardinal;
  class function F2(x: Cardinal): Cardinal;
  class function F3(x: Cardinal): Cardinal;
  class function F4(x: Cardinal): Cardinal;
  class procedure Transform(h: PCardinal; block: PByte; block_nb: Integer);
  class procedure Update(h: PCardinal; block: PByte; data: TGXByteBuffer; len: PInteger; totalLen: PInteger);
  class procedure Final(h: PCardinal; block : PByte; digest: PByte; len: Integer; totalLen: Integer);
public
  class function Encrypt(data: TGXByteBuffer): TBytes;
end;

implementation

class function TGXSha256.SHFR(x: Cardinal; n: Cardinal): Cardinal;
begin
  Result := x shr n;
end;

class function TGXSha256.ROTR(x: Cardinal; n: Cardinal): Cardinal;
begin
  Result := ((x shr n) or (x shl ((Sizeof(x) shl 3) - n)));
end;

class function TGXSha256.ROTL(x: Cardinal; n: Cardinal): Cardinal;
begin
  Result := ((x shl n) or (x shr ((Sizeof(x) shl 3) - n)));
end;

class function TGXSha256.CH(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
begin
  Result := ((x and  y) xor ((Not x) and z));
end;

class function TGXSha256.MAJ(x: Cardinal; y: Cardinal; z: Cardinal): Cardinal;
begin
  Result := ((x and y) xor (x and  z) xor (y and  z));
end;

class function TGXSha256.F1(x: Cardinal): Cardinal;
begin
  Result := (ROTR(x, 2) xor ROTR(x, 13) xor ROTR(x, 22));
end;

class function TGXSha256.F2(x: Cardinal): Cardinal;
begin
  Result := (ROTR(x, 6) xor ROTR(x, 11) xor ROTR(x, 25));
end;

class function TGXSha256.F3(x: Cardinal): Cardinal;
begin
  Result := (ROTR(x, 7) xor ROTR(x, 18) xor SHFR(x, 3));
end;

class function TGXSha256.F4(x: Cardinal): Cardinal;
begin
  Result := (ROTR(x, 17) xor ROTR(x, 19) xor SHFR(x, 10));
end;

class procedure TGXSha256.UNPACK32(x: Cardinal; str: PByte);
begin
  str[3] := x;
  str[2] := (x shr 8);
  str[1] := (x shr 16);
  str[0] := (x shr 24);
end;

class procedure TGXSha256.PACK32(str: PByte; x: PCardinal);
begin
  x^ := str[3] or (str[2] shl 8) or (str[1] shl 16) or (str[0] shl 24);
end;


class procedure TGXSha256.Transform(h: PCardinal; block: PByte; block_nb: Integer);
var
  w: array [0..63] of Cardinal;
  wv: array [0..7] of Cardinal;
  t1, t2: Cardinal;
  sub_block: PByte;
  i, j: Integer;
begin
  for i := 0 to block_nb - 1 do
  begin
    sub_block := PByte(Integer(block) + (i shl 6));
    for j := 0 to 16 do
    begin
      PACK32(@sub_block[j shl 2], @w[j]);
    end;

    for j := 16 to 63 do
      w[j] := F4(w[j - 2]) + w[j - 7] + F3(w[j - 15]) + w[j - 16];

    for j := 0 to 7 do
      wv[j] := PCardinal(Integer(h) + (j * SizeOf(Cardinal)))^;

    for j := 0 to 63 do
    begin
      t1 := wv[7] + F2(wv[4]) + CH(wv[4], wv[5], wv[6])
          + k[j] + w[j];
      t2 := F1(wv[0]) + MAJ(wv[0], wv[1], wv[2]);
      wv[7] := wv[6];
      wv[6] := wv[5];
      wv[5] := wv[4];
      wv[4] := wv[3] + t1;
      wv[3] := wv[2];
      wv[2] := wv[1];
      wv[1] := wv[0];
      wv[0] := t1 + t2;
    end;
    for j := 0 to 7 do
    begin
      h^ := h^ + wv[j];
      Inc(h);
    end;
  end;
end;

class procedure TGXSha256.Update(h: PCardinal; block: PByte; data: TGXByteBuffer; len: PInteger; totalLen: PInteger);
var
  block_nb, new_len, rem_len, tmp_len: Integer;
  shifted_message: PByte;
begin
  tmp_len := 64 - (data.size - data.position);
  if data.size < tmp_len Then
    rem_len := data.size
  else
    rem_len := tmp_len;

  System.Move(data.GetData()[0], block[data.position], rem_len);
  if data.size - data.position < 64 Then
  begin
    data.position(data.size);
    Exit;
  end;
  new_len := len^ - rem_len;
  block_nb := Floor(new_len / 64);
  shifted_message := @data.GetData()[rem_len];
  Transform(h, block, 1);
  Transform(h, shifted_message, block_nb);
  rem_len := new_len Mod 64;
  System.Move(shifted_message[block_nb shl 6], block, rem_len);
  len^ := rem_len;
  totalLen^ := totalLen^ + ((block_nb + 1) shl 6);
end;

class procedure TGXSha256.Final(h: PCardinal; block : PByte; digest: PByte; len: Integer; totalLen: Integer);
var
  block_nb, pm_len, len_b: Integer;
  i: Integer;
begin
  block_nb := 1;
  if ((64 - 9) < (len Mod 64)) Then
    block_nb := 2;

  len_b := (totalLen + len) shl 3;
  pm_len := block_nb shl 6;
  for i:= 0 to pm_len - len - 1 do
    block[len + i] := 0;

  block[len] := $80;
  UNPACK32(len_b, @block[pm_len - 4]);
  Transform(h, block, block_nb);
  for i := 0 to 7 do
    UNPACK32(PCardinal(Integer(h) + (i * SizeOf(Cardinal)))^, @digest[i shl 2]);
end;

class function TGXSha256.Encrypt(data: TGXByteBuffer): TBytes;
var
  len, totalLen: Cardinal;
  h: array [0..7] of Cardinal;
  block: array [0..127] of Byte;
begin
  len := data.Size;
  totalLen := 0;
  h[0] := $6a09e667;
  h[1] := $bb67ae85;
  h[2] := $3c6ef372;
  h[3] := $a54ff53a;
  h[4] := $510e527f;
  h[5] := $9b05688c;
  h[6] := $1f83d9ab;
  h[7] := $5be0cd19;

  SetLength(Result, 32);
  Update(@h[0], @block[0], data, @len, @totalLen);
  Final(@h[0], @block[0], @Result[0], len, totalLen);
end;
end.

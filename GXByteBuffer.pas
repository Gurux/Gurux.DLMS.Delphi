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

unit GXByteBuffer;

interface
uses SysUtils, Rtti, System.Types;

const
  ARRAY_CAPACITY = 10;
  hexArray : array [0..15] of char = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
type

//Byte array class is used to save received bytes.
TGXByteBuffer = class
private
  // Byte array data.
  FData : TBytes;
  // Size of received bytes.
  FSize : Integer;
  //Position of byte array.
  FPosition : Integer;

  class function ToHexValue(Value : char) : Byte; static;

  class function SwapBuffer(value : array of Byte) : TBytes; static;

   // value : Buffer position.
  procedure SetPosition(value : Integer);

  //Result :  Buffer position.
  function GetPosition() : Integer; overload;

  //Result : Buffer size.
  function GetSize() : Integer; overload;

  // value : Buffer size.
  procedure SetSize(value : Integer); overload;

public
  // Constructor.
  constructor Create(); overload;

  // Constructor.
  // capacity : Buffer capacity.
  constructor Create(cap : Integer); overload;

  // Constructor.
  // value : Byte array to attach.
  constructor Create(value : TBytes); overload;

   // Allocate new size for the array in bytes.
  // cap : Buffer capacity.
  procedure Capacity(cap : Integer); overload;

  // Result : Buffer capacity.
  function Capacity : Integer; overload;

  // Constructor.
  // value : Byte array to attach.
  constructor Create(value : TGXByteBuffer); overload;

  destructor Destroy; override;

  class function HexToBytes(HexStr : String): TBytes; static;

  class function ToHexString(bytes : TBytes; addSpace : Boolean; Index : Integer; Count : Integer): String; overload;
  class function ToHexString(bytes : TBytes): String; overload;

  // Clear buffer but don't release memory.
  procedure Clear;

   // Buffer position.
  property Position: Integer read GetPosition write SetPosition;

  // Buffer size.
  property Size: Integer read GetSize write SetSize;

  // return Amount of non read bytes in the buffer.
  function Available() : Integer;

  //Result : Get buffer data as byte array.
  function ToArray(): TBytes;

  // Returns sub array from byte buffer.
  // index : Start index.
  // count : Byte count.
  // Result : Sub array.
  function SubArray(index : Word; count : Word): TBytes;

  // Move content from source to destination.
  // srcPos : Source position.
  // destPos : Destination position.
  // count : Item count.
  procedure Move(srcPos : Word; destPos : Word; count : Word);

  // Remove handled bytes. This can be used in debugging to remove handled bytes.
  procedure Trim();

    // Fill buffer it with zeros.
  procedure Zero(index: Integer; count: Integer);

  // Push the given byte into this buffer at the current position, and then
  // increments the position.
  // item : The byte to be added.
  procedure SetUInt8(item : Integer);overload;

  procedure SetUInt8(index : Integer; item : Integer);overload;

  procedure SetUInt16(item : Integer);overload;

  procedure SetUInt16(index : Integer; item : Integer);overload;

  procedure SetUInt32(item : Longword);overload;

  procedure SetUInt32(index : Integer; item : Longword);overload;

  procedure SetUInt64(item : UInt64);overload;

  procedure SetUInt64(index : Integer; item : UInt64);overload;

  procedure SetFloat(value : Single);overload;

  procedure SetFloat(index : Integer; value : Single);overload;

  procedure SetDouble(value : Double);overload;

  procedure SetDouble(index : Integer; value: Double);overload;

  function GetUInt8 : Byte;overload;

  function GetInt8() : ShortInt;overload;

  function GetUInt8(index : Integer) : Byte;overload;

  function GetUInt16() : Word;overload;

  function GetInt16() : Smallint ;overload;

  function GetUInt16(index : Integer) : Word; overload;

  function GetUInt32() : Longword; overload;

  function GetInt32() : Integer;overload;

  function GetInt32( index : Integer) : Integer; overload;

  function GetUInt32(index : Integer) : Longword; overload;

  function GetFloat : Single;

  function GetDouble : Double;

  function GetInt64 : Int64;

  //Result : the data.
  function GetData : TBytes;

  // value : The data to set
  procedure SetData(value : TBytes);

  function GetUInt64() : Extended;

  function GetString(count : Integer) : String; overload;

  function GetString(index : Integer; count : Integer) : String; overload;

  // Append the given byte array into this buffer.
  // value : Data to append.
  procedure SetArray(value : TBytes); overload;

  // Append the given byte array into this buffer.
  // value : Data to append.
  procedure SetArray(value : TByteDynArray); overload;

  // Append the given byte array into this buffer.
  // value : Data to append.
  procedure SetArray(value : array of Byte); overload;

  procedure AddString(value : String);


  // Push the given byte array into this buffer at the current position, and
  // then increments the position.
  // index : Byte index.
  // value : The value to be added.
  procedure SetArray(index : Integer; value : TBytes); overload;

  // Push the given byte array into this buffer at the current position, and
  // then increments the position.
  // index : Byte index.
  // value : The value to be added.
  procedure SetArray(index : Integer; value : TByteDynArray); overload;

  // Append the given byte array into this buffer.
  // index : Byte index.
  // value : Data to append.
  procedure SetArray(index : Integer; value : array of Byte); overload;

  // Set new value to byte array.
  // value : Byte array to add.
  // index : Byte index.
  // count : Byte count.
  procedure SetArray(value : TBytes; index : Integer; count : Integer); overload;

  // Set new value to byte array.
  // value : Byte array to add.
  // index : Byte index.
  // count : Byte count.
  procedure SetArray(value : TByteDynArray; index : Integer; count : Integer);overload;

  // Set new value to byte array.
  // value : Byte array to add.
  // index : Byte index.
  // count : Byte count.
  procedure SetArray(value : array of byte; index : Integer; count : Integer);overload;

  // Set new value to byte array.
  // value : Byte array to add.
  procedure SetArray(value : TGXByteBuffer); overload;

  // Set new value to byte array.
  // value : Byte array to add.
  // count : Byte count.
  procedure SetArray(value : TGXByteBuffer; count : Integer); overload;

  // Add new object to the byte buffer.
  // value : Value to add.
  procedure Add(value : TValue);

  procedure Get(target : TBytes);

  //Compares, whether two given arrays are similar starting from current position.
  // arr : Array to compare.
  // Result : True, if arrays are similar. False, if the arrays differ.
  function Compare(arr : TBytes) : Boolean; overload;

  //Compares, whether two given arrays are similar starting from current position.
  // arr : Array to compare.
  // Result : True, if arrays are similar. False, if the arrays differ.
  function Compare(arr : array of Byte) : Boolean; overload;

  // Push the given hex string as byte array into this buffer at the current
  // position, and then increments the position.
  // value : The hex string to be added.
  procedure SetHexString(value : String);overload;

  // Push the given hex string as byte array into this buffer at the current
  // position, and then increments the position.
  // index : Byte index.
  // value : The hex string to be added.
  procedure SetHexString(index : Integer; value : String);overload;

  // Push the given hex string as byte array into this buffer at the current
  // position, and then increments the position.
  // value : Byte array to add.
  // index : Byte index.
  // count : Byte count.
  procedure SetHexString(value : String; index : Integer; count : Integer);overload;

  function ToString: string; override;

  //Get remaining data.
  // Result : Remaining data as byte array.
  function Remaining() : TBytes;

  // Get remaining data as a hex string.
  // addSpace : Add space between bytes.
  // Result : Remaining data as a hex string.
  function RemainingHexString(addSpace : Boolean) : String;

  // Get data as hex string.
  // addSpace : Add space between bytes.
  // index : Byte index.
  // count : Byte count.
  // Result : Data as hex string.
  function ToHex(addSpace : Boolean; index : Integer; count : Integer): String;overload;
end;

implementation
// Constructor.
constructor TGXByteBuffer.Create();
begin
  FData := Nil;
  FSize := 0;
  FPosition := 0;
end;

//Constructor.
// capacity : Buffer capacity.
constructor TGXByteBuffer.Create(cap : Integer);
begin
  Create;
  Capacity(cap);
end;

// Constructor.
// value : Byte array to attach.
constructor TGXByteBuffer.Create(value : TBytes);
begin
  Create;
  Capacity(Length(value));
  SetArray(value);
end;

// Constructor.
// value : Byte array to attach.
constructor TGXByteBuffer.Create(value : TGXByteBuffer);
begin
  Create;
  Capacity(value.size - value.position);
  SetArray(value);
end;

// Clear buffer but do not release memory.
procedure TGXByteBuffer.Clear;
begin
  FPosition := 0;
  FSize := 0;
end;

destructor TGXByteBuffer.Destroy();
begin
inherited;
Capacity(0);
end;

// Allocate new size for the array in bytes.
// cap : Buffer capacity.
procedure TGXByteBuffer.Capacity(cap : Integer);
begin
    if cap = 0 then
    begin
      Clear();
      setData(Nil);
    end
    else
    begin
      if FData = Nil then
        SetLength(FData, cap)
      else
      begin
        SetLength(FData, cap);
        if (size > cap) then
          SetSize(cap);
      end;
  end;
end;

// Result : Buffer capacity.
function TGXByteBuffer.Capacity : Integer;
begin
  if GetData() = Nil then
    Result := 0
  else
    Result := Length(FData);
end;

// value : Buffer position.
procedure TGXByteBuffer.SetPosition(value : Integer);
begin
  if (value < 0) or (value > Size) then
    raise EArgumentException.Create('position');

  FPosition := value;
end;

//Result :  Buffer position.
function TGXByteBuffer.GetPosition() : Integer;
begin
  Result := FPosition;
end;

//Result :  Buffer size.
function TGXByteBuffer.GetSize() : Integer;
begin
  Result := FSize;
end;

 // value : Buffer size.
procedure TGXByteBuffer.SetSize(value : Integer);
begin
  if (value < 0) or (value > capacity()) then
  begin
    raise EArgumentException.Create('size');
  end;
  FSize := value;
  if (FPosition > FSize) then
  begin
    FPosition := size;
  end;
end;

//Result :  Get buffer data as byte array.
function TGXByteBuffer.ToArray() : TBytes;
begin
    Result := SubArray(0, size);
end;

// return Amount of non read bytes in the buffer.
function TGXByteBuffer.Available() : Integer;
begin
      Result := size - position;
end;

// Returns sub array from byte buffer.
// index : Start index.
// count : Byte count.
// Result : Sub array.
function TGXByteBuffer.SubArray(index: Word; count: Word) : TBytes;
begin
  SetLength(Result, count);
  if (count <> 0) then
    System.Move(FData[index], Result[0], count);
end;

//Move content from source to destination.
// srcPos : Source position.
// destPos : Destination position.
// count : Item count.
procedure TGXByteBuffer.Move(srcPos : Word; destPos : Word; count : Word);
begin
  if count <> 0 then
  begin
    if destPos + count > Capacity Then
      Capacity(destPos + count);

    System.Move(FData[srcPos], FData[destPos], count);
    SetSize(destPos + count);
    if (FPosition > FSize) then
      Position := size;
  end;
end;

//Remove handled bytes. This can be used in debugging to remove handled bytes.
procedure TGXByteBuffer.Trim();
begin
  if size = position then
    SetSize(0)
  else
    Move(position, 0, size - position);
  SetPosition(0);
end;

procedure TGXByteBuffer.Zero(index: Integer; count: Integer);
var pos: Integer;
begin
  if index + count > Capacity Then
    Capacity(index + count);

  if Size < index + count Then
    FSize := index + count;

  for pos:= 1 to count do
    FData[index + pos] := 0;
end;

// Push the given byte into this buffer at the current position, and then
// increments the position.
// item : The byte to be added.
procedure TGXByteBuffer.SetUInt8(item : Integer);
begin
  SetUInt8(FSize, item);
  FSize := FSize + 1;
end;

procedure TGXByteBuffer.SetUInt8(index : Integer; item : Integer);
begin
  if index >= Capacity() then
    Capacity(index + ARRAY_CAPACITY);

  FData[index] := Byte(item);
end;

procedure TGXByteBuffer.SetUInt16(item : Integer);
begin
  SetUInt16(FSize, item);
  FSize := FSize + 2;
end;

procedure TGXByteBuffer.SetUInt16(index : Integer; item : Integer);
begin
  if (index + 2 >= capacity()) then
      Capacity(index + ARRAY_CAPACITY);
  FData[index] := ((item Shr 8) and $FF);
  FData[index + 1] := (item and $FF);
end;

procedure TGXByteBuffer.SetUInt32(item : Longword);
begin
  SetUInt32(FSize, item);
  FSize := FSize + 4;
end;

procedure TGXByteBuffer.SetUInt32(index : Integer; item : Longword);
begin
  if index + 4 >= capacity() then
    capacity(index + ARRAY_CAPACITY);

  FData[index] := ((item Shr 24) and $FF);
  FData[index + 1] := ((item Shr 16) and $FF);
  FData[index + 2] := ((item Shr 8) and $FF);
  FData[index + 3] := (item and $FF);
end;

procedure TGXByteBuffer.SetUInt64(item : UInt64);
begin
    SetUInt64(FSize, item);
    FSize := FSize + 8;
end;

procedure TGXByteBuffer.SetUInt64(index : Integer; item : UInt64);
begin
    if (index + 8 >= capacity()) then
        capacity(index + ARRAY_CAPACITY);

    FData[size] := ((item Shr 56) and $FF);
    FData[size + 1] := ((item Shr 48) and $FF);
    FData[size + 2] := ((item Shr 40) and $FF);
    FData[size + 3] := ((item Shr 32) and $FF);
    FData[size + 4] := ((item Shr 24) and $FF);
    FData[size + 5] := ((item Shr 16) and $FF);
    FData[size + 6] := ((item Shr 8) and $FF);
    FData[size + 7] := Byte(item and $FF);
end;

procedure TGXByteBuffer.SetFloat(value : Single);
begin
  SetFloat(FSize, value);
end;

procedure TGXByteBuffer.SetFloat(index : Integer; value : Single);
var
  tmp: array[0..3] of Byte absolute value;
begin
  SetArray(index, SwapBuffer(tmp));
end;

procedure TGXByteBuffer.SetDouble(value : Double);
begin
  setDouble(size, value);
end;

procedure TGXByteBuffer.SetDouble(index : Integer; value : Double);
var
  tmp: array[0..7] of Byte absolute value;
begin
  SetArray(index, SwapBuffer(tmp));
end;

function TGXByteBuffer.GetUInt8 : Byte;
begin
  Result := GetUInt8(FPosition);
  FPosition := FPosition + 1;
end;

function TGXByteBuffer.GetInt8() : ShortInt;
begin
  Result := ShortInt(GetUInt8());
end;

function TGXByteBuffer.GetUInt8(index : Integer) : Byte;
begin
  if (index >= size) then
    raise EArgumentException.Create('GetUInt8');

  Result := (FData[index] and $FF);
end;

function TGXByteBuffer.GetUInt16() : Word;
begin
  Result := GetUInt16(FPosition);
  FPosition := FPosition + 2;
end;

function TGXByteBuffer.GetInt16() : Smallint;
begin
  Result := Smallint(GetUInt16());
end;

function TGXByteBuffer.GetUInt16(index : Integer) : Word;
begin
  if index + 2 > size then
    raise EArgumentException.Create('getUInt16');

  Result := Word((FData[index] and $FF) Shl 8) or (FData[index + 1] and $FF);
end;

function TGXByteBuffer.GetUInt32(): Longword;
begin
  Result := GetUInt32(FPosition);
  FPosition := FPosition + 4;
end;

function TGXByteBuffer.GetInt32() : Integer;
begin
  Result := GetInt32(FPosition);
  FPosition := FPosition + 4;
end;

function TGXByteBuffer.GetInt32( index : Integer) : Integer;
begin
  if index + 4 > size then
       raise EArgumentException.Create('getUInt32');

  Result := (FData[index] and $FF) Shl 24 or (FData[index + 1] and $FF) Shl 16
          or (FData[index + 2] and $FF) Shl 8 or (FData[index + 3] and $FF);
end;

function TGXByteBuffer.GetUInt32(index : Integer) : Longword;
begin
  if index + 4 > size then
    raise EArgumentException.Create('getUInt32');

  Result := FData[index] and $FF;
  Result := Result Shl 24;
  Result := Result or (FData[index + 1] and $FF) Shl 16;
  Result := Result or (FData[index + 2] and $FF) Shl 8;
  Result := Result or (FData[index + 3] and $FF);
end;


function TGXByteBuffer.GetFloat(): Single;
var
 tmp: array[0..3] of Byte absolute Result;
begin
  tmp[0] := FData[FPosition + 3];
  tmp[1] := FData[FPosition + 2];
  tmp[2] := FData[FPosition + 1];
  tmp[3] := FData[FPosition];
  FPosition := FPosition + 4;
end;

function TGXByteBuffer.GetDouble(): Double;
var
 tmp: array[0..7] of Byte absolute Result;
begin
  tmp[0] := FData[FPosition + 7];
  tmp[1] := FData[FPosition + 6];
  tmp[2] := FData[FPosition + 5];
  tmp[3] := FData[FPosition + 4];
  tmp[4] := FData[FPosition + 3];
  tmp[5] := FData[FPosition + 2];
  tmp[6] := FData[FPosition + 1];
  tmp[7] := FData[FPosition];
  FPosition := FPosition + 8;
end;

function TGXByteBuffer.GetInt64() : Int64;
begin
  System.Move(FData[FPosition], Result, 8);
  Result := swap(Result);
  FPosition := FPosition + 8;
end;

//Result : the data
function TGXByteBuffer.GetData() : TBytes;
begin
  Result := FData;
end;

// value : The data to set
procedure TGXByteBuffer.SetData( value : TBytes);
begin
  FData := value;
  FSize := Length(value);
end;

function TGXByteBuffer.GetUInt64() : Extended;
begin
    Result := GetInt64();
end;

function TGXByteBuffer.GetString(count : Integer) : String;
begin
  Result := GetString(FPosition, count);
  FPosition := FPosition + count;
end;

function TGXByteBuffer.GetString(index : Integer; count : Integer): String;
var
  tmp : TBytes;
begin
  if count = 0 then
    Result := ''
  else
  begin
    if index + count > size then
      raise EArgumentException.Create('getString');

    SetLength(tmp, count);
    System.Move(FData[index], tmp[0], count);
    Result := TEncoding.ASCII.GetString(tmp);
  end;
end;

// Append the given byte array into this buffer.
// value : Data to append.
procedure TGXByteBuffer.SetArray(value : TBytes);
begin
  if value <> Nil then
    SetArray(value, 0, Length(value));
end;

// Append the given byte array into this buffer.
// value : Data to append.
procedure TGXByteBuffer.SetArray(value : TByteDynArray);
begin
  SetArray(value, 0, Length(value));
end;

// Append the given byte array into this buffer.
// value : Data to append.
procedure TGXByteBuffer.SetArray(value : array of Byte);
begin
  SetArray(value, 0, Length(value));
end;

// Push the given byte array into this buffer at the current position, and
// then increments the position.
// index : Byte index.
// value : The value to be added.
procedure TGXByteBuffer.SetArray(index : Integer; value : TBytes);
begin
  if value <> Nil then
  begin
    Move(index, Length(value), size - index);
    SetArray(value, index, Length(value));
  end;
end;

// Push the given byte array into this buffer at the current position, and
// then increments the position.
// index : Byte index.
// value : The value to be added.
procedure TGXByteBuffer.SetArray(index : Integer; value : TByteDynArray);
var
  len : Integer;
begin
  len := Length(value);
  Move(index, len, size - index);
  SetArray(value, index, Length(value));
end;

  // Push the given byte array into this buffer at the current position, and
// then increments the position.
// index : Byte index.
// value : The value to be added.
procedure TGXByteBuffer.SetArray(index : Integer; value : array of byte);
var
  len : Integer;
begin
  len := Length(value);
  Move(index, len, size - index);
  SetArray(value, index, Length(value));
end;

//Set new value to byte array.
// value : Byte array to add.
// index : Byte index.
// count : Byte count.
procedure TGXByteBuffer.SetArray(value : TBytes; index : Integer; count : Integer);
begin
  if ((value <> Nil) and (count <> 0)) then
  begin
    if (size + count > capacity()) then
      Capacity(size + count + ARRAY_CAPACITY);

    System.Move(value[index], FData[size], count);
    FSize := FSize + count;
  end;
end;


procedure TGXByteBuffer.SetArray(value : TByteDynArray; index : Integer; count : Integer);
begin
  if count <> 0 then
  begin
    if (size + count > capacity()) then
      Capacity(size + count + ARRAY_CAPACITY);

    System.Move(value[index], FData[size], count);
    FSize := FSize + count;
  end;
end;

procedure TGXByteBuffer.SetArray(value : array of byte; index : Integer; count : Integer);
begin
  if count <> 0 then
  begin
    if (size + count > capacity()) then
      Capacity(size + count + ARRAY_CAPACITY);

    System.Move(value[index], FData[size], count);
    FSize := FSize + count;
  end;
end;

procedure TGXByteBuffer.SetArray(value : TGXByteBuffer);
begin
  if value <> Nil then
    SetArray(value, value.Size - value.Position);
end;

//Set new value to byte array.
// value : Byte array to add.
// count : Byte count.
procedure TGXByteBuffer.SetArray(value : TGXByteBuffer; count : Integer);
begin
    if size + count > Capacity() then
      Capacity(size + count + ARRAY_CAPACITY);

    if count <> 0 then
    begin
      System.Move(value.FData[value.Position], FData[FSize], count);
      FSize := FSize + count;
      value.FPosition := value.FPosition + count;
    end;
end;

procedure TGXByteBuffer.AddString(value : String);
begin
  if Length(value) <> 0 then
  begin
   SetArray(TEncoding.ASCII.GetBytes(value));
  end;
end;

//Add new object to the byte buffer.
// value : Value to add.
procedure TGXByteBuffer.Add(value : TValue);
begin
  if Not value.IsEmpty then
  begin
    if value.IsType<TBytes> Then
      SetArray(value.AsType<TBytes>)
    else if value.IsType<Byte> Then
      SetUInt8(value.AsType<Byte>)
    else if value.IsType<ShortInt> Then
      SetUInt8(value.AsType<ShortInt>)
    else if value.IsType<Integer> Then
      SetUInt32(value.AsType<Integer>)
    else if value.IsType<ShortInt> Then
      SetUInt64(value.AsType<ShortInt>)
    else if value.IsType<String> Then
      SetArray(TEncoding.ASCII.GetBytes(value.AsType<String>))
    else if value.IsType<Boolean> Then
      if value.AsType<Boolean> = True Then
        SetUInt8(1)
      else
        SetUInt8(0)
    else
      EArgumentException.Create('Invalid object type.');
  end;
end;

procedure TGXByteBuffer.Get(target : TBytes);
begin
  if (size - position < Length(target)) Then
     raise EArgumentException.Create('get');

  if Length(target) <> 0 then
    System.Move(FData[FPosition], target[0], Length(target));
  FPosition := FPosition + Length(target);
end;

//Compares, whether two given arrays are similar starting from current position.
// arr : Array to compare.
// Result : True, if arrays are similar. False, if the arrays differ.
function TGXByteBuffer.Compare(arr : TBytes) : Boolean;
var
  ret : Boolean;
begin
  if size - position < Length(arr) then
    Result := false
  else
  begin
  ret := CompareMem(@FData[FPosition], @arr[0], length(arr));
  if ret = True then
      FPosition := FPosition + Length(arr);

  Result := ret;
  end;
end;

//Compares, whether two given arrays are similar starting from current position.
// arr : Array to compare.
// Result : True, if arrays are similar. False, if the arrays differ.
function TGXByteBuffer.Compare(arr : array of Byte) : Boolean;
var
  ret : Boolean;
begin
  if size - position < Length(arr) then
    Result := false
  else
  begin
  ret := CompareMem(@FData[FPosition], @arr[0], length(arr));
  if ret = True then
      FPosition := FPosition + Length(arr);

  Result := ret;
  end;
end;

class function TGXByteBuffer.HexToBytes(HexStr : String): TBytes;
var
  tmp : byte;
  count, index, pos: Integer;
begin
  count := (Length(HexStr) + 1) div 3;
  SetLength(Result, count);
  index := 1;
  for pos := 0 to count - 1 do
  begin
     tmp := ToHexValue(HexStr[index]) Shl 4;
     tmp := tmp + ToHexValue(HexStr[index + 1]);
     index := index + 3;
     Result[pos] := tmp;
  end;
end;

class function TGXByteBuffer.ToHexValue(Value : char) : byte;
begin
  if Value > '9' then
  begin
    if Value > 'Z' then
      Result := Ord(Value) - Ord('a') + 10
    else
       Result := Ord(Value) - Ord('A') + 10;
  end
  else
    Result := Ord(Value) - Ord('0');
end;

class function TGXByteBuffer.SwapBuffer(value : array of Byte) : TBytes;
var
  count, pos: Integer;
begin
  count := Length(value);
  SetLength(Result, count);
  for pos := 0 to count - 1 do
  begin
     Result[pos] := value[count - pos - 1];
  end;
end;

class function TGXByteBuffer.ToHexString(bytes : TBytes): String;
begin
   Result := ToHexString(bytes, True,0, Length(bytes));
end;

class function TGXByteBuffer.ToHexString(bytes : TBytes; addSpace : Boolean; Index : Integer; Count : Integer): String;
var
pos, tmp, add : Integer;
begin
if addSpace then
begin
  add  := 3;
  Result := String.Create(' ', (Count * add) - 1);
end
else
begin
  add := 2;
  Result := String.Create(' ', (Count * add));
end;
for pos := Index to Count - 1 do
begin
  tmp := bytes[pos];
  Result[(pos * add) + 1] := hexArray[tmp Shr 4];
  Result[(pos * add) + 2] := hexArray[tmp and $0F];
end;
end;

// Push the given hex string as byte array into this buffer at the current
// position, and then increments the position.
// value : The hex string to be added.
procedure TGXByteBuffer.SetHexString(value : String);
begin
  SetArray(HexToBytes(value));
end;

// Push the given hex string as byte array into this buffer at the current
// position, and then increments the position.
// index : Byte index.
// value : The hex string to be added.
procedure TGXByteBuffer.SetHexString(index : Integer; value : String);
begin
  SetHexString(value, 0, Length(value));
end;

// Push the given hex string as byte array into this buffer at the current
// position, and then increments the position.
// value : Byte array to add.
// index : Byte index.
// count : Byte count.
procedure TGXByteBuffer.SetHexString(value : String; index : Integer; count : Integer);
var
 tmp : TBytes;
begin
  tmp := HexToBytes(value);
  SetArray(tmp, index, count);
end;

function TGXByteBuffer.ToString: string;
begin
  Result := ToHex(True, 0, FSize);
end;

//Get remaining data.
// Result : Remaining data as byte array.
function TGXByteBuffer.Remaining() : TBytes;
begin
  Result := SubArray(position, size - position);
end;

// Get remaining data as a hex string.
// addSpace : Add space between bytes.
// Result : Remaining data as a hex string.
function TGXByteBuffer.RemainingHexString(addSpace : Boolean) : String;
begin
  Result := ToHex(addSpace, FPosition, FSize - FPosition);
end;

//Get data as hex string.
// addSpace : Add space between bytes.
// index : Byte index.
// count : Byte count.
// Result : Data as hex string.
function TGXByteBuffer.ToHex(addSpace : Boolean; index : Integer; count : Integer) : String;
begin
  Result := ToHexString(FData, addSpace, index, count);
end;
end.

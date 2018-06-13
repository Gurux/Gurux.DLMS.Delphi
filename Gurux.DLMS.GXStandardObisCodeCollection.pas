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

unit Gurux.DLMS.GXStandardObisCodeCollection;

interface
uses System.SysUtils, Generics.Collections, Gurux.DLMS.GXStandardObisCode,
Gurux.DLMS.ObjectType, StrUtils;

type
  TGXStandardObisCodeCollection = class(TObjectList<TGXStandardObisCode>)

  class function GetBytes(ln: string): TBytes;static;
  public
    function Find(obisCode: string; objectType: TObjectType): TObjectList<TGXStandardObisCode>; overload;
  strict private
    class function EqualsInterface(it: TGXStandardObisCode; ic: Integer): Boolean;static;
    class function EqualsMask(obisMask: string; ic: Byte): Boolean; overload;static;
  public
    class function EqualsMask(obisMask: string; ln: string): Boolean; overload;static;
  strict private
    class function EqualsObisCode(obisMask: TArray<string>; ic: TBytes): Boolean;static;
    class function GetDescription(str: string): string;static;
  public
    function Find(obisCode: TBytes; IC: Integer): TObjectList<TGXStandardObisCode>; overload;

  end;

implementation

{$AUTOBOX ON}
{$HINTS OFF}
{$WARNINGS OFF}

class function TGXStandardObisCodeCollection.GetBytes(ln: string): TBytes;
var
  tmp: TArray<string>;
begin
  tmp := ln.Split(['.']);
  if (Length(tmp) <> 6) then
    raise Exception.Create('Invalid OBIS Code.');
  SetLength(Result, 6);
  Result[0] := StrToInt(tmp[0]);
  Result[1] := StrToInt(tmp[1]);
  Result[2] := StrToInt(tmp[2]);
  Result[3] := StrToInt(tmp[3]);
  Result[4] := StrToInt(tmp[4]);
  Result[5] := StrToInt(tmp[5]);
end;

function TGXStandardObisCodeCollection.Find(obisCode: string; objectType: TObjectType): TObjectList<TGXStandardObisCode>;
begin
  Result := Find(GetBytes(obisCode), (Integer(objectType)));
end;

class function TGXStandardObisCodeCollection.EqualsInterface(it: TGXStandardObisCode;
  ic: Integer): Boolean;
var
  tmp : TArray<string>;
begin
  if (it.Interfaces = '*') then
    Result := True
  else
  tmp := it.Interfaces.Split([',']);
  Result := AnsiIndexText(Integer(ic).ToString(), tmp) <> -1;
end;

class function TGXStandardObisCodeCollection.EqualsMask(obisMask: string; ic: Byte): Boolean;
var
  it: string;
  number: Boolean;
  tmp : TArray<string>;
begin
  number := True;
  if (obisMask.IndexOf(',') <> -1) then
  begin
      tmp := obisMask.Split([',']);
      for it in tmp do
      begin
          if (it.IndexOf('-') <> -1) then
          begin
              if (EqualsMask(it, ic)) then
              begin
                  Result := True;
                  Exit;
              end;
          end
          else if (byte.Parse(it) = ic) then
          begin
              Result := True;
              Exit;
          end;
      end;
      Result := False;
      Exit;
  end
  else if (obisMask.IndexOf('-') <> -1) then
  begin
      number := false;
      tmp := obisMask.Split(['-']);
      Result := (ic >= byte.Parse(tmp[0])) and (ic <= byte.Parse(tmp[1]));
      Exit;
  end
  else
  if number then
  begin
      if obisMask = '&' then
      begin
          Result := (ic = 0) or (ic = 1) or (ic = 7);
          Exit;
      end;
      Result := byte.Parse(obisMask) = ic;
      Exit;
  end;
  Result := False;
end;

class function TGXStandardObisCodeCollection.EqualsMask(obisMask: string; ln: string): Boolean;
begin
  Result := EqualsObisCode(obisMask.Split(['.']), GetBytes(ln));
end;

class function TGXStandardObisCodeCollection.EqualsObisCode(obisMask: TArray<string>;
  ic: TBytes): Boolean;
begin
  if (Length(obisMask) <> 6) then
    raise Exception.Create('Invalid OBIS mask.');
  if (EqualsMask(obisMask[0], ic[0]) = False) then
  begin
      Result := False;
      Exit;
  end;
  if (EqualsMask(obisMask[1], ic[1]) = False) then
  begin
      Result := False;
      Exit;
  end;
  if (EqualsMask(obisMask[2], ic[2]) = False) then
  begin
      Result := False;
      Exit;
  end;
  if (EqualsMask(obisMask[3], ic[3]) = False) then
  begin
      Result := False;
      Exit;
  end;
  if (EqualsMask(obisMask[4], ic[4]) = False) then
  begin
      Result := False;
      Exit;
  end;
  if (EqualsMask(obisMask[5], ic[5]) = False) then
  begin
      Result := False;
      Exit;
  end;
  Result := True;
end;

class function TGXStandardObisCodeCollection.GetDescription(str: string): string;
var
  value: Integer;
begin
  if (string.IsNullOrEmpty(str) or (str[1] <> '$')) then
    begin
      Result := '';
      Exit;
    end;
  value := Integer.Parse(str.Substring(1));
  case value of
  1: Result := 'Sum Li Active power+ (QI+QIV)';
  2: Result := 'Sum Li Active power- (QII+QIII)';
  3: Result := 'Sum Li Reactive power+ (QI+QII)';
  4: Result := 'Sum Li Reactive power- (QIII+QIV)';
  5: Result := 'Sum Li Reactive power QI';
  6: Result := 'Sum Li Reactive power QII';
  7: Result := 'Sum Li Reactive power QIII';
  8: Result := 'Sum Li Reactive power QIV';
  9: Result := 'Sum Li Apparent power+ (QI+QIV)';
  10: Result := 'Sum Li Apparent power- (QII+QIII)';
  11: Result := 'Current: any phase';
  12: Result := 'Voltage: any phase';
  13: Result := 'Sum Li Power factor';
  14: Result := 'Supply frequency';
  15: Result := 'Sum LI Active power (abs(QI+QIV)+abs(QII+QIII))';
  16: Result := 'Sum LI Active power        (abs(QI+QIV)-abs(QII+QIII))';
  17: Result := 'Sum Li Active power QI';
  18: Result := 'Sum Li Active power QII';
  19: Result := 'Sum Li Active power QIII';
  20: Result := 'Sum Li Active power QIV';
  21: Result := 'L1 Active power+ (QI+QIV)';
  22: Result := 'L1 Active power- (QII+QIII)';
  23: Result := 'L1 Reactive power+ (QI+QII)';
  24: Result := 'L1 Reactive power- (QIII+QIV)';
  25: Result := 'L1 Reactive power QI';
  26: Result := 'L1 Reactive power QII';
  27: Result := 'L1 Reactive power QIII';
  28: Result := 'L1 Reactive power QIV';
  29: Result := 'L1 Apparent power+ (QI+QIV)';
  30: Result := 'L1 Apparent power- (QII+QIII)';
  31: Result := 'L1 Current';
  32: Result := 'L1 Voltage';
  33: Result := 'L1 Power factor';
  34: Result := 'L1 Supply frequency';
  35: Result := 'L1 Active power (abs(QI+QIV)+abs(QII+QIII))';
  36: Result := 'L1 Active power (abs(QI+QIV)-abs(QII+QIII))';
  37: Result := 'L1 Active power QI';
  38: Result := 'L1 Active power QII';
  39: Result := 'L1 Active power QIII';
  40: Result := 'L1 Active power QIV';
  41: Result := 'L2 Active power+ (QI+QIV)';
  42: Result := 'L2 Active power- (QII+QIII)';
  43: Result := 'L2 Reactive power+ (QI+QII)';
  44: Result := 'L2 Reactive power- (QIII+QIV)';
  45: Result := 'L2 Reactive power QI';
  46: Result := 'L2 Reactive power QII';
  47: Result := 'L2 Reactive power QIII';
  48: Result := 'L2 Reactive power QIV';
  49: Result := 'L2 Apparent power+ (QI+QIV)';
  50: Result := 'L2 Apparent power- (QII+QIII)';
  51: Result := 'L2 Current';
  52: Result := 'L2 Voltage';
  53: Result := 'L2 Power factor';
  54: Result := 'L2 Supply frequency';
  55: Result := 'L2 Active power (abs(QI+QIV)+abs(QII+QIII))';
  56: Result := 'L2 Active power (abs(QI+QIV)-abs(QI+QIII))';
  57: Result := 'L2 Active power QI';
  58: Result := 'L2 Active power QII';
  59: Result := 'L2 Active power QIII';
  60: Result := 'L2 Active power QIV';
  61: Result := 'L3 Active power+ (QI+QIV)';
  62: Result := 'L3 Active power- (QII+QIII)';
  63: Result := 'L3 Reactive power+ (QI+QII)';
  64: Result := 'L3 Reactive power- (QIII+QIV)';
  65: Result := 'L3 Reactive power QI';
  66: Result := 'L3 Reactive power QII';
  67: Result := 'L3 Reactive power QIII';
  68: Result := 'L3 Reactive power QIV';
  69: Result := 'L3 Apparent power+ (QI+QIV)';
  70: Result := 'L3 Apparent power- (QII+QIII)';
  71: Result := 'L3 Current';
  72: Result := 'L3 Voltage';
  73: Result := 'L3 Power factor';
  74: Result := 'L3 Supply frequency';
  75: Result := 'L3 Active power (abs(QI+QIV)+abs(QII+QIII))';
  76: Result := 'L3 Active power (abs(QI+QIV)-abs(QI+QIII))';
  77: Result := 'L3 Active power QI';
  78: Result := 'L3 Active power QII';
  79: Result := 'L3 Active power QIII';
  80: Result := 'L3 Active power QIV';
  82: Result := 'Unitless quantities (pulses or pieces)';
  84: Result := 'Sum Li Power factor-';
  85: Result := 'L1 Power factor-';
  86: Result := 'L2 Power factor-';
  87: Result := 'L3 Power factor-';
  88: Result := 'Sum Li A2h QI+QII+QIII+QIV';
  89: Result := 'Sum Li V2h QI+QII+QIII+QIV';
  90: Result := 'SLi current (algebraic sum of the � unsigned � value of the currents in all phases)';
  91: Result := 'Lo Current (neutral)';
  92: Result := 'Lo Voltage (neutral)';
  else
    Result := '';
  end;
end;

function TGXStandardObisCodeCollection.Find(obisCode: TBytes; IC: Integer): TObjectList<TGXStandardObisCode>;
var
  it : TGXStandardObisCode;
  tmp: TGXStandardObisCode;
  tmp2 : TArray<string>;
  desc : string;
  begin1, end1, start, plus : Integer;
  ch : byte;
  channel : char;
begin
  Result := TObjectList<TGXStandardObisCode>.Create();
  try

    for it in Self do
    begin
        //Interface is tested first because it's faster.
        if (EqualsInterface(it, IC) and EqualsObisCode(it.OBIS, obisCode)) then
        begin
            tmp := TGXStandardObisCode.Create(it.OBIS, it.Description, it.Interfaces, it.DataType);
            Result.Add(tmp);
            tmp2 := it.Description.Split([';']);
            if Length(tmp2) > 1 then
            begin
                desc := GetDescription(tmp2[1].Trim());
                if desc <> '' then
                begin
                    tmp2[1] := desc;
                    tmp.Description := string.Join(';', tmp2);
                end;
            end;
            tmp.OBIS[0] := obisCode[0].ToString();
            tmp.OBIS[1] := obisCode[1].ToString();
            tmp.OBIS[2] := obisCode[2].ToString();
            tmp.OBIS[3] := obisCode[3].ToString();
            tmp.OBIS[4] := obisCode[4].ToString();
            tmp.OBIS[5] := obisCode[5].ToString();
            tmp.Description := tmp.Description.Replace('$A', obisCode[0].ToString());
            tmp.Description := tmp.Description.Replace('$B', obisCode[1].ToString());
            tmp.Description := tmp.Description.Replace('$C', obisCode[2].ToString());
            tmp.Description := tmp.Description.Replace('$D', obisCode[3].ToString());
            tmp.Description := tmp.Description.Replace('$E', obisCode[4].ToString());
            tmp.Description := tmp.Description.Replace('$F', obisCode[5].ToString());
            //Increase value
            begin1 := tmp.Description.IndexOf('#$');
            if begin1 <> -1 then
            begin
                start := tmp.Description.IndexOf('(');
                end1 := tmp.Description.IndexOf(')');
                channel := tmp.Description[start + 1];
                ch := 0;
                if channel = 'A' then
                  ch := obisCode[0]
                else if channel = 'B' then
                  ch := obisCode[1]
                else if channel = 'C' then
                  ch := obisCode[2]
                else if channel = 'D' then
                  ch := obisCode[3]
                else if channel = 'E' then
                  ch := obisCode[4]
                else if channel = 'F' then
                  ch := obisCode[5];

                plus := tmp.Description.IndexOf('+');
                if plus <> -1 then
                  ch := ch + byte.Parse(tmp.Description.Substring(plus + 1, end1 - plus - 1));

                tmp.Description := tmp.Description.Substring(0, begin1) + ch.ToString();
            end;
            tmp.Description := tmp.Description.Replace(';', ' ').Replace('  ', ' ').Trim();
        end;
    end;

    //If invalid OBIS code.
    if Result.Count = 0 Then
    begin
      tmp := TGXStandardObisCode.Create(Nil, 'Manufacturer specific', IC.ToString(), '');
      Result.Add(tmp);
      tmp.OBIS[0] := obisCode[0].ToString();
      tmp.OBIS[1] := obisCode[1].ToString();
      tmp.OBIS[2] := obisCode[2].ToString();
      tmp.OBIS[3] := obisCode[3].ToString();
      tmp.OBIS[4] := obisCode[4].ToString();
      tmp.OBIS[5] := obisCode[5].ToString();
    end;

  except
    result.Free;
    raise;
  end;

end;

end.


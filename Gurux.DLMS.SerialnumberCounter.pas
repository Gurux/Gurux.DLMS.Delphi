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

unit Gurux.DLMS.SerialnumberCounter;

interface
uses SysUtils, TypInfo, Rtti, Variants, System.Generics.Collections,
  System.Math;

type
   TSerialnumberCounter = class
    // Get values to count together.
    class function GetValues(expressions: String): TArray<String>;

    class function GetValue(value: String; sn: Integer): Integer;
    // Count serial number using formula.
    class function Count(sn: Integer; formula: String): Integer;

    // Produce formatted string by the given math expression.
    class function FormatString(expression: String): String;

   end;

implementation

class function TSerialnumberCounter.GetValues(expressions: String): TArray<String>;
var
  values: TList<String>;
  last, index: Integer;
  ch: Char;
begin
  last := 0;
  index := 0;
  values := TList<string>.Create();
  try
    for ch in expressions do
    begin
      case ch
        of '%', '+', '-', '*', '/':
        begin
          values.Add(expressions.Substring(last, index - last));
          values.Add(ch);
          last := index + 1;
        end;
      end;
      index := index + 1;
    end;
    if index <> last Then
      values.Add(expressions.Substring(last, index - last));

    Result := values.ToArray();
  finally
    FreeAndNil(values);
  end;
end;

class function TSerialnumberCounter.GetValue(value: String; sn: Integer): Integer;
begin
  if value = 'sn' Then
    Result := sn
  else
    Result := StrToInt(value);
end;

class function TSerialnumberCounter.Count(sn: Integer; formula: String): Integer;
var
  values: TArray<String>;
  index: Integer;
  ch: Char;
begin
  values := GetValues(FormatString(formula));
  if Length(values) Mod 2 = 0 Then
    raise EArgumentException.Create('Invalid serial number formula.');

  Result := GetValue(values[0], sn);
  index := 1;
  while index < Length(values) do
  begin
    ch := values[index].ToCharArray()[0];
    case ch of
      '%': Result := Result Mod GetValue(values[index + 1], sn);
      '+': Result := Result + GetValue(values[index + 1], sn);
      '-': Result := Result - GetValue(values[index + 1], sn);
      '*': Result := Result * GetValue(values[index + 1], sn);
      '/': Result := Floor(Result / GetValue(values[index + 1], sn));
      else
        raise EArgumentException.Create('Invalid serial number formula.');
    end;
    index := index + 2;
  end;
end;

class function TSerialnumberCounter.FormatString(expression: String): String;
var
  sb: TStringBuilder;
  ch: Char;
begin
  if expression = '' Then
    raise EArgumentException.Create('Expression is null or empty.');

  sb := TStringBuilder.Create();
  try
    for ch in expression do
    begin
      if (ch = '(') or (ch = ')') Then
        raise EArgumentException.Create('Invalid serial number formula.');

      if ch <> ' ' Then
        sb.Append(LowerCase(ch));
    end;
    Result := sb.ToString();
  finally
    FreeAndNil(sb);
  end;

end;

end.

//
// --------------------------------------------------------------------------
//  Gurux Ltd
//
//
//
// Filename:    $HeadURL$
//
// Version:     $Revision$,
//          $Date$
//          $Author$
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

unit Gurux.DLMS.GXDLMSTranslatorStructure;

interface
uses SysUtils, Rtti, Generics.Collections, TranslatorOutputType,
Gurux.DLMS.DataType, Gurux.DLMS.Command;

type
TGXDLMSTranslatorStructure = class
  FOutputType: TTranslatorOutputType;
  FOmitNameSpace: BOOLEAN;
  FShowStringAsHex: BOOLEAN;
  FComments: BOOLEAN;
  FIgnoreSpaces: BOOLEAN;
  FShowNumericsAsHex: BOOLEAN;
  FOffset : WORD;
  sb: string;
  tags: TDictionary<LONGWORD, string>;

  // Append spaces.
  procedure AppendSpaces();
  procedure AppendLine(str: string);overload;
  function GetTag(tag: LONGWORD): string;
  procedure AppendLine(tag: string; name: string; value: TValue);overload;
  procedure AppendLine(tag: LONGWORD; name: string; value: TValue);overload;

  procedure AppendLine(tag: LONGWORD; name: string; value: string);overload;
  procedure AppendLine(tag: string; name: string; value: string);overload;

public
  //Translator output type.
  property OutputType: TTranslatorOutputType read FOutputType write FOutputType;
  //Omit name space.
  property OmitNameSpace: BOOLEAN read FOmitNameSpace write FOmitNameSpace;
  //Offset.
  property Offset: WORD read FOffset write FOffset;
  //Show string as hex
  property ShowStringAsHex: BOOLEAN read FShowStringAsHex write FShowStringAsHex;
  //Are comments added.
  property Comments: BOOLEAN read FComments write FComments;
  //Are spaces ignored.
  property IgnoreSpaces: BOOLEAN read FIgnoreSpaces write FIgnoreSpaces;

  function GetDataType(tp: TDataType): string;

  constructor Create(tp: TTranslatorOutputType; omitNameSpace: BOOLEAN;
  numericsAshex: BOOLEAN; hex: BOOLEAN; comments: BOOLEAN; list: TDictionary<LONGWORD, string>);


  // Start comment section.
  procedure StartComment(comment: string);

  // End comment section.
  procedure EndComment();

  // Append comment.
  procedure AppendComment(comment: string);

  procedure Append(value: string); overload;

  procedure Append(tag: LONGWORD; start: BOOLEAN); overload;

  procedure AppendStartTag(tag: LONGWORD; name: string; value: string; plain: BOOLEAN); overload;

  procedure AppendStartTag(cmd: LONGWORD); overload;

  procedure AppendStartTag(cmd: TCommand; tp: LONGWORD); overload;

  procedure AppendEndTag(cmd: TCommand; tp: LONGWORD);overload;

  procedure AppendEndTag(tag: LONGWORD);overload;

  procedure AppendEndTag(tag: LONGWORD; plain: BOOLEAN); overload;

  procedure AppendEmptyTag(tag: LONGWORD); overload;

  procedure AppendEmptyTag(tag: string); overload;

  // Remove \r\n.
  procedure Trim();

  // Get XML Length.
  function GetXmlLength(): WORD;

  // Set XML Length.
  procedure SetXmlLength(value: WORD);

  // Convert integer to string.
  function IntegerToHex(value: Integer; desimals: WORD): string; overload;

  // Convert integer to string.
  function IntegerToHex(value: Integer; desimals: WORD; forceHex: BOOLEAN) : string; overload;

  // Convert integer to string.
  function IntegerToHex(value: UInt32; desimals: WORD; forceHex: BOOLEAN) : string; overload;

  // Convert integer to string.
  function IntegerToHex(value: UInt32): string; overload;

  function ToString: string; override;
end;

implementation

uses Gurux.DLMS.GXDLMS;

constructor TGXDLMSTranslatorStructure.Create(tp: TTranslatorOutputType; omitNameSpace: BOOLEAN;
  numericsAshex: BOOLEAN; hex: BOOLEAN; comments: BOOLEAN; list: TDictionary<LONGWORD, string>);
begin
   FOutputType := tp;
   FOmitNameSpace := omitNameSpace;
   FShowNumericsAsHex := numericsAshex;
   FShowStringAsHex := hex;
   FComments := comments;
   tags := list;
end;

function TGXDLMSTranslatorStructure.GetDataType(tp: TDataType): string;
begin
  Result := GetTag(DATA_TYPE_OFFSET + LONGWORD(tp));
end;

procedure TGXDLMSTranslatorStructure.AppendSpaces();
var
  pos: Integer;
begin
  if IgnoreSpaces Then
  sb := sb + ' '
  else
  begin
  for pos := 1 to offset do
    sb := sb + '  ';
  end;
end;

procedure TGXDLMSTranslatorStructure.AppendLine(str: string);
begin
  if IgnoreSpaces Then
  sb := sb + str
  else
  begin
  AppendSpaces();
  sb := sb + str + sLineBreak;
  end;
end;

function TGXDLMSTranslatorStructure.GetTag(tag: LONGWORD): string;
begin
  if (FOutputType = TTranslatorOutputType.SimpleXml) or (FOmitNameSpace) then
  Result := tags[tag]
  else
  Result := 'x:' + tags[tag];
end;

procedure TGXDLMSTranslatorStructure.AppendLine(tag: LONGWORD; name: string; value: TValue);
begin
  AppendLine(GetTag(tag), name, value);
end;

procedure TGXDLMSTranslatorStructure.AppendLine(tag: LONGWORD; name: string; value: string);
begin
  AppendLine(GetTag(tag), name, value);
end;

procedure TGXDLMSTranslatorStructure.AppendLine(tag: string; name: string; value: TValue);
begin
  AppendSpaces();
  sb := sb + '<';
  sb := sb + tag;
  if FOutputType = TranslatorOutputType.SimpleXml Then
  begin
    sb := sb + ' ';
    if name = '' Then
      sb := sb + 'Value'
    else
      sb := sb + name;
    sb := sb + '=\"';
  end
  else
    sb := sb + '>';
  {
  if (value is byte)
    sb := sb + (IntegerToHex((byte)value, 2));
  else if (value is sbyte)
    sb := sb + (IntegerToHex((sbyte)value, 2));
  else if (value is UInt16)
    sb := sb + (IntegerToHex((UInt16)value, 4));
  else if (value is Int16)
    sb := sb + (IntegerToHex((Int16)value, 4));
  else if (value is UInt32)
    sb := sb + (IntegerToHex((UInt32)value, 8));
  else if (value is Int32)
    sb := sb + (IntegerToHex((Int32)value, 8));
  else if (value is UInt64)
    sb := sb + (IntegerToHex((UInt64)value));
  else if (value is Int64)
    sb := sb + (IntegerToHex((Int64)value, 16));
  else if (value is byte[])
    sb := sb + (GXCommon.ToHex((byte[]) value, true));
  else if (value is sbyte[])
    sb := sb + (GXCommon.ToHex((byte[])value, true));
  else
    sb := sb + (Convert.ToString(value));
  }
  if OutputType = TTranslatorOutputType.SimpleXml Then
    sb := sb + '"\" />'
  else
  begin
    sb := sb + '</';
    sb := sb + tag;
    sb := sb + '>';
  end;
  sb := sb + sLineBreak;
end;

procedure TGXDLMSTranslatorStructure.AppendLine(tag: string; name: string; value: string);
begin
  AppendSpaces();
  sb := sb + '<';
  sb := sb + tag;
  if FOutputType = TranslatorOutputType.SimpleXml Then
  begin
    sb := sb + ' ';
    if name = '' Then
    sb := sb + 'Value'
    else
    sb := sb + name;
    sb := sb + '="';
  end
  else
  sb := sb + '>';
  sb := sb + value;
  if OutputType = TTranslatorOutputType.SimpleXml Then
  sb := sb + '" />'
  else
  begin
  sb := sb + '</';
  sb := sb + tag;
  sb := sb + '>';
  end;
  sb := sb + sLineBreak;
end;

// Start comment section.
procedure TGXDLMSTranslatorStructure.StartComment(comment: string);
begin
  if FComments Then
  begin
    AppendSpaces();
    sb := sb + ('<!--');
    sb := sb + (comment);
    sb := sb + sLineBreak;
    FOffset := FOffset + 1;
  end;
end;

// End comment section.
procedure TGXDLMSTranslatorStructure.EndComment();
begin
  if Comments Then
  begin
    FOffset := FOffset - 1;
    AppendSpaces();
    sb := sb + '-->';
    sb := sb + sLineBreak;
  end;
end;


// Append comment.
procedure TGXDLMSTranslatorStructure.AppendComment(comment: string);
begin
  if FComments Then
  begin
    AppendSpaces();
    sb := sb + '<!--';
    sb := sb + comment;
    sb := sb + '-->';
    sb := sb + sLineBreak;
  end;
end;

procedure TGXDLMSTranslatorStructure.Append(value: string);
begin
  sb := sb + (value);
end;

procedure TGXDLMSTranslatorStructure.Append(tag: LONGWORD; start: BOOLEAN);
begin
  if start Then
    sb := sb + ('<')
  else
    sb := sb + ('</');
  sb := sb + (GetTag(tag));
  sb := sb + ('>');
end;

procedure TGXDLMSTranslatorStructure.AppendStartTag(tag: LONGWORD; name: string; value: string; plain: BOOLEAN);
begin
  AppendSpaces();
  sb := sb + ('<');
  sb := sb + (GetTag(tag));
  if (FOutputType = TTranslatorOutputType.SimpleXml) and (name <> '') Then
  begin
  sb := sb + ' ' + name + '="' + value + '" >';
  end
  else
  begin
  sb := sb + ('>');
end;
  if plain = False Then
  begin
  sb := sb + sLineBreak;
end;
  FOffset := FOffset + 1;
end;

procedure TGXDLMSTranslatorStructure.AppendStartTag(cmd: LONGWORD);
begin
  AppendSpaces();
  sb := sb + '<';
  sb := sb + GetTag(cmd);
  sb := sb + '>' + sLineBreak;
  FOffset := FOffset + 1;
end;

procedure TGXDLMSTranslatorStructure.AppendStartTag(cmd: TCommand; tp: LONGWORD);
begin
  AppendSpaces();
  sb := sb + '<';
  sb := sb + GetTag((LONGWORD(cmd) shl 8) or tp);
  sb := sb + '>' + sLineBreak;
  FOffset := FOffset + 1;
end;


procedure TGXDLMSTranslatorStructure.AppendEndTag(cmd: TCommand; tp: LONGWORD);
begin
  AppendEndTag((LONGWORD(cmd) shl 8) or tp);
end;

procedure TGXDLMSTranslatorStructure.AppendEndTag(tag: LONGWORD);
begin
  AppendEndTag(tag, false);
end;

procedure TGXDLMSTranslatorStructure.AppendEndTag(tag: LONGWORD; plain: BOOLEAN);
begin
  FOffset := FOffset - 1;
  if plain = False Then
  AppendSpaces();
  sb := sb + ('</');
  sb := sb + (GetTag(tag));
  sb := sb + '>' + sLineBreak;
end;

procedure TGXDLMSTranslatorStructure.AppendEmptyTag(tag: LONGWORD);
begin
  AppendEmptyTag(tags[tag]);
end;

procedure TGXDLMSTranslatorStructure.AppendEmptyTag(tag: string);
begin
  AppendSpaces();
  sb := sb + ('<');
  sb := sb + (tag);
  sb := sb + '/>' + sLineBreak;
end;

procedure TGXDLMSTranslatorStructure.Trim();
begin
  SetLength(sb, Length(sb) - 2);
end;

function TGXDLMSTranslatorStructure.GetXmlLength(): WORD;
begin
  Result := sb.Length;
end;

procedure TGXDLMSTranslatorStructure.SetXmlLength(value: WORD);
begin
  SetLength(sb, value);
end;

function TGXDLMSTranslatorStructure.IntegerToHex(value: Integer; desimals: WORD): string;
begin
  Result := IntegerToHex(value, desimals, False);
end;

function TGXDLMSTranslatorStructure.IntegerToHex(value: Integer; desimals: WORD; forceHex: BOOLEAN): string;
begin
  if FShowNumericsAsHex and (FOutputType = TTranslatorOutputType.SimpleXml) Then
  Result := IntToHex(value, desimals)
  else
  Result := IntToStr(value);
end;

function TGXDLMSTranslatorStructure.IntegerToHex(value: UInt32; desimals: WORD; forceHex: BOOLEAN): string;
begin
  if FShowNumericsAsHex and (FOutputType = TTranslatorOutputType.SimpleXml) Then
  Result := IntToHex(value, desimals)
  else
  Result := IntToStr(value);
end;

// Convert integer to string.
function TGXDLMSTranslatorStructure.IntegerToHex(value: UInt32): string;
begin
  if FShowNumericsAsHex and (FOutputType = TTranslatorOutputType.SimpleXml) Then
  Result := IntToHex(value, 16)
  else
  Result := IntToStr(value);
end;

function TGXDLMSTranslatorStructure.ToString: string;
begin
  Result := sb;
end;
end.

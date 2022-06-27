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

unit Gurux.DLMS.Objects.GXDLMSSecuritySetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.SecurityPolicy, Gurux.DLMS.SecuritySuite,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject;

type
TGXDLMSSecuritySetup = class(TGXDLMSObject)
  FSecurityPolicy: TSecurityPolicy;
  FSecuritySuite: TSecuritySuite;
  FClientSystemTitle, FServerSystemTitle : TBytes;
  FGuek, FGbek, FGak, FKek: TBytes;

  public

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property SecurityPolicy: TSecurityPolicy read FSecurityPolicy write FSecurityPolicy;

  property SecuritySuite: TSecuritySuite read FSecuritySuite write FSecuritySuite;

  property ClientSystemTitle: TBytes read FClientSystemTitle write FClientSystemTitle;

  property ServerSystemTitle: TBytes read FServerSystemTitle write FServerSystemTitle;

  property Guek: TBytes read FGuek write FGuek;
  property Gbek: TBytes read FGbek write FGbek;
  property Gak: TBytes read FGak write FGak;
  property Kek: TBytes read FKek write FKek;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
end;

implementation

constructor TGXDLMSSecuritySetup.Create;
begin
  inherited Create(TObjectType.otSecuritySetup);
  if Version < 2 Then
  begin
    Guek := TBytes.Create( $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F);
    Gbek := TBytes.Create( $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F);
    Gak := TBytes.Create( $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF);
end;
end;

constructor TGXDLMSSecuritySetup.Create(ln: string);
begin
  inherited Create(TObjectType.otSecuritySetup, ln, 0);
end;

constructor TGXDLMSSecuritySetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otSecuritySetup, ln, 0);
end;

function TGXDLMSSecuritySetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FSecurityPolicy),
            Integer(FSecuritySuite), TValue.From(FClientSystemTitle),
            TValue.From(FServerSystemTitle));
end;

function TGXDLMSSecuritySetup.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //SecurityPolicy
    if All or CanRead(2) Then
      items.Add(2);
    //SecuritySuite
    if All or CanRead(3) Then
      items.Add(3);
    //ClientSystemTitle
    if All or CanRead(4) Then
      items.Add(4);
    //ServerSystemTitle
    if All or CanRead(5) Then
      items.Add(5);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSSecuritySetup.GetAttributeCount: Integer;
begin
  Result := 5;
end;

function TGXDLMSSecuritySetup.GetMethodCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSSecuritySetup.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSSecuritySetup.GetValue(e: TValueEventArgs): TValue;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(SecurityPolicy);
  end
  else if e.Index = 3 Then
  begin
    Result := Integer(SecuritySuite);
  end
  else if e.Index = 4 Then
  begin
    Result := TValue.From(FClientSystemTitle);
  end
  else if e.Index = 5 Then
  begin
    Result := TValue.From(FServerSystemTitle);
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSSecuritySetup.SetValue(e: TValueEventArgs);
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    SecurityPolicy := TSecurityPolicy(e.Value.AsInteger);
  end
  else if e.Index = 3 Then
  begin
    SecuritySuite := TSecuritySuite(e.Value.AsInteger);
  end
  else if e.Index = 4 Then
  begin
    ClientSystemTitle := e.Value.AsType<TBytes>();
  end
  else if e.Index = 5 Then
  begin
    ServerSystemTitle := e.Value.AsType<TBytes>();
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSSecuritySetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.



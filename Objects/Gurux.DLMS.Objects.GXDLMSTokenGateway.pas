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

unit Gurux.DLMS.Objects.GXDLMSTokenGateway;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.TokenDelivery, Gurux.DLMS.TokenStatusCode,
GXByteBuffer;

type
TGXDLMSTokenGateway = class(TGXDLMSObject)
private
    {
     Token.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
     }
    FToken: TBytes;

    {
     Time.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
     }
    FTime: TGXDateTime;

    {
     Descriptions.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
     }
    FDescriptions: TArray<string>;

    {
     Token Delivery method.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
     }
    FDeliveryMethod: TTokenDelivery;

    {
     Token status code.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
     }
    FStatusCode: TTokenStatusCode;

    {
     Token data value.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
     }
    FDataValue: string;

  public
    constructor Create; overload;
    constructor Create(ln: string); overload;
    constructor Create(ln: string; sn: System.UInt16); overload;
    destructor Destroy; override;

  {
   Token.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
   }
   property Token: TBytes read FToken write FToken;

  {
   Time.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
   }
   property Time: TGXDateTime read FTime write FTime;

  {
   Descriptions.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
   }
   property Descriptions: TArray<string> read FDescriptions write FDescriptions;

  {
   Token Delivery method.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
   }
   property DeliveryMethod: TTokenDelivery read FDeliveryMethod write FDeliveryMethod;

  {
   Token status code.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
   }
   property StatusCode: TTokenStatusCode read FStatusCode write FStatusCode;

  {
   Token data value.
   Online help:
   http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSTokenGateway
   }
  property DataValue: string read FDataValue write FDataValue;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;
end;

implementation

constructor TGXDLMSTokenGateway.Create;
begin
  Create('0.0.19.40.0.255', 0);
end;

constructor TGXDLMSTokenGateway.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSTokenGateway.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otTokenGateway, ln, sn);
end;

destructor TGXDLMSTokenGateway.Destroy;
begin
  inherited;
  FToken := Nil;
  FreeandNil(FTime);
  FDescriptions := Nil
end;

function TGXDLMSTokenGateway.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, TValue.From(FToken), FTime, TValue.From(FDescriptions),
  TValue.From(FDeliveryMethod), TValue.From(TArray<TValue>.Create(Integer(FStatusCode), TValue.From(FDataValue))));
end;

function TGXDLMSTokenGateway.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //Token
    if CanRead(2) Then
      items.Add(2);

    //Time
    if CanRead(3) Then
      items.Add(3);

    //Description
    if CanRead(4) Then
      items.Add(4);

    //DeliveryMethod
    if CanRead(5) Then
      items.Add(5);

    //Status
    if CanRead(6) Then
      items.Add(6);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSTokenGateway.GetAttributeCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSTokenGateway.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSTokenGateway.GetDataType(index: Integer): TDataType;
begin
  case index Of
    1: Result := TDataType.dtOctetString;
    2: Result := TDataType.dtOctetString;
    3: Result := TDataType.dtOctetString;
    4: Result := TDataType.dtArray;
    5: Result := TDataType.dtEnum;
    6: Result := TDataType.dtStructure;
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSTokenGateway.GetValue(e: TValueEventArgs): TValue;
var
  bb: TGXByteBuffer;
  it: string;
begin
  case e.Index Of
      1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
      2: Result := TValue.From(FToken);
      3: Result := FTime;
      4:
      begin
        bb := TGXByteBuffer.Create();
        try
          bb.SetUInt8(Integer(TDataType.dtArray));
          bb.SetUInt8(Length(FDescriptions));
          for it in FDescriptions do
          begin
              bb.SetUInt8(Integer(TDataType.dtOctetString));
              bb.SetUInt8(it.Length);
              bb.SetArray(TGXCommon.GetBytes(it));
          end;
          Result := TValue.From(bb.ToArray());
        finally
          FreeAndNil(bb);
        end;
      end;
      5: Result := Integer(FDeliveryMethod);
      6:
      begin
        bb := TGXByteBuffer.Create();
        try
          bb.SetUInt8(Integer(TDataType.dtStructure));
          bb.SetUInt8(2);
          TGXCommon.SetData(bb, TDataType.dtEnum, Integer(FStatusCode));
          TGXCommon.SetData(bb, TDataType.dtBitString, DataValue);
          Result := TValue.From(bb.ToArray());
        finally
          FreeAndNil(bb);
        end;
      end
      else
       raise Exception.Create('GetValue failed. Invalid attribute index.');
    end;
end;

procedure TGXDLMSTokenGateway.SetValue(e: TValueEventArgs);
var
  it : TValue;
  list: TList<string>;
begin
  case e.Index Of
    1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
    2: Token := e.Value.AsType<TBytes>;
    3:
    begin
      FreeAndNil(FTime);
      if e.Value.IsEmpty Then
        FTime := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
        begin
          if e.Value.IsType<TBytes> Then
            e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
          FTime := e.Value.AsType<TGXDateTime>;
        end;
    end;
    4:
    begin
      FDescriptions := Nil;
      if Not e.Value.IsEmpty Then
        begin
          list := TList<string>.Create;
          try
            for it in e.Value.AsType<TArray<TValue>> do
              list.Add(TEncoding.ASCII.GetString(it.AsType<TBytes>));

            FDescriptions := list.ToArray();
          finally
            FreeAndNil(list);
          end;
        end;
    end;
    5: FDeliveryMethod := TTokenDelivery(e.Value.AsInteger);
    6:
    begin
      FStatusCode := TTokenStatusCode(e.Value.GetArrayElement(0).AsType<TValue>.AsInteger);
      FDataValue := e.Value.GetArrayElement(1).AsType<TValue>.AsType<string>;
    end;
    else
      raise Exception.Create('SetValue failed. Invalid attribute index.');
  end;
end;

function TGXDLMSTokenGateway.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

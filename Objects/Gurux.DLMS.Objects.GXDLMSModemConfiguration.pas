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

unit Gurux.DLMS.Objects.GXDLMSModemConfiguration;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.BaudRate, Gurux.DLMS.GXDLMSModemInitialisation, GXByteBuffer;

type
TGXDLMSModemConfiguration = class(TGXDLMSObject)
  FCommunicationSpeed: TBaudRate;
  FInitialisationStrings : TObjectList<TGXDLMSModemInitialisation>;
  FModemProfile : TArray<string>;
  function DefaultProfiles() : TArray<string>;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property CommunicationSpeed: TBaudRate read FCommunicationSpeed write FCommunicationSpeed;

  property InitialisationStrings: TObjectList<TGXDLMSModemInitialisation> read FInitialisationStrings;

  property ModemProfile: Tarray<string> read FModemProfile write FModemProfile;

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

constructor TGXDLMSModemConfiguration.Create;
begin
  inherited Create(TObjectType.otModemConfiguration, '0.0.2.0.0.255', 0);
  FInitialisationStrings := TObjectList<TGXDLMSModemInitialisation>.Create;
  FCommunicationSpeed := TBaudRate.Baudrate300;
  FModemProfile := DefaultProfiles();
end;

constructor TGXDLMSModemConfiguration.Create(ln: string);
begin
  inherited Create(TObjectType.otModemConfiguration, ln, 0);
  FInitialisationStrings := TObjectList<TGXDLMSModemInitialisation>.Create;
  FCommunicationSpeed := TBaudRate.Baudrate300;
  FModemProfile := DefaultProfiles();
end;

constructor TGXDLMSModemConfiguration.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otModemConfiguration, ln, 0);
  FInitialisationStrings := TObjectList<TGXDLMSModemInitialisation>.Create;
  FCommunicationSpeed := TBaudRate.Baudrate300;
  FModemProfile := DefaultProfiles();
end;

destructor TGXDLMSModemConfiguration.Destroy;
begin
  inherited;
  FModemProfile := Nil;
  FreeAndNil(FInitialisationStrings);
end;

function TGXDLMSModemConfiguration.DefaultProfiles() : TArray<string>;
begin
  result := TArray<string>.Create('OK', 'CONNECT', 'RING', 'NO CARRIER',
        'ERROR', 'CONNECT 1200', 'NO DIAL TONE',
        'BUSY', 'NO ANSWER', 'CONNECT 600', 'CONNECT 2400',
        'CONNECT 4800', 'CONNECT 9600',
        'CONNECT 14 400', 'CONNECT 28 800', 'CONNECT 33 600', 'CONNECT 56 000');
end;


function TGXDLMSModemConfiguration.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FCommunicationSpeed),
            TValue.From(FInitialisationStrings), TValue.From(FModemProfile));
end;

function TGXDLMSModemConfiguration.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //CommunicationSpeed
    if All or Not IsRead(2) Then
      items.Add(2);
    //InitialisationStrings
    if All or Not IsRead(3) Then
      items.Add(3);
    //ModemProfile
    if All or Not IsRead(4) Then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSModemConfiguration.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSModemConfiguration.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSModemConfiguration.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 3 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSModemConfiguration.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  cnt : Integer;
  it : TGXDLMSModemInitialisation;
  str : string;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if (e.Index = 2) then
  begin
    Result := Integer(FCommunicationSpeed);
  end
  else if e.Index = 3 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      //Add count
      cnt := FInitialisationStrings.Count;
      TGXCommon.SetObjectCount(cnt, data);
      if cnt <> 0 Then
      begin
        for it in FInitialisationStrings do
        begin
          data.Add(Integer(TDataType.dtStructure));
          data.Add(3); //Count
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(it.Request)));
          TGXCommon.SetData(data, TDataType.dtOctetString, TGXCommon(it.Response));
          TGXCommon.SetData(data, TDataType.dtUInt16, it.Delay);
        end
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 4 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      //Add count
      cnt := 0;
      if ModemProfile <> Nil Then
        cnt := Length(FModemProfile);

      TGXCommon.SetObjectCount(cnt, data);
      if cnt <> 0 Then
      begin
        for str in ModemProfile do
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(str)));
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSModemConfiguration.SetValue(e: TValueEventArgs);
var
  it : TValue;
  item : TGXDLMSModemInitialisation;
  strs : TList<string>;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FCommunicationSpeed := TBaudRate(e.Value.AsInteger);
  end
  else if e.Index = 3 Then
  begin
    FInitialisationStrings.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
      begin
        item := TGXDLMSModemInitialisation.Create();
        try
          item.Request := TGXCommon.ChangeType(it.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
          item.Response := TGXCommon.ChangeType(it.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtString).ToString();
          if it.GetArrayLength > 2 Then
            item.Delay := it.GetArrayElement(2).AsType<TValue>.AsInteger;
        except
          item.Free;
          raise;
        end;
        FInitialisationStrings.Add(item);
      end;
    end;
  end
  else if e.Index = 4 Then
  begin
    FModemProfile := Nil;
    strs := TList<string>.Create;
    try
      if Not e.Value.IsEmpty Then
      begin
        for it in e.Value.AsType<TArray<TValue>> do
          strs.Add(TGXCommon.ChangeType(it.AsType<TBytes>, TDataType.dtString).ToString());
      end;
      FModemProfile := strs.ToArray();
    finally
      FreeAndNil(strs);
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSModemConfiguration.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

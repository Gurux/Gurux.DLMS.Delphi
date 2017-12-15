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

unit Gurux.DLMS.Objects.GXDLMSPushSetup;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.GXDLMSPushObject,
Gurux.DLMS.Objects.GXSendDestinationAndMethod,
Gurux.DLMS.Objects.ServiceType, Gurux.DLMS.Objects.MessageType;

type
TGXDLMSPushSetup = class(TGXDLMSObject)
  FPushObjectList : TObjectList<TGXDLMSPushObject>;
  FSendDestinationAndMethod : TGXSendDestinationAndMethod;
  FCommunicationWindow : TList<TPair<TGXDateTime, TGXDateTime>>;
  FRandomisationStartInterval : WORD;
  FNumberOfRetries : byte;
  FRepetitionDelay : WORD;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  destructor Destroy;override;

  property PushObjectList: TObjectList<TGXDLMSPushObject> read FPushObjectList;
  property SendDestinationAndMethod: TGXSendDestinationAndMethod read FSendDestinationAndMethod;
  property CommunicationWindow: TList<TPair<TGXDateTime, TGXDateTime>> read FCommunicationWindow;
  property RandomisationStartInterval: WORD read FRandomisationStartInterval write FRandomisationStartInterval;
  property NumberOfRetries: byte read FNumberOfRetries write FNumberOfRetries;
  property RepetitionDelay: WORD read FRepetitionDelay write FRepetitionDelay;

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

constructor TGXDLMSPushSetup.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSPushSetup.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSPushSetup.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otPushSetup, ln, 0);
  FPushObjectList := TObjectList<TGXDLMSPushObject>.Create();
  FSendDestinationAndMethod := TGXSendDestinationAndMethod.Create();
  FCommunicationWindow := TList<TPair<TGXDateTime, TGXDateTime>>.Create();
end;

destructor TGXDLMSPushSetup.Destroy;
begin
  inherited;
  FreeAndNil(FPushObjectList);
  FreeAndNil(FSendDestinationAndMethod);
  FreeAndNil(FCommunicationWindow);
end;

function TGXDLMSPushSetup.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FPushObjectList,
            FSendDestinationAndMethod, FCommunicationWindow,
            FRandomisationStartInterval, FNumberOfRetries, FRepetitionDelay);
end;

function TGXDLMSPushSetup.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //PushObjectList
  if CanRead(2) then
    items.Add(2);

  //SendDestinationAndMethod
  if (CanRead(3)) then
    items.Add(3);
  //CommunicationWindow
  if (CanRead(4)) then
    items.Add(4);

  //RandomisationStartInterval
  if (CanRead(5)) then
    items.Add(5);

  //NumberOfRetries
  if (CanRead(6)) then
    items.Add(6);

  //RepetitionDelay
  if (CanRead(7)) then
    items.Add(7);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSPushSetup.GetAttributeCount: Integer;
begin
  Result := 7;
end;

function TGXDLMSPushSetup.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSPushSetup.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
    Result := TDataType.dtArray
  else if index = 3 Then
    Result := TDataType.dtStructure
  else if index = 4 Then
    Result := TDataType.dtArray
  else if index = 5 Then
    Result := TDataType.dtUInt16
  else if index = 6 Then
    Result := TDataType.dtUInt8
  else if index = 7 Then
    Result := TDataType.dtUInt16
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

function TGXDLMSPushSetup.GetValue(e: TValueEventArgs): TValue;
begin
  if (e.Index = 1) then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName))
  else if e.Index = 2 Then
    Result := FPushObjectList
  else if e.Index = 3 Then
    Result := FSendDestinationAndMethod
  else if e.Index = 4 Then
    Result := FCommunicationWindow
  else if e.Index = 5 Then
    Result := FRandomisationStartInterval
  else if e.Index = 6 Then
    Result := FNumberOfRetries
  else if e.Index = 7 Then
    Result := FRepetitionDelay
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSPushSetup.SetValue(e: TValueEventArgs);
var
  it : TValue;
  tmp : TArray<TValue>;
  obj : TGXDLMSPushObject;
  starttm, endtm : TGXDateTime;
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
      PushObjectList.Clear();
      if e.Value.IsType<TArray<TValue>> Then
      begin
          for it in e.Value.AsType<TArray<TValue>> do
          begin
              tmp := it.AsType<TArray<TValue>>();
              obj := TGXDLMSPushObject.Create();
              obj.&Type := TObjectType(tmp[0].AsInteger);
              obj.LogicalName := TGXCommon.ChangeType(tmp[1].AsType<TBytes>, TDataType.dtOctetString).ToString();
              obj.AttributeIndex := tmp[2].AsInteger;
              obj.DataIndex := tmp[3].AsInteger;
              PushObjectList.Add(obj);
          end;
      end
  end
  else if e.Index = 3 Then
  begin
      if e.Value.IsType<TArray<TValue>>() Then
      begin
        tmp := e.Value.AsType<TArray<TValue>>();
        SendDestinationAndMethod.Service := TServiceType(tmp[0].AsInteger);
        SendDestinationAndMethod.Destination := TEncoding.ASCII.GetString(tmp[1].AsType<TBytes>);
        SendDestinationAndMethod.Message := TMessageType(tmp[2].AsInteger);
      end;
  end
  else if e.Index = 4 Then
  begin
    FCommunicationWindow.Clear();
    if e.Value.IsType<TArray<TValue>>() Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
      begin
          tmp := it.AsType<TArray<TValue>>();
          starttm := TGXCommon.ChangeType(tmp[0].AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
          endtm := TGXCommon.ChangeType(tmp[1].AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
          CommunicationWindow.Add(TPair<TGXDateTime, TGXDateTime>.Create(starttm, endtm));
      end;
    end;
  end
  else if e.Index = 5 Then
    FRandomisationStartInterval := e.Value.AsInteger
  else if e.Index = 6 Then
    FNumberOfRetries := e.Value.AsInteger
  else if e.Index = 7 Then
    FRepetitionDelay := e.Value.AsInteger
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSPushSetup.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

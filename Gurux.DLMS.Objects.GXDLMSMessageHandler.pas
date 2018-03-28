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

unit Gurux.DLMS.Objects.GXDLMSMessageHandler;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.GXDLMSScriptAction;

type
TGXDLMSMessageHandler = class(TGXDLMSObject)
  FListeningWindow : TList<TPair<TGXDateTime, TGXDateTime>>;
  FAllowedSenders : TArray<String>;
  FSendersAndActions : TList<TPair<String, TPair<Integer, TGXDLMSScriptAction>>>;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property ListeningWindow : TList<TPair<TGXDateTime, TGXDateTime>> read FListeningWindow;
  property AllowedSenders : TArray<String> read FAllowedSenders write FAllowedSenders;
  property SendersAndActions : TList<TPair<String, TPair<Integer, TGXDLMSScriptAction>>> read FSendersAndActions write FSendersAndActions;

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

constructor TGXDLMSMessageHandler.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSMessageHandler.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSMessageHandler.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otMessageHandler, ln, 0);
  FListeningWindow := TList<TPair<TGXDateTime, TGXDateTime>>.Create();
  FSendersAndActions := TList<TPair<String, TPair<Integer, TGXDLMSScriptAction>>>.Create();
end;

function TGXDLMSMessageHandler.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FListeningWindow,
  TValue.From(FAllowedSenders), FSendersAndActions);
end;

function TGXDLMSMessageHandler.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //ListeningWindow
  if CanRead(2) Then
    items.Add(2);

  //AllowedSenders
  if CanRead(3) Then
    items.Add(3);

  //SendersAndActions
  if CanRead(4) Then
    items.Add(4);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSMessageHandler.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSMessageHandler.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSMessageHandler.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  //ListeningWindow
  else if index = 2 Then
    Result := TDataType.dtArray
  //AllowedSenders
  else if index = 3 Then
    Result := TDataType.dtArray
  //SendersAndActions
  else if index = 4 Then
    Result := TDataType.dtArray
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

function TGXDLMSMessageHandler.GetValue(e: TValueEventArgs): TValue;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
    Result := FListeningWindow
  else if e.Index = 3 Then
    Result := TValue.From(FAllowedSenders)
  else if e.Index = 4 Then
    Result := TValue.From(FSendersAndActions)
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSMessageHandler.SetValue(e: TValueEventArgs);
var
  it : TValue;
  tmp, tmp2 : TArray<TValue>;
  starttm, endtm : TGXDateTime;
  strs : TList<String>;
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
      ListeningWindow.Clear();
      if e.Value.IsType<TArray<TValue>>() Then
      begin
          for it in e.Value.AsType<TArray<TValue>> do
          begin
              tmp := it.AsType<TArray<TValue>>();
              starttm := TGXCommon.ChangeType(tmp[0].AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
              endtm := TGXCommon.ChangeType(tmp[1].AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
              ListeningWindow.Add(TPair<TGXDateTime, TGXDateTime>.Create(starttm, endtm));
          end;
      end;
  end
  else if e.Index = 3 Then
  begin
      if e.Value.IsType<TArray<TValue>>() Then
      begin
          strs := TList<String>.Create();
          for it in e.Value.AsType<TArray<TValue>> do
            strs.Add(TEncoding.ASCII.GetString(it.AsType<TBytes>));

          AllowedSenders := strs.ToArray();
      end
      else
        AllowedSenders := TArray<String>.Create();
  end
  else if e.Index = 4 Then
  begin
      SendersAndActions.Clear();
      if e.Value.IsType<TArray<TValue>>() Then
      begin
          for it in e.Value.AsType<TArray<TValue>> do
          begin
              tmp := it.AsType<TArray<TValue>>();
//              string id = ASCIIEncoding.ASCII.GetString((byte[])tmp[0]);
              tmp2 := tmp[1].AsType<TArray<TValue>>();
              {TODO:
              KeyValuePair<int, GXDLMSScriptAction> executed_script = new KeyValuePair<int, GXDLMSScriptAction>(Convert.ToInt32(tmp2[1], tmp2[2]));
              SendersAndActions.Add(new KeyValuePair<string, KeyValuePair<int, GXDLMSScriptAction>>(id, tmp[1] as GXDateTime));
              }
          end;
      end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSMessageHandler.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

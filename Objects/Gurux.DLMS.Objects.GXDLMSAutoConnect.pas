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

unit Gurux.DLMS.Objects.GXDLMSAutoConnect;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.AutoConnectMode, GXByteBuffer,
Gurux.DLMS.IGXDLMSClient;

type
TGXDLMSAutoConnect = class(TGXDLMSObject)
  FMode: TAutoConnectMode;
  FDestinations: TArray<string>;
  FRepetitions, FRepetitionDelay : Integer;
  FCallingWindow : TList<TPair<TGXDateTime, TGXDateTime>>;

  destructor Destroy; override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  /// Defines the mode controlling the auto dial functionality concerning the
  /// timing, the message type to be sent and the infrastructure to be used.
  property Mode: TAutoConnectMode read FMode write FMode;

  //The maximum number of trials in the case of unsuccessful dialling attempts.
  property Repetitions: Integer read FRepetitions write FRepetitions;

  // The time delay, expressed in seconds until an unsuccessful dial attempt can be repeated.
  property RepetitionDelay: Integer read FRepetitionDelay write FRepetitionDelay;

  //Contains the start and end date/time stamp when the window becomes active.
  property CallingWindow: TList<TPair<TGXDateTime, TGXDateTime>> read FCallingWindow write FCallingWindow;

  /// Contains the list of destinations (for example phone numbers, email
  /// addresses or their combinations) where the message(s) have to be sent
  /// under certain conditions. The conditions and their link to the elements of
  /// the array are not defined here.
  property Destinations: TArray<string> read FDestinations write FDestinations;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;

  //Initiates the connection process.
  function Connect(client: IGXDLMSClient) : TArray<TBytes>;
end;

implementation

constructor TGXDLMSAutoConnect.Create;
begin
  Create('0.0.2.1.0.255', 0);
end;

constructor TGXDLMSAutoConnect.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSAutoConnect.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otAutoConnect, ln, 0);
  FCallingWindow := TList<TPair<TGXDateTime, TGXDateTime>>.Create();
end;

destructor TGXDLMSAutoConnect.Destroy;
var
  it : TPair<TGXDateTime, TGXDateTime>;
begin
  inherited;
  if FCallingWindow <> Nil then
  begin
    while FCallingWindow.Count <> 0 do
    begin
      it := FCallingWindow[0];
      FCallingWindow.Remove(it);
      FreeAndNil(it.Key);
      FreeAndNil(it.Value);
    end;
    FreeAndNil(FCallingWindow);
  end;
end;

function TGXDLMSAutoConnect.Connect(client: IGXDLMSClient) : TArray<TBytes>;
begin
  Result := client.Method(Self, 1, 0, TDataType.dtInt8);
end;

function TGXDLMSAutoConnect.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FMode), FRepetitions,
            FRepetitionDelay, FCallingWindow, TValue.From(FDestinations));
end;

function TGXDLMSAutoConnect.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if (string.IsNullOrEmpty(LogicalName)) then
      items.Add(1);

    //Mode
    if CanRead(2) Then
      items.Add(2);

    //Repetitions
    if CanRead(3) Then
      items.Add(3);

    //RepetitionDelay
    if CanRead(4) Then
      items.Add(4);

    //CallingWindow
    if CanRead(5) Then
      items.Add(5);

    //Destinations
    if CanRead(6) Then
      items.Add(6);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSAutoConnect.GetAttributeCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSAutoConnect.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSAutoConnect.GetDataType(index: Integer): TDataType;
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
    Result := TDataType.dtUInt8;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtUInt16;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtArray;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSAutoConnect.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TPair<TGXDateTime, TGXDateTime>;
  str : string;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(FMode);
  end
  else if e.Index = 3 Then
  begin
    Result := FRepetitions;
  end
  else if e.Index = 4 Then
  begin
    Result := FRepetitionDelay;
  end
  else if e.Index = 5 Then
  begin
    data := TGXByteBuffer.Create();
    try
      data.Add(Integer(TDataType.dtArray));
      //Add count
      TGXCommon.SetObjectCount(CallingWindow.Count, data);
      for it in CallingWindow do
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(2); //Count
        TGXCommon.SetData(data, TDataType.dtOctetString, it.Key); //start_time
        TGXCommon.SetData(data, TDataType.dtOctetString, it.Value); //end_time
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else if e.Index = 6 Then
  begin
    data := TGXByteBuffer.Create();
    try
      data.Add(Integer(TDataType.dtArray));
      if FDestinations = Nil Then
      begin
        //Add count
        TGXCommon.SetObjectCount(0, data);
      end
      else
      begin
        //Add count
        TGXCommon.SetObjectCount(Length(Destinations), data);
        for str in Destinations do
            TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(str))); //destination
      end;
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSAutoConnect.SetValue(e: TValueEventArgs);
var
  start1, end1 : TGXDateTime;
  item : TValue;
  items : TList<string>;
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FMode := TAutoConnectMode(e.Value.AsInteger);
  end
  else if e.Index = 3 Then
  begin
    FRepetitions := e.Value.AsInteger;
  end
  else if e.Index = 4 Then
  begin
    FRepetitionDelay := e.Value.AsInteger;
  end
  else if e.Index = 5 Then
  begin
    FCallingWindow.Clear();
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        start1 := TGXCommon.ChangeType(item.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        end1 := TGXCommon.ChangeType(item.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        FCallingWindow.Add(TPair<TGXDateTime, TGXDateTime>.Create(start1, end1));
      end
    end;
  end
  else if e.Index = 6 Then
  begin
    Destinations := Nil;
    if Not e.Value.IsEmpty Then
    begin
      items := TList<string>.Create;
      try
        for item in e.Value.AsType<TArray<TValue>> do
          items.Add(TGXCommon.ChangeType(item.AsType<TBytes>, TDataType.dtString).ToString());

        FDestinations := items.ToArray();
      finally
        FreeAndNil(items);
      end;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSAutoConnect.Invoke(e: TValueEventArgs): TBytes;
begin
  if e.Index <> 1 then
    raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

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

unit Gurux.DLMS.Objects.GXDLMSAutoAnswer;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.AutoConnectMode, Gurux.DLMS.AutoAnswerStatus,
GXByteBuffer;

type
TGXDLMSAutoAnswer = class(TGXDLMSObject)
  FMode: TAutoConnectMode;
  FStatus : TAutoAnswerStatus;
  FNumberOfCalls, FNumberOfRingsInListeningWindow, FNumberOfRingsOutListeningWindow : Integer;
  FListeningWindow : TList<TPair<TGXDateTime, TGXDateTime>>;

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property Mode: TAutoConnectMode read FMode write FMode;

  property ListeningWindow: TList<TPair<TGXDateTime, TGXDateTime>> read FListeningWindow;

  property Status: TAutoAnswerStatus read FStatus write FStatus;

  property NumberOfCalls: Integer read FNumberOfCalls write FNumberOfCalls;

  //Number of rings within the window defined by ListeningWindow.
  property NumberOfRingsInListeningWindow: Integer read FNumberOfRingsInListeningWindow write FNumberOfRingsInListeningWindow;

  //Number of rings outside the window defined by ListeningWindow.
  property NumberOfRingsOutListeningWindow: Integer read FNumberOfRingsOutListeningWindow write FNumberOfRingsOutListeningWindow;

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

constructor TGXDLMSAutoAnswer.Create;
begin
  Create('0.0.2.2.0.255', 0);
end;

constructor TGXDLMSAutoAnswer.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSAutoAnswer.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otAutoAnswer, ln, 0);
  FListeningWindow := TList<TPair<TGXDateTime, TGXDateTime>>.Create();
end;

destructor TGXDLMSAutoAnswer.Destroy;
var
  it : TPair<TGXDateTime, TGXDateTime>;
begin
  inherited;
  if FListeningWindow <> Nil then
  begin
    while FListeningWindow.Count <> 0 do
    begin
      it := FListeningWindow[0];
      FListeningWindow.Remove(it);
      FreeAndNil(it.Key);
      FreeAndNil(it.Value);
    end;
    FreeAndNil(FListeningWindow);
  end;
end;

function TGXDLMSAutoAnswer.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, Integer(FMode), FListeningWindow, TValue.From(FStatus),
                FNumberOfCalls,
                FNumberOfRingsInListeningWindow.ToString + '/' + FNumberOfRingsOutListeningWindow.ToString());
end;

function TGXDLMSAutoAnswer.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);

  //Mode is static and read only once.
    if Not IsRead(2) Then
      items.Add(2);

    //ListeningWindow is static and read only once.
    if All or Not IsRead(3) Then
        items.Add(3);

    //Status is not static.
    if All or CanRead(4) Then
      items.Add(4);

    //NumberOfCalls is static and read only once.
    if All or Not IsRead(5) Then
      items.Add(5);

    //NumberOfRingsInListeningWindow is static and read only once.
    if All or Not IsRead(6) Then
      items.Add(6);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSAutoAnswer.GetAttributeCount: Integer;
begin
  Result := 6;
end;

function TGXDLMSAutoAnswer.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSAutoAnswer.GetDataType(index: Integer): TDataType;
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
    Result := TDataType.dtArray;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtUInt8;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtStructure;
  end
  else if index = 7 Then
  begin
    if FVersion >= 2 then
      Result := TDataType.dtArray
    else
      raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSAutoAnswer.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TPair<TGXDateTime, TGXDateTime>;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := Integer(Mode);
  end
  else if e.Index = 3 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtArray));
      //Add count
      TGXCommon.SetObjectCount(ListeningWindow.Count, data);
      for it in ListeningWindow do
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
  else if e.Index = 4 Then
  begin
    Result := Integer(FStatus);
  end
  else if e.Index = 5 Then
  begin
    Result := FNumberOfCalls;
  end
  else if e.Index = 6 Then
  begin
    data := TGXByteBuffer.Create;
    try
      data.Add(Integer(TDataType.dtStructure));
      //Add count
      TGXCommon.SetObjectCount(2, data);
      TGXCommon.SetData(data, TDataType.dtUInt8, NumberOfRingsInListeningWindow);
      TGXCommon.SetData(data, TDataType.dtUInt8, NumberOfRingsOutListeningWindow);
      Result := TValue.From(data.ToArray());
    finally
      data.Free;
    end;
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSAutoAnswer.SetValue(e: TValueEventArgs);
var
  item : TValue;
  start1,  end1 : TGXDateTime;
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
    ListeningWindow.Clear();
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        start1 := TGXCommon.ChangeType(item.GetArrayElement(0).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        end1 := TGXCommon.ChangeType(item.GetArrayElement(1).AsType<TValue>.AsType<TBytes>, TDataType.dtDateTime).AsType<TGXDateTime>;
        FListeningWindow.Add(TPair<TGXDateTime, TGXDateTime>.Create(start1, end1));
      end;
    end;
  end
  else if e.Index = 4 Then
  begin
    FStatus := TAutoAnswerStatus(e.Value.AsInteger);
  end
  else if e.Index = 5 Then
  begin
    FNumberOfCalls := e.Value.AsInteger;
  end
  else if e.Index = 6 Then
  begin
    NumberOfRingsInListeningWindow := 0;
    NumberOfRingsOutListeningWindow := 0;
    if Not e.Value.IsEmpty Then
    begin
      FNumberOfRingsInListeningWindow := e.Value.GetArrayElement(0).AsType<TValue>.AsInteger;
      FNumberOfRingsOutListeningWindow := e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
    end;
  end
  else
   raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSAutoAnswer.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

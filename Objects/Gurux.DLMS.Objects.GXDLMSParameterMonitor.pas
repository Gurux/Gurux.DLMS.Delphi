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

unit Gurux.DLMS.Objects.GXDLMSParameterMonitor;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDateTime, Gurux.DLMS.GXDLMSTarget, GXByteBuffer;

type
TGXDLMSParameterMonitor = class(TGXDLMSObject)
    //Changed parameter.
    FChangedParameter: TGXDLMSTarget;

    //Capture time.
    FCaptureTime: TGXDateTime;

    // Changed Parameter
    FParameters: TObjectList<TGXDLMSTarget>;

  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  destructor Destroy; override;

  //Changed parameter.
  property ChangedParameter: TGXDLMSTarget read FChangedParameter;

  //Capture time.
  property CaptureTime: TGXDateTime read FCaptureTime write FCaptureTime;

  // Changed Parameter
  property Parameters: TObjectList<TGXDLMSTarget> read FParameters;

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

uses GXObjectFactory;

constructor TGXDLMSParameterMonitor.Create;
begin
  Create('0.0.16.2.0.255', 0);
end;

constructor TGXDLMSParameterMonitor.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSParameterMonitor.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otParameterMonitor, ln, sn);
  FChangedParameter := TGXDLMSTarget.Create;
  FParameters := TObjectList<TGXDLMSTarget>.Create;
end;

destructor TGXDLMSParameterMonitor.Destroy;
begin
  inherited;
  FreeAndNil(FCaptureTime);
  FreeAndNil(FParameters);
  FreeAndNil(FChangedParameter);
end;

function TGXDLMSParameterMonitor.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FChangedParameter, FCaptureTime,
    FParameters);
end;

function TGXDLMSParameterMonitor.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //ChangedParameter
    if All or CanRead(2) Then
      items.Add(2);
    //CaptureTime
    if All or CanRead(3) Then
      items.Add(3);
    //Parameters
    if All or CanRead(4) Then
      items.Add(4);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSParameterMonitor.GetAttributeCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSParameterMonitor.GetMethodCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSParameterMonitor.GetDataType(index: Integer): TDataType;
begin
 case index of
    1: Result := TDataType.dtOctetString;
    2: Result := TDataType.dtStructure;
    3: Result := TDataType.dtOctetString;
    4: Result := TDataType.dtArray;
  else
    raise Exception.Create('GetDataType failed. Invalid attribute index.');
 end;
end;

function TGXDLMSParameterMonitor.GetValue(e: TValueEventArgs): TValue;
var
  data: TGXByteBuffer;
  it: TGXDLMSTarget;
  emptyLn : array[0..5] of byte;
begin
  case e.Index Of
    1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
    2:
    begin
      data := TGXByteBuffer.Create();
      try
        data.SetUInt8(Integer(TDataType.dtStructure));
        data.SetUInt8(4);
        if FChangedParameter = Nil Then
        begin
          TGXCommon.SetData(data, TDataType.dtUInt16, 0);
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(emptyLn));
          TGXCommon.SetData(data, TDataType.dtInt8, 1);
          TGXCommon.SetData(data, TDataType.dtNone, Nil);
        end
        else
        begin
          TGXCommon.SetData(data, TDataType.dtUInt16, Integer(ChangedParameter.Target.ObjectType));
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes(ChangedParameter.Target.LogicalName)));
          TGXCommon.SetData(data, TDataType.dtInt8, ChangedParameter.AttributeIndex);
          TGXCommon.SetData(data, TGXCommon.GetDLMSDataType(ChangedParameter.Value), ChangedParameter.Value);
        end;
        Result := TValue.From(data.ToArray());
      finally
        freeAndNil(data);
      end;
    end;
    3: Result := FCaptureTime;
    4:
    begin
      data := TGXByteBuffer.Create();
      try
        data.SetUInt8(Integer(TDataType.dtArray));
        if FParameters = Nil Then
          data.SetUInt8(0)
        else
        begin
          data.SetUInt8(FParameters.Count);
          for it in FParameters do
          begin
            data.SetUInt8(Integer(TDataType.dtStructure));
            data.SetUInt8(3);
            TGXCommon.SetData(data, TDataType.dtUInt16, Integer(it.Target.ObjectType));
            TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.LogicalNameToBytes(it.Target.LogicalName)));
            TGXCommon.SetData(data, TDataType.dtInt8, it.AttributeIndex);
          end;
        end;
        Result := TValue.From(data.ToArray());
      finally
        freeAndNil(data);
      end;
    end
    else
      raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSParameterMonitor.SetValue(e: TValueEventArgs);
var
  ot: WORD;
  tmp: TValue;
  t: TGXDLMSTarget;
  ln: string;
  arr : TArray<TValue>;
begin
case e.Index of
  1: FLogicalName := TGXCommon.ToLogicalName(e.Value);
  2:
  begin
    FChangedParameter.Clear;
    arr := e.Value.AsType<TArray<TValue>>;
    if e.Value.GetArrayLength <> 4 Then
      raise Exception.Create('Invalid structure format.');

    ot := arr[0].AsInteger;
    ln := TGXCommon.ToLogicalName(arr[1]);
    FChangedParameter.Target := e.Settings.Objects.FindByLN(TObjectType(ot), ln);
    if FChangedParameter.Target = Nil Then
    begin
      FChangedParameter.Target := TGXObjectFactory.CreateObject(ot);
      FChangedParameter.Target.LogicalName := ln;
    end;
    FChangedParameter.AttributeIndex := arr[2].AsInteger;
    FChangedParameter.Value := arr[3];
  end;
  3:
  begin
    FreeAndNil(FCaptureTime);
    if e.Value.IsEmpty Then
      FCaptureTime := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
      begin
        if e.Value.IsType<TBytes> Then
          e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
        FCaptureTime := e.Value.AsType<TGXDateTime>;
      end;
  end;
  4:
  begin
    FParameters.Clear();
    if Not e.Value.IsEmpty Then
      for tmp in e.Value.AsType<TArray<TValue>> do
      begin
          if tmp.GetArrayLength <> 3 Then
            raise Exception.Create('Invalid structure format.');

          arr := tmp.AsType<TArray<TValue>>;

          t := TGXDLMSTarget.Create();
          try
            ot := arr[0].AsInteger;
            ln := TGXCommon.ToLogicalName(arr[1]);
            t.Target := e.Settings.Objects.FindByLN(TObjectType(ot), ln);
            if t.Target = Nil Then
            begin
              t.Target := TGXObjectFactory.CreateObject(ot);
              t.Target.LogicalName := ln;
            end;
            t.AttributeIndex := arr[2].AsInteger;
          except
            t.Free;
            raise;
          end;
          Parameters.Add(t);
      end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;
end;

function TGXDLMSParameterMonitor.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

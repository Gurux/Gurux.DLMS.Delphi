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

unit Gurux.DLMS.Objects.GXDLMSSapAssignment;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject, GXByteBuffer;

type
TGXDLMSSapAssignment = class(TGXDLMSObject)
  FSapAssignmentList: TList<TPair<Word, string>>;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;

  public

  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property SapAssignmentList: TList<TPair<Word, string>> read FSapAssignmentList;

  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead: TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
end;

implementation

constructor TGXDLMSSapAssignment.Create;
begin
  inherited Create(TObjectType.otSapAssignment, '0.0.41.0.0.255', 0);
  FSapAssignmentList := TList<TPair<Word, string>>.Create();
end;

constructor TGXDLMSSapAssignment.Create(ln: string);
begin
  inherited Create(TObjectType.otSapAssignment, ln, 0);
  FSapAssignmentList := TList<TPair<Word, string>>.Create();
end;

constructor TGXDLMSSapAssignment.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otSapAssignment, ln, 0);
  FSapAssignmentList := TList<TPair<Word, string>>.Create();
end;

destructor TGXDLMSSapAssignment.Destroy;
begin
  inherited;
  FreeAndNil(FSapAssignmentList);
end;


function TGXDLMSSapAssignment.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FSapAssignmentList);
end;

function TGXDLMSSapAssignment.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //SapAssignmentList
  if Not IsRead(2) Then
    items.Add(2);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSSapAssignment.GetAttributeCount: Integer;
begin
  Result := 2;
end;

function TGXDLMSSapAssignment.GetMethodCount: Integer;
begin
  Result := 1;
end;

function TGXDLMSSapAssignment.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSSapAssignment.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  it : TPair<Word, string>;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    data := TGXByteBuffer.Create;
    if SapAssignmentList = Nil Then
      TGXCommon.SetObjectCount(0, data)
    else
    begin
      data.Add(Integer(TDataType.dtArray));
      //Add count
      TGXCommon.SetObjectCount(FSapAssignmentList.Count, data);
      for it in FSapAssignmentList do
      begin
          data.Add(Integer(TDataType.dtStructure));
          data.Add(2); //Count
          TGXCommon.SetData(data, TDataType.dtUInt16, it.Key);
          TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(it.Value)));
      end;
    end;
    Result := TValue.From(data.ToArray());
  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSSapAssignment.SetValue(e: TValueEventArgs);
var
  item, tmp : TValue;
  str : string;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if (e.Index = 2) then
  begin
    FSapAssignmentList.Clear();
    if Not e.Value.IsEmpty Then
    begin
        for item in e.Value.AsType<TArray<TValue>> do
        begin
          tmp := item.GetArrayElement(1).AsType<TValue>;
          if tmp.IsType<TBytes> Then
            str := TGXCommon.ChangeType(tmp.AsType<TBytes>, TDataType.dtString).ToString()
          else
            str := tmp.ToString;
          FSapAssignmentList.Add(TPair<Word, string>.Create(item.GetArrayElement(0).AsType<TValue>.AsInteger, str));
        end;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSSapAssignment.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

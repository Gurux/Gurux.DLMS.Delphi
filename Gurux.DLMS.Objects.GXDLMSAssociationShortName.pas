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

unit Gurux.DLMS.Objects.GXDLMSAssociationShortName;

interface

uses GXCommon, SysUtils, Rtti, GXObjectFactory, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXAttributeCollection,
Gurux.DLMS.AccessMode, Gurux.DLMS.MethodAccessMode, GXByteBuffer;

type
TGXDLMSAssociationShortName = class(TGXDLMSObject)
  FObjectList: TGXDLMSObjectCollection;
  FSecuritySetupReference : TValue;

  procedure UpdateAccessRights(buff : TArray<TValue>);

  procedure GetAccessRights(item : TGXDLMSObject; data : TGXByteBuffer);

  destructor Destroy; override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  property ObjectList: TGXDLMSObjectCollection read FObjectList;

  property SecuritySetupReference: TValue read FSecuritySetupReference write FSecuritySetupReference;

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

constructor TGXDLMSAssociationShortName.Create;
begin
  Create('0.0.40.0.0.255', $FA00);
end;

constructor TGXDLMSAssociationShortName.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSAssociationShortName.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otAssociationShortName, ln, 0);
  FObjectList := TGXDLMSObjectCollection.Create(False);
  FVersion := 2;
end;

destructor TGXDLMSAssociationShortName.Destroy;
begin
  inherited;
  FreeAndNil(FObjectList);
end;

function TGXDLMSAssociationShortName.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName,
                  FObjectList, Nil,
                  FSecuritySetupReference);
end;

function TGXDLMSAssociationShortName.GetAttributeIndexToRead: TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  //LN is static and read only once.
  if (string.IsNullOrEmpty(LogicalName)) then
    items.Add(1);

  //ObjectList is static and read only once.
  if Not IsRead(2) Then
    items.Add(2);

  if FVersion > 1 Then
  begin
    //AccessRightsList is static and read only once.
    if Not IsRead(3) Then
      items.Add(3);

    //SecuritySetupReference is static and read only once.
    if Not IsRead(4) Then
      items.Add(4);
  end;

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSAssociationShortName.GetAttributeCount: Integer;
begin
 if FVersion < 2 Then
   Result := 2
 else
   Result := 4;
end;

function TGXDLMSAssociationShortName.GetMethodCount: Integer;
begin
  Result := 8;
end;

procedure TGXDLMSAssociationShortName.GetAccessRights(item : TGXDLMSObject; data : TGXByteBuffer);
var
  it : TGXDLMSAttributeSettings;
begin
  data.Add(Integer(TDataType.dtStructure));
  data.Add(3);
  TGXCommon.SetData(data, TDataType.dtUInt16, item.ShortName);
  data.Add(Integer(TDataType.dtArray));
  data.Add(item.FAttributes.Count);
  for it in item.FAttributes do
  begin
      data.Add(Integer(TDataType.dtStructure)); //attribute_access_item
      data.Add(3);
      TGXCommon.SetData(data, TDataType.dtInt8, it.Index);
      TGXCommon.SetData(data, TDataType.dtEnum, Integer(it.Access));
      TGXCommon.SetData(data, TDataType.dtNone, Nil);
  end;
  data.Add(Integer(TDataType.dtArray));
  data.Add(item.FMethodAttributes.Count);
  for it in item.FMethodAttributes do
  begin
      data.Add(Integer(TDataType.dtStructure)); //attribute_access_item
      data.Add(2);
      TGXCommon.SetData(data, TDataType.dtInt8, it.Index);
      TGXCommon.SetData(data, TDataType.dtEnum, Integer(it.MethodAccess));
  end
end;

function TGXDLMSAssociationShortName.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
    Result := TDataType.dtArray;
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

function TGXDLMSAssociationShortName.GetValue(e: TValueEventArgs): TValue;
var
  data : TGXByteBuffer;
  cnt : Integer;
  it : TGXDLMSObject;
  lnExists : Boolean;
begin
  if (e.Index = 1) then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtArray));
    //Add count
    cnt := ObjectList.Count;
    TGXCommon.SetObjectCount(cnt, data);
    if cnt <> 0 then
    begin
      for it in FObjectList do
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(4); //Count
        TGXCommon.SetData(data, TDataType.dtInt16, it.ShortName); //base address.
        TGXCommon.SetData(data, TDataType.dtUInt16, Integer(it.ObjectType)); //ClassID
        TGXCommon.SetData(data, TDataType.dtUInt8, 0); //Version
        TGXCommon.SetData(data, TDataType.dtOctetString, it.LogicalName); //LN
      end;
      if FObjectList.FindBySN(ShortName) = Nil Then
      begin
        data.Add(Integer(TDataType.dtStructure));
        data.Add(4); //Count
        TGXCommon.SetData(data, TDataType.dtInt16, FShortName); //base address.
        TGXCommon.SetData(data, TDataType.dtUInt16, Integer(FObjectType)); //ClassID
        TGXCommon.SetData(data, TDataType.dtUInt8, 0); //Version
        TGXCommon.SetData(data, TDataType.dtOctetString, LogicalName); //LN
      end
    end;
    Result := TValue.From(data.ToArray());
  end
  else if e.Index = 3 Then
  begin
    lnExists := FObjectList.FindBySN(FShortName) <> Nil;
    //Add count
    cnt := ObjectList.Count;
    if Not lnExists Then
      cnt := cnt + 1;

    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtArray));
    TGXCommon.SetObjectCount(cnt, data);
    for it in FObjectList do
      GetAccessRights(it, data);

    if Not lnExists Then
      GetAccessRights(Self, data);
    Result := TValue.From(data.ToArray());
  end
  else if e.Index = 4 Then
  begin

  end
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure TGXDLMSAssociationShortName.UpdateAccessRights(buff : TArray<TValue>);
var
  obj : TGXDLMSObject;
  tmp, access, it : TValue;
  sn : Word;
  id, mode : Integer;
begin
  for access in buff do
  begin
      sn := access.GetArrayElement(0).AsType<TValue>.AsInteger;
      obj := FObjectList.FindBySN(sn);
      if obj <> Nil Then
      begin
        for it in access.GetArrayElement(1).AsType<TValue>.AsType<TArray<TValue>> do
        begin
          id := it.GetArrayElement(0).AsType<TValue>.AsInteger;
          mode := it.GetArrayElement(1).AsType<TValue>.AsInteger;
          obj.SetAccess(id, TAccessMode(mode));
        end;
        if access.GetArrayLength = 3 Then
          for it in access.GetArrayElement(2).AsType<TValue>.AsType<TArray<TValue>> do
          begin
            id := it.GetArrayElement(0).AsType<TValue>.AsInteger;
            tmp := it.GetArrayElement(1).AsType<TValue>;
            //If version is 0.
            if tmp.IsType<Boolean> then
            begin
               if tmp.AsBoolean then
                mode := 1
               else
                mode := 0
            end
            else //If version is 1.
              mode := tmp.AsInteger;
            obj.SetMethodAccess(id, TMethodAccessMode(mode));
          end;
      end;
  end;
end;

procedure TGXDLMSAssociationShortName.SetValue(e: TValueEventArgs);
var
  item : TValue;
  sn : Word;
  pos : Integer;
  ln : String;
  obj : TGXDLMSObject;
  it : TGXDLMSObject;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FObjectList.Clear();
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        sn := item.GetArrayElement(0).AsType<TValue>.AsInteger and $FFFF;
        //Skip tp := TObjectType(item.GetArrayElement(1).AsType<TValue>.AsInteger);
        //Skip version := item.GetArrayElement(2).AsType<TValue>.AsInteger;
        ln := TGXDLMSObject.toLogicalName(item.GetArrayElement(3).AsType<TValue>.AsType<TBytes>);
        obj := e.Settings.Objects.FindBySN(sn);
        if obj <> Nil Then
          FObjectList.Add(obj);
      end
    end;
  end
  else if e.Index = 3 Then
  begin
    if e.Value.IsEmpty Then
    begin
      for it in FObjectList do
      begin
        for pos := 1 to it.GetAttributeCount() do
          it.SetAccess(pos, TAccessMode.NoAccess);
      end
    end
    else
      UpdateAccessRights(e.Value.AsType<TArray<TValue>>);
  end
  else if e.Index = 4 Then
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSAssociationShortName.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

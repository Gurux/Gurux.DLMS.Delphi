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

unit Gurux.DLMS.Objects.GXDLMSAssociationLogicalName;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.AssociationStatus, Gurux.DLMS.GXAttributeCollection,
Gurux.DLMS.AccessMode, Gurux.DLMS.MethodAccessMode,
Gurux.DLMS.GXAuthenticationMechanismName,
Gurux.DLMS.GXApplicationContextName,
Gurux.DLMS.TGXxDLMSContextType,
GXByteBuffer,
Gurux.DLMS.IGXDLMSClient, Gurux.DLMS.Authentication,
Gurux.DLMS.Conformance;

type
TGXDLMSAssociationLogicalName = class(TGXDLMSObject)
  FObjectList: TGXDLMSObjectCollection;
  FSecuritySetupReference : string;
  FAssociationStatus : TAssociationStatus;
  FSecret : TBytes;
  FXDLMSContextInfo : TGXxDLMSContextType;
  FAuthenticationMechanismName : TGXAuthenticationMechanismName;
  FApplicationContextName : TGXApplicationContextName;
  FClientSAP : byte;
  FServerSAP : Word;

  destructor Destroy; override;

  private
  function GetObjects() : TBytes;
  procedure GetAccessRights(item : TGXDLMSObject; data : TGXByteBuffer);


  public
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;
  property ObjectList: TGXDLMSObjectCollection read FObjectList;

  // Updates secret.
  function UpdateSecret(client: IGXDLMSClient) : TArray<TBytes>;

  property ClientSAP: byte read FClientSAP write FClientSAP;

  property ServerSAP: Word read FServerSAP write FServerSAP;

  property ApplicationContextName: TGXApplicationContextName read FApplicationContextName;

  property XDLMSContextInfo: TGXxDLMSContextType read FXDLMSContextInfo;

  property AuthenticationMechanismName: TGXAuthenticationMechanismName read FAuthenticationMechanismName;

  property Secret: TBytes read FSecret write FSecret;

  property AssociationStatus: TAssociationStatus read FAssociationStatus write FAssociationStatus;

  property SecuritySetupReference: string read FSecuritySetupReference write FSecuritySetupReference;

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

uses GXObjectFactory;

constructor TGXDLMSAssociationLogicalName.Create;
begin
  Create('0.0.40.0.0.255', 0);
end;

constructor TGXDLMSAssociationLogicalName.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSAssociationLogicalName.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otAssociationLogicalName, ln, 0);
  FObjectList := TGXDLMSObjectCollection.Create(False);
  FApplicationContextName := TGXApplicationContextName.Create();
  FXDLMSContextInfo := TGXxDLMSContextType.Create();
  FAuthenticationMechanismName := TGXAuthenticationMechanismName.Create();
end;

destructor TGXDLMSAssociationLogicalName.Destroy;
begin
  inherited;
  FreeAndNil(FXDLMSContextInfo);
  FreeAndNil(FObjectList);
  FreeAndNil(FApplicationContextName);
  FreeAndNil(FAuthenticationMechanismName);
end;

// Updates secret.
function TGXDLMSAssociationLogicalName.UpdateSecret(client: IGXDLMSClient) : TArray<TBytes>;
begin
  if FAuthenticationMechanismName.MechanismId = TAuthentication.atNone Then
    raise EArgumentException.Create('Invalid authentication level in MechanismId.');
  if FAuthenticationMechanismName.MechanismId = TAuthentication.atHighGMAC Then
    raise EArgumentException.Create('HighGMAC secret is updated using Security setup.');

  if FAuthenticationMechanismName.MechanismId = TAuthentication.atLow Then
    Result := client.Write(Self, 7)
  else
    //Action is used to update High authentication password.
    Result := client.Method(Self, 2, TValue.From(FSecret), TDataType.dtArray);
end;

function TGXDLMSAssociationLogicalName.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FObjectList,
          IntToStr(FClientSAP) + '/' + IntToStr(FServerSAP),
          FApplicationContextName, FXDLMSContextInfo, FAuthenticationMechanismName, TValue.From(FSecret),
            Integer(FAssociationStatus), FSecuritySetupReference);
end;

function TGXDLMSAssociationLogicalName.GetAttributeIndexToRead: TArray<Integer>;
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

  //associated_partners_id is static and read only once.
  if Not IsRead(3) Then
    items.Add(3);

  //Application Context Name is static and read only once.
  if Not IsRead(4) Then
    items.Add(4);

  //xDLMS Context Info
  if Not IsRead(5) Then
    items.Add(5);

  // Authentication Mechanism Name
  if Not IsRead(6) Then
    items.Add(6);

  // Secret
  if Not IsRead(7) Then
    items.Add(7);

  // Association Status
  if Not IsRead(8) Then
    items.Add(8);

  //Security Setup Reference is from version 1.
  if (Version > 0) and (Not IsRead(9)) Then
    items.Add(9);

  Result := items.ToArray;
  FreeAndNil(items);
end;

function TGXDLMSAssociationLogicalName.GetAttributeCount: Integer;
begin
  //Security Setup Reference is from version 1.
  if FVersion > 0 Then
    Result := 9
  else
    Result := 9;
end;

function TGXDLMSAssociationLogicalName.GetMethodCount: Integer;
begin
  Result := 4;
end;

// Returns Association View.
function TGXDLMSAssociationLogicalName.GetObjects() : TBytes;
var
  stream : TGXByteBuffer;
  cnt : Integer;
  it : TGXDLMSObject;
begin
  stream := TGXByteBuffer.Create;
  stream.Add(Integer(TDataType.dtArray));
  //Add count
  cnt := FObjectList.Count;
  TGXCommon.SetObjectCount(cnt, stream);
  for it in FObjectList do
  begin
    stream.Add(Integer(TDataType.dtStructure));
    stream.Add(4); //Count
    TGXCommon.SetData(stream, TDataType.dtUInt16, Integer(it.ObjectType)); //ClassID
    TGXCommon.SetData(stream, TDataType.dtUInt8, it.Version); //Version
    TGXCommon.SetData(stream, TDataType.dtOctetString, TValue.From(TGXDLMSObject.GetLogicalName(it.LogicalName))); //LN
    GetAccessRights(it, stream); //Access rights.
  end;
  Result := stream.ToArray();
end;

procedure TGXDLMSAssociationLogicalName.GetAccessRights(item : TGXDLMSObject; data : TGXByteBuffer);
var
  attributes : TGXAttributeCollection;
  pos, cnt : Integer;
  att : TGXDLMSAttributeSettings;
begin
  data.Add(Integer(TDataType.dtStructure));
  data.Add(2);
  data.Add(Integer(TDataType.dtArray));
  attributes := item.FAttributes;
  cnt := item.GetAttributeCount();
  data.Add(cnt);
  for pos := 0 to cnt - 1 do
  begin
      att := attributes.Find(pos + 1);
      data.Add(Integer(TDataType.dtStructure)); //attribute_access_item
      data.Add(3);
      TGXCommon.SetData(data, TDataType.dtInt8, pos + 1);
      //If attribute is not set Result := read only.
      if att = Nil Then
        TGXCommon.SetData(data, TDataType.dtEnum, Integer(TAccessMode.Read))
      else
        TGXCommon.SetData(data, TDataType.dtEnum, Integer(att.Access));

      TGXCommon.SetData(data, TDataType.dtNone, Nil);
  end;
  data.Add(Integer(TDataType.dtArray));
  attributes := item.FMethodAttributes;
  cnt := item.GetMethodCount();
  data.Add(cnt);
  for pos := 0 to cnt - 1 do
  begin
    att := attributes.Find(pos + 1);
    data.Add(Integer(TDataType.dtStructure)); //attribute_access_item
    data.Add(2);
    TGXCommon.SetData(data, TDataType.dtInt8, pos + 1);
    //If method attribute is not set Result := no access.
    if att = Nil Then
      TGXCommon.SetData(data, TDataType.dtEnum, Integer(TMethodAccessMode.NoAccess))
    else
      TGXCommon.SetData(data, TDataType.dtEnum, Integer(att.MethodAccess));
  end;
end;

function TGXDLMSAssociationLogicalName.GetDataType(index: Integer): TDataType;
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
    Result := TDataType.dtStructure;
  end
  else if index = 4 Then
  begin
    Result := TDataType.dtStructure;
  end
  else if index = 5 Then
  begin
    Result := TDataType.dtStructure;
  end
  else if index = 6 Then
  begin
    Result := TDataType.dtStructure;
  end
  else if index = 7 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 8 Then
  begin
    Result := TDataType.dtEnum;
  end
  else if index = 9 Then
  begin
    Result := TDataType.dtOctetString;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSAssociationLogicalName.GetValue(e: TValueEventArgs): TValue;
var
  data, bb : TGXByteBuffer;
begin
  if e.Index = 1 then
  begin
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  end
  else if e.Index = 2 Then
  begin
    Result := TValue.From(GetObjects());
  end
  else if e.Index = 3 Then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtArray));
    //Add count
    data.SetUInt8(2);
    data.SetUInt8(Integer(TDataType.dtUInt8));
    data.Add(FClientSAP);
    data.SetUInt8(Integer(TDataType.dtUInt16));
    data.SetUInt16(FServerSAP);
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else if (e.Index = 4) Then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtStructure));
    //Add count
    data.SetUInt8(7);
    TGXCommon.SetData(data, TDataType.dtUInt8, ApplicationContextName.JointIsoCtt);
    TGXCommon.SetData(data, TDataType.dtUInt8, ApplicationContextName.Country);
    TGXCommon.SetData(data, TDataType.dtUInt16, ApplicationContextName.CountryName);
    TGXCommon.SetData(data, TDataType.dtUInt8, ApplicationContextName.IdentifiedOrganization);
    TGXCommon.SetData(data, TDataType.dtUInt8, ApplicationContextName.DlmsUA);
    TGXCommon.SetData(data, TDataType.dtUInt8, ApplicationContextName.ApplicationContext);
    TGXCommon.SetData(data, TDataType.dtUInt8, ApplicationContextName.ContextId);
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else if (e.Index = 5) Then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtStructure));
    data.SetUInt8(6);
    bb := TGXByteBuffer.Create();
    bb.SetUInt32(Integer(XDLMSContextInfo.Conformance));
    TGXCommon.SetData(data, TDataType.dtBitString, TValue.From(bb.SubArray(1, 3)));
    TGXCommon.SetData(data, TDataType.dtUInt16, XDLMSContextInfo.MaxReceivePduSize);
    TGXCommon.SetData(data, TDataType.dtUInt16, XDLMSContextInfo.MaxSendPduSize);
    TGXCommon.SetData(data, TDataType.dtUInt8, XDLMSContextInfo.DlmsVersionNumber);
    TGXCommon.SetData(data, TDataType.dtInt8, XDLMSContextInfo.QualityOfService);
    TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(XDLMSContextInfo.CypheringInfo));
    Result := TValue.From(data.ToArray());
    FreeAndNil(bb);
    FreeAndNil(data);
  end
  else if (e.Index = 6) Then
  begin
    data := TGXByteBuffer.Create;
    data.Add(Integer(TDataType.dtStructure));
    //Add count
    data.SetUInt8(7);
    TGXCommon.SetData(data, TDataType.dtUInt8, FAuthenticationMechanismName.JointIsoCtt);
    TGXCommon.SetData(data, TDataType.dtUInt8, FAuthenticationMechanismName.Country);
    TGXCommon.SetData(data, TDataType.dtUInt16, FAuthenticationMechanismName.CountryName);
    TGXCommon.SetData(data, TDataType.dtUInt8, FAuthenticationMechanismName.IdentifiedOrganization);
    TGXCommon.SetData(data, TDataType.dtUInt8, FAuthenticationMechanismName.DlmsUA);
    TGXCommon.SetData(data, TDataType.dtUInt8, FAuthenticationMechanismName.AuthenticationMechanismName);
    TGXCommon.SetData(data, TDataType.dtUInt8, Integer(FAuthenticationMechanismName.MechanismId));
    Result := TValue.From(data.ToArray());
    FreeAndNil(data);
  end
  else if e.Index = 7 Then
  begin
    Result := TValue.From(Secret);
  end
  else if e.Index = 8 Then
  begin
    Result := Integer(AssociationStatus);
  end
  else if e.Index = 9 Then
    Result := TValue.From(TGXDLMSObject.GetLogicalName(FSecuritySetupReference))
  else
    raise Exception.Create('GetValue failed. Invalid attribute index.');
end;

procedure UpdateAccessRights(obj : TGXDLMSObject; buff : TArray<TValue>);
var
  it, tmp : TValue;
  mode, id : Integer;
begin
  for it in buff[0].AsType<TArray<TValue>> do
  begin
    id := it.GetArrayElement(0).AsType<TValue>.AsInteger;
    mode := it.GetArrayElement(1).AsType<TValue>.AsInteger;
    obj.SetAccess(id, TAccessMode(mode));
  end;
  for it in buff[1].AsType<TArray<TValue>> do
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

procedure TGXDLMSAssociationLogicalName.SetValue(e: TValueEventArgs);
var
  item, tmp : TValue;
  tp : TObjectType;
  ln : string;
  obj : TGXDLMSObject;
  bb: TGXByteBuffer;
begin
  if (e.Index = 1) then
  begin
   FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FObjectList.Clear();
    Writeln(e.Value.ToString);
    if Not e.Value.IsEmpty Then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
        tp := TObjectType(item.GetArrayElement(0).AsType<TValue>.AsInteger);
        version := item.GetArrayElement(1).AsType<TValue>.AsInteger;
        ln := TGXDLMSObject.toLogicalName(item.GetArrayElement(2).AsType<TValue>.AsType<TBytes>);
        obj := e.Settings.Objects.FindByLN(tp, ln);
        if obj <> Nil Then
        begin
          tmp := item.GetArrayElement(3).AsType<TValue>;
          UpdateAccessRights(obj, tmp.AsType<TArray<TValue>>);
          ObjectList.Add(obj);
        end;
        obj.Version := version;
      end
    end;
  end
  else if e.Index = 3 Then
  begin
    FClientSAP := e.Value.GetArrayElement(0).AsType<TValue>.AsInteger;
    FServerSAP := e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
  end
  else if e.Index = 4 Then
  begin
    FApplicationContextName.JointIsoCtt := e.Value.GetArrayElement(0).AsType<TValue>.AsInteger;
    FApplicationContextName.Country := e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
    FApplicationContextName.CountryName := e.Value.GetArrayElement(2).AsType<TValue>.AsInteger;
    FApplicationContextName.IdentifiedOrganization := e.Value.GetArrayElement(3).AsType<TValue>.AsInteger;
    FApplicationContextName.DlmsUA := e.Value.GetArrayElement(4).AsType<TValue>.AsInteger;
    FApplicationContextName.ApplicationContext := e.Value.GetArrayElement(5).AsType<TValue>.AsInteger;
    FApplicationContextName.ContextId := e.Value.GetArrayElement(6).AsType<TValue>.AsInteger;
  end
  else if e.Index = 5 Then
  begin
    bb := TGXByteBuffer.Create(4);
    TGXCommon.SetBitString(bb, e.Value.GetArrayElement(0).AsType<TValue>.ToString);
    bb.SetUInt8(0, 0);
    FXDLMSContextInfo.Conformance := TConformance(bb.GetUInt32());
    FreeAndNil(bb);
    FXDLMSContextInfo.MaxReceivePduSize := e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
    FXDLMSContextInfo.MaxSendPduSize := e.Value.GetArrayElement(2).AsType<TValue>.AsInteger;
    FXDLMSContextInfo.DlmsVersionNumber := e.Value.GetArrayElement(3).AsType<TValue>.AsInteger;
    FXDLMSContextInfo.QualityOfService := e.Value.GetArrayElement(4).AsType<TValue>.AsInteger;
    FXDLMSContextInfo.CypheringInfo := e.Value.GetArrayElement(5).AsType<TValue>.AsType<TBytes>;
  end
  else if e.Index = 6 Then
  begin
    FAuthenticationMechanismName.JointIsoCtt := e.Value.GetArrayElement(0).AsType<TValue>.AsInteger;
    FAuthenticationMechanismName.Country := e.Value.GetArrayElement(1).AsType<TValue>.AsInteger;
    FAuthenticationMechanismName.CountryName := e.Value.GetArrayElement(2).AsType<TValue>.AsInteger;
    FAuthenticationMechanismName.IdentifiedOrganization := e.Value.GetArrayElement(3).AsType<TValue>.AsInteger;
    FAuthenticationMechanismName.DlmsUA := e.Value.GetArrayElement(4).AsType<TValue>.AsInteger;
    FAuthenticationMechanismName.AuthenticationMechanismName := e.Value.GetArrayElement(5).AsType<TValue>.AsInteger;
    FAuthenticationMechanismName.MechanismId := TAuthentication(e.Value.GetArrayElement(6).AsType<TValue>.AsInteger);
  end
  else if e.Index = 7 Then
  begin
    FSecret := e.Value.AsType<TBytes>;
  end
  else if e.Index = 8 Then
  begin
    if e.Value.IsEmpty Then
      FAssociationStatus := TAssociationStatus.NonAssociated
    else
      FAssociationStatus := TAssociationStatus(e.Value.AsInteger);
  end
  else if e.Index = 9 Then
    FSecuritySetupReference := TGXCommon.ToLogicalName(e.Value)
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSAssociationLogicalName.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

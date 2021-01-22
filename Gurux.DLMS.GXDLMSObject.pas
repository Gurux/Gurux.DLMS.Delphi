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

unit Gurux.DLMS.GXDLMSObject;

interface
uses GXCommon, Rtti, System.Classes, Generics.Collections,
System.Variants,
SysUtils, Gurux.DLMS.ObjectType, Gurux.DLMS.GXAttributeCollection,
Gurux.DLMS.AccessMode, Gurux.DLMS.GXDLMSException, Gurux.DLMS.MethodAccessMode,
Gurux.DLMS.DataType, Gurux.DLMS.ErrorCode, Gurux.DLMS.Priority, Gurux.DLMS.ServiceClass,
Gurux.DLMS.Conformance, Gurux.DLMS.SecuritySuite, Gurux.DLMS.Authentication,
Gurux.DLMS.InterfaceType, Gurux.DLMS.GXDLMSLimits, Gurux.DLMS.GXCiphering,
Gurux.DLMS.HdlcFrameType, Gurux.DLMS.GXDateTime, Gurux.DLMS.GXDLMSGateway,
Gurux.DLMS.ConnectionState,
Gurux.DLMS.Command,
Gurux.DLMS.GetCommandType,
GXXmlWriter,
GXXmlReader;

const
// Server frame sequence starting number.
ServerStartFrameSequence = $0F;
// Client frame sequence starting number.
ClientStartFrameSequence = $EE;
// Default Max received PDU size.
DefaultMaxReceivePduSize = $FFFF;

type
TGXDLMSObjectCollection = class;
TGXDLMSSettings = class;
TValueEventArgs = class;


TGXDLMSObject = class
  FDescription : String;
  //object attribute collection.
  FAttributes : TGXAttributeCollection;
  //Method attribute collection.
  FMethodAttributes : TGXAttributeCollection;
  FObjectType : TObjectType;
  FShortName : Word;
  FLogicalName : String;
  FVersion : Integer;
  FReadTimes : TDictionary<byte, TDateTime>;
  FParent: TGXDLMSObjectCollection;

  function GetValue(e: TValueEventArgs): TValue;virtual;
  procedure SetValue(e: TValueEventArgs);virtual;
  function Invoke(e: TValueEventArgs): TBytes;virtual;
  class function toLogicalName(buff: TBytes): string;static;
  constructor Create(objectType: TObjectType); overload;
  constructor Create(objectType: TObjectType; ln: string; sn: Word); overload;

  public
  constructor Create; overload;
  destructor Destroy; override;
  procedure SetAccess(index : Integer; access : TAccessMode);
  function GetAccess(index: Integer): TAccessMode;
  class function GetLogicalName(ln: string): TBytes;static;

  protected
  function IsRead(index: Integer): Boolean;virtual;
  function CanRead(index: Integer): Boolean;virtual;

  strict protected
    function GetAttribute(index: Integer; Attributes: TGXAttributeCollection ): TGXDLMSAttributeSettings;

    function GetLastReadTime(index: Integer): TDateTime;
    function get_Name: Variant;

  public

  function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;overload;virtual;

  function GetAttributeCount: Integer;virtual;
  function GetMethodCount: Integer;virtual;

  property Description : String read FDescription write FDescription;
  property ObjectType : TObjectType read FObjectType write FObjectType;

  property LogicalName : String read FLogicalName write FLogicalName;
  property ShortName : Word read FShortName write FShortName;

  property Version : Integer read FVersion write FVersion;
  property Name: Variant read get_Name;

  property Parent: TGXDLMSObjectCollection read FParent write FParent;

  function ToString: string; override;


  function GetMethodAccess(Index : Integer) : TMethodAccessMode;
  procedure SetMethodAccess(index : Integer; Access : TMethodAccessMode);

  // Returns device data type of selected attribute index.
  function GetDataType(index : Integer) : TDataType;virtual;
  // Returns UI data type of selected index.
  function GetUIDataType(index : Integer) : TDataType;virtual;

  procedure SetDataType(index : Integer; tp : TDataType);
  procedure SetUIDataType(index : Integer; tp : TDataType);
  procedure SetStatic(index : Integer; isStatic : Boolean);
  function GetStatic(index : Integer) : Boolean;
  function GetValues() : TArray<TValue>;virtual;
end;

TGXDLMSObjectCollection = class(TObjectList<TGXDLMSObject>)
  private
  FParent : TObject;

  public
  constructor Create(AOwnsObjects: Boolean); overload;
  constructor Create(Parent: TObject); overload;
  destructor Destroy;override;

  function GetObjects(tp: TObjectType): TArray<TGXDLMSObject>; overload;
  function GetObjects(types: TArray<TObjectType>): TArray<TGXDLMSObject>; overload;
  function GetObjects(types: array of TObjectType): TArray<TGXDLMSObject>; overload;

  function FindByLN(tp: TObjectType; ln: string): TGXDLMSObject;
  function FindBySN(sn: Word): TGXDLMSObject;
  property Parent : TObject read FParent write FParent;
  function ToString: string; override;

  procedure Save(APath : String);
  procedure Load(APath : String);
end;

 //
  TValueEventArgs = class
    // Target COSEM object.
    FTarget: TGXDLMSObject;
    // Attribute index of queried object.
    FIndex: Integer;
    // object value
    FValue: TValue;
    // Is request handled.
    FHandled: Boolean;
    // Parameterised access selector.
    FSelector: Integer;
    // Optional parameters.
    FParameters: TValue;
    // Occurred error.
    FError: TErrorCode;
    // Is action. This is reserved for internal use.
    FAction: Boolean;
    // Is value max PDU size skipped when converting data to bytes.
    FSkipMaxPduSize: Boolean;
    // Is reply handled as byte array or octect string.
    FByteArray: Boolean;
    // Row to PDU is used with Profile Generic to tell how many rows are fit to one PDU.
    FRowToPdu: WORD;
    // Rows begin index.
    FRowBeginIndex: LongWord;
    // Rows end index.
    FRowEndIndex: LongWord;
    // Received invoke ID.
    FInvokeId: LongWord;
    //DLMS settings.
    FSettings: TGXDLMSSettings;
    //GBT Window size.
    FWindowSize: BYTE;
  public
    // Target COSEM object.
    property Target: TGXDLMSObject read FTarget write FTarget;
    // Attribute index of queried object.
    property Index: Integer read FIndex write FIndex;
    // object value
    property Value: TValue read FValue write FValue;
    // Is request handled.
    property Handled: Boolean read FHandled write FHandled;
    // Parameterised access selector.
    property Selector: Integer read FSelector write FSelector;
    // Optional parameters.
    property Parameters: TValue read FParameters write FParameters;
    // Occurred error.
    property Error: TErrorCode read FError write FError;
    // Is action. This is reserved for internal use.
    property Action: Boolean read FAction write FAction;
    // Is value max PDU size skipped when converting data to bytes.
    property SkipMaxPduSize: Boolean read FSkipMaxPduSize write FSkipMaxPduSize;
    // Is reply handled as byte array or octect string.
    property ByteArray: Boolean read FByteArray write FByteArray;
    // Row to PDU is used with Profile Generic to tell how many rows are fit to one PDU.
    property RowToPdu: WORD read FRowToPdu write FRowToPdu;
    // Rows begin index.
    property RowBeginIndex: LongWord read FRowBeginIndex write FRowBeginIndex;
    // Rows end index.
    property RowEndIndex: LongWord read FRowEndIndex write FRowEndIndex;
    // Received invoke ID.
    property InvokeId: LongWord read FInvokeId write FInvokeId;
    //DLMS settings.
    property Settings: TGXDLMSSettings read FSettings;

    //GBT window size.
    property WindowSize: BYTE read FWindowSize write FWindowSize;

  // Constructor.
  constructor Create(settings: TGXDLMSSettings; target: TGXDLMSObject; index: Integer; selector: Integer; parameters: TValue);overload;
  // Constructor.
  constructor Create(target: TGXDLMSObject; index: Integer;selector: Integer; parameters: TValue);overload;
  destructor Destroy; override;
end;

TGXDLMSSettings = class
private
  // HDLC sender frame sequence number.
  FSenderFrame : Byte;
  /// HDLC receiver frame sequence number.
  FReceiverFrame : Byte;
  // Source system title.
  FSourceSystemTitle : TBytes;
  // Long data count.
  FCount : LongWord;
  // Long data index.
  FIndex : LongWord;
  FPriority : TPriority;
  FServiceClass : TServiceClass;
  FObjects: TGXDLMSObjectCollection;
  FUseCustomChallenge: Boolean;
  FInvokeID: Byte;
  FLongInvokeID : UInt32;
  FProposedConformance:   TConformance;
  FNegotiatedConformance:   TConformance;
  FIsAuthenticationRequired : Boolean;
  FSecuritySuite: TSecuritySuite;
  FCtoSChallenge:  TBytes;
  FStoCChallenge:  TBytes;
  FDedicatedKey:  TBytes;
  FAuthentication: TAuthentication;
  FPassword: TBytes;
  FConnected: TConnectionState;
  FInterfaceType: TInterfaceType;
  FClientAddress: Integer;
  FServerAddress: Integer;
  FServerAddressSize : Byte;
  FDLMSVersion: Byte;
  FMaxPduSize: WORD;
  FMaxServerPDUSize: WORD;
  FUseLogicalNameReferencing : Boolean;
  FIsServer: Boolean;
  FLimits : TGXDLMSLimits;
  FBlockIndex : LongWord;
  FStartingBlockIndex : LongWord;
  FGateway : TGXDLMSGateway;
  FProtocolVersion: string;
  FUserId: Integer;
  FQualityOfService: Byte;
  FWindowSize: BYTE;
  FBlockNumberAck: BYTE;
  // Ciphering.
  FCipher : TGXCiphering;
  FCommand: TCommand;
  FCommandType: TGetCommandType;
  FAutoIncreaseInvokeID : Boolean;

  public

  // Get initial Conformance
  class function GetInitialConformance(useLogicalNameReferencing: Boolean): TConformance;static;

  //InvokeID.
  procedure SetInvokeID(Value: Byte);

  // UseLogicalNameReferencing.
  procedure SetUseLogicalNameReferencing(Value: Boolean);

  function IncreaseReceiverSequence(value : Byte) : Byte;

  //Increase sender sequence.
  function IncreaseSendSequence(value : Byte): Byte;

  procedure ResetFrameSequence;
  function CheckFrame(frame : Byte) : Boolean;
  function NextSend(first : Boolean) : Byte;
  function ReceiverReady : Byte;
  //Generates Keep Alive S-frame.
  function KeepAlive : Byte;

  // Resets block index to default value.
  procedure ResetBlockIndex;

  // Increases block index.
  procedure IncreaseBlockIndex;
  // Update invoke ID.
  procedure UpdateInvokeId(value: BYTE);


  // Invoke ID.
  property InvokeID: Byte read FInvokeID write SetInvokeID;

  // Invoke ID.
  property LongInvokeID: UInt32 read FLongInvokeID write FLongInvokeID;

  // When connection is made client tells what kind of services it want's to use.
  property ProposedConformance: TConformance read FProposedConformance write FProposedConformance;

  // Server tells what functionality is available and client will know it.
  property NegotiatedConformance: TConformance read FNegotiatedConformance write FNegotiatedConformance;

  // Is authentication Required.
  property IsAuthenticationRequired: Boolean read FIsAuthenticationRequired write FIsAuthenticationRequired;

  // Ciphering.
  property Cipher : TGXCiphering read FCipher write FCipher;

  // Used security suite.
  property SecuritySuite: TSecuritySuite read FSecuritySuite write FSecuritySuite;

  property Command: TCommand read FCommand write FCommand;
  property CommandType: TGetCommandType read FCommandType write FCommandType;

  //Constructor.
  constructor Create(
  //Is Logical or short name referencing used.
  AIsServer : Boolean);

  destructor Destroy; override;

  // Client to Server challenge.
  property CtoSChallenge: TBytes read FCtoSChallenge write FCtoSChallenge;

  // Server to Client challenge.
  property StoCChallenge: TBytes read FStoCChallenge write FStoCChallenge;

  // Dedicated key.
  property DedicatedKey: TBytes read FDedicatedKey write FDedicatedKey;

  // Used authentication.
  property Authentication: TAuthentication read FAuthentication write FAuthentication;

  /// Client password.
  property Password: TBytes read FPassword write FPassword;

  // Is this server or client settings.
  property IsServer: Boolean read FIsServer;

  // Information from the frame size that server can handle.
  property Limits : TGXDLMSLimits read FLimits;

  // Connected.
  property Connected: TConnectionState read FConnected write FConnected;

  // Used interface.
  property InterfaceType: TInterfaceType read FInterfaceType write FInterfaceType;

  // Client address.
  property ClientAddress: Integer read FClientAddress write FClientAddress;

  // Server address.
  property ServerAddress: Integer read FServerAddress write FServerAddress;

  // Size of Server address.
  property ServerAddressSize: Byte read FServerAddressSize write FServerAddressSize;

  // DLMS version number.
  property DLMSVersion: Byte read FDLMSVersion write FDLMSVersion;

 // Maximum PDU size.
  property MaxPduSize: WORD read FMaxPduSize write FMaxPduSize;

  // Server maximum PDU size.
  property MaxServerPDUSize: WORD read FMaxServerPDUSize write FMaxServerPDUSize;

  // Is Logical Name Referencing used.
  property UseLogicalNameReferencing: Boolean read FUseLogicalNameReferencing write SetUseLogicalNameReferencing;

  // Used priority.
  property Priority: TPriority read FPriority write FPriority;

  // Used service class.
  property ServiceClass: TServiceClass read FServiceClass write FServiceClass;

  // Collection of the objects.
  property Objects: TGXDLMSObjectCollection read FObjects write FObjects;

   // Is custom challenges used. If custom challenge is used new challenge is
   // not generated if it is set. This is for debugging purposes.
  property UseCustomChallenge: Boolean read FUseCustomChallenge write FUseCustomChallenge;

   // Long data count.
  property Count : LongWord read FCount write FCount;

  // Long data index.
  property Index : LongWord read FIndex write FIndex;

  //Current block index.
  property BlockIndex : LongWord read FBlockIndex write FBlockIndex;

  // Gets starting block index. Default is One based, but some meters use Zero based value.
  // Usually this is not used.
  property StartingBlockIndex: LongWord read FStartingBlockIndex write FStartingBlockIndex;
  // Source system title.
  property SourceSystemTitle : TBytes read FSourceSystemTitle  write FSourceSystemTitle;

  //Gateway settings.
  property Gateway : TGXDLMSGateway read FGateway write FGateway;

  //Protocol version.
  property ProtocolVersion : string read FProtocolVersion write FProtocolVersion;

  //User ID.
  property UserId : Integer read FUserId write FUserId;

  //Quality of service.
  property QualityOfService : Byte read FQualityOfService write FQualityOfService;

  property WindowSize : Byte read FWindowSize write FWindowSize;
  property BlockNumberAck : Byte read FBlockNumberAck write FBlockNumberAck;

  property AutoIncreaseInvokeID : Boolean read FAutoIncreaseInvokeID write FAutoIncreaseInvokeID;
end;

implementation

uses DateUtils,
  ScktComp, TypInfo, ActiveX,
  Gurux.DLMS.GXDLMSConverter, GXObjectFactory;

function TGXDLMSObject.ToString: string;
begin
  if FShortName <> 0 then
    Result := FShortName.ToString() + ' ' + FDescription
  else
    Result := FLogicalName + ' ' + FDescription;
end;

function TGXDLMSObject.GetValues() : TArray<TValue>;
begin
  raise Exception.Create('GetValues not implemented.');
end;

function TGXDLMSObject.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
begin
  raise Exception.Create('GetAttributeIndexToRead(All: Boolean) not implemented.');
end;

function TGXDLMSObject.GetAttributeCount: Integer;
begin
  raise Exception.Create('GetAttributeCount not implemented.');
end;

function TGXDLMSObject.GetMethodCount: Integer;
begin
  raise Exception.Create('GetMethodCount not implemented.');
end;

function TGXDLMSObject.GetValue(e: TValueEventArgs): TValue;
begin
  raise Exception.Create('GetValue not implemented.');
end;

procedure TGXDLMSObject.SetValue(e: TValueEventArgs);
begin
  raise Exception.Create('SetValue not implemented.');
end;

function TGXDLMSObject.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke not implemented.');
end;


function TGXDLMSObject.get_Name: Variant;
begin
  if (ShortName <> 0) then
    Result := Variant(FShortName)
  else
    Result := Variant(FLogicalName);
end;

/// Returns time when attribute was last time read.
function TGXDLMSObject.GetLastReadTime(index: Integer): TDateTime;
var
readTime : TDateTime;
begin
  if FReadTimes.TryGetValue(byte(index), readTime) = False then
    Result := TGXDateTime.MinDateTime
  else
    Result := readTime;
end;

/// Is attribute read.
function TGXDLMSObject.IsRead(index: Integer): Boolean;
begin
  if (CanRead(index) = False) then
    Result := True
  else
    Result := (GetLastReadTime(index) <> TGXDateTime.MinDateTime);
end;

function TGXDLMSObject.GetAttribute(index: Integer; Attributes: TGXAttributeCollection ): TGXDLMSAttributeSettings;
begin
   Result := FAttributes.Find(index);
   if Result = Nil then
   begin
     Result := TGXDLMSAttributeSettings.Create(index);
     Attributes.Add(Result);
   end;
end;

//Returns is attribute read only.
function TGXDLMSObject.GetAccess(index: Integer): TAccessMode;
var
  items : TGXAttributeCollection;
begin
  items := TGXAttributeCollection.Create();
  try
    Result := GetAttribute(index, items).Access;
  finally
    FreeAndNil(items);
  end;
end;

// Set attribute access.
procedure TGXDLMSObject.SetAccess(index : Integer; access : TAccessMode);
var
  att : TGXDLMSAttributeSettings;
begin
    att := GetAttribute(index, FAttributes);
    att.Access := access;
end;

// Returns is Method attribute read only.
function TGXDLMSObject.GetMethodAccess(Index : Integer) : TMethodAccessMode;
var
  att : TGXDLMSAttributeSettings;
begin
  att := FMethodAttributes.Find(index);
  if att <> Nil then
    Result := att.MethodAccess
  else
    Result := TMethodAccessMode.NoAccess;
end;

// Set Method attribute access.
procedure TGXDLMSObject.SetMethodAccess(index : Integer; Access : TMethodAccessMode);
var
  att : TGXDLMSAttributeSettings;
begin
  att := FMethodAttributes.Find(index);
  if att = Nil then
  begin
      att := TGXDLMSAttributeSettings.Create(index);
      FMethodAttributes.Add(att);
  end;
  att.MethodAccess := access;
end;

function TGXDLMSObject.CanRead(index: Integer): Boolean;
begin
  Result := (GetAccess(index) <> TAccessMode.NoAccess);
end;

constructor TGXDLMSObject.Create;
begin
  inherited Create;
  FReadTimes := TDictionary<byte, TDateTime>.Create;
  FAttributes := TGXAttributeCollection.Create;
  FMethodAttributes := TGXAttributeCollection.Create;
end;

constructor TGXDLMSObject.Create(objectType: TObjectType);
begin
  Create;
  FObjectType := objectType;
end;

constructor TGXDLMSObject.Create(objectType: TObjectType; ln: string; sn: Word);
var
  items: TArray<string>;
begin
  Create(objectType);
  FShortName := sn;
  if (ln <> '') then
  begin
    items := ln.Split(['.']);
    if (Length(items) <> 6) then
      raise TGXDLMSException.Create('Invalid Logical Name.');
  end;
  FLogicalName := ln;
end;

destructor TGXDLMSObject.Destroy;
begin
  inherited;
  if FAttributes <> Nil then
  begin
    FreeAndNil(FAttributes);
    FreeAndNil(FMethodAttributes);
    FreeAndNil(FReadTimes);
  end;
end;

class function TGXDLMSObject.GetLogicalName(ln: string): TBytes;
begin
  Result := TGXCommon.GetLogicalName(ln);
end;

class function TGXDLMSObject.toLogicalName(buff: TBytes): string;
begin
  Result := TGXCommon.ToLogicalName(buff);
end;

constructor TGXDLMSObjectCollection.Create(AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
end;

constructor TGXDLMSObjectCollection.Create(Parent: TObject);
begin
  inherited Create;
  FParent := Parent;
end;

destructor TGXDLMSObjectCollection.Destroy;
begin
  inherited;
  Self.Clear;
  FParent := Nil;
end;

function TGXDLMSObjectCollection.GetObjects(tp: TObjectType): TArray<TGXDLMSObject>;
var
  it: TGXDLMSObject;
  list: TList<TGXDLMSObject>;
begin
  list := TList<TGXDLMSObject>.Create();
  try
    for it in Self do
    begin
      if it.ObjectType = tp then
        list.Add(it);
    end;
    Result := list.ToArray;
  finally
    FreeAndNil(list);
  end;
end;

function TGXDLMSObjectCollection.GetObjects(types: TArray<TObjectType>): TArray<TGXDLMSObject>;
var
  it: TGXDLMSObject;
  tp : TObjectType;
  list: TList<TGXDLMSObject>;
begin
  list := TList<TGXDLMSObject>.Create();
  try
    for it in Self do
    begin
      for tp in types do
        if tp = it.ObjectType then
        begin
          list.Add(it);
          break;
        end;
    end;
    Result := list.ToArray;
  finally
    FreeAndNil(list);
  end;
end;

function TGXDLMSObjectCollection.GetObjects(types: array of TObjectType): TArray<TGXDLMSObject>;
var
  it: TGXDLMSObject;
  tp : TObjectType;
  list: TList<TGXDLMSObject>;
begin
  list := TList<TGXDLMSObject>.Create();
  try
    for it in Self do
    begin
      for tp in types do
        if tp = it.ObjectType then
        begin
          list.Add(it);
          break;
        end;
    end;
    Result := list.ToArray;
  finally
    FreeAndNil(list);
  end;
end;

function TGXDLMSObjectCollection.FindByLN(tp: TObjectType; ln: string): TGXDLMSObject;
var
  it: TGXDLMSObject;
begin
  Result := Nil;
  for it in Self do
  begin
    if (((tp = TObjectType.otNone) or (it.ObjectType = tp)) and
          (string.CompareText(it.LogicalName, ln) = 0)) then
      begin
        Result := it;
        Exit;
      end;
  end;
end;

function TGXDLMSObjectCollection.FindBySN(sn: Word) : TGXDLMSObject;
var
  it: TGXDLMSObject;
begin
  Result := nil;
  for it in Self do
  begin
    if (it.ShortName = sn) then
      begin
        Result := it;
        Exit;
      end;
  end;
end;

function TGXDLMSObjectCollection.ToString: string;
var
  it: TGXDLMSObject;
  sb : TStringBuilder;
begin
  sb := TStringBuilder.Create();
  try
    sb.Append('[');
    for it in Self do
    begin
      sb.Append(VarToStr(it.Name));
      sb.Append(', ');
    end;
    //Remove last commma.
    sb.Remove(sb.Length - 2, 2);
    sb.Append(']');
    Result := sb.ToString;
  finally
    FreeAndNil(sb);
  end;
end;

//Load objects values.
procedure TGXDLMSObjectCollection.Load(APath : String);
var
  reader: TGXXmlReader;
  target: string;
  obj: TGXDLMSObject;
  ot: TObjectType;
begin
  reader := TGXXmlReader.Create(APath);
  Clear;
  try
    obj := Nil;
    while reader.IsEOF() = False do
    begin
      if reader.IsStartElement() Then
      begin
        target := reader.GetName();
        if 'Objects' = target Then
            // Skip.
            reader.Read()
        else if target.startsWith('GXDLMS') Then
        begin
          ot := TGXDLMSConverter.ValueOfObjectType(target);
          obj := TGXObjectFactory.CreateObject(WORD(ot));
          Add(obj);
          reader.Read();
        end
        else if 'SN' = target Then
            obj.ShortName := reader.ReadElementContentAsInt('SN')
        else if 'LN' = target Then
            obj.LogicalName := reader.ReadElementContentAsString('LN')
        else if 'Description' = target Then
            obj.Description :=reader.ReadElementContentAsString('Description')
        else if 'Version' = target Then
            obj.Version := reader.ReadElementContentAsInt('Version')
        else
          reader.read();
      end
      else
        reader.read();
    end;
  finally
    reader.Free();
  end;
end;

//Save objects values.
procedure TGXDLMSObjectCollection.Save(APath : String);
var
  writer: TGXXmlWriter;
  it: TGXDLMSObject;
begin
  writer := TGXXmlWriter.Create();
  try
    writer.WriteStartElement('Objects');
    for it in Self do
    begin
      //Custom interfaces are not saved.
      if it.ClassType <> TGXDLMSObject then
      begin
        writer.WriteStartElement(TGXDLMSConverter.ToString(it.ObjectType));
        // Add SN
        if it.ShortName <> 0 Then
          writer.WriteElementString('SN', it.ShortName);

        // Add LN
        writer.WriteElementString('LN', it.LogicalName);
        // Add Version
        if it.Version <> 0 Then
          writer.WriteElementString('Version', it.Version);
        // Add description if given.
        if it.description <> '' Then
          writer.WriteElementString('Description', it.Description);

        // Close object.
        writer.WriteEndElement();
      end;
    end;
    writer.WriteEndElement();
    writer.Save(APath);
  finally
    writer.Free();
  end;
end;


procedure TGXDLMSObject.SetDataType(index : Integer; tp : TDataType);
var
  att : TGXDLMSAttributeSettings;
begin
  att := FAttributes.Find(index);
  if att = Nil then
  begin
    att := TGXDLMSAttributeSettings.Create(index);
    FAttributes.Add(att);
  end;
  att.&Type := tp;
end;

procedure TGXDLMSObject.SetUIDataType(index : Integer; tp : TDataType);
var
  att : TGXDLMSAttributeSettings;
begin
  att := FAttributes.Find(index);
  if att = Nil then
  begin
      att := TGXDLMSAttributeSettings.Create(index);
      FAttributes.Add(att);
  end;
  att.UIType := tp;
end;

procedure TGXDLMSObject.SetStatic(index : Integer; isStatic : Boolean);
var
  att : TGXDLMSAttributeSettings;
begin
  att := FMethodAttributes.Find(index);
  if att = Nil then
  begin
      att := TGXDLMSAttributeSettings.Create(index);
      FAttributes.Add(att);
  end;
  att.IsStatic := isStatic;
end;


function TGXDLMSObject.GetStatic(Index : Integer) : Boolean;
var
  att : TGXDLMSAttributeSettings;
begin
  att := FAttributes.Find(index);
  if att <> Nil then
    Result := att.IsStatic
  else
    Result := false;
end;

// Returns device data type of selected attribute index.
function TGXDLMSObject.GetDataType(index : Integer) : TDataType;
var
  att : TGXDLMSAttributeSettings;
begin
  att := FAttributes.Find(index);
  if att <> Nil then
    Result := att.&Type
  else
    Result := TDataType.dtNone;
end;

// Returns UI data type of selected index.
function TGXDLMSObject.GetUIDataType(index : Integer) : TDataType;
var
  att : TGXDLMSAttributeSettings;
begin
  att := FAttributes.Find(index);
  if att <> Nil then
    Result := att.&UIType
  else
    Result := TDataType.dtNone;
end;

// Constructor.
constructor TValueEventArgs.Create(settings: TGXDLMSSettings; target: TGXDLMSObject; index: Integer; selector: Integer; parameters: TValue);
begin
  FSettings := settings;
  FTarget := target;
  FIndex := index;
  FSelector := selector;
  FParameters := parameters;
end;

// Constructor.
constructor TValueEventArgs.Create(target: TGXDLMSObject; index: Integer;selector: Integer; parameters: TValue);
begin
  FTarget := target;
  FIndex := index;
  FSelector := selector;
  FParameters := parameters;
end;

destructor TValueEventArgs.Destroy;
begin
  inherited;
  FValue := Nil;
end;

constructor TGXDLMSSettings.Create(AIsServer : Boolean);
begin;
  inherited Create;
  FMaxPduSize := $FFFF;
  FInvokeID := 1;
  FLongInvokeID := 1;
  FUseCustomChallenge := false;
  FStartingBlockIndex := 1;
  FBlockIndex := 1;
  FDLMSVersion := 6;
  FPriority := TPriority.prHigh;
  FServiceClass := TServiceClass.scConfirmed;
  FMaxServerPDUSize := DefaultMaxReceivePduSize;
  MaxPduSize := DefaultMaxReceivePduSize;
  FIsServer := AIsServer;
  FObjects := TGXDLMSObjectCollection.Create();
  FLimits := TGXDLMSLimits.Create();
  FProposedConformance := TGXDLMSSettings.GetInitialConformance(false);
  ResetFrameSequence();
  FGateway := Nil;
  FCipher := Nil;
  FCommand := TCommand.None;
  FCommandType := TGetCommandType.ctNormal;
end;

destructor TGXDLMSSettings.Destroy;
begin
  FreeAndNil(FLimits);
  FreeAndNil(FObjects);
  FreeAndNil(FCipher);
  inherited;
end;

class function TGXDLMSSettings.GetInitialConformance(useLogicalNameReferencing: Boolean): TConformance;
begin
    if useLogicalNameReferencing Then
      Result := TConformance(Integer(TConformance.cfBlockTransferWithAction) or
                   Integer(TConformance.cfBlockTransferWithSetOrWrite) or
                   Integer(TConformance.cfBlockTransferWithGetOrRead) or
                   Integer(TConformance.cfSet) or
                   Integer(TConformance.cfSelectiveAccess) or
                   Integer(TConformance.cfAction) or
                   Integer(TConformance.cfMultipleReferences) or
                   Integer(TConformance.cfGet))
    else
      Result := TConformance(Integer(TConformance.cfInformationReport) or
                Integer(TConformance.cfRead) or
                Integer(TConformance.cfUnconfirmedWrite) or
                Integer(TConformance.cfWrite) or
                Integer(TConformance.cfParameterizedAccess) or
                Integer(TConformance.cfMultipleReferences));
end;

// Invoke ID.
procedure TGXDLMSSettings.SetInvokeID(Value: Byte);
begin
  if value > $F then
    raise EArgumentException.Create('Invalid InvokeID.');
  FInvokeID := value;
end;

// UseLogicalNameReferencing.
procedure TGXDLMSSettings.SetUseLogicalNameReferencing(Value: Boolean);
begin
  if FUseLogicalNameReferencing <> value then
  begin
   FUseLogicalNameReferencing := value;
   FProposedConformance := TGXDLMSSettings.GetInitialConformance(value);
  end;
end;

// Increase receiver sequence.
function TGXDLMSSettings.IncreaseReceiverSequence(value : Byte): Byte;
begin
    Result := Byte((value + $20) or $10 or value and $E);
end;

///Increase sender sequence.
function TGXDLMSSettings.IncreaseSendSequence(value : Byte): Byte;
begin
    Result := (value and $F0 or (value + 2) and $E);
end;

///Reset frame sequence.
procedure TGXDLMSSettings.ResetFrameSequence;
begin
    if IsServer then
    begin
        FSenderFrame := $1E;
        FReceiverFrame := $FE;
    end
    else
    begin
        FSenderFrame := $FE;
        FReceiverFrame := $E;
    end;
end;

function TGXDLMSSettings.CheckFrame(frame : Byte) : Boolean;
begin
  //If notify
  if frame = $13 Then
  begin
    result := true;
    Exit;
  end;

  if frame and Byte(THdlcFrameType.Uframe) = Byte(THdlcFrameType.Uframe) then
  begin
      if (frame = $73) or (frame = $93) then
        ResetFrameSequence();

      result := true;
      Exit;
  end;
  //If S -frame.
  if frame and Byte(THdlcFrameType.Sframe) = Byte(THdlcFrameType.Sframe) then
  begin
    FReceiverFrame := IncreaseReceiverSequence(FReceiverFrame);
    result := true;
    Exit;
  end;
  //Handle I-frame.
  if (FSenderFrame and $1) = 0 Then
  begin
    if (frame = IncreaseReceiverSequence(IncreaseSendSequence(FReceiverFrame))) then
    begin
      FReceiverFrame := frame;
      result := true;
      Exit;
    end;
  end
  else
  begin
    //If answer for RR.
    if (frame = IncreaseSendSequence(FReceiverFrame)) then
    begin
      FReceiverFrame := frame;
      result := true;
      Exit;
    end;
  end;
  result := false;
end;

/// Generates I-frame.
function TGXDLMSSettings.NextSend(first : Boolean) : Byte;
begin
    if (first) then
    begin
        FSenderFrame := IncreaseReceiverSequence(IncreaseSendSequence(FSenderFrame));
    end
    else
    begin
        FSenderFrame := IncreaseSendSequence(FSenderFrame);
    end;
    Result := FSenderFrame;
end;

///Generates Receiver Ready S-frame.
function TGXDLMSSettings.ReceiverReady : Byte;
begin
    FSenderFrame := (IncreaseReceiverSequence(FSenderFrame) or 1);
    Result := FSenderFrame and $F1;
end;

///Generates Keep Alive S-frame.
function TGXDLMSSettings.KeepAlive : Byte;
begin
    FSenderFrame := (FSenderFrame or 1);
    Result := FSenderFrame and $F1;
end;

// Resets block index to default value.
procedure TGXDLMSSettings.ResetBlockIndex;
begin
    FBlockIndex := FStartingBlockIndex;
end;

// Increases block index.
procedure TGXDLMSSettings.IncreaseBlockIndex;
begin
    FBlockIndex := FBlockIndex + 1;
end;

// Update invoke ID.
procedure TGXDLMSSettings.UpdateInvokeId(value: BYTE);
begin
  if value and $80 <> 0 Then
    FPriority := TPriority.prHigh
  else
    FPriority := TPriority.prNormal;

  if value and $40 <> 0 Then
    FServiceClass := TServiceClass.scConfirmed
  else
    FServiceClass := TServiceClass.scUnConfirmed;
  FInvokeID := value and $F;
end;
end.


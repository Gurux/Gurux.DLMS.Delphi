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

unit Gurux.DLMS.GXDLMSClient;

interface
uses SysUtils, TypInfo, Rtti, Variants, System.Generics.Collections,
Gurux.DLMS.Authentication, Gurux.DLMS.Priority,
Gurux.DLMS.ServiceClass, Gurux.DLMS.InterfaceType, Gurux.DLMS.GXDLMSLimits,
Gurux.DLMS.GXDLMS, System.Math,
Gurux.DLMS.DataType, Gurux.DLMS.RequestTypes,
Gurux.DLMS.GXDLMSObject, Gurux.DLMS.ObjectType, GXAPDU,
GXCommon, Gurux.DLMS.Command, Gurux.DLMS.GXDLMSException, Gurux.DLMS.ActionType,
Gurux.DLMS.AccessMode, Gurux.DLMS.MethodAccessMode, Gurux.DLMS.GXCiphering,
Gurux.DLMS.Security, HDLCInfo, Gurux.DLMS.AssociationResult,
Gurux.DLMS.SourceDiagnostic, Gurux.DLMS.GXDateTime, Gurux.DLMS.DateTimeSkips,
Gurux.DLMS.GXStandardObisCodeCollection, Gurux.DLMS.GXStandardObisCode,
Gurux.DLMS.Objects.GXDLMSProfileGeneric,
GXObjectFactory, GXByteBuffer,
Gurux.DLMS.Objects.GXDLMSAssociationShortName,
Gurux.DLMS.Objects.GXDLMSAssociationLogicalName,
Gurux.DLMS.Conformance,
Gurux.DLMS.GXDLMSLNParameters, Gurux.DLMS.GXDLMSSNParameters,
Gurux.DLMS.GXSecure, GXDataInfo, Gurux.DLMS.ActionRequestType,
Gurux.DLMS.VariableAccessSpecification,
Gurux.DLMS.GXDLMSConverter, Gurux.DLMS.SetRequestType,
Gurux.DLMS.GetCommandType, Gurux.DLMS.GXDLMSCaptureObject,
Gurux.DLMS.GXReplyData, Gurux.DLMS.IGXDLMSClient,
Gurux.DLMS.SerialnumberCounter;

type
  CaptureObject = TPair<TGXDLMSObject, TGXDLMSCaptureObject>;

TGXDLMSClient = class (TInterfacedObject, IGXDLMSClient)
  protected
    FSettings: TGXDLMSSettings;

  private
    function GetPassword: TBytes;
    procedure SetPassword(Value: TBytes);

    function get_Objects: TGXDLMSObjectCollection;
    function get_Authentication: TAuthentication;
    function get_Priority: TPriority;
    function get_ServiceClass: TServiceClass;
    function get_InvokeID: Byte;
    function get_InterfaceType: TInterfaceType;
    function get_Limits: TGXDLMSLimits;
    function get_ClientAddress: Integer;
    function get_ServerAddress: Integer;
    procedure set_Authentication(Value: TAuthentication);
    procedure set_Priority(Value: TPriority);
    procedure set_ServiceClass(Value: TServiceClass);
    procedure set_InvokeID(Value: Byte);
    procedure set_InterfaceType(Value: TInterfaceType);
    procedure set_ClientAddress(Value: Integer);
    procedure set_ServerAddress(Value: Integer);
    function get_MaxReceivePDUSize: System.UInt16;
    function get_UseLogicalNameReferencing: Boolean;
    procedure set_MaxReceivePDUSize(Value: System.UInt16);
    procedure set_UseLogicalNameReferencing(Value: Boolean);
    // Functionality what server offers.
    function GetNegotiatedConformance : TConformance;
    procedure SetNegotiatedConformance(value: TConformance);

    // When connection is made client tells what kind of services it want's to use.
    function GetProposedConformance : TConformance;
    // When connection is made client tells what kind of services it want's to use.
    procedure SetProposedConformance(value: TConformance);

    // Generates a read message.
    function Read(name : Variant; ot : TObjectType; attributeOrdinal : Integer; data: TGXByteBuffer) : TArray<TBytes>;overload;

    procedure ParseSNObjects(buff : TGXByteBuffer; onlyKnownObjects : Boolean);
    procedure ParseLNObjects(buff : TGXByteBuffer; onlyKnownObjects : Boolean);

    class function CreateDLMSObject(ClassID : Word; Version : Word; BaseName : Word;
                LN : TValue; AccessRights : TValue) : TGXDLMSObject; static;

   class procedure UpdateObjectData(obj : TGXDLMSObject; objectType : TObjectType;
              version : Word; baseName : TValue; logicalName : TValue;
              accessRights : TValue); static;
    function ReadRowsByRange(pg: TGXDLMSProfileGeneric; startTime: TValue; endTime : TValue; columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;overload;
  public
    destructor Destroy; override;

    constructor Create; overload;
    constructor Create(
        //Is Logical or short name referencing used.
        UseLogicalNameReferencing : Boolean;
        //Client ID. Default is 0x10
				ClientAddress : Integer;
        //Server ID. Default is 1.
				ServerAddress : Integer;
				//Authentication type. Default is None
				Authentication : TAuthentication;
				//Password if authentication is used.
				Password : TBytes;
        //Interface type. Default is general.
				intefaceType : TInterfaceType);overload;

    constructor Create(
        //Is Logical or short name referencing used.
        UseLogicalNameReferencing : Boolean;
        //Client ID. Default is 0x10
				ClientAddress : Integer;
        //Server ID. Default is 1.
				ServerAddress : Integer;
				//Authentication type. Default is None
				Authentication : TAuthentication;
				//Password if authentication is used.
				Password : string;
        //Interface type. Default is general.
				intefaceType : TInterfaceType);overload;

    // Update list values.
    procedure UpdateValues(list: TList<TPair<TGXDLMSObject, Integer>>; values: TList<TValue>);

    property Authentication: TAuthentication read get_Authentication write set_Authentication;
    property NegotiatedConformance: TConformance read GetNegotiatedConformance write SetNegotiatedConformance;
    property ProposedConformance: TConformance read GetProposedConformance write SetProposedConformance;
    property Priority: TPriority read get_Priority write set_Priority;
    property ServiceClass: TServiceClass read get_ServiceClass write set_ServiceClass;
    property InvokeID: Byte read get_InvokeID write set_InvokeID;
    property InterfaceType: TInterfaceType read get_InterfaceType write set_InterfaceType;
    property Limits: TGXDLMSLimits read get_Limits;
    property ClientAddress : Integer read get_ClientAddress write set_ClientAddress;
    property ServerAddress : Integer read get_ServerAddress write set_ServerAddress;
    // Generates a write message.
    function Write(item : TGXDLMSObject; index : Integer) : TArray<TBytes>;overload;
    function Write(name : Variant; value : TValue; dt : TDataType; ot : TObjectType; index : Integer) : TArray<TBytes>;overload;

    // Read list of COSEM objects.
    function ReadList(list: TList<TPair<TGXDLMSObject, Integer>>): TArray<TBytes>;

    // Generates a read message.
    function Read(it : TGXDLMSObject; attributeIndex : Integer) : TArray<TBytes>;overload;
    // Generates a read message.
    function Read(name : Variant; ot : TObjectType; attributeOrdinal : Integer): TArray<TBytes>;overload;

    // Generate Method (Action) request.
    function Method(item: TGXDLMSObject; index: Integer; data: TValue): TArray<TBytes>;overload;

    // Generate Method (Action) request.
    function Method(name : Variant; ot : TObjectType; index : Integer; value : TValue; dt : TDataType) : TArray<TBytes>;overload;
    property Objects : TGXDLMSObjectCollection read Get_Objects;
    property MaxReceivePDUSize: System.UInt16 read get_MaxReceivePDUSize write set_MaxReceivePDUSize default $FFFF;
    property UseLogicalNameReferencing: Boolean read get_UseLogicalNameReferencing write set_UseLogicalNameReferencing default False;
    property Password: TBytes read GetPassword write SetPassword;
    function GetKeepAlive() : TBytes;
    function SNRMRequest() : TBytes;
    procedure ParseUAResponse(Data : TGXByteBuffer);
    function AARQRequest() : TArray<TBytes>;
    procedure ParseAAREResponse(Data : TGXByteBuffer);
    function DisconnectRequest() : TBytes;
    function GetObjectsRequest() : TBytes;
    function GetApplicationAssociationRequest(): TArray<TBytes>;
    procedure ParseApplicationAssociationResponse(reply : TGXByteBuffer);
    procedure ParseObjects(data: TGXByteBuffer; onlyKnownObjects: Boolean);
    // Removes the frame from the packet, and returns DLMS PDU.
    function GetData(reply: TBytes; data: TGXReplyData): Boolean;

    function ReceiverReady(tp : TRequestTypes) : TBytes;
    function ReadRowsByEntry(pg: TGXDLMSProfileGeneric; Index : Integer; Count : Integer;columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;
    function ReadRowsByRange(pg: TGXDLMSProfileGeneric; startTime: TDateTime; endTime : TDateTime; columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;overload;
    function ReadRowsByRange(pg: TGXDLMSProfileGeneric; startTime: TGXDateTime; endTime : TGXDateTime; columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;overload;

    // Get Value from byte array received from the meter.
    function UpdateValue(target: TGXDLMSObject; attributeIndex: Integer; value: TValue) : TValue;overload;
    // Get Value from byte array received from the meter.
    function UpdateValue(target: TGXDLMSObject; attributeIndex: Integer; value: TValue; columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TValue;overload;

    function GetValue(data: TGXByteBuffer; dt: TDataType): TValue; overload;
  
    function CreateObject(ObjectType : TObjectType): TGXDLMSObject;

    class function ChangeType(value: TBytes; tp: TDataType): TValue;static;
    class function ObjectTypeToString(AObjectType : TObjectType) : String;

    // Is authentication Required.
    function IsAuthenticationRequired: Boolean;

    class function GetInitialConformance(useLogicalNameReferencing: Boolean): TConformance;
    // Converts meter serial number to server address.
    // Default formula is used.
    class function GetServerAddress(serialNumber: Integer): Integer; overload;

    // Converts meter serial number to server address.
    class function GetServerAddress(serialNumber: Integer; formula: string): Integer; overload;

end;

implementation

constructor TGXDLMSClient.Create;
begin
  FSettings := TGXDLMSSettings.Create(False);
  Self.ClientAddress := Byte($10);
  Self.ServerAddress := Byte(1);
  Self.Authentication := TAuthentication.atNone;
end;

constructor TGXDLMSClient.Create(
    UseLogicalNameReferencing : Boolean;
    //Client ID. Default is 0x10
    ClientAddress : Integer;
    //Server ID. Default is 1.
    ServerAddress : Integer;
    //Authentication type. Default is None
    Authentication : TAuthentication;
    //Password if authentication is used.
    Password : string;
    //Interface type. Default is general.
    intefaceType : TInterfaceType);
begin
  FSettings := TGXDLMSSettings.Create(False);
  Self.InterfaceType := intefaceType;
  Self.UseLogicalNameReferencing := UseLogicalNameReferencing;
  Self.ClientAddress := ClientAddress;
  Self.ServerAddress := ServerAddress;
  Self.Authentication := Authentication;
  Self.Password := TGXCommon.GetBytes(Password);
end;

constructor TGXDLMSClient.Create(
    UseLogicalNameReferencing: Boolean;
    //Client ID. Default is $10
    ClientAddress: Integer;
    //Server ID. Default is 1.
    ServerAddress: Integer;
    //Authentication type. Default is None
    Authentication : TAuthentication;
    //Password if authentication is used.
    Password: TBytes;
    //Interface type. Default is general.
    intefaceType : TInterfaceType);
var
  tmp: TBytes;
begin
  FSettings := TGXDLMSSettings.Create(False);
  Self.InterfaceType := intefaceType;
  Self.UseLogicalNameReferencing := UseLogicalNameReferencing;
  Self.ClientAddress := ClientAddress;
  Self.ServerAddress := ServerAddress;
  Self.Authentication := Authentication;
  tmp := FSettings.Password;
  SetLength(tmp, Length(Password));
  Move(Password[0], tmp[0], Length(Password));
end;

destructor TGXDLMSClient.Destroy;
begin
  inherited;
  FreeAndNil(FSettings);
end;

function TGXDLMSClient.GetNegotiatedConformance : TConformance;
begin
  Result := FSettings.NegotiatedConformance;
end;

procedure TGXDLMSClient.SetNegotiatedConformance(value: TConformance);
begin
  FSettings.NegotiatedConformance := value;
end;

function TGXDLMSClient.GetProposedConformance : TConformance;
begin
  Result := FSettings.ProposedConformance;
end;

procedure TGXDLMSClient.SetProposedConformance(value: TConformance);
begin
  FSettings.ProposedConformance := value;
end;

// Is authentication Required.
function TGXDLMSClient.IsAuthenticationRequired: Boolean;
begin
  Result := FSettings.IsAuthenticationRequired;
end;

function TGXDLMSClient.get_Authentication: TAuthentication;
begin
  Result := FSettings.Authentication;
end;

function TGXDLMSClient.get_Priority: TPriority;
begin
  Result := FSettings.Priority;
end;

function TGXDLMSClient.get_ServiceClass: TServiceClass;
begin
  Result := FSettings.ServiceClass;
end;

function TGXDLMSClient.get_InvokeID: Byte;
begin
  Result := FSettings.InvokeID;
end;

function TGXDLMSClient.get_InterfaceType: TInterfaceType;
begin
  Result := FSettings.InterfaceType;
end;

function TGXDLMSClient.get_Limits: TGXDLMSLimits;
begin
  Result := FSettings.Limits;
end;

procedure TGXDLMSClient.set_Authentication(Value: TAuthentication);
begin
  FSettings.Authentication := value;
end;

procedure TGXDLMSClient.set_Priority(Value: TPriority);
begin
  FSettings.Priority := value;
end;

procedure TGXDLMSClient.set_ServiceClass(Value: TServiceClass);
begin
  FSettings.ServiceClass := value;
end;

procedure TGXDLMSClient.set_InvokeID(Value: Byte);
begin
  FSettings.InvokeID := value;
end;

procedure TGXDLMSClient.set_InterfaceType(Value: TInterfaceType);
begin
  FSettings.InterfaceType := value;
end;

function TGXDLMSClient.get_ClientAddress: Integer;
begin
  Result := FSettings.ClientAddress;
end;

function TGXDLMSClient.get_ServerAddress: Integer;
begin
  Result := FSettings.ServerAddress;
end;

function TGXDLMSClient.get_MaxReceivePDUSize: System.UInt16;
begin
  Result := FSettings.MaxPduSize;
end;

function TGXDLMSClient.get_UseLogicalNameReferencing: Boolean;
begin
  Result := FSettings.UseLogicalNameReferencing;
end;

function TGXDLMSClient.GetPassword: TBytes;
begin
  Result := FSettings.Password;
end;

procedure TGXDLMSClient.SetPassword(Value: TBytes);
begin
  FSettings.Password := value;
end;

procedure TGXDLMSClient.set_ClientAddress(Value: Integer);
begin
  FSettings.ClientAddress := value;
end;

procedure TGXDLMSClient.set_ServerAddress(Value: Integer);
begin
  FSettings.ServerAddress := value;
end;

function TGXDLMSClient.get_Objects: TGXDLMSObjectCollection;
begin
  Result := FSettings.Objects;
end;

procedure TGXDLMSClient.set_MaxReceivePDUSize(Value: System.UInt16);
begin
  FSettings.MaxPduSize := value;
end;

procedure TGXDLMSClient.set_UseLogicalNameReferencing(Value: Boolean);
begin
  FSettings.UseLogicalNameReferencing := value;
end;

function TGXDLMSClient.GetKeepAlive() : TBytes;
begin
  // There is no need for keep alive in IEC 62056-47.
  if InterfaceType = TInterfaceType.WRAPPER Then
    Exit;
  if Objects.Count <> 0 Then
    Result := Read(Objects[0], 1)[0];
end;

function TGXDLMSClient.SNRMRequest() : TBytes;
var
  data: TGXByteBuffer;
begin
  FSettings.Connected := false;
  // SNRM request is not used in network connections.
  if InterfaceType = TInterfaceType.WRAPPER Then
      Exit;

  data := TGXByteBuffer.Create(25);
  data.SetUInt8($81); // FromatID
  data.SetUInt8($80); // GroupID
  data.SetUInt8(0); // Length.

  // If custom HDLC parameters are used.
  if DEFAULT_MAX_INFO_TX <> FSettings.Limits.MaxInfoTX Then
  begin
    data.SetUInt8(BYTE(THDLCInfo.MaxInfoTX));
    TGXDLMS.AppendHdlcParameter(data, FSettings.Limits.MaxInfoTX);
  end;
  if DEFAULT_MAX_INFO_RX <> FSettings.Limits.MaxInfoRX Then
  begin
    data.SetUInt8(BYTE(THDLCInfo.MaxInfoRX));
    TGXDLMS.AppendHdlcParameter(data, FSettings.Limits.MaxInfoRX);
   end;
  if DEFAULT_WINDOWS_SIZE_TX <> FSettings.Limits.WindowSizeTX Then
  begin
    data.SetUInt8(BYTE(THDLCInfo.WindowSizeTX));
    data.SetUInt8(4);
    data.SetUInt32(FSettings.Limits.WindowSizeTX);
   end;
  if DEFAULT_WINDOWS_SIZE_RX <> FSettings.Limits.WindowSizeRX Then
  begin
    data.SetUInt8(BYTE(THDLCInfo.WindowSizeRX));
    data.SetUInt8(4);
    data.SetUInt32(FSettings.Limits.WindowSizeRX);
   end;
  // If default HDLC parameters are not used.
  if data.size() <> 3 Then
    data.SetUInt8(2, data.size() - 3) // Length.
  else
  begin
    FreeAndNil(data);
    data := Nil;
  end;
  FSettings.ResetFrameSequence();
  Result := TGXDLMS.GetHdlcFrame(FSettings, Byte(TCommand.Snrm), Nil);
  FreeAndNil(data);
end;

procedure TGXDLMSClient.ParseUAResponse(Data : TGXByteBuffer);
var
  len: byte;
  val : Variant;
  id : THDLCInfo;
begin
  //If default settings are used.
  if data.Size <> 0 Then
  begin
    data.GetUInt8(); // Skip FromatID
    data.GetUInt8(); // Skip Group ID.
    data.GetUInt8(); // Skip Group len
    while data.Position < data.Size do
    begin
        id := THDLCInfo(data.GetUInt8());
        len := data.GetUInt8();
        case len of
        1: val := data.GetUInt8();
        2: val := data.GetUInt16();
        4: val := data.GetUInt32();
        else raise TGXDLMSException.Create('Invalid Exception.');
        end;
        // RX / TX are delivered from the partner's point of view =>
        // reversed to ours
        case id of
        THDLCInfo.MaxInfoTX: Limits.MaxInfoRX := val;
        HDLCInfo.MaxInfoRX: Limits.MaxInfoTX := val;
        HDLCInfo.WindowSizeTX: Limits.WindowSizeRX := val;
        HDLCInfo.WindowSizeRX: Limits.WindowSizeTX := val;
        else raise TGXDLMSException.Create('Invalid UA response.');
        end;
    end;
  end;
end;

function TGXDLMSClient.AARQRequest() : TArray<TBytes>;
var
  buff : TGXByteBuffer;
  p: TObject;
begin
 try
  p := Nil;
  buff := Nil;
  FSettings.NegotiatedConformance := TConformance(0);
  FSettings.ResetBlockIndex();
  FSettings.Connected := false;
  FSettings.StoCChallenge := Nil;
  TGXDLMS.CheckInit(FSettings);
  buff := TGXByteBuffer.Create();

   //If High authentication is used.
  if Authentication > TAuthentication.atLow Then
    if Not FSettings.UseCustomChallenge Then
      FSettings.CtoSChallenge := TGXSecure.GenerateChallenge
  else
    FSettings.CtoSChallenge := Nil;

  TGXAPDU.GenerateAarq(FSettings, FSettings.Cipher, Nil, buff);
  if UseLogicalNameReferencing Then
  begin
    p := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.Aarq, 0, buff, Nil, $ff);
    Result := TGXDLMS.GetLnMessages(TGXDLMSLNParameters(p));
  end
  else
  begin
    p:= TGXDLMSSNParameters.Create(FSettings, TCommand.Aarq, 0, 0, Nil, buff);
    Result := TGXDLMS.GetSnMessages(TGXDLMSSNParameters(p));
  end;
  finally
    FreeAndNil(p);
    FreeAndNil(buff);
  end;
end;

procedure TGXDLMSClient.ParseAAREResponse(Data : TGXByteBuffer);
var
  ret: TSourceDiagnostic;
begin
  ret := TGXAPDU.ParsePDU(FSettings, FSettings.Cipher, Data);
  FSettings.IsAuthenticationRequired := (ret = TSourceDiagnostic.AuthenticationRequired);
  //Some meters need disconnect even authentication is required.
  FSettings.Connected := true;
end;

function TGXDLMSClient.DisconnectRequest() : TBytes;
var
  bb : TGXByteBuffer;
begin
  //Reset to max PDU size when connection is closed.
  FSettings.MaxPduSize := $FFFF;
  // If connection is not established, there is no need to send
  // DisconnectRequest.
  if Not FSettings.Connected Then
    Exit;

  if FSettings.InterfaceType = TInterfaceType.HDLC Then
    Result := TGXDLMS.GetHdlcFrame(FSettings, Byte(TCommand.DisconnectRequest), Nil)
  else
  begin
    bb := TGXByteBuffer.Create(2);
    bb.SetUInt8(Byte(TCommand.ReleaseRequest));
    bb.SetUInt8($0);
    Result := TGXDLMS.GetWrapperFrame(FSettings, bb);
    FreeAndNil(bb);
  end;
end;

// Get challenge request if HLS authentication is used.
function TGXDLMSClient.GetApplicationAssociationRequest() : TArray<TBytes>;
var
  challenge, pw : TBytes;
  ic: LongWord;
  bb: TGXByteBuffer;
  tmp: Tvalue;
 begin

 if ((FSettings.Authentication <> TAuthentication.atHighECDSA) and
        (FSettings.Authentication <> TAuthentication.atHighGMAC) and
            ((FSettings.Password = Nil) or (Length(FSettings.Password) = 0))) Then
    raise EArgumentException.Create('Password is invalid.');

  FSettings.ResetBlockIndex();
  if FSettings.Authentication = TAuthentication.atHighGMAC Then
    pw := FSettings.Cipher.SystemTitle
  else
    pw := FSettings.Password;
  ic := 0;
  if FSettings.Cipher <> Nil Then
    ic := FSettings.Cipher.InvocationCounter;

  challenge := TGXSecure.Secure(FSettings, FSettings.Cipher, ic,
                                     FSettings.StoCChallenge, pw);
  bb := TGXByteBuffer.Create();
  bb.SetUInt8(Byte(TDataType.dtOctetString));
  TGXCommon.SetObjectCount(Length(challenge), bb);
  bb.SetArray(challenge);
  tmp := TValue.From(bb.ToArray());
  if UseLogicalNameReferencing Then
    Result := Method('0.0.40.0.0.255', TObjectType.otAssociationLogicalName,
                    1, tmp, TDataType.dtOctetString)
  else
    Result := Method($FA00, TObjectType.otAssociationShortName, 8, tmp,
                TDataType.dtOctetString);
  FreeAndNil(bb);
end;

// Parse server's challenge if HLS authentication is used.
procedure TGXDLMSClient.ParseApplicationAssociationResponse(reply : TGXByteBuffer);
var
  secret, tmp, value: TBytes;
  equals: Boolean;
  info: TGXDataInfo;
  bb, challenge: TGXByteBuffer;
  ic: LongWord;
begin
  info := TGXDataInfo.Create();
  equals := false;
  value := TGXCommon.GetData(reply, info).AsType<TBytes>;
  FreeAndNil(info);
  if value <> Nil Then
  begin
    ic := 0;
    if FSettings.Authentication = TAuthentication.atHighGMAC Then
    begin
        secret := FSettings.SourceSystemTitle;
        bb := TGXByteBuffer.Create(value);
        bb.GetUInt8();
        ic := bb.GetUInt32();
        FreeAndNil(bb);
    end
    else
      secret := FSettings.Password;

    tmp := TGXSecure.Secure(FSettings, FSettings.Cipher, ic,
                                 FSettings.CtoSChallenge, secret);
    challenge := TGXByteBuffer.Create(tmp);
    equals := challenge.Compare(value);
    FreeAndNil(challenge);
  end;
  if Not equals Then
    raise TGXDLMSException.Create('Invalid password. Server to Client challenge do not match.');
end;

function TGXDLMSClient.Method(item: TGXDLMSObject; index: Integer; data: TValue): TArray<TBytes>;
begin
  Result := Method(item.Name, item.ObjectType, index, data, TDataType.dtNone);
end;

function TGXDLMSClient.Method(name: Variant; ot: TObjectType; index: Integer;
      value: TValue; dt: TDataType) : TArray<TBytes>;
var
  attributeDescriptor, data : TGXByteBuffer;
  sn: WORD;
  ind, count : Integer;
  ln: LogicalName;
  p: TObject;
  requestType: Byte;
begin
  if (VarType(name) = VarEmpty) or (index < 1) then
      raise EArgumentException.Create('Invalid parameter');

  FSettings.ResetBlockIndex();
  if (dt = TDataType.dtNone) and Not value.IsEmpty Then
    dt := TGXDLMSConverter.GetDLMSDataType(value);

  attributeDescriptor := TGXByteBuffer.Create();
  data := TGXByteBuffer.Create();
  if value.IsType<TBytes> Then
    data.SetArray(value.AsType<TBytes>)
  else if dt <> TDataType.dtNone Then
    TGXCommon.SetData(data, dt, value);

  if UseLogicalNameReferencing Then
  begin
    // CI
    attributeDescriptor.SetUInt16(Integer(ot));
    // Add LN
    ln := TGXCommon.LogicalNameToBytes(String(name));
    attributeDescriptor.SetArray(ln);
    // Attribute ID.
    attributeDescriptor.SetUInt8(Byte(index));
    // Method Invocation Parameters is not used.
    if dt = TDataType.dtNone Then
      attributeDescriptor.SetUInt8(0)
    else
      attributeDescriptor.SetUInt8(1);

    p := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.MethodRequest,
      Byte(TActionRequestType.Normal), attributeDescriptor, data, $ff);
    Result := TGXDLMS.GetLnMessages(TGXDLMSLNParameters(p));
  end
  else
  begin
    if dt = TDataType.dtNone Then
      requestType := Byte(TVariableAccessSpecification.vaVariableName)
    else
      requestType := Byte(TVariableAccessSpecification.vaParameterisedAccess);
    ind := 0;
    count := 0;
    TGXDLMS.GetActionInfo(ot, @ind, @count);
      if index > count then
        raise EArgumentException.Create('methodIndex');

    sn := Integer(name);
    index := (ind + (index - 1) * $8);
    sn := sn + index;
    // Add name.
    attributeDescriptor.SetUInt16(sn);
    // Add selector.
    if dt <> TDataType.dtNone Then
        attributeDescriptor.SetUInt8(1);

    p := TGXDLMSSNParameters.Create(FSettings, TCommand.ReadRequest, 1, requestType, attributeDescriptor, data);
    Result := TGXDLMS.GetSnMessages(TGXDLMSSNParameters(p));
  end;
  FreeAndNil(attributeDescriptor);
  FreeAndNil(data);
  FreeAndNil(p);
end;

function TGXDLMSClient.Write(item: TGXDLMSObject; index: Integer) : TArray<TBytes>;
var
  value : TValue;
  p: TValueEventArgs;
  dt: TDataType;
begin
  if (item = Nil) or (index < 1) then
    raise TGXDLMSException.Create('Invalid parameter');

  p := TValueEventArgs.Create(FSettings, item, index, 0, Nil);

  value := item.GetValue(p);
  dt := item.GetDataType(index);
  if dt = TDataType.dtNone then
    dt := TGXCommon.GetDLMSDataType(value);
  FreeAndNil(p);
  Result := Write(item.Name, value, dt, item.ObjectType, index);
end;

function TGXDLMSClient.Write(name: Variant; value: TValue; dt: TDataType; ot: TObjectType; index: Integer) : TArray<TBytes>;
var
  data, attributeDescriptor : TGXByteBuffer;
  p: TObject;
  sn: WORD;
  ln: LogicalName;
begin

  if (VarType(name) = VarEmpty) or (index < 1) then
    raise TGXDLMSException.Create('Invalid parameter. Unknown value type.');

  if dt = TDataType.dtNone then
    raise TGXDLMSException.Create('Invalid parameter. Unknown value type.');

  FSettings.ResetBlockIndex();
  if (dt = TDataType.dtNone) and Not value.IsEmpty Then
  begin
    dt := TGXDLMSConverter.GetDLMSDataType(value);
    if dt = TDataType.dtNone Then
      raise EArgumentException.Create('Invalid parameter. Unknown value type.');
  end;
  attributeDescriptor := TGXByteBuffer.Create();
  data := TGXByteBuffer.Create();
try
  TGXCommon.SetData(data, dt, value);
  if UseLogicalNameReferencing Then
  begin
    // Add CI.
    attributeDescriptor.SetUInt16(WORD(ot));
    // Add LN.
    ln := TGXCommon.LogicalNameToBytes(string(name));
    attributeDescriptor.SetArray(ln);
    // Attribute ID.
    attributeDescriptor.SetUInt8(index);
    // Access selection is not used.
    attributeDescriptor.SetUInt8(0);
    p := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.SetRequest,
          Byte(TSetRequestType.Normal), attributeDescriptor, data, $ff);
    Result := TGXDLMS.GetLnMessages(TGXDLMSLNParameters(p));
  end
  else
  begin
    // Add name.
    sn := WORD(name);
    sn := sn + ((index - 1) * 8);
    attributeDescriptor.SetUInt16(sn);
    //Data cnt.
    attributeDescriptor.SetUInt8(1);
    p := TGXDLMSSNParameters.Create(FSettings, TCommand.WriteRequest, 1,
            Byte(TVariableAccessSpecification.vaVariableName), attributeDescriptor, data);
    Result := TGXDLMS.GetSnMessages(TGXDLMSSNParameters(p));
  end;
finally
  freeAndNil(p);
  freeAndNil(attributeDescriptor);
  freeAndNil(data);
end;
end;

// Read list of COSEM objects.
function TGXDLMSClient.ReadList(list: TList<TPair<TGXDLMSObject, Integer>>): TArray<TBytes>;
var
  sn, pos, count: Integer;
  data: TGXByteBuffer;
  p: TObject;
  it: TPair<TGXDLMSObject, Integer>;
  messages: TList<TBytes>;
  ln: LogicalName;
begin
  if (list = Nil) or (list.Count = 0) Then
    raise EArgumentException.Create('Invalid parameter.');

  try
    FSettings.ResetBlockIndex();
    messages := TList<TBytes>.Create();
    data := TGXByteBuffer.Create();
    if UseLogicalNameReferencing Then
    begin
      p := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.GetRequest, BYTE(TGetCommandType.ctWithList), Nil, data, $ff);
      //Request service primitive shall always fit in a single APDU.
      pos := 0;
      count := Floor((FSettings.MaxPduSize - 12) / 10);
      if list.Count < count Then
        count := list.Count;

      //All meters can handle 10 items.
      if (count > 10) Then
        count := 10;

      // Add length.
      TGXCommon.SetObjectCount(count, data);
      for it in list do
      begin
        // CI.
        data.SetUInt16(Integer(it.Key.ObjectType));
        // Add LN
        ln := TGXCommon.LogicalNameToBytes(it.Key.LogicalName);
        data.SetArray(ln);
        // Attribute ID.
        data.SetUInt8(BYTE(it.Value));
        // Attribute selector is not used.
        data.SetUInt8(0);
        pos := pos + 1;
        if (pos Mod count = 0) and (list.Count <> pos) Then
        begin
          messages.AddRange(TGXDLMS.GetLnMessages(TGXDLMSLNParameters(p)));
          data.Clear();
          if (list.Count - pos < count) Then
            TGXCommon.SetObjectCount(list.Count - pos, data)
          else
            TGXCommon.SetObjectCount(count, data);
        end;
      end;
     messages.AddRange(TGXDLMS.GetLnMessages(TGXDLMSLNParameters(p)));
    end
    else
    begin
      p := TGXDLMSSNParameters.Create(FSettings, TCommand.ReadRequest, list.Count, $FF, Nil, data);
      for it in list do
      begin
        // Add variable type.
        data.SetUInt8(BYTE(TVariableAccessSpecification.vaVariableName));
        sn := it.Key.ShortName + ((it.Value - 1) * 8);
        data.SetUInt16(Integer(sn));
        if data.Size >= FSettings.MaxPduSize Then
        begin
          messages.AddRange(TGXDLMS.GetSnMessages(TGXDLMSSNParameters(p)));
          data.Clear();
        end;
      end;
      messages.AddRange(TGXDLMS.GetSnMessages(TGXDLMSSNParameters(p)));
    end;
    Result := messages.ToArray();
  finally
    FreeAndNil(p);
    FreeAndNil(messages);
    FreeAndNil(data);
  end;
end;

function TGXDLMSClient.Read(it : TGXDLMSObject; attributeIndex : Integer) : TArray<TBytes>;
begin
  Result := Read(it.Name, it.ObjectType, attributeIndex, Nil);
end;

function TGXDLMSClient.Read(name: Variant; ot: TObjectType; attributeOrdinal: Integer) : TArray<TBytes>;
begin
  Result := Read(name, ot, attributeOrdinal, Nil);
end;

function TGXDLMSClient.Read(name : Variant; ot : TObjectType; attributeOrdinal : Integer; data: TGXByteBuffer) : TArray<TBytes>;
var
  attributeDescriptor: TGXByteBuffer;
  sn: WORD;
  ln: LogicalName;
  requestType: Byte;
  p: TObject;
begin
  if (VarType(name) = VarEmpty) or (attributeOrdinal < 1) then
    raise TGXDLMSException.Create('Invalid parameter');

  FSettings.ResetBlockIndex();
  attributeDescriptor := TGXByteBuffer.Create();
  p := Nil;
  try
    if UseLogicalNameReferencing Then
    begin
      // CI
      attributeDescriptor.SetUInt16(WORD(ot));
      // Add LN
      ln := TGXCommon.LogicalNameToBytes(string(name));
      attributeDescriptor.SetArray(ln);
      // Attribute ID.
      attributeDescriptor.SetUInt8(attributeOrdinal);
      if (data = Nil) or (data.Size = 0) Then
        // Access selection is not used.
        attributeDescriptor.SetUInt8(0)
      else
        // Access selection is used.
        attributeDescriptor.SetUInt8(1);

     p := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.GetRequest,
      Byte(TGetCommandType.ctNormal), attributeDescriptor, data, $ff);
     Result := TGXDLMS.GetLnMessages(TGXDLMSLNParameters(p));
    end
    else
    begin
        sn := WORD(name);
        sn := sn + ((attributeOrdinal - 1) * 8);
        attributeDescriptor.SetUInt16(sn);
        // parameterized-access
        if (data <> Nil) and (data.Size <> 0) Then
          requestType := Byte(TVariableAccessSpecification.vaParameterisedAccess)
        else
          //variable-name
          requestType := Byte(TVariableAccessSpecification.vaVariableName);
        p := TGXDLMSSNParameters.Create(FSettings, TCommand.ReadRequest, 1,
              requestType, attributeDescriptor, data);
        Result := TGXDLMS.GetSnMessages(TGXDLMSSNParameters(p));
    end;
  finally
    FreeAndNil(attributeDescriptor);
    FreeAndNil(p);
  end;
end;

function TGXDLMSClient.GetObjectsRequest() : TBytes;
var
  name : Variant;
begin
  if UseLogicalNameReferencing then
    name := '0.0.40.0.0.255'
  else
    name := Word($FA00);
  Result := Read(name, TObjectType.otAssociationLogicalName, 2)[0];
end;

procedure TGXDLMSClient.ParseObjects(data: TGXByteBuffer; onlyKnownObjects: Boolean);
var
  c: TGXDLMSConverter;
begin
  if (data = Nil) or (data.Size = 0) Then
    raise TGXDLMSException.Create('ParseObjects failed. Invalid parameter.');

  FSettings.Objects.Clear;

  if UseLogicalNameReferencing Then
    ParseLNObjects(data, onlyKnownObjects)
  else
    ParseSNObjects(data, onlyKnownObjects);

  c := TGXDLMSConverter.Create();
  c.UpdateOBISCodeInformation(objects);
  FreeAndNil(c);
end;

function TGXDLMSClient.CreateObject(ObjectType : TObjectType): TGXDLMSObject;
begin
  Result := CreateDLMSObject(Word(ObjectType), 0, 0, '', Nil);
end;

// Reserved for internal use.
class function TGXDLMSClient.CreateDLMSObject(ClassID : Word; Version : Word; BaseName : Word;
          LN : TValue; AccessRights : TValue) : TGXDLMSObject;

var
  tp : TObjectType;
begin
  tp := TObjectType(ClassID);
  if tp = TObjectType.otProfileGeneric Then
    Result := TGXDLMSProfileGeneric.Create()
  else if tp = TObjectType.otAssociationShortName Then
    Result := TGXDLMSAssociationShortName.Create()
  else if tp = TObjectType.otAssociationLogicalName Then
    Result := TGXDLMSAssociationLogicalName.Create()
  else
    Result := TGXObjectFactory.CreateObject(tp);
  UpdateObjectData(Result, tp, Version, BaseName, LN,
          AccessRights);
end;

// Reserved for internal use.
class procedure TGXDLMSClient.UpdateObjectData(obj : TGXDLMSObject; objectType : TObjectType;
  version : Word; baseName : TValue; logicalName : TValue; accessRights : TValue);
var
  mode : Integer;
  id : Integer;
  tmp, access : TArray<TValue>;
  attributeAccess, methodAccess : TValue;
begin
    obj.ObjectType := objectType;
    // Check access rights...
    if (Not accessRights.IsEmpty) then
    begin
        //access_rights: access_right
        access := accessRights.AsType<TArray<TValue>>;
        for attributeAccess in access[0].AsType<TArray<TValue>> do
        begin
            tmp := attributeAccess.AsType<TArray<TValue>>;
            id := tmp[0].AsInteger;
            mode := tmp[1].AsInteger;
            //With some meters id is negative.
            if id > 0 then
              obj.SetAccess(id, TAccessMode(mode));
        end;
        if Length(access) < 1 then
        begin
          for methodAccess in access[1].AsType<TArray<TValue>> do
          begin
            tmp := methodAccess.AsType<TArray<TValue>>;
            id := tmp[0].AsInteger;
            //If version is 0.
            if tmp[0].IsType<Boolean> then
            begin
               if tmp[0].AsBoolean then
                mode := 1
               else
                mode := 0
            end
            else //If version is 1.
              mode := tmp[0].AsInteger;

            obj.SetMethodAccess(id, TMethodAccessMode(mode));
          end;
        end;
    end;
    if Not baseName.IsEmpty then
      obj.ShortName := baseName.AsInteger;

    obj.Version := version;

    if logicalName.IsType<TBytes> then
      obj.LogicalName := TGXDLMSObject.ToLogicalName(logicalName.AsType<TBytes>)
    else
      obj.LogicalName := logicalName.ToString();
end;

// Reserved for internal use.
procedure TGXDLMSClient.ParseSNObjects(buff : TGXByteBuffer; onlyKnownObjects : Boolean);
var
  size: Byte;
  ot, baseName, pos, cnt: Integer;
  info: TGXDataInfo;
  objects: TArray<TValue>;
  comp: TGXDLMSObject;
begin
  try
    //Get array tag.
    size := buff.GetUInt8();
    //Check that data is in the array
    if size <> 1 Then
      raise TGXDLMSException.Create('Invalid response.');

    cnt := TGXCommon.GetObjectCount(buff);
    info := TGXDataInfo.Create();
    for pos := 0 to cnt do
    begin
      // Some meters give wrong item count.
      if buff.Position = buff.Size Then
          break;

      objects := TGXCommon.GetData(buff, info).AsType<TArray<TValue>>;
      info.Clear();
      if Length(objects) <> 4 Then
        raise TGXDLMSException.Create('Invalid structure format.');

      ot := objects[1].AsType<WORD>;
      baseName := objects[0].AsType<WORD> and $FFFF;
      if baseName > 0 Then
      begin
        comp := CreateDLMSObject(ot, objects[2].AsType<WORD>, baseName, objects[3], Nil);
        if comp.ClassType = TGXDLMSObject Then
          TGXCommon.Trace('Unknown object ' + ot.ToString + ' ' + objects[0].ToString());

        if (Not onlyKnownObjects) or (comp.ClassType <> TGXDLMSObject) then
          FSettings.Objects.Add(comp)
        else
          FreeAndNil(comp);
      end;
    end;
  finally
    FreeAndNil(info);
  end;
end;

//Reserved for internal use.
procedure TGXDLMSClient.ParseLNObjects(buff : TGXByteBuffer; onlyKnownObjects : Boolean);
var
  ot, cnt, objectCnt: Integer;
  objects: TArray<TValue>;
  comp : TGXDLMSObject;
  info: TGXDataInfo;
begin
  try
    cnt := buff.GetUInt8();
    //Check that data is in the array.
    if cnt <> 1 Then
        raise TGXDLMSException.Create('Invalid response.');

    //Get object count
    cnt := TGXCommon.GetObjectCount(buff);
    objectCnt := 0;
    info := TGXDataInfo.Create();
    //Some meters give wrong item count.
    while (buff.Position <> buff.Size) and (cnt <> objectCnt) do
    begin
      info.Clear();
      objects := TGXCommon.GetData(buff, info).AsType<TArray<TValue>>;
      if Length(objects) <> 4 Then
        raise TGXDLMSException.Create('Invalid structure format.');

      objectCnt := objectCnt + 1;
      ot := objects[0].AsType<WORD>;
      comp := CreateDLMSObject(ot, objects[1].AsType<WORD>, 0, objects[2], objects[3]);
      if comp.ClassType = TGXDLMSObject Then
        TGXCommon.Trace('Unknown object ' + ot.toString() + ' ' +
                  TGXDLMSObject.ToLogicalName(objects[2].AsType<TBytes>()));

      if (comp.ClassType <> TGXDLMSObject) or Not onlyKnownObjects then
        FSettings.Objects.Add(comp)
      else
        FreeAndNil(comp);
    end;
  finally
  FreeAndNil(info);
  end;
end;

function TGXDLMSClient.ReceiverReady(tp : TRequestTypes) : TBytes;
begin
  Result := TGXDLMS.ReceiverReady(FSettings, tp);
end;

function TGXDLMSClient.GetData(reply: TBytes; data: TGXReplyData): Boolean;
var
  tmp: TGXByteBuffer;
begin
  try
    tmp := TGXByteBuffer.Create(reply);
    Result := TGXDLMS.GetData(FSettings, tmp, data);
  finally
    FreeAndNil(tmp);
  end;
end;

function TGXDLMSClient.ReadRowsByRange(
  pg: TGXDLMSProfileGeneric;
  startTime: TGXDateTime;
  endTime : TGXDateTime;
  columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;
begin
  Result := ReadRowsByRange(pg, TValue.From(startTime), TValue.From(endTime), columns);
end;

function TGXDLMSClient.ReadRowsByRange(
  pg: TGXDLMSProfileGeneric;
  startTime: TDateTime;
  endTime : TDateTime;
  columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;
begin
  Result := ReadRowsByRange(pg, TValue.From(startTime), TValue.From(endTime), columns);
end;

function TGXDLMSClient.ReadRowsByRange(
  pg: TGXDLMSProfileGeneric;
  startTime: TValue;
  endTime : TValue;
  columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;
var
  ln: LogicalName;
  buff : TGXByteBuffer;
  it: TPair<TGXDLMSObject, TGXDLMSCaptureObject>;
begin
  pg.Reset();
  FSettings.ResetBlockIndex();
  buff := TGXByteBuffer.Create(51);
  try
    // Add AccessSelector value.
    buff.SetUInt8($01);
    // Add enum tag.
    buff.SetUInt8(Byte(TDataType.dtStructure));
    // Add item count
    buff.SetUInt8($04);
    // Add enum tag.
    buff.SetUInt8(Byte(TDataType.dtStructure));
    // Add item count
    buff.SetUInt8($04);
    // CI
    TGXCommon.SetData(buff, TDataType.dtUInt16, WORD(TObjectType.otClock));
    // LN
    ln := TGXCommon.LogicalNameToBytes('0.0.1.0.0.255');
    TGXCommon.SetData(buff, TDataType.dtOctetString, TValue.From(ln));
    // Add attribute index.                            1
    TGXCommon.SetData(buff, TDataType.dtInt8, 2);
    // Add version.
    TGXCommon.SetData(buff, TDataType.dtUInt16, 0);
    // Add start time.
    TGXCommon.SetData(buff, TDataType.dtOctetString, startTime);
    // Add end time.
    TGXCommon.SetData(buff, TDataType.dtOctetString, endTime);

    // Add array of read columns.
    buff.SetUInt8(Byte(TDataType.dtArray));
    if columns = Nil Then
      // Add item count
      buff.SetUInt8(0)
    else
    begin
      TGXCommon.SetObjectCount(columns.Count, buff);
      for it in columns do
      begin
        buff.SetUInt8(Byte(TDataType.dtStructure));
        // Add items count.
        buff.SetUInt8(4);
        // CI
        TGXCommon.SetData(buff, TDataType.dtUInt16, WORD(it.Key.ObjectType));
        // LN
        ln := TGXCommon.LogicalNameToBytes(it.Key.LogicalName);
        TGXCommon.SetData(buff, TDataType.dtOctetString, TValue.From(ln));
        // Add attribute index.
        TGXCommon.SetData(buff, TDataType.dtInt8, it.Value.AttributeIndex);
        // Add data index.
        TGXCommon.SetData(buff, TDataType.dtInt16, it.Value.DataIndex);
      end;
    end;
    Result := Read(pg.Name, TObjectType.otProfileGeneric, 2, buff);
  finally
    FreeAndNil(buff);
  end;
end;

function TGXDLMSClient.ReadRowsByEntry(
  pg: TGXDLMSProfileGeneric;
  Index : Integer;
  Count : Integer;
  columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TBytes>;
var
  buff : TGXByteBuffer;
  pos, columnIndex, columnCount: Integer;
  found: Boolean;
  c: TPair<TGXDLMSObject, TGXDLMSCaptureObject>;
  it: TPair<TGXDLMSObject, TGXDLMSCaptureObject>;
begin
try
  pg.Reset();
  FSettings.ResetBlockIndex();
  buff := TGXByteBuffer.Create(19);
  // Add AccessSelector value
  buff.SetUInt8($02);
  // Add enum tag.
  buff.SetUInt8(Byte(TDataType.dtStructure));
  // Add item count
  buff.SetUInt8($04);
  // Add start index
  TGXCommon.SetData(buff, TDataType.dtUInt32, index);
  // Add Count
  TGXCommon.SetData(buff, TDataType.dtUInt32, count);
  columnIndex := 1;
  columnCount := 0;
  // If columns are given find indexes.
  if (columns <> Nil) and (columns.Count <> 0) Then
  begin
    if (pg.CaptureObjects = Nil) or (pg.CaptureObjects.Count = 0) Then
      raise Exception.Create('Read capture objects first.');

    columnIndex := pg.CaptureObjects.Count;
    columnCount := 1;
    for c in columns do
    begin
      pos := 0;
      found := false;
      for it in pg.CaptureObjects do
      begin
          pos := pos + 1;
          if (it.Key.ObjectType = c.Key.ObjectType)
                  and (it.Key.LogicalName.CompareTo(c.Key.LogicalName) = 0)
                  and (it.Value.AttributeIndex = c.Value.AttributeIndex)
                  and (it.Value.DataIndex = c.Value.DataIndex) Then
          begin
            found := true;
            if pos < columnIndex Then
              columnIndex := pos;

            columnCount := pos - columnIndex + 1;
            break;
          end;
      end;
      if Not found Then
        raise Exception.Create('Invalid column: ' + c.Key.LogicalName);
    end;
  end;
  // Select columns to read.
  TGXCommon.SetData(buff, TDataType.dtUInt16, columnIndex);
  TGXCommon.SetData(buff, TDataType.dtUInt16, columnCount);
  Result := Read(pg.Name, TObjectType.otProfileGeneric, 2, buff);
finally
  FreeAndNil(buff);
end;
end;

function TGXDLMSClient.UpdateValue(target: TGXDLMSObject; attributeIndex: Integer; value: TValue) : TValue;
begin
  Result := UpdateValue(target, attributeIndex, value, Nil);
end;

function TGXDLMSClient.UpdateValue(target: TGXDLMSObject; attributeIndex: Integer; value: TValue; columns: TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TValue;
var
  tmp: TBytes;
  dt: TDataType;
  e: TValueEventArgs;
begin
  if value.IsType<TBytes> Then
  begin
    tmp := value.asType<TBytes>;
    dt := target.GetUIDataType(attributeIndex);
    if dt <> TDataType.dtNone Then
    begin
        if (dt = TDataType.dtDateTime) and (Length(tmp) = 5) Then
        begin
          dt := TDataType.dtDate;
          target.SetUIDataType(attributeIndex, dt);
        end;
        value := ChangeType(tmp, dt);
    end;
  end;
  try
    e := TValueEventArgs.Create(FSettings, target, attributeIndex, 0, columns);
    e.Value := value;
    target.SetValue(e);
    Result := target.GetValues()[attributeIndex - 1];
  finally
    FreeAndNil(e);
  end;
end;

// Update list values.
procedure TGXDLMSClient.UpdateValues(list: TList<TPair<TGXDLMSObject, Integer>>; values: TList<TValue>);
var
  it: TPair<TGXDLMSObject, Integer>;
  e: TValueEventArgs;
  pos: Integer;
begin
  pos := 0;
  for it in list do
  begin
    e := TValueEventArgs.Create(FSettings, it.Key, it.Value, 0, Nil);
    e.Value := values[pos];
    it.Key.SetValue(e);
    pos := pos + 1;
    FreeAndNil(e);
  end;
end;

function TGXDLMSClient.GetValue(data: TGXByteBuffer; dt: TDataType): TValue;
var
  info: TGXDataInfo;
begin
  info := TGXDataInfo.Create();
  try
  Result := TGXCommon.GetData(data, info);
  if (Result.IsType<TBytes>) and (dt <> TDataType.dtNone) Then
    Result := TGXDLMSClient.ChangeType(Result.AsType<TBytes>, dt);
  finally
    FreeAndNil(info);
  end;
end;

//Changes byte array received from the meter to given type.
class function TGXDLMSClient.ChangeType(value: TBytes; tp: TDataType): TValue;
begin
  Result := TGXCommon.ChangeType(value, tp);
end;

class function TGXDLMSClient.ObjectTypeToString(AObjectType : TObjectType) : String;
begin
  case AObjectType of
    otActionSchedule: Result := 'GXDLMSActionSchedule';
    otActivityCalendar: Result := 'GXDLMSActivityCalendar';
    otAssociationLogicalName: Result := 'GXDLMSAssociationLogicalName';
    otAssociationShortName: Result := 'GXDLMSAssociationShortName';
    otAutoAnswer: Result := 'GXDLMSAutoAnswer';
    otAutoConnect: Result := 'GXDLMSAutoConnect';
    otClock: Result := 'GXDLMSClock';
    otData: Result := 'GXDLMSData';
    otDemandRegister: Result := 'GXDLMSDemandRegister';
    otMacAddressSetup: Result := 'GXDLMSMacAddressSetup';
    otEvent: Result := 'GXDLMSEvent';
    otExtendedRegister: Result := 'GXDLMSExtendedRegister';
    otGprsSetup: Result := 'GXDLMSGprsSetup';
    otIecHdlcSetup: Result := 'GXDLMSIecHdlcSetup';
    otIecLocalPortSetup: Result := 'GXDLMSIecLocalPortSetup';
    otIecTwistedPairSetup: Result := 'GXDLMSIecTwistedPairSetup';
    otIp4Setup: Result := 'GXDLMSIp4Setup';
    otMBusSlavePortSetup: Result := 'GXDLMSMBusSlavePortSetup';
    otModemConfiguration: Result := 'GXDLMSModemConfiguration';
    otNone: Result := 'GXDLMSNone';
    otPushSetup: Result := 'GXDLMSPushSetup';
    otPppSetup: Result := 'GXDLMSPppSetup';
    otProfileGeneric: Result := 'GXDLMSProfileGeneric';
    otRegister: Result := 'GXDLMSRegister';
    otRegisterActivation: Result := 'GXDLMSRegisterActivation';
    otRegisterMonitor: Result := 'GXDLMSRegisterMonitor';
    otDisconnectControl: Result := 'GXDLMSDisconnectControl';
    otLimiter: Result := 'GXDLMSLimiter';
    otMBusClient: Result := 'GXDLMSMBusClient';
    otMessageHandler: Result := 'GXDLMSMessageHandler';
    otParameterMonitor: Result := 'GXDLMSParameterMonitor';
    otWirelessModeQchannel: Result := 'GXDLMSWirelessModeQchannel';
    otMBusMasterPortSetup: Result := 'GXDLMSMBusMasterPortSetup';
    otRegisterTable: Result := 'GXDLMSRegisterTable';
    otRemoteAnalogueControl: Result := 'GXDLMSRemoteAnalogueControl';
    otRemoteDigitalControl: Result := 'GXDLMSRemoteDigitalControl';
    otSapAssignment: Result := 'GXDLMSSapAssignment';
    otImageTransfer: Result := 'GXDLMSImageTransfer';
    otSchedule: Result := 'GXDLMSSchedule';
    otScriptTable: Result := 'GXDLMSScriptTable';
    otSmtpSetup: Result := 'GXDLMSSmtpSetup';
    otSpecialDaysTable: Result := 'GXDLMSSpecialDaysTable';
    otStatusMapping: Result := 'GXDLMSStatusMapping';
    otSecuritySetup: Result := 'GXDLMSSecuritySetup';
    otTcpUdpSetup: Result := 'GXDLMSTcpUdpSetup';
    otTunnel: Result := 'GXDLMSTunnel';
    otUtilityTables: Result := 'GXDLMSUtilityTables';
    else
      Result := 'Manufacturer spesific';
  end;
end;

class function TGXDLMSClient.GetInitialConformance(useLogicalNameReferencing: Boolean): TConformance;
begin
  Result := TGXDLMSSettings.GetInitialConformance(useLogicalNameReferencing);
end;

class function TGXDLMSClient.GetServerAddress(serialNumber: Integer): Integer;
begin
  Result := GetServerAddress(serialNumber, '');
end;

class function TGXDLMSClient.GetServerAddress(serialNumber: Integer; formula: string): Integer;
begin
    //If formula is not given use default formula.
    //This formula is defined in DLMS specification.
    if formula = '' Then
      formula := 'SN % 10000 + 1000';
    Result := $4000 or TSerialnumberCounter.Count(serialNumber, formula);
end;

end.

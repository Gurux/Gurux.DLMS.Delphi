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

unit Gurux.DLMS.GXDLMSServer;

interface
uses SysUtils, TypInfo, Rtti, Variants, System.Generics.Collections,
Gurux.DLMS.Authentication, Gurux.DLMS.Priority,
Gurux.DLMS.ServiceClass, Gurux.DLMS.InterfaceType, Gurux.DLMS.GXHDLCSettings,
Gurux.DLMS.GXDLMS, System.Math,
Gurux.DLMS.DataType, Gurux.DLMS.RequestTypes,
Gurux.DLMS.GXDLMSObject, Gurux.DLMS.ObjectType, GXAPDU,
GXCommon, Gurux.DLMS.Command, Gurux.DLMS.GXDLMSException, Gurux.DLMS.ActionType,
Gurux.DLMS.AccessMode, Gurux.DLMS.MethodAccessMode, Gurux.DLMS.GXCiphering,
Gurux.DLMS.Security, HDLCInfo, Gurux.DLMS.AssociationResult,
Gurux.DLMS.SourceDiagnostic, Gurux.DLMS.GXDateTime, Gurux.DLMS.DateTimeSkips,
Gurux.DLMS.GXStandardObisCodeCollection, Gurux.DLMS.GXStandardObisCode,
Gurux.DLMS.Objects.GXDLMSProfileGeneric,
Gurux.DLMS.Objects.GXDLMSData,
GXObjectFactory, GXByteBuffer,
Gurux.DLMS.Objects.GXDLMSAssociationShortName,
Gurux.DLMS.Objects.GXDLMSAssociationLogicalName,
Gurux.DLMS.Conformance,
Gurux.DLMS.GXDLMSLNParameters, Gurux.DLMS.GXDLMSSNParameters,
Gurux.DLMS.GXSecure, GXDataInfo, Gurux.DLMS.ActionRequestType,
Gurux.DLMS.VariableAccessSpecification,
Gurux.DLMS.GXDLMSConverter, Gurux.DLMS.SetRequestType,
Gurux.DLMS.GetCommandType, Gurux.DLMS.GXDLMSCaptureObject,
Gurux.DLMS.GXReplyData,
Gurux.DLMS.SerialnumberCounter,
Gurux.DLMS.GXDLMSGateway,
Gurux.DLMS.ConnectionState,
Gurux.DLMS.SetCommandType,
System.DateUtils,
Gurux.DLMS.ErrorCode,
Gurux.DLMS.AccessServiceCommandType,
Gurux.DLMS.GXDLMSAccessItem,
Gurux.DLMS.GXDLMSLongTransaction,
Gurux.DLMS.GXServerReply,
Gurux.DLMS.GXDLMSExceptionResponse,
Gurux.DLMS.Objects.GXDLMSHdlcSetup,
Gurux.DLMS.Objects.GXDLMSTcpUdpSetup,
Gurux.DLMS.GXDLMSConfirmedServiceError,
Gurux.DLMS.GXDLMSConnectionEventArgs,
Gurux.DLMS.Enums.ExceptionStateError,
Gurux.DLMS.Enums.ExceptionServiceError,
Gurux.DLMS.ConfirmedServiceError,
Gurux.DLMS.ServiceError,
Gurux.DLMS.LNCommandHandler,
Gurux.DLMS.SNCommandHandler,
Gurux.DLMS.GXDLMSServerNotifier,
Gurux.DLMS.Service,
Gurux.DLMS.Initiate,
Gurux.DLMS.Enums.AcseServiceProvider;

type
  // GXDLMSServer
  TGXDLMSServer = class abstract (TGXDLMSServerNotifier)
  private
    function AddPduToFrame(cmd: TCommand;frame: BYTE; data: TGXByteBuffer): TBytes;
    function ReportExceptionResponse(ex: TGXDLMSExceptionResponse): TBytes;
    function ReportError(cmd: TCommand; error: TErrorCode):TBytes;
    // Generate confirmed service error.
    class function GenerateConfirmedServiceError(service: TConfirmedServiceError; error: TServiceError; code: BYTE): TBytes;
    // Handle received command.
    function HandleCommand(cmd: TCommand; data: TGXByteBuffer; sr: TGXServerReply; cipheredCommand: TCommand): TBytes;
    // Generates disconnect request.
    procedure GenerateDisconnectRequest();
    //Parse SNRM Request. If server do not accept client empty byte array is returned.
    procedure HandleSnrmRequest(data: TGXByteBuffer);

    // Handles release request.
    procedure HandleReleaseRequest(data: TGXByteBuffer; connectionInfo: TGXDLMSConnectionEventArgs);

    //Parse AARQ request that client send and returns AARE request.
    procedure HandleAarqRequest(data: TGXByteBuffer; connectionInfo: TGXDLMSConnectionEventArgs);
    function HandleGeneralBlockTransfer(data: TGXByteBuffer; sr: TGXServerReply; cipheredCommand: TCommand): Boolean;
    function GetItems: TGXDLMSObjectCollection;
  protected
    //Server settings.
    FSettings: TGXDLMSSettings;
    FInfo : TGXReplyData;
    // Received data.
    FReceivedData : TGXByteBuffer;
    // Reply data.
    FReplyData: TGXByteBuffer;
    FTransaction: TGXDLMSLongTransaction;
    FDataReceived: TDateTime;
    FInitialized: Boolean;

  public
    // HDLC settings.
    Hdlc: TGXDLMSHdlcSetup;

    // Wrapper settings.
    Wrapper: TGXDLMSTcpUdpSetup;

    //Constructor.
    constructor Create();overload;
    constructor Create(ALogicalNameReferencing: BOOLEAN; AType: TInterfaceType); overload;

    procedure Reset(AConnected: Boolean);
    // Handles client request.
    procedure HandleRequest(sr: TGXServerReply);
    function GetAssignedAssociation(): TGXDLMSAssociationLogicalName;
    procedure SetAssignedAssociation(AValue: TGXDLMSAssociationLogicalName);
    property Items: TGXDLMSObjectCollection read GetItems;
    function GetConformance(): TConformance;
    procedure SetConformance(AValue: TConformance);
    ///  Initialize server.
    /// This must call after server objects are set.
    /// manually: If true, server handle objects and all data are updated manually.
    procedure Initialize(manually: Boolean);

    // Update short names.
    procedure UpdateShortNames(force: Boolean);
  end;

implementation

uses Gurux.DLMS.Enums.ApplicationContextName, Gurux.DLMS.AssociationStatus;

constructor TGXDLMSServer.Create();
begin
  Create(TRUE, TInterfaceType.HDLC);
end;

constructor TGXDLMSServer.Create(ALogicalNameReferencing: BOOLEAN; AType: TInterfaceType);
begin
    FSettings := TGXDLMSSettings.Create(True, AType);
    FInfo := TGXReplyData.Create();
    FReplyData := TGXByteBuffer.Create();
    FReceivedData := TGXByteBuffer.Create();
    FSettings.Plc.Reset();
    FSettings.Objects.Parent := Self;
    FSettings.ServerAddress := 1;
    FSettings.ClientAddress := 16;
    FSettings.UseLogicalNameReferencing := ALogicalNameReferencing;
    Reset(false);
    if AType = TInterfaceType.Plc Then
      FSettings.MaxServerPDUSize := 134;
end;

function TGXDLMSServer.AddPduToFrame(cmd: TCommand;frame: BYTE; data: TGXByteBuffer): TBytes;
begin
  case FSettings.InterfaceType of
  TInterfaceType.WRAPPER:
    Result := TGXDLMS.GetWrapperFrame(FSettings, cmd, data);
  TInterfaceType.HDLC, TInterfaceType.HdlcWithModeE:
    Result := TGXDLMS.GetHdlcFrame(FSettings, frame, data);
  TInterfaceType.Plc, TInterfaceType.PlcHdlc:
    Result := TGXDLMS.GetMacFrame(FSettings, frame, 0, data);
  TInterfaceType.PDU:
    Result := data.ToArray();
  else
   raise Exception.Create('Unknown interface type.');
  end;
end;

function TGXDLMSServer.HandleGeneralBlockTransfer(data: TGXByteBuffer; sr: TGXServerReply; cipheredCommand: TCommand): Boolean;
var
  bc: byte;
  windowSize, bn, blockNumber, blockNumberAck: UInt16;
  len: Integer;
  igonoreAck: BOOLEAN;
begin
    if FTransaction <> Nil Then
    begin
        if FTransaction.command = TCommand.GetRequest Then
        begin
            // Get request for next data block
            if sr.Count = 0 Then
            begin
                FSettings.BlockNumberAck := FSettings.BlockNumberAck + 1;
                sr.Count := FSettings.GBTWindowSize;
            end;
            TGXDLMSLNCommandHandler.GetRequestNextDataBlock(FSettings, Self, 0, data, FReplyData, Nil, true, cipheredCommand);
            if sr.Count <> 0 Then
            begin
                sr.Count := sr.Count - 1;
            end;
            if FTransaction = Nil Then
            begin
                sr.Count := 0;
            end;
        end
        else
        begin
            //BlockControl
            bc := data.GetUInt8();
            //Block number.
            blockNumber := data.GetUInt16();
            //Block number acknowledged.
            blockNumberAck := data.GetUInt16();
            len := TGXCommon.GetObjectCount(data);
            if len > data.Size - data.Position Then
            begin
                FReplyData.SetArray(GenerateConfirmedServiceError(TConfirmedServiceError.InitiateError,
                TServiceError.Service, BYTE(TService.Unsupported)));
            end
            else
            begin
                FTransaction.data.SetArray(data);
                //Send ACK.
                igonoreAck := ((bc and $40) <> 0) and ((blockNumberAck * WindowSize) + 1 > blockNumber);
                windowSize := FSettings.GBTWindowSize;
                bn := FSettings.BlockIndex;
                if (bc and $80) <> 0 Then
                begin
                  HandleCommand(FTransaction.command, FTransaction.data, sr, cipheredCommand);
                  FTransaction := Nil;
                  igonoreAck := false;
                  windowSize := 1;
                end;
                if igonoreAck Then
                begin
                    Result := False;
                    Exit;
                end;
                FReplyData.SetUInt8(BYTE(TCommand.GeneralBlockTransfer));
                FReplyData.SetUInt8($80 + windowSize);
                FSettings.BlockIndex := FSettings.BlockIndex + 1;
                FReplyData.SetUInt16(bn);
                FReplyData.SetUInt16(blockNumber);
                FReplyData.SetUInt8(0);
            end;
        end;
    end
    else
    begin
        //BlockControl
        bc := data.GetUInt8();
        //Block number.
        blockNumber := data.GetUInt16();
        //Block number acknowledged.
        blockNumberAck := data.GetUInt16();
        len := TGXCommon.GetObjectCount(data);
        if len > data.Size - data.Position Then
        begin
            FReplyData.SetArray(GenerateConfirmedServiceError(TConfirmedServiceError.InitiateError,
               TServiceError.Service, BYTE(TService.Unsupported)));
        end
        else
        begin
            FTransaction := TGXDLMSLongTransaction.Create(Nil, TCommand(data.GetUInt8()), data);
            FReplyData.SetUInt8(BYTE(TCommand.GeneralBlockTransfer));
            FReplyData.SetUInt8($80 + FSettings.GBTWindowSize);
            FReplyData.SetUInt16(blockNumber);
            blockNumberAck := blockNumberAck + 1;
            FReplyData.SetUInt16(blockNumberAck);
            FReplyData.SetUInt8(0);
        end;
    end;
    Result := True;
end;

function TGXDLMSServer.ReportExceptionResponse(ex: TGXDLMSExceptionResponse): TBytes;
var
  bb: TGXByteBuffer;
  ln: TGXDLMSLNParameters;
  sn: TGXDLMSSNParameters;
begin
    bb := TGXByteBuffer.Create();
    bb.SetUInt8(BYTE(TExceptionStateError.ServiceNotAllowed));
    bb.SetUInt8(BYTE(ex.FExceptionServiceError));
    if (ex.FExceptionServiceError = TExceptionServiceError.InvocationCounterError) Then
    begin
      FReplyData.SetUInt32(UInt32(FSettings.ExpectedInvocationCounter));
    end;
    if FSettings.UseLogicalNameReferencing Then
    begin
        ln := TGXDLMSLNParameters.Create(FSettings, 0, TCommand.ExceptionResponse, 1, bb, Nil, $FF, FInfo.CipheredCommand);
        try
          TGXDLMS.GetLNPdu(ln, FReplyData);
        finally
          FreeAndNil(ln);
        end;
    end
    else
    begin
        sn := TGXDLMSSNParameters.Create(FSettings, TCommand.ExceptionResponse, 1, 0, Nil, bb);
        try
        TGXDLMS.GetSNPdu(sn, FReplyData);
        finally
          FreeAndNil(sn);
        end;
    end;
    Result := AddPduToFrame(TCommand.ExceptionResponse, 0, FReplyData);
end;

function TGXDLMSServer.ReportError(cmd: TCommand; error: TErrorCode):TBytes;
var
 ln:TGXDLMSLNParameters;
 sn: TGXDLMSSNParameters;
 bb: TGXByteBuffer;
begin
    case cmd of
    TCommand.ReadRequest: cmd := TCommand.ReadResponse;
    TCommand.WriteRequest: cmd := TCommand.WriteResponse;
    TCommand.GetRequest: cmd := TCommand.GetResponse;
    TCommand.SetRequest: cmd := TCommand.SetResponse;
    TCommand.MethodRequest: cmd := TCommand.MethodResponse;
    TCommand.GeneralSigning: cmd := TCommand.ExceptionResponse;
    TCommand.GeneralCiphering: cmd := TCommand.ExceptionResponse;
    TCommand.GeneralDedCiphering: cmd := TCommand.ExceptionResponse;
    TCommand.GeneralGloCiphering: cmd := TCommand.ExceptionResponse;
    end;
    if FSettings.UseLogicalNameReferencing Then
    begin
      ln := TGXDLMSLNParameters.Create(FSettings, 0, cmd, 1, Nil, Nil, BYTE(error), FInfo.CipheredCommand);
      try
        TGXDLMS.GetLNPdu(ln, FReplyData);
      finally
        FreeAndNil(ln);
      end;
    end
    else
    begin
      bb := TGXByteBuffer.Create();
      try
        bb.SetUInt8(BYTE(error));
        sn := TGXDLMSSNParameters.Create(FSettings, cmd, 1, BYTE(error), Nil, bb);
        try
          TGXDLMS.GetSNPdu(sn, FReplyData);
        finally
          FreeAndNil(sn);
        end;
      finally
        FreeAndNil(bb);
      end;
    end;
    Result := AddPduToFrame(cmd, 0, FReplyData);
end;

function TGXDLMSServer.GetItems: TGXDLMSObjectCollection;
begin
  Result := FSettings.Objects;
end;

procedure TGXDLMSServer.Reset(AConnected: Boolean);
begin
  FSettings.ProtocolVersion := '';
  // Reset Ephemeral keys.
  FSettings.EphemeralBlockCipherKey := Nil;
  FSettings.EphemeralBroadcastBlockCipherKey := Nil;
  FSettings.EphemeralAuthenticationKey := Nil;
  FSettings.EphemeralKek := Nil;
  FTransaction := Nil;
  FSettings.BlockIndex := 1;
  FSettings.Count := 0;
  FSettings.Index := 0;
  FSettings.Connected := TConnectionState.csNone;
  FReplyData.Clear();
  FReceivedData.Clear();
  FSettings.Password := Nil;
  if Not AConnected Then
  begin
    FInfo.Clear();
    FSettings.ServerAddress := 0;
    FSettings.ClientAddress := 0;
  end;
  FSettings.Authentication := TAuthentication.atNone;
  if FSettings.Cipher <> Nil Then
  begin
    if Not AConnected Then
      FSettings.Cipher.Reset()
    else
      FSettings.Cipher.Security := TSecurity.None;
  end;
  FDataReceived := 0;
end;

// Handles client request.
procedure TGXDLMSServer.HandleRequest(sr: TGXServerReply);
var
  first: BOOLEAN;
  elapsed: Integer;
begin
  sr.Reply := Nil;
  if Not sr.IsStreaming and ((sr.Data = Nil) or (Length(sr.Data) = 0)) Then
    Exit;

  if Not FInitialized Then
    raise Exception.Create('Server not Initialized.');

  try
    if not sr.IsStreaming Then
    begin
      FReceivedData.SetArray(sr.Data);
      first := (FSettings.ServerAddress = 0) and (FSettings.ClientAddress = 0);
      try
        TGXDLMS.GetData(FSettings, FReceivedData, FInfo, Nil);
      except
      on E: TGXDLMSExceptionResponse do
      begin
        FDataReceived := Now;
        FReceivedData.Size := 0;
        sr.Reply := ReportExceptionResponse(E);
        FInfo.Clear();
        Exit;
      end;
      on E: Exception do
      begin
        FDataReceived := Now;
        FReceivedData.Size := 0;
        sr.Reply := ReportError(FInfo.Command, TErrorCode.ecHardwareFault);
        FInfo.Clear();
        Exit;
      end;
      end;
      //If all data is not received yet.
      if not FInfo.Complete Then
        Exit;

      FReceivedData.Clear();
      sr.Command := FInfo.Command;
      if (FInfo.Command = TCommand.DisconnectRequest) and (FSettings.Connected = TConnectionState.csNone) Then
      begin
        // Check is data send to this server.
        if IsTarget(FSettings.ServerAddress, FSettings.ClientAddress) Then
            sr.Reply := TGXDLMS.GetHdlcFrame(FSettings, BYTE(TCommand.DisconnectMode), FReplyData);
        FInfo.Clear();
        Exit;
      end;
      //If data is send using GW.
      if (FInfo.Gateway <> Nil) Then
      begin
        sr.Gateway := FInfo.Gateway;
        sr.Data := FInfo.Data.ToArray();
        FInfo.Command := TCommand.None;
        FInfo.Data.Clear();
        Exit;
      end;
      if ((first or (FInfo.Command = TCommand.Snrm) or
          ((FSettings.InterfaceType = TInterfaceType.WRAPPER) and (FInfo.Command = TCommand.Aarq))) and
          (FSettings.InterfaceType <> TInterfaceType.PDU)) Then
      begin
        // Check is data send to this server.
        if Not IsTarget(FSettings.ServerAddress, FSettings.ClientAddress) Then
        begin
          FInfo.Clear();
          FSettings.ClientAddress := 0;
          FSettings.ServerAddress := 0;
          Exit;
        end;
      end;

      //If client want next frame.
      if (Integer(FInfo.MoreData) and Integer(TRequestTypes.rtFrame)) = Integer(TRequestTypes.rtFrame) Then
      begin
        FDataReceived := Now;
        sr.Reply := TGXDLMS.GetHdlcFrame(FSettings, FSettings.ReceiverReady(), FReplyData);
        Exit;
      end;
      //Update command if transaction and next frame is asked.
      if (FInfo.Command = TCommand.None) Then
      begin
        if FTransaction <> Nil Then
          FInfo.Command := FTransaction.Command
        else if (FReplyData.Size = 0) Then
        begin
          sr.Reply := TGXDLMS.GetHdlcFrame(FSettings, FSettings.ReceiverReady(), FReplyData);
          Exit;
        end;
      end;
      //Check inactivity time out.
      if (Hdlc <> Nil) and (Hdlc.InactivityTimeout <> 0) Then
      begin
        if FInfo.Command <> TCommand.Snrm Then
        begin
            elapsed := MilliSecondsBetween(Now, FDataReceived);
            //If inactivity time out is elapsed.
            if elapsed >= Hdlc.InactivityTimeout Then
            begin
              Reset(false);
              Exit;
            end;
        end;
      end
      else if (Wrapper <> Nil) and (Wrapper.InactivityTimeout <> 0) Then
      begin
        if (FInfo.Command <> TCommand.Aarq) Then
        begin
          elapsed := MilliSecondsBetween(Now, FDataReceived);
          //If inactivity time out is elapsed.
          if elapsed >= Wrapper.InactivityTimeout Then
          begin
            Reset(False);
            Exit;
          end;
        end;
      end
      else
          FInfo.Command := TCommand.GeneralBlockTransfer;
    try
      sr.Reply := HandleCommand(FInfo.Command, FInfo.Data, sr, FInfo.CipheredCommand);
    except on E: Exception do
      begin
        FReceivedData.Size := 0;
        if (FSettings.InterfaceType = TInterfaceType.HDLC) or (FSettings.InterfaceType = TInterfaceType.HdlcWithModeE) Then
          sr.Reply := TGXDLMS.GetHdlcFrame(FSettings, BYTE(TCommand.UnacceptableFrame), FReplyData);
        FInfo.Clear();
        FDataReceived := Now;
      end;
    on E: TGXDLMSConfirmedServiceError do
    begin
      FReplyData.Clear();
      FReplyData.SetArray(GenerateConfirmedServiceError(e.ConfirmedServiceError, e.ServiceError, e.ServiceErrorValue));
      FInfo.Clear();
      sr.Reply := AddPduToFrame(FInfo.Command, 0, FReplyData);
      end;
    end;
    end;
  except on E: Exception do
  if (FInfo.Command <> TCommand.None) Then
  begin
    sr.Reply := ReportError(FInfo.Command, TErrorCode.ecHardwareFault);
    FInfo.Clear();
  end
  else
  begin
      Reset(false);
      if FSettings.Connected = TConnectionState.csDlms Then
      begin
        FSettings.Connected := TConnectionState(Integer(FSettings.Connected) and not Integer(TConnectionState.csDlms));
        Disconnected(sr.ConnectionInfo);
      end;
  end;
      end;
  end;

class function TGXDLMSServer.GenerateConfirmedServiceError(service: TConfirmedServiceError ; error: TServiceError; code: BYTE): TBytes;
begin
  Result := TBytes.Create(BYTE(TCommand.ConfirmedServiceError), BYTE(service), BYTE(error), code);
end;

function TGXDLMSServer.HandleCommand(cmd: TCommand; data: TGXByteBuffer; sr: TGXServerReply; cipheredCommand: TCommand): TBytes;
var
  frame: BYTE;
begin
    frame := 0;
    if TGXDLMS.UseHdlc(FSettings.InterfaceType) and (FReplyData.Size <> 0) Then
    begin
      //Get next frame.
      frame := FSettings.NextSend(false);
    end;
    case cmd of
      TCommand.AccessRequest:
          TGXDLMSLNCommandHandler.HandleAccessRequest(FSettings, Self, data, FReplyData, Nil, cipheredCommand);
      TCommand.SetRequest:
          TGXDLMSLNCommandHandler.HandleSetRequest(FSettings, Self, data, FReplyData, Nil, cipheredCommand);
      TCommand.WriteRequest:
          TGXDLMSSNCommandHandler.HandleWriteRequest(FSettings, Self, data, FReplyData, Nil, cipheredCommand);
      TCommand.GetRequest:
          if data.Size <> 0 Then
              TGXDLMSLNCommandHandler.HandleGetRequest(FSettings, Self, data, FReplyData, Nil, cipheredCommand);
      TCommand.ReadRequest:
          TGXDLMSSNCommandHandler.HandleReadRequest(FSettings, Self, data, FReplyData, Nil, cipheredCommand);
      TCommand.MethodRequest:
          TGXDLMSLNCommandHandler.HandleMethodRequest(FSettings, Self, data, sr.ConnectionInfo, FReplyData, Nil, cipheredCommand);
      TCommand.Snrm:
      begin
          HandleSnrmRequest(data);
          frame := BYTE(TCommand.Ua);
          FSettings.Connected := TConnectionState.csHdlc;
          end;
      TCommand.Aarq:
          HandleAarqRequest(data, sr.ConnectionInfo);
      TCommand.ReleaseRequest:
      begin
          HandleReleaseRequest(data, sr.ConnectionInfo);
          FSettings.Connected := TConnectionState(Integer(FSettings.Connected) and Not Integer(TConnectionState.csDlms));
          Disconnected(sr.ConnectionInfo);
      end;
      TCommand.DisconnectRequest:
      begin
          GenerateDisconnectRequest();
          if FSettings.Connected > TConnectionState.csNone Then
          begin
              if (Integer(FSettings.Connected) and Integer(TConnectionState.csDlms)) <> 0 Then
                  Disconnected(sr.ConnectionInfo);
              FSettings.Connected := TConnectionState.csNone;
          end;
          frame := BYTE(TCommand.Ua);
      end;
      TCommand.GeneralBlockTransfer:
          if Not HandleGeneralBlockTransfer(data, sr, FInfo.CipheredCommand) Then
          begin
            Result := Nil;
            Exit;
          end;
      TCommand.DiscoverRequest:
      begin
          FSettings.Plc.ParseDiscoverRequest(data);
          Result := FSettings.Plc.DiscoverReport(FSettings.Plc.SystemTitle, (FSettings.Plc.MacSourceAddress = $FFE) and (FSettings.Plc.MacDestinationAddress = $FFF));
          Exit;
      end;
      TCommand.RegisterRequest:
      begin
        FSettings.Plc.ParseRegisterRequest(data);
        Result := FSettings.Plc.DiscoverReport(FSettings.Plc.SystemTitle, false);
        Exit;
      end;
      TCommand.GeneralSigning:
          Exit;
      TCommand.PingRequest:
          Exit;
      TCommand.None:
          //Get next frame.
          Exit;
      else
            raise Exception.Create('Invalid command.');
    end;
    Result := AddPduToFrame(cmd, frame, FReplyData);
    if (cmd = TCommand.DisconnectRequest) or
        ((FSettings.InterfaceType = TInterfaceType.WRAPPER) and (cmd = TCommand.ReleaseRequest)) Then
    begin
        Reset(False);
    end;
  end;

  procedure TGXDLMSServer.HandleAarqRequest(data: TGXByteBuffer; connectionInfo: TGXDLMSConnectionEventArgs);
  var
    error: TGXByteBuffer;
    result: TAssociationResult;
    name: Byte;
    ret: TValue;
    ln: TGXDLMSAssociationLogicalName;
  begin
    error := Nil;
    result := TAssociationResult.Accepted;
    FSettings.CtoSChallenge := Nil;
    if FSettings.Cipher <> Nil Then
    begin
      FSettings.Cipher.DedicatedKey := Nil;
    end;
    if Not FSettings.UseCustomChallenge Then
    begin
        fSettings.StoCChallenge := Nil;
    end;
    // Reset settings for wrapper and raw PDU.
    if (FSettings.InterfaceType = TInterfaceType.WRAPPER) or
        (FSettings.InterfaceType = TInterfaceType.PDU) Then
    begin
        Reset(true);
    end;
    name := 0;
    try
    begin
        ret := TGXAPDU.ParsePDU(FSettings, FSettings.Cipher, data, Nil);
        if ret.IsType<TExceptionServiceError> Then
        begin
            if TGXDLMS.UseHdlc(FSettings.InterfaceType) Then
            begin
                FReplyData.SetArray(GXCommon.LLCReplyBytes);
            end;
            FReplyData.SetUInt8(BYTE(TCommand.ExceptionResponse));
            FReplyData.SetUInt8(BYTE(TExceptionStateError.ServiceNotAllowed));
            FReplyData.SetUInt8(BYTE(ret.AsType<TExceptionServiceError>()));
            if ret.AsType<TExceptionServiceError>() = TExceptionServiceError.InvocationCounterError Then
            begin
              FReplyData.SetUInt32(FSettings.ExpectedInvocationCounter);
            end;
            Exit;
        end;
        if Not ret.IsType<TAcseServiceProvider> Then
        begin
            if ret.IsType<TApplicationContextName> Then
            begin
                name := ret.AsType<Integer>();
                result := TAssociationResult.PermanentRejected;
                ret := TValue.From(TSourceDiagnostic.ApplicationContextNameNotSupported);
            end
            else if FSettings.NegotiatedConformance = TConformance.cfNone Then
            begin
                result := TAssociationResult.PermanentRejected;
                ret := TValue.From(TSourceDiagnostic.NoReasonGiven);
                error := TGXByteBuffer.Create();
                error.SetUInt8($E);
                error.SetUInt8(BYTE(TConfirmedServiceError.InitiateError));
                error.SetUInt8(BYTE(TServiceError.Initiate));
                error.SetUInt8(BYTE(TInitiate.IncompatibleConformance));
            end
            //If PDU is too low.
            else if FSettings.MaxPduSize < 64 Then
            begin
                result := TAssociationResult.PermanentRejected;
                ret := TValue.From(TSourceDiagnostic.NoReasonGiven);
                error := TGXByteBuffer.Create();
                error.SetUInt8($E);
                error.SetUInt8(BYTE(TConfirmedServiceError.InitiateError));
                error.SetUInt8(BYTE(TServiceError.Initiate));
                error.SetUInt8(BYTE(TInitiate.PduSizeTooShort));
            end
            else if FSettings.DLMSVersion <> 6 Then
            begin
              FSettings.DLMSVersion := 6;
              result := TAssociationResult.PermanentRejected;
              ret := TValue.From(TSourceDiagnostic.NoReasonGiven);
              error := TGXByteBuffer.Create();
              error.SetUInt8($E);
              error.SetUInt8(BYTE(TConfirmedServiceError.InitiateError));
              error.SetUInt8(BYTE(TServiceError.Initiate));
              error.SetUInt8(BYTE(TInitiate.DlmsVersionTooLow));
            end
            else if ret.AsType<TSourceDiagnostic>() <> TSourceDiagnostic.None Then
            begin
              result := TAssociationResult.PermanentRejected;
              ret := TValue.From(TSourceDiagnostic.ApplicationContextNameNotSupported);
              InvalidConnection(connectionInfo);
            end
            else
            begin
              ret := TValue.From(ValidateAuthentication(FSettings.Authentication, FSettings.Password));
              if ret.AsType<TSourceDiagnostic>() <> TSourceDiagnostic.None Then
              begin
                  result := TAssociationResult.PermanentRejected;
                  InvalidConnection(connectionInfo);
              end
              else if FSettings.Authentication > TAuthentication.atLow Then
              begin
                  // If High authentication is used.
                  result := TAssociationResult.Accepted;
                  ret := TValue.From(TSourceDiagnostic.AuthenticationRequired);
                  if FSettings.UseLogicalNameReferencing Then
                  begin
                      ln := TGXDLMSAssociationLogicalName(GetAssignedAssociation());
                      if ln = Nil Then
                      begin
                          ln := TGXDLMSAssociationLogicalName(Items.FindByLN(TObjectType.otAssociationLogicalName, '0.0.40.0.0.255'));
                          if ln = Nil Then
                          begin
                              ln := TGXDLMSAssociationLogicalName(FindObject(TObjectType.otAssociationLogicalName, 0, '0.0.40.0.0.255'));
                          end;
                      end;
                      if ln <> Nil Then
                      begin
                         ln.AssociationStatus := TAssociationStatus.AssociationPending;
                      end;
                  end;
              end
              else
              begin
                  if FSettings.UseLogicalNameReferencing Then
                  begin
                      ln := TGXDLMSAssociationLogicalName(GetAssignedAssociation());
                      if ln = Nil Then
                      begin
                          ln := TGXDLMSAssociationLogicalName(Items.FindByLN(TObjectType.otAssociationLogicalName, '0.0.40.0.0.255'));
                          if ln = Nil Then
                          begin
                              ln := TGXDLMSAssociationLogicalName(FindObject(TObjectType.otAssociationLogicalName, 0, '0.0.40.0.0.255'));
                          end;
                      end;
                      if ln <> Nil Then
                      begin
                          ln.AssociationStatus := TAssociationStatus.Associated;
                      end;
                  end;
                  Connected(connectionInfo);
                  FSettings.Connected := TConnectionState(Integer(FSettings.Connected) or Integer(TConnectionState.csDlms));
              end;
          end;
        end
        else if (result = TAssociationResult.Accepted) and (ret.AsType<Integer> <> 0) Then
        begin
            result := TAssociationResult.PermanentRejected;
        end;
    end;
    except
    on e: TGXDLMSException do
    begin
        result := TGXDLMSException(e).Result;
        ret := TValue.From(TSourceDiagnostic(TGXDLMSException(e).Diagnostic));
    end;
    end;
    if (FSettings.Authentication > TAuthentication.atLow) and Not FSettings.UseCustomChallenge Then
    begin
        // If High authentication is used.
        FSettings.StoCChallenge := TGXSecure.GenerateChallenge();
    end;
    if TGXDLMS.UseHdlc(FSettings.InterfaceType) Then
    begin
      FReplyData.SetArray(GXCommon.LLCReplyBytes);
    end;
    // Generate AARE packet.
    TGXAPDU.GenerateAARE(FSettings, FReplyData, result, ret, FSettings.Cipher, error, Nil);
  end;

  procedure TGXDLMSServer.HandleReleaseRequest(data: TGXByteBuffer; connectionInfo: TGXDLMSConnectionEventArgs);
  var
    tmp : TBytes;
  begin
    //Return error if connection is not established.
    if Integer(FSettings.Connected) and Integer(TConnectionState.csDlms) = 0 Then
    begin
        FReplyData.SetArray(GenerateConfirmedServiceError(TConfirmedServiceError.InitiateError,
                      TServiceError.Service, BYTE(TService.Unsupported)));
        Exit;
    end;
    if TGXDLMS.UseHdlc(FSettings.InterfaceType) Then
    begin
        FReplyData.SetArray(0, LLCReplyBytes);
    end;
    tmp := TGXAPDU.GetUserInformation(FSettings, FSettings.Cipher);
    if (FSettings.Gateway <> Nil) and (FSettings.Gateway.PhysicalDeviceAddress <> Nil) Then
    begin
      FReplyData.SetUInt8(BYTE(TCommand.GatewayResponse));
      FReplyData.SetUInt8(FSettings.Gateway.NetworkId);
      FReplyData.SetUInt8(Length(FSettings.Gateway.PhysicalDeviceAddress));
      FReplyData.SetArray(FSettings.Gateway.PhysicalDeviceAddress);
    end;
    FReplyData.SetUInt8($63);
    //Len.
    FReplyData.SetUInt8(Length(tmp) + 3);
    FReplyData.SetUInt8($80);
    FReplyData.SetUInt8($01);
    FReplyData.SetUInt8($00);
    FReplyData.SetUInt8($BE);
    FReplyData.SetUInt8(Length(tmp) + 1);
    FReplyData.SetUInt8(4);
    FReplyData.SetUInt8(Length(tmp));
    FReplyData.SetArray(tmp);
  end;

procedure TGXDLMSServer.HandleSnrmRequest(data: TGXByteBuffer);
begin
  TGXDLMS.ParseSnrmUaResponse(data, FSettings);
  Reset(true);
  if Hdlc <> Nil Then
  begin
    //If client wants send larger HDLC frames what meter accepts.
    if FSettings.Hdlc.MaxInfoTX > Hdlc.MaximumInfoLengthReceive Then
        FSettings.Hdlc.MaxInfoTX := Hdlc.MaximumInfoLengthReceive;
    //If client wants receive larger HDLC frames what meter accepts.
    if FSettings.Hdlc.MaxInfoRX > Hdlc.MaximumInfoLengthTransmit Then
        FSettings.Hdlc.MaxInfoRX := Hdlc.MaximumInfoLengthTransmit;
    //If client asks higher window size what meter accepts.
    if FSettings.Hdlc.WindowSizeTX > Hdlc.WindowSizeReceive Then
        FSettings.Hdlc.WindowSizeTX := Hdlc.WindowSizeReceive;
    //If client asks higher window size what meter accepts.
    if FSettings.Hdlc.WindowSizeRX > Hdlc.WindowSizeTransmit Then
        FSettings.Hdlc.WindowSizeRX := Hdlc.WindowSizeTransmit;
  end;
  FReplyData.SetUInt8($81); // FromatID
  FReplyData.SetUInt8($80); // GroupID
  FReplyData.SetUInt8(0); // Length
  FReplyData.SetUInt8(BYTE(HDLCInfo.MaxInfoTX));
  TGXDLMS.AppendHdlcParameter(FReplyData, FSettings.Hdlc.MaxInfoTX);
  FReplyData.SetUInt8(BYTE(HDLCInfo.MaxInfoRX));
  TGXDLMS.AppendHdlcParameter(FReplyData, FSettings.Hdlc.MaxInfoRX);
  FReplyData.SetUInt8(BYTE(HDLCInfo.WindowSizeTX));
  FReplyData.SetUInt8(4);
  FReplyData.SetUInt32(FSettings.Hdlc.WindowSizeTX);
  FReplyData.SetUInt8(BYTE(HDLCInfo.WindowSizeRX));
  FReplyData.SetUInt8(4);
  FReplyData.SetUInt32(FSettings.Hdlc.WindowSizeRX);
  FReplyData.SetUInt8(2, (FReplyData.Size - 3));
end;

procedure TGXDLMSServer.GenerateDisconnectRequest();
begin
  //Return error if connection is not established.
  if (Integer(FSettings.Connected) and Integer(TConnectionState.csHdlc)) = 0 Then
  begin
      FReplyData.SetArray(GenerateConfirmedServiceError(TConfirmedServiceError.InitiateError,
                    TServiceError.Service, BYTE(TService.Unsupported)));
      Exit;
  end;

  FReplyData.SetUInt8($81); // FromatID
  FReplyData.SetUInt8($80); // GroupID
  FReplyData.SetUInt8(0); // Length

  FReplyData.SetUInt8(BYTE(HDLCInfo.MaxInfoTX));
  TGXDLMS.AppendHdlcParameter(FReplyData, FSettings.Hdlc.MaxInfoTX);

  FReplyData.SetUInt8(BYTE(HDLCInfo.MaxInfoRX));
  TGXDLMS.AppendHdlcParameter(FReplyData, FSettings.Hdlc.MaxInfoRX);

  FReplyData.SetUInt8(BYTE(HDLCInfo.WindowSizeTX));
  FReplyData.SetUInt8(4);
  FReplyData.SetUInt32(FSettings.Hdlc.WindowSizeTX);

  FReplyData.SetUInt8(BYTE(HDLCInfo.WindowSizeRX));
  FReplyData.SetUInt8(4);
  FReplyData.SetUInt32(BYTE(FSettings.Hdlc.WindowSizeRX));
  FReplyData.SetUInt8(2, FReplyData.Position - 3); // Length.
end;

function TGXDLMSServer.GetAssignedAssociation(): TGXDLMSAssociationLogicalName;
begin
  Result := TGXDLMSAssociationLogicalName(FSettings.GetAssignedAssociation);
end;
procedure TGXDLMSServer.SetAssignedAssociation(AValue: TGXDLMSAssociationLogicalName);
begin
  FSettings.SetAssignedAssociation(AValue);
end;

function TGXDLMSServer.GetConformance(): TConformance;
begin
  Result := FSettings.ProposedConformance;
end;
procedure TGXDLMSServer.SetConformance(AValue: TConformance);
begin
  FSettings.ProposedConformance := AValue;
end;

///  Initialize server.
/// This must call after server objects are set.
/// manually: If true, server handle objects and all data are updated manually.
procedure TGXDLMSServer.Initialize(manually: Boolean);
var
  pos: Integer;
  it : TGXDLMSObject;
  ln: TGXDLMSAssociationLogicalName;
  associationObject: TGXDLMSObject;
  sn: TGXDLMSAssociationShortName;
begin
  associationObject := Nil;
  FInitialized := true;
  if manually Then
  begin
      Exit;
  end;
  for pos := 0 to Items.Count - 1 do
  begin
      it := Items[pos];
      if FSettings.UseLogicalNameReferencing and ((it.LogicalName = '')) Then
      begin
          raise Exception.Create('Invalid Logical Name.');
      end;
      if (it is TGXDLMSAssociationShortName) and Not FSettings.UseLogicalNameReferencing Then
      begin
          if TGXDLMSAssociationShortName(it).ObjectList.Count = 0 Then
          begin
              TGXDLMSAssociationShortName(it).ObjectList.AddRange(Items);
          end;
          associationObject := it;
      end
      else if (it is TGXDLMSAssociationLogicalName) and FSettings.UseLogicalNameReferencing Then
      begin
          ln := TGXDLMSAssociationLogicalName(it);
          if ln.ObjectList.Count = 0 Then
          begin
              ln.ObjectList.AddRange(Items);
          end;
          associationObject := it;
          if FSettings.ProposedConformance <> TConformance.cfNone Then
          begin
              ln.XDLMSContextInfo.Conformance := FSettings.ProposedConformance;
          end;
      end;
  end;
  if associationObject = Nil Then
  begin
      if FSettings.UseLogicalNameReferencing Then
      begin
          ln := TGXDLMSAssociationLogicalName.Create();
          ln.XDLMSContextInfo.MaxReceivePduSize := FSettings.MaxServerPDUSize;
          ln.XDLMSContextInfo.MaxSendPduSize := FSettings.MaxServerPDUSize;
          ln.XDLMSContextInfo.Conformance := FSettings.ProposedConformance;
          ln.ClientSAP := 16;
          ln.ObjectList.AddRange(Items);
          Items.Add(ln);
      end
      else
      begin
        sn := TGXDLMSAssociationShortName.Create();
        sn.ObjectList.AddRange(Items);
        Items.Add(sn);
      end;
  end;
  //Arrange items by Short Name.
  UpdateShortNames(false);
end;

// Update short names.
procedure TGXDLMSServer.UpdateShortNames(force: Boolean);
var
  sn, offset, count: Integer;
  it: TGXDLMSObject;
begin
    //Arrange items by Short Name.
    sn := $A0;
    if Not FSettings.UseLogicalNameReferencing Then
    begin
        for it in Items do
        begin
            if (Not ((it is TGXDLMSAssociationShortName) or (it is TGXDLMSAssociationLogicalName))) Then
            begin
                //Generate Short Name if not given.
                if force or (it.ShortName = 0) Then
                begin
                    it.ShortName := sn;
                    //Add method index addresses.
                    TGXDLMS.GetActionInfo(it.ObjectType, @offset, @count);
                    if count <> 0 Then
                    begin
                        sn := sn + offset + (8 * count);
                    end
                    else //If there are no methods.
                    begin
                        //Add attribute index addresses.
                        sn := sn +  8 * it.GetAttributeCount();
                    end;
                end
                else
                begin
                    sn := it.ShortName;
                end;
            end;
        end;
    end;
end;
end.

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

program Gurux.DLMS.Client.Example.Delphi;

{$APPTYPE CONSOLE}
{$R *.res}

uses System.SysUtils,
GXProgram,
Gurux.DLMS.Authentication,
Gurux.DLMS.InterfaceType,
GXCommon,
System.Generics.Collections,
GXCmdParameter,
Gurux.DLMS.TraceLevel, ActiveX, Gurux.DLMS.GXDLMSObject, Gurux.DLMS.ObjectType,
Gurux.DLMS.Security, Gurux.DLMS.SecuritySuite, Gurux.DLMS.GXDLMSClient,
GXByteBuffer;

var
  p : TGXProgram;
  UseLogicalNameReferencing : Boolean;
  //Client ID. Default is 0x10
  ClientAddress: Integer;
  //Server ID. Default is 1.
  ServerAddress: Integer;
  //Authentication type. Default is None
  Authentication: TAuthentication;
  //Password if authentication is used.
  Password: string;
  //Interface type. Default is general.
  InterfaceType: TInterfaceType;
  //Host name
  Host: String;
  //TCP/IP port number.
  Port: Integer;
  parameters: TObjectList<TGXCmdParameter>;
  it: TGXCmdParameter;
  trace: TTraceLevel;
  readObjects, o: string;
  tmp: TArray<String>;
  obj: TGXDLMSObject;
  Security: TSecurity;
  SecuritySuite: TSecuritySuite;
  invocationCounter: string;
  AutoIncreaseInvokeID: boolean;
  outputFile: string;
  GbtWindowSize: BYTE;
  WindowSize: Integer;
  MaxInfo: Integer;
  ManufacturerId: String;
  SystemTitle : TBytes;
  AuthenticationKey : TBytes;
  BlockCipherKey : TBytes;
begin
  Security := TSecurity.None;
  SecuritySuite := TSecuritySuite.Suite0;
  Host := '';
  ManufacturerId := '';
  Port := 0;
  p := Nil;
  GbtWindowSize := 1;
  WindowSize := 1;
  MaxInfo := 128;
  ClientAddress := 16;
  UseLogicalNameReferencing := true;
  ServerAddress := 1;
  Authentication := TAuthentication.atNone;
  InterfaceType := TInterfaceType.HDLC;
  trace := TTraceLevel.tlInfo;
  invocationCounter := '';
  AutoIncreaseInvokeID := False;
{$WARN SYMBOL_PLATFORM OFF}
{$IFDEF MSWINDOWS}
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
{$ENDIF}
{$ENDIF}
  try
    parameters := TGXCommon.GetParameters('h:p:c:s:r:i:It:a:p:P:g:C:n:v:o:l:W:w:f:L:V:T:A:B:');
    for it in parameters do
    begin
      case it.Tag of
      'r':
      begin
        if it.Value = 'sn' Then
          UseLogicalNameReferencing := false
        else if it.Value = 'ln' Then
          UseLogicalNameReferencing := true
        else
          raise EArgumentException.Create('Invalid reference option.');
      end;
      'h':
        Host := it.Value;
    't':
      begin
        //Trace.
        if it.Value = 'Error' Then
          trace := TTraceLevel.tlError
        else if it.Value = 'Warning' Then
          trace := TTraceLevel.tlWarning
        else if it.Value = 'Info' Then
          trace := TTraceLevel.tlInfo
        else if it.Value = 'Verbose' Then
          trace := TTraceLevel.tlVerbose
        else if it.Value = 'Off' Then
          trace := TTraceLevel.tlOff
        else
          raise Exception.Create('Invalid trace option. (Error, Warning, Info, Verbose, Off).');
      end;
      'p': Port := StrToInt(it.Value);
      'P'://Password
         Password := it.Value;
      'i':
      begin
      //Interface
        if it.Value = 'HDLC' Then
         InterfaceType := TInterfaceType.HDLC
        else if it.Value = 'WRAPPER' Then
          InterfaceType := TInterfaceType.WRAPPER
        else if it.Value = 'PDU' Then
          InterfaceType := TInterfaceType.PDU
        else if it.Value = 'WirelessMBus' Then
          InterfaceType := TInterfaceType.WirelessMBus
        else if it.Value = 'Plc' Then
          InterfaceType := TInterfaceType.Plc
        else if it.Value = 'PlcHdlc' Then
          InterfaceType := TInterfaceType.PlcHdlc
        else if it.Value = 'LPWAN' Then
          InterfaceType := TInterfaceType.LPWAN
        else if it.Value = 'WiSUN' Then
          InterfaceType := TInterfaceType.WiSUN
        else if it.Value = 'PlcPrime' Then
          InterfaceType := TInterfaceType.PlcPrime
        else
          raise Exception.Create('Invalid trace option. (Error, Warning, Info, Verbose, Off).');
      end;
      'I':
        // AutoIncreaseInvokeID.
        AutoIncreaseInvokeID := True;
      'o':
        outputFile := it.Value;
      'v':
      begin
        invocationCounter := it.Value.Trim();
        TGXDLMSObject.GetLogicalName(invocationCounter);
      end;
      'g':
      begin
        //Get (read) selected objects.
        for o in it.Value.Split([',', ';']) do
        begin
          tmp := o.Split([':']);
          if Length(tmp) <> 2 Then
            raise Exception.Create('Invalid Logical name or attribute index.');
        end;
        readObjects := it.Value;
      end;
      'S'://Serial Port
          raise EArgumentException.Create('Serial port is not supported.');
      'a':
        if it.Value = 'None' Then
          Authentication := TAuthentication.atNone
        else if it.Value = 'Low' Then
          Authentication := TAuthentication.atLow
        else if it.Value = 'High' Then
          Authentication := TAuthentication.atHigh
        else if it.Value = 'HighMd5' Then
          Authentication := TAuthentication.atHighMd5
        else if it.Value = 'HighSha1' Then
          Authentication := TAuthentication.atHighSha1
        else if CompareText(it.Value, 'HighGmac') = 0 Then
          Authentication := TAuthentication.atHighGmac
        else if it.Value = 'HighSha256' Then
          Authentication := TAuthentication.atHighSha256
        else
          raise Exception.Create('Invalid Authentication option. (None, Low, High, HighMd5, HighSha1, HighGmac, HighSha256). ' + it.Value);
       'C':
        if it.Value = 'None' Then
          Security := TSecurity.None
        else if it.Value = 'Authentication' Then
          Security := TSecurity.Authentication
        else if it.Value = 'Encryption' Then
          Security := TSecurity.Encryption
        else if it.Value = 'AuthenticationEncryption' Then
          Security := TSecurity.AuthenticationEncryption
        else
          raise Exception.Create('Invalid Ciphering option. (None, Authentication, Encryption, AuthenticationEncryption)');
        'V':
        if it.Value = 'Suite0' Then
          SecuritySuite := TSecuritySuite.Suite0
        else if it.Value = 'Suite1' Then
           SecuritySuite := TSecuritySuite.Suite1
        else
          raise Exception.Create('Invalid security suite option. (Suite0, Suite1)');
      'T': SystemTitle := TGXByteBuffer.HexToBytes(it.Value);
      'A': AuthenticationKey := TGXByteBuffer.HexToBytes(it.Value);
      'B': BlockCipherKey := TGXByteBuffer.HexToBytes(it.Value);
      'c':
          clientAddress := StrToInt(it.Value);
      's':
          if serverAddress <> 1 then
            serverAddress := TGXDLMSClient.GetServerAddress(serverAddress, StrToInt(it.Value))
          else
            serverAddress := StrToInt(it.Value);
      'l': serverAddress := TGXDLMSClient.GetServerAddress(StrToInt(it.Value), serverAddress);
      'n': serverAddress := TGXDLMSClient.GetServerAddressFromSerialNumber(StrToInt(it.Value), 1);
      'W': GbtWindowSize := StrToInt(it.Value);
      'w': WindowSize := StrToInt(it.Value);
      'f': MaxInfo := StrToInt(it.Value);
      'L': ManufacturerId := it.Value;


      '?':
        case it.Tag of
        'c': raise EArgumentException.Create('Missing mandatory client option.');
        's':  raise EArgumentException.Create('Missing mandatory server option.');
        'h':  raise EArgumentException.Create('Missing mandatory host name option.');
        'p':  raise EArgumentException.Create('Missing mandatory port option.');
        'r':   raise EArgumentException.Create('Missing mandatory reference option.');
        'a':   raise EArgumentException.Create('Missing mandatory authentication option.');
        'S':   raise EArgumentException.Create('Missing mandatory Serial port option.');
        't':  raise EArgumentException.Create('Missing mandatory trace option.');
        'C':  raise EArgumentException.Create('Missing mandatory Ciphering option.');
        else
          TGXProgram.ShowHelp;
          ExitCode := 1;
          Exit;
        end
      else
        TGXProgram.ShowHelp;
        ExitCode := 1;
        Exit;
      end;
    end;
    FreeAndNil(parameters);
    if (Host = String.Empty) or (Port = 0) or (clientAddress = 0) or (serverAddress = 0) Then
    begin
      TGXProgram.ShowHelp;
      ExitCode := 1;
      Exit;
    end;
    //Xml needs this.
    CoInitialize(nil);
    try
    try
      p := TGXProgram.Create(UseLogicalNameReferencing, ClientAddress,
        ServerAddress, Authentication, Password, InterfaceType, Host, Port, trace, security,
        SecuritySuite,
        invocationCounter, AutoIncreaseInvokeID, GbtWindowSize,WindowSize,
        MaxInfo, ManufacturerId, SystemTitle, AuthenticationKey, BlockCipherKey);
      if readObjects = '' Then
        p.ReadAll(outputFile)
      Else
      begin
        p.GetAssociationView;
        for o in readObjects.Split([',', ';']) do
        begin
          tmp := o.Split([':']);
          obj := p.Client.Objects.FindByLN(TObjectType.otNone, tmp[0]);
          p.Read(obj, StrToInt(tmp[1]));
        end;
      end;
    except
      on E: Exception do
        writeln('Error! ' + E.Message);
    end;
    finally
      //Xml needs this.
      CoUnInitialize;
      FreeAndNil(p);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

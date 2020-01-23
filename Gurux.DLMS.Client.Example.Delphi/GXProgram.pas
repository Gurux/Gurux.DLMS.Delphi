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

unit GXProgram;

interface

//This class implements DLMS client example.
uses System.Generics.Collections, DateUtils, Classes, System.SysUtils, Rtti,
  ScktComp, TypInfo, Variants, ActiveX, xmldom, XMLIntf, msxmldom, XMLDoc,
  Gurux.DLMS.DataType,
  GXByteBuffer,
  Gurux.DLMS.GXDLMSCaptureObject,
  Gurux.DLMS.GXDLMSObject,
  Gurux.DLMS.Secure.GXDLMSSecureClient,
  Gurux.DLMS.GXDateTime,
  Gurux.DLMS.ObjectType,
  Gurux.DLMS.RequestTypes,
  Gurux.DLMS.GXDLMSException,
  Gurux.DLMS.InterfaceType,
  Gurux.DLMS.Authentication,
  Gurux.DLMS.AccessMode,
  Gurux.DLMS.Objects.GXDLMSClock,
  Gurux.DLMS.Objects.GXDLMSAssociationLogicalName,
  Gurux.DLMS.Objects.GXDLMSProfileGeneric,
  Gurux.DLMS.Objects.GXDLMSRegister,
  Gurux.DLMS.Objects.GXDLMSExtendedRegister,
  Gurux.DLMS.Objects.GXDLMSDemandRegister,
  GXCommon, Gurux.DLMS.GXDLMSDayProfile,
  Gurux.DLMS.GXDLMSDayProfileAction,
  Gurux.DLMS.GXDLMSConverter,
  Gurux.DLMS.GXReplyData,
  Gurux.DLMS.TraceLevel,
  Gurux.DLMS.Conformance,
  Gurux.DLMS.Security,
  Gurux.DLMS.Objects.GXDLMSData;

type
TGXProgram = class
  WaitTime : Integer;
  FTrace: TTraceLevel;
  socket : TClientSocket;
  Client : TGXDLMSSecureClient;
  class procedure WriteValue(line : string);
  procedure WriteTrace(line : string);
  procedure ReadScalerAndUnits;
  procedure GetProfileGenericColumns;
  procedure GetReadOut;
  procedure GetProfileGenerics;
  destructor Destroy; override;

  public
  class procedure ShowHelp;static;
  constructor Create(AUseLogicalNameReferencing : Boolean;
    //Client ID. Default is 0x10
    AClientAddress : Integer;
    //Server ID. Default is 1.
    AServerAddress : Integer;
    //Authentication type. Default is None
    AAuthentication : TAuthentication;
    //Password if authentication is used.
    APassword : string;
    //Interface type. Default is general.
    AIntefaceType : TInterfaceType;
    AHost: String;
    APort: Integer;
    ATrace: TTraceLevel;
    ASecurity: TSecurity);

  procedure InitializeConnection();
  procedure Close();
  function GetAssociationView() : TGXDLMSObjectCollection;
  function Read(it : TGXDLMSObject; attributeIndex : Integer) : TValue;
  procedure Write(it : TGXDLMSObject; attributeIndex : Integer);
  function ReadRowsByEntry(it : TGXDLMSObject; index : Integer; count : Integer) : TArray<TValue>;
  function ReadRowsByRange(it : TGXDLMSObject; startTime : TDateTime; endTime :
          TDateTime; columns : TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TValue>;

  procedure ReadDLMSPacket(data: TBytes; reply: TGXReplyData);
  procedure ReadDataBlock(data: TBytes; reply: TGXReplyData);overload;
  procedure ReadDataBlock(data: TArray<TBytes>; reply: TGXReplyData);overload;

  procedure Save(APath : String);
  function Load(APath : String) : TGXDLMSObjectCollection;

  class function GetValueAsString(value : TValue) : string;
  function Method(it : TGXDLMSObject; attributeIndex : Integer; data : TValue; dt : TDataType) : TValue;
  procedure ReadAll;

  // Read list of attributes.
  procedure ReadList(list: TList<TPair<TGXDLMSObject, Integer>>);

  end;

implementation

destructor TGXProgram.Destroy;
begin
  Close();
  FreeAndNil(Client);
  inherited;
end;


class procedure TGXProgram.ShowHelp;
begin
  WriteLn('GuruxDlmsSample reads data from the DLMS/COSEM device.');
  WriteLn('GuruxDlmsSample -h [Meter IP Address] -p [Meter Port No] -c 16 -s 1 -r SN');
  WriteLn(' -h \t host name or IP address.');
  WriteLn(' -p \t port number or name (Example: 1000).');
  WriteLn(' -S \t serial port.');
  WriteLn(' -i IEC is a start protocol.');
  WriteLn(' -a \t Authentication (None, Low, High).');
  WriteLn(' -P \t Password for authentication.');
  WriteLn(' -c \t Client address. (Default: 16)');
  WriteLn(' -s \t Server address. (Default: 1)');
  WriteLn(' -n \t Server address as serial number.');
  WriteLn(' -r [sn, sn]\t Short name or Logican Name (default) referencing is used.');
  WriteLn(' -w WRAPPER profile is used. HDLC is default.');
  WriteLn(' -t [Error, Warning, Info, Verbose] Trace messages.');
  WriteLn(' -g "0.0.1.0.0.255:1; 0.0.1.0.0.255:2" Get selected object(s) with given attribute index.');
  WriteLn('Example:');
  WriteLn('Read LG device using TCP/IP connection.');
  WriteLn('GuruxDlmsSample -r SN -c 16 -s 1 -h [Meter IP Address] -p [Meter Port No]');
  WriteLn('Read LG device using serial port connection.');
  WriteLn('GuruxDlmsSample -r SN -c 16 -s 1 -sp COM1 -i');
  WriteLn('Read Indian device using serial port connection.');
  WriteLn('GuruxDlmsSample -S COM1 -c 16 -s 1 -a Low -P [password]');
end;

constructor TGXProgram.Create(AUseLogicalNameReferencing : Boolean;
    //Client ID. Default is 0x10
    AClientAddress : Integer;
    //Server ID. Default is 1.
    AServerAddress : Integer;
    //Authentication type. Default is None
    AAuthentication : TAuthentication;
    //Password if authentication is used.
    APassword : string;
    //Interface type. Default is general.
    AIntefaceType : TInterfaceType;
    AHost: String;
    APort: Integer;
    ATrace: TTraceLevel;
    ASecurity: TSecurity);
begin
  WaitTime := 5000;
  FTrace := ATrace;

  if FileExists('trace.txt') Then
    DeleteFile('trace.txt');

  if FileExists('LogFile.txt') Then
    DeleteFile('LogFile.txt');


  socket := TClientSocket.Create(Nil);
  Client := TGXDLMSSecureClient.Create(AUseLogicalNameReferencing, AClientAddress, AServerAddress,
            AAuthentication, APassword, AIntefaceType);
  Client.Ciphering.Security := ASecurity;
  socket.Host := AHost;
  socket.Port := APort;
  ///////////////////////////////////////////////////////
  socket.Socket.ClientType := TClientType.ctBlocking;
  socket.Open;
  if FTrace > TTraceLevel.tlWarning Then
    writeln('Connected.');
  InitializeConnection;
end;

procedure TGXProgram.ReadScalerAndUnits;
var
  list: TList<TPair<TGXDLMSObject, Integer>>;
  tmp: TArray<TGXDLMSObject>;
  it: TGXDLMSObject;
begin
  tmp := Client.Objects.GetObjects([TObjectType.otRegister, TObjectType.otDemandRegister, TObjectType.otExtendedRegister]);
  try
    if Integer(Client.NegotiatedConformance) and Integer(TConformance.cfMultipleReferences) <> 0 Then
    begin
      list := TList<TPair<TGXDLMSObject, Integer>>.Create();
      for it in tmp do
      begin
      if (it is TGXDLMSRegister) or (it is TGXDLMSExtendedRegister) then
        list.Add(TPair<TGXDLMSObject, Integer>.Create(it, 3));

      if (it is TGXDLMSDemandRegister) Then
        list.Add(TPair<TGXDLMSObject, Integer>.Create(it, 4));
      end;

      if list.Count <> 0 Then
        ReadList(list);
    end;
  except
  on E: Exception do
   Client.NegotiatedConformance := TConformance(Integer(Client.NegotiatedConformance) and Not Integer(TConformance.cfMultipleReferences));
  end;
  FreeAndNil(list);
  if Integer(Client.NegotiatedConformance) and Integer(TConformance.cfMultipleReferences) = 0 Then
    for it in tmp do
    begin
      try
      if (it is TGXDLMSRegister) or (it is TGXDLMSDemandRegister) Then
        read(it, 3)
      else if it is TGXDLMSDemandRegister Then
        read(it, 4);
       except
      on E: Exception do
        // Actaric SL7000 can return error here. Continue reading.
      end;
    end;
end;

procedure TGXProgram.ReadList(list: TList<TPair<TGXDLMSObject, Integer>>);
var
  reply: TGXReplyData;
  data: TArray<TBytes>;
  values: TList<TValue>;
  it: TBytes;
  pos: Integer;
begin
  data := Client.ReadList(list);
  reply := TGXReplyData.Create();
  values := TList<TValue>.Create();
  try
    for it in data do
    begin
      ReadDataBlock(it, reply);
      if (list.Count <> 1) and (reply.Value.isArray) Then
      begin
        for pos := 0 to reply.Value.GetArrayLength() - 1 do
          values.Add(reply.Value.GetArrayElement(pos).AsType<TValue>());
      end
      else if Not reply.Value.IsEmpty Then
        //Value is null if data is send in multiple frames.
        values.Add(reply.Value);
      reply.Clear();
    end;
    if values.Count <> list.Count Then
      raise EArgumentException.Create('Invalid reply. Read items count do not match.');

    Client.UpdateValues(list, values);
  finally
    FreeAndNil(reply);
    FreeAndNil(values);
  end;
end;

procedure TGXProgram.GetProfileGenericColumns;
var
  cols, tmp: TArray<TGXDLMSObject>;
  col, it : TGXDLMSObject;
  First : Boolean;
  sb : TStringBuilder;
begin
  sb := TStringBuilder.Create();
  tmp := Client.Objects.GetObjects(TObjectType.otProfileGeneric);
  for it in tmp do
    try
      //Read Profile Generic columns first.
      Read(it, 3);

      if FTrace > TTraceLevel.tlWarning Then
      begin
        WriteValue('Profile Generic ' + VarToStr(it.Name) + ' Columns:');
        First := true;
        sb.Clear();
        for col in cols do
        begin
          if Not First Then
            sb.Append(' | ');

          First := false;
          sb.Append(VarToStr(col.Name));
          sb.Append(' ' );
          sb.Append(col.Description);
        end;
        WriteValue(sb.ToString());
      end;
    except
    on E: TGXDLMSException do
    begin
      if FTrace > TTraceLevel.tlOff Then
        WriteLn(E.Message);
      //Continue reading if device returns access denied error.
      if TGXDLMSException(E).ErrorCode = 3 then
        continue
      else
      begin
        if FTrace > TTraceLevel.tlOff Then
          WriteValue('Error! Index: ' + IntToStr(3) + ' ' + E.Message);
        continue;
      end
    end;
  end;
  FreeAndNil(sb);
end;

procedure TGXProgram.GetReadOut;
var
 it: TGXDLMSObject;
 pos: Integer;
 val : TValue;
begin
 for it in Client.Objects do
  begin
    // Profile generics are read later because they are special cases.
    // (There might be so lots of data and we so not want waste time to read all the data.)
    if it is TGXDLMSProfileGeneric then
      continue;

    if it.ClassType = TGXDLMSObject then
    begin
        //If interface is not implemented.
        //Example manufacturer spesific interface.
        writeln('Unknown Interface: ' + IntToStr(Integer(it.ObjectType)));
        continue;
    end;


    if FTrace > TTraceLevel.tlWarning Then
      WriteValue('-------- Reading ' + TGXDLMSSecureClient.ObjectTypeToString(it.ObjectType) + ' ' + it.LogicalName + ' ' + it.Description);
    for pos in it.GetAttributeIndexToRead() do
    begin
      try
        val := Read(it, pos);
        if FTrace > TTraceLevel.tlWarning Then
          WriteValue('Index: ' + IntToStr(pos) + ' Value: ' + GetValueAsString(val));

      except
      on E: TGXDLMSException do
      begin
        if FTrace > TTraceLevel.tlOff Then
          WriteValue('Error! Index: ' + IntToStr(pos) + ' ' + E.Message);
        //Continue reading if device returns access denied error.
        if TGXDLMSException(E).ErrorCode = 3 then
          continue
        else
        begin
          continue;
        end;
      end;
      on Ex : Exception do
      begin
        if FTrace > TTraceLevel.tlOff Then
          WriteValue('Error! Index: ' + IntToStr(pos) + ' ' + Ex.Message);
        continue;
      end;
    end;
  end;
  end;
end;

procedure TGXProgram.GetProfileGenerics;
var
  cols, tmp: TArray<TGXDLMSObject>;
  rows: TArray<TValue>;
  cell, row: TValue;
  it: TGXDLMSObject;
  pos, entriesInUse, entries : Integer;
  str: String;
begin
 //Find profile generics and read them.
  tmp := Client.Objects.GetObjects(TObjectType.otProfileGeneric);
  for it in tmp do
  begin
    if FTrace > TTraceLevel.tlWarning Then
      WriteValue('-------- Reading ' + TGXDLMSSecureClient.ObjectTypeToString(it.ObjectType) + ' ' + VarToStr(it.Name) + ' ' + it.Description);
    entriesInUse := Read(it, 7).AsInteger;
    entries := Read(it, 8).AsInteger;
    if FTrace > TTraceLevel.tlWarning Then
      WriteValue('Entries: ' + IntTostr(entriesInUse) + '/' + IntTostr(entries));
    //If there are no columns or rows.
    if (entriesInUse = 0) or
      ((it as TGXDLMSProfileGeneric).CaptureObjects.Count = 0) Then
        continue;

    //Note! All meters do not support this.
    //Read first row from Profile Generic.
    try
      if FTrace > TTraceLevel.tlWarning Then
        writeln('-------- Reading Profile Generic ' + VarToStr(it.Name) + ' Read first row:');
      rows := ReadRowsByEntry(it, 1, 1);
      if FTrace > TTraceLevel.tlWarning Then
      begin
        for row in rows do
        begin
          str := '';
          for pos := 0 to row.GetArrayLength - 1 do
          begin
            cell := row.GetArrayElement(pos);
            str := str + GetValueAsString(cell) + ' | ';
          end;
          WriteValue(str);
        end;
      end;
    except
    on E: TGXDLMSException do
      if FTrace > TTraceLevel.tlOff Then
        WriteValue('Error! Failed to read first row: ' + E.Message);
    on Ex : Exception do
      if FTrace > TTraceLevel.tlWarning Then
        WriteValue('Error! ' + Ex.Message);
    end;

    try
      //Note! All meters do not support this.
      if FTrace > TTraceLevel.tlWarning Then
       writeln('-------- Reading Profile Generic ' + VarToStr(it.Name) + ' Last day:');
      //Read last day from Profile Generic.
      cols := (it as TGXDLMSProfileGeneric).GetCaptureObject();
      if Length(cols) <> 0 then
      begin
        rows := ReadRowsByRange(it, DateOf(Date), IncDay(Date, 1), Nil);
        if FTrace > TTraceLevel.tlWarning Then
        begin
        for row in rows do
        begin
          str := '';
          for pos := 0 to row.GetArrayLength - 1 do
          begin
            cell := row.GetArrayElement(pos);
            str := str + GetValueAsString(cell) + ' | ';
          end;
          WriteValue(str);
        end;
        end;
      end;
    except
    on E: TGXDLMSException do
      WriteValue('Error! Failed to read last day: ' + E.Message);
      //Continue reading.
    on Ex : Exception do
      WriteValue('Error! ' + Ex.Message);
    end;
  end;
end;

procedure TGXProgram.ReadAll;
var
  logFile : string;
begin
  logFile := socket.Host.Replace('.', '_') + '_' + socket.Port.ToString() + '.xml';
  try
  //You can save association view, but make sure that it is not change.
  //Save Association view to the cache so it is not needed to retreave every time.
  {
  //Get list of objects from the meter.
  if FileExists(logFile) Then
    objects := Load(logFile);
  }
  //Read association view if objects are not saved yet.
  if Client.Objects.Count = 0 then
    GetAssociationView;
  // Read Scalers and units from the register objects.
  ReadScalerAndUnits;
  // Read Profile Generic columns.
  GetProfileGenericColumns;
  // Read all attributes from all objects.
  GetReadOut;
  // Read historical data.
  GetProfileGenerics();
  Save(logFile);
  finally
    Close();
  end;
end;

class function TGXProgram.GetValueAsString(value : TValue) : string;
var
  pos : Integer;
  it : TValue;
  bytes : TBytes;
  sb: TStringBuilder;
  row: TValue;
begin
  value := value.AsType<TValue>;
  //If data is array.
  if value.IsEmpty then
    Result := 'Null'
  else if value.IsType<TBytes> then
    Result := TGXByteBuffer.ToHexString(value.AsType<TBytes>)
  else if value.IsType<TGXDateTime> then
    Result := value.AsType<TGXDateTime>().ToString
  else if value.IsType<TList> then
    Result := value.AsType<TObject>().ToString
  else if value.IsObject then
    Result := value.AsType<TObject>().ToString
  else if value.IsClass then
    Result := value.AsType<TObject>().ToString
  else if value.IsArray then
  begin
    if value.IsType<TArray<TValue>> then
    begin
        sb := TStringBuilder.Create;
        for row in value.AsType<TArray<TValue>> do
        begin
            if sb.Length <> 0 then
              sb.Append(', ');
            sb.Append(row.ToString);
        end;
        Result := sb.ToString;
        FreeAndNil(sb);
    end
    else
    begin
      if value.TypeData.OrdType = System.TypInfo.otUByte Then
      begin
        bytes := TBytes.Create();
        SetLength(bytes, value.GetArrayLength);
        for pos := 0 to value.GetArrayLength - 1 do
          bytes[pos] := value.GetArrayElement(pos).AsInteger;

        Result := TGXByteBuffer.ToHexString(bytes, true, 0, Length(bytes));
      end
      else
      begin
        Result := '';
        for pos := 0 to value.GetArrayLength - 1 do
        begin
          it := value.GetArrayElement(pos).AsType<TValue>;
          if it.IsObject then
            Result := Result + ' ' + it.ToString
          else if it.IsType<TValue> then
            if it.Kind = tkRecord then
            begin
              Result := Result + ' ' + GetValueAsString(it.AsType<TValue>)
            end
            else
              Result := Result + ' ' + GetValueAsString(it.AsType<TValue>)
          else
            Result := Result + ' ' + it.ToString;
        end;
      end;
    end;
  end
  else
    Result := value.ToString;
end;

class procedure TGXProgram.WriteValue(line : String);
var
  FileName : string;
  logFile : TextFile;
begin
  try
    WriteLn(line);
    FileName := 'LogFile.txt';
    AssignFile(logFile, FileName);
    if Not FileExists(FileName) Then
     Rewrite(logFile)
    else
      Append(logFile);
    WriteLn(logFile, line);
  finally
   CloseFile(logFile);
  end;
end;

procedure TGXProgram.WriteTrace(line : string);
var
  FileName : string;
  logFile : TextFile;
begin
  try
    if FTrace > TTraceLevel.tlInfo then
      WriteLn(line);

    FileName := 'trace.txt';
    AssignFile(logFile, FileName);
    if Not FileExists(FileName) Then
     Rewrite(logFile)
    else
      Append(logFile);
    WriteLn(logFile, line);
  finally
   CloseFile(logFile);
  end;
end;

//Load objects values.
function TGXProgram.Load(APath : String) : TGXDLMSObjectCollection;
var
  FDOC: TXMLDocument;
  Node, cn, access: IXMLNode;
  ot : TObjectType;
  obj, obj2 : TGXDLMSObject;
  comp : TComponent;
  index, pos, pos2 : Integer;
  ln : string;
  val : OleVariant;
  co: TGXDLMSConverter;
begin
  Result := Client.Objects;
  Result.Clear;
  try
    comp := TComponent.Create(Nil);
    FDOC := TXMLDocument.Create(comp);
    FDOC.Options := FDOC.Options + [doNodeAutoIndent];
    FDOC.LoadFromFile(APath);
    FDOC.Active := true;
    For pos := 0 to FDOC.DocumentElement.ChildNodes.Count - 1 do
    begin
      Node := FDOC.DocumentElement.ChildNodes[pos];
      ot := TObjectType(StrToInt(Node.Attributes['Type']));
      obj := Client.CreateObject(ot);
      val := Node.Attributes['SN'];
      if Variants.VarIsStr(val) then
        obj.ShortName := StrToInt(val);

      obj.LogicalName := Node.Attributes['LN'];
      obj.Version := StrToInt(Node.Attributes['Version']);
      cn := Node.ChildNodes.FindNode('Access');
      if cn <> Nil then
      begin
        For pos2 := 0 to cn.ChildNodes.Count - 1 do
        begin
          access := cn.ChildNodes[pos2];
          index := StrToInt(access.Attributes['Index']);
          obj.SetAccess(index,
                        TAccessMode(StrToInt(access.Attributes['Access'])));

          val := access.Attributes['Type'];
          if Variants.VarIsStr(val) then
            obj.SetDataType(index, TDataType(StrToInt(val)));
        end;
      end;

      Client.Objects.Add(obj);
      if obj is TGXDLMSProfileGeneric then
      begin
        Node := Node.ChildNodes.FindNode('Objects');
        For pos2 := 0 to Node.ChildNodes.Count - 1 do
        begin
          cn := Node.ChildNodes[pos2];
          ot := TObjectType(StrToInt(cn.Attributes['Type']));
          ln := cn.Attributes['LN'];
          obj2 := Client.Objects.FindByLN(ot, ln);
          if obj2 = Nil then
          begin
            obj2 := Client.CreateObject(ot);
            obj2.LogicalName := ln;
          end;
          obj2.Version := StrToInt(cn.Attributes['Version']);
          (obj as TGXDLMSProfileGeneric).CaptureObjects.Add(
          TGXDLMSCaptureObject.Create(obj2, StrToInt(cn.Attributes['AttributeIndex']),
              StrToInt(cn.Attributes['DataIndex'])));
        end;
      end;
    end;
    //Update objects descriptions.
    co := TGXDLMSConverter.Create();
    co.UpdateOBISCodeInformation(Client.Objects);
    FreeAndNil(co);
  except
    on E: Exception do
    begin
      Client.Objects.Clear;
      DeleteFile(APath);
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;
  FDOC.Active := False;
  Node := Nil;
  cn := Nil;
  access := Nil;
  FreeAndNil(FDOC);
  FreeAndNil(comp);
  end;

//Save objects values.
procedure TGXProgram.Save(APath : String);
var
  FDOC: TXMLDocument;
  FRootNode: IXMLNode;
  access, Auth, Node, Node2: IXMLNode;
  it: TGXDLMSObject;
  it2: TGXDLMSCaptureObject;
  pos, tp : Integer;
begin
  try
    FDOC := TXMLDocument.Create(Nil);
    FDOC.Options := FDOC.Options + [doNodeAutoIndent];
    FDOC.Active := true;
    FDOC.Encoding := 'UTF-8';
    FRootNode := FDOC.CreateElement('Objects', '');
    FDOC.DocumentElement := FRootNode;
    for it in Client.Objects do
    begin
      Node := FRootNode.AddChild(it.ClassName);
      Node.Attributes['LN'] := it.LogicalName;
      Node.Attributes['Type'] := Integer(it.ObjectType).ToString;
      if it.ShortName <> 0 then
        Node.Attributes['SN'] := it.ShortName.ToString;
      Node.Attributes['Version'] := it.Version.ToString;
      Auth := Node.AddChild('Access');
      for pos := 1 to it.GetAttributeCount do
      begin
        access := Auth.AddChild('Index');
        access.Attributes['Index'] := pos.ToString();
        access.Attributes['Access'] := Integer(it.GetAccess(pos));
        tp := Integer(it.GetDataType(pos));
        if tp <> 0 then
          access.Attributes['Type'] := tp;
      end;

      if it is TGXDLMSProfileGeneric then
      begin
        Node := Node.AddChild('Objects');
        for it2 in (it as TGXDLMSProfileGeneric).CaptureObjects do
        begin
          Node2 := Node.AddChild(it2.Target.ClassName);
          Node2.Attributes['LN'] := it2.Target.LogicalName;
          Node2.Attributes['Type'] := Integer(it2.Target.ObjectType).ToString;
          Node2.Attributes['Version'] := it2.Target.Version.ToString;
          Node2.Attributes['AttributeIndex'] := it2.AttributeIndex.ToString;
          Node2.Attributes['DataIndex'] := it2.DataIndex.ToString;
        end;
      end;
    end;
    FDOC.SaveToFile(APath);
    FDOC.Active := False;
  finally
    Node := Nil;
    FRootNode := Nil;
    FreeAndNil(FDOC);
  end;
end;

//Close connection to the meter.
procedure TGXProgram.Close();
var
  reply: TGXReplyData;
begin
  if (socket <> Nil) and (Client <> Nil) then
  begin
    Writeln('Disconnecting from the meter.');
    reply := TGXReplyData.Create();
    try
      //Release is call only for secured connections.
      //All meters are not supporting Release and it's causing problems.
      if ((Client.InterfaceType = TInterfaceType.WRAPPER) or
      ((Client.InterfaceType = TInterfaceType.HDLC) and (Client.Ciphering.Security = TSecurity.None))) Then
      begin
        ReadDataBlock(Client.ReleaseRequest(), reply);
      end;
      ReadDLMSPacket(Client.DisconnectRequest(), reply);
      socket.Close;
    finally
      FreeAndNil(reply);
      FreeAndNil(socket);
    end;
  end;
end;

//Initialize connection to the meter.
procedure TGXProgram.InitializeConnection();
var
  data : TBytes;
  reply: TGXReplyData;
begin
  try
    data := Client.SNRMRequest;
    reply := TGXReplyData.Create();
    if (data <> nil) then
    begin
      if FTrace > TTraceLevel.tlWarning then
        writeln('Send SNRM request: ');

      ReadDLMSPacket(data, reply);
      if FTrace > TTraceLevel.tlWarning then
        writeln('Parsing UA reply: ');
      Client.ParseUAResponse(reply.Data);
      if FTrace > TTraceLevel.tlWarning then
        writeln('Parsing UA reply succeeded.');
    end;
    for data in Client.AARQRequest() do
    begin
      if FTrace > TTraceLevel.tlWarning then
        writeln('Send AARQ request: ');
      reply.Clear;
      ReadDLMSPacket(data, reply);
    end;
    if FTrace > TTraceLevel.tlWarning then
      writeln('Parsing AARE reply: ');
    Client.ParseAAREResponse(reply.Data);
    reply.Clear;
    if Client.Authentication > TAuthentication.atLow then
    begin
      for data in Client.GetApplicationAssociationRequest do
      begin
        reply.Clear;
        ReadDLMSPacket(data, reply);
      end;
      Client.ParseApplicationAssociationResponse(reply.Data);
      reply.Clear;
    end;
    if FTrace > TTraceLevel.tlWarning then
      writeln('Parsing AARE reply succeeded.');
  finally
    FreeAndNil(reply);
  end;
end;

// Read Association View from the meter.
function TGXProgram.GetAssociationView() : TGXDLMSObjectCollection;
var
  reply : TGXReplyData;
begin
  try
    reply := TGXReplyData.Create();
    ReadDataBlock(Client.GetObjectsRequest(), reply);
    Client.ParseObjects(reply.Data, True);
    Result := Client.Objects;
  finally
    FreeAndNil(reply);
  end;
end;

function TGXProgram.Method(it : TGXDLMSObject; attributeIndex : Integer; data : TValue; dt : TDataType) : TValue;
var
  reply : TGXReplyData;
begin
  try
    reply := TGXReplyData.Create();
    ReadDataBlock(Client.Method(it.Name, it.ObjectType, attributeIndex, data, dt), reply);
  finally
    FreeAndNil(reply);
  end;
end;

// Read attribute value.
function TGXProgram.Read(it : TGXDLMSObject; attributeIndex : Integer) : TValue;
var
  reply : TGXReplyData;
begin
  try
    reply := TGXReplyData.Create();
    ReadDataBlock(Client.Read(it, attributeIndex), reply);
    Result := Client.UpdateValue(it, attributeIndex, reply.Value);
    //Update data type after read.
    if it.GetDataType(attributeIndex) = TDataType.dtNone Then
      it.SetDataType(attributeIndex, reply.ValueType);
  finally
    FreeAndNil(reply);
  end;
end;

// Write attribute value.
procedure TGXProgram.Write(it : TGXDLMSObject; attributeIndex : Integer);
var
  reply : TGXReplyData;
begin
  try
    reply := TGXReplyData.Create();
    ReadDataBlock(Client.Write(it, attributeIndex), reply);
  finally
    FreeAndNil(reply);
  end;
end;

// Read Profile Generic Columns by entry.
function TGXProgram.ReadRowsByEntry(it : TGXDLMSObject; index : Integer;
                                    count : Integer) : TArray<TValue>;
var
  reply : TGXReplyData;
begin
  try
    reply := TGXReplyData.Create();
    ReadDataBlock(Client.ReadRowsByEntry(TGXDLMSProfileGeneric(it), index, count, Nil), reply);
    Client.UpdateValue(it, 2, reply.Value);
    Result := (it as TGXDLMSProfileGeneric).Buffer.ToArray;
  finally
    FreeAndNil(reply);
  end;
end;

// Read Profile Generic Columns by range.
function TGXProgram.ReadRowsByRange(it : TGXDLMSObject; startTime : TDateTime;
                    endTime : TDateTime;
                    columns : TList<TPair<TGXDLMSObject, TGXDLMSCaptureObject>>) : TArray<TValue>;
var
  reply : TGXReplyData;
begin
  try
    reply := TGXReplyData.Create();
    ReadDataBlock(Client.ReadRowsByRange(TGXDLMSProfileGeneric(it), startTime, endTime, Nil), reply);
    Client.UpdateValue(it, 2, reply.Value);
    Result := (it as TGXDLMSProfileGeneric).Buffer.ToArray;
  finally
    FreeAndNil(reply);
  end;
end;

//Read DLMS packet from the meter.
procedure TGXProgram.ReadDLMSPacket(data: TBytes; reply: TGXReplyData);
var
  pos, cnt: Integer;
  eop: Variant;
  stream: TWinSocketStream;
  Result: TBytes;
begin
  if (data = nil) then
      Exit;
  try
    stream := TWinSocketStream.Create(socket.Socket, WaitTime);
    if FTrace = tlVerbose then
      WriteTrace('<- ' + TimeToStr(Time) + chr(9) + TGXByteBuffer.ToHexString(data));

    //Send data.
    stream.Write(data, 0, Length(data));
    pos := 0;
    eop := (Byte(126));
    if Client.InterfaceType = TInterfaceType.WRAPPER then
      eop := VarEmpty;

    repeat
      //Wait new data.
      if stream.WaitForData(WaitTime) = false then
        raise Exception.Create('Failed to received reply from the meter.');

      cnt := socket.Socket.ReceiveLength;
      if cnt <> 0 then
      begin
        SetLength(Result, pos + cnt);
        socket.Socket.ReceiveBuf(Result[pos], cnt);
        pos := pos + cnt;
        //If all data is received.
         //Loop until whole COSEM packet is received.
        if Client.GetData(Result, reply) Then
          break;
      end;
    Until False;
    if FTrace = tlVerbose then
      WriteTrace('-> ' + TimeToStr(Time) + chr(9) + TGXByteBuffer.ToHexString(Result));

    if reply.Error <> 0 Then
      raise TGXDLMSException.Create(reply.Error);
  finally
    FreeAndNil(stream);
  end;
end;

procedure TGXProgram.ReadDataBlock(data: TArray<TBytes>; reply: TGXReplyData);
var
  it : TBytes;
begin
  for it in data do
  begin
    reply.Clear;
    ReadDataBlock(it, reply);
  end;
end;

//Read DLMS data block from the meter.
procedure TGXProgram.ReadDataBlock(data: TBytes; reply: TGXReplyData);
begin
  ReadDLMSPacket(data, reply);
  while (reply.IsMoreData) do
  begin
      data := Client.ReceiverReady(reply.MoreData);
      ReadDLMSPacket(data, reply);
      if FTrace > TTraceLevel.tlInfo then
        //If data block is read.
        if (Integer(reply.MoreData) and Integer(TRequestTypes.rtFrame)) = 0 Then
          writeln('+')
        else
          writeln('-');
  end;
end;

end.

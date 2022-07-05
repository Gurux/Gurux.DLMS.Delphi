unit GXDLMSMeter;

interface
uses SysUtils,
Rtti,
System.Generics.Collections,
Gurux.DLMS.ObjectType,
Gurux.DLMS.AccessMode,
Gurux.DLMS.MethodAccessMode,
Gurux.DLMS.Authentication,
Gurux.DLMS.SourceDiagnostic,
Gurux.DLMS.GXDLMSConnectionEventArgs,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.GXDLMSServer,
Gurux.DLMS.Objects.GXDLMSSapAssignment,
Gurux.DLMS.Objects.GXDLMSAssociationLogicalName,
Gurux.DLMS.Objects.GXDLMSData,
Gurux.DLMS.Objects.GXDLMSRegister,
Gurux.DLMS.Objects.GXDLMSClock,
Gurux.DLMS.Conformance,
Gurux.DLMS.InterfaceType,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.DataType,
GXCommon;

type
  TGXDLMSMeter = class(TGXDLMSServer)
    SerialNumber: Integer;
    constructor Create();

    function FindObject(objectType: TObjectType; sn: Integer; ln: string): TGXDLMSObject;override;

    function IsTarget(serverAddress: Integer; clientAddress: Integer): BOOLEAN;override;

    function GetAttributeAccess(arg: TValueEventArgs):TAccessMode;override;

    function GetMethodAccess(arg: TValueEventArgs): TMethodAccessMode;override;

    function ValidateAuthentication(authentication: TAuthentication; password: TBytes): TSourceDiagnostic;override;

    procedure Connected(connectionInfo: TGXDLMSConnectionEventArgs);override;

    procedure InvalidConnection(connectionInfo: TGXDLMSConnectionEventArgs);override;

    procedure Disconnected(connectionInfo: TGXDLMSConnectionEventArgs);override;

    procedure PreRead(args: TArray<TValueEventArgs>);override;

    procedure PreWrite(args: TArray<TValueEventArgs>);override;
    procedure PreAction(args: TArray<TValueEventArgs>);override;

    procedure PostRead(args: TArray<TValueEventArgs>);override;
    procedure PostWrite(args: TArray<TValueEventArgs>);override;
    procedure PostAction(args: TArray<TValueEventArgs>);override;
    // Update simulated values for the meter instance.
    procedure UpdateValues();
  end;
implementation

// Update simulated values for the meter instance.
procedure TGXDLMSMeter.UpdateValues();
var
  ln: TGXDLMSAssociationLogicalName;
  ldn: TGXDLMSData;
  r: TGXDLMSRegister;
  clock: TGXDLMSClock;
begin
  //TODO: Add simulated objects.
  //Add public authentication (None).
  ln := TGXDLMSAssociationLogicalName.Create('0.0.40.0.1.255');
  ln.ClientSAP := 16;
  ln.XDLMSContextInfo.MaxSendPduSize := 1024;
  ln.XDLMSContextInfo.MaxReceivePduSize := 1024;
  ln.AuthenticationMechanismName.MechanismId := TAuthentication.atNone;
  // Only get, service is allowed.
  // https://www.gurux.fi/Gurux.DLMS.Conformance
  ln.XDLMSContextInfo.Conformance := TConformance.cfGet;
  Items.Add(ln);
  //Add low authentication.
  ln := TGXDLMSAssociationLogicalName.Create('0.0.40.0.2.255');
  ln.ClientSAP := 17;
  ln.XDLMSContextInfo.MaxSendPduSize := 1024;
  ln.XDLMSContextInfo.MaxReceivePduSize := 1024;
  ln.Secret := TGXCommon.GetBytes('Gurux');
  ln.AuthenticationMechanismName.MechanismId := TAuthentication.atLow;
  // Only get, set, multiple references and parameterized access services
  // are allowed. https://www.gurux.fi/Gurux.DLMS.Conformance
  ln.XDLMSContextInfo.Conformance := TConformance(Integer(TConformance.cfGet) or Integer(TConformance.cfMultipleReferences) or
  Integer(TConformance.cfSet) or Integer(TConformance.cfSelectiveAccess));
  Items.Add(ln);
   //Add GMAC High authentication.
  ln := TGXDLMSAssociationLogicalName.Create('0.0.40.0.3.255');
  ln.ClientSAP := 1;
  ln.XDLMSContextInfo.MaxSendPduSize := 1024;
  ln.XDLMSContextInfo.MaxReceivePduSize := 1024;
  ln.AuthenticationMechanismName.MechanismId := TAuthentication.atHighGMAC;
  // Only get, set, multiple references and parameterized access services
  // are allowed. https://www.gurux.fi/Gurux.DLMS.Conformance
  ln.XDLMSContextInfo.Conformance := TConformance(Integer(TConformance.cfGet) or Integer(TConformance.cfMultipleReferences) or
  Integer(TConformance.cfSet) or Integer(TConformance.cfSelectiveAccess));
  Items.Add(ln);

  //Add Logical device Name
  ldn := TGXDLMSData.Create('0.0.42.0.0.255');
  ldn.Value := TValue.From(TGXCommon.GetBytes('GRX123456'));
  //Value is get as Octet String.
  ldn.SetDataType(2, TDataType.dtOctetString);
  ldn.SetUIDataType(2, TDataType.dtString);
  Items.Add(ldn);

  //Add Last average.
  r := TGXDLMSRegister.Create('1.1.21.25.0.255');
  r.Value := Integer(230);
  r.SetDataType(2, TDataType.dtInt32);
  //Set access right. Client can't change average value.
  Items.Add(r);
  //Add default clock. Clock's Logical Name is 0.0.1.0.0.255.
  clock := TGXDLMSClock.Create();
  clock.&Begin := TGXDateTime.Create($FFFF, 9, 1, $FF, $FF, $FF, $FF, $FF);
  clock.&End := TGXDateTime.Create($FFFF, 3, 1, $FF, $FF, $FF, $FF, $FF);
  clock.TimeZone := TGXDateTime.GetTimeZone();
  clock.Deviation := 60;
  Items.Add(clock);

end;

constructor TGXDLMSMeter.Create();
begin
  inherited Create(True, TInterfaceType.WRAPPER);
  // Each association has own conformance.
  SetConformance(TConformance.cfNone);
  UpdateValues();

  ///////////////////////////////////////////////////////////////////////
  //Server must initialize after all objects are added.
  Initialize(false);
end;

function TGXDLMSMeter.FindObject(objectType: TObjectType; sn: Integer; ln: string): TGXDLMSObject;
var
  it : TGXDLMSObject;
  a: TGXDLMSAssociationLogicalName;
begin
  Result := Nil;
  if objectType = TObjectType.otAssociationLogicalName Then
  begin
      for it in Items do
      begin
          if it.ObjectType = TObjectType.otAssociationLogicalName Then
          begin
              a := TGXDLMSAssociationLogicalName(it);
              if (a.ClientSAP = FSettings.ClientAddress) and
                  ((a.AuthenticationMechanismName.MechanismId = FSettings.Authentication)
                      and ((ln = a.LogicalName) or (ln = '0.0.40.0.0.255'))) then
              begin
                  Result := it;
                  break;
              end;
          end;
      end;
  end
  // Find object from the active association view.
  else if GetAssignedAssociation() <> Nil Then
    Result := GetAssignedAssociation().ObjectList.FindByLN(objectType, ln);
end;

function TGXDLMSMeter.IsTarget(serverAddress: Integer; clientAddress: Integer): BOOLEAN;
var
  it: TGXDLMSAssociationLogicalName;
  saps: TArray<TGXDLMSObject>;
  sap: TGXDLMSSapAssignment;
  tmp: TGXDLMSObject;
  e: TPair<Word, string>;
begin
  Result := false;
  SetAssignedAssociation(Nil);
  for tmp in Items.GetObjects(TObjectType.otAssociationLogicalName) do
  begin
    it := TGXDLMSAssociationLogicalName(tmp);
    if it.ClientSAP = clientAddress Then
    begin
        SetAssignedAssociation(it);
        break;
    end;
  end;
  if GetAssignedAssociation() <> Nil Then
  begin
      // Check server address using serial number.
      if (Not((serverAddress = $3FFF) or (serverAddress = $7F) or
          ((serverAddress and $3FFF) = ((SerialNumber Mod 10000) + 1000)))) Then
      begin
          // Find address from the SAP table.
          saps := Items.GetObjects(TObjectType.otSapAssignment);
          if Length(saps) <> 0 Then
          begin
              for tmp in saps do
              begin
                  sap := TGXDLMSSapAssignment(tmp);
                  if sap.SapAssignmentList.Count = 0 Then
                  begin
                    Result := true;
                    Exit;
                  end;
                  for e in sap.SapAssignmentList do
                  begin
                      // Check server address with two bytes.
                      if ((serverAddress and $FFFF0000) = 0) and ((serverAddress and $7FFF) = e.Key) Then
                      begin
                          Result := True;
                          break;
                      end;
                      // Check server address with one byte.
                      if ((serverAddress and $FFFFFF00) = 0) and ((serverAddress and $7F) = e.Key) Then
                      begin
                          Result := True;
                          break;
                      end;
                  end;
                  if Result Then
                  begin
                      break;
                  end;
              end;
          end
          else
          begin
              //Accept all server addresses if there is no SAP table available.
              Result := true;
          end;
      end;
  end;
end;

function TGXDLMSMeter.GetAttributeAccess(arg: TValueEventArgs):TAccessMode;
begin
  Result := GetAssignedAssociation().GetAccess(arg.Target, arg.Index);
end;

function TGXDLMSMeter.GetMethodAccess(arg: TValueEventArgs): TMethodAccessMode;
begin
  Result := GetAssignedAssociation().GetMethodAccess(arg.Target, arg.Index);
end;

function TGXDLMSMeter.ValidateAuthentication(authentication: TAuthentication; password: TBytes): TSourceDiagnostic;
begin
  //All connections are accepted.
  Result := TSourceDiagnostic.None;
end;

procedure TGXDLMSMeter.Connected(connectionInfo: TGXDLMSConnectionEventArgs);
begin

end;

procedure  TGXDLMSMeter.InvalidConnection(connectionInfo: TGXDLMSConnectionEventArgs);
begin

end;

procedure  TGXDLMSMeter.Disconnected(connectionInfo: TGXDLMSConnectionEventArgs);
begin

end;

procedure TGXDLMSMeter.PreRead(args: TArray<TValueEventArgs>);
begin

end;

procedure TGXDLMSMeter.PreWrite(args: TArray<TValueEventArgs>);
begin

end;
procedure TGXDLMSMeter.PreAction(args: TArray<TValueEventArgs>);
begin

end;

procedure TGXDLMSMeter.PostRead(args: TArray<TValueEventArgs>);
begin

end;

procedure TGXDLMSMeter.PostWrite(args: TArray<TValueEventArgs>);
begin

end;

procedure TGXDLMSMeter.PostAction(args: TArray<TValueEventArgs>);
begin

end;
end.

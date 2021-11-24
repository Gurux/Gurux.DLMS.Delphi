unit GXDLMSMeter;

interface
uses SysUtils,
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
Gurux.DLMS.Conformance;

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

    procedure  InvalidConnection(connectionInfo: TGXDLMSConnectionEventArgs);override;

    procedure  Disconnected(connectionInfo: TGXDLMSConnectionEventArgs);override;

    procedure PreRead(args: TArray<TValueEventArgs>);override;

    procedure PreWrite(args: TArray<TValueEventArgs>);override;
    procedure PreAction(args: TArray<TValueEventArgs>);override;

    procedure PostRead(args: TArray<TValueEventArgs>);override;
    procedure PostWrite(args: TArray<TValueEventArgs>);override;
    procedure PostAction(args: TArray<TValueEventArgs>);override;
  end;
implementation

constructor TGXDLMSMeter.Create();
begin
  inherited;
  // Each association has own conformance.
  SetConformance(TConformance.cfNone);
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

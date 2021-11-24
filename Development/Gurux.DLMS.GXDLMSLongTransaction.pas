unit Gurux.DLMS.GXDLMSLongTransaction;

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
Gurux.DLMS.GXReplyData;

type
  TGXDLMSLongTransaction = class
  protected
  public
  // Executed command.
  Command: TCommand;

  // Targets.
  Targets: TArray<TValueEventArgs>;

  // Extra data from PDU.
  Data: TGXByteBuffer;

  // Constructor.
  constructor Create(ATargets: TArray<TValueEventArgs>; ACommand: TCommand; AData: TGXByteBuffer); overload;
  end;
implementation

constructor TGXDLMSLongTransaction.Create(ATargets: TArray<TValueEventArgs>; ACommand: TCommand; AData: TGXByteBuffer);
begin
  Targets := ATargets;
  Command := ACommand;
  Data := TGXByteBuffer.Create();
  Data.SetArray(AData.GetData(), AData.Position, AData.Size - AData.Position);
end;
end.

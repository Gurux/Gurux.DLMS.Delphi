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

unit TranslatorSimpleTags;

interface
uses SysUtils, Generics.Collections, TranslatorOutputType, TranslatorGeneralTags,
Gurux.DLMS.GXDLMSTranslator, Gurux.DLMS.Command, Gurux.DLMS.ErrorCode,
Gurux.DLMS.ServiceError, Gurux.DLMS.ApplicationReference, Gurux.DLMS.HardwareResource,
Gurux.DLMS.VdeStateError, Gurux.DLMS.Service, Gurux.DLMS.Definition, Gurux.DLMS.Access,
Gurux.DLMS.Initiate, Gurux.DLMS.LoadDataSet, Gurux.DLMS.Task, Gurux.DLMS.Conformance,
ReleaseResponseReason, ReleaseRequestReason, Gurux.DLMS.Objects.SingleReadResponse,
Gurux.DLMS.VariableAccessSpecification, Gurux.DLMS.SetRequestType,
Gurux.DLMS.GetCommandType, Gurux.DLMS.ActionRequestType, Gurux.DLMS.ActionResponseType,
Gurux.DLMS.TranslatorTags, Gurux.DLMS.SetResponseType,
Gurux.DLMS.AccessServiceCommandType, Gurux.DLMS.DataType,
Gurux.DLMS.GXDLMS,
Gurux.DLMS.Enums.ExceptionStateError,
Gurux.DLMS.Enums.ExceptionServiceError;

type
TTranslatorSimpleTags = class
public
 //Get general tags.
  class procedure GetGeneralTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>); static;
  // Get SN tags.
  class procedure GetSnTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>); static;
  // Get LN tags.
  class procedure GetLnTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>); static;
  // Get clo tags.
  class procedure GetGloTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>); static;
  // Get ded tags.
  class procedure GetDedTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>); static;
  // Get translator tags.
  class procedure GetTranslatorTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>); static;

  class procedure GetDataTypeTags(list: TDictionary<LONGWORD, string>); static;

  class function ErrorCodeToString(value: TErrorCode): string; static;

  class function ValueOfErrorCode(value: string): TErrorCode; static;
  class function GetServiceErrors(): TDictionary<TServiceError, string>; static;
  class function GetApplicationReference(): TDictionary<TApplicationReference, string>; static;
  class function GetHardwareResource(): TDictionary<THardwareResource, String>; static;

  class function GetVdeStateError(): TDictionary<TVdeStateError, String>; static;
  class function GetService(): TDictionary<TService, String>; static;
  class function GetDefinition(): TDictionary<TDefinition, String>; static;
  class function GetAccess(): TDictionary<TAccess, String>; static;
  class function GetInitiate(): TDictionary<TInitiate, String>; static;
  class function GetLoadDataSet(): TDictionary<TLoadDataSet, String>; static;
  class function GetTask(): TDictionary<TTask, String>; static;
  class function GetServiceErrorValue(error: TServiceError; value : Integer): string; static;
  class function ServiceErrorToString(error: TServiceError): string; static;
  class function GetServiceError(error: string): TServiceError; static;
  class function ValueOfApplicationReference(value: string): WORD; static;
  class function ValueOfHardwareResource(value: string): WORD; static;

  class function ValueOfVdeStateError(value: string): WORD; static;
  class function ValueOfService(value: string): WORD; static;

  class function ValueOfDefinition(value: string): WORD; static;
  class function ValueOfAccess(value: string): WORD; static;
  class function ValueOfInitiate(value: string): WORD; static;

  class function ValueOfLoadDataSet(value: string): WORD; static;
  class function ValueOfTask(value: string): WORD; static;
  class function GetError(serviceError: TServiceError; value: string): WORD; static;

  class function ValueOfConformance(value: string): TConformance; static;
  class function ConformanceToString(value: TConformance): string; static;
  class function ReleaseResponseReasonToString(value: TReleaseResponseReason): string; static;
  class function ValueOfReleaseResponseReason(value: string): TReleaseResponseReason; static;
  class function ReleaseRequestReasonToString(value: TReleaseRequestReason): string; static;
  class function ValueOfReleaseRequestReason(value: string): TReleaseRequestReason; static;
  class function StateErrorToString(value: TExceptionStateError): string; static;
  class function ExceptionServiceErrorToString(value: TExceptionServiceError): string; static;
end;
implementation

class procedure TTranslatorSimpleTags.GetGeneralTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
begin
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.Snrm), 'Snrm');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.UnacceptableFrame), 'UnacceptableFrame');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DisconnectMode), 'DisconnectMode');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.Ua), 'Ua');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.Aarq), 'AssociationRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.Aare), 'AssociationResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ApplicationContextName), 'ApplicationContextName');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.InitiateResponse), 'InitiateResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.InitiateRequest), 'InitiateRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.NegotiatedQualityOfService), 'NegotiatedQualityOfService');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ProposedQualityOfService), 'ProposedQualityOfService');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ProposedDlmsVersionNumber), 'ProposedDlmsVersionNumber');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ProposedMaxPduSize), 'ProposedMaxPduSize');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ProposedConformance), 'ProposedConformance');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.VaaName), 'VaaName');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.NegotiatedConformance), 'NegotiatedConformance');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.NegotiatedDlmsVersionNumber), 'NegotiatedDlmsVersionNumber');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.NegotiatedMaxPduSize), 'NegotiatedMaxPduSize');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ConformanceBit), 'ConformanceBit');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.SenderACSERequirements), 'SenderACSERequirements');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ResponderACSERequirement), 'ResponderACSERequirement');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.RespondingMechanismName), 'MechanismName');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.CallingMechanismName), 'MechanismName');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.CallingAuthentication), 'CallingAuthentication');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.RespondingAuthentication), 'RespondingAuthentication');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.ReleaseRequest), 'ReleaseRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.ReleaseResponse), 'ReleaseResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DisconnectRequest), 'DisconnectRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.AssociationResult), 'AssociationResult');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ResultSourceDiagnostic), 'ResultSourceDiagnostic');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ACSEServiceUser), 'ACSEServiceUser');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.ACSEServiceProvider), 'ACSEServiceProvider');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.CallingAPTitle), 'CallingAPTitle');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.RespondingAPTitle), 'RespondingAPTitle');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.DedicatedKey), 'DedicatedKey');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.ConfirmedServiceError), 'ConfirmedServiceError');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.InformationReport), 'InformationReportRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.EventNotification), 'EventNotificationRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralBlockTransfer), 'GeneralBlockTransfer');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.CallingAeInvocationId), 'CallingAEInvocationId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.CalledAeInvocationId), 'CalledAEInvocationId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.RespondingAeInvocationId), 'RespondingAEInvocationId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorGeneralTags.CallingAeQualifier), 'CallingAEQualifier');
end;

class procedure TTranslatorSimpleTags.GetSnTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
begin
  list.Add(WORD(TCommand.ReadRequest), 'ReadRequest');
  list.Add(WORD(TCommand.WriteRequest), 'WriteRequest');
  list.Add(WORD(TCommand.WriteResponse), 'WriteResponse');
  list.Add((WORD(TCommand.ReadRequest) shl 8 ) or WORD(TVariableAccessSpecification.VariableName), 'VariableName');
  list.Add((WORD(TCommand.ReadRequest) shl 8 ) or WORD(TVariableAccessSpecification.ParameterisedAccess), 'ParameterisedAccess');
  list.Add((WORD(TCommand.ReadRequest) shl 8 ) or WORD(TVariableAccessSpecification.BlockNumberAccess), 'BlockNumberAccess');
  list.Add((WORD(TCommand.WriteRequest) shl 8) or WORD(TVariableAccessSpecification.VariableName), 'VariableName');
  list.Add(WORD(TCommand.ReadResponse), 'ReadResponse');
  list.Add((WORD(TCommand.ReadResponse) shl 8 ) or WORD(TSingleReadResponse.DataBlockResult), 'DataBlockResult');
  list.Add((WORD(TCommand.ReadResponse) shl 8 ) or WORD(TSingleReadResponse.Data), 'Data');
  list.Add((WORD(TCommand.ReadResponse) shl 8) or WORD(TSingleReadResponse.DataAccessError), 'DataAccessError');
end;

class procedure TTranslatorSimpleTags.GetLnTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
begin
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GetRequest), 'GetRequest');
  list.Add((WORD(TCommand.GetRequest) shl 8 ) or WORD(TGetCommandType.ctNormal), 'GetRequestNormal');
  list.Add((WORD(TCommand.GetRequest) shl 8 ) or WORD(TGetCommandType.ctNextDataBlock), 'GetRequestForNextDataBlock');
  list.Add((WORD(TCommand.GetRequest) shl 8 ) or WORD(TGetCommandType.ctWithList), 'GetRequestWithList');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.SetRequest), 'SetRequest');
  list.Add((WORD(TCommand.SetRequest) shl 8 ) or WORD(TSetRequestType.stNormal), 'SetRequestNormal');
  list.Add((WORD(TCommand.SetRequest) shl 8 ) or WORD(TSetRequestType.stFirstDataBlock), 'SetRequestFirstDataBlock');
  list.Add((WORD(TCommand.SetRequest) shl 8 ) or WORD(TSetRequestType.stWithDataBlock), 'SetRequestWithDataBlock');
  list.Add((WORD(TCommand.SetRequest) shl 8 ) or WORD(TSetRequestType.stWithList), 'SetRequestWithList');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.MethodRequest), 'ActionRequest');
  list.Add((WORD(TCommand.MethodRequest) shl 8 ) or WORD(TActionRequestType.arNormal), 'ActionRequestNormal');
  list.Add((WORD(TCommand.MethodRequest) shl 8 ) or WORD(TActionRequestType.arNextBlock), 'ActionRequestForNextDataBlock');
  list.Add((WORD(TCommand.MethodRequest) shl 8 ) or WORD(TActionRequestType.arWithList), 'ActionRequestWithList');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.MethodResponse), 'ActionResponse');
  list.Add((WORD(TCommand.MethodResponse) shl 8 ) or WORD(TActionRequestType.arNormal), 'ActionResponseNormal');
  list.Add((WORD(TCommand.MethodResponse) shl 8 ) or WORD(TActionRequestType.arWithFirstBlock), 'ActionResponseWithPBlock');
  list.Add((WORD(TCommand.MethodResponse) shl 8 ) or WORD(TActionRequestType.arWithList), 'ActionResponseWithList');
  list.Add((WORD(TCommand.MethodResponse) shl 8 ) or WORD(TActionRequestType.arNextBlock), 'ActionResponseNextBlock');
  list.Add(WORD(TCommand.DataNotification), 'DataNotification');
  list.Add(WORD(TCommand.GetResponse), 'GetResponse');
  list.Add((WORD(TCommand.GetResponse) shl 8 ) or WORD(TGetCommandType.ctNormal), 'GetResponseNormal');
  list.Add((WORD(TCommand.GetResponse) shl 8 ) or WORD(TGetCommandType.ctNextDataBlock), 'GetResponsewithDataBlock');
  list.Add((WORD(TCommand.GetResponse) shl 8 ) or WORD(TGetCommandType.ctWithList), 'GetResponseWithList');
  list.Add(WORD(TCommand.SetResponse), 'SetResponse');
  list.Add((WORD(TCommand.SetResponse) shl 8 ) or WORD(TSetResponseType.srNormal), 'SetResponseNormal');
  list.Add((WORD(TCommand.SetResponse) shl 8 ) or WORD(TSetResponseType.srDataBlock), 'SetResponseDataBlock');
  list.Add((WORD(TCommand.SetResponse) shl 8 ) or WORD(TSetResponseType.srLastDataBlock), 'SetResponseWithLastDataBlock');
  list.Add((WORD(TCommand.SetResponse) shl 8 ) or WORD(TSetResponseType.srWithList), 'SetResponseWithList');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.AccessRequest), 'AccessRequest');
  list.Add((WORD(TCommand.AccessRequest) shl 8 ) or WORD(TAccessServiceCommandType.ctGet), 'AccessRequestGet');
  list.Add((WORD(TCommand.AccessRequest) shl 8 ) or WORD(TAccessServiceCommandType.ctSet), 'AccessRequestSet');
  list.Add((WORD(TCommand.AccessRequest) shl 8 ) or WORD(TAccessServiceCommandType.ctAction), 'AccessRequestAction');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.AccessResponse), 'AccessResponse');
  list.Add((WORD(TCommand.AccessResponse) shl 8 ) or WORD(TAccessServiceCommandType.ctGet), 'AccessResponseGet');
  list.Add((WORD(TCommand.AccessResponse) shl 8 ) or WORD(TAccessServiceCommandType.ctSet), 'AccessResponseSet');
  list.Add((WORD(TCommand.AccessResponse) shl 8 ) or WORD(TAccessServiceCommandType.ctAction), 'AccessResponseAction');
  list.Add(WORD(TTranslatorTags.AccessRequestBody), 'AccessRequestBody');
  list.Add(WORD(TTranslatorTags.ListOfAccessRequestSpecification), 'AccessRequestSpecification');
  list.Add(WORD(TTranslatorTags.AccessRequestSpecification), '_AccessRequestSpecification');
  list.Add(WORD(TTranslatorTags.AccessRequestListOfData), 'AccessRequestListOfData');
  list.Add(WORD(TTranslatorTags.AccessResponseBody), 'AccessResponseBody');
  list.Add(WORD(TTranslatorTags.ListOfAccessResponseSpecification), 'AccessResponseSpecification');
  list.Add(WORD(TTranslatorTags.AccessResponseSpecification), '_AccessResponseSpecification');
  list.Add(WORD(TTranslatorTags.AccessResponseListOfData), 'AccessResponseListOfData');
  list.Add(WORD(TTranslatorTags.Service), 'Service');
  list.Add(WORD(TTranslatorTags.ServiceError), 'ServiceError');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GatewayRequest), 'GatewayRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GatewayResponse), 'GatewayResponse');
end;

class procedure TTranslatorSimpleTags.GetGloTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
begin
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloInitiateRequest), 'glo_InitiateRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloInitiateResponse), 'glo_InitiateResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloGetRequest), 'glo_GetRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloGetResponse), 'glo_GetResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloSetRequest), 'glo_SetRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloSetResponse), 'glo_SetResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloMethodRequest), 'glo_ActionRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloMethodResponse), 'glo_ActionResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloReadRequest), 'glo_ReadRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloReadResponse), 'glo_ReadResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloWriteRequest), 'glo_WriteRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloWriteResponse), 'glo_WriteResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralGloCiphering), 'GeneralGloCiphering');
end;

class procedure TTranslatorSimpleTags.GetDedTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
begin
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedInitiateRequest), 'ded_InitiateRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedInitiateResponse), 'ded_InitiateResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedGetRequest), 'ded_GetRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedGetResponse), 'ded_GetResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedSetRequest), 'ded_SetRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedSetResponse), 'ded_SetResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedMethodRequest), 'ded_ActionRequest');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedMethodResponse), 'ded_ActionResponse');
  TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralDedCiphering), 'generalDedCiphering');
end;

class procedure TTranslatorSimpleTags.GetTranslatorTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
begin
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Wrapper), 'Wrapper');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Hdlc), 'Hdlc');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.PduDlms), 'Pdu');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.TargetAddress), 'TargetAddress');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.SourceAddress), 'SourceAddress');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ListOfVariableAccessSpecification), 'ListOfVariableAccessSpecification');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ListOfData), 'ListOfData');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Success), 'Ok');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataAccessError), 'DataAccessError');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeDescriptor), 'AttributeDescriptor');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ClassId), 'ClassId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.InstanceId), 'InstanceId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeId), 'AttributeId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MethodInvocationParameters), 'MethodInvocationParameters');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Selector), 'Selector');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Parameter), 'Parameter');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.LastBlock), 'LastBlock');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockNumber), 'BlockNumber');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.RawData), 'RawData');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MethodDescriptor), 'MethodDescriptor');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MethodId), 'MethodId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Result), 'Result');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ReturnParameters), 'ReturnParameters');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AccessSelection), 'AccessSelection');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Value), 'Value');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AccessSelector), 'AccessSelector');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AccessParameters), 'AccessParameters');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeDescriptorList), 'AttributeDescriptorList');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeDescriptorWithSelection), 'AttributeDescriptorWithSelection');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ReadDataBlockAccess), 'ReadDataBlockAccess');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.WriteDataBlockAccess), 'WriteDataBlockAccess');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Data), 'Data');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.InvokeId), 'InvokeIdAndPriority');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.LongInvokeId), 'LongInvokeIdAndPriority');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DateTime), 'DateTime');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CurrentTime), 'CurrentTime');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Time), 'DateTime');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Reason), 'Reason');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.NotificationBody), 'NotificationBody');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataValue), 'DataValue');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CipheredService), 'CipheredService');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.SystemTitle), 'SystemTitle');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataBlock), 'DataBlock');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.TransactionId), 'TransactionId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.OriginatorSystemTitle), 'OriginatorSystemTitle');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.RecipientSystemTitle), 'RecipientSystemTitle');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.OtherInformation), 'OtherInformation');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.KeyInfo), 'KeyInfo');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CipheredContent), 'CipheredContent');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AgreedKey), 'AgreedKey');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.KeyParameters), 'KeyParameters');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.KeyCipheredData), 'KeyCipheredData');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeValue), 'AttributeValue');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MaxInfoRX), 'MaxInfoRX');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MaxInfoTX), 'MaxInfoTX');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.WindowSizeRX), 'WindowSizeRX');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.WindowSizeTX), 'WindowSizeTX');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ValueList), 'ValueList');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataAccessResult), 'DataAccessResult');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockControl), 'BlockControl');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockNumberAck), 'BlockNumberAck');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockData), 'BlockData');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ContentsDescription), 'ContentsDescription');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ArrayContents), 'ArrayContents');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.NetworkId), 'NetworkId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.PhysicalDeviceAddress), 'PhysicalDeviceAddress');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ProtocolVersion), 'ProtocolVersion');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAPTitle), 'CalledAPTitle');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAPInvocationId), 'CalledAPInvocationId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAEInvocationId), 'CalledAEInvocationId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CallingApInvocationId), 'CallingAPInvocationId');
  TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAEQualifier), 'CalledAEQualifier');
end;

class procedure TTranslatorSimpleTags.GetDataTypeTags(list: TDictionary<LONGWORD, string>);
begin
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtNone), 'None');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtArray), 'Array');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtBinaryCodedDesimal), 'Bcd');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtBitString), 'BitString');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtBoolean), 'Boolean');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtCompactArray), 'CompactArray');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtDate), 'Date');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtDateTime), 'DateTime');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtEnum), 'Enum');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtFloat32), 'Float32');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtFloat64), 'Float64');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt16), 'Int16');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt32), 'Int32');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt64), 'Int64');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt8), 'Int8');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtOctetString), 'OctetString');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtString), 'String');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtStringUTF8), 'StringUTF8');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtStructure), 'Structure');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtTime), 'Time');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt16), 'UInt16');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt32), 'UInt32');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt64), 'UInt64');
  list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt8), 'UInt8');
end;

class function TTranslatorSimpleTags.ErrorCodeToString(value: TErrorCode): string;
begin
  case value of
  TErrorCode.ecAccessViolated:
    Result := 'AccessViolated';
  TErrorCode.ecDataBlockNumberInvalid:
    Result := 'DataBlockNumberInvalid';
  TErrorCode.ecDataBlockUnavailable:
    Result := 'DataBlockUnavailable';
  TErrorCode.ecHardwareFault:
    Result := 'HardwareFault';
  TErrorCode.ecInconsistentClass:
    Result := 'InconsistentClass';
  TErrorCode.ecLongGetOrReadAborted:
    Result := 'LongGetOrReadAborted';
  TErrorCode.ecLongSetOrWriteAborted:
    Result := 'LongSetOrWriteAborted';
  TErrorCode.ecNoLongGetOrReadInProgress:
    Result := 'NoLongGetOrReadInProgress';
  TErrorCode.ecNoLongSetOrWriteInProgress:
    Result := 'NoLongSetOrWriteInProgress';
  TErrorCode.ecOk:
    Result := 'Success';
  TErrorCode.ecOtherReason:
    Result := 'OtherReason';
  TErrorCode.ecReadWriteDenied:
    Result := 'ReadWriteDenied';
  TErrorCode.ecTemporaryFailure:
    Result := 'TemporaryFailure';
  TErrorCode.ecUnavailableObject:
    Result := 'UnavailableObject';
  TErrorCode.ecUndefinedObject:
    Result := 'UndefinedObject';
  TErrorCode.ecUnmatchedType:
    Result := 'UnmatchedType';
  else raise EArgumentException.Create('Error code is invalid.');
  end;
end;

class function TTranslatorSimpleTags.ValueOfErrorCode(value: string): TErrorCode;
begin
  if string.Compare('AccessViolated', value) = 0 Then
    Result := TErrorCode.ecAccessViolated
  else if string.Compare('DataBlockNumberInvalid', value) = 0 Then
    Result := TErrorCode.ecDataBlockNumberInvalid
  else if string.Compare('DataBlockUnavailable', value) = 0 Then
    Result := TErrorCode.ecDataBlockUnavailable
  else if string.Compare('HardwareFault', value) = 0 Then
    Result := TErrorCode.ecHardwareFault
  else if string.Compare('InconsistentClass', value) = 0 Then
    Result := TErrorCode.ecInconsistentClass
  else if string.Compare('LongGetOrReadAborted', value) = 0 Then
    Result := TErrorCode.ecLongGetOrReadAborted
  else if string.Compare('LongSetOrWriteAborted', value) = 0 Then
    Result := TErrorCode.ecLongSetOrWriteAborted
  else if string.Compare('NoLongGetOrReadInProgress', value) = 0 Then
    Result := TErrorCode.ecNoLongGetOrReadInProgress
  else if string.Compare('NoLongSetOrWriteInProgress', value) = 0 Then
    Result := TErrorCode.ecNoLongSetOrWriteInProgress
  else if (string.Compare('Ok', value) = 0) or (string.Compare('Success', value) = 0) Then
    Result := TErrorCode.ecOk
  else if string.Compare('OtherReason', value) = 0 Then
    Result := TErrorCode.ecOtherReason
  else if string.Compare('ReadWriteDenied', value) = 0 Then
    Result := TErrorCode.ecReadWriteDenied
  else if string.Compare('TemporaryFailure', value) = 0 Then
    Result := TErrorCode.ecTemporaryFailure
  else if string.Compare('UnavailableObject', value) = 0 Then
    Result := TErrorCode.ecUnavailableObject
  else if string.Compare('UndefinedObject', value) = 0 Then
    Result := TErrorCode.ecUndefinedObject
  else if string.Compare('UnmatchedType', value) = 0 Then
    Result := TErrorCode.ecUnmatchedType
  else
    raise EArgumentException.Create('Error code is invalid. ' + value);
end;

class function TTranslatorSimpleTags.GetServiceErrors(): TDictionary<TServiceError, string>;
begin
  Result := TDictionary<TServiceError, string>.Create();
  Result.Add(TServiceError.ApplicationReference, 'ApplicationReference');
  Result.Add(TServiceError.HardwareResource, 'HardwareResource');
  Result.Add(TServiceError.VdeStateError, 'VdeStateError');
  Result.Add(TServiceError.Service, 'Service');
  Result.Add(TServiceError.Definition, 'Definition');
  Result.Add(TServiceError.Access, 'Access');
  Result.Add(TServiceError.Initiate, 'Initiate');
  Result.Add(TServiceError.LoadDataSet, 'LoadDataSet');
  Result.Add(TServiceError.Task, 'Task');
end;

class function TTranslatorSimpleTags.GetApplicationReference(): TDictionary<TApplicationReference, string>;
begin
  Result := TDictionary<TApplicationReference, string>.Create();
  Result.Add(TApplicationReference.ApplicationContextUnsupported, 'ApplicationContextUnsupported');
  Result.Add(TApplicationReference.ApplicationReferenceInvalid, 'ApplicationReferenceInvalid');
  Result.Add(TApplicationReference.ApplicationUnreachable, 'ApplicationUnreachable');
  Result.Add(TApplicationReference.DecipheringError, 'DecipheringError');
  Result.Add(TApplicationReference.Other, 'Other');
  Result.Add(TApplicationReference.ProviderCommunicationError, 'ProviderCommunicationError');
  Result.Add(TApplicationReference.TimeElapsed, 'TimeElapsed');
end;

class function TTranslatorSimpleTags.GetHardwareResource(): TDictionary<THardwareResource, String>;
begin
  Result := TDictionary<THardwareResource, string>.Create();
  Result.Add(THardwareResource.MassStorageUnavailable, 'MassStorageUnavailable');
  Result.Add(THardwareResource.MemoryUnavailable, 'MemoryUnavailable');
  Result.Add(THardwareResource.Other, 'Other');
  Result.Add(THardwareResource.OtherResourceUnavailable, 'OtherResourceUnavailable');
  Result.Add(THardwareResource.ProcessorResourceUnavailable, 'ProcessorResourceUnavailable');
end;

class function TTranslatorSimpleTags.GetVdeStateError(): TDictionary<TVdeStateError, String>;
begin
  Result := TDictionary<TVdeStateError, string>.Create();
  Result.Add(TVdeStateError.LoadingDataSet, 'LoadingDataSet');
  Result.Add(TVdeStateError.NoDlmsContext, 'NoDlmsContext');
  Result.Add(TVdeStateError.Other, 'Other');
  Result.Add(TVdeStateError.StatusInoperable, 'StatusInoperable');
  Result.Add(TVdeStateError.StatusNochange, 'StatusNochange');
end;

class function TTranslatorSimpleTags.GetService(): TDictionary<TService, String>;
begin
  Result := TDictionary<TService, string>.Create();
  Result.Add(TService.Other, 'Other');
  Result.Add(TService.PduSize, 'PduSize');
  Result.Add(TService.Unsupported, 'ServiceUnsupported');
end;

class function TTranslatorSimpleTags.GetDefinition(): TDictionary<TDefinition, String>;
begin
  Result := TDictionary<TDefinition, string>.Create();
  Result.Add(TDefinition.ObjectAttributeInconsistent, 'ObjectAttributeInconsistent');
  Result.Add(TDefinition.ObjectClassInconsistent, 'ObjectClassInconsistent');
  Result.Add(TDefinition.ObjectUndefined, 'ObjectUndefined');
  Result.Add(TDefinition.Other, 'Other');
end;

class function TTranslatorSimpleTags.GetAccess(): TDictionary<TAccess, String>;
begin
  Result := TDictionary<TAccess, string>.Create();
  Result.Add(TAccess.HardwareFault, 'HardwareFault');
  Result.Add(TAccess.ObjectAccessInvalid, 'ObjectAccessInvalid');
  Result.Add(TAccess.ObjectUnavailable, 'ObjectUnavailable');
  Result.Add(TAccess.Other, 'Other');
  Result.Add(TAccess.ScopeOfAccessViolated, 'ScopeOfAccessViolated');
end;

class function TTranslatorSimpleTags.GetInitiate(): TDictionary<TInitiate, String>;
begin
  Result := TDictionary<TInitiate, string>.Create();
  Result.Add(TInitiate.DlmsVersionTooLow, 'DlmsVersionTooLow');
  Result.Add(TInitiate.IncompatibleConformance, 'IncompatibleConformance');
  Result.Add(TInitiate.Other, 'Other');
  Result.Add(TInitiate.PduSizeTooShort, 'PduSizeTooShort');
  Result.Add(TInitiate.RefusedByTheVDEHandler, 'RefusedByTheVDEHandler');
end;

class function TTranslatorSimpleTags.GetLoadDataSet(): TDictionary<TLoadDataSet, String>;
begin
  Result := TDictionary<TLoadDataSet, string>.Create();
  Result.Add(TLoadDataSet.DatasetNotReady, 'DataSetNotReady');
  Result.Add(TLoadDataSet.DatasetSizeTooLarge, 'DatasetSizeTooLarge');
  Result.Add(TLoadDataSet.InterpretationFailure, 'InterpretationFailure');
  Result.Add(TLoadDataSet.NotAwaitedSegment, 'NotAwaitedSegment');
  Result.Add(TLoadDataSet.NotLoadable, 'NotLoadable');
  Result.Add(TLoadDataSet.Other, 'Other');
  Result.Add(TLoadDataSet.PrimitiveOutOfSequence, 'PrimitiveOutOfSequence');
  Result.Add(TLoadDataSet.StorageFailure, 'StorageFailure');
end;

class function TTranslatorSimpleTags.GetTask(): TDictionary<TTask, String>;
begin
  Result := TDictionary<TTask, string>.Create();
  Result.Add(TTask.NoRemoteControl, 'NoRemoteControl');
  Result.Add(TTask.Other, 'Other');
  Result.Add(TTask.TiRunning, 'tiRunning');
  Result.Add(TTask.TiStopped, 'tiStopped');
  Result.Add(TTask.TiUnusable, 'tiUnusable');
end;

class function TTranslatorSimpleTags.GetServiceErrorValue(error: TServiceError; value : Integer): string;
begin
  case error of
    TServiceError.ApplicationReference: Result := GetApplicationReference()[TApplicationReference(value)];
    TServiceError.HardwareResource: Result := GetHardwareResource()[THardwareResource(value)];
    TServiceError.VdeStateError: Result := GetVdeStateError()[TVdeStateError(value)];
    TServiceError.Service: Result := GetService()[TService(value)];
    TServiceError.Definition: Result := GetDefinition()[TDefinition(value)];
    TServiceError.Access: Result := GetAccess()[TAccess(value)];
    TServiceError.Initiate: Result := GetInitiate()[TInitiate(value)];
    TServiceError.LoadDataSet: Result := GetLoadDataSet()[TLoadDataSet(value)];
    TServiceError.Task: Result := GetTask()[TTask(value)];
    TServiceError.OtherError: Result := inttostr(value)
    else Result := '';
  end;
end;

class function TTranslatorSimpleTags.ServiceErrorToString(error: TServiceError): string;
begin
   Result := GetServiceErrors()[error];
end;

class function TTranslatorSimpleTags.GetServiceError(error: string): TServiceError;
var
  it: TPair<TServiceError, string>;
begin
  for it in GetServiceErrors() do
  begin
    if CompareText(error, it.Value) = 0 Then
    begin
      Result := it.Key;
      Exit;
    end;
  end;
  raise EArgumentException.Create('ServiceError is invalid. ' + error);
end;

class function TTranslatorSimpleTags.ValueOfApplicationReference(value: string): WORD;
var
  it: TPair<TApplicationReference, string>;
begin
  for it in GetApplicationReference() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
      Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfHardwareResource(value: string): WORD;
var
  it: TPair<THardwareResource, string>;
begin
  for it in GetHardwareResource() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfVdeStateError(value: string): WORD;
var
  it: TPair<TVdeStateError, string>;
begin
  for it in GetVdeStateError() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfService(value: string): WORD;
var
  it: TPair<TService, string>;
begin
  for it in GetService() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;


class function TTranslatorSimpleTags.ValueOfDefinition(value: string): WORD;
var
  it: TPair<TDefinition, string>;
begin
  for it in GetDefinition() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfAccess(value: string): WORD;
var
  it: TPair<TAccess, string>;
begin
  for it in GetAccess() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfInitiate(value: string): WORD;
var
  it: TPair<TInitiate, string>;
begin
  for it in GetInitiate() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfLoadDataSet(value: string): WORD;
var
  it: TPair<TLoadDataSet, string>;
begin
  for it in GetLoadDataSet() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ValueOfTask(value: string): WORD;
var
  it: TPair<TTask, string>;
begin
  for it in GetTask() do
  begin
    if CompareText(value, it.Value) = 0 Then
    begin
       Result := WORD(it.Key);
      Exit;
    end;
  end;
  raise EArgumentException.Create('Application reference is invalid. ' + value);
end;

class function TTranslatorSimpleTags.GetError(serviceError: TServiceError; value: string): WORD;
begin
  case serviceError of
    TServiceError.ApplicationReference: Result := ValueOfApplicationReference(value);
    TServiceError.HardwareResource: Result := ValueOfHardwareResource(value);
    TServiceError.VdeStateError: Result := ValueOfVdeStateError(value);
    TServiceError.Service: Result := ValueOfService(value);
    TServiceError.Definition: Result := ValueOfDefinition(value);
    TServiceError.Access: Result := ValueOfAccess(value);
    TServiceError.Initiate: Result := ValueOfInitiate(value);
    TServiceError.LoadDataSet: Result := ValueOfLoadDataSet(value);
    TServiceError.Task: Result := ValueOfTask(value);
    TServiceError.OtherError: Result := strToInt(value);
    else raise EArgumentException.Create('Servce error is invalid.');
  end;
end;


class function TTranslatorSimpleTags.ValueOfConformance(value: string): TConformance;
begin
if string.Compare('Access', value) = 0 Then
    Result := TConformance.cfAccess
  else if string.Compare('Action', value) = 0 Then
    Result := TConformance.cfAction
  else if string.Compare('Attribute0SupportedWithGet', value) = 0 Then
    Result := TConformance.cfAttribute0SupportedWithGet
  else if string.Compare('Attribute0SupportedWithSet', value) = 0 Then
    Result := TConformance.cfAttribute0SupportedWithSet
  else if string.Compare('BlockTransferWithAction', value) = 0 Then
    Result := TConformance.cfBlockTransferWithAction
  else if string.Compare('BlockTransferWithGetOrRead', value) = 0 Then
    Result := TConformance.cfBlockTransferWithGetOrRead
  else if string.Compare('BlockTransferWithSetOrWrite', value) = 0 Then
    Result := TConformance.cfBlockTransferWithSetOrWrite
  else if string.Compare('DataNotification', value) = 0 Then
    Result := TConformance.cfDataNotification
  else if string.Compare('EventNotification', value) = 0 Then
    Result := TConformance.cfEventNotification
  else if string.Compare('GeneralBlockTransfer', value) = 0 Then
    Result := TConformance.cfGeneralBlockTransfer
  else if string.Compare('GeneralProtection', value) = 0 Then
    Result := TConformance.cfGeneralProtection
  else if string.Compare('Get', value) = 0 Then
    Result := TConformance.cfGet
  else if string.Compare('InformationReport', value) = 0 Then
    Result := TConformance.cfInformationReport
  else if string.Compare('MultipleReferences', value) = 0 Then
    Result := TConformance.cfMultipleReferences
  else if string.Compare('ParameterizedAccess', value) = 0 Then
    Result := TConformance.cfParameterizedAccess
  else if string.Compare('PriorityMgmtSupported', value) = 0 Then
    Result := TConformance.cfPriorityMgmtSupported
  else if string.Compare('Read', value) = 0 Then
    Result := TConformance.cfRead
  else if string.Compare('ReservedSeven', value) = 0 Then
    Result := TConformance.cfReservedSeven
  else if string.Compare('DeltaValueEncoding', value) = 0 Then
    Result := TConformance.cfDeltaValueEncoding
  else if string.Compare('ReservedZero', value) = 0 Then
    Result := TConformance.cfReservedZero
  else if string.Compare('SelectiveAccess', value) = 0 Then
    Result := TConformance.cfSelectiveAccess
  else if string.Compare('Set', value) = 0 Then
    Result := TConformance.cfSet
  else if string.Compare('UnconfirmedWrite', value) = 0 Then
    Result := TConformance.cfUnconfirmedWrite
  else if string.Compare('Write', value) = 0 Then
    Result := TConformance.cfWrite
  else
    raise EArgumentException.Create('Conformance1 is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ConformanceToString(value: TConformance): string;
begin
case value of
  TConformance.cfReservedZero:
    Result := 'ReservedZero';
  TConformance.cfGeneralProtection:
    Result := 'GeneralProtection';
  TConformance.cfGeneralBlockTransfer:
      Result := 'GeneralBlockTransfer';
  TConformance.cfRead:
      Result := 'Read';
  TConformance.cfWrite:
      Result := 'Write';
  TConformance.cfUnconfirmedWrite:
      Result := 'UnconfirmedWrite';
  TConformance.cfDeltaValueEncoding:
      Result := 'DeltaValueEncoding';
  TConformance.cfReservedSeven:
      Result := 'ReservedSeven';
  TConformance.cfAttribute0SupportedWithSet:
      Result := 'Attribute0SupportedWithSet';
  TConformance.cfPriorityMgmtSupported:
      Result := 'PriorityMgmtSupported';
  TConformance.cfAttribute0SupportedWithGet:
      Result := 'Attribute0SupportedWithGet';
  TConformance.cfBlockTransferWithGetOrRead:
      Result := 'BlockTransferWithGetOrRead';
  TConformance.cfBlockTransferWithSetOrWrite:
      Result := 'BlockTransferWithSetOrWrite';
  TConformance.cfBlockTransferWithAction:
      Result := 'BlockTransferWithAction';
  TConformance.cfMultipleReferences:
      Result := 'MultipleReferences';
  TConformance.cfInformationReport:
      Result := 'InformationReport';
  TConformance.cfDataNotification:
      Result := 'DataNotification';
  TConformance.cfAccess:
      Result := 'Access';
  TConformance.cfParameterizedAccess:
      Result := 'ParameterizedAccess';
  TConformance.cfGet:
      Result := 'Get';
  TConformance.cfSet:
      Result := 'Set';
  TConformance.cfSelectiveAccess:
      Result := 'SelectiveAccess';
  TConformance.cfEventNotification:
      Result := 'EventNotification';
  TConformance.cfAction:
      Result := 'Action';
  TConformance.cfNone:
    Result := 'None';
  else
    raise EArgumentException.Create('Invalid Conformance');
  end;
end;


class function TTranslatorSimpleTags.ReleaseResponseReasonToString(value: TReleaseResponseReason): string;
begin
  case value of
  ReleaseResponseReason.Normal: Result := 'Normal';
  ReleaseResponseReason.NotFinished: Result := 'NotFinished';
  ReleaseResponseReason.UserDefined: Result := 'UserDefined';
  else raise EArgumentException.Create('ReleaseResponseReason is invalid.');
  end;
end;

class function TTranslatorSimpleTags.ValueOfReleaseResponseReason(value: string): TReleaseResponseReason;
begin
  if string.Compare(value, 'Normal', true) = 0 Then
    Result := ReleaseResponseReason.Normal
  else if string.Compare(value, 'NotFinished') = 0 Then
    Result := ReleaseResponseReason.NotFinished
  else if string.Compare(value, 'UserDefined') = 0 Then
    Result := ReleaseResponseReason.UserDefined
  else
    raise EArgumentException.Create('ReleaseResponseReason is invalid. ' + value);
end;

class function TTranslatorSimpleTags.ReleaseRequestReasonToString(value: TReleaseRequestReason): string;
begin
  case value of
  ReleaseRequestReason.Normal: Result := 'Normal';
  ReleaseRequestReason.Urgent: Result := 'Urgent';
  ReleaseRequestReason.UserDefined: Result := 'UserDefined';
  else raise EArgumentException.Create('ReleaseRequestReason is invalid.');
  end;
end;

class function TTranslatorSimpleTags.ValueOfReleaseRequestReason(value: string): TReleaseRequestReason;
begin
  if string.Compare(value, 'normal', true) = 0 Then
    Result := ReleaseRequestReason.Normal
  else if string.Compare(value, 'urgent', true) = 0 Then
    Result := ReleaseRequestReason.Urgent
  else if string.Compare(value, 'user-defined', true) = 0 Then
    Result := ReleaseRequestReason.UserDefined
  else
    raise EArgumentException.Create('ReleaseRequestReason is invalid. ' + value);
end;


class function TTranslatorSimpleTags.StateErrorToString(value: TExceptionStateError): string;
begin
  case value of
  TExceptionStateError.ServiceNotAllowed: Result := 'service-not-allowed';
  TExceptionStateError.ServiceUnknown: Result := 'service-unknown';
  else raise EArgumentException.Create('TExceptionStateError is invalid.');
  end;
end;

class function TTranslatorSimpleTags.ExceptionServiceErrorToString(value: TExceptionServiceError): string;
begin
  case value of
  TExceptionServiceError.OperationNotPossible: Result := 'operation-not-possible';
  TExceptionServiceError.ServiceNotSupported: Result := 'service-not-supported';
  TExceptionServiceError.OtherReason: Result := 'other-reason';
  TExceptionServiceError.PduTooLong: Result := 'pdu-too-long';
  TExceptionServiceError.DecipheringError: Result := 'deciphering-error';
  TExceptionServiceError.InvocationCounterError: Result := 'invocation-counter-error';
  else raise EArgumentException.Create('TExceptionStateError is invalid.');
  end;
end;

end.

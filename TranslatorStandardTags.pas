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

unit TranslatorStandardTags;

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
Gurux.DLMS.AccessServiceCommandType, Gurux.DLMS.DataType;

type
TTranslatorStandardTags = class
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
  end;

implementation
uses Gurux.DLMS.GXDLMS;

  class procedure TTranslatorStandardTags.GetGeneralTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
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
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.NegotiatedQualityOfService), 'NegotiatedQualityOfService');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ProposedQualityOfService), 'ProposedQualityOfService');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ProposedDlmsVersionNumber), 'ProposedDlmsVersionNumber');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ProposedMaxPduSize), 'ProposedMaxPduSize');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ProposedConformance), 'ProposedConformance');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.VaaName), 'VaaName');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.NegotiatedConformance), 'NegotiatedConformance');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.NegotiatedDlmsVersionNumber), 'NegotiatedDlmsVersionNumber');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.NegotiatedMaxPduSize), 'NegotiatedMaxPduSize');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ConformanceBit), 'ConformanceBit');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.SenderACSERequirements), 'SenderACSERequirements');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ResponderACSERequirement), 'ResponderACSERequirement');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.RespondingMechanismName), 'MechanismName');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.CallingMechanismName), 'MechanismName');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.CallingAuthentication), 'CallingAuthentication');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.RespondingAuthentication), 'RespondingAuthentication');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.ReleaseRequest), 'ReleaseRequest');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.ReleaseResponse), 'ReleaseResponse');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DisconnectRequest), 'DisconnectRequest');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.AssociationResult), 'AssociationResult');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ResultSourceDiagnostic), 'ResultSourceDiagnostic');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ACSEServiceUser), 'ACSEServiceUser');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.ACSEServiceProvider), 'ACSEServiceProvider');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.CallingAPTitle), 'CallingAPTitle');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.RespondingAPTitle), 'RespondingAPTitle');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.DedicatedKey), 'DedicatedKey');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.ConfirmedServiceError), 'ConfirmedServiceError');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.InformationReport), 'InformationReportRequest');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.EventNotification), 'EventNotificationRequest');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralBlockTransfer), 'GeneralBlockTransfer');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.CallingAeInvocationId), 'CallingAEInvocationId');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.CalledAeInvocationId), 'CalledAEInvocationId');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.RespondingAeInvocationId), 'RespondingAeInvocationId');
    TGXDLMSTranslator.AddTag(list, WORD(TranslatorGeneralTags.CallingAeQualifier), 'CallingAEQualifier');
  end;

  class procedure TTranslatorStandardTags.GetSnTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
  begin
    list.Add(WORD(TCommand.ReadRequest), 'readRequest');
    list.Add(WORD(TCommand.WriteRequest), 'writeRequest');
    list.Add(WORD(TCommand.WriteResponse), 'writeResponse');
    list.Add((WORD(TCommand.WriteRequest) shl 8) or WORD(TSingleReadResponse.Data), 'Data');
    list.Add((WORD(TCommand.ReadRequest) shl 8) or WORD(TVariableAccessSpecification.VariableName), 'variable-name');
    list.Add((WORD(TCommand.ReadRequest) shl 8) or WORD(TVariableAccessSpecification.ParameterisedAccess), 'parameterized-access');
    list.Add((WORD(TCommand.ReadRequest) shl 8) or WORD(TVariableAccessSpecification.BlockNumberAccess), 'BlockNumberAccess');
    list.Add((WORD(TCommand.WriteRequest) shl 8) or WORD(TVariableAccessSpecification.VariableName), 'variable-name');
    list.Add(WORD(TCommand.ReadResponse), 'readResponse');
    list.Add((WORD(TCommand.ReadResponse) shl 8) or WORD(TSingleReadResponse.DataBlockResult), 'DataBlockResult');
    list.Add((WORD(TCommand.ReadResponse) shl 8) or WORD(TSingleReadResponse.Data), 'data');
    list.Add((WORD(TCommand.WriteResponse) shl 8) or WORD(TSingleReadResponse.Data), 'data');
    list.Add((WORD(TCommand.ReadResponse) shl 8) or WORD(TSingleReadResponse.DataAccessError), 'data-access-error');
  end;

  class procedure TTranslatorStandardTags.GetLnTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
  begin
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GetRequest), 'get-request');
    list.Add((WORD(TCommand.GetRequest) shl 8) or WORD(TGetCommandType.ctNormal), 'get-request-normal');
    list.Add((WORD(TCommand.GetRequest) shl 8) or WORD(TGetCommandType.ctNextDataBlock), 'get-request-next');
    list.Add((WORD(TCommand.GetRequest) shl 8) or WORD(TGetCommandType.ctWithList), 'get-request-with-list');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.SetRequest), 'set-request');
    list.Add((WORD(TCommand.SetRequest) shl 8) or WORD(TSetRequestType.stNormal), 'set-request-normal');
    list.Add((WORD(TCommand.SetRequest) shl 8) or WORD(TSetRequestType.stFirstDataBlock), 'set-request-first-data-block');
    list.Add((WORD(TCommand.SetRequest) shl 8) or WORD(TSetRequestType.stWithDataBlock), 'set-request-with-data-block');
    list.Add((WORD(TCommand.SetRequest) shl 8) or WORD(TSetRequestType.stWithList), 'set-request-with-list');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.MethodRequest), 'action-request');
    list.Add((WORD(TCommand.MethodRequest) shl 8) or WORD(TActionRequestType.arNormal), 'action-request-normal');
    list.Add((WORD(TCommand.MethodRequest) shl 8) or WORD(TActionRequestType.arNextBlock), 'ActionRequestForNextDataBlock');
    list.Add((WORD(TCommand.MethodRequest) shl 8) or WORD(TActionRequestType.arWithList), 'action-request-with-list');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.MethodResponse), 'action-response');
    list.Add(WORD(TCommand.MethodResponse) shl 8 or WORD(TActionResponseType.Normal), 'action-response-normal');
    list.Add(WORD(TCommand.MethodResponse) shl 8 or WORD(TActionResponseType.WithFirstBlock), 'action-response-with-first-block');
    list.Add(WORD(TCommand.MethodResponse) shl 8 or WORD(TActionResponseType.WithList), 'action-response-with-list');
    list.Add(WORD(TTranslatorTags.SingleResponse), 'single-response');
    list.Add(WORD(TCommand.DataNotification), 'data-notification');
    list.Add(WORD(TCommand.GetResponse), 'get-response');
    list.Add((WORD(TCommand.GetResponse) shl 8) or WORD(TGetCommandType.ctNormal), 'get-response-normal');
    list.Add((WORD(TCommand.GetResponse) shl 8) or WORD(TGetCommandType.ctNextDataBlock), 'get-response-with-data-block');
    list.Add((WORD(TCommand.GetResponse) shl 8) or WORD(TGetCommandType.ctWithList), 'get-response-with-list');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.SetResponse), 'set-response');
    list.Add((WORD(TCommand.SetResponse) shl 8) or WORD(TSetResponseType.srNormal), 'set-response-normal');
    list.Add((WORD(TCommand.SetResponse) shl 8) or WORD(TSetResponseType.srDataBlock), 'set-response-data-block');
    list.Add((WORD(TCommand.SetResponse) shl 8) or WORD(TSetResponseType.srLastDataBlock), 'set-response-with-last-data-block');
    list.Add((WORD(TCommand.SetResponse) shl 8) or WORD(TSetResponseType.srWithList), 'set-response-with-list');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.AccessRequest), 'access-request');
    list.Add((WORD(TCommand.AccessRequest) shl 8) or WORD(TAccessServiceCommandType.ctGet), 'access-request-get');
    list.Add((WORD(TCommand.AccessRequest) shl 8) or WORD(TAccessServiceCommandType.ctSet), 'access-request-set');
    list.Add((WORD(TCommand.AccessRequest) shl 8) or WORD(TAccessServiceCommandType.ctAction), 'access-request-action');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.AccessResponse), 'access-response');
    list.Add((WORD(TCommand.AccessResponse) shl 8) or WORD(TAccessServiceCommandType.ctGet), 'access-response-get');
    list.Add((WORD(TCommand.AccessResponse) shl 8) or WORD(TAccessServiceCommandType.ctSet), 'access-response-set');
    list.Add((WORD(TCommand.AccessResponse) shl 8) or WORD(TAccessServiceCommandType.ctAction), 'access-response-action');
    list.Add(WORD(TTranslatorTags.AccessRequestBody), 'access-request-body');
    list.Add(WORD(TTranslatorTags.ListOfAccessRequestSpecification), 'access-request-specification');
    list.Add(WORD(TTranslatorTags.AccessRequestSpecification), 'Access-Request-Specification');
    list.Add(WORD(TTranslatorTags.AccessRequestListOfData), 'access-request-list-of-data');
    list.Add(WORD(TTranslatorTags.AccessResponseBody), 'access-response-body');
    list.Add(WORD(TTranslatorTags.ListOfAccessResponseSpecification), 'access-response-specification');
    list.Add(WORD(TTranslatorTags.AccessResponseSpecification), 'Access-Response-Specification');
    list.Add(WORD(TTranslatorTags.AccessResponseListOfData), 'access-response-list-of-data');
    list.Add(WORD(TTranslatorTags.Service), 'service');
    list.Add(WORD(TTranslatorTags.ServiceError), 'service-error');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralBlockTransfer), 'general-block-transfer');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GatewayRequest), 'gateway-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GatewayResponse), 'gateway-response');
  end;

  class procedure TTranslatorStandardTags.GetGloTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
  begin
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloInitiateRequest), 'glo-initiate-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloInitiateResponse), 'glo-initiate-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloGetRequest), 'glo-get-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloGetResponse), 'glo-get-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloSetRequest), 'glo-set-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloSetResponse), 'glo-set-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloMethodRequest), 'glo-action-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloMethodResponse), 'glo-action-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloReadRequest), 'glo-read-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloReadResponse), 'glo-read-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloWriteRequest), 'glo-write-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GloWriteResponse), 'glo-write-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralGloCiphering), 'general-glo-ciphering');
  end;

  class procedure TTranslatorStandardTags.GetDedTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
  begin
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedInitiateRequest), 'ded-initiate-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedInitiateResponse), 'ded-initiate-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedGetRequest), 'ded-get-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedGetResponse), 'ded-get-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedSetRequest), 'ded-set-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedSetResponse), 'ded-set-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedMethodRequest), 'ded-action-request');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.DedMethodResponse), 'ded-action-response');
    TGXDLMSTranslator.AddTag(list, WORD(TCommand.GeneralDedCiphering), 'general-ded-ciphering');
  end;

  class procedure TTranslatorStandardTags.GetTranslatorTags(tp: TTranslatorOutputType; list: TDictionary<LONGWORD, string>);
  begin
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Wrapper), 'Wrapper');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Hdlc), 'Hdlc');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.PduDlms), 'xDLMS-APDU');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.PduCse), 'aCSE-APDU');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.TargetAddress), 'TargetAddress');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.SourceAddress), 'SourceAddress');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ListOfVariableAccessSpecification), 'variable-access-specification');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ListOfData), 'list-of-data');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Success), 'Success');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataAccessError), 'data-access-result');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeDescriptor), 'cosem-attribute-descriptor');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ClassId), 'class-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.InstanceId), 'instance-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeId), 'attribute-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MethodInvocationParameters), 'method-invocation-parameters');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Selector), 'selector');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Parameter), 'parameter');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.LastBlock), 'LastBlock');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockNumber), 'block-number');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.RawData), 'RawData');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MethodDescriptor), 'cosem-method-descriptor');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MethodId), 'method-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Result), 'result');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ReturnParameters), 'return-parameters');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AccessSelection), 'access-selection');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Value), 'value');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AccessSelector), 'access-selector');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AccessParameters), 'access-parameters');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeDescriptorList), 'attribute-descriptor-list');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeDescriptorWithSelection), 'Cosem-Attribute-Descriptor-With-Selection');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ReadDataBlockAccess), 'ReadDataBlockAccess');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.WriteDataBlockAccess), 'WriteDataBlockAccess');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Data), 'data');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.InvokeId), 'invoke-id-and-priority');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.LongInvokeId), 'long-invoke-id-and-priority');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DateTime), 'date-time');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CurrentTime), 'current-time');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Time), 'time');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Reason), 'Reason');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.VariableAccessSpecification), 'Variable-Access-Specification');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.Choice), 'CHOICE');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.NotificationBody), 'notification-body');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataValue), 'data-value');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.InitiateError), 'initiateError');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CipheredService), 'ciphered-content');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.SystemTitle), 'system-title');
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
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.AttributeValue), 'attribute-value');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MaxInfoRX), 'MaxInfoRX');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.MaxInfoTX), 'MaxInfoTX');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.WindowSizeRX), 'WindowSizeRX');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.WindowSizeTX), 'WindowSizeTX');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ValueList), 'value-list');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.DataAccessResult), 'data-access-result');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockControl), 'block-control');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockNumberAck), 'block-number-ack');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.BlockData), 'block-data');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ContentsDescription), 'contents-description');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ArrayContents), 'array-contents');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.NetworkId), 'network-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.PhysicalDeviceAddress), 'physical-device-address');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.ProtocolVersion), 'protocol-version');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAPTitle), 'called-ap-title');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAPInvocationId), 'called-ap-invocation-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAEInvocationId), 'called-ae-invocation-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CallingApInvocationId), 'calling-ap-invocation-id');
    TGXDLMSTranslator.AddTag(list, WORD(TTranslatorTags.CalledAEQualifier), 'called-ae-qualifier');
  end;

  class procedure TTranslatorStandardTags.GetDataTypeTags(list: TDictionary<LONGWORD, string>);
  begin
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtNone), 'null-data');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtArray), 'array');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtBinaryCodedDesimal), 'bcd');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtBitString), 'bit-string');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtBoolean), 'boolean');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtCompactArray), 'compact-array');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtDate), 'date');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtDateTime), 'date-time');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtEnum), 'enum');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtFloat32), 'float32');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtFloat64), 'float64,');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt16), 'long');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt32), 'double-long');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt64), 'long64');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtInt8), 'integer');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtOctetString), 'octet-string');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtString), 'visible-string');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtStringUTF8), 'utf8-string');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtStructure), 'structure');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtTime), 'time');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt16), 'long-unsigned');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt32), 'double-long-unsigned');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt64), 'long64-unsigned');
    list.Add(DATA_TYPE_OFFSET + WORD(TDataType.dtUInt8), 'unsigned');
  end;

  class function TTranslatorStandardTags.ErrorCodeToString(value: TErrorCode): string;
  begin
    case value of
      TErrorCode.ecAccessViolated: Result := 'scope-of-access-violated';
      TErrorCode.ecDataBlockNumberInvalid: Result := 'data-block-number-invalid';
      TErrorCode.ecDataBlockUnavailable: Result := 'data-block-unavailable';
      TErrorCode.ecHardwareFault: Result := 'hardware-fault';
      TErrorCode.ecInconsistentClass: Result := 'object-class-inconsistent';
      TErrorCode.ecLongGetOrReadAborted: Result := 'long-Get-aborted';
      TErrorCode.ecLongSetOrWriteAborted: Result := 'long-set-aborted';
      TErrorCode.ecNoLongGetOrReadInProgress: Result := 'no-long-Get-in-progress';
      TErrorCode.ecNoLongSetOrWriteInProgress: Result := 'no-long-set-in-progress';
      TErrorCode.ecOk: Result := 'success';
      TErrorCode.ecOtherReason: Result := 'other-reason';
      TErrorCode.ecReadWriteDenied: Result := 'read-write-denied';
      TErrorCode.ecTemporaryFailure: Result := 'temporary-failure';
      TErrorCode.ecUnavailableObject: Result := 'object-unavailable';
      TErrorCode.ecUndefinedObject: Result := 'object-undefined';
      TErrorCode.ecUnmatchedType: Result := 'type-unmatched';
      else raise EArgumentException.Create('Error code is invalid.');
    end;
 end;

 class function TTranslatorStandardTags.ValueOfErrorCode(value: string): TErrorCode;
 begin
  if CompareText('scope-of-access-violated', value) = 0 Then
    Result := TErrorCode.ecAccessViolated
  else if CompareText('data-block-number-invalid', value) = 0 Then
    Result := TErrorCode.ecDataBlockNumberInvalid
  else if 'data-block-unavailable'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecDataBlockUnavailable
  else if 'hardware-fault'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecHardwareFault
  else if 'object-class-inconsistent'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecInconsistentClass
  else if 'long-Get-aborted'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecLongGetOrReadAborted
  else if 'long-set-aborted'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecLongSetOrWriteAborted
  else if 'no-long-Get-in-progress'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecNoLongGetOrReadInProgress
  else if 'no-long-set-in-progress'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecNoLongSetOrWriteInProgress
  else if 'success'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecOk
  else if 'other-reason'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecOtherReason
  else if 'read-write-denied'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecReadWriteDenied
  else if 'temporary-failure'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecTemporaryFailure
  else if 'object-unavailable'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecUnavailableObject
  else if 'object-undefined'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecUndefinedObject
  else if 'type-unmatched'.CompareTo(value) = 0 Then
      Result := TErrorCode.ecUnmatchedType
  else
      raise EArgumentException.Create('Error code is invalid. ' + value);
end;

  class function TTranslatorStandardTags.GetServiceErrors(): TDictionary<TServiceError, string>;
  begin
    Result := TDictionary<TServiceError, string>.Create();
    Result.Add(TServiceError.ApplicationReference, 'application-reference');
    Result.Add(TServiceError.HardwareResource, 'hardware-resource');
    Result.Add(TServiceError.VdeStateError, 'vde-state-error');
    Result.Add(TServiceError.Service, 'service');
    Result.Add(TServiceError.Definition, 'definition');
    Result.Add(TServiceError.Access, 'access');
    Result.Add(TServiceError.Initiate, 'initiate');
    Result.Add(TServiceError.LoadDataSet, 'load-data-set');
    Result.Add(TServiceError.Task, 'task');
  end;

  class function TTranslatorStandardTags.GetApplicationReference(): TDictionary<TApplicationReference, string>;
  begin
    Result := TDictionary<TApplicationReference, string>.Create();
    Result.Add(TApplicationReference.ApplicationContextUnsupported, 'application-context-unsupported');
    Result.Add(TApplicationReference.ApplicationReferenceInvalid, 'application-reference-invalid');
    Result.Add(TApplicationReference.ApplicationUnreachable, 'application-unreachable');
    Result.Add(TApplicationReference.DecipheringError, 'deciphering-error');
    Result.Add(TApplicationReference.Other, 'other');
    Result.Add(TApplicationReference.ProviderCommunicationError, 'provider-communication-error');
    Result.Add(TApplicationReference.TimeElapsed, 'time-elapsed');
  end;

  class function TTranslatorStandardTags.GetHardwareResource(): TDictionary<THardwareResource, String>;
  begin
    Result := TDictionary<THardwareResource, string>.Create();
    Result.Add(THardwareResource.MassStorageUnavailable, 'mass-storage-unavailable');
    Result.Add(THardwareResource.MemoryUnavailable, 'memory-unavailable');
    Result.Add(THardwareResource.Other, 'other');
    Result.Add(THardwareResource.OtherResourceUnavailable, 'other-resource-unavailable');
    Result.Add(THardwareResource.ProcessorResourceUnavailable, 'processor-resource-unavailable');
  end;

  class function TTranslatorStandardTags.GetVdeStateError(): TDictionary<TVdeStateError, String>;
  begin
    Result := TDictionary<TVdeStateError, string>.Create();
    Result.Add(TVdeStateError.LoadingDataSet, 'loading-data-set');
    Result.Add(TVdeStateError.NoDlmsContext, 'no-dlms-context');
    Result.Add(TVdeStateError.Other, 'other');
    Result.Add(TVdeStateError.StatusInoperable, 'status-inoperable');
    Result.Add(TVdeStateError.StatusNochange, 'status-nochange');
  end;

  class function TTranslatorStandardTags.GetService(): TDictionary<TService, String>;
  begin
    Result := TDictionary<TService, string>.Create();
    Result.Add(TService.Other, 'other');
    Result.Add(TService.PduSize, 'pdu-size');
    Result.Add(TService.Unsupported, 'service-unsupported');
  end;

  class function TTranslatorStandardTags.GetDefinition(): TDictionary<TDefinition, String>;
  begin
    Result := TDictionary<TDefinition, string>.Create();
    Result.Add(TDefinition.ObjectAttributeInconsistent, 'object-attribute-inconsistent');
    Result.Add(TDefinition.ObjectClassInconsistent, 'object-class-inconsistent');
    Result.Add(TDefinition.ObjectUndefined, 'object-undefined');
    Result.Add(TDefinition.Other, 'other');
  end;

  class function TTranslatorStandardTags.GetAccess(): TDictionary<TAccess, String>;
  begin
    Result := TDictionary<TAccess, string>.Create();
    Result.Add(TAccess.HardwareFault, 'hardware-fault');
    Result.Add(TAccess.ObjectAccessInvalid, 'object-access-violated');
    Result.Add(TAccess.ObjectUnavailable, 'object-unavailable');
    Result.Add(TAccess.Other, 'other');
    Result.Add(TAccess.ScopeOfAccessViolated, 'scope-of-access-violated');
  end;

  class function TTranslatorStandardTags.GetInitiate(): TDictionary<TInitiate, String>;
  begin
    Result := TDictionary<TInitiate, string>.Create();
    Result.Add(TInitiate.DlmsVersionTooLow, 'dlms-version-too-low');
    Result.Add(TInitiate.IncompatibleConformance, 'incompatible-conformance');
    Result.Add(TInitiate.Other, 'other');
    Result.Add(TInitiate.PduSizeTooShort, 'pdu-size-too-short');
    Result.Add(TInitiate.RefusedByTheVDEHandler, 'refused-by-the-VDE-Handler');
  end;

  class function TTranslatorStandardTags.GetLoadDataSet(): TDictionary<TLoadDataSet, String>;
  begin
    Result := TDictionary<TLoadDataSet, string>.Create();
    Result.Add(TLoadDataSet.DatasetNotReady, 'data-set-not-ready');
    Result.Add(TLoadDataSet.DatasetSizeTooLarge, 'dataset-size-too-large');
    Result.Add(TLoadDataSet.InterpretationFailure, 'interpretation-failure');
    Result.Add(TLoadDataSet.NotAwaitedSegment, 'not-awaited-segment');
    Result.Add(TLoadDataSet.NotLoadable, 'not-loadable');
    Result.Add(TLoadDataSet.Other, 'other');
    Result.Add(TLoadDataSet.PrimitiveOutOfSequence, 'primitive-out-of-sequence');
    Result.Add(TLoadDataSet.StorageFailure, 'storage-failure');
  end;

  class function TTranslatorStandardTags.GetTask(): TDictionary<TTask, string>;
  begin
    Result := TDictionary<TTask, string>.Create();
    Result.Add(TTask.NoRemoteControl, 'no-remote-control');
    Result.Add(TTask.Other, 'other');
    Result.Add(TTask.TiRunning, 'ti-running');
    Result.Add(TTask.TiStopped, 'ti-stopped');
    Result.Add(TTask.TiUnusable, 'ti-unusable');
  end;

  class function TTranslatorStandardTags.GetServiceErrorValue(error: TServiceError; value : Integer): string;
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
      TServiceError.OtherError: Result := inttostr(value);
      else Result := '';
    end;
  end;

class function TTranslatorStandardTags.ServiceErrorToString(error: TServiceError): string;
begin
   Result := GetServiceErrors()[error];
end;

class function TTranslatorStandardTags.GetServiceError(error: string): TServiceError;
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

class function TTranslatorStandardTags.ValueOfApplicationReference(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfHardwareResource(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfVdeStateError(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfService(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfDefinition(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfAccess(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfInitiate(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfLoadDataSet(value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfTask(value: string): WORD;
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

class function TTranslatorStandardTags.GetError(serviceError: TServiceError; value: string): WORD;
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

class function TTranslatorStandardTags.ValueOfConformance(value: string): TConformance;
begin
  if string.Compare('access', value) = 0 Then
    Result := TConformance.cfAccess
  else if string.Compare('action', value) = 0 Then
    Result := TConformance.cfAction
  else if string.Compare('attribute0-supported-with-get', value) = 0 Then
    Result := TConformance.cfAttribute0SupportedWithGet
  else if string.Compare('attribute0-supported-with-set', value) = 0 Then
    Result := TConformance.cfAttribute0SupportedWithSet
  else if string.Compare('block-transfer-with-action', value) = 0 Then
    Result := TConformance.cfBlockTransferWithAction
  else if string.Compare('block-transfer-with-get-or-read', value) = 0 Then
    Result := TConformance.cfBlockTransferWithGetOrRead
  else if string.Compare('block-transfer-with-set-or-write', value) = 0 Then
    Result := TConformance.cfBlockTransferWithSetOrWrite
  else if string.Compare('data-notification', value) = 0 Then
    Result := TConformance.cfDataNotification
  else if string.Compare('event-notification', value) = 0 Then
    Result := TConformance.cfEventNotification
  else if string.Compare('general-block-transfer', value) = 0 Then
    Result := TConformance.cfGeneralBlockTransfer
  else if string.Compare('general-protection', value) = 0 Then
    Result := TConformance.cfGeneralProtection
  else if string.Compare('get', value) = 0 Then
    Result := TConformance.cfGet
  else if string.Compare('information-report', value) = 0 Then
    Result := TConformance.cfInformationReport
  else if string.Compare('multiple-references', value) = 0 Then
    Result := TConformance.cfMultipleReferences
  else if string.Compare('parameterized-access', value) = 0 Then
    Result := TConformance.cfParameterizedAccess
  else if string.Compare('priority-mgmt-supported', value) = 0 Then
    Result := TConformance.cfPriorityMgmtSupported
  else if string.Compare('read', value) = 0 Then
    Result := TConformance.cfRead
  else if string.Compare('reserved-seven', value) = 0 Then
    Result := TConformance.cfReservedSeven
  else if string.Compare('reserved-six', value) = 0 Then
    Result := TConformance.cfReservedSix
  else if string.Compare('reserved-zero', value) = 0 Then
    Result := TConformance.cfReservedZero
  else if string.Compare('selective-access', value) = 0 Then
    Result := TConformance.cfSelectiveAccess
  else if string.Compare('set', value) = 0 Then
    Result := TConformance.cfSet
  else if string.Compare('unconfirmed-write', value) = 0 Then
    Result := TConformance.cfUnconfirmedWrite
  else if string.Compare('write', value) = 0 Then
    Result := TConformance.cfWrite
  else
    raise EArgumentException.Create('Conformance1 is invalid. ' + value);
end;

class function TTranslatorStandardTags.ConformanceToString(value: TConformance): string;
begin
  case value of
  TConformance.cfReservedZero:
    Result := 'reserved-zero';
  TConformance.cfGeneralProtection:
    Result := 'general-protection';
  TConformance.cfGeneralBlockTransfer:
    Result := 'general-block-transfer';
  TConformance.cfRead:
    Result := 'read';
  TConformance.cfWrite:
    Result := 'write';
  TConformance.cfUnconfirmedWrite:
    Result := 'unconfirmed-write';
  TConformance.cfReservedSix:
    Result := 'reserved-six';
  TConformance.cfReservedSeven:
    Result := 'reserved-seven';
  TConformance.cfAttribute0SupportedWithSet:
    Result := 'attribute0-supported-with-set';
  TConformance.cfPriorityMgmtSupported:
    Result := 'priority-mgmt-supported';
  TConformance.cfAttribute0SupportedWithGet:
    Result := 'attribute0-supported-with-get';
  TConformance.cfBlockTransferWithGetOrRead:
    Result := 'block-transfer-with-get-or-read';
  TConformance.cfBlockTransferWithSetOrWrite:
    Result := 'block-transfer-with-set-or-write';
  TConformance.cfBlockTransferWithAction:
    Result := 'block-transfer-with.action';
  TConformance.cfMultipleReferences:
    Result := 'multiple-references';
  TConformance.cfInformationReport:
    Result := 'information-report';
  TConformance.cfDataNotification:
    Result := 'data-notification';
  TConformance.cfAccess:
    Result := 'access';
  TConformance.cfParameterizedAccess:
    Result := 'parameterized-access';
  TConformance.cfGet:
    Result := 'get';
  TConformance.cfSet:
    Result := 'set';
  TConformance.cfSelectiveAccess:
    Result := 'selective-access';
  TConformance.cfEventNotification:
    Result := 'event-notification';
  TConformance.cfAction:
    Result := 'action';
  TConformance.cfNone:
    Result := 'none';
  else
    raise EArgumentException.Create('Invalid Conformance');
  end;
end;

class function TTranslatorStandardTags.ReleaseResponseReasonToString(value: TReleaseResponseReason): string;
begin
  case value of
  ReleaseResponseReason.Normal: Result := 'Normal';
  ReleaseResponseReason.NotFinished: Result := 'not-finished';
  ReleaseResponseReason.UserDefined: Result := 'user-defined';
  else raise EArgumentException.Create('ReleaseResponseReason is invalid.');
  end;
end;

class function TTranslatorStandardTags.ValueOfReleaseResponseReason(value: string): TReleaseResponseReason;
begin
  if string.Compare(value, 'normal', true) = 0 Then
    Result := ReleaseResponseReason.Normal
  else if string.Compare(value, 'not-finished') = 0 Then
    Result := ReleaseResponseReason.NotFinished
  else if string.Compare(value, 'user-defined') = 0 Then
    Result := ReleaseResponseReason.UserDefined
  else
    raise EArgumentException.Create('ReleaseResponseReason is invalid. ' + value);
end;

class function TTranslatorStandardTags.ReleaseRequestReasonToString(value: TReleaseRequestReason): string;
begin
  case value of
  ReleaseRequestReason.Normal: Result := 'normal';
  ReleaseRequestReason.Urgent: Result := 'urgent';
  ReleaseRequestReason.UserDefined: Result := 'user-defined';
  else raise EArgumentException.Create('ReleaseRequestReason is invalid.');
  end;
end;

class function TTranslatorStandardTags.ValueOfReleaseRequestReason(value: string): TReleaseRequestReason;
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
end.

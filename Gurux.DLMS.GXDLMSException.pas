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

unit Gurux.DLMS.GXDLMSException;

interface
uses SysUtils, Gurux.DLMS.AssociationResult, Gurux.DLMS.SourceDiagnostic,
Gurux.DLMS.ServiceError, Gurux.DLMS.StateError, Gurux.DLMS.ExceptionServiceError,
GXCommon;

type
TGXDLMSException = class(Exception)
  FErrorCode : Integer;
  constructor Create(ErrorCode: Integer);overload;
  constructor Create(error : String); overload;
  constructor Create(StateError : TStateError; ServiceError: TExceptionServiceError);overload;
  constructor Create(result : TAssociationResult; diagnostic : TSourceDiagnostic);overload;

  class function GetServiceError(ErrorCode : TExceptionServiceError) : String;static;
  class function GetStateError(ErrorCode : TStateError) : String;static;
  class function GetDescription(ErrorCode : Integer) : String; static;
  class function GetResult(AResult : TAssociationResult) : String; static;
  class function GetDiagnostic(diagnostic : TSourceDiagnostic) : String; static;

  property ErrorCode : Integer read FErrorCode;
end;

implementation

constructor TGXDLMSException.Create(ErrorCode: Integer);
begin
  FErrorCode := ErrorCode;
  inherited Create(GetDescription(ErrorCode));
end;

constructor TGXDLMSException.Create(StateError : TStateError; ServiceError: TExceptionServiceError);
begin
  inherited Create(GetStateError(StateError) + ' ' + GetServiceError(ServiceError));
end;

// Constructor for AARE error.
constructor TGXDLMSException.Create(result : TAssociationResult; diagnostic : TSourceDiagnostic);
begin
  inherited Create('Connection is ' + GetResult(result) + sLineBreak + GetDiagnostic(diagnostic));
end;

constructor TGXDLMSException.Create(error : String);
begin
  inherited Create(error);
end;

class function TGXDLMSException.GetServiceError(ErrorCode : TExceptionServiceError) : String;
begin
 case ErrorCode of
  OperationNotPossible : Result:= 'Operation not possible';
  ServiceNotSupported : Result:= 'Service not supported';
  OtherReason : Result:= 'Other reason';
  end;
end;

class function TGXDLMSException.GetStateError(ErrorCode : TStateError) : String;
begin
  case ErrorCode of
  ServiceNotAllowed : Result:= 'Service not allowed';
  ServiceUnknown : Result:= 'Service unknown';
  end;
end;

class function TGXDLMSException.GetDescription(ErrorCode : Integer) : String;
begin
  Result := TGXCommon.GetDescription(ErrorCode);
end;

class function TGXDLMSException.GetResult(AResult : TAssociationResult) : String;
var
str : String;
begin
  if AResult = TAssociationResult.PermanentRejected then
    str := 'Permanently rejected'
  else if AResult = TAssociationResult.TransientRejected then
    str := 'Transient rejected'
  else
    Exception.RaiseOuterException(Exception.Create('Invalid AssociationResult value'));

  Result := str;
end;

class function TGXDLMSException.GetDiagnostic(diagnostic : TSourceDiagnostic) : String;
begin
  case diagnostic of
    TSourceDiagnostic.NoReasonGiven : Result := 'No reason is given.';
    TSourceDiagnostic.ApplicationContextNameNotSupported : Result := 'The application context name is not supported.';
    TSourceDiagnostic.AuthenticationMechanismNameNotRecognised : Result := 'The authentication mechanism name is not recognized.';
    TSourceDiagnostic.AuthenticationMechanismNameReguired : Result := 'Authentication mechanism name is required.';
    TSourceDiagnostic.AuthenticationFailure : Result := 'Authentication failure.';
    TSourceDiagnostic.AuthenticationRequired : Result := 'Authentication is required.';
  end;
end;

end.

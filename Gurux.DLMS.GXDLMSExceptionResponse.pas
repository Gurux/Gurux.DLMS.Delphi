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

unit Gurux.DLMS.GXDLMSExceptionResponse;

interface
uses SysUtils,
Rtti,
Gurux.DLMS.AssociationResult,
Gurux.DLMS.SourceDiagnostic,
Gurux.DLMS.ServiceError,
Gurux.DLMS.StateError,
GXCommon,
Gurux.DLMS.Enums.ExceptionStateError,
Gurux.DLMS.Enums.ExceptionServiceError;

type
TGXDLMSExceptionResponse = class(Exception)
  FExceptionStateError : TExceptionStateError;
  FExceptionServiceError : TExceptionServiceError;
  FValue : TValue;
  class function GetServiceError(ErrorCode : TExceptionServiceError; value: TValue) : String;static;
  class function GetStateError(ErrorCode : TExceptionStateError) : String;static;

public
  constructor Create(error: TExceptionStateError; tp: TExceptionServiceError; value: TValue);
end;

implementation

constructor TGXDLMSExceptionResponse.Create(error: TExceptionStateError; tp: TExceptionServiceError; value: TValue);
begin
  inherited Create(GetStateError(error) + ' ' + GetServiceError(tp, value));
  FExceptionStateError := error;
  FExceptionServiceError := tp;
  FValue := value;
end;

class function TGXDLMSExceptionResponse.GetServiceError(ErrorCode : TExceptionServiceError; value: TValue) : String;
begin
 case ErrorCode of
  OperationNotPossible : Result:= 'Operation not possible';
  ServiceNotSupported : Result:= 'Service not supported';
  PduTooLong : Result:= 'PDU is too long';
  DecipheringError : Result:= 'Deciphering failed';
  InvocationCounterError : Result:= 'Invocation counter is invalid. Expected value is ' + value.ToString();
  end;
end;

class function TGXDLMSExceptionResponse.GetStateError(ErrorCode : TExceptionStateError) : String;
begin
  case ErrorCode of
  ServiceNotAllowed : Result:= 'Service not allowed';
  ServiceUnknown : Result:= 'Service unknown';
  end;
end;
end.


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

unit Gurux.DLMS.GXDLMSConfirmedServiceError;

interface
uses SysUtils, TypInfo, Gurux.DLMS.ConfirmedServiceError, Gurux.DLMS.ServiceError,
Gurux.DLMS.ApplicationReference, Gurux.DLMS.HardwareResource,
Gurux.DLMS.VdeStateError, Gurux.DLMS.Service, Gurux.DLMS.Definition,
Gurux.DLMS.Access, Gurux.DLMS.Initiate, Gurux.DLMS.LoadDataSet, Gurux.DLMS.Task;

type
//DLMS specific exception class that has error description available from GetDescription method.
  TGXDLMSConfirmedServiceError = class(Exception)
  FConfirmedServiceError: TConfirmedServiceError ;
  FServiceError: TServiceError;
  FServiceErrorValue: Byte;

  public
  //Constructor for Confirmed ServiceError.
  Constructor Create(service: TConfirmedServiceError; t: TServiceError; value: Byte);

  property ConfirmedServiceError: TConfirmedServiceError read FConfirmedServiceError;
  property ServiceError: TServiceError read FServiceError;
  property ServiceErrorValue: Byte read FServiceErrorValue;

  function GetConfirmedServiceError(stateError: TConfirmedServiceError): String;
  function GetServiceError(error: TServiceError): String;
  function GetServiceErrorValue(error: TServiceError; value: Byte): String;
end;

implementation

Constructor TGXDLMSConfirmedServiceError.Create(service: TConfirmedServiceError; t: TServiceError; value: Byte);
begin
  inherited Create('ServiceError ' + GetConfirmedServiceError(service)
          + ' exception. ' + GetServiceError(t) + ' '
          + GetServiceErrorValue(t, value));
  FConfirmedServiceError := service;
  FServiceError := t;
  FServiceErrorValue := value;
end;

function TGXDLMSConfirmedServiceError.GetConfirmedServiceError(stateError: TConfirmedServiceError): String;
begin
  case stateError of
  TConfirmedServiceError.InitiateError:
    Result := 'Initiate Error';
  TConfirmedServiceError.Read:
    Result := 'Read';
  TConfirmedServiceError.Write:
    Result := 'Write';
  else
    Result := '';
  end;
end;

function TGXDLMSConfirmedServiceError.GetServiceError(error: TServiceError): String;
begin
  case error of
  TServiceError.ApplicationReference:
    Result := 'Application reference';
  TServiceError.HardwareResource:
    Result := 'Hardware resource';
  TServiceError.VdeStateError:
    Result := 'Vde state error';
  TServiceError.Service:
    Result := 'Service';
  TServiceError.Definition:
    Result := 'Definition';
  TServiceError.Access:
    Result := 'Access';
  TServiceError.Initiate:
    Result := 'Initiate';
  TServiceError.LoadDataSet:
    Result := 'Load dataset';
  TServiceError.Task:
    Result := 'Task';
  TServiceError.OtherError:
    Result := 'Other Error';
  else
    Result := '';
  end;
end;

function TGXDLMSConfirmedServiceError.GetServiceErrorValue(error: TServiceError; value: Byte): String;
begin
  case error of
  TServiceError.ApplicationReference:
    Result := TypInfo.GetEnumName(TypeInfo(TApplicationReference), value);
  TServiceError.HardwareResource:
    Result := TypInfo.GetEnumName(TypeInfo(THardwareResource), value);
  TServiceError.VdeStateError:
    Result := TypInfo.GetEnumName(TypeInfo(TVdeStateError), value);
  TServiceError.Service:
    Result := TypInfo.GetEnumName(TypeInfo(TService), value);
  TServiceError.Definition:
    Result := TypInfo.GetEnumName(TypeInfo(TDefinition), value);
  TServiceError.Access:
    Result := TypInfo.GetEnumName(TypeInfo(TAccess), value);
  TServiceError.Initiate:
    Result := TypInfo.GetEnumName(TypeInfo(TInitiate), value);
  TServiceError.LoadDataSet:
    Result := TypInfo.GetEnumName(TypeInfo(TLoadDataSet), value);
  TServiceError.Task:
    Result := TypInfo.GetEnumName(TypeInfo(TTask), value);
  TServiceError.OtherError:
    Result := IntToStr(value);
  else
    Result := '';
  end;
end;

end.

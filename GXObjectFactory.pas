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

unit GXObjectFactory;

interface

uses SysUtils, Gurux.DLMS.ObjectType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.Objects.GXDLMSData, Gurux.DLMS.Objects.GXDLMSRegister,
Gurux.DLMS.Objects.GXDLMSClock, Gurux.DLMS.Objects.GXDLMSRegisterMonitor,
Gurux.DLMS.Objects.GXDLMSActivityCalendar,
Gurux.DLMS.Objects.GXDLMSHdlcSetup,
Gurux.DLMS.Objects.GXDLMSIECOpticalPortSetup,
Gurux.DLMS.Objects.GXDLMSSapAssignment,
Gurux.DLMS.Objects.GXDLMSSpecialDaysTable,
Gurux.DLMS.Objects.GXDLMSExtendedRegister,
Gurux.DLMS.Objects.GXDLMSActionSchedule,
Gurux.DLMS.Objects.GXDLMSDemandRegister,
Gurux.DLMS.Objects.GXDLMSIp4Setup,
Gurux.DLMS.Objects.GXDLMSPppSetup,
Gurux.DLMS.Objects.GXDLMSGprsSetup,
Gurux.DLMS.Objects.GXDLMSGSMDiagnostic,
Gurux.DLMS.Objects.GXDLMSTcpUdpSetup,
Gurux.DLMS.Objects.GXDLMSScriptTable,
Gurux.DLMS.Objects.GXDLMSAutoAnswer,
Gurux.DLMS.Objects.GXDLMSAutoConnect,
Gurux.DLMS.Objects.GXDLMSModemConfiguration,
Gurux.DLMS.Objects.GXDLMSMacAddressSetup,
Gurux.DLMS.Objects.GXDLMSImageTransfer,
Gurux.DLMS.Objects.GXDLMSLimiter,
Gurux.DLMS.Objects.GXDLMSMBusSlavePortSetup,
Gurux.DLMS.Objects.GXDLMSMBusClient,
Gurux.DLMS.Objects.GXDLMSDisconnectControl,
Gurux.DLMS.Objects.GXDLMSSecuritySetup,
Gurux.DLMS.Objects.GXDLMSRegisterActivation,
Gurux.DLMS.Objects.GXDLMSMBusMasterPortSetup,
Gurux.DLMS.Objects.GXDLMSPushSetup,
Gurux.DLMS.Objects.GXDLMSMessageHandler,
Gurux.DLMS.Objects.GXDLMSAssociationLogicalName,
Gurux.DLMS.Objects.GXDLMSAssociationShortName,
Gurux.DLMS.Objects.GXDLMSProfileGeneric,
Gurux.DLMS.Objects.GXDLMSAccount,
Gurux.DLMS.Objects.GXDLMSCredit,
Gurux.DLMS.Objects.GXDLMSCharge,
Gurux.DLMS.Objects.GXDLMSTokenGateway,
Gurux.DLMS.Objects.GXDLMSParameterMonitor,
Gurux.DLMS.Objects.GXDLMSCompactData;

type
TGXObjectFactory = class
    class function CreateObject(tp : TObjectType) : TGXDLMSObject;static;
end;
implementation

// Reserved for internal use.
class function TGXObjectFactory.CreateObject(tp : TObjectType) : TGXDLMSObject;
begin
  if tp = TObjectType.otActionSchedule Then
    Result := TGXDLMSActionSchedule.Create()
  else if tp = TObjectType.otActivityCalendar Then
    Result := TGXDLMSActivityCalendar.Create()
  else if tp = TObjectType.otAssociationLogicalName Then
    Result := TGXDLMSAssociationLogicalName.Create()
  else if tp = TObjectType.otAssociationShortName Then
    Result := TGXDLMSAssociationShortName.Create()
  else if tp = TObjectType.otAutoAnswer Then
      Result := TGXDLMSAutoAnswer.Create()
  else if tp = TObjectType.otAutoConnect Then
      Result := TGXDLMSAutoConnect.Create()
  else if tp = TObjectType.otClock Then
      Result := TGXDLMSClock.Create()
  else if tp = TObjectType.otData Then
      Result := TGXDLMSData.Create()
  else if tp = TObjectType.otDemandRegister Then
     Result := TGXDLMSDemandRegister.Create()
  else if tp = TObjectType.otSecuritySetup Then
     Result := TGXDLMSSecuritySetup.Create()
  else if tp = TObjectType.otMacAddressSetup Then
     Result := TGXDLMSMacAddressSetup.Create()
  else if tp = TObjectType.otEVENT Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otExtendedRegister Then
      Result := TGXDLMSExtendedRegister.Create()
  else if tp = TObjectType.otGprsSetup Then
      Result := TGXDLMSGprsSetup.Create()
  else if tp = TObjectType.otGSMDiagnostic Then
      Result := TGXDLMSGSMDiagnostic.Create()
  else if tp = TObjectType.otIecHdlcSetup Then
      Result := TGXDLMSHdlcSetup.Create()
  else if tp = TObjectType.otIecLocalPortSetup Then
      Result := TGXDLMSIECOpticalPortSetup.Create()
  else if tp = TObjectType.otIecTwistedPairSetup Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otIp4Setup Then
      Result := TGXDLMSIp4Setup.Create()
  else if tp = TObjectType.otMBusSlavePortSetup Then
      Result := TGXDLMSMBusSlavePortSetup.Create()
  else if tp = TObjectType.otImageTransfer Then
      Result := TGXDLMSImageTransfer.Create()
  else if tp = TObjectType.otDisconnectControl Then
      Result := TGXDLMSDisconnectControl.Create()
  else if tp = TObjectType.otLimiter Then
      Result := TGXDLMSLimiter.Create()
  else if tp = TObjectType.otMBusClient Then
      Result := TGXDLMSMBusClient.Create()
  else if tp = TObjectType.otModemConfiguration Then
      Result := TGXDLMSModemConfiguration.Create()
  else if tp = TObjectType.otPppSetup Then
      Result := TGXDLMSPppSetup.Create()
  else if tp = TObjectType.otProfileGeneric Then
    Result := TGXDLMSProfileGeneric.Create()
  else if tp = TObjectType.otRegister Then
      Result := TGXDLMSRegister.Create()
  else if tp = TObjectType.otRegisterActivation Then
      Result := TGXDLMSRegisterActivation.Create()
  else if tp = TObjectType.otRegisterMonitor Then
      Result := TGXDLMSRegisterMonitor.Create()
  else if tp = TObjectType.otRegisterTable Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otRemoteAnalogueControl Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otRemoteDigitalControl Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otSapAssignment Then
      Result := TGXDLMSSapAssignment.Create()
  else if tp = TObjectType.otSchedule Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otScriptTable Then
      Result := TGXDLMSScriptTable.Create()
  else if tp = TObjectType.otSmtpSetup Then
      Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otSpecialDaysTable Then
      Result := TGXDLMSSpecialDaysTable.Create()
  else if tp = TObjectType.otStatusMapping Then
    Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otTcpUdpSetup Then
    Result := TGXDLMSTcpUdpSetup.Create()
  else if tp = TObjectType.otTunnel Then
    Result := TGXDLMSObject.Create(tp)
  else if tp = TObjectType.otUtilityTables Then
    Result := TGXDLMSObject.Create(tp)
   else if tp = TObjectType.otMBusMasterPortSetup Then
     Result := TGXDLMSMBusMasterPortSetup.Create()
  else if tp = TObjectType.otPushSetup Then
    Result := TGXDLMSPushSetup.Create()
  else if tp = TObjectType.otMessageHandler Then
    Result := TGXDLMSMessageHandler.Create()
  else if tp = TObjectType.otAccount Then
    Result := TGXDLMSAccount.Create()
  else if tp = TObjectType.otCredit Then
    Result := TGXDLMSCredit.Create()
  else if tp = TObjectType.otCharge Then
     Result := TGXDLMSCharge.Create()
  else if tp = TObjectType.otTokenGateway Then
    Result := TGXDLMSTokenGateway.Create()
  else if tp = TObjectType.otParameterMonitor Then
    Result := TGXDLMSParameterMonitor.Create()
  else if tp = TObjectType.otCompactData Then
    Result := TGXDLMSCompactData.Create()
  else
    Result := TGXDLMSObject.Create(tp);
end;

end.

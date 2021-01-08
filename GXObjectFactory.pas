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

uses Gurux.DLMS.ObjectType, Gurux.DLMS.GXDLMSObject;

type
TGXObjectFactory = class
    class function CreateObject(tp : WORD) : TGXDLMSObject;static;
end;
implementation

uses SysUtils,
Gurux.DLMS.Objects.GXDLMSData, Gurux.DLMS.Objects.GXDLMSRegister,
Gurux.DLMS.Objects.GXDLMSClock, Gurux.DLMS.Objects.GXDLMSRegisterMonitor,
Gurux.DLMS.Objects.GXDLMSActivityCalendar,
Gurux.DLMS.Objects.GXDLMSHdlcSetup,
Gurux.DLMS.Objects.GXDLMSIECLocalPortSetup,
Gurux.DLMS.Objects.GXDLMSSapAssignment,
Gurux.DLMS.Objects.GXDLMSSpecialDaysTable,
Gurux.DLMS.Objects.GXDLMSExtendedRegister,
Gurux.DLMS.Objects.GXDLMSActionSchedule,
Gurux.DLMS.Objects.GXDLMSDemandRegister,
Gurux.DLMS.Objects.GXDLMSIp4Setup,
Gurux.DLMS.Objects.GXDLMSIp6Setup,
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
Gurux.DLMS.Objects.GXDLMSCompactData,
Gurux.DLMS.Objects.GXDLMSUtilityTables,
Gurux.DLMS.Objects.GXDLMSLlcSscsSetup,
Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcPhysicalLayerCounters,
Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacSetup,
Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacFunctionalParameters,
Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacCounters,
Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData,
Gurux.DLMS.Objects.GXDLMSPrimeNbOfdmPlcApplicationsIdentification,
Gurux.DLMS.Objects.GXDLMSSchedule,
Gurux.DLMS.Objects.GXDLMSIecTwistedPairSetup;

// Reserved for internal use.
class function TGXObjectFactory.CreateObject(tp : WORD) : TGXDLMSObject;
begin
  case TObjectType(tp) of
  TObjectType.otActionSchedule:
    Result := TGXDLMSActionSchedule.Create();
  TObjectType.otActivityCalendar:
    Result := TGXDLMSActivityCalendar.Create();
  TObjectType.otAssociationLogicalName:
    Result := TGXDLMSAssociationLogicalName.Create();
  TObjectType.otAssociationShortName :
    Result := TGXDLMSAssociationShortName.Create();
  TObjectType.otAutoAnswer :
      Result := TGXDLMSAutoAnswer.Create();
  TObjectType.otAutoConnect :
      Result := TGXDLMSAutoConnect.Create();
  TObjectType.otClock :
      Result := TGXDLMSClock.Create();
  TObjectType.otData :
      Result := TGXDLMSData.Create();
  TObjectType.otDemandRegister :
     Result := TGXDLMSDemandRegister.Create();
  TObjectType.otSecuritySetup :
     Result := TGXDLMSSecuritySetup.Create();
  TObjectType.otMacAddressSetup :
     Result := TGXDLMSMacAddressSetup.Create();
  TObjectType.otEVENT :
      Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otExtendedRegister :
      Result := TGXDLMSExtendedRegister.Create();
  TObjectType.otGprsSetup :
      Result := TGXDLMSGprsSetup.Create();
  TObjectType.otGSMDiagnostic :
      Result := TGXDLMSGSMDiagnostic.Create();
  TObjectType.otIecHdlcSetup :
      Result := TGXDLMSHdlcSetup.Create();
  TObjectType.otIecLocalPortSetup :
      Result := TGXDLMSIECLocalPortSetup.Create();
  TObjectType.otIecTwistedPairSetup :
    Result := TGXDLMSIecTwistedPairSetup.Create();
  TObjectType.otIp4Setup :
      Result := TGXDLMSIp4Setup.Create();
  TObjectType.otIp6Setup :
      Result := TGXDLMSIp6Setup.Create();
  TObjectType.otMBusSlavePortSetup :
      Result := TGXDLMSMBusSlavePortSetup.Create();
  TObjectType.otImageTransfer :
      Result := TGXDLMSImageTransfer.Create();
  TObjectType.otDisconnectControl :
      Result := TGXDLMSDisconnectControl.Create();
  TObjectType.otLimiter :
      Result := TGXDLMSLimiter.Create();
  TObjectType.otMBusClient :
      Result := TGXDLMSMBusClient.Create();
  TObjectType.otModemConfiguration :
      Result := TGXDLMSModemConfiguration.Create();
  TObjectType.otPppSetup :
      Result := TGXDLMSPppSetup.Create();
  TObjectType.otProfileGeneric:
    Result := TGXDLMSProfileGeneric.Create();
  TObjectType.otRegister :
      Result := TGXDLMSRegister.Create();
  TObjectType.otRegisterActivation :
      Result := TGXDLMSRegisterActivation.Create();
  TObjectType.otRegisterMonitor :
      Result := TGXDLMSRegisterMonitor.Create();
  TObjectType.otRegisterTable :
      Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otRemoteAnalogueControl :
      Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otRemoteDigitalControl :
      Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otSapAssignment :
      Result := TGXDLMSSapAssignment.Create();
  TObjectType.otSchedule :
      Result := TGXDLMSSchedule.Create();
  TObjectType.otScriptTable :
      Result := TGXDLMSScriptTable.Create();
  TObjectType.otSmtpSetup :
      Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otSpecialDaysTable :
      Result := TGXDLMSSpecialDaysTable.Create();
  TObjectType.otStatusMapping :
    Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otTcpUdpSetup:
    Result := TGXDLMSTcpUdpSetup.Create();
  TObjectType.otTunnel :
    Result := TGXDLMSObject.Create(TObjectType(tp));
  TObjectType.otUtilityTables :
    Result := TGXDLMSUtilityTables.Create();
   TObjectType.otMBusMasterPortSetup :
     Result := TGXDLMSMBusMasterPortSetup.Create();
  TObjectType.otPushSetup:
    Result := TGXDLMSPushSetup.Create();
  TObjectType.otMessageHandler :
    Result := TGXDLMSMessageHandler.Create();
  TObjectType.otAccount :
    Result := TGXDLMSAccount.Create();
  TObjectType.otCredit :
    Result := TGXDLMSCredit.Create();
  TObjectType.otCharge :
     Result := TGXDLMSCharge.Create();
  TObjectType.otTokenGateway :
    Result := TGXDLMSTokenGateway.Create();
  TObjectType.otParameterMonitor :
    Result := TGXDLMSParameterMonitor.Create();
  //TODO: TObjectType.otCompactData :
  //TODO:   Result := TGXDLMSCompactData.Create();
  TObjectType.otLlcSscsSetup:
    Result := TGXDLMSLlcSscsSetup.Create();
  TObjectType.otPrimeNbOfdmPlcPhysicalLayerCounters:
    Result := TGXDLMSPrimeNbOfdmPlcPhysicalLayerCounters.Create();
  TObjectType.otPrimeNbOfdmPlcMacSetup:
    Result := TGXDLMSPrimeNbOfdmPlcMacSetup.Create();
  TObjectType.otPrimeNbOfdmPlcMacFunctionalParameters:
    Result := TGXDLMSPrimeNbOfdmPlcMacFunctionalParameters.Create();
  TObjectType.otPrimeNbOfdmPlcMacCounters:
    Result := TGXDLMSPrimeNbOfdmPlcMacCounters.Create();
  TObjectType.otPrimeNbOfdmPlcMacNetworkAdministrationData:
    Result := TGXDLMSPrimeNbOfdmPlcMacNetworkAdministrationData.Create();
  TObjectType.otPrimeNbOfdmPlcApplicationsIdentification:
    Result := TGXDLMSPrimeNbOfdmPlcApplicationsIdentification.Create();
  else
    Result := TGXDLMSObject.Create(TObjectType(tp));
  end;
end;

end.

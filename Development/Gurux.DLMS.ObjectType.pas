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

unit Gurux.DLMS.ObjectType;

interface

type
// ObjectType enumerates the usable types of DLMS objects in GuruxDLMS.
TObjectType =
(
  //Default value, no object type is set.
  otNone = 0,

  //When communicating with a meter, the application may demand periodical
  //actions. If these actions are not linked to tariffication  = ActivityCalendar
  //or Schedule, use an object of type ActionSchedule  = 0x16.
  otActionSchedule = 22,

  //When handling tariffication structures, you can use an object of type
  //ActivityCalendar. It determines, when to activate specified scripts to
  //perform certain activities in the meter. The activities, simply said,
  //scheduled actions, are operations that are carried out on a specified day,
  //at a specified time.
  //ActivityCalendar can be used together with a more general object type,
  //Schedule, and they can even overlap. If multiple actions are timed to the
  //same moment, the actions determined in the Schedule are executed first,
  //and then the ones determined in the ActivityCalendar. If using object
  //type SpecialDaysTable, with ActivityCalendar, simultaneous actions determined
  //in SpecialDaysTable are executed over the ones determined in ActivityCalendar.
  //<p /><b>Note: </b>To make sure that tariffication is correct after a
  //power failure, only the latest missed action from ActivityCalendar is
  //executed, with a delay. In a case of power failure, if a Schedule object
  //coexists, the latest missed action from ActivityCalendar has to be executed
  //at the correct time, sequentially with actions determined in the Schedule.
  otActivityCalendar = 20,

  //AssociationLogicalName object type is used with meters that utilize
  //Logical Name associations within a COSEM.
  otAssociationLogicalName = 15,

  //AssociationShortName object type is used with meters that utilize Short
  //Name associations within a COSEM.
  otAssociationShortName = 12,

  //To determine auto answering settings  = for data transfer between device
  //and modem = s to answer incoming calls, use AutoAnswer object.
  otAutoAnswer = 28,

  //To determine auto connecting settings  = for data transfer from the meter
  //to defined destinations, use AutoConnect  = previously known as AutoDial
  //object.
  otAutoConnect = 29,

  //An object of type Clock is used to handle the information of a date  = day,
  //month and year and/or a time  = hundredths of a second, seconds, minutes
  //and hours.
  otClock = 8,

  //An object of type Data typically stores manufacturer specific information
  //of the meter, for example configuration data and logical name.
  otData = 1,

  //An object of type DemandRegister stores a value, information of the item,
  //which the value belongs to, the status of the item, and the time of the value.
  //DemandRegister object type enables both current, and last average, it
  //supports both block, and sliding demand calculation, and it also provides
  //resetting the value average, and periodic averages.
  otDemandRegister = 5,

  //MAC address of the physical device.
  //
  //The name and the use of this interface class has been changed from “Ethernet setup” to “MAC address setup” to
  //allow a more general use.
  otMacAddressSetup = 43,

  //GSM diagnostic settings.
  otGSMDiagnostic = 47,

  //To determine the IP 6 settings, use the Ip6Setup object.
  otIp6Setup = 48,

  // NTP Setup is used for time synchronisation.
  otNtpSetup = 100,

  // Configure a ZigBee PRO device with information necessary
  // to create or join the network.
  otZigBeeSasStartup = 101,

  // Configure the behaviour of a ZigBee PRO device on
  // joining or loss of connection to the network.
  otZigBeeSasJoin = 102,

  //Configure the fragmentation feature of ZigBee PRO transport layer.
  otZigBeeSasApsFragmentation = 103,

  otZigBeeNetworkControl = 104,

  otDataProtection = 30,

  otAccount = 111,

  otCredit = 112,

  otCharge = 113,

  otTokenGateway = 115,

  // ExtendedRegister stores a value, and understands the type of the value.
  // Refer to an object of this type by its logical name, using the OBIS
  // identification code.
  otExtendedRegister = 4,

  //To determine the GPRS settings, use GprsSetup object.
  otGprsSetup = 45,

  //To determine the HDLC  = High-level Data Link Control settings, use the
  //IecHdlcSetup object.
  otIecHdlcSetup = 23,

  //To determine the Local Port settings, use the IecLocalPortSetup object.
  otIecLocalPortSetup = 19,

  //To determine the Twisted Pair settings, use the IecTwistedPairSetup object.
  otIecTwistedPairSetup = 24,

  //To determine the IP 4 settings, use the Ip4Setup object.
  otIp4Setup = 42,

  //To determine the M-BUS settings, use the MbusSetup object.
  otMBusSlavePortSetup = 25,

  //To determine modem settings, use ModemConfiguration object.
  otModemConfiguration = 27,

  otPushSetup = 40,

  //To determine PPP  = Point-to-Point Protocol settings, use the PppSetup object.
  otPppSetup = 44,

  //ProfileGeneric determines a general way of gathering values from a profile.
  //The data is retrieved either by a period of time, or by an occuring event.
  //When gathering values from a profile, you need to understand the concept
  //of the profile buffer, in which the profile data is stored. The buffer may
  //be sorted by a register, or by a clock, within the profile, or the data
  //can be just piled in it, in order: last in, first out.
  //You can retrieve a part of the buffer, within a certain range of values,
  //or by a range of entry numbers. You can also determine objects, whose
  //values are to be retained. To determine, what to retrieve, and what to
  //retain, you need to assign the objects to the profile. You can use static
  //assignments, as all entries in a buffer are alike  = same size, same structure.
  //<p /><b>Note: </b>When you modify any assignment, the buffer of the
  //corresponding profile is cleared, and all other profiles, using the
  //modified one, will be cleared too. This is to make sure that their
  //entries stay alike by size and structure.
  otProfileGeneric = 7,

  //Register stores a value, and understands the type of the value. Refer to
  //an object of this type by its logical name, using the OBIS identification
  //code.
  otRegister = 3,

  //When handling tariffication structures, you can use RegisterActivation to
  //determine, what objects to enable, when activating a certain activation mask.
  //The objects, assigned to the register, but not determined in the mask,
  //are disabled.
  //<p /><b>Note: </b>If an object is not assigned to any register, it is,
  //by default, enabled.
  otRegisterActivation = 6,

  //RegisterMonitor allows you to determine scripts to execute, when a register
  //value crosses a specified threshold. To use RegisterMonitor, also ScriptTable
  //needs to be instantiated in the same logical device.
  otRegisterMonitor = 21,

  // Instances of the Disconnect control IC manage an internal or external disconnect unit
  // of the meter (e.g. electricity breaker, gas valve) in order to connect or disconnect
  // – partly or entirely – the premises of the consumer to / from the supply.
  otDisconnectControl = 70,

  otLimiter = 71,

  otMBusClient = 72,

  /// How the device manages incoming messages such as SMS, MMS, e-mail, etc.
  /// as well as the execution of dedicated actions based on the identification of the sender.
  /// The message service used is implicitly defined by the modem used.
  otMessageHandler = 60,

  otParameterMonitor = 65,

  // Defines the operational parameters for
  // communication using the mode Q interfaces.
  otWirelessModeQchannel = 73,

  // Defines the operational parameters for communication using the
  // EN 13757-2 interfaces if the device acts as an M-bus master.
  otMBusMasterPortSetup = 74,


  // Addresses that are provided by the base node during the opening of the
  // convergence layer.
  otLlcSscsSetup = 80,


  // Counters related to the physical layers exchanges.
  otPrimeNbOfdmPlcPhysicalLayerCounters = 81,


  // A necessary parameters to set up and manage the PRIME NB OFDM PLC MAC layer.
  otPrimeNbOfdmPlcMacSetup = 82,


  //Functional behaviour of MAC.
  otPrimeNbOfdmPlcMacFunctionalParameters = 83,

  // Statistical information on the operation of the MAC layer for management purposes.
  otPrimeNbOfdmPlcMacCounters = 84,

  //  Parameters related to the management of the devices connected to the network.
  otPrimeNbOfdmPlcMacNetworkAdministrationData = 85,

  // Identification information related to administration and maintenance of PRIME NB OFDM PLC devices.
  otPrimeNbOfdmPlcApplicationsIdentification = 86,

  //RegisterTable stores identical attributes of objects, in a selected
  //collection of objects. All the objects in the collection need to be of
  //the same type. Also, the value in value groups A to D and F in their
  //logical name  = OBIS identification code needs to be identical.
  //<p />Clause 5 determines the possible values in value group E, as a table,
  //where header = the common part, and each cell = a possible E value,
  //of the OBIS code.
  otRegisterTable = 61,

  //SapAssigment stores information of assignment of the logical devices to
  //their SAP  = Service Access Points.
  otSapAssignment = 17,

  // Instances of the Image transfer IC model the mechanism of
  // transferring binary files, called firmware Images to COSEM servers.
  otImageTransfer = 18,

  //To handle time and date driven actions, use Schedule, with an object of
  //type SpecialDaysTable.
  otSchedule = 10,

  //To trigger a set of actions with an execute method, use object type
  //ScriptTable. Each table entry  = script includes a unique identifier, and
  //a set of action specifications, which either execute a method, or modify
  //the object attributes, within the logical device. The script can be
  //triggered by other objects  = within the same logical device, or from the
  //outside.
  otScriptTable = 9,

  //To determine the SMTP protocol settings, use the SmtpSetup object.
  otSmtpSetup = 2,

  //With SpecialDaysTable you can determine dates to override a preset behaviour,
  //for specific days  = data item day_id. SpecialDaysTable works together with
  //objects of Schedule, or Activity Calendar.
  otSpecialDaysTable = 11,

  //StatusMapping object stores status words with mapping. Each bit in the
  //status word is mapped to position = s in referencing status table.
  otStatusMapping = 63,

  otSecuritySetup = 64,

  //To determine Internet TCP/UDP protocol settings, use the TcpUdpSetup object.
  otTcpUdpSetup = 41,

  //In an object of type UtilityTables each "Table"  = ANSI C12.19:1997 table data
  //is represented as an instance, and identified by its logical name.
  otUtilityTables = 26,

  otToken = 115,

  // S-FSK Phy MAC Setup
  otSFSKPhyMacSetUp = 50,

  // S-FSK Active initiator.
  otSFSKActiveInitiator = 51,

  // S-FSK MAC synchronization timeouts
  otSFSKMacSynchronizationTimeouts = 52,

  // S-FSK MAC Counters.
  otSFSKMacCounters = 53,

  // IEC 61334-4-32 LLC setup
  otIec61334_4_32LlcSetup = 55,

  // S-FSK Reporting system list.
  otSFSKReportingSystemList = 56,

  // Arbitrator.
  otArbitrator = 68,

  // G3-PLC MAC layer counters
  otG3PlcMacLayerCounters = 90,

  // G3-PLC MAC setup.
  otG3PlcMacSetup = 91,

  // G3-PLC 6LoWPAN.
  otG3Plc6LoWPan = 92,

  // Function control.
  otFunctionControl = 122,

  // Communication port protection.
  otCommunicationPortProtection = 124,

  // LTE monitoring.
  otLteMonitoring = 151,

  // CoAP setup.
  otCoAPSetup = 152,

  // CoAP diagnostic.
  otCoAPDiagnostic = 153,

  // G3-PLC Hybrid RF MAC layer counters.
  otG3PlcHybridRfMacLayerCounters = 160,

  // G3-PLC Hybrid RF MAC setup.
  otG3PlcHybridRfMacSetup = 161,

  // G3-PLC Hybrid 6LoWPAN adaptation layer setup.
  otG3PlcHybrid6LoWPANAdaptationLayerSetup = 162,

  otCompactData = 62,

  otInvalid = $FFFF
);
implementation

end.

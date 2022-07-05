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

unit Gurux.DLMS.GXDLMSServerNotifier;

interface
uses SysUtils,
Gurux.DLMS.ObjectType,
Gurux.DLMS.AccessMode,
Gurux.DLMS.MethodAccessMode,
Gurux.DLMS.Authentication,
Gurux.DLMS.SourceDiagnostic,
Gurux.DLMS.GXDLMSConnectionEventArgs,
Gurux.DLMS.GXDLMSLongTransaction,
Gurux.DLMS.GXDLMSObject;

type
  TGXDLMSServerNotifier = class abstract
  /// Find object.
    /// <param name="objectType">Object type. In Short Name referencing this is not used.</param>
    /// <param name="sn">Short Name. In Logical name referencing this is not used.</param>
    /// <param name="ln">Logical Name. In Short Name referencing this is not used.</param>
    /// <returns>Found object or null if object is not found.</returns>
    function FindObject(objectType: TObjectType; sn: Integer; ln: string): TGXDLMSObject;Virtual;Abstract;

    /// <summary>
    /// Check is data sent to this server.
    /// </summary>
    /// <param name="serverAddress">Server address.</param>
    /// <param name="clientAddress">Client address.</param>
    /// <returns>True, if data is sent to this server.</returns>
    function IsTarget(serverAddress: Integer; clientAddress: Integer): BOOLEAN;Virtual;Abstract;

    /// <summary>
    /// Get attribute access mode.
    /// </summary>
    /// <param name="arg">Value event argument.</param>
    /// <returns>Access mode.</returns>
    function GetAttributeAccess(arg: TValueEventArgs):TAccessMode;Virtual;Abstract;

    /// <summary>
    /// Get method access mode.
    /// </summary>
    /// <param name="arg">Value event argument.</param>
    /// <returns>Method access mode.</returns>
    function GetMethodAccess(arg: TValueEventArgs): TMethodAccessMode;Virtual;Abstract;

    /// <summary>
    /// Check whether the authentication and password are correct.
    /// </summary>
    /// <param name="authentication">Authentication level.</param>
    /// <param name="password">Password</param>
    /// <returns>Source diagnostic.</returns>
    function ValidateAuthentication(authentication: TAuthentication; password: TBytes): TSourceDiagnostic; Virtual;Abstract;

    /// <summary>
    /// Accepted connection is made for the server.
    /// </summary>
    /// <remarks>
    /// All initialization is done here.
    /// Example access level of the COSEM objects is good to update here.
    /// </remarks>
    /// <param name="connectionInfo">Connection information.</param>
    procedure Connected(connectionInfo: TGXDLMSConnectionEventArgs);Virtual;Abstract;

    /// <summary>
    /// Client has try to made invalid connection. Password is incorrect.
    /// </summary>
    /// <param name="connectionInfo">Connection information.</param>
    procedure  InvalidConnection(connectionInfo: TGXDLMSConnectionEventArgs); Virtual;Abstract;

    /// <summary>
    /// Server has close the connection. All clean up is made here.
    /// </summary>
    /// <param name="connectionInfo">Connection information.</param>
    procedure  Disconnected(connectionInfo: TGXDLMSConnectionEventArgs);Virtual;Abstract;

    /// <summary>
    /// Read selected item.
    /// </summary>
    /// <param name="args">Handled read requests.</param>
    procedure PreRead(args: TArray<TValueEventArgs>); Virtual;Abstract;

    /// <summary>
    /// Write selected item.
    /// </summary>
    /// <param name="args">Handled write requests.</param>
    procedure PreWrite(args: TArray<TValueEventArgs>);Virtual;Abstract;
    /// <summary>
    /// Action is occurred.
    /// </summary>
    /// <param name="args">Handled action requests.</param>
    procedure PreAction(args: TArray<TValueEventArgs>);Virtual;Abstract;

    /// <summary>
    /// Read selected item.
    /// </summary>
    /// <param name="args">Handled read requests.</param>
    procedure PostRead(args: TArray<TValueEventArgs>);Virtual;Abstract;

    /// <summary>
    /// Write selected item.
    /// </summary>
    /// <param name="args">Handled write requests.</param>
    procedure PostWrite(args: TArray<TValueEventArgs>);Virtual;Abstract;
    /// <summary>
    /// Action is occurred.
    /// </summary>
    /// <param name="args">Handled action requests.</param>
    procedure PostAction(args: TArray<TValueEventArgs>);Virtual;Abstract;

    function GetTransaction(): TGXDLMSLongTransaction;Virtual;Abstract;
    procedure SetTransaction(AValue: TGXDLMSLongTransaction);Virtual;Abstract;
end;

implementation

end.

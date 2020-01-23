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

unit Gurux.DLMS.Secure.GXDLMSSecureClient;

interface
uses SysUtils, Gurux.DLMS.InterfaceType, Gurux.DLMS.Authentication,
    Gurux.DLMS.GXCiphering, Gurux.DLMS.GXDLMSClient;

type

TGXDLMSSecureClient = class(TGXDLMSClient)
  private
    FCiphering: TGXCiphering;
    procedure SetCiphering(Ciphering: TGXCiphering);
  public
    // Ciphering settings.
    property Ciphering: TGXCiphering read FCiphering write SetCiphering;

    destructor Destroy; override;
    constructor Create; overload;
    constructor Create(
        //Is Logical or short name referencing used.
        UseLogicalNameReferencing : Boolean;
        //Client ID. Default is 0x10
				ClientAddress : Integer;
        //Server ID. Default is 1.
				ServerAddress : Integer;
				//Authentication type. Default is None
				Authentication : TAuthentication;
				//Password if authentication is used.
				Password : TBytes;
        //Interface type. Default is general.
				interfaceType : TInterfaceType);overload;

    constructor Create(
        //Is Logical or short name referencing used.
        UseLogicalNameReferencing : Boolean;
        //Client ID. Default is 0x10
				ClientAddress : Integer;
        //Server ID. Default is 1.
				ServerAddress : Integer;
				//Authentication type. Default is None
				Authentication : TAuthentication;
				//Password if authentication is used.
				Password : string;
        //Interface type. Default is general.
				interfaceType : TInterfaceType);overload;
end;

implementation

destructor TGXDLMSSecureClient.Destroy;
begin
  {
   FCiphering is destroyed by the destroying FSettings in the base class.
   inherited destory FSettings, FSettings destorys FCiphering.
  }
  inherited;
end;

procedure TGXDLMSSecureClient.SetCiphering(Ciphering: TGXCiphering);
begin
  FSettings.Cipher := nil;
  FCiphering.Free;

  FCiphering := Ciphering;
  FSettings.Cipher := FCiphering;
end;

constructor TGXDLMSSecureClient.Create;
begin
  inherited;
  { The inherited constructor does not create the FCiphering }
  FCiphering := TGXCiphering.Create(TEncoding.ASCII.GetBytes('ABCDEFGH'));
  FSettings.Cipher := FCiphering;
end;

constructor TGXDLMSSecureClient.Create(
    UseLogicalNameReferencing : Boolean;
    //Client ID. Default is 0x10
    ClientAddress : Integer;
    //Server ID. Default is 1.
    ServerAddress : Integer;
    //Authentication type. Default is None
    Authentication : TAuthentication;
    //Password if authentication is used.
    Password : string;
    //Interface type. Default is general.
    interfaceType : TInterfaceType);
begin
  inherited Create (UseLogicalNameReferencing, ClientAddress, ServerAddress, Authentication, Password, interfaceType) ;
  FCiphering := TGXCiphering.Create(TEncoding.ASCII.GetBytes('ABCDEFGH'));
  FSettings.Cipher := FCiphering;
end;

constructor TGXDLMSSecureClient.Create(
    UseLogicalNameReferencing: Boolean;
    //Client ID. Default is $10
    ClientAddress: Integer;
    //Server ID. Default is 1.
    ServerAddress: Integer;
    //Authentication type. Default is None
    Authentication : TAuthentication;
    //Password if authentication is used.
    Password: TBytes;
    //Interface type. Default is general.
    interfaceType : TInterfaceType);
begin
  inherited Create(UseLogicalNameReferencing, ClientAddress, ServerAddress, Authentication, Password, interfaceType);
  FCiphering := TGXCiphering.Create(TEncoding.ASCII.GetBytes('ABCDEFGH'));
  FSettings.Cipher := FCiphering;
end;

end.

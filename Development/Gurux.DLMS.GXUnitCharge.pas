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

unit Gurux.DLMS.GXUnitCharge;

interface
uses SysUtils, System.Generics.Collections, Gurux.DLMS.GXChargePerUnitScaling,
Gurux.DLMS.GXCommodity, Gurux.DLMS.GXChargeTable;

type
  //Used currency.
  TGXUnitCharge = class
   private
   {Charge per unit scaling.}
    FChargePerUnitScaling: TGXChargePerUnitScaling;

    {Commodity.}
    FCommodity: TGXCommodity;

    {Charge tables.}
    FChargeTables: TObjectList<TGXChargeTable>;


   public
  {
     Charge per unit scaling.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
     }
    property ChargePerUnitScaling: TGXChargePerUnitScaling read FChargePerUnitScaling;

    {
     Commodity.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
     }
    property Commodity: TGXCommodity read FCommodity;

    {
     Charge tables.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
     }
    property ChargeTables: TObjectList<TGXChargeTable> read FChargeTables;

    constructor Create; overload;
    destructor Destroy; override;
   end;
implementation

constructor TGXUnitCharge.Create;
begin
  FChargePerUnitScaling := TGXChargePerUnitScaling.Create();
  FCommodity := TGXCommodity.Create();
  FChargeTables := TObjectList<TGXChargeTable>.Create;
end;

destructor TGXUnitCharge.Destroy;
begin
  FreeAndNil(FChargePerUnitScaling);
  FreeAndNil(FCommodity);
  FreeAndNil(FChargeTables);
end;

end.

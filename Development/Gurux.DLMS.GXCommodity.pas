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

unit Gurux.DLMS.GXCommodity;

interface
uses Gurux.DLMS.GXDLMSObject;

type
  {
  Online help:
  http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
  }
  TGXCommodity = class
   private
   {
     Executed object.
     }
    FTarget: TGXDLMSObject;

    {
     Attribute index.
     }
   FIndex: Byte;

   public
    {
     Executed object.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
     }
    property Target: TGXDLMSObject read FTarget write FTarget;

    {
     Attribute index.
     Online help:
     http://www.gurux.fi/Gurux.DLMS.Objects.GXDLMSCharge
     }
   property Index: Byte read FIndex write FIndex;
   end;
implementation

end.

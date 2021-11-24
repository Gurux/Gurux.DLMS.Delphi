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

unit Gurux.DLMS.GXDLMSCaptureObject;

interface

uses Gurux.DLMS.GXDLMSObject;

type
  TGXDLMSCaptureObject = class
private
  //Target object.
  FTarget: TGXDLMSObject;
  //Attribute Index of DLMS object in the profile generic table.
  FAttributeIndex: Byte;
  // Data index of DLMS object in the profile generic table.
  FDataIndex: Byte;
  FFreeTargetOnDestroy: Boolean;
public
    //Attribute Index of DLMS object in the profile generic table.
    property Target: TGXDLMSObject read FTarget write FTarget;

    //Attribute Index of DLMS object in the profile generic table.
    property AttributeIndex: Byte read FAttributeIndex write FAttributeIndex;
    // Data index of DLMS object in the profile generic table.
    property DataIndex: Byte read FDataIndex write FDataIndex;
    constructor Create();overload;
    constructor Create(ATarget: TGXDLMSObject; AAttributeIndex: Byte; ADataIndex: Byte; AOwnsTarget: Boolean = False);overload;
    destructor Destroy; override;
end;

implementation

constructor TGXDLMSCaptureObject.Create();
begin
end;

constructor TGXDLMSCaptureObject.Create(ATarget: TGXDLMSObject; AAttributeIndex: Byte; ADataIndex: Byte; AOwnsTarget: Boolean = False);
begin
  FTarget := ATarget;
  FAttributeIndex := AAttributeIndex;
  FDataIndex := ADataIndex;
  FFreeTargetOnDestroy := AOwnsTarget;
end;

destructor TGXDLMSCaptureObject.Destroy;
begin
  if FFreeTargetOnDestroy then
    FTarget.Free;
  inherited;
end;

end.

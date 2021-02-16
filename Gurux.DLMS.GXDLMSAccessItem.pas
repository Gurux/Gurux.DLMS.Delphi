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

unit Gurux.DLMS.GXDLMSAccessItem;
interface
uses Rtti,
Gurux.DLMS.ErrorCode,
Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.AccessServiceCommandType;

type
  TGXDLMSAccessItem = class
  private
    //COSEM target object.
    FTarget: TGXDLMSObject;

    //Executed command type.
    FCommand: TAccessServiceCommandType;

    //Attribute index.
    FIndex: BYTE;

    //Reply error code.
    FError: TErrorCode;

    //Reply value.
    FValue: TValue;
  public
    // Returns COSEM target object.
    function GetTarget(): TGXDLMSObject;
    //Set COSEM target object.
    procedure SetTarget(value: TGXDLMSObject);
    //Returns Executed command type.
    function GetCommand() : TAccessServiceCommandType;
    //Returns Attribute index.
    function GetIndex(): BYTE;
    //Set Attribute index.
    procedure SetIndex(value: BYTE);

    //Returns Reply error code.
    function GetError(): TErrorCode;
    // Set reply error code.
    procedure SetError(AError: TErrorCode);
    //Returns Reply value.
    function GetValue(): TValue;
    //Set Reply value
    procedure SetValue(AValue: TValue);

    // Constructor.
    //
    // ACommandType: Command to execute.
    // ATargetObject: COSEM target object.
    // AAttributeIndex: Attribute index.
    constructor Create(
      ACommandType: TAccessServiceCommandType;
      ATargetObject: TGXDLMSObject;
      AAttributeIndex: Integer);

  end;

implementation
  function TGXDLMSAccessItem.GetTarget(): TGXDLMSObject;
  begin
    Result := FTarget;
  end;

  procedure TGXDLMSAccessItem.SetTarget(value: TGXDLMSObject);
  begin
    FTarget := value;
  end;

  function TGXDLMSAccessItem.GetCommand() : TAccessServiceCommandType;
  begin
    Result := FCommand;
  end;

  //Returns Attribute index.
  function TGXDLMSAccessItem.GetIndex(): BYTE;
  begin
    Result := FIndex;
  end;

  //Set Attribute index.
  procedure TGXDLMSAccessItem.SetIndex(value: BYTE);
  begin
    FIndex := value;
  end;

  constructor TGXDLMSAccessItem.Create(
      ACommandType: TAccessServiceCommandType;
      ATargetObject: TGXDLMSObject;
      AAttributeIndex: Integer);
  begin
    FCommand := ACommandType;
    FTarget := ATargetObject;
    FIndex := BYTE(AAttributeIndex);
  end;

  function TGXDLMSAccessItem.GetError(): TErrorCode;
  begin
    Result := FError;
  end;

  // Set reply error code.
  procedure TGXDLMSAccessItem.SetError(AError: TErrorCode);
  begin
    FError := AError;
  end;

  //Returns Reply value.
  function TGXDLMSAccessItem.GetValue(): TValue;
  begin
    Result := FValue;
  end;

  //Set Reply value
  procedure TGXDLMSAccessItem.SetValue(AValue: TValue);
  begin
      FValue := AValue;
  end;
end.

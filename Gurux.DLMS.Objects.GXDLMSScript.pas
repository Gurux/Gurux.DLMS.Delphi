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

unit Gurux.DLMS.Objects.GXDLMSScript;

interface

uses System.Generics.Collections, Gurux.DLMS.GXDLMSScriptAction, SysUtils;

type
  TGXDLMSScript = class
  private
    FID: Integer;
    FActions: TObjectList<TGXDLMSScriptAction>;
  public
  //Constructor.
  constructor Create();

  //Script identifier.
  property ID: Integer read FID write FID;
  //Script actions.
  property Actions: TObjectList<TGXDLMSScriptAction> read FActions Write FActions;

  destructor Destroy;override;

  end;

implementation

constructor TGXDLMSScript.Create();
begin
  FActions := TObjectList<TGXDLMSScriptAction>.Create();
end;

destructor TGXDLMSScript.Destroy;
begin
  inherited;
  FreeAndNil(FActions);
end;

end.

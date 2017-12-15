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

unit GXDataInfo;

interface
uses Gurux.DLMS.DataType;

type
//This class is used in DLMS data parsing.
TGXDataInfo = class
private
  // Last array index.
  FIndex : Integer;
  // Items count in array.
  FCount: Integer;
  // Object data type.
  FType: TDataType;
  // Is data parsed to the end.
  FCompleate: Boolean;

public
  // Last array index.
  property Index: Integer read FIndex write FIndex;
  // Items count in array.
  property Count: Integer read FCount write FCount;
  // Object data type.
  property &Type: TDataType read FType write FType;
  property Complete: Boolean read FCompleate write FCompleate;

  procedure Clear;
  //Constructor.
  Constructor Create;
  end;

implementation
  Constructor TGXDataInfo.Create;
  begin
    FIndex := 0;
    FCount := 0;
    FType := TDataType.dtNone;
    FCompleate := False;
  end;

  procedure TGXDataInfo.Clear;
  begin
    FIndex := 0;
    FCount := 0;
    FType := TDataType.dtNONE;
    FCompleate := true;
  end;
end.

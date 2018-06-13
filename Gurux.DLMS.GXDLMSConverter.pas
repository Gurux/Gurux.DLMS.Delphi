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

unit Gurux.DLMS.GXDLMSConverter;

interface

uses System.TypInfo, GXCommon, System.Generics.Collections, System.Rtti, SysUtils, Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDate, Gurux.DLMS.GXTime, Gurux.DLMS.DataType,
Gurux.DLMS.GXStandardObisCodeCollection, Gurux.DLMS.ObjectType, Gurux.DLMS.GXStandardObisCode,
Gurux.DLMS.GXDLMSObject;

type
  //DLMS Converter is used to get string value for enumeration types.
  TGXDLMSConverter = class

  // Collection of standard OBIS codes.
  codes: TGXStandardObisCodeCollection;

  // Convert DLMS data type to pascal data type.
  class function GetDataType(ADataType : TDataType): PTypeInfo;static;
  class function GetDLMSDataType(AValue : TValue): TDataType ;static;

  // Read standard OBIS code information from the file.
  // codes: Collection of standard OBIS codes.
  procedure ReadStandardObisInfo(codes: TGXStandardObisCodeCollection);
  function GetCode(value: String): String;
  // Update standard OBIS codes description and type if defined.
  // target:  COSEM object.
  procedure UpdateOBISCodeInformation(target: TGXDLMSObject); overload;
   // Update standard OBIS codes descriptions and type if defined.
  // targets: Collection of COSEM objects to update.
  procedure UpdateOBISCodeInformation(targets: TGXDLMSObjectCollection);overload;

  procedure UpdateOBISCodeInfo(codes: TGXStandardObisCodeCollection; it: TGXDLMSObject);

public
  destructor Destroy; override;
  constructor Create;
  // Get OBIS code description.
  // logicalName: Logical name (OBIS code).
  // return: Array of descriptions that match given OBIS code.
  function GetDescription(logicalName: String): TList<String>;overload;
  // Get OBIS code description.
  // logicalName: Logical name (OBIS code).
  // description: Description filter.
  // return: Array of descriptions that match given OBIS code.
  function GetDescription(logicalName: String; description: String): TList<String>;overload;

  // Get OBIS code description.
  // logicalName: Logical name (OBIS code).
  // type: Object type.
  // return: Array of descriptions that match given OBIS code.
  function GetDescription(logicalName: String; ot: TObjectType): TList<String>;overload;

  // Get OBIS code description.
  // logicalName: Logical name (OBIS code).
  // type: Object type.
  // description: Description filter.
  // return: Array of descriptions that match given OBIS code.
  function GetDescription(logicalName: String; ot: TObjectType; description: String): TList<String>;overload;
end;

implementation
constructor TGXDLMSConverter.Create;
begin
  codes := TGXStandardObisCodeCollection.Create();
end;

destructor TGXDLMSConverter.Destroy;
begin
  inherited;
  FreeAndNil(codes);
end;

// Get OBIS code description.
// logicalName: Logical name (OBIS code).
// return: Array of descriptions that match given OBIS code.
function TGXDLMSConverter.GetDescription(logicalName: String): TList<String>;
begin
  Result := GetDescription(logicalName, TObjectType.otNone);
end;

// Get OBIS code description.
// logicalName: Logical name (OBIS code).
// description: Description filter.
// return: Array of descriptions that match given OBIS code.
function TGXDLMSConverter.GetDescription(logicalName: String; description: String): TList<String>;
begin
  Result := GetDescription(logicalName, TObjectType.otNone, description);
end;

// Get OBIS code description.
// logicalName: Logical name (OBIS code).
// type: Object type.
// return: Array of descriptions that match given OBIS code.
function TGXDLMSConverter.GetDescription(logicalName: String; ot: TObjectType): TList<String>;
begin
  Result := GetDescription(logicalName, ot, '');
end;

// Get OBIS code description.
// logicalName: Logical name (OBIS code).
// type: Object type.
// description: Description filter.
// return: Array of descriptions that match given OBIS code.
function TGXDLMSConverter.GetDescription(logicalName: String; ot: TObjectType; description: String): TList<String>;
var
  all: Boolean;
  it: TGXStandardObisCode;
  tmp: TList<TGXStandardObisCode>;
begin
  if codes.Count = 0 Then
    ReadStandardObisInfo(codes);

  Result := TList<String>.Create;
  try

    all := Length(logicalName) = 0;

    tmp := codes.Find(logicalName, ot);
    try
      for it in tmp do
      begin
          if Not description.IsEmpty and Not it.Description.ToLower().Contains(description.ToLower()) Then
            continue;
          if all Then
          begin
              Result.Add('A=' + it.OBIS[0] + ', B=' + it.OBIS[1]
                      + ', C=' + it.OBIS[2] + ', D=' + it.OBIS[3]
                      + ', E=' + it.OBIS[4] + ', F=' + it.OBIS[5]
                      + '\r\n' + it.Description);
          end
          else
            Result.Add(it.Description);
      end;
    finally
      FreeAndNil(tmp);
    end;

  except
    Result.Free;
    raise;
  end;

end;

function TGXDLMSConverter.GetCode(value: String): String;
var
  index: Integer;
begin
  index := value.IndexOfAny(['.', '-', ',']);
  if index <> -1 Then
    Result := value.Substring(0, index)
  else
    Result := value;
end;

procedure TGXDLMSConverter.UpdateOBISCodeInformation(target: TGXDLMSObject);
begin
  if codes.Count = 0 Then
    ReadStandardObisInfo(codes);

  UpdateOBISCodeInfo(codes, target);
end;


// Update standard OBIS codes descriptions and type if defined.
// targets: Collection of COSEM objects to update.
procedure TGXDLMSConverter.UpdateOBISCodeInformation(targets: TGXDLMSObjectCollection);
var
  it: TGXDLMSObject;
begin
  if codes.Count = 0 Then
    ReadStandardObisInfo(codes);

  for it in targets do
   UpdateOBISCodeInfo(codes, it);
end;

procedure TGXDLMSConverter.ReadStandardObisInfo(codes: TGXStandardObisCodeCollection);
var
  rows, items, obis: TArray<string>;
  it: String;
  code: TGXStandardObisCode;
begin
  rows := TGXCommon.GetResource('OBIS_CODES').Split([sLineBreak], TStringSplitOptions.ExcludeEmpty);
  for it in rows do
  begin
    items := string(it).Split([';']);
    obis := items[0].Split(['.']);
    code := TGXStandardObisCode.Create(obis, items[3] + '; ' + items[4] + '; ' +
        items[5] + '; ' + items[6] + '; ' + items[7], items[1], items[2]);
    codes.Add(code);
  end;
end;

procedure TGXDLMSConverter.UpdateOBISCodeInfo(codes: TGXStandardObisCodeCollection; it: TGXDLMSObject);
var
  code: TGXStandardObisCode;
  dt: TDataType;
  list: TObjectList<TGXStandardObisCode>;
begin
  if Not it.Description.IsEmpty Then
    Exit;
  list := codes.Find(it.LogicalName, it.ObjectType);
  try
    code := list[0];
    it.Description := code.Description;
    //If string is used
    if code.DataType.Contains('10') Then
      code.UIDataType := '10'
    //If date time is used.
    else if code.DataType.Contains('25') or code.DataType.Contains('26') Then
    begin
      code.UIDataType := '25';
      code.DataType := '25';
    end
    //Time stamps of the billing periods objects (first scheme if there are two)
    else if code.DataType.Contains('9') Then
    begin
      if TGXStandardObisCodeCollection.EqualsMask('0.0-64.96.7.10-14.255', it.LogicalName) or
        //Time stamps of the billing periods objects (second scheme)
        TGXStandardObisCodeCollection.EqualsMask('0.0-64.0.1.5.0-99,255', it.LogicalName) or
        //Time of power failure
        TGXStandardObisCodeCollection.EqualsMask('0.0-64.0.1.2.0-99,255', it.LogicalName) or
        //Time stamps of the billing periods objects (first scheme if there are two)
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.1.2.0-99,255', it.LogicalName) or
        //Time stamps of the billing periods objects (second scheme)
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.1.5.0-99,255', it.LogicalName) or
        //Time expired since last end of billing period
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.0.255', it.LogicalName) or
        //Time of last reset
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.6.255', it.LogicalName) or
        //Date of last reset
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.7.255', it.LogicalName) or
        //Time expired since last end of billing period (Second billing period scheme)
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.13.255', it.LogicalName) or
        //Time of last reset (Second billing period scheme)
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.14.255', it.LogicalName) or
        //Date of last reset (Second billing period scheme)
        TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.15.255', it.LogicalName) Then
          code.UIDataType := '25'
      //Local time
      else if TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.1.255', it.LogicalName) Then
        code.UIDataType := '27'
      //Local date
      else if TGXStandardObisCodeCollection.EqualsMask('1.0-64.0.9.2.255', it.LogicalName) Then
        code.UIDataType := '26'
      //Active firmware identifier
      else if TGXStandardObisCodeCollection.EqualsMask('1.0.0.2.0.255', it.LogicalName) Then
        code.UIDataType := '10';
    end;
    if (code.DataType <> '*') and (code.DataType <> string.Empty) and (Not code.DataType.Contains(',')) Then
    begin
      dt := TDataType(StrToInt(code.DataType));
      case it.ObjectType of
        TObjectType.otData,
        TObjectType.otRegister,
        TObjectType.otRegisterActivation,
        TObjectType.otExtendedRegister:
          it.SetDataType(2, dt)
      end;
    end;
    if Not code.UIDataType.IsEmpty Then
    begin
      dt := TDataType(StrToInt(code.UIDataType));
      case it.ObjectType of
        TObjectType.otData,
        TObjectType.otRegister,
        TObjectType.otRegisterActivation,
        TObjectType.otExtendedRegister:
          it.SetUIDataType(2, dt);
      end;
    end;
  finally
    FreeAndNil(list);
  end;
end;

// Convert DLMS data type to pascal data type.
class function TGXDLMSConverter.GetDataType(ADataType : TDataType) : PTypeInfo;
begin
  Result := TGXCommon.GetDataType(ADataType);
end;

class function TGXDLMSConverter.GetDLMSDataType(AValue : TValue) : TDataType;
begin
  Result := TGXCommon.GetDLMSDataType(AValue);
end;

end.

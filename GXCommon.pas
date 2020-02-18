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

unit GXCommon;


interface

uses System.TypInfo,
System.Generics.Collections,
SysUtils,
DateUtils,
Classes,
Variants,
Gurux.DLMS.ActionType,
Gurux.DLMS.DataType,
Gurux.DLMS.GXDateTime,
Gurux.DLMS.GXDate,
Gurux.DLMS.GXTime,
Gurux.DLMS.DateTimeSkips,
Rtti,
Gurux.DLMS.TUnit,
Windows,
Gurux.DLMS.ClockStatus,
GXByteBuffer,
GXDataInfo,
Gurux.DLMS.ErrorCode,
GXCmdParameter,
System.Types,
Gurux.DLMS.Enums.DateTimeExtraInfo;

const
  HDLCFrameStartEnd = $7E;
  LLCSendBytes : array [0..2] of Byte = ($E6, $E6, $00);
  LLCReplyBytes : array [0..2] of byte = ($E6, $E7, $00);
  DATA_TYPE_OFFSET = $FF0000;
type
  LogicalName = array[0..5] of Byte;
  TValueArray = array of TValue;
  TGXStructure = TArray<TValue>;
  TGXArray = TArray<TValue>;
  TGXEnum = UInt8;
  TGXBitString = string;

TGXCommon = class
// Reserved for internal use.
class procedure ToBitString(sb: TStringBuilder; value : Byte; count : Integer);
// Convert Bit string to DLMS bytes.
class procedure SetBitString(buff : TGXByteBuffer; value: TValue; addCount: Boolean);

// Convert Octet string to DLMS bytes.
class procedure SetOctetString(buff: TGXByteBuffer; value: TValue);

// Convert UTF string to DLMS bytes.
class procedure SetUtfString(buff: TGXByteBuffer; value: TValue);

// Convert ASCII string to DLMS bytes.
class procedure SetString(buff: TGXByteBuffer; value: TValue);

// Convert time to DLMS bytes.
class procedure SetTime(buff : TGXByteBuffer; value: TValue);

// Convert date to DLMS bytes.
class procedure SetDate(buff : TGXByteBuffer; value: TValue);
// Convert date time to DLMS bytes.
class procedure SetDateTime(buff : TGXByteBuffer; value: TValue);

// Convert BCD to DLMS bytes.
class procedure SetBcd(buff : TGXByteBuffer; value: TValue);

// Convert Array to DLMS bytes.
class procedure SetArray(buff : TGXByteBuffer; value: TValue);

  // Get array from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// index : starting index.
// return Object array.
class function GetArray(buff : TGXByteBuffer; info: TGXDataInfo; index : Integer) : TValue; static;

// Get time from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return Parsed time.
class function GetTime(buff : TGXByteBuffer; info: TGXDataInfo) : TValue; static;

// Get date from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed date.
class function GetDate(buff : TGXByteBuffer; info: TGXDataInfo): TValue; static;

// Get the number of days in that month.
// year : Year.
// month: Month.
// return Number of days in month.
class function DaysInMonth(year : Integer; month : Integer) : Integer; static;

// Get date and time from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed date and time.
class function GetDateTime(buff : TGXByteBuffer; info: TGXDataInfo): TValue;static;

// Get double value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed double value.
class function GetDouble(buff : TGXByteBuffer; info: TGXDataInfo): TValue; static;

// Get float value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed float value.
class function GetFloat(buff : TGXByteBuffer;info: TGXDataInfo): TValue;static;

// Get enumeration value from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return parsed enumeration value.
class function GetEnum(buff : TGXByteBuffer; info: TGXDataInfo) : TValue; static;

// Get UInt64 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UInt64 value.
class function GetUInt64(buff : TGXByteBuffer; info: TGXDataInfo) : TValue; static;

// Get Int64 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int64 value.
class function GetInt64(buff : TGXByteBuffer; info: TGXDataInfo): TValue; static;

// Get UInt16 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UInt16 value.
class function GetUInt16(buff : TGXByteBuffer; info: TGXDataInfo): TValue; static;

// Get UInt8 value from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return parsed UInt8 value.
class function GetUInt8(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;static;

// Get Int16 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int16 value.
class function GetInt16(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;static;

// Get Int8 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int8 value.
class function GetInt8(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;static;

// Get BCD value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed BCD value.
class function GetBcd(buff : TGXByteBuffer; info: TGXDataInfo; knownType: Boolean): TValue;static;

// Get UTF string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UTF string value.
class function GetUtfString(buff : TGXByteBuffer; info: TGXDataInfo;knownType: Boolean): TValue; static;

// Get octet string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed octet string value.
class function GetOctetString(buff : TGXByteBuffer; info: TGXDataInfo;knownType: Boolean): TValue;static;

// Get string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed string value.
class function GetString(buff : TGXByteBuffer; info: TGXDataInfo;knownType: Boolean): TValue;static;

// Get UInt32 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UInt32 value.
class function GetUInt32(buff : TGXByteBuffer; info: TGXDataInfo): TValue;static;

// Get Int32 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int32 value.
class function GetInt32(buff : TGXByteBuffer; info: TGXDataInfo): TValue;static;

// Get bit string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed bit string value.
class function GetBitString(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;static;

// Get boolean value from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return parsed boolean value.
class function GetBoolean(buff : TGXByteBuffer; info: TGXDataInfo): TValue;static;

// Get HDLC address from byte array.
// buff : byte array.
// return HDLC address.
class function GetHDLCAddress(buff : TGXByteBuffer) : Integer;static;
// Return how many bytes object count takes.
// count: Value.
// returns Value size in bytes.
class function GetObjectCountSizeInBytes(count: Integer) : Integer;static;

public
  class procedure Trace(str : string);static;
  class function Compare(buff1 : array of byte; index : PInteger; buff2 : array of byte) : Boolean;
  class function GetBytes(value: string): TBytes; static;

   // Convert DLMS data type to pascal data type.
  class function GetDataType(ADataType : TDataType): PTypeInfo;static;
  class function GetDLMSDataType(AValue : TValue): TDataType ;static;


  // Get object count. If first byte is $80 or higger it will tell bytes count.
  // data : received data.
  // return Object count.
  class function GetObjectCount(data : TGXByteBuffer) : Integer;

  class function SetObjectCount(Count : Integer; buff : TGXByteBuffer): Byte ;static;

  class function GetData(data : TGXByteBuffer; info : TGXDataInfo) : TValue; static;

  class procedure SetData(buff : TGXByteBuffer; dataType : TDataType; value : TValue); static;

  class function GetResource(Name : String): String;static;

  class function GetDescription(errCode : Integer) : String;
  class function UnitToString(AUnit : TUnit) : String; static;

  class function ChangeType(value: TBytes; tp: TDataType): TValue;overload;
  class function ChangeType(value: TGXByteBuffer; tp: TDataType): TValue;overload;
  class function LogicalNameToBytes(value: String): LogicalName;overload;
  class function ToLogicalName(value: TValue): string;overload;

  // Returns command line parameters.
  // returns: List of command line parameters
  class function GetParameters(optstring: string) : TObjectList<TGXCmdParameter>;
  class function GetLogicalName(ln: string): TBytes;overload;
  class function ToLogicalName(buff: TBytes): string;overload;
  class function IsAsciiString(value: TBytes): Boolean;static;
  class function ToHexString(bytes : TBytes; addSpace : Boolean; Index : Integer; Count : Integer): String; static;

  //Is Numeric Value
  class function IsNumeric(value: TValue): Boolean;static;
end;

implementation

class procedure TGXCommon.Trace(str : string);
begin
  OutputDebugString(PCHAR(str));
end;

class function TGXCommon.GetDescription(errCode : Integer): String;
begin
     // -1 : Result := 'Not a reply.';
    case TErrorCode(errCode) of
    TErrorCode.ecREJECTED:
        Result := 'Rejected';
    TErrorCode.ecOK: Result := '';
    TErrorCode.ecHARDWAREFAULT: Result := 'Access Error : Device reports a hardware fault.';
    TErrorCode.ecTEMPORARYFAILURE: Result := 'Access Error : Device reports a temporary failure.';
    TErrorCode.ecREADWRITEDENIED: Result := 'Access Error : Device reports Read-Write denied.';
    TErrorCode.ecUNDEFINEDOBJECT: Result := 'Access Error : Device reports a undefined object.';
    TErrorCode.ecINCONSISTENTCLASS: Result := 'Access Error : Device reports a inconsistent Class or object.';
    TErrorCode.ecUNAVAILABLEOBJECT: Result := 'Access Error : Device reports a unavailable object.';
    TErrorCode.ecUNMATCHEDTYPE: Result := 'Access Error : Device reports a unmatched type.';
    TErrorCode.ecACCESSVIOLATED: Result := 'Access Error : Device reports scope of access violated.';
    TErrorCode.ecDATABLOCKUNAVAILABLE: Result := 'Access Error : Data Block Unavailable.';
    TErrorCode.ecLONGGETORREADABORTED: Result := 'Access Error : Long Get Or Read Aborted.';
    TErrorCode.ecNOLONGGETORREADINPROGRESS: Result := 'Access Error : No Long Get Or Read In Progress.';
    TErrorCode.ecLONGSETORWRITEABORTED: Result := 'Access Error : Long Set Or Write Aborted.';
    TErrorCode.ecNOLONGSETORWRITEINPROGRESS: Result := 'Access Error : No Long Set Or Write In Progress.';
    TErrorCode.ecDATABLOCKNUMBERINVALID: Result := 'Access Error : Data Block Number Invalid.';
    TErrorCode.ecOTHERREASON: Result := 'Access Error : Other Reason.';
    else Result := 'Access Error : Unknown error.';
    end;
end;

class function TGXCommon.UnitToString(AUnit : TUnit) : String;
begin
  case Integer(AUnit) of
    0: Result := 'None';
		1: Result := 'Year';
		2: Result := 'Month';
		3: Result := 'Week';
		4: Result := 'Day';
		5: Result := 'Hour';
		6: Result := 'Minute';
		7: Result := 'Second';
		8: Result := 'PhaseAngle';
		9: Result := 'Temperature';
		10: Result := 'LocalCurrency';
		11: Result := 'Length';
		12: Result := 'Speed';
		13: Result := 'Volume';
		14: Result := 'CorrectedVolume';
		15: Result := 'VolumeFlux';
		16: Result := 'CorrectedVolume';
		17: Result := 'VolumeFlux';
		18: Result := 'CorrectedVolumeF';
		19: Result := 'Volume';
		20: Result := 'MassKg';
		21: Result := 'Force';
		22: Result := 'Energy';
		23: Result := 'PressurePascal';
		24: Result := 'PressureBar';
		25: Result := 'EnergyJoule';
		26: Result := 'ThermalPower';
		27: Result := 'ActivePower';
		28: Result := 'ApparentPower';
		29: Result := 'ReactivePower';
		30: Result := 'ActiveEnergy';
		31: Result := 'ApparentEnergy';
		32: Result := 'ReactiveEnergy';
		33: Result := 'Current';
		34: Result := 'ElectricalCharge';
		35: Result := 'Voltage';
		36: Result := 'ElectricalFieldStrength';
		37: Result := 'Capacity';
		38: Result := 'Resistance';
		39: Result := 'Resistivity';
		40: Result := 'MagneticFlux';
		41: Result := 'Induction';
		42: Result := 'MagneticFeldStrength';
		43: Result := 'Inductivity';
		44: Result := 'Frequency';
		45: Result := 'ActiveEnergyMeterConstant';
		46: Result := 'ReactiveEnergyMeterConstant';
		47: Result := 'ApparentEnergyMeterConstant';
		48: Result := 'V260';
		49: Result := 'A260';
		50: Result := 'MassFlux';
		51: Result := 'Conductance';
		254: Result := 'OtherUnit';
		255: Result := 'NoUnit';
  	else
      Result := '';
  end;
end;

class function TGXCommon.Compare(buff1 : array of byte; index : PInteger;
                        buff2 : array of byte) : Boolean;
var
  len : Integer;
begin
  len := Length(buff2);
  Result := CompareMem(@buff1[index^], @buff2, len);
  if Result then
    index^ := index^ + len;
end;

class function TGXCommon.GetBytes(value: string): TBytes;
begin
  Result := TEncoding.ASCII.GetBytes(value)
end;

class function TGXCommon.SetObjectCount(Count : Integer; buff : TGXByteBuffer) : Byte;
begin
  if (count < $80) then
  begin
    buff.SetUInt8(count);
    Result := 1;
  end
  else if (count < $100) then
  begin
    buff.SetUInt8($81);
    buff.SetUInt8(count);
    Result := 2;
  end
  else if (count < $10000) then
  begin
    buff.SetUInt8($82);
    buff.SetUInt16(count);
    Result := 3;
  end
  else
  begin
    buff.SetUInt8($84);
    buff.SetUInt32(count);
    Result := 5;
  end;
end;

class function TGXCommon.GetResource(Name : String): String;
var
  RS: TResourceStream;
  str : AnsiString;
  wx : word;
  len : Integer;
begin
  RS := TResourceStream.Create(HInstance, Name, 'Text');
  try
    RS.Read(wx,2);
    //UTF16
    if wx=$FEFF then
    begin
      len :=(RS.Size div 2) - 1;
      SetLength(Result, len);
      RS.Read(Result[1], len *2);
    end
    else
      begin
      len:=0;
      if wx=$BBEF then RS.Read(len, 1);

      //UTF-8
      if (wx=$BBEF) and (len = $BF) then
      begin
        len:= RS.Size - 3;
        SetLength(str, len);
        RS.Read(str[1], len);
        Result:=UTF8ToString(str);
      end
      else
      begin
        RS.Position := 0;
        SetLength(str, RS.Size);
        RS.Read(str[1], RS.Size);
        Result := string(str);
      end;
    end;
  finally
    RS.Free;
  end;
end;

// Get object count. If first byte is $80 or higger it will tell bytes count.
// data : received data.
// return Object count.
class function TGXCommon.GetObjectCount(data : TGXByteBuffer) : Integer;
begin
  Result := data.GetUInt8();
  if Result > $80 then
    if Result = $81 then
      Result := data.GetUInt8()
    else if (Result = $82)then
      Result := data.GetUInt16()
    else if (Result = $84) then
      Result := data.GetUInt32()
    else
      raise EArgumentException.Create('Invalid count.');
end;

// Get data from DLMS frame.
// data : received data.
// info : Data info.
// return : Received data.
class function TGXCommon.GetData(data : TGXByteBuffer; info : TGXDataInfo) : TValue;
var
  startIndex : Integer;
  knownType : Boolean;
begin
  startIndex := data.Position;
  if (data.Position = data.Size) then
  begin
      info.Complete := False;
      Result := Nil;
      Exit;
  end;
  info.Complete := True;
  // Get data type if it is unknown.
  knownType := info.&Type <> TDataType.dtNONE;
  if (knownType = False) then
      info.&Type := TDataType(data.GetUInt8());

  if (info.&Type = TDataType.dtNONE) then
  begin
    Result := Nil;
    if info.Xml <> Nil Then
      info.Xml.AppendLine('<' + info.Xml.GetDataType(info.&Type) + ' />');
    Exit;
  end;
  if (data.Position = data.Size) then
  begin
      info.Complete := False;
      Result := Nil;
      Exit;
  end;
  case(info.&Type) of
  TDataType.dtARRAY,
  TDataType.dtSTRUCTURE:
      Result := GetArray(data, info, startIndex);
  TDataType.dtBOOLEAN:
      Result := GetBoolean(data, info);
  TDataType.dtBITSTRING:
      Result := GetBitString(data, info);
  TDataType.dtINT32:
      Result := GetInt32(data, info);
  TDataType.dtUINT32:
      Result := GetUInt32(data, info);
  TDataType.dtString:
      Result := GetString(data, info, knownType);
  TDataType.dtStringUTF8:
      Result := GetUtfString(data, info, knownType);
  TDataType.dtOctetString:
      Result := GetOctetString(data, info, knownType);
  TDataType.dtBinaryCodedDesimal:
      Result := GetBcd(data, info, knownType);
  TDataType.dtINT8:
      Result := GetInt8(data, info);
  TDataType.dtINT16:
      Result := GetInt16(data, info);
  TDataType.dtUINT8:
      Result := GetUInt8(data, info);
  TDataType.dtUINT16:
      Result := GetUInt16(data, info);
  TDataType.dtCompactArray:
    raise Exception.Create('Invalid data type.');
  TDataType.dtINT64:
      Result := GetInt64(data, info);
  TDataType.dtUINT64:
      Result := GetUInt64(data, info);
  TDataType.dtENUM:
      Result := GetEnum(data, info);
  TDataType.dtFLOAT32:
      Result := GetFloat(data, info);
  TDataType.dtFLOAT64:
      Result := GetDouble(data, info);
  TDataType.dtDATETIME:
      Result := GetDateTime(data, info);
  TDataType.dtDATE:
      Result := GetDate(data, info);
  TDataType.dtTIME:
      Result := GetTime(data, info);
  else
    raise Exception.Create('Invalid data type.');
  end;
end;

// Get array from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// index : starting index.
// return Object array.
class function TGXCommon.GetArray(buff : TGXByteBuffer; info: TGXDataInfo; index : Integer) : TValue;
var
  pos, size, startIndex : Integer;
  arr : TList<TValue>;
  info2 : TGXDataInfo;
  tmp : TValue;
begin
  pos := 0;
  if info.Count = 0 then
    info.Count := GetObjectCount(buff);

  if info.Xml <> Nil Then
    info.Xml.AppendStartTag(DATA_TYPE_OFFSET or LONGWORD(info.&Type), 'Qty', info.Xml.IntegerToHex(info.Count, 2), False);

  size := buff.Size - buff.Position;
  if (info.Count <> 0) and (size < 1) then
  begin
    info.Complete := False;
    Exit;
  end;
  startIndex := index;
  arr := TList<TValue>.Create();
  try
    // Position where last row was found. Cache uses this info.
    for pos := info.Index to info.Count - 1 do
    begin
      info2 := TGXDataInfo.Create();
      try
        info2.Xml := info.Xml;
        tmp := GetData(buff, info2);
        if info2.Complete = False then
        begin
          buff.Position := startIndex;
          info.Complete := False;
          break;
        end
        else if info2.Count = info2.Index then
        begin
          startIndex := buff.Position;
          arr.add(tmp);
        end;
      finally
        FreeAndNil(info2);
      end;
    end;
    if info.Xml <> Nil Then
      info.Xml.AppendEndTag(DATA_TYPE_OFFSET + LONGWORD(info.&Type));
    info.Index := pos;
    Result := TValue.From(arr.ToArray())
  finally
    FreeAndNil(arr);
  end;
end;

// Get time from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return Parsed time.
class function TGXCommon.GetTime(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  hour, minute, second, ms : Integer;
  str: String;
begin
  if ((buff.Size - buff.Position) < 4) then
  begin
    // If there is not enough data available.
    info.Complete := False;
    Exit;
  end;
  if info.Xml <> Nil Then
    str := buff.ToHex(False, buff.Position, buff.Available);
  // Get time.
  hour := buff.GetUInt8();
  minute := buff.GetUInt8();
  second := buff.GetUInt8();
  ms := buff.GetUInt8();
  Result := TGXTime.Create(hour, minute, second, ms);
  if info.Xml <> Nil Then
  begin
    info.Xml.AppendComment(Result.ToString());
    info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', str);
  end;
end;

// Get date from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed date.
class function TGXCommon.GetDate(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  year, month, day, dow : Integer;
  dt : TGXDate;
  str: string;
begin
  if ((buff.Size - buff.Position) < 5) then
  begin
    // If there is not enough data available.
    info.Complete := False;
    Exit;
  end;
  if info.Xml <> Nil Then
    str := buff.ToHex(False, buff.Position, buff.Available);
  // Get year.
  year := buff.getUInt16();
  // Get month
  month := buff.GetUInt8();
  // Get day
  day := buff.GetUInt8();
  // Get week day
  dow := buff.GetUInt8();
  dt := TGXDate.Create(year, month, day, dow);
  Result := TValue.From(dt);
  if info.Xml <> Nil Then
  begin
    info.Xml.AppendComment(dt.ToString());
    info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', str);
  end;
end;

// Get the number of days in that month.
// year : Year.
// month: Month.
// return Number of days in month.
class function TGXCommon.DaysInMonth(year: Integer; month: Integer) : Integer;
begin
   if (month = 0) or (month = 2) or (month = 4) or
      (month = 6) or (month = 7) or (month = 9) or (month = 11) then
    Result := 31
  else if (month = 3) or (month = 5) or (month = 8) or (month = 10) then
    Result := 30
  else if year Mod 4 = 0 Then
  begin
    if year Mod 100 = 0 Then
    begin
      if year Mod 400 = 0 then
        Result := 29
      else
        Result := 28;
    end
    else
      Result := 29;
  end
  else
    Result := 28;
end;

// Get date and time from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed date and time.
class function TGXCommon.GetDateTime(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  dt : TGXDateTime;
  year: WORD;
  month, day, hour, min, sec, ms, dow : Byte;
  deviation: Integer;
  skip: TDateTimeSkipsSet;
  str: String;
begin
  // If there is not enough data available.
  if buff.Size - buff.Position < 12 then
  begin
    //If time.
    if buff.Size - buff.Position < 5 Then
      Result := GetTime(buff, info)
    //If date.
    else if buff.Size - buff.Position < 6 Then
      Result := GetDate(buff, info)
    else
      info.Complete := False;
    Exit;
  end;
  if info.Xml <> Nil Then
    str := buff.ToHex(False, buff.Position, buff.Available);

  skip.SetOnly(TDateTimeSkips.dkNone);

  // Get year.
  year := buff.getUInt16();
  // Get month
  month := buff.GetUInt8();
  // Get day
  day := buff.GetUInt8();
  // Get week day
  dow := buff.GetUInt8();

  // Get time.
  hour := buff.GetUInt8();
  min := buff.GetUInt8();
  sec := buff.GetUInt8();
  ms := buff.GetUInt8();

  dt := TGXDateTime.Create(year, month, day, hour, min, sec, ms, dow);
  try

    deviation := buff.getInt16();
    if (deviation = -32768) Then
    begin
      dt.TimeZone := 0;
      dt.Skip.Add(TDateTimeSkips.dkDeviation);
    end
    else
    begin
      dt.TimeZone := deviation;
    end;
    dt.Status := TClockStatus(buff.GetUInt8());
  except
    dt.Free;
    raise;
  end;

  Result := TValue.From(dt);
  if info.Xml <> Nil Then
  begin
    info.Xml.AppendComment(dt.ToString());
    info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', str);
  end;
end;

// Get double value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed double value.
class function TGXCommon.GetDouble(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  str: String;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 8) then
    info.Complete := False
  else
  begin
    if info.Xml <> Nil Then
      str := buff.ToHex(False, buff.Position, 8);

    Result := buff.GetDouble();
    if info.Xml <> Nil Then
    begin
      if info.Xml.Comments Then
        info.Xml.AppendComment(Result.ToString());
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', str);
    end;
  end;
end;

// Get float value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return Parsed float value.
class function TGXCommon.GetFloat(buff : TGXByteBuffer;info: TGXDataInfo): TValue;
var
  str: String;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 4) then
    info.Complete := False
  else
  begin
    if info.Xml <> Nil Then
      str := buff.ToHex(False, buff.Position, 8);

    Result := buff.GetFloat();
    if info.Xml <> Nil Then
    begin
      if info.Xml.Comments Then
        info.Xml.AppendComment(Result.ToString());
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', str);
    end;
  end;
end;

// Get enumeration value from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return parsed enumeration value.
class function TGXCommon.GetEnum(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  ch: BYTE;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 1) then
      info.Complete := False
  else
  begin
    ch := buff.GetUInt8();
    Result := TValue.From<TGXEnum>(ch);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(ch, 2));
  end;
end;

// Get UInt64 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UInt64 value.
class function TGXCommon.GetUInt64(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  val: UInt64;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 8) then
      info.Complete := False
  else
  begin
    val := buff.GetUInt64();
    Result := val;
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 8));
  end;
end;

// Get Int64 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int64 value.
class function TGXCommon.GetInt64(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  val: Int64;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 8) then
      info.Complete := False
  else
  begin
    val := buff.GetInt64();
    Result := val;
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 8));
  end;
end;

// Get UInt16 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UInt16 value.
class function TGXCommon.GetUInt16(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  val: UInt16;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 2) then
    info.Complete := False
  else
  begin
    val := buff.GetUInt16();
    Result := val;
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 4));
  end;
end;

// Get UInt8 value from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return parsed UInt8 value.
class function TGXCommon.GetUInt8(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  val: BYTE;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 1) then
    info.Complete := False
  else
  begin
    val := buff.GetUInt8();
    TValue.Make(val, TypeInfo(BYTE),Result);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 2));
  end;
end;

// Get Int16 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int16 value.
class function TGXCommon.GetInt16(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  val: Int16;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 2) then
      info.Complete := False
  else
  begin
    val := buff.GetInt16();
    TValue.Make(val, TypeInfo(Int16),Result);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 4));
  end;
end;

// Get Int8 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int8 value.
class function TGXCommon.GetInt8(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  val: ShortInt;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 1) then
    info.Complete := False
  else
   begin
    val := buff.GetInt8();
    TValue.Make(val, TypeInfo(Shortint),Result);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 2));
  end;
end;

// Get BCD value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed BCD value.
class function TGXCommon.GetBcd(buff : TGXByteBuffer; info: TGXDataInfo; knownType: Boolean): TValue;
var
  val: BYTE;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 1) then
      info.Complete := False
  else
  begin
    val := buff.GetUInt8();
    TValue.Make(val, TypeInfo(BYTE),Result);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 4));
  end;
end;

// Get UTF string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UTF string value.
class function TGXCommon.GetUtfString(buff : TGXByteBuffer; info: TGXDataInfo;knownType: Boolean): TValue;
var
  len : Integer;
begin
  if knownType then
    len := buff.Size
  else
  begin
    len := TGXCommon.GetObjectCount(buff);
    // If there is not enough data available.
    if buff.Size - buff.Position < len then
    begin
      info.Complete := False;
      Exit;
    end;
  end;
  if len > 0 then
    Result := buff.GetString(buff.Position, len)
  else
    Result := '';
end;

class function TGXCommon.ToLogicalName(value: TValue): string;
var
  buff: TBytes;
begin
    value := value.AsType<TValue>;
    if value.IsType<TBytes> Then
    begin
      buff := value.AsType<TBytes>;
      if Length(buff) = 0 Then
        SetLength(buff, 6);

      if Length(buff) = 6 Then
        Result := IntToStr(buff[0]) + '.' + IntToStr(buff[1]) + '.' + IntToStr(buff[2]) + '.' +
                  IntToStr(buff[3]) + '.' + IntToStr(buff[4]) + '.' + IntToStr(buff[5])
      else if Length(buff) <> 0 Then
        raise EArgumentException.Create('Invalid Logical Name');
    end
    else
      Result := value.toString();
end;

class function TGXCommon.ToLogicalName(buff: TBytes): string;
begin
  Result := '';
  if Length(buff) = 6 then
    begin
      Result := Format('%d', [buff[0]])+ '.' + Format('%d', [buff[1]]) + '.' +
      Format('%d', [buff[2]])+ '.' + Format('%d', [buff[3]]) + '.' +
      Format('%d', [buff[4]])+ '.' + Format('%d', [buff[5]]);
    end;
end;

class function TGXCommon.GetLogicalName(ln: string): TBytes;
var
  index : Integer;
  it: string;
  items: TArray<string>;
begin
  items := ln.Split(['.']);
  SetLength(Result, Length(items));
  if Length(Result) <> 6 then
    raise EArgumentException.Create('Invalid Logical name.');
  index := 0;
  for it in items do
  begin
    Result[index] := (byte.Parse(it));
    index := index + 1;
  end;
 end;

// Get octet string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed octet string value.
class function TGXCommon.GetOctetString(buff : TGXByteBuffer; info: TGXDataInfo;knownType: Boolean): TValue;
var
  len: Integer;
  value: TBytes;
  str: string;
  isString: Boolean;
  dt: TDataType;
  tmp: TValue;
begin
  if knownType then
    len := buff.Size
  else
  begin
    len := TGXCommon.GetObjectCount(buff);
    // If there is not enough data available.
    if buff.Size - buff.Position < len then
    begin
      info.Complete := False;
      Exit;
    end;
  end;
  SetLength(value, len);
  buff.Get(value);
  Result := TValue.From(value);
  if info.Xml <> Nil Then
  begin
    if (info.Xml.Comments and (Length(value) <> 0)) Then
    begin
      isString := False;
      // This might be logical name.
      if (Length(value) = 6) and (value[5] = $FF) Then
      begin
        info.Xml.AppendComment(TGXCommon.ToLogicalName(value));
      end
      else
      begin
        isString := True;
        //Try to move octect string to DateTime, Date or time.
        if (Length(value) = 12) or (Length(value) = 5) or (Length(value) = 4) Then
        begin
          dt := TDataType.dtNone;
          if Length(value) = 12 Then
            dt := TDataType.dtDateTime
          else if Length(value) = 5 Then
            dt := TDataType.dtDate
          else if Length(value) = 4 Then
            dt := TDataType.dtTime;
          if dt <> TDataType.dtNone Then
          begin
            tmp := TGXCommon.ChangeType(value, dt);
            info.Xml.AppendComment(tmp.ToString());
            isString := false;
          end;
        end;
      end;
      if isString Then
        isString := TGXCommon.IsAsciiString(value);

      if isString Then
      begin
        str := str + TEncoding.ASCII.GetString(value);
        info.Xml.AppendComment(str);
      end;
    end;
    str := TGXCommon.ToHexString(value, False, 0, Length(value));
    info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', str);
  end;
end;

// Get string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed string value.
class function TGXCommon.GetString(buff : TGXByteBuffer; info: TGXDataInfo;knownType: Boolean): TValue;
var
 len : Integer;
begin
  if knownType then
    len := buff.Size
  else
  begin
    len := GetObjectCount(buff);
    // If there is not enough data available.
    if (buff.Size - buff.Position < len) then
    begin
      info.Complete := False;
      Exit;
    end;
  end;
  if (len > 0) Then
    Result := buff.GetString(len)
  else
    Result := '';

  if info.Xml <> Nil Then
    info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', Result);
end;

// Get UInt32 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed UInt32 value.
class function TGXCommon.GetUInt32(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  val: UInt32;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 4) then
    info.Complete := False
  else
  begin
    val := buff.GetUInt32();
    TValue.Make(val, TypeInfo(UInt32), Result);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 8));
  end;
end;

// Get Int32 value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed Int32 value.
class function TGXCommon.GetInt32(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  val: Int32;
begin
  // If there is not enough data available.
  if ((buff.Size - buff.Position) < 4) then
    info.Complete := False
  else
  begin
    val := buff.GetInt32();
    TValue.Make(val, TypeInfo(Int32), Result);
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', info.Xml.IntegerToHex(val, 8));
  end;
end;

// Reserved for internal use.
class procedure TGXCommon.ToBitString(sb: TStringBuilder; value : Byte; count : Integer);
var
  pos: Integer;
begin
  if count > 0 then
  begin
    if (count > 8) then
      count := 8;
    pos := 7;
    while pos <> 8 - count - 1 do
    begin
      if (value and (1 shl pos)) <> 0 then
        sb.append('1')
      else
        sb.append('0');
      pos := pos - 1;
    end;
  end;
end;

// Get bit string value from DLMS data.
// buff : Received DLMS data.
// info: Data info.
// return parsed bit string value.
class function TGXCommon.GetBitString(buff : TGXByteBuffer; info: TGXDataInfo) : TValue;
var
  byteCnt, cnt : Integer;
  t : Double;
  sb: TStringBuilder;
begin
  cnt := TGXCommon.GetObjectCount(buff);
  t := cnt;
  t := t / 8;
  if cnt Mod 8 <> 0 then
    t := t + 1;

  byteCnt := Trunc(t);
  // If there is not enough data available.
  if (buff.Size - buff.Position) < byteCnt then
  begin
    info.Complete := False;
    Exit;
  end;
  sb := TStringBuilder.Create;
  try
    while cnt > 0 do
    begin
      toBitString(sb, buff.getInt8(), cnt);
      cnt := cnt - 8;
    end;
    Result := TValue.From<TGXBitString>(sb.ToString());
    if info.Xml <> Nil Then
      info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', sb.ToString());
  finally
    FreeAndNil(sb);
  end;
end;

// Get boolean value from DLMS data.
// buff : Received DLMS data.
// info : Data info.
// return parsed boolean value.
class function TGXCommon.GetBoolean(buff : TGXByteBuffer; info: TGXDataInfo): TValue;
var
  val: Boolean;
  str: string;
begin
    // If there is not enough data available.
    if ((buff.Size - buff.Position) < 1) then
      info.Complete := False
    else
    begin
      val := Boolean(buff.GetUInt8() <> 0);
      Result := val;
      if info.Xml <> Nil Then
      begin
        if val then str := 'true' else str := 'false';
        info.Xml.AppendLine(info.Xml.GetDataType(info.&Type), '', val);
      end;
    end;
end;

// Get HDLC address from byte array.
// buff : byte array.
// return HDLC address.
class function TGXCommon.GetHDLCAddress(buff : TGXByteBuffer) : Integer;
var
  tmp : Long;
  size : Byte;
  pos : Integer;
begin
  size := 0;
  for pos := buff.Position to buff.Size do
  begin
    size := size + 1;
    if (buff.GetUInt8(pos) and $1) = 1 then
      break;
  end;
  if size = 1 then
    Result := ((buff.GetUInt8() and $FE) Shr 1)
  else if size = 2 then
  begin
      tmp := buff.getUInt16();
      Result := ((tmp and $FE) shr 1) or ((tmp and $FE00) shr 2);
  end
  else if size = 4 then
  begin
    tmp := buff.GetUInt32();
    Result := ((tmp and $FE) shr 1) or ((tmp and $FE00) shr 2)
            or ((tmp and $FE0000) shr 3) or Integer((tmp and $FE000000) shr 4);
  end
  else
    raise Exception.Create('Wrong size.');
end;

class function TGXCommon.GetObjectCountSizeInBytes(count: Integer) : Integer;
begin
  if count < $80 Then
    Result := 1
  else if count < $100 Then
    Result := 2
  else if count < $10000 Then
    Result := 3
  else
    Result := 5;
end;

// Convert Bit string to DLMS bytes.
class procedure TGXCommon.SetBitString(buff : TGXByteBuffer; value: TValue; addCount: Boolean);
var
  val, index, pos : Integer;
  arr : TBytes;
  str : TArray<Char>;
  it : Char;
begin
    if value.IsType<String> then
    begin
      val := 0;
      str := value.AsType<String>.ToCharArray();
      if addCount then
        SetObjectCount(Length(str), buff);
      index := 7;
      for pos := 0 to Length(str) - 1 do
      begin
        it := str[pos];
        if it = '1' then
          val := val or (1 shl index)
        else if it <> '0' then
          raise Exception.Create('Not a bit string.');

        index := index - 1;
        if index = -1 then
        begin
          index := 7;
          buff.SetUInt8(val);
          val := 0;
        end;
      end;
      if index <> 7 then
        buff.SetUInt8(val);
    end
    else if value.IsType<TBytes> then
    begin
      arr := value.asType<TBytes>;
      setObjectCount(8 * Length(arr), buff);
      buff.SetArray(arr);
    end
    else if value.IsType<BYTE> then
    begin
      val := value.asType<BYTE>;
      setObjectCount(8, buff);
      buff.SetUint8(val);
    end
    else
      raise Exception.Create('BitString must give as string.');
end;

// Convert Octet string to DLMS bytes.
class procedure TGXCommon.SetOctetString(buff: TGXByteBuffer; value: TValue);
type
  BYTE_ARRAY = array of Byte;
var
  tmp: TBytes;
  tmp2: TByteDynArray;
  pos, len: Integer;
begin
  if value.IsType<String> then
  begin
    tmp := TGXByteBuffer.HexToBytes(value.ToString);
    SetObjectCount(Length(tmp), buff);
    buff.SetArray(tmp);
  end
  else if (value.IsType<TBytes>) then
  begin
    tmp := value.asType<TBytes>;
    setObjectCount(Length(tmp) , buff);
    buff.SetArray(tmp);
  end
  else if (value.IsType<TByteDynArray>) then
  begin
    tmp2 := value.asType<TByteDynArray>;
    setObjectCount(Length(tmp2), buff);
    buff.SetArray(tmp2);
  end
  else if (value.IsArray) then
  begin
    len := value.GetArrayLength;
    setObjectCount(len, buff);
    for pos := 0 to len - 1 do
    begin
      buff.SetUInt8(value.GetArrayElement(pos).AsType<Byte>);
    end;
  end
  else if (value.isEmpty) then
    SetObjectCount(0, buff)
  else
    raise Exception.Create('Invalid data type.');
end;

// Convert UTF string to DLMS bytes.
class procedure TGXCommon.SetUtfString(buff: TGXByteBuffer; value: TValue);
var tmp : TBytes;
begin
  tmp := TBytes(value.ToString.ToCharArray);
  setObjectCount(Length(tmp), buff);
  buff.SetArray(tmp);
end;

// Convert ASCII string to DLMS bytes.
class procedure TGXCommon.SetString(buff: TGXByteBuffer; value: TValue);
var
  str : String;
begin
  if value.IsEmpty = False Then
  begin
    str := value.ToString;
    SetObjectCount(Length(str), buff);
    buff.SetArray(TEncoding.ASCII.GetBytes(str));
  end
  else
    buff.setUInt8(0);
end;

// Convert time to DLMS bytes.
class procedure TGXCommon.SetTime(buff : TGXByteBuffer; value: TValue);
var
  Hour, Min, Sec, Ms : Word;
  tm: TDateTime;
  skip: TDateTimeSkipsSet;
begin
if value.IsType<TTime> Then
  begin
    tm := TDateTime(value.AsType<TTime>);
    skip.SetOnly(TDateTimeSkips.dkNone);
  end
  else if value.IsType<TDateTime> Then
   begin
    tm := value.AsType<TDateTime>;
    skip.SetOnly(TDateTimeSkips.dkNone);
   end
   else if value.IsType<TGXDateTime> Then
   begin
    tm := value.AsType<TGXDateTime>.Time;
    skip.SetOnly(value.AsType<TGXDateTime>.Skip);
   end
   else
    raise EArgumentException.Create('Invalid Time format.');
  DecodeTime(tm, Hour, Min, Sec, Ms);

  // Add time.
  if skip.Contains(TDateTimeSkips.dkHour) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Hour);

  if skip.Contains(TDateTimeSkips.dkMinute) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Min);

  if skip.Contains(TDateTimeSkips.dkSecond) Then
    buff.setUInt8($FF)
  else
    buff.SetUInt8(Sec);

  // Hundredths of second is not used.
  if skip.Contains(TDateTimeSkips.dkMs) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Round(Ms / 10));
end;

// Convert date to DLMS bytes.
class procedure TGXCommon.SetDate(buff : TGXByteBuffer; value: TValue);
var
  Y, M, D : Word;
  dt: TDateTime;
  skip: TDateTimeSkipsSet;
  extra: TDateTimeExtraInfo;
begin
 extra := TDateTimeExtraInfo.None;
 if value.IsType<TDate> Then
  begin
    dt := TDateTime(value.AsType<TDate>);
    skip.SetOnly(TDateTimeSkips.dkNone);
  end
  else if value.IsType<TDateTime> Then
  begin
    dt := value.AsType<TDateTime>;
    skip.SetOnly(TDateTimeSkips.dkNone);
  end
  else if value.IsType<TGXDateTime> Then
  begin
    dt := value.AsType<TGXDateTime>.Time;
    skip.SetOnly(value.AsType<TGXDateTime>.Skip);
    extra := value.AsType<TGXDateTime>.Extra;
  end
  else
    raise EArgumentException.Create('Invalid Time format.');

  DecodeDate(dt, Y, M, D);
  // Add year.
  if skip.Contains(TDateTimeSkips.dkYear) Then
    buff.SetUInt16($FFFF)
  else
    buff.SetUInt16(Y);

  // Add month
  if Integer(extra) and Integer(TDateTimeExtraInfo.DstBegin) <> 0 then
    buff.SetUInt8($FE)
  else if Integer(extra) and Integer(TDateTimeExtraInfo.DstEnd) <> 0 then
    buff.SetUInt8($FD)
  else if skip.Contains(TDateTimeSkips.dkMonth) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(M);

  // Add day
  if Integer(extra) and Integer(TDateTimeExtraInfo.LastDay) <> 0 then
    buff.SetUInt8($FE)
  else if Integer(extra) and Integer(TDateTimeExtraInfo.LastDay2) <> 0 then
    buff.SetUInt8($FD)
  else if skip.Contains(TDateTimeSkips.dkDay) Then
    buff.setUInt8($FF)
  else
    buff.setUInt8(D);

  if skip.Contains(TDateTimeSkips.dkDayOfWeek) Then
    // Week day is not specified.
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(DateUtils.DayOfTheWeek(dt));
end;

// Convert date time to DLMS bytes.
class procedure TGXCommon.SetDateTime(buff : TGXByteBuffer; value: TValue);
var
  Y, M, D, Hour, Min, Sec, Ms : Word;
  tm: TDateTime;
  deviation: Integer;
  skip: TDateTimeSkipsSet;
  status: TClockStatus;
  extra: TDateTimeExtraInfo;
begin
  status := TClockStatus.ctNone;
  extra := TDateTimeExtraInfo.None;
  deviation := $8000;
  if value.IsType<TDate> Then
  begin
    tm := TDateTime(value.AsType<TDate>);
    skip.SetOnly(TDateTimeSkips.dkNone);
  end
  else if value.IsType<TTime> Then
  begin
    tm := TDateTime(value.AsType<TTime>);
    skip.SetOnly(TDateTimeSkips.dkNone);
  end
  else if value.IsType<TDateTime> Then
  begin
    tm := value.AsType<TDateTime>;
    skip.SetOnly(TDateTimeSkips.dkNone);
  end
  else if value.IsType<TGXDateTime> Then
  begin
    tm := value.AsType<TGXDateTime>.Time;
    skip.SetOnly(value.AsType<TGXDateTime>.Skip);
    deviation := value.AsType<TGXDateTime>.TimeZone;
    status := value.AsType<TGXDateTime>.Status;
    extra := value.AsType<TGXDateTime>.Extra;
  end
  else
    raise EArgumentException.Create('Invalid Time format.');

  DecodeDate(tm, Y, M, D);
  DecodeTime(tm, Hour, Min, Sec, Ms);

  // Add year.
  if skip.Contains(TDateTimeSkips.dkYear) Then
    buff.SetUInt16($FFFF)
  else
    buff.SetUInt16(Y);

  // Add month
  if Integer(extra) and Integer(TDateTimeExtraInfo.DstBegin) <> 0 then
    buff.SetUInt8($FE)
  else if Integer(extra) and Integer(TDateTimeExtraInfo.DstEnd) <> 0 then
    buff.SetUInt8($FD)
  else if skip.Contains(TDateTimeSkips.dkMonth) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(M);

  // Add day
  if Integer(extra) and Integer(TDateTimeExtraInfo.LastDay) <> 0 then
    buff.SetUInt8($FE)
  else if Integer(extra) and Integer(TDateTimeExtraInfo.LastDay2) <> 0 then
    buff.SetUInt8($FD)
  else if skip.Contains(TDateTimeSkips.dkDay) Then
    buff.setUInt8($FF)
  else
    buff.setUInt8(D);

  // Add week day.
  if skip.Contains(TDateTimeSkips.dkDayOfWeek) Then
  // Week day is not specified.
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(DateUtils.DayOfTheWeek(tm));

    // Add time.
  if skip.Contains(TDateTimeSkips.dkHour) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Hour);

  if skip.Contains(TDateTimeSkips.dkMinute) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Min);

  if skip.Contains(TDateTimeSkips.dkSecond) Then
    buff.setUInt8($FF)
  else
    buff.SetUInt8(Sec);

  // Hundredths of second is not used.
  if skip.Contains(TDateTimeSkips.dkMs) Then
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Round(Ms / 10));

  // devitation not used.
  if skip.Contains(TDateTimeSkips.dkDeviation) Then
    buff.SetUInt16($8000)
  else
    // Add devitation.
    buff.setUInt16(deviation);

  // Add clock_status
  if skip.Contains(TDateTimeSkips.dkStatus) Then
    // Status is not used.
    buff.SetUInt8($FF)
  else
    buff.SetUInt8(Integer(Status));
end;

// Convert BCD to DLMS bytes.
class procedure TGXCommon.SetBcd(buff : TGXByteBuffer; value: TValue);
begin
  // Standard supports only size of byte.
  buff.setUInt8(value.AsInteger);
end;

// Convert Array to DLMS bytes.
class procedure TGXCommon.SetArray(buff : TGXByteBuffer; value: TValue);
var
  pos, len : Integer;
  it: TValue;
begin
  if value.IsEmpty = False then
  begin
    len := value.GetArrayLength;
    SetObjectCount(len, buff);
    for pos := 0 to len - 1 do
    begin
      it := value.GetArrayElement(pos);
      if it.IsType<TValue> Then
        it := it.AsType<TValue>;
      SetData(buff, TGXCommon.GetDLMSDataType(it), it);
    end;
  end
  else
    SetObjectCount(0, buff);
end;

// Reserved for internal use.
class procedure TGXCommon.SetData(buff : TGXByteBuffer; dataType : TDataType; value : TValue);
begin
  if ((dataType = TDataType.dtArray) or (dataType = TDataType.dtSTRUCTURE)) and value.IsType<TBytes> then
    // If byte array is added do not add type.
    buff.SetArray(value.AsType<TBytes>)
 else
 begin
    buff.setUInt8(Integer(dataType));
    case dataType of
    dtNONE:
      Exit;
    dtBOOLEAN:
      if value.AsType<Boolean> = true then
        buff.setUInt8(1)
      else
        buff.setUInt8(0);
    dtINT8:
      buff.SetUInt8(value.AsInteger);
    dtUINT8:
      buff.SetUInt8(value.AsInteger);
    dtENUM:
      buff.SetUInt8(value.AsInteger);
    dtINT16:
      buff.SetUInt16(value.AsInteger);
    dtUINT16:
      buff.SetUInt16(value.AsType<WORD>);
    dtINT32:
      buff.SetUInt32(value.AsInteger);
    dtUINT32:
      buff.SetUInt32(value.Cast(TypeInfo(Longword)).AsType<Longword>);
    dtINT64:
      buff.SetUInt64(value.AsUInt64);
    dtUINT64:
      buff.SetUInt64(value.AsUInt64);
    dtFLOAT32:
      buff.SetFloat(value.AsCurrency);
    dtFLOAT64:
      buff.SetDouble(value.AsType<double>);
    dtBITSTRING:
      TGXCommon.SetBitString(buff, value, True);
    dtString:
      SetString(buff, value);
    dtStringUTF8:
      TGXCommon.SetUtfString(buff, value);
    dtOctetString:
      if value.IsEmpty then
        // Add size
        buff.setUInt8(0)
      else if value.IsType<TGXDate> then
      begin
        // Add size
        buff.setUInt8(5);
        TGXCommon.SetDate(buff, value);
      end
      else if value.IsType<TGXTime> then
      begin
        // Add size
        buff.setUInt8(4);
        TGXCommon.SetTime(buff, value);
      end
      else if value.IsType<TGXDateTime> or value.IsType<TDateTime> then
      begin
        // Date an calendar are always written as date time.
        buff.setUInt8(12);
        TGXCommon.SetDateTime(buff, value);
      end
      else
        TGXCommon.SetOctetString(buff, value);
    dtARRAY:
      TGXCommon.SetArray(buff, value);
    dtSTRUCTURE:
      TGXCommon.SetArray(buff, value);
    dtBinaryCodedDesimal:
      TGXCommon.SetBcd(buff, value);
    dtCompactArray:
      raise Exception.Create('Invalid data type.');
    dtDateTime:
      TGXCommon.SetDateTime(buff, value);
    dtDate:
      TGXCommon.SetDate(buff, value);
    dtTime:
      TGXCommon.SetTime(buff, value);
    else
      raise Exception.Create('Invalid data type.');
    end;
 end;
end;

class function TGXCommon.ChangeType(value: TBytes; tp: TDataType): TValue;
var
 bb: TGXByteBuffer;
begin
  bb := TGXByteBuffer.Create(value);
  try
    Result := ChangeType(bb, tp);
  finally
    FreeAndNil(bb);
  end;
end;

class function TGXCommon.ChangeType(value: TGXByteBuffer; tp: TDataType): TValue;
var
  info: TGXDataInfo;
begin
  if (((value = Nil) or (value.Size = 0)) and ((tp = TDataType.dtString) or (tp = TDataType.dtOctetString))) Then
  begin
      Result := '';
      Exit;
  end;
  if value = Nil Then
  begin
    Result := Nil;
    Exit;
  end;
  if tp = TDataType.dtNone Then
  begin
    Result := value.ToHex(True, value.Position, value.Available);
    Exit;
  end;
  if (value.Size = 0) and ((tp = TDataType.dtString) or (tp = TDataType.dtOctetString)) Then
  begin
      Result := '';
      Exit;
  end;
  if (value.Size = 0) and (tp = TDataType.dtDateTime) Then
  begin
      Result := TGXDateTime.Create(TGXDateTime.MinDateTime);
    Exit;
  end;
  if (value.Size = 0) and (tp = TDataType.dtDate) Then
  begin
      Result := TGXDate.Create(TGXDateTime.MinDateTime);
    Exit;
  end;
  if (value.Size = 0) and (tp = TDataType.dtTime) Then
  begin
      Result := TGXTime.Create(TGXDateTime.MinDateTime);
    Exit;
  end;

  info := TGXDataInfo.Create();
  try
    info.&Type := tp;
    Result := TGXCommon.GetData(value, info);
    if Not info.Complete Then
      raise Exception.Create('OutOfMemoryException');
  finally
    freeAndNil(info);
  end;

end;

class function TGXCommon.LogicalNameToBytes(value: String): LogicalName;
var
  len: Integer;
  items: TArray<string>;
begin
  len := Length(value);
  if len <> 0 Then
  begin
    items := value.Split(['.']);
    // If data is string.
    if Length(items) <> 6 Then
      raise EArgumentException.Create('Invalid Logical Name.');

    Result[0] := StrToInt(items[0]);
    Result[1] := StrToInt(items[1]);
    Result[2] := StrToInt(items[2]);
    Result[3] := StrToInt(items[3]);
    Result[4] := StrToInt(items[4]);
    Result[5] := StrToInt(items[5]);
  end;
end;

// Convert DLMS data type to pascal data type.
class function TGXCommon.GetDataType(ADataType : TDataType) : PTypeInfo;
begin
  case ADataType of
    TDataType.dtNone:
        Result := Nil;
    TDataType.dtArray:
        Result := TypeInfo(TValueArray);
    TDataType.dtCompactArray:
        Result := TypeInfo(TValueArray);
    TDataType.dtStructure:
        Result := TypeInfo(TGXStructure);
    TDataType.dtBinaryCodedDesimal:
        Result := TypeInfo(String);
    TDataType.dtBitString:
        Result := TypeInfo(TGXBitString);
    TDataType.dtBoolean:
        Result := TypeInfo(Boolean);
    TDataType.dtDate:
        Result := TypeInfo(TGXDate);
    TDataType.dtDateTime:
        Result := TypeInfo(TGXDateTime);
    TDataType.dtFloat32:
        Result := TypeInfo(Single);
    TDataType.dtFloat64:
        Result := TypeInfo(Double);
    TDataType.dtInt16:
        Result := TypeInfo(Int16);
    TDataType.dtInt32:
        Result := TypeInfo(Int32);
    TDataType.dtInt64:
        Result := TypeInfo(Int64);
    TDataType.dtInt8:
        Result := TypeInfo(ShortInt);
    TDataType.dtOctetString:
        Result := TypeInfo(TBytes);
    TDataType.dtString:
        Result := TypeInfo(String);
    TDataType.dtTime:
        Result := TypeInfo(TGXTime);
    TDataType.dtUInt16:
        Result := TypeInfo(UInt16);
    TDataType.dtUInt32:
        Result := TypeInfo(UInt32);
    TDataType.dtUInt64:
        Result := TypeInfo(UInt64);
    TDataType.dtUInt8:
        Result := TypeInfo(byte);
    TDataType.dtEnum:
        Result := TypeInfo(TGXEnum);
    else
      raise EArgumentException.Create('Invalid DLMS data type.');
    end;
end;

class function TGXCommon.GetDLMSDataType(AValue : TValue) : TDataType;
begin
  //If expected type is not given Result := property type.
  if AValue.IsEmpty Then
  begin
    Result := TDataType.dtNone;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TGXStructure) Then
  begin
     Result := TDataType.dtStructure;
     Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TGXArray) Then
  begin
    Result := TDataType.dtArray;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(Int32) Then
  begin
    Result := TDataType.dtInt32;
    Exit;
  end;
  if (AValue.TypeInfo = TypeInfo(UInt32)) or (AValue.TypeInfo = TypeInfo(Integer)) Then
  begin
    Result := TDataType.dtUInt32;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(String) Then
  begin
    Result := TDataType.dtString;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TGXBitString) Then
  begin
     Result := TDataType.dtBitString;
     Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TGXEnum) Then
  begin
    Result := TDataType.dtEnum;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(byte) Then
  begin
    Result := TDataType.dtUInt8;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(ShortInt) Then
  begin
    Result := TDataType.dtInt8;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(Int16) Then
  begin
    Result := TDataType.dtInt16;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(UInt16) Then
  begin
    Result := TDataType.dtUInt16;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(Int64) Then
  begin
    Result := TDataType.dtInt64;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(UInt64) Then
  begin
    Result := TDataType.dtUInt64;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(Single) Then
  begin
    Result := TDataType.dtFloat32;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(double) Then
  begin
    Result := TDataType.dtFloat64;
    Exit;
  end;
  if (AValue.TypeInfo = TypeInfo(TDateTime)) or (AValue.TypeInfo = TypeInfo(TGXDateTime)) Then
  begin
    Result := TDataType.dtDateTime;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TGXDate) Then
  begin
    Result := TDataType.dtDate;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TGXTime) Then
  begin
    Result := TDataType.dtTime;
    Exit;
  end;
  if (AValue.TypeInfo = TypeInfo(Boolean)) or (AValue.TypeInfo = TypeInfo(Boolean)) Then
  begin
    Result := TDataType.dtBoolean;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TBytes) Then
  begin
    Result := TDataType.dtOctetString;
    Exit;
  end;
  if AValue.TypeInfo = TypeInfo(TValueArray) Then
  begin
    Result := TDataType.dtArray;
    Exit;
  end;
    raise EArgumentException.Create('Failed to convert data type to DLMS data type. Unknown data type.');
end;

class function TGXCommon.GetParameters(optstring: string) : TObjectList<TGXCmdParameter>;
var
  index, pos: Integer;
  str: String;
  c: TGXCmdParameter;
begin
  index := 1;

  Result := TObjectList<TGXCmdParameter>.Create();
  try

    while index <= ParamCount do
    begin
      str := ParamStr(index);

      if (str.Chars[0] <> '-') and (str.Chars[0] <> '/') Then
        raise EArgumentException.Create('Invalid parameter: ' + str);

      pos := optstring.IndexOf(str.Chars[1]);
      if pos = -1 Then
        raise EArgumentException.Create('Invalid parameter: ' + str);

      c := TGXCmdParameter.Create();
      try
        c.Tag := str.Chars[1];
      except
        c.Free;
        raise;
      end;
      Result.Add(c);
      if (pos < Length(optstring) -1 )and (optstring.Chars[1 + pos] = ':') Then
      begin
        index := index + 1;
        if ParamCount <= index Then
          c.Missing := true;

        c.Value := ParamStr(index);
      end;
      index := index + 1;
    end;

  except
    result.Free;
    raise;
  end;
end;

class function TGXCommon.ToHexString(bytes : TBytes; addSpace : Boolean; Index : Integer; Count : Integer): String;
var
  p, pos, tmp, add : Integer;
  begin
  if addSpace then
  begin
    add  := 3;
    Result := String.Create(' ', (Count * add) - 1);
  end
  else
  begin
    add := 2;
    Result := String.Create(' ', (Count * add));
  end;
  p := 0;
  for pos := 0 to Count - 1 do
  begin
    tmp := bytes[Index + pos];
    Result[p + 1] := hexArray[tmp Shr 4];
    Result[p + 2] := hexArray[tmp and $0F];
    p := p + add;
  end;
end;

class function TGXCommon.IsAsciiString(value: TBytes): Boolean;
var
  pos: Integer;
  it: BYTE;
begin
  Result := True;
  if value <> Nil Then
    for pos := 0 to Length(value)- 1 do
    begin
      it := value[pos];
      if (it < 32) or (it > 127) and (it <> $10) and (it <> $13) and (it <> 0) Then
      begin
        Result := False;
        break;
      end;
    end;
end;

class function TGXCommon.IsNumeric(value: TValue): Boolean;
begin
  Result := (value.TypeInfo = TypeInfo(BYTE)) or
            (value.TypeInfo = TypeInfo(UInt16)) or
            (value.TypeInfo = TypeInfo(UInt32)) or
            (value.TypeInfo = TypeInfo(UInt64)) or
            (value.TypeInfo = TypeInfo(char)) or
            (value.TypeInfo = TypeInfo(Int16)) or
            (value.TypeInfo = TypeInfo(Int32)) or
            (value.TypeInfo = TypeInfo(Int64));
end;
end.

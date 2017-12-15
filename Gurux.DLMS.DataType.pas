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

unit Gurux.DLMS.DataType;

interface
type

//DataType enumerates usable types of data in GuruxDLMS.

TDataType =
(
  //Data type is Array.
  // DLMS/COSEM type is: array.
  dtArray = 1,
  //Data type is Binary coded decimal.
  // DLMS/COSEM type is: bcd.
  dtBinaryCodedDesimal = 13,
  //Data type is Bit string.
  // DLMS/COSEM type is: bit-string.
  dtBitString = 4,
  //Data type is Boolean.
  // DLMS/COSEM type is: boolean.
  dtBoolean = 3,
  //Data type is Compact array.
  // DLMS/COSEM type is: compact array.
  dtCompactArray = 19,
  //Data type is Date.
  // DLMS/COSEM type is: date.
  dtDate = 26,
  //Data type is DateTime.
  // DLMS/COSEM type is: date_time.
  dtDateTime = 25,
  //Data type is Enum.
  // DLMS/COSEM type is: enum.
  dtEnum = 22,
  //Data type is Float32.
  // DLMS/COSEM type is: float 32.
  dtFloat32 = 23,
  //Data type is Float64.
  // DLMS/COSEM type is: float 64.
  dtFloat64 = 24,
  //Data type is Int16.
  // DLMS/COSEM type is: long.
  dtInt16 = $10,
  //Data type is Int32.
  // DLMS/COSEM type is: double-long.
  dtInt32 = 5,
  //Data type is Int64.
  // DLMS/COSEM type is: Integer64.
  dtInt64 = 20,
  //Data type is Int8.
  // DLMS/COSEM type is: integer.
  dtInt8 = 15,
  //By default, no data type is set.
  // DLMS/COSEM type is: null-data.
  dtNone = 0,
  //Data type is Octet string.
  // DLMS/COSEM type is: octet-string.
  dtOctetString = 9,
  //Data type is String.
  // DLMS/COSEM type is: visible-string.
  dtString = 10,
  //Data type is UTF8 String.
  // DLMS/COSEM type is: utf8-string.
  dtStringUTF8 = 12,
  //Data type is Structure.
  // DLMS/COSEM type is: structure.
  dtStructure = 2,
  //Data type is Time.
  // DLMS/COSEM type is: time.
  dtTime = $1b,
  //Data type is UInt16.
  // DLMS/COSEM type is: long-unsigned.
  dtUInt16 = $12,
  //Data type is UInt32.
  // DLMS/COSEM type is: double-longunsigned.
  dtUInt32 = 6,
  //Data type is UInt64.
  // DLMS/COSEM type is: long64-unsigned.
  dtUInt64 = $15,
  //Data type is UInt8.
  // DLMS/COSEM type is: unsigned.
  dtUInt8 = $11
);

implementation

end.

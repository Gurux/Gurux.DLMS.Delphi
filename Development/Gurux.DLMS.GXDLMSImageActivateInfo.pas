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

unit Gurux.DLMS.GXDLMSImageActivateInfo;

interface

type

TGXDLMSImageActivateInfo = class
  FSize : LongWord;
  FIdentification, FSignature : string;

  // Image size is the size of the Image(s) to be activated. Expressed in octets;
  property Size: LongWord read FSize write FSize;

  /// Image identification is the identification of the Image(s)
  /// to be activated, and may contain information like
  /// manufacturer, device type, version information, etc.
  property Identification: string read FIdentification write FIdentification;

  // Image signature is the signature of the Image(s) to be activated.
  property Signature: string read FSignature write FSignature;

end;
implementation

end.

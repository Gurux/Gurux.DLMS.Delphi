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

unit Gurux.GXMD5;

interface
uses IdHashMessageDigest, IdGlobal,
  //Old Windows versions need this.
  GXByteBuffer, SysUtils, Math;

type
TGXMD5 = class
  public
   class function Encrypt(data: TBytes): TBytes;

end;
implementation

class function TGXMD5.Encrypt(data: TBytes): TBytes;
var
  idmd5 : TIdHashMessageDigest5;
begin
  if TOSVersion.Major >= 10 then
  begin
    //Windows 10 can use API.
    idmd5 := TIdHashMessageDigest5.Create;
  try
    Result := TBytes(idmd5.HashBytes(TIdBytes(data)));
   finally
     idmd5.Free;
   end;
  end;
end;
end.

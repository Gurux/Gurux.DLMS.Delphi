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

unit GXXmlWriter;

interface
uses Generics.Collections,
XMLDoc,
xmldom,
XMLIntf,
msxmldom,
SysUtils;

type
TGXXmlWriter = class
  FElements: TList<IXMLNode>;
  FDOC: TXMLDocument;
public
  constructor Create;
  procedure WriteStartElement(AName: string);
  procedure WriteElementString(AName: string; AValue: string); overload;
  procedure WriteElementString(AName: string; AValue: integer); overload;
  procedure WriteEndElement();
  procedure Save(APath: string);
  destructor Destroy; override;
end;
implementation

constructor TGXXmlWriter.Create;
begin
  FDOC := TXMLDocument.Create(Nil);
  FDOC.Options := FDOC.Options + [doNodeAutoIndent];
  FDOC.Active := true;
  FDOC.Encoding := 'UTF-8';
  FElements := TList<IXMLNode>.Create;
end;

procedure TGXXmlWriter.WriteStartElement(AName: string);
begin
  if FElements.Count = 0 then
  begin
    FDOC.DocumentElement := FDOC.CreateElement(AName, '');
    FElements.Add(FDOC.DocumentElement)
  end
  else
    FElements.Add(FElements[FElements.Count - 1].AddChild(AName));
end;

procedure TGXXmlWriter.WriteElementString(AName: string; AValue: string);
begin
  FElements[FElements.Count - 1].AddChild(AName).Text := AValue;
end;

procedure TGXXmlWriter.WriteElementString(AName: string; AValue: Integer);
begin
  WriteElementString(AName, IntToStr(AValue));
end;

procedure TGXXmlWriter.WriteEndElement();
begin
  FElements.Delete(FElements.Count - 1);
end;

procedure TGXXmlWriter.Save(APath: string);
begin
  FDOC.SaveToFile(APath);
  FDOC.Active := False;
end;

destructor TGXXmlWriter.Destroy;
begin
  inherited;
  FDOC.Free;
  FElements.Clear;
  FElements.Free;
end;
end.

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

unit GXXmlReader;

interface

uses Generics.Collections,
Classes,
XMLDoc,
xmldom,
XMLIntf,
msxmldom,
SysUtils;

type
TGXXmlReader = class
  FNode: IXmlNode;
  FIndex: Integer;
  FDOC: TXMLDocument;
  class function GetNextNode(ANode: IXmlNode): IXmlNode;
  public
    constructor Create(APath: string);
    function GetName: string;
    function IsEOF: Boolean;
    function IsStartElement: Boolean;
    procedure Read();
    function ReadElementContentAsInt(AName: string): Integer;
    function ReadElementContentAsString(AName: string): string;
    destructor Destroy; override;
end;
implementation

constructor TGXXmlReader.Create(APath: string);
begin
  FDOC := TXMLDocument.Create(TComponent.Create(Nil));
  FDOC.Options := FDOC.Options + [doNodeAutoIndent];
  FDOC.LoadFromFile(APath);
  FDOC.Active := true;
  if FDOC.ChildNodes.Count <> 0 then
    FNode := FDOC.ChildNodes[1];
end;

function TGXXmlReader.GetName: string;
begin
  Result := FNode.LocalName;
end;

function TGXXmlReader.IsEOF: Boolean;
begin
  Result := FNode = Nil;
end;

function TGXXmlReader.IsStartElement: Boolean;
begin
  Result := FNode.NodeType = TNodeType.ntElement;
end;

class function TGXXmlReader.GetNextNode(ANode: IXmlNode): IXmlNode;
begin
  if ANode.ParentNode = Nil then
    Exit;
  if ANode.ParentNode.NextSibling() = Nil then
    Result := GetNextNode(ANode.ParentNode)
  else
    Result := ANode.ParentNode.NextSibling();
end;

procedure TGXXmlReader.Read();
begin
  if FNode.ChildNodes.Count <> 0 then
    FNode := FNode.ChildNodes[0]
  else
  begin
    if FNode.NextSibling() = Nil then
      FNode := GetNextNode(FNode)
    else
      FNode := FNode.NextSibling();
  end;
end;

function TGXXmlReader.ReadElementContentAsInt(AName: string): Integer;
begin
  Result := StrToInt(ReadElementContentAsString(AName));
end;

function TGXXmlReader.ReadElementContentAsString(AName: string): string;
begin
  if FNode.LocalName = AName then
  begin
    Read();
    Result := FNode.Text;
    Read();
  end;
end;

destructor TGXXmlReader.Destroy;
begin
  inherited;
  FDOC.Free;
end;

end.

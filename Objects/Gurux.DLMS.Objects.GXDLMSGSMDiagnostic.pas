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

unit Gurux.DLMS.Objects.GXDLMSGSMDiagnostic;

interface

uses
  GXCommon,
  SysUtils,
  Rtti,
  System.Generics.Collections,
  Gurux.DLMS.ObjectType,
  Gurux.DLMS.DataType,
  Gurux.DLMS.GXDLMSObject,
  Gurux.DLMS.GXDateTime,
  GXByteBuffer;

type
  TRegStatus = ( rsNot, rsRegHome, rsSearching, rsDenied, rsUnknown, rsRoaming );

  TPSStatus = ( pssInactive, pssGPRS, pssEDGE, pssUMTS, pssHSDPA );

  TPSStatusHelper = record helper for TPSStatus
    function AsString: String;
  end;

  TCSAttachment = (cssInactive,cssIncoming,cssActive);
  TCSAttachmentHelper = record helper for TCSAttachment
    function AsString: String;
  end;

  TSignalQuality = record
    var
      FSignalQuality: Byte;
    constructor Create(val: Byte);
    function AsString: string;
  end;

  TAdjacentCellInfo = record
    strict private
      FCellId: Word;
      FSignalQuality: TSignalQuality;
    public
      constructor Create(const ACellId: Word; const ASigQual: Byte);
      property CellId: Word read FCellId;
      property SignalQuality: TSignalQuality read FSignalQuality;
  end;

  TCellInfo = class
    strict private
      FCellId: Word;
      FLocationId: Word;
      FSignalQuality: TSignalQuality;
      FBER: Byte;
    public
      constructor Create(const ACellId: Word = 0; const ALocationId: Word = 0; const ASigQual: Byte = 0; const ABER: Byte = 0);
      property CellId: word read FCellId;
      property LocationId: Word read FLocationId;
      property SignalQuality: TSignalQuality read FSignalQuality;
      property BER: Byte read FBER;
  end;

  TGXDLMSGSMDiagnostic = class(TGXDLMSObject)
    private
    FOperator: String;
    FStatus: TRegStatus;
    FCSAttachment: TCSAttachment;
    FPSStatus: TPSStatus;
    FCellInfo: TCellInfo;
    FAdjacentCells: TList<TAdjacentCellInfo>;
    FCaptureTime: TGXDateTime;

    public
    constructor Create; overload;
    constructor Create(ln: string); overload;
    constructor Create(ln: string; sn: System.UInt16); overload;
    destructor Destroy; override;

    property &Operator: String read FOperator write FOperator;
    property Status: TRegStatus read FStatus write FStatus;
    property CSAttachment: TCSAttachment read FCSAttachment write FCSAttachment;
    property PSStatus: TPSStatus read FPSStatus write FPSStatus;
    property CellInfo: TCellInfo read FCellInfo write FCellInfo;
    property AdjacentCells: TList<TAdjacentCellInfo> read FAdjacentCells;
    property CaptureTime: TGXDateTime read FCaptureTime write FCaptureTime;

    function GetValues() : TArray<TValue>;override;

    function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;override;
    function GetAttributeCount: Integer;override;
    function GetMethodCount: Integer;override;
    function GetDataType(index: Integer): TDataType;override;
    function GetValue(e: TValueEventArgs): TValue;override;
    procedure SetValue(e: TValueEventArgs);override;
    function Invoke(e: TValueEventArgs): TBytes;override;
  end;

implementation

constructor TGXDLMSGSMDiagnostic.Create;
begin
  Create('', 0);
end;

constructor TGXDLMSGSMDiagnostic.Create(ln: string);
begin
  Create(ln, 0);
end;

constructor TGXDLMSGSMDiagnostic.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otGSMDiagnostic, ln, 0);
  FCellInfo := TCellInfo.Create;
  FAdjacentCells := TList<TAdjacentCellInfo>.Create;
end;

destructor TGXDLMSGSMDiagnostic.Destroy;
begin
  inherited;
  FCellInfo.Free;
  FAdjacentCells.Free;
end;


function TGXDLMSGSMDiagnostic.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);

    //Operator
    if All or not IsRead(2) Then
      items.Add(2);

    //Status
    if All or CanRead(3) Then
      items.Add(3);

    //CS Attachment
    if All or CanRead(4) Then
      items.Add(4);

    //PS Status
    if All or CanRead(5) Then
      items.Add(5);

    //CelLInfo
    if All or CanRead(6) Then
      items.Add(6);

    //AdjacentCells
    if All or CanRead(7) Then
      items.Add(7);

    //CaptureTime
    if All or CanRead(8) Then
      items.Add(8);

    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSGSMDiagnostic.GetAttributeCount: Integer;
begin
  Result := 8;
end;

function TGXDLMSGSMDiagnostic.GetMethodCount: Integer;
begin
  Result := 0;
end;

function TGXDLMSGSMDiagnostic.GetDataType(index: Integer): TDataType;
begin
 case index of
    1: Result := TDataType.dtOctetString;
    2: Result := TDataType.dtString;
    3: Result := TDataType.dtEnum;
    4: Result := TDataType.dtEnum;
    5: Result := TDataType.dtEnum;
    6: Result := TDataType.dtStructure;
    7: Result := TDataType.dtArray;
    8: Result := TDataType.dtDateTime;
    else
      raise Exception.Create('GetDataType failed. Invalid attribute index.');
  end;
end;

function TGXDLMSGSMDiagnostic.GetValues: TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FOperator, TValue.From(FStatus),
    TValue.From(FCSAttachment), TValue.From(FPSStatus),
    FCellInfo, FAdjacentCells, FCaptureTime);
end;

function TGXDLMSGSMDiagnostic.GetValue(e: TValueEventArgs): TValue;
var
 bb: TGXByteBuffer;
 it: TAdjacentCellInfo;
begin
  case e.Index Of
    1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
    2: Result := TValue.From(TGXCommon.GetBytes(FOperator));
    3: Result := Integer(FStatus);
    4: Result := Integer(FCSAttachment);
    5: Result := Integer(FPSStatus);
    6:
    begin
      bb := TGXByteBuffer.Create;
      try
        bb.SetUInt8(Integer(TDataType.dtStructure));
        if Version = 0 Then
        begin
          bb.SetUInt8(4);
          TGXCommon.SetData(bb, TDataType.dtUInt16, FCellInfo.CellId);
        end
        else
        begin
          bb.SetUInt8(7);
          TGXCommon.SetData(bb, TDataType.dtUInt32, FCellInfo.CellId);
        end;
        TGXCommon.SetData(bb, TDataType.dtUInt16, FCellInfo.LocationId);
        TGXCommon.SetData(bb, TDataType.dtUInt8, BYTE(FCellInfo.SignalQuality));
        TGXCommon.SetData(bb, TDataType.dtUInt8, BYTE(FCellInfo.Ber));
        {
        if Version > 0 Then
        begin
          TGXCommon.SetData(bb, TDataType.dtUInt16, Integer(FCellInfo.MobileCountryCode));
          TGXCommon.SetData(bb, TDataType.dtUInt16, Integer(FCellInfo.MobileNetworkCode));
          TGXCommon.SetData(bb, TDataType.dtUInt32, Integer(FCellInfo.ChannelNumber));
        end;
        }
        Result := TValue.From(bb.ToArray());
      finally
        FreeAndNil(bb);
      end;
    end;
    7:
    begin
      bb := TGXByteBuffer.Create;
        try
        bb.SetUInt8(Integer(TDataType.dtArray));
        bb.SetUInt8(FAdjacentCells.Count);
        for it in FAdjacentCells do
        begin
          bb.SetUInt8(Integer(TDataType.dtStructure));
          bb.SetUInt8(2);
          if Version = 0 Then
            TGXCommon.SetData(bb, TDataType.dtUInt16, it.CellId)
          else
            TGXCommon.SetData(bb, TDataType.dtUInt32, it.CellId);

          TGXCommon.SetData(bb, TDataType.dtUInt8, it.SignalQuality.FSignalQuality);
        end;
        Result := TValue.From(bb.ToArray());
      finally
        FreeAndNil(bb);
      end;
    end;
    8: Result := FCaptureTime;
    else
      raise Exception.Create('GetValue failed. Invalid attribute index.');
  end;
end;

procedure TGXDLMSGSMDiagnostic.SetValue(e: TValueEventArgs);
var
  item : TValue;
  it : TAdjacentCellInfo;
  tmp : TArray<TValue>;
begin
  if e.Index = 1 then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FOperator := e.Value.AsString;
  end
  else if e.Index = 3 Then
  begin
    FStatus := TRegStatus(e.Value.AsInteger);
  end
  else if e.Index = 4 Then
  begin
    FCSAttachment:= TCSAttachment(e.Value.AsInteger);
  end
  else if e.Index = 5 Then
  begin
    FPSStatus := TPSStatus(e.Value.AsInteger);
  end
  else if e.Index = 6 Then
  begin
    if e.Value.IsEmpty Then
      FCellInfo := TCellInfo.Create
    else
      begin
        if e.Value.IsType<TArray<TValue>>() Then
          begin
          tmp := e.Value.AsType<TArray<TValue>>();
          if Length(tmp) = 0 Then
            begin
              FCellInfo := TCellInfo.Create;
            end
          else
            begin
              FCellInfo := TCellInfo.Create(
                            tmp[0].AsInteger,
                            tmp[1].AsInteger,
                            tmp[2].AsInteger,
                            tmp[3].AsInteger);
            end;
          end;
      end;
  end
  else if e.Index = 7 Then
  begin
    FAdjacentCells.Clear;
    if Not e.Value.IsEmpty then
    begin
      for item in e.Value.AsType<TArray<TValue>> do
      begin
          it := TAdjacentCellInfo.Create(
            item.GetArrayElement(0).AsType<TValue>.AsInteger,
            item.GetArrayElement(1).AsType<TValue>.AsInteger);
          FAdjacentCells.Add(it);
      end;
    end;
  end
  else if e.Index = 8 Then
  begin
    if e.Value.IsEmpty Then
        FCaptureTime := TGXDateTime.Create(TGXDateTime.MinDateTime)
      else
      begin
        if e.Value.IsType<TBytes> Then
          e.Value := TGXCommon.ChangeType(e.Value.AsType<TBytes>, TDataType.dtDateTime);
        FCaptureTime := e.Value.AsType<TGXDateTime>;
      end;
  end
  else
  begin
    raise Exception.Create('SetValue failed. Invalid attribute index.');
  end
end;

function TGXDLMSGSMDiagnostic.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;


{ TCellInfo }
constructor TCellInfo.Create(const ACellId: Word; const ALocationId: Word; const ASigQual: Byte; const ABER: Byte);
begin
  FCellId := ACellId;
  FLocationId := ALocationId;
  FSignalQuality := TSignalQuality.Create(ASigQual);
  FBER := ABER;
end;

{ TSignalQuality }
function TSignalQuality.AsString: String;
var
  tmp: Integer;
begin
  if FSignalQuality > 31 then
    Result := ' - dBm'
  else
    begin
      tmp := (-113 + 2*FSignalQuality);
      Result := format('%d dBm',[tmp]);
    end;
end;

constructor TSignalQuality.Create(val: Byte);
begin
  FSignalQuality := val;
end;

{ TPSStatusHelper }

function TPSStatusHelper.AsString: String;
begin
  case self of
    pssInactive: Result := 'Inactive';
    pssGPRS: Result := 'GPRS';
    pssEDGE: Result := 'EDGE';
    pssUMTS: Result := 'UMTS';
    pssHSDPA: Result := 'HSDPA';
  end;
end;

{ TAdjacentCellInfo }

constructor TAdjacentCellInfo.Create(const ACellId: Word; const ASigQual: Byte);
begin
  FCellId := ACellId;
  FSignalQuality := TSignalQuality.Create(ASigQual);
end;

{ TCSAttachmentHelper }

function TCSAttachmentHelper.AsString: String;
begin
  case self of
    cssInactive: Result := 'inactive';
    cssIncoming: Result := 'incoming call';
    cssActive: Result := 'active';
  end;
end;

end.

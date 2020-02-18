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

unit Gurux.DLMS.Objects.GXDLMSImageTransfer;

interface

uses GXCommon, SysUtils, Rtti, System.Generics.Collections,
Gurux.DLMS.ObjectType, Gurux.DLMS.GXDLMSImageActivateInfo,
Gurux.DLMS.DataType, Gurux.DLMS.GXDLMSObject,
Gurux.DLMS.ImageTransferStatus, GXByteBuffer,
Gurux.DLMS.ErrorCode, Gurux.DLMS.IGXDLMSClient,
System.Math;

type
TGXDLMSImageTransfer = class(TGXDLMSObject)
  private
  FImageBlockSize, FImageFirstNotTransferredBlockNumber : WORD;
  FImageTransferredBlocksStatus : string;
  FImageTransferEnabled : Boolean;
  FImageTransferStatus : TImageTransferStatus;
  FImageActivateInfo : TObjectList<TGXDLMSImageActivateInfo>;
  function GetImageActivateInfo(): TValue;

  public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(ln: string); overload;
  constructor Create(ln: string; sn: System.UInt16); overload;

  //Holds the ImageBlockSize, expressed in octets, which can be handled by the server.
  property ImageBlockSize: WORD read FImageBlockSize write FImageBlockSize;

  // Provides information about the transfer status of each ImageBlock.
  // Each bit in the bit-string provides information about one individual ImageBlock.
  property ImageTransferredBlocksStatus: string read FImageTransferredBlocksStatus write FImageTransferredBlocksStatus;

  //Provides the ImageBlockNumber of the first ImageBlock not transferred.
  property ImageFirstNotTransferredBlockNumber:  WORD read FImageFirstNotTransferredBlockNumber write FImageFirstNotTransferredBlockNumber;

  //Controls enabling the Image transfer process. The method can
  // be invoked successfully only if the value of this attribute is true.
  property ImageTransferEnabled:  Boolean read FImageTransferEnabled write FImageTransferEnabled;

  //Holds the status of the Image transfer process.
  property ImageTransferStatus:  TImageTransferStatus read FImageTransferStatus write FImageTransferStatus;

  property ImageActivateInfo : TObjectList<TGXDLMSImageActivateInfo> read FImageActivateInfo;


  function GetValues() : TArray<TValue>;override;

  function GetAttributeIndexToRead(All: Boolean): TArray<Integer>;override;
  function GetAttributeCount: Integer;override;
  function GetMethodCount: Integer;override;
  function GetDataType(index: Integer): TDataType;override;
  function GetValue(e: TValueEventArgs): TValue;override;
  procedure SetValue(e: TValueEventArgs);override;
  function Invoke(e: TValueEventArgs): TBytes;override;

  function ImageTransferInitiate(client: IGXDLMSClient; imageIdentifier: String; imageSize: Integer) : TArray<TBytes>;

  function ImageBlockTransfer(client: IGXDLMSClient; imageBlockValue: TBytes; ImageBlockCount : PInteger) : TArray<TBytes>;

  //Verifies the image.
  function ImageVerify(client: IGXDLMSClient) : TArray<TBytes>;

  //Activates the image.
  function ImageActivate(client: IGXDLMSClient) : TArray<TBytes>;
end;

implementation

constructor TGXDLMSImageTransfer.Create;
begin
  inherited Create(TObjectType.otImageTransfer);
  FImageActivateInfo := TObjectList<TGXDLMSImageActivateInfo>.Create;
end;

constructor TGXDLMSImageTransfer.Create(ln: string);
begin
  inherited Create(TObjectType.otImageTransfer, ln, 0);
  FImageActivateInfo := TObjectList<TGXDLMSImageActivateInfo>.Create;
end;

constructor TGXDLMSImageTransfer.Create(ln: string; sn: System.UInt16);
begin
  inherited Create(TObjectType.otImageTransfer, ln, 0);
  FImageActivateInfo := TObjectList<TGXDLMSImageActivateInfo>.Create;
end;

destructor TGXDLMSImageTransfer.Destroy;
begin
  inherited;
  FreeAndNil(FImageActivateInfo);
end;

function TGXDLMSImageTransfer.ImageTransferInitiate(client: IGXDLMSClient; imageIdentifier: String; imageSize: Integer) : TArray<TBytes>;
var
  data: TGXByteBuffer;
begin
  if ImageBlockSize = 0 Then
    raise Exception.Create('Invalid image block size.');

  if FImageBlockSize > client.GetMaxReceivePDUSize Then
                raise Exception.Create('Image block size is bigger than max PDU size.');
  data := TGXByteBuffer.Create();
  try
    data.SetUInt8(Integer(TDataType.dtStructure));
    data.SetUInt8(2);
    TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(imageIdentifier)));
    TGXCommon.SetData(data, TDataType.dtUInt32, imageSize);
    Result := client.Method(Self, 1, TValue.From(data.ToArray()), TDataType.dtArray);
  finally
    FreeAndNil(data);
  end;

end;

function TGXDLMSImageTransfer.ImageBlockTransfer(client: IGXDLMSClient; imageBlockValue: TBytes; ImageBlockCount : PInteger) : TArray<TBytes>;
var
  packets: TList<TBytes>;
  bytes, pos: Integer;
  data: TGXByteBuffer;
  tmp: TBytes;
begin
  ImageBlockCount^ := Floor(Length(imageBlockValue) / FImageBlockSize);
  if (Length(imageBlockValue) Mod FImageBlockSize) <> 0 Then
    ImageBlockCount^ := ImageBlockCount^ + 1;

  packets := TList<TBytes>.Create();
  try
    for pos := 0 to ImageBlockCount^ - 1 do
    begin
      data := TGXByteBuffer.Create();
      try
        data.SetUInt8(Integer(TDataType.dtStructure));
        data.SetUInt8(2);
        TGXCommon.SetData(data, TDataType.dtUInt32, pos);
        bytes := (Length(imageBlockValue) - ((pos + 1) * FImageBlockSize));
        tmp := TBytes.Create();
        //If last packet
        if bytes < 0 Then
        begin
          bytes := (Length(imageBlockValue) - (pos * FImageBlockSize));
          SetLength(tmp, bytes);
          System.Move(imageBlockValue[pos * FImageBlockSize], tmp[0], bytes);
        end
        else
        begin
          SetLength(tmp, FImageBlockSize);
          System.Move(imageBlockValue[pos * FImageBlockSize], tmp[0], FImageBlockSize);
        end;
        TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(tmp));
        packets.AddRange(client.Method(Self, 2, TValue.From(data.ToArray()), TDataType.dtArray));
      finally
        FreeAndNil(data);
      end;
    end;
    Result := packets.ToArray();
  finally
    FreeAndNil(packets);
  end;
end;

//Verifies the image.
function TGXDLMSImageTransfer.ImageVerify(client: IGXDLMSClient) : TArray<TBytes>;
begin
  Result := client.Method(Self, 3, 0, TDataType.dtInt8);
end;

//Activates the image.
function TGXDLMSImageTransfer.ImageActivate(client: IGXDLMSClient) : TArray<TBytes>;
begin
  Result := client.Method(Self, 4, 0, TDataType.dtInt8);
end;

function TGXDLMSImageTransfer.GetValues() : TArray<TValue>;
begin
  Result := TArray<TValue>.Create(FLogicalName, FImageBlockSize,
  FImageTransferredBlocksStatus, FImageFirstNotTransferredBlockNumber,
  FImageTransferEnabled, Integer(FImageTransferStatus), FImageActivateInfo);
end;

function TGXDLMSImageTransfer.GetAttributeIndexToRead(All: Boolean): TArray<Integer>;
var
  items : TList<Integer>;
begin
  items := TList<Integer>.Create;
  try
    //LN is static and read only once.
    if All or string.IsNullOrEmpty(LogicalName) then
      items.Add(1);
    //ImageBlockSize
    if All or Not IsRead(2) Then
      items.Add(2);
    //ImageTransferredBlocksStatus
    if All or Not IsRead(3) Then
      items.Add(3);
    //ImageFirstNotTransferredBlockNumber
    if All or Not IsRead(4) Then
      items.Add(4);
    //ImageTransferEnabled
    if All or Not IsRead(5) Then
      items.Add(5);
    //ImageTransferStatus
    if All or Not IsRead(6) Then
      items.Add(6);
    //ImageActivateInfo
    if All or Not IsRead(7) Then
      items.Add(7);
    Result := items.ToArray;
  finally
    FreeAndNil(items);
  end;
end;

function TGXDLMSImageTransfer.GetAttributeCount: Integer;
begin
  Result := 7;
end;

function TGXDLMSImageTransfer.GetMethodCount: Integer;
begin
  Result := 4;
end;

function TGXDLMSImageTransfer.GetDataType(index: Integer): TDataType;
begin
  if (index = 1) then
  begin
    Result := TDataType.dtOctetString;
  end
  else if index = 2 Then
  begin
      Result := TDataType.dtUInt32;
  end
  else if index = 3 Then
  begin
      Result := TDataType.dtBitString;
  end
  else if index = 4 Then
  begin
      Result := TDataType.dtUInt32;
  end
  else if index = 5 Then
  begin
      Result := TDataType.dtBoolean;
  end
  else if index = 6 Then
  begin
      Result := TDataType.dtEnum;
  end
  else if index = 7 Then
  begin
      Result := TDataType.dtArray;
  end
  else
  	raise Exception.Create('GetDataType failed. Invalid attribute index.');
end;

function TGXDLMSImageTransfer.GetImageActivateInfo(): TValue;
var
  data: TGXByteBuffer;
  it: TGXDLMSImageActivateInfo;
begin
  data := TGXByteBuffer.Create();
  try
    data.SetUInt8(Integer(TDataType.dtArray));
    if FImageActivateInfo = Nil Then
        TGXCommon.SetObjectCount(0, data)
    else
    begin
      TGXCommon.SetObjectCount(FImageActivateInfo.Count, data);
      for it in FImageActivateInfo do
      begin
        data.SetUInt8(Integer(TDataType.dtStructure));
        data.SetUInt8(3);
        TGXCommon.SetData(data, TDataType.dtUInt32, it.Size);
        TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(it.Identification)));
        TGXCommon.SetData(data, TDataType.dtOctetString, TValue.From(TGXCommon.GetBytes(it.Signature)));
      end;
    end;
    Result := TValue.From(data.ToArray());
  finally
    FreeAndNil(data);
  end;
end;

function TGXDLMSImageTransfer.GetValue(e: TValueEventArgs): TValue;
begin
  case e.Index of
  1: Result := TValue.From(TGXDLMSObject.GetLogicalName(FLogicalName));
  2: Result := FImageBlockSize;
  3: Result := FImageTransferredBlocksStatus;
  4: Result := FImageFirstNotTransferredBlockNumber;
  5: Result := FImageTransferEnabled;
  6: Result := Integer(FImageTransferStatus);
  7: Result := GetImageActivateInfo();
  else
    e.Error := TErrorCode.ecReadWriteDenied;
  end;
end;

procedure TGXDLMSImageTransfer.SetValue(e: TValueEventArgs);
var
  it : TValue;
  item : TGXDLMSImageActivateInfo;
begin
  if (e.Index = 1) then
  begin
    FLogicalName := TGXCommon.ToLogicalName(e.Value);
  end
  else if e.Index = 2 Then
  begin
    FImageBlockSize := e.Value.AsInteger;
  end
  else if e.Index = 3 Then
  begin
    FImageTransferredBlocksStatus := e.Value.ToString;
  end
  else if e.Index = 4 Then
  begin
    FImageFirstNotTransferredBlockNumber := e.Value.AsInteger;
  end
  else if e.Index = 5 Then
  begin
    FImageTransferEnabled := e.Value.AsBoolean;
  end
  else if e.Index = 6 Then
  begin
    FImageTransferStatus := TImageTransferStatus(e.Value.AsInteger);
  end
  else if e.Index = 7 Then
  begin
    FImageActivateInfo.Clear;
    if Not e.Value.IsEmpty Then
    begin
      for it in e.Value.AsType<TArray<TValue>> do
      begin
        item := TGXDLMSImageActivateInfo.Create();
        try
          item.Size := it.GetArrayElement(0).AsType<TValue>.AsInteger;
          item.Identification := TGXCommon.ChangeType(it.GetArrayElement(1).AsType<TValue>.AsType<TBytes>,
                              TDataType.dtString).toString();
          item.Signature := TGXCommon.ChangeType(it.GetArrayElement(2).AsType<TValue>.AsType<TBytes>,
                              TDataType.dtString).toString();
        except
          item.Free;
          raise;
        end;
        FImageActivateInfo.Add(item);
      end;
    end;
  end
  else
    raise Exception.Create('SetValue failed. Invalid attribute index.');
end;

function TGXDLMSImageTransfer.Invoke(e: TValueEventArgs): TBytes;
begin
  raise Exception.Create('Invoke failed. Invalid attribute index.');
end;

end.

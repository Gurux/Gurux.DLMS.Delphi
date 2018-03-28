unit Gurux.DLMS.TGXxDLMSContextType;

interface

uses SysUtils, Gurux.DLMS.Conformance;

type

TGXxDLMSContextType = class
  FConformance : TConformance;
  FMaxReceivePduSize, FMaxSendPduSize : Word;

  FDlmsVersionNumber : byte;
  FQualityOfService : ShortInt;
  FCypheringInfo : TBytes;

 public
  property Conformance: TConformance read FConformance write FConformance;

  property MaxReceivePduSize: Word read FMaxReceivePduSize write FMaxReceivePduSize;

  property MaxSendPduSize: Word read FMaxSendPduSize write FMaxSendPduSize;

  property DlmsVersionNumber: byte read FDlmsVersionNumber write FDlmsVersionNumber;

  property QualityOfService: ShortInt read FQualityOfService write FQualityOfService;

  property CypheringInfo: TBytes read FCypheringInfo write FCypheringInfo;

end;

implementation

end.

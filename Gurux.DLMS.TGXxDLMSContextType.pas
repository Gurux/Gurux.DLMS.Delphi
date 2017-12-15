unit Gurux.DLMS.TGXxDLMSContextType;

interface

uses SysUtils;

type

TGXxDLMSContextType = class
  FConformance : string;
    FMaxReceivePduSize, FMaxSendPpuSize : Word;

    FDlmsVersionNumber : byte;
    FQualityOfService : ShortInt;
    FCypheringInfo : TBytes;

 public
  property Conformance: string read FConformance write FConformance;

  property MaxReceivePduSize: Word read FMaxReceivePduSize write FMaxReceivePduSize;

  property MaxSendPpuSize: Word read FMaxSendPpuSize write FMaxSendPpuSize;

  property DlmsVersionNumber: byte read FDlmsVersionNumber write FDlmsVersionNumber;

  property QualityOfService: ShortInt read FQualityOfService write FQualityOfService;

  property CypheringInfo: TBytes read FCypheringInfo write FCypheringInfo;

end;

implementation

end.

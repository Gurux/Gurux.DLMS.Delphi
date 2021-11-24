unit Gurux.DLMS.GXDLMSSeasonProfile;

interface

uses SysUtils, Gurux.DLMS.GXDateTime;
type

TGXDLMSSeasonProfile = class
  private
  FName: string;
  FStart: TGXDateTime;
  FWeekName: string;

  public
  destructor Destroy;override;
  constructor Create; overload;
  constructor Create(name: string; start: TGXDateTime; weekName: string); overload;
  property Name: string read FName write FName;
  property Start: TGXDateTime read FStart write FStart;
  property WeekName: string read FWeekName write FWeekName;
  function ToString: string; override;
end;

implementation

constructor TGXDLMSSeasonProfile.Create;
begin
  inherited Create;
end;

destructor TGXDLMSSeasonProfile.Destroy;
begin
  inherited;
  FreeAndNil(FStart);
end;

constructor TGXDLMSSeasonProfile.Create(name: string; start: TGXDateTime; weekName: string);
begin
  inherited Create;
  FName := name;
  FStart := start;
  FWeekName := weekName;
end;

function TGXDLMSSeasonProfile.ToString: string;
begin
  Result := ((Self.Name + ' ') + Self.Start.ToString);
end;

end.

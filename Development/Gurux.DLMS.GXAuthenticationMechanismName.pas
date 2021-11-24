unit Gurux.DLMS.GXAuthenticationMechanismName;

interface
 uses Gurux.DLMS.Authentication;
type

TGXAuthenticationMechanismName = class
  FJointIsoCtt, FCountry, FIdentifiedOrganization : byte;
  FDlmsUA, FAuthenticationMechanismName : byte;

  FCountryName : Word;
  FMechanismId: TAuthentication;

  public
  property JointIsoCtt: byte read FJointIsoCtt write FJointIsoCtt;

  property Country: byte read FCountry write FCountry;

  property CountryName: Word read FCountryName write FCountryName;

  property IdentifiedOrganization: byte read FIdentifiedOrganization write FIdentifiedOrganization;

  property DlmsUA: byte read FDlmsUA write FDlmsUA;

  property AuthenticationMechanismName: byte read FAuthenticationMechanismName write FAuthenticationMechanismName;

  property MechanismId: TAuthentication read FMechanismId write FMechanismId;

end;
implementation

end.

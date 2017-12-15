unit Gurux.DLMS.GXAuthenticationMechanismName;

interface
 uses Gurux.DLMS.Authentication;
type

TGXAuthenticationMechanismName = class
  FJointIsoCttElement, FCountryElement, FIdentifiedOrganizationElement : byte;
  FDlmsUAElement, FAuthenticationMechanismNameElement : byte;

  FCountryNameElement : Word;
  FMechanismId: TAuthentication;

  public
  property JointIsoCttElement: byte read FJointIsoCttElement write FJointIsoCttElement;

  property CountryElement: byte read FCountryElement write FCountryElement;

  property CountryNameElement: Word read FCountryNameElement write FCountryNameElement;

  property IdentifiedOrganizationElement: byte read FIdentifiedOrganizationElement write FIdentifiedOrganizationElement;

  property DlmsUAElement: byte read FDlmsUAElement write FDlmsUAElement;

  property AuthenticationMechanismNameElement: byte read FAuthenticationMechanismNameElement write FAuthenticationMechanismNameElement;

  property MechanismId: TAuthentication read FMechanismId write FMechanismId;

end;
implementation

end.

unit Gurux.DLMS.GXDLMSObjectDefinition;

interface

uses Gurux.DLMS.ObjectType;

type

TGXDLMSObjectDefinition = class
  private
  FClassId : TObjectType;
  FLogicalName : string;

  public
  property ClassId: TObjectType read FClassId write FClassId;
  property LogicalName: string read FLogicalName write FLogicalName;
end;

implementation

end.

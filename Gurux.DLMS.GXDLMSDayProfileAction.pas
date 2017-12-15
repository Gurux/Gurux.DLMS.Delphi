unit Gurux.DLMS.GXDLMSDayProfileAction;

interface

uses SysUtils, GXCommon, Gurux.DLMS.GXDateTime;

type

TGXDLMSDayProfileAction = class

  FStartTime : TGXDateTime;
  FScriptLogicalName : string;
  FScriptSelector : Word;

  constructor Create;overload;
  destructor Destroy; override;

  // Defines the time when the script is to be executed.
  property StartTime: TGXDateTime read FStartTime write FStartTime;

  // Defines the logical name of the “Script table” object;
  property ScriptLogicalName: string read FScriptLogicalName write FScriptLogicalName;

  // Defines the script_identifier of the script to be executed.
  property ScriptSelector: Word read FScriptSelector write FScriptSelector;
  function ToString : String;override;
end;

implementation
destructor TGXDLMSDayProfileAction.Destroy;
begin
  inherited;
  FreeAndNil(FStartTime);
end;

constructor TGXDLMSDayProfileAction.Create;
begin
  inherited Create;
end;

function TGXDLMSDayProfileAction.ToString : String;
begin
  Result := FStartTime.ToString() + ' ' + FScriptLogicalName;
end;
end.

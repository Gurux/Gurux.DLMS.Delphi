program Gurux.DLMS.Simulator.Delphi;

uses
  Vcl.Forms,
  app in 'app.pas' {Form3},
  GXDLMSMeter in 'GXDLMSMeter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

program Gurux.DLMS.Push.Listener.Example.Delphi;

uses
  Vcl.Forms,
  app in 'app.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

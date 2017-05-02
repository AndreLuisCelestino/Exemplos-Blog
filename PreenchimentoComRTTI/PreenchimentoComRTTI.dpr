program PreenchimentoComRTTI;

uses
  Vcl.Forms,
  uFormulario in 'uFormulario.pas' {fFormulario},
  uFuncionario in 'uFuncionario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfFormulario, fFormulario);
  Application.Run;
end.

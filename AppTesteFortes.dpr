program AppTesteFortes;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {fmPrincipal},
  uVendasDTO in 'uVendasDTO.pas',
  uVendasDAO in 'uVendasDAO.pas',
  uConexao in 'uConexao.pas',
  uVendasController in 'uVendasController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmPrincipal, fmPrincipal);
  Application.Run;
end.

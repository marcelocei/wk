program RestCliente;

uses
  Vcl.Forms,
  U_Principal in 'U_Principal.pas' {frmPrincipal},
  U_Cadastro in 'U_Cadastro.pas' {frmCadastro};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

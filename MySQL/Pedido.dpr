program Pedido;

uses
  Vcl.Forms,
  U_Pedido in 'U_Pedido.pas' {Form2},
  U_Pesquisa in 'U_Pesquisa.pas' {frmPesquisa},
  U_Funcoes in 'U_Funcoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfrmPesquisa, frmPesquisa);
  Application.Run;
end.

unit U_Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Web.WebReq,
  System.JSON,
  REST.Types;

type
  TfrmCadastro = class(TForm)
    leNATUREZA: TLabeledEdit;
    leDOCUMENTO: TLabeledEdit;
    lePRIMEIRO: TLabeledEdit;
    leSEGUNDO: TLabeledEdit;
    leCEP: TLabeledEdit;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OPCAO : Integer;
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.dfm}

uses U_Principal;

procedure TfrmCadastro.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastro.Button2Click(Sender: TObject);
Var
  jsonRegistro : TJSONObject;
begin
  If leNATUREZA.Text = EmptyStr Then
  Begin
    leNATUREZA.SetFocus;
    raise Exception.Create('Campo NATUREZA em Branco...');
  End;

  If leDOCUMENTO.Text = EmptyStr Then
  Begin
    leDOCUMENTO.SetFocus;
    raise Exception.Create('Campo DOCUMENTO em Branco...');
  End;

  If lePRIMEIRO.Text = EmptyStr Then
  Begin
    lePRIMEIRO.SetFocus;
    raise Exception.Create('Campo PRIMEIRO em Branco...');
  End;

  If leSEGUNDO.Text = EmptyStr Then
  Begin
    leSEGUNDO.SetFocus;
    raise Exception.Create('Campo SEGUNDO em Branco...');
  End;

  If leCEP.Text = EmptyStr Then
  Begin
    leCEP.SetFocus;
    raise Exception.Create('Campo CEP em Branco...');
  End;

  jsonRegistro := TJSONObject.Create;

  With frmPrincipal do
  Begin

    RESTRequest1.Resource := 'pessoa';

    If OPCAO = 0 Then
      RESTRequest1.Method := rmPOST
    else
    Begin
      RESTRequest1.Method := rmPUT;
      jsonRegistro.AddPair('idpessoa',TJSONNumber.Create(fdmPessoa.FieldByName('IDPESSOA').AsString));
    End;

    jsonRegistro.AddPair('flnatureza',TJSONNumber.Create(leNATUREZA.Text));
    jsonRegistro.AddPair('dsdocumento',leDOCUMENTO.Text);
    jsonRegistro.AddPair('nmprimeiro',lePRIMEIRO.Text);
    jsonRegistro.AddPair('nmsegundo',leSEGUNDO.Text);
    jsonRegistro.AddPair('dscep',leCEP.Text);

    RESTRequest1.Body.ClearBody;
    RESTRequest1.AddBody(jsonRegistro.ToJSON,ctAPPLICATION_JSON);
    RESTRequest1.Execute;
  End;

  jsonRegistro.Free;

  Close;
end;

procedure TfrmCadastro.FormShow(Sender: TObject);
begin
  leNATUREZA.SetFocus;
end;

end.

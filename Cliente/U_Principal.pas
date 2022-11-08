unit U_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.StdCtrls,
  Web.WebReq,
  System.JSON;

type
  TfrmPrincipal = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    fdmPessoa: TFDMemTable;
    dsPessoa: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TNavigateBtn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

CONST
  URL = 'http://localhost:8080/wk/';


implementation

Uses U_Cadastro;

{$R *.dfm}

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.DBNavigator1BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
Var
  jsonRegistro : TJSONObject;
begin
  Try
    Case Button Of
      nbDelete:
      Begin
        RESTRequest1.Method   := rmDELETE;
        RESTRequest1.Resource := 'pessoa';

        jsonRegistro := TJSONObject.Create;

        jsonRegistro.AddPair('idpessoa',TJSONNumber.Create(fdmPessoa.FieldByName('idpessoa').AsInteger));

        RESTRequest1.Body.ClearBody;
        RESTRequest1.AddBody(jsonRegistro.ToJSON,ctAPPLICATION_JSON);
        RESTRequest1.Execute;

        jsonRegistro.Free;
      End;
      nbEdit:
      Begin
        Application.CreateForm(TfrmCadastro, frmCadastro);

        With frmCadastro do
        Begin
          OPCAO            := 1;
          leNATUREZA.Text  := fdmPessoa.FieldByName('FLNATUREZA').AsString;
          leDOCUMENTO.Text := fdmPessoa.FieldByName('DSDOCUMENTO').AsString;
          lePRIMEIRO.Text  := fdmPessoa.FieldByName('NMPRIMEIRO').AsString;
          leSEGUNDO.Text   := fdmPessoa.FieldByName('NMSEGUNDO').AsString;
          leCEP.Text       := fdmPessoa.FieldByName('DSCEP').AsString;

          ShowModal;
          Release;
        End;
      End;
      nbInsert:
      Begin
        Application.CreateForm(TfrmCadastro, frmCadastro);
        With frmCadastro do
        Begin
          OPCAO := 0;

          ShowModal;
          Release;
        End;
      End;
      nbRefresh:
      Begin
        RESTRequest1.Method   := rmGET;
        RESTRequest1.Resource := 'pessoa';
        RESTRequest1.Execute;
      End;
    End;
  Except
  End;

  fdmPessoa.Cancel;
  Abort;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  RESTClient1.BaseURL := URL;
  Try
    RESTRequest1.Resource := 'pessoa';
    RESTRequest1.Method   := rmGET;
    RESTRequest1.Execute;
  Except

  End;
end;

end.

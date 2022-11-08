unit U_Pedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, Vcl.Imaging.pngimage, Vcl.DBCtrls;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    gbCliente: TGroupBox;
    edtCliente: TEdit;
    fdcBanco: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    tblPedido: TFDMemTable;
    qryGeral: TFDQuery;
    DBGrid1: TDBGrid;
    dsPedido: TDataSource;
    tblPedidoiditem: TIntegerField;
    tblPedidoidproduto: TIntegerField;
    tblPedidoquantidade: TIntegerField;
    tblPedidovlunitario: TBCDField;
    tblPedidovltotal: TBCDField;
    Label1: TLabel;
    tblPedidodsproduto: TStringField;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    edtCodigo: TEdit;
    GroupBox2: TGroupBox;
    edtProduto: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox5: TGroupBox;
    edtNome: TEdit;
    GroupBox7: TGroupBox;
    edtCidade: TEdit;
    GroupBox8: TGroupBox;
    edtUF: TEdit;
    BitBtn1: TBitBtn;
    tblPedidototalpedido: TAggregateField;
    Panel3: TPanel;
    GroupBox12: TGroupBox;
    DBText1: TDBText;
    sbPesquisaCliente: TSpeedButton;
    sbPesquisaProduto: TSpeedButton;
    edtQTDE: TEdit;
    edtValor: TEdit;
    edtTotal: TEdit;
    Panel4: TPanel;
    PEDIDOS: TBitBtn;
    bbGravaPedido: TBitBtn;
    fdTransacao: TFDTransaction;
    procedure edtCodigoExit(Sender: TObject);
    procedure edtQTDEKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtClienteExit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtQTDEExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tblPedidoNewRecord(DataSet: TDataSet);
    procedure sbPesquisaClienteClick(Sender: TObject);
    procedure sbPesquisaProdutoClick(Sender: TObject);
    procedure PEDIDOSClick(Sender: TObject);
    procedure bbGravaPedidoClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    Procedure BuscaCliente(Codigo : Integer);
    Procedure BuscaPedido(Pedido : Integer);
    Procedure BuscaProduto(Codigo : Integer);
    Procedure IncluiProduto;
    Procedure GravaPedido;
    Procedure PesquisaCliente;
    Procedure PesquisaPedidos;
    Procedure PesquisaProduto;

  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

Uses U_Funcoes, U_Pesquisa;

procedure TForm2.PEDIDOSClick(Sender: TObject);
begin
  PesquisaPedidos;
end;

procedure TForm2.BuscaPedido(Pedido : Integer);
Begin

  With qryGeral do
  Begin

    { CLIENTE }

    Close;
    SQL.Clear;
    SQL.Add('SELECT B.* FROM PEDIDOS A LEFT JOIN CLIENTES B ON A.IDCLIENTE = B.IDCLIENTE WHERE A.IDPEDIDO = :IDPEDIDO');
    ParamByName('IDPEDIDO').Value := Pedido;
    Open;

    edtCliente.Text := FieldByName('IDCLIENTE').AsString;
    edtNome.Text    := FieldByName('NOME').AsString;
    edtCidade.Text  := FieldByName('CIDADE').AsString;
    edtUF.Text      := FieldByName('UF').AsString;


    { PEDIDO }

    Close;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  A.IDITEM,');
    SQL.Add('  A.IDPRODUTO,');
    SQL.Add('  B.DSPRODUTO,');
    SQL.Add('  A.VLUNITARIO,');
    SQL.Add('  A.QUANTIDADE,');
    SQL.Add('  A.VLTOTAL');
    SQL.Add('FROM');
    SQL.Add('  PEDIDODETALHE A');
    SQL.Add('    LEFT JOIN PRODUTOS B ON A.IDPRODUTO = B.IDPRODUTO');
    SQL.Add('WHERE');
    SQL.Add('  IDPEDIDO = :IDPEDIDO');
    ParamByName('IDPEDIDO').Value := Pedido;
    Open;

    tblPedido.AppendData(qryGeral);
  End;
End;

procedure TForm2.PesquisaPedidos;
Var
  dbSQL : TStringList;
  dbCampos     : Array Of Variant;
  dbCamposPesq : Array Of Variant;
  dbRetorno    : Variant;
begin
  dbSQL := TStringList.Create;
  With dbSQL do
  Begin
    Clear;
    Add('SELECT');
    Add('  A.IDPEDIDO,');
    Add('  A.DTEMISSAO,');
    Add('  B.NOME,');
    Add('  A.VLTOTAL');
    Add('FROM');
    Add('  PEDIDOS A');
    Add('    LEFT JOIN CLIENTES B ON A.IDCLIENTE = B.IDCLIENTE');
    Add('WHERE');
    Add('    A.IDPEDIDO LIKE :PESQUISA');
    Add('ORDER BY');
    Add('  A.IDPEDIDO');
    Add('LIMIT 100;');
  End;

  dbCampos := VarArrayOf([
                VarArrayOf(['IDPEDIDO','PEDIDO',70,'',1]),
                VarArrayOf(['DTEMISSAO','DATA',70,'',0]),
                VarArrayOf(['NOME','NOME',150,'',0]),
                VarArrayOf(['VLTOTAL','VALOR',100,'##,##0.00',0])
              ]);

  dbCamposPesq := VarArrayOf([
                    VarArrayOf(['PEDIDO','A.IDPEDIDO']),
                    VarArrayOf(['DATA','A.DTEMISSAO']),
                    VarArrayOf(['CLIENTE','B.NOME']),
                    VarArrayOf(['VALOR','A.VLPEDIDO'])
                  ]);

  dbRetorno := dbPesquisa(fdcBanco,dbSQL,dbCampos,dbCamposPesq);

  If VarIsArray(dbRetorno) Then
  Begin
    BuscaPedido(dbRetorno[0]);

    DBGrid1.SetFocus;
  End
  Else
    edtCliente.SetFocus;
End;


procedure TForm2.PesquisaCliente;
Var
  dbSQL : TStringList;
  dbCampos     : Array Of Variant;
  dbCamposPesq : Array Of Variant;
  dbRetorno    : Variant;
begin
  dbSQL := TStringList.Create;
  With dbSQL do
  Begin
    Clear;
    Add('SELECT');
    Add('  IDCLIENTE,');
    Add('  NOME,');
    Add('  CIDADE,');
    Add('  UF');
    Add('FROM');
    Add('  CLIENTES');
    Add('WHERE');
    Add('    NOME LIKE :PESQUISA');
    Add('ORDER BY');
    Add('  NOME');
    Add('LIMIT 100;');
  End;

  dbCampos := VarArrayOf([
                VarArrayOf(['IDCLIENTE','CÓDIGO',70,'',1]),
                VarArrayOf(['NOME','NOME',100,'',1]),
                VarArrayOf(['CIDADE','CIDADE',100,'',1]),
                VarArrayOf(['UF','UF',50,'',1])
              ]);

  dbCamposPesq := VarArrayOf([
                    VarArrayOf(['NOME','NOME']),
                    VarArrayOf(['CIDADE','CIDADE']),
                    VarArrayOf(['UF','UF'])
                  ]);

  dbRetorno := dbPesquisa(fdcBanco,dbSQL,dbCampos,dbCamposPesq);

  If VarIsArray(dbRetorno) Then
  Begin
    edtCliente.Text := dbRetorno[0];
    edtNome.Text    := dbRetorno[1];
    edtCidade.Text  := dbRetorno[2];
    edtUF.Text      := dbRetorno[3];

    edtCodigo.SetFocus;
  End
  Else
    edtCliente.SetFocus;
End;

procedure TForm2.PesquisaProduto;
Var
  dbSQL : TStringList;
  dbCampos     : Array Of Variant;
  dbCamposPesq : Array Of Variant;
  dbRetorno    : Variant;
begin
  dbSQL := TStringList.Create;
  With dbSQL do
  Begin
    Clear;
    Add('SELECT');
    Add('  IDPRODUTO,');
    Add('  DSPRODUTO,');
    Add('  VLPRODUTO');
    Add('FROM');
    Add('  PRODUTOS');
    Add('WHERE');
    Add('    DSPRODUTO LIKE :PESQUISA');
    Add('ORDER BY');
    Add('  DSPRODUTO');
    Add('LIMIT 100;');
  End;

  dbCampos := VarArrayOf([
                VarArrayOf(['IDPRODUTO','CÓDIGO',70,'',1]),
                VarArrayOf(['DSPRODUTO','NOME',150,'',1]),
                VarArrayOf(['VLPRODUTO','VALOR',80,'##,##0.00',1])
              ]);

  dbCamposPesq := VarArrayOf([
                    VarArrayOf(['NOME','DSPRODUTO']),
                    VarArrayOf(['VALOR','VLPRODUTO'])
                  ]);

  dbRetorno := dbPesquisa(fdcBanco,dbSQL,dbCampos,dbCamposPesq);

  If VarIsArray(dbRetorno) Then
  Begin
    edtCodigo.Text  := dbRetorno[0];
    edtProduto.Text := dbRetorno[1];
    edtValor.Text   := FormatFloat('##,##0.00',StrToFloat(dbRetorno[2]));

    edtQTDE.SetFocus;
  End
  Else
    edtCodigo.SetFocus;
End;

procedure TForm2.sbPesquisaClienteClick(Sender: TObject);
begin
  PesquisaCliente;
end;

procedure TForm2.sbPesquisaProdutoClick(Sender: TObject);
begin
  PesquisaProduto;
end;

procedure TForm2.IncluiProduto;
Begin
  With tblPedido do
  Begin
    Insert;
    FieldByName('idproduto').Value := StrToInt(edtCodigo.Text);
    FieldByName('dsproduto').Value := edtProduto.Text;
    FieldByName('vlunitario').Value := StrToFloat(edtValor.Text);
    FieldByName('quantidade').Value := StrToFloat(edtQTDE.Text);
    FieldByName('vltotal').Value    := StrToFloat(edtTotal.Text);
    Post;
  End;
End;

procedure TForm2.GravaPedido;
Var
  SEQ : Integer;
Begin
  Try
    fdTransacao.StartTransaction;

    { INCLUI PEDIDO }

    With qryGeral do
    Begin
      Close;
      SQL.Clear;

      SQL.Add('SET @IDPEDIDO := (SELECT IFNULL(MAX(IDPEDIDO),0) +1 FROM WK.PEDIDOS);');
      SQL.Add('');
      SQL.Add('INSERT INTO WK.PEDIDOS (IDPEDIDO, DTEMISSAO, IDCLIENTE, VLTOTAL)');
      SQL.Add('VALUES (@IDPEDIDO, CURRENT_DATE, :IDCLIENTE, :VLTOTAL);');
      SQL.Add('');
      SQL.Add('SELECT');
      SQL.Add('  @IDPEDIDO;');

      ParamByName('IDCLIENTE').Value := StrToInt(edtCliente.Text);
      ParamByName('VLTOTAL').Value   := tblPedido.FieldByName('TOTALPEDIDO').Value;

      Open;

      SEQ := Fields[0].AsInteger;

      ShowMessage('PEDIDO Nº '+IntToStr(SEQ));

      Close;

      { INCLUI PRODUTOS }

      tblPedido.First;

      While Not tblPedido.Eof do
      Begin
        SQL.Clear;

        SQL.Add('INSERT INTO WK.PEDIDODETALHE (IDITEM,IDPEDIDO,IDPRODUTO,QUANTIDADE,VLUNITARIO,VLTOTAL)');
        SQL.Add('VALUES (:IDITEM, :IDPEDIDO,:IDPRODUTO,:QUANTIDADE,:VLUNITARIO,:VLTOTAL)');

        ParamByName('IDPEDIDO').Value   := SEQ;
        ParamByName('IDITEM').Value     := tblPedido.FieldByName('IDITEM').AsInteger;
        ParamByName('IDPRODUTO').Value  := tblPedido.FieldByName('IDPRODUTO').AsInteger;
        ParamByName('QUANTIDADE').Value := tblPedido.FieldByName('QUANTIDADE').AsFloat;
        ParamByName('VLUNITARIO').Value := tblPedido.FieldByName('VLUNITARIO').AsFloat;
        ParamByName('VLTOTAL').Value    := tblPedido.FieldByName('VLTOTAL').AsFloat;

        ExecSQL;

        tblPedido.Next;
      End;

      fdTransacao.Commit;
    End;
  Except
    fdTransacao.Rollback;
  End;

End;


procedure TForm2.tblPedidoNewRecord(DataSet: TDataSet);
begin
  tblPedido.FieldByName('iditem').Value := tblPedido.FieldByName('iditem').AsInteger * -1;
end;

procedure TForm2.BuscaCliente(Codigo : Integer);
Begin
  With qryGeral do
  Begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM CLIENTES WHERE IDCLIENTE = :IDCLIENTE');
    ParamByName('IDCLIENTE').Value := Codigo;
    Open;

    If IsEmpty Then
    Begin
      edtCliente.SetFocus;
      raise Exception.Create('Cliente Não Encontrado...');
    End;

    edtNome.Text   := FieldByName('nome').AsString;
    edtCidade.Text := FieldByName('cidade').AsString;
    edtUF.Text     := FieldByName('uf').AsString;
  End;
End;

procedure TForm2.BuscaProduto(Codigo : Integer);
Begin
  With qryGeral do
  Begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM PRODUTOS WHERE IDPRODUTO = :IDPRODUTO');
    ParamByName('IDPRODUTO').Value := Codigo;
    Open;

    If IsEmpty Then
    Begin
      edtCodigo.SetFocus;
      raise Exception.Create('Produto Não Encontrado...');
    End;

    edtProduto.Text := FieldByName('dsproduto').AsString;
    edtValor.Text   := FormatFloat('##,##0.00',FieldByName('vlproduto').AsFloat);
  End;
End;

procedure TForm2.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_INSERT Then
    Abort;


  If (Key = VK_DELETE) and (dsPedido.State = dsBrowse) Then
  Begin
    If Application.MessageBox('Deseja Apagar Produto?','Atenção...',MB_YESNO+MB_ICONWARNING) = ID_YES Then
      tblPedido.Delete;
  End;


  If (Key = VK_RETURN) and (dsPedido.State = dsEdit) Then
  Begin
    tblPedido.FieldByName('VLTOTAL').Value := tblPedido.FieldByName('VLUNITARIO').AsFloat * tblPedido.FieldByName('QUANTIDADE').AsFloat;
    tblPedido.Post;
  End;
end;

procedure TForm2.bbGravaPedidoClick(Sender: TObject);
begin

  If edtCliente.Text = EmptyStr Then
  Begin
    edtCliente.SetFocus;
    raise Exception.Create('Pedido sem Cliente...');
  End;


  If tblPedido.RecordCount = 0 Then
  Begin
    edtCodigo.SetFocus;
    raise Exception.Create('Pedido sem Produtos...');
  End;

//  GravaPedido;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  If edtCliente.Text = EmptyStr Then
  Begin
    edtCliente.SetFocus;
    Abort;
  End;

  If edtCodigo.Text = EmptyStr Then
  Begin
    edtCodigo.SetFocus;
    Abort;
  End;

  If edtQTDE.Text = EmptyStr Then
  Begin
    edtQTDE.SetFocus;
    Abort;
  End;

  IncluiProduto;
  edtCodigo.SetFocus;
end;

procedure TForm2.edtClienteExit(Sender: TObject);
begin
  If edtCliente.Text <> EmptyStr Then
  Begin
    BuscaCliente(StrToInt(edtCliente.Text));
  End;
end;

procedure TForm2.edtCodigoExit(Sender: TObject);
begin
  If edtCodigo.Text <> EmptyStr Then
  Begin
    BuscaProduto(StrToInt(edtCodigo.Text));
  End;

end;

procedure TForm2.edtQTDEExit(Sender: TObject);
begin
  If edtQTDE.Text <> EmptyStr Then
  Begin
    If (edtValor.Text <> EmptyStr) Then
      edtTotal.Text := FormatFloat('##,##0.00',StrToFloat(edtValor.Text) * StrToFloat(edtQTDE.Text));

    edtQTDE.Text := FormatFloat('##,##0.00',StrToFloat(edtQTDE.Text));
  End;
end;

procedure TForm2.edtQTDEKeyPress(Sender: TObject; var Key: Char);
begin
	If Not (Key In ['0'..'9','-',',',#8,#9,#13]) Then Key := #0;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tblPedido.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  tblPedido.Open;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
    VK_ESCAPE:
    Begin
    End;

    VK_RETURN:
    Begin
      Perform(WM_NextDlgCtl,0,0);
    End;
    VK_DOWN:
{
    Begin
    	Perform(WM_NextDlgCtl,0,0);
    End;
    VK_UP:
    Begin
    	Perform(WM_NextDlgCtl,1,0);
    End;
}
  End;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  edtCliente.SetFocus;
end;

end.

unit U_Pesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.FMTBcd, Data.DB, Data.SqlExpr,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, SimpleDS, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
   TCampos = Class
     Nome  : String;
     Titulo: String;
End;

type
  TfrmPesquisa = class(TForm)
    Label1: TLabel;
    CBCampos: TComboBox;
    edtPesquisa: TEdit;
    dsPesquisa: TDataSource;
    DBGPesquisa: TDBGrid;
    Panel1: TPanel;
    bbConfirma: TBitBtn;
    Splitter1: TSplitter;
    mkeData: TMaskEdit;
    qryPesquisa: TClientDataSet;
    qryPesquisaDBX: TSimpleDataSet;
    qryPesquisaFD: TFDQuery;
    procedure FormActivate(Sender: TObject);
    procedure edtPesquisaChange(Sender: TObject);
    procedure CBCamposKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mkeDataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CBCamposClick(Sender: TObject);
    procedure mkeDataExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pCampos  : TCampos;
    fCampos : Array of Variant;
    TP_CONEXAO : Integer;
  end;

var
  frmPesquisa: TfrmPesquisa;


implementation

{$R *.dfm}


procedure TfrmPesquisa.CBCamposClick(Sender: TObject);
Var
  sCampo :String;
begin
  pCampos := CBCampos.Items.Objects[CBCampos.ItemIndex] As TCampos;

  sCampo := Copy(pCampos.Nome,Pos('.',pCampos.Nome)+1,Length(pCampos.Nome));

  If dsPesquisa.DataSet.FieldByName(sCampo).DataType In [ftDate,ftDateTime,ftTimeStamp] Then
  Begin
    mkeData.Visible     := True;
    edtPesquisa.Visible := False;

    mkeData.Clear;
  End
  Else
  Begin
    mkeData.Visible     := False;
    edtPesquisa.Visible := True;

    edtPesquisa.Clear;
  End;
end;

procedure TfrmPesquisa.CBCamposKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN Then Perform(WM_NextDlgCtl,0,0);
end;

procedure TfrmPesquisa.DBGPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If (Key = VK_UP) and (dsPesquisa.DataSet.Bof) then
    Perform(WM_NextDlgCtl,1,0);

  If Key = VK_RETURN Then bbConfirma.Click;
end;

procedure TfrmPesquisa.edtPesquisaChange(Sender: TObject);
Var
  dbSQL,dbSQLNovo : TStringList;
  Pesquisa : Boolean;
  c, i, PosPesq, PosAnd, PosOrderBy : integer;
begin

  If Length(Trim(edtPesquisa.Text)) = 0 Then Exit;

  dbSQL      := TStringList.Create;
  dbSQLNovo  := TStringList.Create;
  pCampos    := CBCampos.Items.Objects[CBCampos.ItemIndex] As TCampos;


  Case TP_CONEXAO Of
    0: dbSQL.Text := qryPesquisa.CommandText;
    1: dbSQL.Text := qryPesquisaDBX.DataSet.CommandText;
    2: dbSQL.Text := qryPesquisaFD.SQL.Text;
  End;

  dbSQLNovo.Clear;

  For i := 0 to dbSQL.Count -1 do
  Begin
    PosPesq    := Pos(':PESQUISA',AnsiUpperCase(dbSQL.Strings[i]));
    PosOrderBy := Pos('ORDER BY',AnsiUpperCase(dbSQL.Strings[i]));

    If PosPesq > 0 Then
    Begin
      PosAnd := Pos('AND ',AnsiUpperCase(dbSQL.Strings[i]));

      If (PosAnd > 0) and (PosAnd < PosPesq)  Then
        dbSQLNovo.Add('AND '+pCampos.Nome+' LIKE :PESQUISA')
      Else
       dbSQLNovo.Add('    '+pCampos.Nome+' LIKE :PESQUISA');

      Continue;
    End;

    If PosOrderBy > 0 Then
    Begin
      dbSQLNovo.Add('ORDER BY');
      dbSQLNovo.Add('  '+pCampos.Nome);
      Break;
    End;

    dbSQLNovo.Add(dbSQL.Strings[i]);
  End;

  With dsPesquisa.DataSet do
  Begin
    Close;

    Case TP_CONEXAO Of
      0:
      Begin
        qryPesquisa.CommandText := dbSQLNovo.Text;
        qryPesquisa.ParamByName('PESQUISA').Value := '%'+edtPesquisa.Text+'%';
      End;
      1:
      Begin
        qryPesquisaDBX.DataSet.CommandText := dbSQLNovo.Text;
        qryPesquisaDBX.DataSet.ParamByName('PESQUISA').Value := '%'+edtPesquisa.Text+'%';
      End;
      2:
      Begin
        qryPesquisaFD.SQL.Text := dbSQLNovo.Text;
        qryPesquisaFD.ParamByName('PESQUISA').Value := '%'+edtPesquisa.Text+'%';
      End;
    End;

    Open;

    For i := 0 to Length(fCampos) -1 do
    Begin
      c:= Fields.IndexOf(Fields.FindField(fCampos[i][0]));
      Case Fields[i].DataType Of
        ftInteger : TIntegerField(Fields[c]).DisplayFormat := fCampos[i][3];
        ftBCD     : TFloatField(Fields[c]).DisplayFormat   := fCampos[i][3];
        ftFMTBcd  : TFloatField(Fields[c]).DisplayFormat   := fCampos[i][3];
        ftString  : TStringField(Fields[c]).EditMask       := fCampos[i][3];
      End;
    End;
  End;

  dbSQL.Free;
  dbSQLNovo.Free;
End;

procedure TfrmPesquisa.edtPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
    VK_RETURN:
    Begin
      bbConfirma.Click;
    End;
    VK_DOWN:
    Begin
    	Perform(WM_NextDlgCtl,0,0);
    End;
    VK_UP:
    Begin
    	Perform(WM_NextDlgCtl,1,0);
    End;
  End;
end;

procedure TfrmPesquisa.FormActivate(Sender: TObject);
Var
  sCampo : String;
begin
  pCampos := CBCampos.Items.Objects[CBCampos.ItemIndex] As TCampos;

  sCampo := Copy(pCampos.Nome,Pos('.',pCampos.Nome)+1,Length(pCampos.Nome));

  If dsPesquisa.DataSet.FieldByName(sCampo).DataType In [ftDate,ftDateTime,ftTimeStamp] Then
  Begin
    mkeData.Visible     := True;
    edtPesquisa.Visible := False;

    mkeData.Clear;
    mkeData.SetFocus;
  End
  Else
  Begin
    mkeData.Visible     := False;
    edtPesquisa.Visible := True;

    edtPesquisa.Clear;
    edtPesquisa.SetFocus;
  End;
end;

procedure TfrmPesquisa.mkeDataExit(Sender: TObject);
Var
  dbSQL,dbSQLNovo : TStringList;
  Pesquisa : Boolean;
  c, i, PosAnd, PosOrderBy, PosPesq : integer;
begin

  If Length(Trim(mkeData.Text)) < 8  Then Exit;

  dbSQL      := TStringList.Create;
  dbSQLNovo  := TStringList.Create;
  pCampos    := CBCampos.Items.Objects[CBCampos.ItemIndex] As TCampos;
  dbSQL.Text := qryPesquisa.CommandText;

  dbSQLNovo.Clear;

  For i := 0 to dbSQL.Count -1 do
  Begin
    PosPesq    := Pos(':PESQUISA',AnsiUpperCase(dbSQL.Strings[i]));
    PosOrderBy := Pos('ORDER BY',AnsiUpperCase(dbSQL.Strings[i]));

    If PosPesq > 0 Then
    Begin

      PosAnd := Pos('AND ',AnsiUpperCase(dbSQL.Strings[i]));

      If (PosAnd > 0) and (PosAnd < PosPesq)  Then
        dbSQLNovo.Add('AND '+pCampos.Nome+' = :PESQUISA')
      Else
       dbSQLNovo.Add('    '+pCampos.Nome+' = :PESQUISA');

      Continue;
    End;

    If PosOrderBy > 0 Then
    Begin
      dbSQLNovo.Add('ORDER BY');
      dbSQLNovo.Add('  '+pCampos.Nome);
      Break;
    End;

    dbSQLNovo.Add(dbSQL.Strings[i]);
  End;

  With dsPesquisa.DataSet do
  Begin
    Close;

    Case TP_CONEXAO Of
      0:
      Begin
        qryPesquisa.CommandText := dbSQLNovo.Text;
        qryPesquisa.ParamByName('PESQUISA').Value := '%'+edtPesquisa.Text+'%';
      End;
      1:
      Begin
        qryPesquisaDBX.DataSet.CommandText := dbSQLNovo.Text;
        qryPesquisaDBX.DataSet.ParamByName('PESQUISA').Value := '%'+edtPesquisa.Text+'%';
      End;
      2:
      Begin
        qryPesquisaFD.SQL.Text := dbSQLNovo.Text;
        qryPesquisaFD.ParamByName('PESQUISA').Value := '%'+edtPesquisa.Text+'%';
      End;
    End;

    For i := 0 to Length(fCampos) -1 do
    Begin
      c:= Fields.IndexOf(Fields.FindField(fCampos[i][0]));
      Case Fields[i].DataType Of
        ftInteger : TIntegerField(Fields[c]).DisplayFormat := fCampos[i][3];
        ftBCD     : TFloatField(Fields[c]).DisplayFormat   := fCampos[i][3];
        ftFMTBcd  : TFloatField(Fields[c]).DisplayFormat   := fCampos[i][3];
        ftString  : TStringField(Fields[c]).EditMask       := fCampos[i][3];
      End;
    End;
  End;

  dbSQL.Free;
  dbSQLNovo.Free;
end;

procedure TfrmPesquisa.mkeDataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
    VK_RETURN:
    Begin
      Perform(WM_NextDlgCtl,0,0);
    End;
    VK_DOWN:
    Begin
    	Perform(WM_NextDlgCtl,0,0);
    End;
    VK_UP:
    Begin
    	Perform(WM_NextDlgCtl,1,0);
    End;
  End;
end;

end.

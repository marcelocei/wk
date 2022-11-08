unit U_Funcoes;

interface

Uses
  Winapi.Windows, System.Classes, SysUtils, Vcl.Forms, Vcl.Controls, Vcl.Dialogs, IdCoderMIME, Data.DB, Datasnap.DBClient, Inifiles, Variants,
  Data.SqlExpr, TypInfo, Vcl.DBGrids, SimpleDS,DataSnap.DSConnect, FireDAC.Comp.Client, IdIcmpClient, IdTCPClient, Winapi.WinInet;

  Procedure AbreForm(const AClasse: TFormClass; out Form; Modo : Integer; BackGround : Boolean);
  Function  PesquisaRegistro(qryTabela : TDataSet; Tabela : String; Argumentos : Variant) : Boolean;
  Function  Criptografa(Texto : String; OPCAO : Integer) : String;
	Function  MaxCampo(qryTabela : TDataSet; sTabela, sCampo : String) : Real;
  Function  MaxCampoSeq(qryTabela : TDataSet; sTabela, sCampo, sCampoSeq : String; vCampoSeqValor : Variant) : Integer;
  Function  LeINI(Secao,Item : String; Tipo : Integer) : Variant;
  Procedure SalvaINI(Secao,Item : String; Conteudo : Variant; Tipo : Integer);
  Function  dbPesquisa(dbConexao : TCustomConnection; dbSQL : TStringList; dbCampos : Array of Variant; dbCamposPesq : Array of Variant) : Variant;
	Function  Preenche(sString, sCaracter : String; iTamanho, iDirecao : Integer): String;
	Function  Centraliza(sString : String ; iRef : Integer) : String;
  Function  StrZero(piValor, piTamanho: integer): string;
	Function  TiraPonto(Valor : String) : String;
	Function  VirgulaPonto(Valor : String) : String;
  Function  RetornaChaveNFe(XML : String) : String;
  Procedure AjusteScala(Form : TForm);
  Procedure AjusteDBGridColuna(DBGrid : TDBGrid; Secao, Item : String);
  Procedure AjusteTamanhoColuna(Coluna : TColumn; nCol : Integer; Secao, Item : String);
  Procedure FormBackground;
  Procedure FormBackgroundPesquisa();
  Procedure FormBackgroundDialog;
  Function  VerificaCasaDecimal(Valor : Real) : Real;
  Function  RetornaNumero(Numero : String): Integer;
  Function  RetornaValor(Valor : String): Real;

//  Procedure VerificaConexaoServidor;

  Function ConexaoInternet() : Boolean;
  Function SomenteNumeros(Numero : String) : String;
  Procedure MensagemDialog(msg : String);

implementation

Uses U_Background, U_BackgroundPesquisa, U_BackgroundDialog,
  U_AjusteColuna, U_Pesquisa;

Const
  ScreenWidth  : LongInt = 1360;
  ScreenHeight : LongInt = 768;


Procedure MensagemDialog(msg : string);
Begin
  FormBackground();

  Application.MessageBox(PChar(msg),'Atenção...',MB_ICONWARNING);

  FormBackground();
End;

Function SomenteNumeros(Numero : String) : String;
Var
  I : Integer;
  S : String;
Begin
  S := EmptyStr;

  For I := 1 to Length(Numero) do
    If Numero[I] In ['0'..'9'] Then
      S := S + Numero[I];

  Result := S;
End;

Function ConexaoInternet() : Boolean;
Begin
  Result := InternetCheckConnection('https://registro.br',1,0);
End;

Procedure FormBackground();
Begin
  If Not Assigned(frmBackground) Then
  Begin
    Application.CreateForm(TfrmBackground, frmBackground);
    frmBackground.Show;
  End
  Else
  Begin
    frmBackground.Release;
    FreeAndNil(frmBackGround);
  End;
End;

Function RetornaNumero(Numero : String): Integer;
var
  I : Byte;
  N : String;
begin
   N := EmptyStr;

   For I := 1 To Length(Numero) do
     If Numero[I] In ['0'..'9'] Then
       N := N + Numero[I];

   If Length(N) > 0 Then
     Result := StrToInt(N)
   Else
     Result := 0;
end;

Function RetornaValor(Valor : String): Real;
var
  I : Byte;
  N : String;
begin
   N := EmptyStr;

   For I := 1 To Length(Valor) do
     If Valor[I] In ['0'..'9',','] Then
       N := N + Valor[I];

   If Length(N) > 0 Then
     Result := StrToFloat(N)
   Else
     Result := 0;
end;

Function VerificaCasaDecimal(Valor : Real) : Real;
Var
  tmpValor  : String;
  tmpValor2 : String;
  P : Integer;
Begin

  tmpValor := FloatToStr(Valor);

  P := Pos(',',tmpValor);

  tmpValor2 := Copy(tmpValor,1,P) +
               Copy(tmpValor,P+1,2);

  Result := StrToFloat(tmpValor2);
End;

Procedure FormBackgroundPesquisa();
Begin
  If Not Assigned(frmBackgroundPesquisa) Then
  Begin
    Application.CreateForm(TfrmBackgroundPesquisa, frmBackgroundPesquisa);
    frmBackgroundPesquisa.Show;
  End
  Else
  Begin
    frmBackgroundPesquisa.Release;
    FreeAndNil(frmBackgroundPesquisa);
  End;
End;

Procedure FormBackgroundDialog();
Begin
  If Not Assigned(frmBackgroundDialog) Then
  Begin
    Application.CreateForm(TfrmBackgroundDialog, frmBackgroundDialog);
    frmBackgroundDialog.Show;
  End
  Else
  Begin
    frmBackgroundDialog.Release;
    FreeAndNil(frmBackgroundDialog);
  End;
End;

Procedure AjusteTamanhoColuna(Coluna : TColumn; nCol : Integer; Secao, Item : String);
Var
  P : TPoint;
  T : Array Of Integer;
  S : String;
  I : Integer;
  C : Integer;
  V : String;
  W : Integer;
Begin
  GetCursorPos(P);

  { BUSCA TAMANHO COLULA }

  S := Trim(LeINI(Secao,Item,0));
  C := 0;
  V := EmptyStr;

  SetLength(T,nCol);
  For I := 1 to Length(S) do
  Begin
    If S[I] = ',' Then
    Begin
      T[C] := StrToInt(V);

      V := EmptyStr;
      C := C+1;
    End
    Else
      V := V + S[I];
  End;

  If V <> EmptyStr Then
    T[C] := StrToInt(V);

  { FORM }

  Application.CreateForm(TfrmAjusteColuna, frmAjusteColuna);
  With frmAjusteColuna do
  Begin

    Top  := P.Y + 30;
    Left := P.X;

    GBColuna.Caption := Coluna.Title.Caption;
    edtColuna.Text   := IntToStr(Coluna.Width);

    ShowModal;

    W := StrToInt(edtColuna.Text);

    Release;
  End;

  If W <> T[Coluna.Index] Then
  Begin
    T[Coluna.Index] := W;
    Coluna.Width    := W;

    V := EmptyStr;

    For I := 0 to Length(T) -1 do
      V := V + IntToStr(T[I]) + ',';

    V := Copy(V,1,Length(V)-1);

    SalvaINI(secao,item,V,0);
  End;
End;

Procedure AjusteDBGridColuna(DBGrid : TDBGrid; Secao, Item : String);
Var
  S : String;
  I : Integer;
  C : Integer;
  V : String;
Begin
  S := Trim(LeINI(Secao,Item,0));
  C := 0;
  V := EmptyStr;

  For I := 1 to Length(S) do
  Begin
    If S[I] = ',' Then
    Begin
      DBGrid.Columns[C].Width := StrToInt(V);

      V := EmptyStr;
      C := C+1;
    End
    Else
      V := V + S[I];
  End;

  If V <> EmptyStr Then
    DBGrid.Columns[C].Width := StrToInt(V);
End;

Procedure AjusteScala(Form : TForm);
Var
  I : Integer;
  F : Integer;
  C : TComponent;
Begin
  If (Screen.Width <> ScreenWidth) Then
  Begin
//    Form.Height := LongInt(Form.Height) * LongInt(Screen.Height) div ScreenHeight;
//    Form.Width  := LongInt(Form.Width) * LongInt(Screen.Width) div ScreenWidth;
    Form.ScaleBy(Screen.Width, ScreenWidth);


{
    With Form do
    Begin
      ScaleBy(Screen.Width, ScreenWidth);



     { BUSCA COMPONENTES

      For C In Form do
      Begin
        If C Is TDBGrid Then
        Begin
          F  := TDBGrid(C).Font.Size;

          For I := 0 To TDBGrid(C).Columns.Count -1 do
          Begin
            TDBGrid(C).Columns[I].Font.Size := F;
            TDBGrid(C).Columns[I].Title.Font.Size := F;
          End;
        End;
      End;

    End;
}
  End;
End;

Function RetornaChaveNFe(XML : String) : String;
Var
  P : Integer;
Begin
  Result := EmptyStr;
   P := Pos('<chNFe>',XML);

  If P > 0 Then
  Begin
    P:= P + 7;
    Result := Copy(XML,P,44);
  End;
End;

Function VirgulaPonto(Valor : String) : String;
Var
  I : Integer;
  V, V2 : String;
begin
  Result := '';

  If Valor = EmptyStr Then Exit;

  V2:= '';

	For I := 1 to Length(Valor) do
	Begin
		If Valor[I] = ',' Then
			V2 := V2 + '.'
		Else
			V2 := V2 + Valor[I];
	End;
  Result := V2;
end;

Function PesquisaRegistro(qryTabela : TDataSet; Tabela : String; Argumentos : Variant) : Boolean;
Var
	A : Integer;
  S : String;
  P : TParams;

  tmpSQL : TStringList;
Begin
	Result := True;

  tmpSQL := TStringList.Create;
  P      := TParams.Create(nil);

  tmpSQL.Add('SELECT');
  tmpSQL.Add('  TOP 1 *');
  tmpSQL.Add('FROM');
  tmpSQL.Add('  '+Tabela);
  tmpSQL.Add('WHERE');

  For A := 0 To VarArrayHighBound(Argumentos,1) do
  Begin
    S := '  '+Argumentos[A][0]+' '+Argumentos[A][1]+' ';
    S := S + ':'+ Argumentos[A][0];

    If A < VarArrayHighBound(Argumentos,1) Then
      S := S + ' AND';

    tmpSQL.Add(S);

    { PARAMETROS SQL }

    With P.AddParameter do
    Begin
      Case VarType(Argumentos[A][2]) Of
        varDate    : DataType := ftDate;
        varInteger : DataType := ftInteger;
        varDouble  : DataType := ftFloat;
        varString  : DataType := ftString;
      End;

      Name      := Argumentos[A][0];
      ParamType := ptInput;
      Value     := Argumentos[A][2];
    End;
  End;

  If qryTabela Is TClientDataSet Then
  Begin
    With TClientDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      Params.Assign(P);
      Open;

      If Eof Then
        Result := False;
    End;
  End;

  If qryTabela Is TSQLDataSet Then
  Begin
    With TSQLDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      Params.Assign(P);

      Open;

      If Eof Then
        Result := False;
    End;
  End;

  If qryTabela Is TSQLQuery Then
  Begin
    With TSQLQuery(qryTabela) do
    Begin
      Close;
      SQL.Clear;
      SQL.Add(tmpSQL.Text);
      Params.Assign(P);

      Open;

      If Eof Then
        Result := False;
    End;
  End;

  tmpSQL.Free;
End;

Function Criptografa(Texto : String; OPCAO : Integer) : String;
Var
  Encode : TIdEncoderMIME;
  Decode : TIdDecoderMIME;
begin
  Case OPCAO of
    0:
    Begin
      Encode := TIdEncoderMIME.Create(nil);
      Result := Encode.Encode(Texto);
      Encode.Free;
    End;
    1:
    Begin
      Decode := TIdDecoderMIME.Create(nil);
      Result := Decode.DecodeString(Texto);
      Decode.Free;
    End;
  end;
end;

Function MaxCampo(qryTabela : TDataSet; sTabela, sCampo : String) : Real;
Var
  tmpSQL : TStringList;
begin
  { RETORNA O MÁXIMO DO CAMPO }

  tmpSQL := TStringList.Create;

  tmpSQL.Add('SELECT');
  tmpSQL.Add('  MAX('+sCampo+')');
  tmpSQL.Add('FROM');
  tmpSQL.Add('  '+sTabela);

  If qryTabela Is TClientDataSet Then
  Begin
    With TClientDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      Open;
      Result := Fields[0].AsFloat +1;
    End;
  End;

  If qryTabela Is TSQLDataSet Then
  Begin
    With TSQLDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      Open;
      Result := Fields[0].AsFloat +1;
    End;
  End;

  If qryTabela Is TSQLQuery Then
  Begin
    With TSQLDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      Open;
      Result := Fields[0].AsFloat +1;
    End;
  End;

  tmpSQL.Free;
end;

Function MaxCampoSeq(qryTabela : TDataSet; sTabela, sCampo, sCampoSeq : String; vCampoSeqValor : Variant) : Integer;
Var
  tmpSQL : TStringList;
Begin
  { RETORNA O MÁXIMO DO CAMPO SEQUÊNCIA }

  tmpSQL := TStringList.Create;

  tmpSQL.Add('SELECT');
  tmpSQL.Add('  MAX('+sCampoSeq+')');
  tmpSQL.Add('FROM');
  tmpSQL.Add('  '+sTabela);
  tmpSQL.Add('WHERE');
  tmpSQL.Add('  '+sCampo+'= :VL_CAMPO');

  If qryTabela Is TClientDataSet Then
  Begin
    With TClientDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      ParamByName('VL_CAMPO').Value := vCampoSeqValor;
      Open;
      Result := Fields[0].AsInteger +1;
    End;
  End;

  If qryTabela Is TSQLDataSet Then
  Begin
    With TSQLDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      ParamByName('VL_CAMPO').Value := vCampoSeqValor;
      Open;
      Result := Fields[0].AsInteger +1;
    End;
  End;

  If qryTabela Is TSQLQuery Then
  Begin
    With TSQLDataSet(qryTabela) do
    Begin
      Close;
      CommandText := tmpSQL.Text;
      ParamByName('VL_CAMPO').Value := vCampoSeqValor;
      Open;
      Result := Fields[0].AsInteger +1;
    End;
  End;
end;

Procedure SalvaINI(Secao,Item : String; Conteudo : Variant; Tipo : Integer);
Var
  Ini: TIniFile;
Begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'\'+
                         ChangeFileExt(ExtractFileName(ParamStr(0)),'.ini'));

  Try
    Case Tipo Of
      0: Ini.WriteString(Secao,Item,Conteudo);
      1: Ini.WriteInteger(Secao,Item,Conteudo);
    End;
  Finally
    Ini.Free;
  End;
End;

Function LeINI(Secao,Item : String; Tipo : Integer) : Variant;
Var
  Ini: TIniFile;
Begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'\'+
                         ChangeFileExt(ExtractFileName(ParamStr(0)),'.ini'));
  Try
    Case Tipo Of
      0: Result := Ini.ReadString(Secao,Item,Result);
      1: Result := Ini.ReadInteger(Secao,Item,Result);
    End;
  Finally
    Ini.Free;
  End;
End;

Function dbPesquisa(dbConexao : TCustomConnection; dbSQL : TStringList; dbCampos : Array of Variant; dbCamposPesq : Array of Variant) : Variant;
Var
  c,i,r : Integer;
  dbRetorno : Variant;

  Function CamposRetorno(Campos : Array Of Variant) : Integer;
  Var
    r,i : Integer;
  Begin
    r := 0;
    For i := 0 to Length(Campos) -1 do
    Begin
      If Campos[i][4] = 1 Then
        Inc(r);
    End;

    Result := r;
  End;

Begin

  Result := Null;

  If dbConexao = Nil Then Exit;
  If dbSQL     = Nil Then Exit;

  FormBackgroundPesquisa();

  Application.CreateForm(TfrmPesquisa, frmPesquisa);
  With frmPesquisa do
  Begin

    fCampos := VarArrayOf(dbCampos);

    { CAMPOS COMBOBOX - INICIO }

    CBCampos.Clear;
    For i := 0 to Length(dbCamposPesq) -1 do
    Begin
      pCampos        := TCampos.Create;
      pCampos.Nome   := dbCamposPesq[i][1];
      pCampos.Titulo := dbCamposPesq[i][0];

      CBCampos.Items.AddObject(dbCamposPesq[i][0],pCampos);
    End;
    CBCampos.ItemIndex := 0;

    { CAMPOS COMBOBOX - FIM }

    { CAMPOS DBGRID - INICIO }

    c:= 0;
    For i := 0 to Length(dbCampos) -1 do
    Begin
      If dbCampos[i][2] <> 0 Then
      Begin
        DBGPesquisa.Columns.Add;
        DBGPesquisa.Columns.Items[c].FieldName     := dbCampos[i][0];
        DBGPesquisa.Columns.Items[c].Title.Caption := dbCampos[i][1];
        DBGPesquisa.Columns.Items[c].Width         := dbCampos[i][2];
        Inc(c);
      End;
    End;

    { CAMPOS DBGRID - FIM }

    If dbConexao.ClassNameIs('TDSProviderConnection') Then
    Begin
      With qryPesquisa do
      Begin
        RemoteServer                  := TDSProviderConnection(dbConexao);
        CommandText                   := dbSQL.Text;
        ParamByName('PESQUISA').Value := '%';
      End;
      TP_CONEXAO := 0;
      dsPesquisa.DataSet := qryPesquisa;
    End;

    If dbConexao.ClassNameIs('TSQLConnection') Then
    Begin
      With qryPesquisaDBX do
      Begin
        Connection                            := TSQLConnection(dbConexao);
        DataSet.CommandText                   := dbSQL.Text;
        DataSet.ParamByName('PESQUISA').Value := '%';
      End;
      TP_CONEXAO := 1;
      dsPesquisa.DataSet := qryPesquisaDBX;
    End;

    If dbConexao.ClassNameIs('TFDConnection') Then
    Begin
      With qryPesquisaFD do
      Begin
        Connection                    := TFDConnection(dbConexao);
        SQL.Text                      := dbSQL.Text;
        ParamByName('PESQUISA').Value := '%';
      End;
      TP_CONEXAO := 2;
      dsPesquisa.DataSet := qryPesquisaFD;
    End;

    With dsPesquisa.DataSet do
    Begin
      Close;
      Open;

      For i := 0 to Length(dbCampos) -1 do
      Begin
        c:= Fields.IndexOf(Fields.FindField(dbCampos[i][0]));
        Case Fields[i].DataType Of
          ftInteger : TIntegerField(Fields[c]).DisplayFormat := dbCampos[i][3];
          ftBCD     : TFloatField(Fields[c]).DisplayFormat   := dbCampos[i][3];
          ftFMTBcd  : TFloatField(Fields[c]).DisplayFormat   := dbCampos[i][3];
          ftString  : TStringField(Fields[c]).EditMask       := dbCampos[i][3];
        End;
      End;

      If ShowModal = mrOK Then
      Begin
        dbRetorno := VarArrayCreate([0,CamposRetorno(dbCampos)],varVariant);

        r := 0;
        For i := 0 to Length(dbCampos) -1 do
        Begin
          If dbCampos[i][4] = 1 Then
          Begin
            Case dsPesquisa.DataSet.Fields[dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).Index].DataType Of
              ftDateTime : dbRetorno[r] := dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).AsDateTime;
              ftInteger  : dbRetorno[r] := dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).AsInteger;
              ftBCD      : dbRetorno[r] := dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).AsFloat;
              ftFMTBcd   : dbRetorno[r] := dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).AsFloat;
              ftString   : dbRetorno[r] := dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).AsString;
            Else
              dbRetorno[r] := dsPesquisa.DataSet.FieldByName(dbCampos[i][0]).Value;
            End;
            Inc(r);
          End;
        End;
      End;
      Close;
    End;
    Release;
  End;
  Result := dbRetorno;

  FormBackgroundPesquisa();
End;

Function Preenche(sString, sCaracter : String; iTamanho, iDirecao: Integer): String;
Var
	l : Integer;
	sVariavel : String;
begin
	sVariavel := '';
	For l := Length(sString) + 1 To iTamanho do
		sVariavel := sVariavel + sCaracter;
	Case iDirecao of
		0 : Result := sVariavel + sString;
		1 : Result := sString + sVariavel;
	End;
end;

Function Centraliza(sString : String ; iRef : Integer) : String;
Var
	l, iTamanho : Integer;
	sVariavel : String;
begin
	sVariavel := '';
	iTamanho  := iRef - (Length(sString) div 2);
	For l := 1 To iTamanho do
		sVariavel := sVariavel + ' ';
	Result := sVariavel + sString;
End;

Function StrZero(piValor, piTamanho: integer): string;
Var
  liAux: integer;
  lsAux: string;
Begin
  lsAux := '';
  for liAux := length(IntToStr(piValor)) + 1 to piTamanho do
    lsAux := lsAux + '0';
  Result := lsAux + IntToStr(piValor);
End;

Function TiraPonto(Valor : String) : String;
Var
 i, n , Code : Integer;
begin
	Result := '';
	For i := 1 to Length(valor) do
	Begin
		Val(Copy(Valor,i,1), n, Code);
		If Code = 0 Then Result := Result + Copy(Valor,i,1);
	End;
end;

Procedure AbreForm(const AClasse: TFormClass; out Form; Modo : Integer; BackGround : Boolean);
Var
  Reference : TForm Absolute Form;  //acessa o mesmo endereço de memória de Form porém com tipagem
Begin
  { MODO -> 0 - SHOW, 1 - SHOWMODAL }

  If not Assigned(Reference) then
    Application.CreateForm(AClasse,Form);

  Case Modo Of
    0: Reference.Show;
    1:
    Begin
      If BackGround Then
        FormBackground;

      Reference.ShowModal;
      Reference.Release;
      FreeAndNil(Form);

      If BackGround Then
        FormBackground;
    End;
  end;
End;

end.

unit U_WebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer,
  Web.WebFileDispatcher, Web.HTTPProd,
  DataSnap.DSAuth,
  Datasnap.DSProxyJavaScript, IPPeerServer, Datasnap.DSMetadata,
  Datasnap.DSServerMetadata, Datasnap.DSClientMetadata, Datasnap.DSCommonServer,
  Datasnap.DSHTTP,
  VCL.Dialogs,
  Web.WebReq,
  System.JSON,
  System.StrUtils;

type
  TWebModule1 = class(TWebModule)
    DSHTTPWebDispatcher1: TDSHTTPWebDispatcher;
    DSServer1: TDSServer;
    DSProxyGenerator1: TDSProxyGenerator;
    DSServerMetaDataProvider1: TDSServerMetaDataProvider;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebFileDispatcher1BeforeDispatch(Sender: TObject;
      const AFileName: string; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
  private
    { Private declarations }
    Procedure IncluiRegistro(Tabela : String);
    Procedure ApagaRegistro(Tabela : String);
    Procedure AlteraRegistro(Tabela : String);
    Function RegistrosTabela(Tabela : String) : String;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation


{$R *.dfm}

uses
  U_DataModule;


Function TWebModule1.RegistrosTabela(Tabela : String) : String;
Var
  jsonTabela   : TJSONArray;
  jsonRegistro : TJSONObject;
Begin

  Try
    With TdssmWK.Create(nil) do
    Begin
      With qryGeral do
      Begin
        Close;
        SQL.Clear;

        jsonTabela    := TJSONArray.Create;

        jsonRegistro := TJSONObject.Create;

        Case IndexStr(UpperCase(Tabela),['PESSOA','ENDERECO'])  of
          0:
          Begin
            SQL.Add('SELECT A.*, B.DSCEP FROM '+Tabela+' A LEFT JOIN ENDERECO B ON A.IDPESSOA = B.IDPESSOA');
            Open();

            If IsEmpty Then
            Begin
              With jsonRegistro do
              Begin
                AddPair('idpessoa',TJSONNull.Create);
                AddPair('flnatureza',TJSONNull.Create);
                AddPair('dsdocumento',TJSONNull.Create);
                AddPair('nmprimeiro',TJSONNull.Create);
                AddPair('nmsegundo',TJSONNull.Create);
                AddPair('dscep',TJSONNull.Create);
                AddPair('dtregistro',TJSONNull.Create);
              End;

              jsonTabela.AddElement(jsonRegistro);
            End;

            While Not Eof do
            Begin
              jsonRegistro := TJSONObject.Create;

              With jsonRegistro do
              Begin
                AddPair('idpessoa',TJSONNumber.Create(FieldByName('idpessoa').AsInteger));
                AddPair('flnatureza',TJSONNumber.Create(FieldByName('flnatureza').AsInteger));
                AddPair('dsdocumento',FieldByName('dsdocumento').AsString);
                AddPair('nmprimeiro',FieldByName('nmprimeiro').AsString);
                AddPair('nmsegundo',FieldByName('nmsegundo').AsString);
                AddPair('dscep',FieldByName('dscep').AsString);
                AddPair('dtregistro',FieldByName('dtregistro').AsString);
              End;

              jsonTabela.AddElement(jsonRegistro);

              Next;
            End;
          End;
          1:
          Begin
            If IsEmpty Then
            Begin
              With jsonRegistro do
              Begin
                AddPair('idendereco',TJSONNull.Create);
                AddPair('idpessoa',TJSONNull.Create);
                AddPair('dscep',TJSONNull.Create);
              End;
            End;

            While Not Eof do
            Begin
              With jsonRegistro do
              Begin
                Create;
                AddPair('idendereco',TJSONNumber.Create(FieldByName('idendereco').AsInteger));
                AddPair('idpessoa',TJSONNumber.Create(FieldByName('idpessoa').AsInteger));
                AddPair('dscep',FieldByName('dscep').AsString);

                Next;
              End;
            End;
          End;
        End;

        Response.StatusCode := 200; // Success;

        Result :=   jsonTabela.ToJSON;

        jsonRegistro.DisposeOf;

//        jsonTabela.DisposeOf;
      End;
      Free;
    End;
  Except
    With TJSONObject.Create do
    Begin
      AddPair('Erro',TJSONString.Create('Servidor Off-Line...'));

      Response.StatusCode := 400; // Bad Request;

      Result := ToJSON;

      DisposeOf;
    End;
  End;
End;

Procedure TWebModule1.IncluiRegistro(Tabela : String);
Var
  jsonRegistro : TJSONObject;
Begin

  Try
    With TdssmWK.Create(nil) do
    Begin
      With qryGeral do
      Begin
        Close;
        SQL.Clear;

        jsonRegistro := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;

        Case IndexStr(UpperCase(Tabela),['PESSOA','ENDERECO'])  of
          0:
          Begin
            SQL.Add('SELECT');
            SQL.Add('  INCLUIPESSOA(:FLNATUREZA,:DSDOCUMENTO, :NMPRIMEIRO, :NMSEGUNDO, :DSCEP)');

            ParamByName('FLNATUREZA').Value   := jsonRegistro.GetValue<integer>('flnatureza');
            ParamByName('DSDOCUMENTO').Value  := jsonRegistro.GetValue<string>('dsdocumento');
            ParamByName('NMPRIMEIRO').Value   := jsonRegistro.GetValue<string>('nmprimeiro');
            ParamByName('NMSEGUNDO').Value    := jsonRegistro.GetValue<string>('nmsegundo');
            ParamByName('DSCEP').Value        := jsonRegistro.GetValue<string>('dscep');
          End;
          1:
          Begin
          End;
        End;

        Open;

        { RETORNA REGISTROS EXISTENTES }

        Response.Content := RegistrosTabela('PESSOA');

        Response.StatusCode := 200;

        jsonRegistro.DisposeOf;
      End;
      Free;
    End;
  Except
    With TJSONObject.Create do
    Begin
      AddPair('Erro',TJSONString.Create('Servidor Off-Line...'));

      Response.StatusCode := 400; // Bad Request;

      Response.Content := ToJSON;

      DisposeOf;
    End;
  End;
End;


Procedure TWebModule1.ApagaRegistro(Tabela : String);
Var
  jsonRegistro : TJSONObject;
Begin

  Try
    With TdssmWK.Create(nil) do
    Begin
      With qryGeral do
      Begin
        Close;
        SQL.Clear;

        jsonRegistro := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;

        Case IndexStr(UpperCase(Tabela),['PESSOA','ENDERECO'])  of
          0:
          Begin
            SQL.Add('DELETE FROM PESSOA WHERE IDPESSOA = :IDPESSOA');

            ParamByName('idpessoa').Value := jsonRegistro.GetValue<integer>('idpessoa');

            ExecSQL;

            { RETORNA REGISTROS EXISTENTES }

            Response.Content := RegistrosTabela('PESSOA');

          End;
          1:
          Begin
          End;
        End;


        Response.StatusCode := 200;

        jsonRegistro.DisposeOf;

      End;
      Free;
    End;
  Except
    With TJSONObject.Create do
    Begin
      AddPair('Erro',TJSONString.Create('Servidor Off-Line...'));

      Response.StatusCode := 400; // Bad Request;

      Response.Content := ToJSON;

      DisposeOf;
    End;
  End;
End;

Procedure TWebModule1.AlteraRegistro(Tabela : String);
Var
  jsonRegistro : TJSONObject;
Begin

  Try
    With TdssmWK.Create(nil) do
    Begin
      With qryGeral do
      Begin
        Close;
        SQL.Clear;

        jsonRegistro := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;

        Case IndexStr(UpperCase(Tabela),['PESSOA','ENDERECO'])  of
          0:
          Begin
            SQL.Add('UPDATE PESSOA SET');
            SQL.Add('  FLNATUREZA  = :FLNATUREZA,');
            SQL.Add('  DSDOCUMENTO = :DSDOCUMENTO,');
            SQL.Add('  NMPRIMEIRO  = :NMPRIMEIRO,');
            SQL.Add('  NMSEGUNDO   = :NMSEGUNDO');
            SQL.Add('WHERE');
            SQL.Add(' IDPESSOA = :IDPESSOA');

            ParamByName('IDPESSOA').Value     := jsonRegistro.GetValue<integer>('idpessoa');
            ParamByName('FLNATUREZA').Value   := jsonRegistro.GetValue<integer>('flnatureza');
            ParamByName('DSDOCUMENTO').Value  := jsonRegistro.GetValue<string>('dsdocumento');
            ParamByName('NMPRIMEIRO').Value   := jsonRegistro.GetValue<string>('nmprimeiro');
            ParamByName('NMSEGUNDO').Value    := jsonRegistro.GetValue<string>('nmsegundo');

            ExecSQL;

            SQL.Clear;
            SQL.Add('UPDATE ENDERECO SET');
            SQL.Add('  DSCEP = :DSCEP');
            SQL.Add('WHERE');
            SQL.Add(' IDPESSOA = :IDPESSOA');

            ParamByName('IDPESSOA').Value     := jsonRegistro.GetValue<integer>('idpessoa');
            ParamByName('DSCEP').Value        := jsonRegistro.GetValue<string>('dscep');

            ExecSQL;

            { RETORNA REGISTROS EXISTENTES }

            Response.Content := RegistrosTabela('PESSOA');

          End;
          1:
          Begin
          End;
        End;


        Response.StatusCode := 200;

        jsonRegistro.DisposeOf;

      End;
      Free;
    End;
  Except
    With TJSONObject.Create do
    Begin
      AddPair('Erro',TJSONString.Create('Servidor Off-Line...'));

      Response.StatusCode := 400; // Bad Request;

      Response.Content := ToJSON;

      DisposeOf;
    End;
  End;
End;


procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
Var
  strPathInfo, Tabela: string;
  ErroReq : Boolean;
begin


  // Recebendo o PathInfo constante na Request
  strPathInfo := Request.InternalPathInfo;

  // Atribuindo o Content-Type da resposta como padrão para todas elas
  Response.ContentType := 'application/json';

  ErroReq := True;

  If strPathInfo = '/wk/pessoa'   Then
  Begin
    ErroReq := False;
    Tabela  := 'PESSOA';
  End;

  If strPathInfo = '/wk/endereco' Then
  Begin
    ErroReq := False;
    Tabela  := 'ENDERECO';
  End;

  If ErroReq Then
  Begin
    with TJSONArray.Create do
    begin
      Add('Caminho para a solicitação inválido...');

      Response.Content    := ToJSON;
      Response.StatusCode := 400; // Bad Request;

      DisposeOf;
      Exit;
    end;
  end;

  Case Request.MethodType of
    mtDelete : ApagaRegistro(Tabela);
    mtGet    : Response.Content := RegistrosTabela(Tabela);
    mtPost   : IncluiRegistro(Tabela);
    mtPut    : AlteraRegistro(Tabela);
  end;





  // Verificando se o comprimento do caminho (wk/) está correto
  // Senão estiver, emita uma mensagem de erro e saia

{
  if not bufPathInfo.Count.Equals(1) then
  begin
    with TJSONObject.Create do
    begin
      AddBooleanPair('sucesso', False);
      AddStringPair('mensagem', 'Caminho para a solicitação inválido.');
      Response.Content := Minify;
      Response.StatusCode := 400; // Bad Request
      Free;
      Exit;
    end;
  end;
}




end;

procedure TWebModule1.WebFileDispatcher1BeforeDispatch(Sender: TObject;
  const AFileName: string; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  D1, D2: TDateTime;
begin
end;

initialization
finalization
  Web.WebReq.FreeWebModules;

end.


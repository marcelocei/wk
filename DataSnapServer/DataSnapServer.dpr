program DataSnapServer;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  U_DataSnapServer in 'U_DataSnapServer.pas' {Form1},
  U_WebModule in 'U_WebModule.pas' {WebModule1: TWebModule},
  U_DataModule in 'U_DataModule.pas' {dssmWK: TDSServerModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

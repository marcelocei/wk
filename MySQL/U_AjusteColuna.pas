unit U_AjusteColuna;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAjusteColuna = class(TForm)
    Panel3: TPanel;
    GBColuna: TGroupBox;
    edtColuna: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAjusteColuna: TfrmAjusteColuna;

implementation

{$R *.dfm}

uses U_Funcoes;

procedure TfrmAjusteColuna.FormActivate(Sender: TObject);
begin
  edtColuna.SetFocus;
end;

procedure TfrmAjusteColuna.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN Then
    Close;
end;

procedure TfrmAjusteColuna.FormShow(Sender: TObject);
begin
  AjusteScala(Self);
end;

end.

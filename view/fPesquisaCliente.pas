unit fPesquisaCliente;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.Controls;

type
  TfrmPesquisaCliente = class(TForm)
    lblTitulo: TLabel;

    lblNome: TLabel;
    edtNome: TEdit;

    lblDoc: TLabel;
    edtDoc: TEdit;

    btnPesquisar: TButton;
    btnLimpar: TButton;
    btnSelecionar: TButton;

    grdClientes: TStringGrid;

    procedure FormCreate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure grdClientesDblClick(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtDocKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fIdSelecionado: Integer;
    procedure configurarGrid;
    procedure pesquisar;
  public
    property idSelecionado: Integer read fIdSelecionado;
  end;

var
  frmPesquisaCliente: TfrmPesquisaCliente;

implementation

uses
  FireDAC.Comp.Client,
  fPrincipal;

{$R *.dfm}

procedure TfrmPesquisaCliente.FormCreate(Sender: TObject);
begin
  configurarGrid;
end;

procedure TfrmPesquisaCliente.configurarGrid;
begin
  grdClientes.Options := grdClientes.Options + [goColSizing, goRowSelect];
  grdClientes.ColCount := 5;
  grdClientes.RowCount := 1;

  grdClientes.Cells[0,0] := 'ID';
  grdClientes.Cells[1,0] := 'Nome/Razão';
  grdClientes.Cells[2,0] := 'Tipo';
  grdClientes.Cells[3,0] := 'CPF/CNPJ';
  grdClientes.Cells[4,0] := 'UF';

  grdClientes.ColWidths[0] := 60;
  grdClientes.ColWidths[1] := 300;
  grdClientes.ColWidths[2] := 60;
  grdClientes.ColWidths[3] := 150;
  grdClientes.ColWidths[4] := 60;
end;

procedure TfrmPesquisaCliente.btnPesquisarClick(Sender: TObject);
begin
  pesquisar;
end;

procedure TfrmPesquisaCliente.edtNomeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then pesquisar;
end;

procedure TfrmPesquisaCliente.edtDocKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then pesquisar;
end;

procedure TfrmPesquisaCliente.pesquisar;
var
  qr: TFDQuery;
begin
  grdClientes.RowCount := 1;

  qr := TFDQuery.Create(nil);
  try
    qr.Connection := frmPrincipal.fdConnection;

    qr.SQL.Add('SELECT * FROM CLIENTE');
    qr.SQL.Add('WHERE 1=1');

    if Trim(edtNome.Text) <> '' then
      qr.SQL.Add('AND UPPER(NOME_RAZAO) LIKE :NOME');

    if Trim(edtDoc.Text) <> '' then
      qr.SQL.Add('AND CPF_CNPJ LIKE :DOC');

    if Trim(edtNome.Text) <> '' then
      qr.ParamByName('NOME').AsString := '%' + UpperCase(edtNome.Text) + '%';

    if Trim(edtDoc.Text) <> '' then
      qr.ParamByName('DOC').AsString := '%' + edtDoc.Text + '%';

    qr.Open;

    while not qr.Eof do
    begin
      grdClientes.RowCount := grdClientes.RowCount + 1;

      grdClientes.Cells[0,grdClientes.RowCount-1] := qr.FieldByName('ID_CLIENTE').AsString;
      grdClientes.Cells[1,grdClientes.RowCount-1] := qr.FieldByName('NOME_RAZAO').AsString;
      grdClientes.Cells[2,grdClientes.RowCount-1] := qr.FieldByName('TIPO_PESSOA').AsString;
      grdClientes.Cells[3,grdClientes.RowCount-1] := qr.FieldByName('CPF_CNPJ').AsString;
      grdClientes.Cells[4,grdClientes.RowCount-1] := qr.FieldByName('UF').AsString;

      qr.Next;
    end;

  finally
    qr.Free;
  end;
end;

procedure TfrmPesquisaCliente.btnLimparClick(Sender: TObject);
begin
  edtNome.Clear;
  edtDoc.Clear;
  grdClientes.RowCount := 1;
end;

procedure TfrmPesquisaCliente.btnSelecionarClick(Sender: TObject);
begin
  if grdClientes.Row > 0 then
  begin
    fIdSelecionado := StrToIntDef(grdClientes.Cells[0,grdClientes.Row],0);
    ModalResult := mrOk;
  end;
end;

procedure TfrmPesquisaCliente.grdClientesDblClick(Sender: TObject);
begin
  btnSelecionarClick(Sender);
end;

end.

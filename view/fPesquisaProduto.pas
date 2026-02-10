unit fPesquisaProduto;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.Controls;

type
  TfrmPesquisaProduto = class(TForm)
    lblTitulo: TLabel;

    lblDescricao: TLabel;
    edtDescricao: TEdit;

    btnPesquisar: TButton;
    btnLimpar: TButton;
    btnSelecionar: TButton;

    grdProdutos: TStringGrid;

    procedure FormCreate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure grdProdutosDblClick(Sender: TObject);
    procedure edtDescricaoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fIdSelecionado: Integer;
    procedure configurarGrid;
    procedure pesquisar;
  public
    property idSelecionado: Integer read fIdSelecionado;
  end;

var
  frmPesquisaProduto: TfrmPesquisaProduto;

implementation

uses
  FireDAC.Comp.Client,
  fPrincipal;

{$R *.dfm}

procedure TfrmPesquisaProduto.FormCreate(Sender: TObject);
begin
  configurarGrid;
end;

procedure TfrmPesquisaProduto.configurarGrid;
begin
  grdProdutos.Options := grdProdutos.Options + [goColSizing, goRowSelect];

  grdProdutos.ColCount := 5;
  grdProdutos.RowCount := 1;

  grdProdutos.Cells[0,0] := 'ID';
  grdProdutos.Cells[1,0] := 'Descrição';
  grdProdutos.Cells[2,0] := 'NCM';
  grdProdutos.Cells[3,0] := 'CFOP';
  grdProdutos.Cells[4,0] := 'Preço';

  grdProdutos.ColWidths[0] := 60;
  grdProdutos.ColWidths[1] := 300;
  grdProdutos.ColWidths[2] := 100;
  grdProdutos.ColWidths[3] := 80;
  grdProdutos.ColWidths[4] := 100;
end;

procedure TfrmPesquisaProduto.btnPesquisarClick(Sender: TObject);
begin
  pesquisar;
end;

procedure TfrmPesquisaProduto.edtDescricaoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    pesquisar;
end;

procedure TfrmPesquisaProduto.pesquisar;
var
  qr: TFDQuery;
begin
  grdProdutos.RowCount := 1;

  qr := TFDQuery.Create(nil);
  try
    qr.Connection := frmPrincipal.fdConnection;

    qr.SQL.Add('SELECT * FROM PRODUTO');
    qr.SQL.Add('WHERE 1=1');

    if Trim(edtDescricao.Text) <> '' then
      qr.SQL.Add('AND UPPER(DESCRICAO) LIKE :DESC');

    if Trim(edtDescricao.Text) <> '' then
      qr.ParamByName('DESC').AsString := '%' + UpperCase(edtDescricao.Text) + '%';

    qr.Open;

    while not qr.Eof do
    begin
      grdProdutos.RowCount := grdProdutos.RowCount + 1;

      grdProdutos.Cells[0,grdProdutos.RowCount-1] := qr.FieldByName('ID_PRODUTO').AsString;
      grdProdutos.Cells[1,grdProdutos.RowCount-1] := qr.FieldByName('DESCRICAO').AsString;
      grdProdutos.Cells[2,grdProdutos.RowCount-1] := qr.FieldByName('NCM').AsString;
      grdProdutos.Cells[3,grdProdutos.RowCount-1] := qr.FieldByName('CFOP_PADRAO').AsString;
      grdProdutos.Cells[4,grdProdutos.RowCount-1] := FormatFloat('#,##0.00', qr.FieldByName('PRECO_VENDA').AsFloat);

      qr.Next;
    end;

  finally
    qr.Free;
  end;
end;

procedure TfrmPesquisaProduto.btnLimparClick(Sender: TObject);
begin
  edtDescricao.Clear;
  grdProdutos.RowCount := 1;
end;

procedure TfrmPesquisaProduto.btnSelecionarClick(Sender: TObject);
begin
  if grdProdutos.Row > 0 then
  begin
    fIdSelecionado := StrToIntDef(grdProdutos.Cells[0,grdProdutos.Row],0);
    ModalResult := mrOk;
  end;
end;

procedure TfrmPesquisaProduto.grdProdutosDblClick(Sender: TObject);
begin
  btnSelecionarClick(Sender);
end;

end.

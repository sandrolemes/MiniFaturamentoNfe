unit fPedidoVenda;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.Controls,
  Vcl.Dialogs;

type
  TfrmPedidoVenda = class(TForm)
    lblTitulo: TLabel;

    lblCliente: TLabel;
    edtIdCliente: TEdit;
    edtNomeCliente: TEdit;

    lblProduto: TLabel;
    edtIdProduto: TEdit;

    lblDescricao: TLabel;
    edtDescricao: TEdit;

    lblQuantidade: TLabel;
    edtQuantidade: TEdit;

    lblPreco: TLabel;
    edtPreco: TEdit;

    grdItens: TStringGrid;

    lblTotal: TLabel;
    edtTotal: TEdit;

    btnGravar: TButton;
    btnPesquisarCliente: TButton;
    Button1: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure edtIdClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtIdProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure grdItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure btnGravarClick(Sender: TObject);
    procedure btnPesquisarClienteClick(Sender: TObject);
    procedure edtPrecoKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure edtPrecoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure configurarGrid;
    procedure carregarCliente;
    procedure carregarProduto;
    procedure adicionarItem;
    procedure removerLinha(pRow: Integer);
    procedure limparItens;
    procedure recalcularTotal;
    procedure pesquisarrCliente;
    procedure pesquisarrProduto;
  public
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

uses
  uClienteDao,
  uClienteDto,
  uProdutoDao,
  uProdutoDto,
  uPedidoDto,
  uPedidoItemDto,
  uPedidoController,
  fPrincipal,
  fPesquisaCliente,
  fPesquisaProduto,
  uUtils;

{$R *.dfm}

procedure TfrmPedidoVenda.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  configurarGrid;
end;

procedure TfrmPedidoVenda.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // ESC fecha tela
  if Key = VK_ESCAPE then
    Close;

  // CTRL+S grava pedido
  if (Key = Ord('S')) and (ssCtrl in Shift) then
    btnGravarClick(Self);
end;

procedure TfrmPedidoVenda.configurarGrid;
begin
  grdItens.ColCount := 5;

  grdItens.Cells[0,0] := 'PRODUTO';
  grdItens.Cells[1,0] := 'DESCRICAO';
  grdItens.Cells[2,0] := 'QTDE';
  grdItens.Cells[3,0] := 'PRECO';
  grdItens.Cells[4,0] := 'TOTAL';
end;

procedure TfrmPedidoVenda.edtIdClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    carregarCliente;

  if Key = VK_F2 then
    pesquisarrCliente;

  if Key = VK_F3 then
    pesquisarrProduto;

end;

procedure TfrmPedidoVenda.pesquisarrProduto;
begin
  if frmPesquisaProduto.ShowModal = mrOk then
  begin
    edtIdProduto.Text := IntToStr(frmPesquisaProduto.idSelecionado);
    carregarProduto;
    if edtQuantidade.CanFocus then
      edtQuantidade.SetFocus;
  end;
end;

procedure TfrmPedidoVenda.pesquisarrCliente;
begin
  if frmPesquisaCliente.ShowModal = mrOk then
  begin
    edtIdCliente.Text := IntToStr(frmPesquisaCliente.idSelecionado);
    carregarCliente;
    if edtIdProduto.CanFocus then
      edtIdProduto.SetFocus;
  end;
end;

procedure TfrmPedidoVenda.carregarCliente;
var
  dao: TClienteDao;
  dto: TClienteDto;
  idCli: Integer;
begin
  idCli := StrToIntDef(Trim(edtIdCliente.Text), 0);
  if idCli = 0 then Exit;

  dao := TClienteDao.Create(frmPrincipal.fdConnection);
  dto := TClienteDto.Create;
  try
    if dao.obterPorId(idCli, dto) then
      edtNomeCliente.Text := dto.nomeRazao
    else
      ShowMessage('Cliente não encontrado.');
  finally
    dto.Free;
    dao.Free;
  end;
end;

procedure TfrmPedidoVenda.edtIdProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    carregarProduto;

  if Key = VK_F2 then
    ShowMessage('Busca de produto (futura implementação)');
end;

procedure TfrmPedidoVenda.edtPrecoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    adicionarItem;
end;

procedure TfrmPedidoVenda.edtPrecoKeyPress(Sender: TObject; var Key: Char);
begin
  uUtils.editMoedaKeyPress(edtPreco, Key);
end;

procedure TfrmPedidoVenda.carregarProduto;
var
  dao: TProdutoDao;
  dto: TProdutoDto;
  idProd: Integer;
begin
  idProd := StrToIntDef(Trim(edtIdProduto.Text), 0);
  if idProd = 0 then Exit;

  dao := TProdutoDao.Create(frmPrincipal.fdConnection);
  dto := TProdutoDto.Create;
  try
    if dao.obterPorId(idProd, dto) then
    begin
      edtDescricao.Text := dto.descricao;
      edtPreco.Text := FormatCurr(',0.00', dto.precoVenda);
      edtQuantidade.SetFocus;
    end
    else
      ShowMessage('Produto não encontrado.');
  finally
    dto.Free;
    dao.Free;
  end;
end;

procedure TfrmPedidoVenda.adicionarItem;
var
  row: Integer;
  qtd: Double;
  vl: Currency;
  idProd: Integer;
begin
  idProd := StrToIntDef(edtIdProduto.Text,0);
  qtd := StrToFloatDef(edtQuantidade.Text,0);
  vl := StrToCurrDef(edtPreco.Text,0);

  if (idProd = 0) or (qtd <= 0) then Exit;

  row := grdItens.RowCount;
  grdItens.RowCount := row + 1;

  grdItens.Cells[0,row] := IntToStr(idProd);
  grdItens.Cells[1,row] := edtDescricao.Text;
  grdItens.Cells[2,row] := FloatToStr(qtd);
  grdItens.Cells[3,row] := FormatCurr(',0.00', vl);
  grdItens.Cells[4,row] := FormatCurr(',0.00', qtd * vl);

  edtIdProduto.Clear;
  edtDescricao.Clear;
  edtQuantidade.Clear;
  edtPreco.Clear;
  edtIdProduto.SetFocus;

  recalcularTotal;
end;

procedure TfrmPedidoVenda.removerLinha(pRow: Integer);
var
  i: Integer;
begin
  if (pRow <= 0) or (pRow >= grdItens.RowCount) then Exit;

  for i := pRow to grdItens.RowCount - 2 do
    grdItens.Rows[i] := grdItens.Rows[i+1];

  grdItens.RowCount := grdItens.RowCount - 1;
  recalcularTotal;
end;

procedure TfrmPedidoVenda.limparItens;
begin
  grdItens.RowCount := 1;
  edtTotal.Clear;
end;

procedure TfrmPedidoVenda.grdItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if ssCtrl in Shift then
      limparItens
    else
      removerLinha(grdItens.Row);
  end;
end;

procedure TfrmPedidoVenda.recalcularTotal;
var
  i: Integer;
  total: Currency;
begin
  total := 0;

  for i := 1 to grdItens.RowCount - 1 do
    total := total + StrToCurrDef(grdItens.Cells[4,i],0);

  edtTotal.Text := FormatCurr(',0.00', total);
end;

procedure TfrmPedidoVenda.btnGravarClick(Sender: TObject);
var
  pedido: TPedidoDto;
  item: TPedidoItemDto;
  controller: TPedidoController;
  i: Integer;
begin
  if StrToIntDef(edtIdCliente.Text,0) = 0 then
  begin
    ShowMessage('Informe o cliente.');
    Exit;
  end;

  if grdItens.RowCount <= 1 then
  begin
    ShowMessage('Adicione itens.');
    Exit;
  end;

  pedido := TPedidoDto.Create;
  controller := TPedidoController.Create;
  try
    pedido.idCliente := StrToIntDef(edtIdCliente.Text,0);
    pedido.total := StrToCurrDef(edtTotal.Text,0);

    for i := 1 to grdItens.RowCount - 1 do
    begin
      item := TPedidoItemDto.Create;
      item.idProduto := StrToIntDef(grdItens.Cells[0,i],0);
      item.descricao := grdItens.Cells[1,i];
      item.quantidade := StrToFloatDef(grdItens.Cells[2,i],0);
      item.vlUnitario := StrToCurrDef(grdItens.Cells[3,i],0);

      pedido.itens.Add(item);
    end;

    controller.gravar(frmPrincipal.fdConnection, pedido);

    ShowMessage('Pedido gravado.');

    limparItens;
    edtIdCliente.Clear;
    edtNomeCliente.Clear;

  finally
    pedido.Free;
    controller.Free;
  end;
end;

procedure TfrmPedidoVenda.btnPesquisarClienteClick(Sender: TObject);
begin
  pesquisarrCliente;
end;

procedure TfrmPedidoVenda.Button1Click(Sender: TObject);
begin
  pesquisarrProduto;
end;

end.



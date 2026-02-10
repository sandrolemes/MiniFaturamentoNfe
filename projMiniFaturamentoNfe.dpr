program projMiniFaturamentoNfe;

uses
  Vcl.Forms,
  fCadastroCliente in 'view\fCadastroCliente.pas' {frmCadastroCliente},
  fCadastroProduto in 'view\fCadastroProduto.pas' {frmCadastroProduto},
  fFaturamentoNfe in 'view\fFaturamentoNfe.pas' {frmFaturamentoNfe},
  fPedidoVenda in 'view\fPedidoVenda.pas' {frmPedidoVenda},
  fPrincipal in 'view\fPrincipal.pas' {frmPrincipal},
  uStatusNfe in 'util\uStatusNfe.pas',
  uNfeAcbrService in 'service\uNfeAcbrService.pas',
  uSefazSimuladorService in 'service\uSefazSimuladorService.pas',
  uClienteDto in 'dto\uClienteDto.pas',
  uLogEventoDto in 'dto\uLogEventoDto.pas',
  uNfeDto in 'dto\uNfeDto.pas',
  uNfeEventoDto in 'dto\uNfeEventoDto.pas',
  uNfeStatus in 'dto\uNfeStatus.pas',
  uPedidoDto in 'dto\uPedidoDto.pas',
  uPedidoItemDto in 'dto\uPedidoItemDto.pas',
  uProdutoDto in 'dto\uProdutoDto.pas',
  uClienteDao in 'dao\uClienteDao.pas',
  uLogEventoDao in 'dao\uLogEventoDao.pas',
  uNfeDao in 'dao\uNfeDao.pas',
  uNfeEventoDao in 'dao\uNfeEventoDao.pas',
  uPedidoDao in 'dao\uPedidoDao.pas',
  uPedidoItemDao in 'dao\uPedidoItemDao.pas',
  uProdutoDao in 'dao\uProdutoDao.pas',
  uClienteController in 'controller\uClienteController.pas',
  uPedidoController in 'controller\uPedidoController.pas',
  uProdutoController in 'controller\uProdutoController.pas',
  uUtils in 'util\uUtils.pas',
  uNfeXmlService in 'service\uNfeXmlService.pas',
  uFaturamentoController in 'controller\uFaturamentoController.pas',
  fPesquisaCliente in 'view\fPesquisaCliente.pas' {frmPesquisaCliente},
  fPesquisaProduto in 'view\fPesquisaProduto.pas' {frmPesquisaProduto},
  fPesquisaPedido in 'view\fPesquisaPedido.pas' {frmPesquisaPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmPesquisaCliente, frmPesquisaCliente);
  Application.CreateForm(TfrmPesquisaProduto, frmPesquisaProduto);
  Application.CreateForm(TfrmPesquisaPedido, frmPesquisaPedido);
  Application.Run;
end.



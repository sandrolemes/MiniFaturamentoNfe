unit uNfeAcbrService;

interface

uses
  System.SysUtils;

type
  TNfeAcbrService = class
  public
    class procedure gerarXmlNfe(pIdPedido: Integer);
  end;

implementation

uses
  ACBrNFe,
  ACBrNFeDANFEClass,
  uPedidoDao,
  uPedidoItemDao,
  uClienteDao,
  uProdutoDao,
  uPedidoDto,
  uPedidoItemDto,
  uClienteDto,
  uProdutoDto;

class procedure TNfeAcbrService.gerarXmlNfe(pIdPedido: Integer);
var
  acbrNfe: TACBrNFe;
  pedidoDao: TPedidoDao;
  itemDao: TPedidoItemDao;
  clienteDao: TClienteDao;
  produtoDao: TProdutoDao;
  pedidoDto: TPedidoDto;
  clienteDto: TClienteDto;
  itemDto: TPedidoItemDto;
  produtoDto: TProdutoDto;
  i: Integer;
begin
  acbrNfe := TACBrNFe.Create(nil);
  pedidoDao := TPedidoDao.Create(nil);
  itemDao := TPedidoItemDao.Create(nil);
  clienteDao := TClienteDao.Create(nil);
  produtoDao := TProdutoDao.Create(nil);
  pedidoDto := TPedidoDto.Create;
  clienteDto := TClienteDto.Create;
  produtoDto := TProdutoDto.Create;
  try
    acbrNfe.NotasFiscais.Clear;
    acbrNfe.NotasFiscais.Add;

    // Pedido
    pedidoDao.obterPorId(pIdPedido, pedidoDto);

    // Cliente
    clienteDao.obterPorId(pedidoDto.idCliente, clienteDto);

    with acbrNfe.NotasFiscais.Items[0].NFe do
    begin
      ide.natOp := 'VENDA';
      ide.modelo := 55;
      ide.serie := 1;
      ide.nNF := 1;
      ide.dEmi := Now;

      emit.xNome := 'EMPRESA TESTE';
      emit.CNPJCPF := '12345678000190';
      emit.enderEmit.UF := 'SP';

      dest.xNome := clienteDto.nomeRazao;
      dest.CNPJCPF := clienteDto.cpfCnpj;
      dest.enderDest.UF := clienteDto.uf;
    end;

    // Itens
    for i := 0 to acbrNfe.NotasFiscais.Items[0].NFe.Det.Count - 1 do
    begin
      itemDto := TPedidoItemDto.Create;
      produtoDto := TProdutoDto.Create;
      try
        // Simplesmente ilustrativo para o teste
        produtoDao.obterPorId(itemDto.idProduto, produtoDto);

        with acbrNfe.NotasFiscais.Items[0].NFe.Det.Add do
        begin
          Prod.xProd := produtoDto.descricao;
          Prod.NCM := produtoDto.ncm;
          Prod.CFOP := produtoDto.cfopPadrao;
          Prod.qCom := itemDto.quantidade;
          Prod.vUnCom := itemDto.vlUnitario;
          Prod.vProd := itemDto.quantidade * itemDto.vlUnitario;
        end;
      finally
        produtoDto.Free;
        itemDto.Free;
      end;
    end;

    acbrNfe.NotasFiscais.GerarNFe;
  finally
    produtoDto.Free;
    clienteDto.Free;
    pedidoDto.Free;
    produtoDao.Free;
    clienteDao.Free;
    itemDao.Free;
    pedidoDao.Free;
    acbrNfe.Free;
  end;
end;

end.

unit uNfeXmlService;

interface

uses
  System.SysUtils,
  System.Classes,
  ACBrNFe,
  uPedidoDto;

type
  TNfeXmlService = class
  private
    procedure configurarBasico(pACBr: TACBrNFe);
    procedure adicionarIdentificacao(pACBr: TACBrNFe; pPedido: TPedidoDto);
    procedure adicionarEmitente(pACBr: TACBrNFe);
    procedure adicionarDestinatario(pACBr: TACBrNFe; pPedido: TPedidoDto);
    procedure adicionarItens(pACBr: TACBrNFe; pPedido: TPedidoDto);
    procedure adicionarTotais(pACBr: TACBrNFe; pPedido: TPedidoDto);
  public
    function gerarXml(pPedido: TPedidoDto): string;
  end;

implementation

uses
  uPedidoItemDto,
  ACBrNFe.Classes,
  ACBrDFe.Conversao,
  pcnConversao,
  pcnConversaoNFe,
  Winapi.Windows;

procedure TNfeXmlService.configurarBasico(pACBr: TACBrNFe);
begin
  pACBr.Configuracoes.Geral.ModeloDF := moNFe;
  pACBr.Configuracoes.Geral.VersaoDF := ve400;
  pACBr.Configuracoes.WebServices.UF := 'GO';
  pACBr.Configuracoes.WebServices.Ambiente := taHomologacao;
end;

procedure TNfeXmlService.adicionarIdentificacao(pACBr: TACBrNFe; pPedido: TPedidoDto);
begin
  with pACBr.NotasFiscais.Add.NFe.Ide do
  begin
    cUF := 52;
    natOp := 'VENDA';
    modelo := 55;
    serie := 1;
    nNF := pPedido.idPedido;
    dEmi := Now;
    tpNF := tnSaida;
    idDest := doInterna;
    tpImp := tiRetrato;
    tpEmis := teNormal;
    tpAmb := taHomologacao;
    finNFe := fnNormal;
    indFinal := cfConsumidorFinal;
    indPres := pcPresencial;
    procEmi := peAplicativoContribuinte;
    verProc := '1.1.26.1';
  end;
end;

procedure TNfeXmlService.adicionarEmitente(pACBr: TACBrNFe);
begin
  with pACBr.NotasFiscais.Items[0].NFe.Emit do
  begin
    CNPJCPF := '12345678000195';
    xNome := 'EMPRESA TESTE LTDA';
    xFant := 'EMPRESA TESTE';

    with enderEmit do
    begin
      xLgr := 'RUA EXEMPLO';
      nro := '100';
      xBairro := 'CENTRO';
      cMun := 5208707;
      xMun := 'GOIANIA';
      UF := 'GO';
      CEP := 74000000;
      cPais := 1058;
      xPais := 'BRASIL';
      fone := '6200000000';
    end;

    IE := '123456789';
    CRT := crtSimplesNacional;
  end;
end;

procedure TNfeXmlService.adicionarDestinatario(pACBr: TACBrNFe; pPedido: TPedidoDto);
begin
  with pACBr.NotasFiscais.Items[0].NFe.Dest do
  begin
    CNPJCPF := '00000000000';
    xNome := 'CLIENTE TESTE';

    with enderDest do
    begin
      xLgr := 'RUA CLIENTE';
      nro := '1';
      xBairro := 'CENTRO';
      cMun := 5208707;
      xMun := 'GOIANIA';
      UF := 'GO';
      CEP := 74000000;
      cPais := 1058;
      xPais := 'BRASIL';
      fone := '6200000000';
    end;

    indIEDest := inNaoContribuinte;
  end;
end;

procedure TNfeXmlService.adicionarItens(pACBr: TACBrNFe; pPedido: TPedidoDto);
var
  item: TPedidoItemDto;
  det: TDetCollectionItem;
  i: Integer;
begin
  i := 1;
  for item in pPedido.itens do
  begin
    det := pACBr.NotasFiscais.Items[0].NFe.Det.Add;

    with det do
    begin
      with prod do
      begin
        nItem := i;
        cProd := IntToStr(item.idProduto);
        xProd := item.descricao;
        NCM := '00000000';
        CFOP := '5102';
        uCom := 'UN';
        qCom := item.quantidade;
        vUnCom := item.vlUnitario;
        vProd := item.quantidade * item.vlUnitario;
        uTrib := 'UN';
        qTrib := qCom;
        vUnTrib := vUnCom;
        indTot := itSomaTotalNFe;
      end;

      with imposto do
      begin
        det.Imposto.ICMS.CSOSN := csosn102;
      end;
    end;



    Inc(i);
  end;
end;

procedure TNfeXmlService.adicionarTotais(pACBr: TACBrNFe; pPedido: TPedidoDto);
var
  total: Currency;
  item: TPedidoItemDto;
begin
  total := 0;

  for item in pPedido.itens do
    total := total + (item.quantidade * item.vlUnitario);

  with pACBr.NotasFiscais.Items[0].NFe.Total.ICMSTot do
  begin
    vProd := total;
    vNF := total;
  end;
end;

function TNfeXmlService.gerarXml(pPedido: TPedidoDto): string;
var
  acbr: TACBrNFe;
begin
  acbr := TACBrNFe.Create(nil);
  try
    configurarBasico(acbr);

    acbr.NotasFiscais.Clear;

    adicionarIdentificacao(acbr, pPedido);
    adicionarEmitente(acbr);
    adicionarDestinatario(acbr, pPedido);
    adicionarItens(acbr, pPedido);
    adicionarTotais(acbr, pPedido);

    acbr.NotasFiscais.GerarNFe;

    Result := acbr.NotasFiscais.Items[0].XML;

  finally
    acbr.Free;
  end;
end;

end.



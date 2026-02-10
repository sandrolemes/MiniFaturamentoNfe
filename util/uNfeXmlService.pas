unit uNfeXmlService;

interface

uses
  System.SysUtils,
  System.Classes,
  ACBrNFe,
  ACBrNFeNotasFiscais,
  ACBrNFeConfiguracoes,
  ACBrNFeDANFeClass,
  ACBrUtil,
  uPedidoDto,
  uPedidoItemDto;

type
  TNfeXmlService = class
  private
    function somenteNumeros(const pValor: string): string;
    procedure configurarBasico(pACBr: TACBrNFe);
    procedure adicionarIdentificacao(pACBr: TACBrNFe; pPedido: TPedidoDto);
    procedure adicionarEmitente(pACBr: TACBrNFe);
    procedure adicionarDestinatario(pACBr: TACBrNFe; pPedido: TPedidoDto);
    procedure adicionarItens(pACBr: TACBrNFe; pItens: TArray<TPedidoItemDto>);
    procedure adicionarTotais(pACBr: TACBrNFe; pItens: TArray<TPedidoItemDto>);
  public
    /// <summary>
    /// Gera o XML da NF-e em memória e retorna como string.
    /// </summary>
    function gerarXml(const pPedido: TPedidoDto; const pItens: TArray<TPedidoItemDto>): string;

    /// <summary>
    /// Gera o XML e salva em arquivo (retorna o caminho).
    /// </summary>
    function gerarXmlArquivo(const pPedido: TPedidoDto; const pItens: TArray<TPedidoItemDto>; const pCaminho: string): string;
  end;

implementation

function TNfeXmlService.somenteNumeros(const pValor: string): string;
var
  c: Char;
begin
  Result := '';
  for c in pValor do
    if c in ['0'..'9'] then
      Result := Result + c;
end;

procedure TNfeXmlService.configurarBasico(pACBr: TACBrNFe);
begin
  // Configurações mínimas para gerar XML
  pACBr.Configuracoes.Geral.ModeloDF := moNFe;
  pACBr.Configuracoes.Geral.VersaoDF := ve400;
  pACBr.Configuracoes.Geral.FormaEmissao := teNormal;

  // Ajuste conforme ambiente do teste
  pACBr.Configuracoes.WebServices.UF := 'GO';
  pACBr.Configuracoes.WebServices.Ambiente := taHomologacao;

  // Não vamos transmitir, só gerar XML
  pACBr.Configuracoes.Arquivos.Salvar := False;
end;

procedure TNfeXmlService.adicionarIdentificacao(pACBr: TACBrNFe; pPedido: TPedidoDto);
begin
  with pACBr.NotasFiscais.Add.NFe.infNFe.ide do
  begin
    cUF := 52; // GO
    natOp := 'VENDA DE MERCADORIA';
    mod_ := 55;
    serie := 1;
    nNF := pPedido.idPedido; // para teste
    dhEmi := Now;
    tpNF := tnSaida;
    idDest := iddInterna;
    tpImp := tiRetrato;
    tpEmis := teNormal;
    tpAmb := taHomologacao;
    finNFe := fnNormal;
    indFinal := cfConsumidorFinal;
    indPres := ipPresencial;
    procEmi := peAplicativoContribuinte;
    verProc := '1.0';
  end;
end;

procedure TNfeXmlService.adicionarEmitente(pACBr: TACBrNFe);
begin
  // DADOS FIXOS PARA TESTE – ajuste conforme necessário
  with pACBr.NotasFiscais.Items[0].NFe.infNFe.emit do
  begin
    CNPJ := '12345678000195';
    xNome := 'EMPRESA TESTE LTDA';
    xFant := 'EMPRESA TESTE';

    with enderEmit do
    begin
      xLgr := 'RUA EXEMPLO';
      nro := '100';
      xBairro := 'CENTRO';
      cMun := 5208707; // Goiânia
      xMun := 'GOIANIA';
      UF := 'GO';
      CEP := '74000000';
      cPais := 1058;
      xPais := 'BRASIL';
      fone := '6230000000';
    end;

    IE := '123456789';
    CRT := crtSimplesNacional;
  end;
end;

procedure TNfeXmlService.adicionarDestinatario(pACBr: TACBrNFe; pPedido: TPedidoDto);
begin
  // Como o PedidoDto não possui os dados completos do cliente,
  // aqui deixamos um exemplo básico.
  // Ideal: buscar dados reais via Controller antes de chamar este service.

  with pACBr.NotasFiscais.Items[0].NFe.infNFe.dest do
  begin
    CNPJCPF := '00000000000'; // ajuste conforme cliente real
    xNome := 'CLIENTE TESTE';

    with enderDest do
    begin
      xLgr := 'RUA CLIENTE';
      nro := '1';
      xBairro := 'CENTRO';
      cMun := 5208707;
      xMun := 'GOIANIA';
      UF := 'GO';
      CEP := '74000000';
      cPais := 1058;
      xPais := 'BRASIL';
      fone := '6200000000';
    end;

    indIEDest := inNaoContribuinte;
  end;
end;

procedure TNfeXmlService.adicionarItens(pACBr: TACBrNFe; pItens: TArray<TPedidoItemDto>);
var
  i: Integer;
  vItem: TPedidoItemDto;
begin
  for i := 0 to High(pItens) do
  begin
    vItem := pItens[i];

    with pACBr.NotasFiscais.Items[0].NFe.infNFe.det.Add do
    begin
      nItem := i + 1;

      with prod do
      begin
        cProd := IntToStr(vItem.idProduto);
        xProd := vItem.descricao;
        NCM := somenteNumeros(vItem.ncm);
        CFOP := somenteNumeros(vItem.cfop);
        uCom := 'UN';
        qCom := vItem.quantidade;
        vUnCom := vItem.vlUnitario;
        vProd := vItem.quantidade * vItem.vlUnitario;
        uTrib := 'UN';
        qTrib := qCom;
        vUnTrib := vUnCom;
        indTot := itCompoeTotal;
      end;

      // Impostos simplificados para teste
      with imposto do
      begin
        ICMS.ICMSSN102.CSOSN := 102;
      end;
    end;
  end;
end;

procedure TNfeXmlService.adicionarTotais(pACBr: TACBrNFe; pItens: TArray<TPedidoItemDto>);
var
  i: Integer;
  vTotal: Currency;
begin
  vTotal := 0;
  for i := 0 to High(pItens) do
    vTotal := vTotal + (pItens[i].quantidade * pItens[i].vlUnitario);

  with pACBr.NotasFiscais.Items[0].NFe.infNFe.total.ICMSTot do
  begin
    vProd := vTotal;
    vNF := vTotal;
  end;
end;

function TNfeXmlService.gerarXml(const pPedido: TPedidoDto; const pItens: TArray<TPedidoItemDto>): string;
var
  acbr: TACBrNFe;
  sl: TStringList;
begin
  acbr := TACBrNFe.Create(nil);
  sl := TStringList.Create;
  try
    configurarBasico(acbr);

    acbr.NotasFiscais.Clear;

    adicionarIdentificacao(acbr, pPedido);
    adicionarEmitente(acbr);
    adicionarDestinatario(acbr, pPedido);
    adicionarItens(acbr, pItens);
    adicionarTotais(acbr, pItens);

    // Gera XML em memória
    acbr.NotasFiscais.GerarNFe;

    acbr.NotasFiscais.Items[0].XML.SaveToStream(sl);
    Result := sl.Text;
  finally
    sl.Free;
    acbr.Free;
  end;
end;

function TNfeXmlService.gerarXmlArquivo(const pPedido: TPedidoDto; const pItens: TArray<TPedidoItemDto>; const pCaminho: string): string;
var
  vXml: string;
  vArquivo: string;
begin
  vXml := gerarXml(pPedido, pItens);

  vArquivo := IncludeTrailingPathDelimiter(pCaminho) +
              'NFe_Pedido_' + IntToStr(pPedido.idPedido) + '.xml';

  TFile.WriteAllText(vArquivo, vXml, TEncoding.UTF8);
  Result := vArquivo;
end;

end.

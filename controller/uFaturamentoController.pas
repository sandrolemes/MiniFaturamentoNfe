unit uFaturamentoController;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uPedidoDto;

type
  TFaturamentoController = class
  private
    function simularRetornoSefaz: string;
    procedure registrarEvento(pConexao: TFDConnection; pIdNfe: Integer;
      pStatusAntes, pStatusDepois, pMotivo: string);
  public
    function faturarPedido(pConexao: TFDConnection; pPedido: TPedidoDto): Integer;
    procedure enviarParaSefaz(pConexao: TFDConnection; pIdNfe: Integer);
    procedure reprocessarNfe(pConexao: TFDConnection; pIdNfe: Integer);
    procedure cancelarNfe(pConexao: TFDConnection; pIdPedido: Integer; pIdNFe: Integer; pMotivo: string);
  end;

implementation

uses
  uNfeDao,
  uNfeDto,
  uNfeXmlService;

function TFaturamentoController.simularRetornoSefaz: string;
var
  r: Integer;
begin
  Randomize;
  r := Random(100);

  if r < 70 then
    Result := 'AUTORIZADA'
  else if r < 90 then
    Result := 'REJEITADA'
  else
    Result := 'CONTINGENCIA';
end;

procedure TFaturamentoController.registrarEvento(pConexao: TFDConnection;
  pIdNfe: Integer; pStatusAntes, pStatusDepois, pMotivo: string);
var
  qr: TFDQuery;
begin
  qr := TFDQuery.Create(nil);
  try
    qr.Connection := pConexao;

    qr.SQL.Add('INSERT INTO NFE_EVENTO (');
    qr.SQL.Add('ID_NFE_EVENTO, ID_NFE, DT_EVENTO, STATUS_ANTES, STATUS_DEPOIS, MOTIVO)');
    qr.SQL.Add('VALUES (');
    qr.SQL.Add('NEXT VALUE FOR GEN_NFE_EVENTO, :ID, :DT, :ANTES, :DEPOIS, :MOTIVO)');

    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.ParamByName('DT').AsDateTime := Now;
    qr.ParamByName('ANTES').AsString := pStatusAntes;
    qr.ParamByName('DEPOIS').AsString := pStatusDepois;
    qr.ParamByName('MOTIVO').AsString := pMotivo;

    qr.ExecSQL;
  finally
    qr.Free;
  end;
end;

function TFaturamentoController.faturarPedido(pConexao: TFDConnection; pPedido: TPedidoDto): Integer;
var
  nfeDao: TNfeDao;
  nfeDto: TNfeDto;
  xmlService: TNfeXmlService;
  xml: string;
begin
  xmlService := TNfeXmlService.Create;
  nfeDao := TNfeDao.Create(pConexao);
  nfeDto := TNfeDto.Create;
  try
    xml := xmlService.gerarXml(pPedido);

    registrarEvento(pConexao, Result, '', 'RASCUNHO', 'NF-e gerada');

    nfeDto.idPedido := pPedido.idPedido;
    nfeDto.serie := 1;
    nfeDto.numero := pPedido.idPedido;
    nfeDto.dtEmissao := Now;
    nfeDto.statusAtual := 'RASCUNHO';
    nfeDto.xml := xml;


    Result := nfeDao.gravar(nfeDto);
    registrarEvento(pConexao, Result, '', 'RASCUNHO', 'NF-e gerada');


  finally
    xmlService.Free;
    nfeDao.Free;
    nfeDto.Free;
  end;
end;

procedure TFaturamentoController.enviarParaSefaz(pConexao: TFDConnection; pIdNfe: Integer);
var
  statusNovo: string;
  qr: TFDQuery;
  statusAnterior: string;
begin
  qr := TFDQuery.Create(nil);
  try
    qr.Connection := pConexao;

    qr.SQL.Add('SELECT STATUS_ATUAL FROM NFE WHERE ID_NFE = :ID');
    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.Open;

    statusAnterior := qr.Fields[0].AsString;

    statusNovo := simularRetornoSefaz;

    qr.Close;
    qr.SQL.Clear;

    qr.SQL.Add('UPDATE NFE SET STATUS_ATUAL = :S WHERE ID_NFE = :ID');
    qr.ParamByName('S').AsString := statusNovo;
    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.ExecSQL;

    registrarEvento(pConexao, pIdNfe, statusAnterior, statusNovo, 'Retorno SEFAZ');

  finally
    qr.Free;
  end;
end;

procedure TFaturamentoController.reprocessarNfe(pConexao: TFDConnection; pIdNfe: Integer);
var
  qr: TFDQuery;
  statusAnterior: string;
begin
  try
    qr := TFDQuery.Create(nil);
    qr.Connection := pConexao;

    qr.SQL.Add('SELECT STATUS_ATUAL FROM NFE WHERE ID_NFE = :ID');
    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.Open;

    statusAnterior := qr.FieldByName('STATUS_ATUAL').AsString;

    if statusAnterior <> 'REJEITADA' then
      raise Exception.Create('Só é permitido reprocessar NF-e rejeitada.');

    qr.Close;
    qr.SQL.Clear;

    qr.SQL.Add('UPDATE NFE SET STATUS_ATUAL = :S WHERE ID_NFE = :ID');
    qr.ParamByName('S').AsString := 'PRONTA_PARA_ENVIO';
    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.ExecSQL;

    registrarEvento(pConexao, pIdNfe, statusAnterior, 'PRONTA_PARA_ENVIO', 'Reprocessamento manual');

    enviarParaSefaz(pConexao, pIdNfe);

  finally
    qr.Free;
  end;
end;

procedure TFaturamentoController.cancelarNfe(pConexao: TFDConnection; pIdPedido: Integer; pIdNFe: Integer; pMotivo: string);
var
  qr: TFDQuery;
begin
  try
    qr := TFDQuery.Create(nil);
    qr.Connection := pConexao;

    qr.SQL.Clear;
    qr.SQL.Add('UPDATE NFE SET STATUS_ATUAL = ''CANCELADA'' ');
    qr.SQL.Add('WHERE ID_NFE = :ID_NFE ');
    qr.SQL.Add('  AND ID_PEDIDO = :ID_PEDIDO ');
    qr.ParamByName('ID_PEDIDO').AsInteger := pIdPedido;
    qr.ParamByName('ID_NFE').AsInteger := pIdNFe;
    qr.ExecSQL;

    registrarEvento(pConexao, pIdNFe, 'AUTORIZADA', 'CANCELADA', pMotivo);
  finally
    qr.Free;
  end;
end;

end.

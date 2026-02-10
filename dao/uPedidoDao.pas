unit uPedidoDao;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uPedidoDto;

type
  TPedidoDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);

    function gravar(pDto: TPedidoDto): Integer;
    function obterPorId(pIdPedido: Integer; pDto: TPedidoDto): Boolean;
  end;

implementation

uses
  uPedidoItemDao,
  uPedidoItemDto;

constructor TPedidoDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TPedidoDao.obterProximoId: Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;
    qrSql.SQL.Add('SELECT NEXT VALUE FOR GEN_PEDIDO FROM RDB$DATABASE');
    qrSql.Open;
    Result := qrSql.Fields[0].AsInteger;
  finally
    qrSql.Free;
  end;
end;

function TPedidoDao.gravar(pDto: TPedidoDto): Integer;
var
  qrSql: TFDQuery;
  itemDao: TPedidoItemDao;
  item: TPedidoItemDto;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    if pDto.idPedido > 0 then
    begin
      qrSql.SQL.Add('UPDATE PEDIDO SET');
      qrSql.SQL.Add('ID_CLIENTE = :CLIENTE,');
      qrSql.SQL.Add('DT_EMISSAO = :DT,');
      qrSql.SQL.Add('STATUS = :STATUS,');
      qrSql.SQL.Add('TOTAL = :TOTAL');
      qrSql.SQL.Add('WHERE ID_PEDIDO = :ID');

      qrSql.ParamByName('ID').AsInteger := pDto.idPedido;
    end
    else
    begin
      pDto.idPedido := obterProximoId;

      qrSql.SQL.Add('INSERT INTO PEDIDO (');
      qrSql.SQL.Add('ID_PEDIDO, ID_CLIENTE, DT_EMISSAO, STATUS, TOTAL');
      qrSql.SQL.Add(') VALUES (');
      qrSql.SQL.Add(':ID, :CLIENTE, :DT, :STATUS, :TOTAL)');

      qrSql.ParamByName('ID').AsInteger := pDto.idPedido;
    end;

    qrSql.ParamByName('CLIENTE').AsInteger := pDto.idCliente;
    qrSql.ParamByName('DT').AsDateTime := Now;
    qrSql.ParamByName('STATUS').AsString := 'ABERTO';
    qrSql.ParamByName('TOTAL').AsCurrency := pDto.total;

    qrSql.ExecSQL;

    // Salvar itens
    itemDao := TPedidoItemDao.Create(fConexao);
    try
      itemDao.excluirPorPedido(pDto.idPedido);

      for item in pDto.itens do
      begin
        item.idPedido := pDto.idPedido;
        itemDao.gravar(item);
      end;
    finally
      itemDao.Free;
    end;

    Result := pDto.idPedido;
  finally
    qrSql.Free;
  end;
end;

function TPedidoDao.obterPorId(pIdPedido: Integer; pDto: TPedidoDto): Boolean;
var
  qrSql: TFDQuery;
  itemDao: TPedidoItemDao;
  listaItens: TArray<TPedidoItemDto>;
  item: TPedidoItemDto;
begin
  Result := False;

  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('SELECT P.*, C.* ');
    qrSql.SQL.Add('FROM PEDIDO P ');
    qrSql.SQL.Add('LEFT JOIN CLIENTE C ');
    qrSql.SQL.Add('  ON C.ID_CLIENTE = P.ID_CLIENTE ');
    qrSql.SQL.Add('WHERE P.ID_PEDIDO = :ID');

    qrSql.ParamByName('ID').AsInteger := pIdPedido;
    qrSql.Open;

    if not qrSql.IsEmpty then
    begin
      pDto.idPedido := qrSql.FieldByName('ID_PEDIDO').AsInteger;
      pDto.idCliente := qrSql.FieldByName('ID_CLIENTE').AsInteger;
      pDto.dtEmissao := qrSql.FieldByName('DT_EMISSAO').AsDateTime;
      pDto.status := qrSql.FieldByName('STATUS').AsString;
      pDto.total := qrSql.FieldByName('TOTAL').AsCurrency;
      pDto.nomeRazao := qrSql.FieldByName('NOME_RAZAO').AsString;
      pDto.uf := qrSql.FieldByName('UF').AsString;

      // Carregar itens
      itemDao := TPedidoItemDao.Create(fConexao);
      try
        listaItens := itemDao.obterPorPedido(pDto.idPedido);

        for item in listaItens do
          pDto.itens.Add(item);

      finally
        itemDao.Free;
      end;

      Result := True;
    end;
  finally
    qrSql.Free;
  end;
end;

end.


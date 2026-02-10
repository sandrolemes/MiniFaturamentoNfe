unit uPedidoItemDao;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uPedidoItemDto;

type
  TPedidoItemDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);
    procedure gravar(pDto: TPedidoItemDto);
    procedure excluirPorPedido(pIdPedido: Integer);
    function obterPorPedido(pIdPedido: Integer): TArray<TPedidoItemDto>;
  end;

implementation

uses
  System.Generics.Collections;

constructor TPedidoItemDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TPedidoItemDao.obterProximoId: Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;
    qrSql.SQL.Add('SELECT NEXT VALUE FOR GEN_PEDIDO_ITEM FROM RDB$DATABASE');
    qrSql.Open;
    Result := qrSql.Fields[0].AsInteger;
  finally
    qrSql.Free;
  end;
end;

procedure TPedidoItemDao.gravar(pDto: TPedidoItemDto);
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    pDto.idPedidoItem := obterProximoId;

    qrSql.SQL.Add('INSERT INTO PEDIDO_ITEM (');
    qrSql.SQL.Add('ID_PEDIDO_ITEM, ID_PEDIDO, ID_PRODUTO, QUANTIDADE, VL_UNITARIO');
    qrSql.SQL.Add(') VALUES (');
    qrSql.SQL.Add(':ID, :PEDIDO, :PRODUTO, :QTD, :VL)');

    qrSql.ParamByName('ID').AsInteger := pDto.idPedidoItem;
    qrSql.ParamByName('PEDIDO').AsInteger := pDto.idPedido;
    qrSql.ParamByName('PRODUTO').AsInteger := pDto.idProduto;
    qrSql.ParamByName('QTD').AsFloat := pDto.quantidade;
    qrSql.ParamByName('VL').AsCurrency := pDto.vlUnitario;

    qrSql.ExecSQL;
  finally
    qrSql.Free;
  end;
end;

procedure TPedidoItemDao.excluirPorPedido(pIdPedido: Integer);
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('DELETE FROM PEDIDO_ITEM');
    qrSql.SQL.Add('WHERE ID_PEDIDO = :ID');

    qrSql.ParamByName('ID').AsInteger := pIdPedido;
    qrSql.ExecSQL;
  finally
    qrSql.Free;
  end;
end;

function TPedidoItemDao.obterPorPedido(pIdPedido: Integer): TArray<TPedidoItemDto>;
var
  qrSql: TFDQuery;
  lista: TObjectList<TPedidoItemDto>;
  item: TPedidoItemDto;
begin
  lista := TObjectList<TPedidoItemDto>.Create;
  try
    qrSql := TFDQuery.Create(nil);
    try
      qrSql.Connection := fConexao;

      qrSql.SQL.Add('SELECT * FROM PEDIDO_ITEM');
      qrSql.SQL.Add('WHERE ID_PEDIDO = :ID');

      qrSql.ParamByName('ID').AsInteger := pIdPedido;
      qrSql.Open;

      while not qrSql.Eof do
      begin
        item := TPedidoItemDto.Create;

        item.idPedidoItem := qrSql.FieldByName('ID_PEDIDO_ITEM').AsInteger;
        item.idPedido := qrSql.FieldByName('ID_PEDIDO').AsInteger;
        item.idProduto := qrSql.FieldByName('ID_PRODUTO').AsInteger;
        item.quantidade := qrSql.FieldByName('QUANTIDADE').AsFloat;
        item.vlUnitario := qrSql.FieldByName('VL_UNITARIO').AsCurrency;

        lista.Add(item);
        qrSql.Next;
      end;

    finally
      qrSql.Free;
    end;

    Result := lista.ToArray;
  finally
    lista.Free;
  end;
end;

end.



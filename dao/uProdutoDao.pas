unit uProdutoDao;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uProdutoDto;

type
  TProdutoDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);
    function gravar(pDto: TProdutoDto): Integer;
    function obterPorId(pIdProduto: Integer; pDto: TProdutoDto): Boolean;
    procedure excluir(pIdProduto: Integer);
    function obterLista: TArray<TProdutoDto>;
  end;

implementation

constructor TProdutoDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TProdutoDao.obterProximoId: Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;
    qrSql.SQL.Add('SELECT NEXT VALUE FOR GEN_PRODUTO FROM RDB$DATABASE');
    qrSql.Open;
    Result := qrSql.Fields[0].AsInteger;
  finally
    qrSql.Free;
  end;
end;

function TProdutoDao.gravar(pDto: TProdutoDto): Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    if pDto.idProduto > 0 then
    begin
      qrSql.SQL.Add('UPDATE PRODUTO SET');
      qrSql.SQL.Add('  DESCRICAO = :DESC,');
      qrSql.SQL.Add('  NCM = :NCM,');
      qrSql.SQL.Add('  CFOP_PADRAO = :CFOP,');
      qrSql.SQL.Add('  PRECO_VENDA = :PRECO');
      qrSql.SQL.Add('WHERE ID_PRODUTO = :ID');

      qrSql.ParamByName('ID').AsInteger := pDto.idProduto;
    end
    else
    begin
      pDto.idProduto := obterProximoId;

      qrSql.SQL.Add('INSERT INTO PRODUTO (');
      qrSql.SQL.Add('  ID_PRODUTO, DESCRICAO, NCM, CFOP_PADRAO, PRECO_VENDA');
      qrSql.SQL.Add(') VALUES (');
      qrSql.SQL.Add('  :ID, :DESC, :NCM, :CFOP, :PRECO');
      qrSql.SQL.Add(')');

      qrSql.ParamByName('ID').AsInteger := pDto.idProduto;
    end;

    qrSql.ParamByName('DESC').AsString := pDto.descricao;
    qrSql.ParamByName('NCM').AsString := pDto.ncm;
    qrSql.ParamByName('CFOP').AsString := pDto.cfopPadrao;
    qrSql.ParamByName('PRECO').AsCurrency := pDto.precoVenda;

    qrSql.ExecSQL;

    Result := pDto.idProduto;
  finally
    qrSql.Free;
  end;
end;

function TProdutoDao.obterPorId(pIdProduto: Integer; pDto: TProdutoDto): Boolean;
var
  qrSql: TFDQuery;
begin
  Result := False;

  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('SELECT * FROM PRODUTO');
    qrSql.SQL.Add('WHERE ID_PRODUTO = :ID');

    qrSql.ParamByName('ID').AsInteger := pIdProduto;
    qrSql.Open;

    if not qrSql.IsEmpty then
    begin
      pDto.idProduto := qrSql.FieldByName('ID_PRODUTO').AsInteger;
      pDto.descricao := qrSql.FieldByName('DESCRICAO').AsString;
      pDto.ncm := qrSql.FieldByName('NCM').AsString;
      pDto.cfopPadrao := qrSql.FieldByName('CFOP_PADRAO').AsString;
      pDto.precoVenda := qrSql.FieldByName('PRECO_VENDA').AsCurrency;
      Result := True;
    end;
  finally
    qrSql.Free;
  end;
end;

procedure TProdutoDao.excluir(pIdProduto: Integer);
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('DELETE FROM PRODUTO');
    qrSql.SQL.Add('WHERE ID_PRODUTO = :ID');

    qrSql.ParamByName('ID').AsInteger := pIdProduto;
    qrSql.ExecSQL;
  finally
    qrSql.Free;
  end;
end;

function TProdutoDao.obterLista: TArray<TProdutoDto>;
var
  qrSql: TFDQuery;
  lista: TObjectList<TProdutoDto>;
  dto: TProdutoDto;
begin
  lista := TObjectList<TProdutoDto>.Create;
  try
    qrSql := TFDQuery.Create(nil);
    try
      qrSql.Connection := fConexao;

      qrSql.SQL.Add('SELECT * FROM PRODUTO');
      qrSql.SQL.Add('ORDER BY DESCRICAO');

      qrSql.Open;

      while not qrSql.Eof do
      begin
        dto := TProdutoDto.Create;

        dto.idProduto := qrSql.FieldByName('ID_PRODUTO').AsInteger;
        dto.descricao := qrSql.FieldByName('DESCRICAO').AsString;
        dto.ncm := qrSql.FieldByName('NCM').AsString;
        dto.cfopPadrao := qrSql.FieldByName('CFOP_PADRAO').AsString;
        dto.precoVenda := qrSql.FieldByName('PRECO_VENDA').AsCurrency;

        lista.Add(dto);
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

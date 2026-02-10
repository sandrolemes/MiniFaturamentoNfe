unit uProdutoController;

interface

uses
  FireDAC.Comp.Client,
  uProdutoDto;

type
  TProdutoController = class
  public
    function gravar(pConexao: TFDConnection; pDto: TProdutoDto): Integer;
    function obterPorId(pConexao: TFDConnection; pIdProduto: Integer; pDto: TProdutoDto): Boolean;
    procedure excluir(pConexao: TFDConnection; pIdProduto: Integer);
  end;

implementation

uses
  uProdutoDao;

function TProdutoController.gravar(pConexao: TFDConnection; pDto: TProdutoDto): Integer;
var
  dao: TProdutoDao;
begin
  dao := TProdutoDao.Create(pConexao);
  try
    Result := dao.gravar(pDto);
  finally
    dao.Free;
  end;
end;

function TProdutoController.obterPorId(pConexao: TFDConnection; pIdProduto: Integer; pDto: TProdutoDto): Boolean;
var
  dao: TProdutoDao;
begin
  dao := TProdutoDao.Create(pConexao);
  try
    Result := dao.obterPorId(pIdProduto, pDto);
  finally
    dao.Free;
  end;
end;

procedure TProdutoController.excluir(pConexao: TFDConnection; pIdProduto: Integer);
var
  dao: TProdutoDao;
begin
  dao := TProdutoDao.Create(pConexao);
  try
    dao.excluir(pIdProduto);
  finally
    dao.Free;
  end;
end;

end.

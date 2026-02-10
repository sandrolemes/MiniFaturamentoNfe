unit uPedidoController;

interface

uses
  FireDAC.Comp.Client,
  uPedidoDto,
  uPedidoDao;

type
  TPedidoController = class
  public
    function gravar(pConexao: TFDConnection; pDto: TPedidoDto): Integer;
  end;

implementation

function TPedidoController.gravar(pConexao: TFDConnection; pDto: TPedidoDto): Integer;
var
  dao: TPedidoDao;
begin
  dao := TPedidoDao.Create(pConexao);
  try
    Result := dao.gravar(pDto);
  finally
    dao.Free;
  end;
end;

end.


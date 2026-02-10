unit uClienteController;

interface

uses
  FireDAC.Comp.Client,
  uClienteDto;

type
  TClienteController = class
  public
    function gravar(pConexao: TFDConnection; pDto: TClienteDto): Integer;
    function obterPorId(pConexao: TFDConnection; pIdCliente: Integer; pDto: TClienteDto): Boolean;
    procedure excluir(pConexao: TFDConnection; pIdCliente: Integer);
  end;

implementation

uses
  uClienteDao;

function TClienteController.gravar(pConexao: TFDConnection; pDto: TClienteDto): Integer;
var
  dao: TClienteDao;
begin
  dao := TClienteDao.Create(pConexao);
  try
    Result := dao.gravar(pDto);
  finally
    dao.Free;
  end;
end;

function TClienteController.obterPorId(pConexao: TFDConnection; pIdCliente: Integer; pDto: TClienteDto): Boolean;
var
  dao: TClienteDao;
begin
  dao := TClienteDao.Create(pConexao);
  try
    Result := dao.obterPorId(pIdCliente, pDto);
  finally
    dao.Free;
  end;
end;

procedure TClienteController.excluir(pConexao: TFDConnection; pIdCliente: Integer);
var
  dao: TClienteDao;
begin
  dao := TClienteDao.Create(pConexao);
  try
    dao.excluir(pIdCliente);
  finally
    dao.Free;
  end;
end;

end.

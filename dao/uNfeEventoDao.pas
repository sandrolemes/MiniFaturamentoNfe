unit uNfeEventoDao;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uNfeEventoDto;

type
  TNfeEventoDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);
    function gravar(pDto: TNfeEventoDto): Integer;
  end;

implementation

constructor TNfeEventoDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TNfeEventoDao.obterProximoId: Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;
    qrSql.SQL.Add('SELECT NEXT VALUE FOR GEN_NFE_EVENTO FROM RDB$DATABASE');
    qrSql.Open;
    Result := qrSql.Fields[0].AsInteger;
  finally
    qrSql.Free;
  end;
end;

function TNfeEventoDao.gravar(pDto: TNfeEventoDto): Integer;
var
  qrSql: TFDQuery;
begin
  Result := obterProximoId;

  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('INSERT INTO NFE_EVENTO (');
    qrSql.SQL.Add('  ID_NFE_EVENTO, ID_NFE, DT_EVENTO, STATUS_ANTES, STATUS_DEPOIS, MOTIVO');
    qrSql.SQL.Add(') VALUES (');
    qrSql.SQL.Add('  :ID, :NFE, :DT, :ANTES, :DEPOIS, :MOTIVO');
    qrSql.SQL.Add(')');

    qrSql.ParamByName('ID').AsInteger := Result;
    qrSql.ParamByName('NFE').AsInteger := pDto.idNfe;
    qrSql.ParamByName('DT').AsDateTime := pDto.dtEvento;
    qrSql.ParamByName('ANTES').AsString := pDto.statusAntes;
    qrSql.ParamByName('DEPOIS').AsString := pDto.statusDepois;
    qrSql.ParamByName('MOTIVO').AsString := pDto.motivo;

    qrSql.ExecSQL;
  finally
    qrSql.Free;
  end;
end;

end.

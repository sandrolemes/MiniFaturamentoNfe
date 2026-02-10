unit uNfeDao;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uNfeDto;

type
  TNfeDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);
    function gravar(pDto: TNfeDto): Integer;
    procedure atualizarStatus(pIdNfe: Integer; pStatus: string);
  end;

implementation

constructor TNfeDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TNfeDao.obterProximoId: Integer;
var qr: TFDQuery;
begin
  qr := TFDQuery.Create(nil);
  try
    qr.Connection := fConexao;
    qr.SQL.Add('SELECT NEXT VALUE FOR GEN_NFE FROM RDB$DATABASE');
    qr.Open;
    Result := qr.Fields[0].AsInteger;
  finally
    qr.Free;
  end;
end;

function TNfeDao.gravar(pDto: TNfeDto): Integer;
var qr: TFDQuery;
begin
  qr := TFDQuery.Create(nil);
  try
    qr.Connection := fConexao;

    pDto.idNfe := obterProximoId;

    qr.SQL.Add('INSERT INTO NFE (');
    qr.SQL.Add('ID_NFE, ID_PEDIDO, SERIE, NUMERO, STATUS_ATUAL, CHAVE_ACESSO, DT_EMISSAO, XML)');
    qr.SQL.Add('VALUES (:ID, :PED, :SER, :NUM, :STA, :CHA, :DT, :XML)');

    qr.ParamByName('ID').AsInteger := pDto.idNfe;
    qr.ParamByName('PED').AsInteger := pDto.idPedido;
    qr.ParamByName('SER').AsInteger := pDto.serie;
    qr.ParamByName('NUM').AsInteger := pDto.numero;
    qr.ParamByName('STA').AsString := pDto.statusAtual;
    qr.ParamByName('CHA').AsString := pDto.chaveAcesso;
    qr.ParamByName('DT').AsDateTime := pDto.dtEmissao;
    qr.ParamByName('XML').AsString := pDto.xml;

    qr.ExecSQL;
    Result := pDto.idNfe;
  finally
    qr.Free;
  end;
end;

procedure TNfeDao.atualizarStatus(pIdNfe: Integer; pStatus: string);
var qr: TFDQuery;
begin
  qr := TFDQuery.Create(nil);
  try
    qr.Connection := fConexao;
    qr.SQL.Add('UPDATE NFE SET STATUS_ATUAL = :ST WHERE ID_NFE = :ID');
    qr.ParamByName('ST').AsString := pStatus;
    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.ExecSQL;
  finally
    qr.Free;
  end;
end;

end.


unit uLogEventoDao;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client;

type
  TLogEventoDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);
    procedure gravar(pEntidade: string; pAcao: string; pMensagem: string);
    function obterLista: TArray<string>;
  end;

implementation

constructor TLogEventoDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TLogEventoDao.obterProximoId: Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;
    qrSql.SQL.Add('SELECT NEXT VALUE FOR GEN_LOG_EVENTO FROM RDB$DATABASE');
    qrSql.Open;
    Result := qrSql.Fields[0].AsInteger;
  finally
    qrSql.Free;
  end;
end;

procedure TLogEventoDao.gravar(pEntidade: string; pAcao: string; pMensagem: string);
var
  qrSql: TFDQuery;
  vId: Integer;
begin
  vId := obterProximoId;

  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('INSERT INTO LOG_EVENTO (');
    qrSql.SQL.Add('  ID_LOG, DT_LOG, ENTIDADE, ACAO, MENSAGEM');
    qrSql.SQL.Add(') VALUES (');
    qrSql.SQL.Add('  :ID, :DT, :ENT, :ACAO, :MSG');
    qrSql.SQL.Add(')');

    qrSql.ParamByName('ID').AsInteger := vId;
    qrSql.ParamByName('DT').AsDateTime := Now;
    qrSql.ParamByName('ENT').AsString := pEntidade;
    qrSql.ParamByName('ACAO').AsString := pAcao;
    qrSql.ParamByName('MSG').AsString := pMensagem;

    qrSql.ExecSQL;
  finally
    qrSql.Free;
  end;
end;

function TLogEventoDao.obterLista: TArray<string>;
var
  qrSql: TFDQuery;
  lista: TList<string>;
  linha: string;
begin
  lista := TList<string>.Create;
  try
    qrSql := TFDQuery.Create(nil);
    try
      qrSql.Connection := fConexao;

      qrSql.SQL.Add('SELECT DT_LOG, ENTIDADE, ACAO, MENSAGEM');
      qrSql.SQL.Add('FROM LOG_EVENTO');
      qrSql.SQL.Add('ORDER BY DT_LOG DESC');

      qrSql.Open;

      while not qrSql.Eof do
      begin
        linha :=
          FormatDateTime('dd/mm/yyyy hh:nn:ss', qrSql.FieldByName('DT_LOG').AsDateTime) + ' - ' +
          qrSql.FieldByName('ENTIDADE').AsString + ' - ' +
          qrSql.FieldByName('ACAO').AsString + ' - ' +
          qrSql.FieldByName('MENSAGEM').AsString;

        lista.Add(linha);
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

unit uClienteDao;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uClienteDto;

type
  TClienteDao = class
  private
    fConexao: TFDConnection;
    function obterProximoId: Integer;
  public
    constructor Create(pConexao: TFDConnection);
    function gravar(pDto: TClienteDto): Integer;
    function obterPorId(pIdCliente: Integer; pDto: TClienteDto): Boolean;
    procedure excluir(pIdCliente: Integer);
    function obterLista: TArray<TClienteDto>;
  end;

implementation

constructor TClienteDao.Create(pConexao: TFDConnection);
begin
  fConexao := pConexao;
end;

function TClienteDao.obterProximoId: Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;
    qrSql.SQL.Add('SELECT NEXT VALUE FOR GEN_CLIENTE FROM RDB$DATABASE');
    qrSql.Open;
    Result := qrSql.Fields[0].AsInteger;
  finally
    qrSql.Free;
  end;
end;

function TClienteDao.gravar(pDto: TClienteDto): Integer;
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    if pDto.idCliente > 0 then
    begin
      qrSql.SQL.Add('UPDATE CLIENTE SET');
      qrSql.SQL.Add('  NOME_RAZAO = :NOME,');
      qrSql.SQL.Add('  TIPO_PESSOA = :TIPO,');
      qrSql.SQL.Add('  CPF_CNPJ = :DOC,');
      qrSql.SQL.Add('  UF = :UF,');
      qrSql.SQL.Add('  DT_CADASTRO = :DT');
      qrSql.SQL.Add('WHERE ID_CLIENTE = :ID');

      qrSql.ParamByName('ID').AsInteger := pDto.idCliente;
    end
    else
    begin
      pDto.idCliente := obterProximoId;

      qrSql.SQL.Add('INSERT INTO CLIENTE (');
      qrSql.SQL.Add('  ID_CLIENTE, NOME_RAZAO, TIPO_PESSOA, CPF_CNPJ, UF, DT_CADASTRO');
      qrSql.SQL.Add(') VALUES (');
      qrSql.SQL.Add('  :ID, :NOME, :TIPO, :DOC, :UF, :DT');
      qrSql.SQL.Add(')');

      qrSql.ParamByName('ID').AsInteger := pDto.idCliente;
    end;

    qrSql.ParamByName('NOME').AsString := pDto.nomeRazao;
    qrSql.ParamByName('TIPO').AsString := pDto.tipoPessoa;
    qrSql.ParamByName('DOC').AsString := pDto.cpfCnpj;
    qrSql.ParamByName('UF').AsString := pDto.uf;
    qrSql.ParamByName('DT').AsDateTime := pDto.dtCadastro;

    qrSql.ExecSQL;

    Result := pDto.idCliente;
  finally
    qrSql.Free;
  end;
end;

function TClienteDao.obterPorId(pIdCliente: Integer; pDto: TClienteDto): Boolean;
var
  qrSql: TFDQuery;
begin
  Result := False;

  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('SELECT * FROM CLIENTE');
    qrSql.SQL.Add('WHERE ID_CLIENTE = :ID');

    qrSql.ParamByName('ID').AsInteger := pIdCliente;
    qrSql.Open;

    if not qrSql.IsEmpty then
    begin
      pDto.idCliente := qrSql.FieldByName('ID_CLIENTE').AsInteger;
      pDto.nomeRazao := qrSql.FieldByName('NOME_RAZAO').AsString;
      pDto.tipoPessoa := qrSql.FieldByName('TIPO_PESSOA').AsString;
      pDto.cpfCnpj := qrSql.FieldByName('CPF_CNPJ').AsString;
      pDto.uf := qrSql.FieldByName('UF').AsString;
      pDto.dtCadastro := qrSql.FieldByName('DT_CADASTRO').AsDateTime;
      Result := True;
    end;
  finally
    qrSql.Free;
  end;
end;

procedure TClienteDao.excluir(pIdCliente: Integer);
var
  qrSql: TFDQuery;
begin
  qrSql := TFDQuery.Create(nil);
  try
    qrSql.Connection := fConexao;

    qrSql.SQL.Add('DELETE FROM CLIENTE');
    qrSql.SQL.Add('WHERE ID_CLIENTE = :ID');

    qrSql.ParamByName('ID').AsInteger := pIdCliente;
    qrSql.ExecSQL;
  finally
    qrSql.Free;
  end;
end;

function TClienteDao.obterLista: TArray<TClienteDto>;
var
  qrSql: TFDQuery;
  lista: TObjectList<TClienteDto>;
  dto: TClienteDto;
begin
  lista := TObjectList<TClienteDto>.Create;
  try
    qrSql := TFDQuery.Create(nil);
    try
      qrSql.Connection := fConexao;

      qrSql.SQL.Add('SELECT * FROM CLIENTE');
      qrSql.SQL.Add('ORDER BY NOME_RAZAO');

      qrSql.Open;

      while not qrSql.Eof do
      begin
        dto := TClienteDto.Create;

        dto.idCliente := qrSql.FieldByName('ID_CLIENTE').AsInteger;
        dto.nomeRazao := qrSql.FieldByName('NOME_RAZAO').AsString;
        dto.tipoPessoa := qrSql.FieldByName('TIPO_PESSOA').AsString;
        dto.cpfCnpj := qrSql.FieldByName('CPF_CNPJ').AsString;
        dto.uf := qrSql.FieldByName('UF').AsString;
        dto.dtCadastro := qrSql.FieldByName('DT_CADASTRO').AsDateTime;

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

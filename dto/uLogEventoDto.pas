unit uLogEventoDto;

interface

uses
  System.SysUtils;

type
  TLogEventoDto = class
  private
    fIdLog: Integer;
    fDtLog: TDateTime;
    fEntidade: string;
    fAcao: string;
    fMensagem: string;
  public
    property idLog: Integer read fIdLog write fIdLog;
    property dtLog: TDateTime read fDtLog write fDtLog;
    property entidade: string read fEntidade write fEntidade;
    property acao: string read fAcao write fAcao;
    property mensagem: string read fMensagem write fMensagem;
  end;

implementation

end.

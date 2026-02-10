unit uClienteDto;

interface

uses
  System.SysUtils;

type
  TClienteDto = class
  private
    fIdCliente: Integer;
    fNomeRazao: string;
    fTipoPessoa: string;
    fCpfCnpj: string;
    fUf: string;
    fDtCadastro: TDateTime;
  public
    property idCliente: Integer read fIdCliente write fIdCliente;
    property nomeRazao: string read fNomeRazao write fNomeRazao;
    property tipoPessoa: string read fTipoPessoa write fTipoPessoa;
    property cpfCnpj: string read fCpfCnpj write fCpfCnpj;
    property uf: string read fUf write fUf;
    property dtCadastro: TDateTime read fDtCadastro write fDtCadastro;
  end;

implementation

end.

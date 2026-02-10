unit uNfeDto;

interface

uses System.SysUtils;

type
  TNfeDto = class
  private
    fIdNfe: Integer;
    fIdPedido: Integer;
    fNumero: Integer;
    fSerie: Integer;
    fStatusAtual: string;
    fChaveAcesso: string;
    fDtEmissao: TDateTime;
    fXml: string;
  public
    property idNfe: Integer read fIdNfe write fIdNfe;
    property idPedido: Integer read fIdPedido write fIdPedido;
    property numero: Integer read fNumero write fNumero;
    property serie: Integer read fSerie write fSerie;
    property statusAtual: string read fStatusAtual write fStatusAtual;
    property chaveAcesso: string read fChaveAcesso write fChaveAcesso;
    property dtEmissao: TDateTime read fDtEmissao write fDtEmissao;
    property xml: string read fXml write fXml;
  end;

implementation
end.


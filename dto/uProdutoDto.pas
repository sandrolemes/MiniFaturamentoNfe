unit uProdutoDto;

interface

uses
  System.SysUtils;

type
  TProdutoDto = class
  private
    fIdProduto: Integer;
    fDescricao: string;
    fNcm: string;
    fCfopPadrao: string;
    fPrecoVenda: Currency;
  public
    property idProduto: Integer read fIdProduto write fIdProduto;
    property descricao: string read fDescricao write fDescricao;
    property ncm: string read fNcm write fNcm;
    property cfopPadrao: string read fCfopPadrao write fCfopPadrao;
    property precoVenda: Currency read fPrecoVenda write fPrecoVenda;
  end;

implementation

end.

unit uPedidoItemDto;

interface

uses
  System.SysUtils;

type
  TPedidoItemDto = class
  private
    fIdPedidoItem: Integer;
    fIdPedido: Integer;
    fIdProduto: Integer;
    fQuantidade: Double;
    fVlUnitario: Currency;
    fVlTotal: Currency;
    fNcm: string;
    fCfop: string;
    fDescricao: string;
  public
    property idPedidoItem: Integer read fIdPedidoItem write fIdPedidoItem;
    property idPedido: Integer read fIdPedido write fIdPedido;
    property idProduto: Integer read fIdProduto write fIdProduto;
    property quantidade: Double read fQuantidade write fQuantidade;
    property vlUnitario: Currency read fVlUnitario write fVlUnitario;
    property vlTotal: Currency read fVlTotal write fVlTotal;
    property ncm: string read fNcm write fNcm;
    property cfop: string read fCfop write fCfop;
    property descricao: string read fDescricao write fDescricao;
  end;

implementation

end.


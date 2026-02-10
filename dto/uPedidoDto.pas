unit uPedidoDto;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  uPedidoItemDto;

type
  TPedidoDto = class
  private
    fIdPedido: Integer;
    fIdCliente: Integer;
    fDtEmissao: TDateTime;
    fStatus: string;
    fTotal: Currency;
    fuf: string;
    fnomeRazao: string;
    fItens: TObjectList<TPedidoItemDto>;
  public
    constructor Create;
    destructor Destroy; override;

    property idPedido: Integer read fIdPedido write fIdPedido;
    property idCliente: Integer read fIdCliente write fIdCliente;
    property dtEmissao: TDateTime read fDtEmissao write fDtEmissao;
    property status: string read fStatus write fStatus;
    property total: Currency read fTotal write fTotal;
    property nomeRazao: string read fnomeRazao write fnomeRazao;
    property uf: string read fuf write fuf;
    property itens: TObjectList<TPedidoItemDto> read fItens;
  end;

implementation

constructor TPedidoDto.Create;
begin
  fItens := TObjectList<TPedidoItemDto>.Create(False);
end;

destructor TPedidoDto.Destroy;
begin
  FreeAndNil(fItens);
  inherited;
end;

end.


unit fCadastroProduto;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  uUtils;

type
  TfrmCadastroProduto = class(TForm)
    lblTitulo: TLabel;
    lblDescricao: TLabel;
    lblNcm: TLabel;
    lblCfop: TLabel;
    lblPreco: TLabel;
    edtDescricao: TEdit;
    edtNcm: TEdit;
    edtCfop: TEdit;
    edtPreco: TEdit;
    btnSalvar: TButton;
    lblIdProduto: TLabel;
    edtIdProduto: TEdit;
    btnBuscar: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure edtPrecoKeyPress(Sender: TObject; var Key: Char);
    procedure btnBuscarClick(Sender: TObject);
  private
  public
  end;

var
  frmCadastroProduto: TfrmCadastroProduto;

implementation

uses
  uProdutoDto,
  uProdutoController,
  fPrincipal,
  Vcl.Dialogs,
  fPesquisaProduto;

{$R *.dfm}

procedure TfrmCadastroProduto.btnBuscarClick(Sender: TObject);
var
  idProduto: string;
  dto: TProdutoDto;
  controller: TProdutoController;
begin
  try
    dto := TProdutoDto.Create;
    controller := TProdutoController.Create;

    if frmPesquisaProduto.ShowModal = mrOk then
    begin
      idProduto := IntToStr(frmPesquisaProduto.idSelecionado);

      if controller.obterPorId(frmPrincipal.fdConnection, StrToIntDef(idProduto,0), dto) then
      begin
        edtIdProduto.Text := dto.idProduto.ToString;
        edtDescricao.Text := dto.descricao;
        edtNcm.Text := dto.ncm;
        edtCfop.Text := dto.cfopPadrao;
        edtPreco.Text := FormatCurr(',0.00', dto.precoVenda);
      end
      else
      begin
        ShowMessage(Format('Produto %s não localizado!', [idProduto]));
      end;
    end;

  finally
    dto.Free;
    controller.Free;
  end;
end;

procedure TfrmCadastroProduto.btnSalvarClick(Sender: TObject);
var
  dto: TProdutoDto;
  controller: TProdutoController;
begin
  dto := TProdutoDto.Create;
  controller := TProdutoController.Create;
  try
    dto.idProduto := StrToIntDef(edtIdProduto.Text,0);
    dto.descricao := edtDescricao.Text;
    dto.ncm := edtNcm.Text;
    dto.cfopPadrao := edtCfop.Text;
    dto.precoVenda := StrToCurrDef(edtPreco.Text, 0);

    controller.gravar(frmPrincipal.fdConnection, dto);

    ShowMessage('Produto salvo com sucesso.');
  finally
    dto.Free;
    controller.Free;
  end;
end;

procedure TfrmCadastroProduto.edtPrecoKeyPress(Sender: TObject; var Key: Char);
begin
  uUtils.editMoedaKeyPress(edtPreco, Key);
end;

end.

unit fCadastroCliente;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls;

type
  TfrmCadastroCliente = class(TForm)
    lblTitulo: TLabel;
    lblNome: TLabel;
    lblCpfCnpj: TLabel;
    lblUf: TLabel;
    edtNome: TEdit;
    edtCpfCnpj: TEdit;
    edtUf: TEdit;
    btnSalvar: TButton;
    edtIdCliente: TEdit;
    Label1: TLabel;
    btnBuscar: TButton;
    cboTipoPessoa: TComboBox;
    lblTipoPessoa: TLabel;
    edtDtCadastro: TEdit;
    lblDtCadastro: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
  private
  public
  end;

var
  frmCadastroCliente: TfrmCadastroCliente;

implementation

uses
  uClienteController,
  uClienteDto,
  fPrincipal,
  Vcl.Dialogs,
  fPesquisaCliente;

{$R *.dfm}

procedure TfrmCadastroCliente.btnBuscarClick(Sender: TObject);
var
  idCliente: string;
  dto: TClienteDto;
  controller: TClienteController;
begin
  try
    dto := TClienteDto.Create;
    controller := TClienteController.Create;

    if frmPesquisaCliente.ShowModal = mrOk then
    begin
      idCliente := IntToStr(frmPesquisaCliente.idSelecionado);

      if controller.obterPorId(frmPrincipal.fdConnection, StrToIntDef(idCliente,0), dto) then
      begin
        edtIdCliente.Text := dto.idCliente.ToString;
        cboTipoPessoa.ItemIndex := cboTipoPessoa.Items.IndexOf(UpperCase(dto.tipoPessoa));
        edtDtCadastro.Text := FormatDateTime('dd/mm/yyyy', dto.dtCadastro);
        edtNome.Text := dto.nomeRazao;
        edtCpfCnpj.Text := dto.cpfCnpj;
        edtUf.Text := dto.uf;
      end
      else
      begin
        ShowMessage(Format('Cliente %s não localizado!', [idCliente]));
      end;
    end;

  finally
    dto.Free;
    controller.Free;
  end;
end;

procedure TfrmCadastroCliente.btnSalvarClick(Sender: TObject);
var
  dto: TClienteDto;
  controller: TClienteController;
begin
  dto := TClienteDto.Create;
  controller := TClienteController.Create;
  try
    dto.idCliente := StrToIntDef(edtIdCliente.Text,0);
    dto.tipoPessoa := cboTipoPessoa.Text;
    dto.dtCadastro := Now;
    dto.nomeRazao := edtNome.Text;
    dto.cpfCnpj := edtCpfCnpj.Text;
    dto.uf := edtUf.Text;

    edtIdCliente.Text := controller.gravar(frmPrincipal.fdConnection, dto).ToString;

    ShowMessage('Cliente salvo com sucesso.');
  finally
    dto.Free;
    controller.Free;
  end;
end;

end.

unit fPrincipal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Comp.Client,
  FireDAC.DApt;

type
  TfrmPrincipal = class(TForm)
    lblTitulo: TLabel;
    btnClientes: TButton;
    btnProdutos: TButton;
    btnPedidos: TButton;
    btnFaturamento: TButton;
    procedure btnClientesClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnPedidosClick(Sender: TObject);
    procedure btnFaturamentoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure configurarConexao;

  public
    fdConnection: TFDConnection;

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  fCadastroCliente,
  fCadastroProduto,
  fPedidoVenda,
  fFaturamentoNfe;

{$R *.dfm}

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin
  Application.CreateForm(TfrmCadastroCliente, frmCadastroCliente);
  frmCadastroCliente.ShowModal;
end;

procedure TfrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  Application.CreateForm(TfrmCadastroProduto, frmCadastroProduto);
  frmCadastroProduto.ShowModal;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  configurarConexao;
end;

procedure TfrmPrincipal.btnPedidosClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPedidoVenda, frmPedidoVenda);
  frmPedidoVenda.ShowModal;
end;

procedure TfrmPrincipal.btnFaturamentoClick(Sender: TObject);
begin
  Application.CreateForm(TfrmFaturamentoNfe, frmFaturamentoNfe);
  frmFaturamentoNfe.ShowModal;
end;

procedure TfrmPrincipal.configurarConexao;
begin
  fdConnection := TFDConnection.Create(nil);
  fdConnection.Params.Clear;
  fdConnection.Params.DriverID := 'FB';
  fdConnection.Params.Database := ExtractFilePath(ParamStr(0)) + '\DB\BANCO.FDB'; // ajuste se necessário
  fdConnection.Params.UserName := 'SYSDBA';
  fdConnection.Params.Password := 'masterkey';
  fdConnection.Params.Add('Server=localhost');
  fdConnection.LoginPrompt := False;
  fdConnection.Connected := True;
end;


end.




unit fPesquisaPedido;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.Controls, Vcl.ComCtrls;

type
  TfrmPesquisaPedido = class(TForm)
    lblTitulo: TLabel;

    lblId: TLabel;
    edtId: TEdit;

    lblCliente: TLabel;
    edtCliente: TEdit;

    lblDataIni: TLabel;
    dtIni: TDateTimePicker;

    lblDataFim: TLabel;
    dtFim: TDateTimePicker;

    btnPesquisar: TButton;
    btnLimpar: TButton;
    btnSelecionar: TButton;

    grdPedidos: TStringGrid;

    procedure FormCreate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure grdPedidosDblClick(Sender: TObject);

    procedure edtIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    fIdSelecionado: Integer;
    procedure configurarGrid;
    procedure pesquisar;
  public
    property idSelecionado: Integer read fIdSelecionado;
  end;

var
  frmPesquisaPedido: TfrmPesquisaPedido;

implementation

uses
  FireDAC.Comp.Client,
  fPrincipal;

{$R *.dfm}

procedure TfrmPesquisaPedido.FormCreate(Sender: TObject);
begin
  configurarGrid;

  dtIni.Date := Date - 30;
  dtFim.Date := Date;
end;

procedure TfrmPesquisaPedido.configurarGrid;
begin
  grdPedidos.Options := grdPedidos.Options + [goColSizing, goRowSelect];

  grdPedidos.ColCount := 5;
  grdPedidos.RowCount := 1;

  grdPedidos.Cells[0,0] := 'ID';
  grdPedidos.Cells[1,0] := 'Cliente';
  grdPedidos.Cells[2,0] := 'Data';
  grdPedidos.Cells[3,0] := 'Status';
  grdPedidos.Cells[4,0] := 'Total';

  grdPedidos.ColWidths[0] := 70;
  grdPedidos.ColWidths[1] := 280;
  grdPedidos.ColWidths[2] := 120;
  grdPedidos.ColWidths[3] := 120;
  grdPedidos.ColWidths[4] := 120;
end;

procedure TfrmPesquisaPedido.btnPesquisarClick(Sender: TObject);
begin
  pesquisar;
end;

procedure TfrmPesquisaPedido.edtIdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then pesquisar;
end;

procedure TfrmPesquisaPedido.edtClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then pesquisar;
end;

procedure TfrmPesquisaPedido.pesquisar;
var
  qr: TFDQuery;
begin
  grdPedidos.RowCount := 1;

  qr := TFDQuery.Create(nil);
  try
    qr.Connection := frmPrincipal.fdConnection;

    qr.SQL.Add('SELECT');
    qr.SQL.Add('  p.ID_PEDIDO,');
    qr.SQL.Add('  p.DT_EMISSAO,');
    qr.SQL.Add('  p.STATUS,');
    qr.SQL.Add('  p.TOTAL,');
    qr.SQL.Add('  c.NOME_RAZAO');
    qr.SQL.Add('FROM PEDIDO p');
    qr.SQL.Add('LEFT JOIN CLIENTE c ON c.ID_CLIENTE = p.ID_CLIENTE');
    qr.SQL.Add('WHERE 1=1');

    if Trim(edtId.Text) <> '' then
      qr.SQL.Add('AND p.ID_PEDIDO = :ID');

    if Trim(edtCliente.Text) <> '' then
      qr.SQL.Add('AND UPPER(c.NOME_RAZAO) LIKE :CLI');

    qr.SQL.Add('AND p.DT_EMISSAO BETWEEN :DTINI AND :DTFIM');

    if Trim(edtId.Text) <> '' then
      qr.ParamByName('ID').AsInteger := StrToIntDef(edtId.Text,0);

    if Trim(edtCliente.Text) <> '' then
      qr.ParamByName('CLI').AsString := '%' + UpperCase(edtCliente.Text) + '%';

    qr.ParamByName('DTINI').AsDateTime := dtIni.Date;
    qr.ParamByName('DTFIM').AsDateTime := dtFim.Date + 1;

    qr.Open;

    while not qr.Eof do
    begin
      grdPedidos.RowCount := grdPedidos.RowCount + 1;

      grdPedidos.Cells[0,grdPedidos.RowCount-1] := qr.FieldByName('ID_PEDIDO').AsString;
      grdPedidos.Cells[1,grdPedidos.RowCount-1] := qr.FieldByName('NOME_RAZAO').AsString;
      grdPedidos.Cells[2,grdPedidos.RowCount-1] := DateTimeToStr(qr.FieldByName('DT_EMISSAO').AsDateTime);
      grdPedidos.Cells[3,grdPedidos.RowCount-1] := qr.FieldByName('STATUS').AsString;
      grdPedidos.Cells[4,grdPedidos.RowCount-1] := FormatFloat('#,##0.00', qr.FieldByName('TOTAL').AsFloat);

      qr.Next;
    end;

  finally
    qr.Free;
  end;
end;

procedure TfrmPesquisaPedido.btnLimparClick(Sender: TObject);
begin
  edtId.Clear;
  edtCliente.Clear;
  dtIni.Date := Date - 30;
  dtFim.Date := Date;
  grdPedidos.RowCount := 1;
end;

procedure TfrmPesquisaPedido.btnSelecionarClick(Sender: TObject);
begin
  if grdPedidos.Row > 0 then
  begin
    fIdSelecionado := StrToIntDef(grdPedidos.Cells[0,grdPedidos.Row],0);
    ModalResult := mrOk;
  end;
end;

procedure TfrmPesquisaPedido.grdPedidosDblClick(Sender: TObject);
begin
  btnSelecionarClick(Sender);
end;

end.

unit fFaturamentoNfe;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.IOUtils,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.Controls,
  Vcl.Menus, Vcl.Dialogs;

type
  TfrmFaturamentoNfe = class(TForm)
    lblTitulo: TLabel;

    lblPedido: TLabel;
    edtIdPedido: TEdit;
    btnCarregar: TButton;
    btnFaturar: TButton;

    lblCliente: TLabel;
    edtCliente: TEdit;

    lblCidade: TLabel;
    edtUf: TEdit;

    lblTotal: TLabel;
    edtTotal: TEdit;

    grdNfe: TStringGrid;
    grdEventos: TStringGrid;

    btnReprocessar: TButton;
    btnCancelar: TButton;
    dlgSaveXml: TSaveDialog;
    btnEnviarSefaz: TButton;
    btnExportarXML: TButton;
    btnPesquisarPedido: TButton;

    procedure FormCreate(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnFaturarClick(Sender: TObject);
    procedure btnReprocessarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure grdNfeSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure btnExportarXMLClick(Sender: TObject);
    procedure btnEnviarSefazClick(Sender: TObject);
    procedure btnPesquisarPedidoClick(Sender: TObject);
  private
    fPedidoCarregado: Boolean;

    procedure configurarGrids;
    procedure carregarPedido;
    procedure carregarNfe(pIdPedido: Integer);
    procedure carregarEventos(pIdNfe: Integer);

    function obterIdNfeSelecionado: Integer;
    function obterStatusSelecionado: string;
  public
  end;

var
  frmFaturamentoNfe: TfrmFaturamentoNfe;

implementation

uses
  FireDAC.Comp.Client,
  fPrincipal,
  uFaturamentoController,
  uPedidoDao,
  uPedidoDto,
  fPesquisaPedido;

{$R *.dfm}

procedure TfrmFaturamentoNfe.FormCreate(Sender: TObject);
begin
  configurarGrids;
  btnFaturar.Enabled := False;
  fPedidoCarregado := False;
end;

procedure TfrmFaturamentoNfe.configurarGrids;
begin
  grdNfe.Options := grdNfe.Options + [goColSizing, goRowSelect];

  grdNfe.ColCount := 8;
  grdNfe.RowCount := 1;

  grdNfe.Cells[0,0] := 'ID NFE';
  grdNfe.Cells[1,0] := 'PEDIDO';
  grdNfe.Cells[2,0] := 'NUMERO';
  grdNfe.Cells[3,0] := 'SERIE';
  grdNfe.Cells[4,0] := 'STATUS';
  grdNfe.Cells[5,0] := 'CHAVE';
  grdNfe.Cells[6,0] := 'EMISSAO';
  grdNfe.Cells[7,0] := 'XML';

  grdEventos.Options := grdEventos.Options + [goColSizing, goRowSelect];

  grdEventos.ColCount := 4;
  grdEventos.RowCount := 1;

  grdEventos.Cells[0,0] := 'DATA';
  grdEventos.Cells[1,0] := 'ANTES';
  grdEventos.Cells[2,0] := 'DEPOIS';
  grdEventos.Cells[3,0] := 'MOTIVO';
end;

procedure TfrmFaturamentoNfe.btnCarregarClick(Sender: TObject);
begin
  carregarPedido;
end;

procedure TfrmFaturamentoNfe.btnEnviarSefazClick(Sender: TObject);
var
  fatControl: TFaturamentoController;
  idNfe: Integer;
begin
  idNfe := obterIdNfeSelecionado;
  if idNfe = 0 then
    Exit;

  try
    fatControl := TFaturamentoController.Create;
    fatControl.enviarParaSefaz(frmPrincipal.fdConnection, idNfe);
    carregarNfe(StrToIntDef(edtIdPedido.Text,0));
  finally
    fatControl.Free;
  end;
end;

procedure TfrmFaturamentoNfe.btnExportarXMLClick(Sender: TObject);
var
  qr: TFDQuery;
  sStatusAtual: string;
  row: Integer;
  numero, xml: string;
begin
  try
    qr := TFDQuery.Create(nil);
    qr.Connection := frmPrincipal.fdConnection;

    qr.SQL.Add('SELECT STATUS_ATUAL FROM NFE WHERE ID_NFE = :ID');
    qr.ParamByName('ID').AsInteger := obterIdNfeSelecionado;
    qr.Open;

    sStatusAtual := qr.FieldByName('STATUS_ATUAL').AsString;

    if sStatusAtual <> 'AUTORIZADA' then
      raise Exception.Create('Só é permitido exportar XML de NF-e autorizada.');

    row := grdNfe.Row;
    if row <= 0 then
      Exit;

    numero := grdNfe.Cells[2,row];
    xml := grdNfe.Cells[7,row];

    dlgSaveXml.FileName := 'NFE_' + numero + '.xml';
    if dlgSaveXml.Execute then
      TFile.WriteAllText(dlgSaveXml.FileName, xml, TEncoding.UTF8);
  finally
    qr.Free;
  end;
end;

procedure TfrmFaturamentoNfe.carregarPedido;
var
  pedidoDTO: TPedidoDto;
  PedidoDAO: TPedidoDao;
begin
  try
    pedidoDTO := TPedidoDto.Create;
    PedidoDAO := TPedidoDao.Create(frmPrincipal.fdConnection);

    if PedidoDAO.obterPorId(StrToIntDef(edtIdPedido.Text,0), pedidoDTO) then
    begin
      edtCliente.Text := pedidoDTO.nomeRazao;
      edtUF.Text := pedidoDTO.uf;
      edtTotal.Text := CurrToStr(pedidoDTO.total);

      fPedidoCarregado := True;
      btnFaturar.Enabled := True;

      carregarNfe(pedidoDTO.idPedido);
    end
    else
    begin
      ShowMessage('Pedido não encontrado.');
      btnFaturar.Enabled := False;
      fPedidoCarregado := False;
    end;
  finally
    pedidoDTO.Free;
    PedidoDAO.Free;
  end;
end;

procedure TfrmFaturamentoNfe.carregarNfe(pIdPedido: Integer);
var
  qr: TFDQuery;
begin
  grdEventos.RowCount := 1;

  try
    qr := TFDQuery.Create(nil);
    qr.Connection := frmPrincipal.fdConnection;
    qr.SQL.Add('SELECT * FROM NFE WHERE ID_PEDIDO = :P');
    qr.ParamByName('P').AsInteger := pIdPedido;
    qr.Open;

    grdNfe.RowCount := 1;

    while not qr.Eof do
    begin
      grdNfe.RowCount := grdNfe.RowCount + 1;

      grdNfe.Cells[0,grdNfe.RowCount-1] := qr.FieldByName('ID_NFE').AsString;
      grdNfe.Cells[1,grdNfe.RowCount-1] := qr.FieldByName('ID_PEDIDO').AsString;
      grdNfe.Cells[2,grdNfe.RowCount-1] := qr.FieldByName('NUMERO').AsString;
      grdNfe.Cells[3,grdNfe.RowCount-1] := qr.FieldByName('SERIE').AsString;
      grdNfe.Cells[4,grdNfe.RowCount-1] := qr.FieldByName('STATUS_ATUAL').AsString;
      grdNfe.Cells[5,grdNfe.RowCount-1] := qr.FieldByName('CHAVE_ACESSO').AsString;
      grdNfe.Cells[6,grdNfe.RowCount-1] := qr.FieldByName('DT_EMISSAO').AsString;
      grdNfe.Cells[7,grdNfe.RowCount-1] := qr.FieldByName('XML').AsString;

      qr.Next;
    end;
  finally
    qr.Free;
  end;
end;

procedure TfrmFaturamentoNfe.grdNfeSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  idNfe: Integer;
begin
  if ARow = 0 then
    Exit;

  idNfe := StrToIntDef(grdNfe.Cells[0, ARow], 0);
  if idNfe > 0 then
    carregarEventos(idNfe);
end;

procedure TfrmFaturamentoNfe.carregarEventos(pIdNfe: Integer);
var
  qr: TFDQuery;
begin
  grdEventos.RowCount := 1;

  try
    qr := TFDQuery.Create(nil);
    qr.Connection := frmPrincipal.fdConnection;
    qr.SQL.Add('SELECT * FROM NFE_EVENTO WHERE ID_NFE = :ID');
    qr.ParamByName('ID').AsInteger := pIdNfe;
    qr.Open;

    while not qr.Eof do
    begin
      grdEventos.RowCount := grdEventos.RowCount + 1;
      grdEventos.Cells[0,grdEventos.RowCount-1] := qr.FieldByName('DT_EVENTO').AsString;
      grdEventos.Cells[1,grdEventos.RowCount-1] := qr.FieldByName('STATUS_ANTES').AsString;
      grdEventos.Cells[2,grdEventos.RowCount-1] := qr.FieldByName('STATUS_DEPOIS').AsString;
      grdEventos.Cells[3,grdEventos.RowCount-1] := qr.FieldByName('MOTIVO').AsString;
      qr.Next;
    end;
  finally
    qr.Free;
  end;
end;

function TfrmFaturamentoNfe.obterIdNfeSelecionado: Integer;
begin
  Result := StrToIntDef(grdNfe.Cells[0, grdNfe.Row], 0);
end;

function TfrmFaturamentoNfe.obterStatusSelecionado: string;
begin
  Result := grdNfe.Cells[4, grdNfe.Row];
end;

procedure TfrmFaturamentoNfe.btnFaturarClick(Sender: TObject);
var
  pedidoDTO: TPedidoDto;
  pedidoDAO: TPedidoDao;
  fatControl: TFaturamentoController;
begin
  if not fPedidoCarregado then
    Exit;

  try
    pedidoDTO := TPedidoDto.Create;
    pedidoDAO := TPedidoDao.Create(frmPrincipal.fdConnection);
    fatControl := TFaturamentoController.Create;

    if pedidoDAO.obterPorId(StrToIntDef(edtIdPedido.Text,0), pedidoDTO) then
    begin
      fatControl.faturarPedido(frmPrincipal.fdConnection, pedidoDTO);
      carregarNfe(pedidoDTO.idPedido);
    end;
  finally
    pedidoDTO.Free;
    pedidoDAO.Free;
    fatControl.Free;
  end;
end;

procedure TfrmFaturamentoNfe.btnPesquisarPedidoClick(Sender: TObject);
begin
  if frmPesquisaPedido.ShowModal = mrOk then
  begin
    edtIdPedido.Text := IntToStr(frmPesquisaPedido.idSelecionado);
    btnCarregar.Click;
  end;
end;

procedure TfrmFaturamentoNfe.btnReprocessarClick(Sender: TObject);
var
  fatControl: TFaturamentoController;
  idNfe: Integer;
begin
  idNfe := obterIdNfeSelecionado;
  if idNfe = 0 then
    Exit;

  try
    fatControl := TFaturamentoController.Create;
    fatControl.reprocessarNfe(frmPrincipal.fdConnection, idNfe);
    carregarNfe(StrToIntDef(edtIdPedido.Text,0));
  finally
    fatControl.Free;
  end;
end;

procedure TfrmFaturamentoNfe.btnCancelarClick(Sender: TObject);
var
  fatControl: TFaturamentoController;
  idNfe: Integer;
begin
  idNfe := obterIdNfeSelecionado;
  if idNfe = 0 then
    Exit;

  try
    fatControl := TFaturamentoController.Create;
    fatControl.cancelarNfe(frmPrincipal.fdConnection, StrToIntDef(edtIdPedido.Text,0), idNfe, 'Cancelamento manual');
    carregarNfe(StrToIntDef(edtIdPedido.Text,0));
  finally
    fatControl.Free;
  end;
end;

end.





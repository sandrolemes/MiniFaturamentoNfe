object frmFaturamentoNfe: TfrmFaturamentoNfe
  Left = 0
  Top = 0
  Caption = 'Faturamento NF-e'
  ClientHeight = 580
  ClientWidth = 1217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  DesignSize = (
    1217
    580)
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 16
    Top = 8
    Width = 162
    Height = 25
    Caption = 'Faturamento NF-e'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPedido: TLabel
    Left = 16
    Top = 50
    Width = 37
    Height = 15
    Caption = 'Pedido'
  end
  object lblCliente: TLabel
    Left = 16
    Top = 110
    Width = 37
    Height = 15
    Caption = 'Cliente'
  end
  object lblCidade: TLabel
    Left = 533
    Top = 110
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object lblTotal: TLabel
    Left = 664
    Top = 110
    Width = 66
    Height = 15
    Caption = 'Total Pedido'
  end
  object edtIdPedido: TEdit
    Left = 16
    Top = 68
    Width = 100
    Height = 23
    TabOrder = 0
  end
  object btnCarregar: TButton
    Left = 130
    Top = 66
    Width = 100
    Height = 25
    Caption = 'Carregar'
    TabOrder = 1
    OnClick = btnCarregarClick
  end
  object btnFaturar: TButton
    Left = 236
    Top = 66
    Width = 100
    Height = 25
    Caption = 'Faturar'
    TabOrder = 2
    OnClick = btnFaturarClick
  end
  object edtCliente: TEdit
    Left = 16
    Top = 128
    Width = 511
    Height = 23
    ReadOnly = True
    TabOrder = 4
  end
  object edtUf: TEdit
    Left = 533
    Top = 128
    Width = 41
    Height = 23
    ReadOnly = True
    TabOrder = 5
  end
  object edtTotal: TEdit
    Left = 580
    Top = 128
    Width = 150
    Height = 23
    ReadOnly = True
    TabOrder = 6
  end
  object grdNfe: TStringGrid
    Left = 16
    Top = 170
    Width = 1177
    Height = 180
    Anchors = [akLeft, akTop, akRight]
    DefaultColWidth = 140
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowDefAlign]
    TabOrder = 7
    OnSelectCell = grdNfeSelectCell
    ExplicitWidth = 880
  end
  object btnReprocessar: TButton
    Left = 152
    Top = 356
    Width = 130
    Height = 25
    Caption = 'Reprocessar NF-e'
    TabOrder = 9
    OnClick = btnReprocessarClick
  end
  object btnCancelar: TButton
    Left = 288
    Top = 356
    Width = 130
    Height = 25
    Caption = 'Cancelar NF-e'
    TabOrder = 10
    OnClick = btnCancelarClick
  end
  object grdEventos: TStringGrid
    Left = 16
    Top = 400
    Width = 1177
    Height = 160
    Anchors = [akLeft, akTop, akRight]
    DefaultColWidth = 165
    TabOrder = 12
    ExplicitWidth = 880
  end
  object btnEnviarSefaz: TButton
    Left = 16
    Top = 356
    Width = 130
    Height = 25
    Caption = 'Enviar para Sefaz'
    TabOrder = 8
    OnClick = btnEnviarSefazClick
  end
  object btnExportarXML: TButton
    Left = 424
    Top = 356
    Width = 130
    Height = 25
    Caption = 'Exportar XML'
    TabOrder = 11
    OnClick = btnExportarXMLClick
  end
  object btnPesquisarPedido: TButton
    Left = 342
    Top = 66
    Width = 104
    Height = 25
    Caption = 'Pesquisar (F2)'
    TabOrder = 3
    OnClick = btnPesquisarPedidoClick
  end
  object dlgSaveXml: TSaveDialog
    DefaultExt = 'xml'
    Left = 384
    Top = 8
  end
end

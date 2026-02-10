object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Mini M'#243'dulo de Faturamento'
  ClientHeight = 266
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 40
    Top = 16
    Width = 220
    Height = 30
    Caption = 'Mini Faturamento ERP'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnClientes: TButton
    Left = 80
    Top = 70
    Width = 160
    Height = 30
    Caption = 'Cadastro de Clientes'
    TabOrder = 0
    OnClick = btnClientesClick
  end
  object btnProdutos: TButton
    Left = 80
    Top = 110
    Width = 160
    Height = 30
    Caption = 'Cadastro de Produtos'
    TabOrder = 1
    OnClick = btnProdutosClick
  end
  object btnPedidos: TButton
    Left = 80
    Top = 150
    Width = 160
    Height = 30
    Caption = 'Pedidos de Venda'
    TabOrder = 2
    OnClick = btnPedidosClick
  end
  object btnFaturamento: TButton
    Left = 80
    Top = 190
    Width = 160
    Height = 30
    Caption = 'Faturamento NF-e'
    TabOrder = 3
    OnClick = btnFaturamentoClick
  end
end

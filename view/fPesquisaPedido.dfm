object frmPesquisaPedido: TfrmPesquisaPedido
  Left = 0
  Top = 0
  Caption = 'Pesquisa de Pedidos'
  ClientHeight = 520
  ClientWidth = 760
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
    Left = 16
    Top = 8
    Width = 170
    Height = 25
    Caption = 'Pesquisa de Pedidos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblId: TLabel
    Left = 16
    Top = 48
    Width = 51
    Height = 15
    Caption = 'ID Pedido'
  end
  object lblCliente: TLabel
    Left = 140
    Top = 48
    Width = 37
    Height = 15
    Caption = 'Cliente'
  end
  object lblDataIni: TLabel
    Left = 380
    Top = 48
    Width = 58
    Height = 15
    Caption = 'Data Inicial'
  end
  object lblDataFim: TLabel
    Left = 520
    Top = 48
    Width = 52
    Height = 15
    Caption = 'Data Final'
  end
  object edtId: TEdit
    Left = 16
    Top = 64
    Width = 100
    Height = 23
    TabOrder = 0
    OnKeyDown = edtIdKeyDown
  end
  object edtCliente: TEdit
    Left = 140
    Top = 64
    Width = 220
    Height = 23
    TabOrder = 1
    OnKeyDown = edtClienteKeyDown
  end
  object dtIni: TDateTimePicker
    Left = 380
    Top = 64
    Width = 120
    Height = 23
    Time = 0.013889085646951570
    TabOrder = 2
  end
  object dtFim: TDateTimePicker
    Left = 520
    Top = 64
    Width = 120
    Height = 23
    Time = 0.013889085646951570
    TabOrder = 3
  end
  object btnPesquisar: TButton
    Left = 660
    Top = 62
    Width = 80
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 4
    OnClick = btnPesquisarClick
  end
  object btnLimpar: TButton
    Left = 660
    Top = 94
    Width = 80
    Height = 25
    Caption = 'Limpar'
    TabOrder = 5
    OnClick = btnLimparClick
  end
  object grdPedidos: TStringGrid
    Left = 16
    Top = 130
    Width = 724
    Height = 320
    TabOrder = 6
    OnDblClick = grdPedidosDblClick
  end
  object btnSelecionar: TButton
    Left = 600
    Top = 460
    Width = 140
    Height = 25
    Caption = 'Selecionar Pedido'
    TabOrder = 7
    OnClick = btnSelecionarClick
  end
end

object frmPedidoVenda: TfrmPedidoVenda
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 490
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 16
    Top = 8
    Width = 150
    Height = 25
    Caption = 'Pedido de Venda'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblCliente: TLabel
    Left = 16
    Top = 50
    Width = 51
    Height = 15
    Caption = 'ID Cliente'
  end
  object lblProduto: TLabel
    Left = 16
    Top = 110
    Width = 57
    Height = 15
    Caption = 'ID Produto'
  end
  object lblDescricao: TLabel
    Left = 112
    Top = 110
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object lblQuantidade: TLabel
    Left = 424
    Top = 110
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  object lblPreco: TLabel
    Left = 510
    Top = 110
    Width = 30
    Height = 15
    Caption = 'Pre'#231'o'
  end
  object lblTotal: TLabel
    Left = 550
    Top = 440
    Width = 26
    Height = 15
    Caption = 'Total'
  end
  object edtIdCliente: TEdit
    Left = 16
    Top = 68
    Width = 120
    Height = 23
    TabOrder = 0
    OnKeyDown = edtIdClienteKeyDown
  end
  object edtNomeCliente: TEdit
    Left = 142
    Top = 68
    Width = 468
    Height = 23
    TabStop = False
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 1
  end
  object edtIdProduto: TEdit
    Left = 16
    Top = 128
    Width = 90
    Height = 23
    TabOrder = 3
    OnKeyDown = edtIdProdutoKeyDown
  end
  object edtDescricao: TEdit
    Left = 112
    Top = 128
    Width = 306
    Height = 23
    TabStop = False
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 4
  end
  object edtQuantidade: TEdit
    Left = 424
    Top = 128
    Width = 80
    Height = 23
    TabOrder = 5
  end
  object edtPreco: TEdit
    Left = 510
    Top = 128
    Width = 100
    Height = 23
    ReadOnly = True
    TabOrder = 6
    OnKeyDown = edtPrecoKeyDown
    OnKeyPress = edtPrecoKeyPress
  end
  object grdItens: TStringGrid
    Left = 16
    Top = 180
    Width = 740
    Height = 240
    RowCount = 1
    FixedRows = 0
    TabOrder = 8
    OnKeyDown = grdItensKeyDown
  end
  object edtTotal: TEdit
    Left = 590
    Top = 436
    Width = 170
    Height = 23
    ReadOnly = True
    TabOrder = 9
  end
  object btnGravar: TButton
    Left = 16
    Top = 430
    Width = 170
    Height = 36
    Caption = 'Gravar (Ctrl+S)'
    TabOrder = 10
    OnClick = btnGravarClick
  end
  object btnPesquisarCliente: TButton
    Left = 616
    Top = 68
    Width = 104
    Height = 23
    Caption = 'Pesquisar (F2)'
    TabOrder = 2
    TabStop = False
    OnClick = btnPesquisarClienteClick
  end
  object Button1: TButton
    Left = 616
    Top = 128
    Width = 104
    Height = 23
    Caption = 'Pesquisar (F3)'
    TabOrder = 7
    TabStop = False
    OnClick = Button1Click
  end
end

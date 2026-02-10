object frmPesquisaProduto: TfrmPesquisaProduto
  Left = 0
  Top = 0
  Caption = 'Pesquisa de Produtos'
  ClientHeight = 480
  ClientWidth = 720
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
    Width = 181
    Height = 25
    Caption = 'Pesquisa de Produtos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDescricao: TLabel
    Left = 16
    Top = 48
    Width = 66
    Height = 15
    Caption = 'Descri'#195#167#195#163'o'
  end
  object edtDescricao: TEdit
    Left = 16
    Top = 64
    Width = 350
    Height = 23
    TabOrder = 0
    OnKeyDown = edtDescricaoKeyDown
  end
  object btnPesquisar: TButton
    Left = 380
    Top = 62
    Width = 90
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 1
    OnClick = btnPesquisarClick
  end
  object btnLimpar: TButton
    Left = 480
    Top = 62
    Width = 90
    Height = 25
    Caption = 'Limpar'
    TabOrder = 2
    OnClick = btnLimparClick
  end
  object grdProdutos: TStringGrid
    Left = 16
    Top = 100
    Width = 680
    Height = 300
    TabOrder = 3
    OnDblClick = grdProdutosDblClick
  end
  object btnSelecionar: TButton
    Left = 560
    Top = 420
    Width = 140
    Height = 25
    Caption = 'Selecionar Produto'
    TabOrder = 4
    OnClick = btnSelecionarClick
  end
end

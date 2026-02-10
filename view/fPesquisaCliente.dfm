object frmPesquisaCliente: TfrmPesquisaCliente
  Left = 0
  Top = 0
  Caption = 'Pesquisa de Clientes'
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
    Width = 171
    Height = 25
    Caption = 'Pesquisa de Clientes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNome: TLabel
    Left = 16
    Top = 48
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object lblDoc: TLabel
    Left = 300
    Top = 48
    Width = 53
    Height = 15
    Caption = 'CPF/CNPJ'
  end
  object edtNome: TEdit
    Left = 16
    Top = 64
    Width = 260
    Height = 23
    TabOrder = 0
    OnKeyDown = edtNomeKeyDown
  end
  object edtDoc: TEdit
    Left = 300
    Top = 64
    Width = 160
    Height = 23
    TabOrder = 1
    OnKeyDown = edtDocKeyDown
  end
  object btnPesquisar: TButton
    Left = 480
    Top = 62
    Width = 90
    Height = 25
    Caption = 'Pesquisar'
    TabOrder = 2
    OnClick = btnPesquisarClick
  end
  object btnLimpar: TButton
    Left = 580
    Top = 62
    Width = 90
    Height = 25
    Caption = 'Limpar'
    TabOrder = 3
    OnClick = btnLimparClick
  end
  object grdClientes: TStringGrid
    Left = 16
    Top = 100
    Width = 680
    Height = 300
    TabOrder = 4
    OnDblClick = grdClientesDblClick
  end
  object btnSelecionar: TButton
    Left = 560
    Top = 420
    Width = 140
    Height = 25
    Caption = 'Selecionar Cliente'
    TabOrder = 5
    OnClick = btnSelecionarClick
  end
end

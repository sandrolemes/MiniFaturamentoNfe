object frmCadastroProduto: TfrmCadastroProduto
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produto'
  ClientHeight = 290
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 16
    Top = 10
    Width = 186
    Height = 25
    Caption = 'Cadastro de Produto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDescricao: TLabel
    Left = 16
    Top = 116
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object lblNcm: TLabel
    Left = 16
    Top = 166
    Width = 28
    Height = 15
    Caption = 'NCM'
  end
  object lblCfop: TLabel
    Left = 140
    Top = 166
    Width = 30
    Height = 15
    Caption = 'CFOP'
  end
  object lblPreco: TLabel
    Left = 240
    Top = 166
    Width = 65
    Height = 15
    Caption = 'Pre'#231'o Venda'
  end
  object lblIdProduto: TLabel
    Left = 16
    Top = 58
    Width = 56
    Height = 15
    Caption = 'Id Produto'
  end
  object edtDescricao: TEdit
    Left = 16
    Top = 134
    Width = 380
    Height = 23
    TabOrder = 0
  end
  object edtNcm: TEdit
    Left = 16
    Top = 184
    Width = 100
    Height = 23
    TabOrder = 1
  end
  object edtCfop: TEdit
    Left = 140
    Top = 184
    Width = 80
    Height = 23
    TabOrder = 2
  end
  object edtPreco: TEdit
    Left = 240
    Top = 184
    Width = 120
    Height = 23
    TabOrder = 3
    OnKeyPress = edtPrecoKeyPress
  end
  object btnSalvar: TButton
    Left = 16
    Top = 236
    Width = 120
    Height = 32
    Caption = 'Salvar'
    TabOrder = 4
    OnClick = btnSalvarClick
  end
  object edtIdProduto: TEdit
    Left = 16
    Top = 79
    Width = 73
    Height = 23
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 5
  end
  object btnBuscar: TButton
    Left = 142
    Top = 236
    Width = 120
    Height = 32
    Caption = 'Buscar'
    TabOrder = 6
    OnClick = btnBuscarClick
  end
end

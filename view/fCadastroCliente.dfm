object frmCadastroCliente: TfrmCadastroCliente
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cliente'
  ClientHeight = 277
  ClientWidth = 431
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
    Width = 172
    Height = 25
    Caption = 'Cadastro de Cliente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNome: TLabel
    Left = 16
    Top = 108
    Width = 109
    Height = 15
    Caption = 'Nome / Raz'#227'o Social'
  end
  object lblCpfCnpj: TLabel
    Left = 16
    Top = 158
    Width = 59
    Height = 15
    Caption = 'CPF / CNPJ'
  end
  object lblUf: TLabel
    Left = 240
    Top = 158
    Width = 14
    Height = 15
    Caption = 'UF'
  end
  object Label1: TLabel
    Left = 16
    Top = 58
    Width = 50
    Height = 15
    Caption = 'Id Cliente'
  end
  object lblTipoPessoa: TLabel
    Left = 142
    Top = 58
    Width = 63
    Height = 15
    Caption = 'Tipo Pessoa'
  end
  object lblDtCadastro: TLabel
    Left = 302
    Top = 58
    Width = 74
    Height = 15
    Caption = 'Data Cadastro'
  end
  object edtNome: TEdit
    Left = 16
    Top = 126
    Width = 380
    Height = 23
    TabOrder = 0
  end
  object edtCpfCnpj: TEdit
    Left = 16
    Top = 176
    Width = 200
    Height = 23
    TabOrder = 1
  end
  object edtUf: TEdit
    Left = 240
    Top = 179
    Width = 60
    Height = 23
    TabOrder = 2
  end
  object btnSalvar: TButton
    Left = 16
    Top = 218
    Width = 120
    Height = 32
    Caption = 'Salvar'
    TabOrder = 3
    OnClick = btnSalvarClick
  end
  object edtIdCliente: TEdit
    Left = 16
    Top = 79
    Width = 73
    Height = 23
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 4
  end
  object btnBuscar: TButton
    Left = 142
    Top = 218
    Width = 120
    Height = 32
    Caption = 'Buscar'
    TabOrder = 5
    OnClick = btnBuscarClick
  end
  object cboTipoPessoa: TComboBox
    Left = 142
    Top = 79
    Width = 90
    Height = 23
    Color = clInfoBk
    ItemIndex = 0
    TabOrder = 6
    Text = 'F'
    Items.Strings = (
      'F'
      'J')
  end
  object edtDtCadastro: TEdit
    Left = 302
    Top = 79
    Width = 94
    Height = 23
    Color = clInfoBk
    ReadOnly = True
    TabOrder = 7
  end
end

object fFormulario: TfFormulario
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exemplo de preenchimento de campos com RTTI'
  ClientHeight = 211
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCodigo: TLabel
    Left = 199
    Top = 8
    Width = 37
    Height = 13
    Caption = 'C'#243'digo:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelNome: TLabel
    Left = 255
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Nome:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelEstadoCivil: TLabel
    Left = 199
    Top = 70
    Width = 59
    Height = 13
    Caption = 'Estado Civil:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelSenioridade: TLabel
    Left = 199
    Top = 130
    Width = 60
    Height = 13
    Caption = 'Senioridade:'
  end
  object LabelDataNascimento: TLabel
    Left = 356
    Top = 130
    Width = 100
    Height = 13
    Caption = 'Data de Nascimento:'
  end
  object CampoCorUniforme: TShape
    Left = 475
    Top = 147
    Width = 82
    Height = 17
  end
  object LabelCorUniforme: TLabel
    Left = 475
    Top = 130
    Width = 82
    Height = 13
    Caption = 'Cor do Uniforme:'
  end
  object CampoCodigo: TEdit
    Left = 199
    Top = 24
    Width = 43
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object CampoNome: TEdit
    Left = 255
    Top = 24
    Width = 302
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object CampoSexo: TRadioGroup
    Left = 360
    Top = 61
    Width = 197
    Height = 46
    Caption = 'Sexo'
    Columns = 2
    Items.Strings = (
      'Masculino'
      'Feminino')
    TabOrder = 3
  end
  object CampoEstadoCivil: TComboBox
    Left = 199
    Top = 85
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      'Solteiro(a)'
      'Casado(a)'
      'Divorciado(a)'
      'Vi'#250'vo(a)')
  end
  object CampoPlanoSaude: TCheckBox
    Left = 201
    Top = 186
    Width = 143
    Height = 17
    Caption = 'Plano de Sa'#250'de'
    TabOrder = 6
  end
  object CampoSenioridade: TTrackBar
    Left = 194
    Top = 149
    Width = 156
    Height = 33
    TabOrder = 4
  end
  object CampoDataNascimento: TDateTimePicker
    Left = 356
    Top = 145
    Width = 100
    Height = 21
    Date = 42856.040230960650000000
    Time = 42856.040230960650000000
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 169
    Height = 197
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Nome'
        Width = 135
        Visible = True
      end>
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 72
    Top = 128
  end
  object ClientDataSet: TClientDataSet
    PersistDataPacket.Data = {
      330000009619E0BD0100000018000000010000000000030000003300044E6F6D
      6501004900000001000557494454480200020064000000}
    Active = True
    Aggregates = <>
    Params = <>
    AfterScroll = ClientDataSetAfterScroll
    Left = 72
    Top = 72
    object ClientDataSetNome: TStringField
      FieldName = 'Nome'
      Size = 100
    end
  end
end

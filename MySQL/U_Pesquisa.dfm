object frmPesquisa: TfrmPesquisa
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pesquisa...'
  ClientHeight = 400
  ClientWidth = 694
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Calibri'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Width = 694
    Height = 55
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 684
  end
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 79
    Height = 15
    Caption = '&PESQUISA POR'
    FocusControl = CBCampos
  end
  object CBCampos: TComboBox
    Left = 8
    Top = 22
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 0
    OnClick = CBCamposClick
    OnKeyDown = CBCamposKeyDown
  end
  object edtPesquisa: TEdit
    Left = 150
    Top = 22
    Width = 527
    Height = 23
    CharCase = ecUpperCase
    Color = clInfoBk
    TabOrder = 1
    OnChange = edtPesquisaChange
    OnKeyDown = edtPesquisaKeyDown
  end
  object DBGPesquisa: TDBGrid
    Left = 0
    Top = 55
    Width = 694
    Height = 301
    Align = alClient
    Color = clInfoBk
    DataSource = dsPesquisa
    DrawingStyle = gdsGradient
    GradientStartColor = clWindow
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Calibri'
    TitleFont.Style = [fsBold]
    OnKeyDown = DBGPesquisaKeyDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 356
    Width = 694
    Height = 44
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 4
    object bbConfirma: TBitBtn
      Left = 557
      Top = 7
      Width = 120
      Height = 26
      Caption = '&CONFIRMA'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
    end
  end
  object mkeData: TMaskEdit
    Left = 150
    Top = 22
    Width = 527
    Height = 23
    CharCase = ecUpperCase
    Color = clInfoBk
    EditMask = '!99/99/9999;1; '
    MaxLength = 10
    TabOrder = 2
    Text = '  /  /    '
    OnExit = mkeDataExit
    OnKeyDown = mkeDataKeyDown
  end
  object dsPesquisa: TDataSource
    DataSet = qryPesquisa
    Left = 448
    Top = 72
  end
  object qryPesquisa: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspGeral'
    Left = 384
    Top = 72
  end
  object qryPesquisaDBX: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 384
    Top = 128
  end
  object qryPesquisaFD: TFDQuery
    SQL.Strings = (
      'SELECT * FROM PRODUTO')
    Left = 384
    Top = 184
  end
end

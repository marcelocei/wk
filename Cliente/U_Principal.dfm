object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RESTClient...'
  ClientHeight = 326
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 610
    Height = 261
    Align = alClient
    DataSource = dsPessoa
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'idpessoa'
        Title.Alignment = taCenter
        Title.Caption = 'ID'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 50
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'flnatureza'
        Title.Alignment = taCenter
        Title.Caption = 'NATUREZA'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dsdocumento'
        Title.Alignment = taCenter
        Title.Caption = 'DOCUMENTO'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 120
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'nmprimeiro'
        Title.Alignment = taCenter
        Title.Caption = 'PRIMEIRO'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 80
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'nmsegundo'
        Title.Alignment = taCenter
        Title.Caption = 'SEGUNDO'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dscep'
        Title.Alignment = taCenter
        Title.Caption = 'CEP'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 80
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'dtregistro'
        Title.Alignment = taCenter
        Title.Caption = 'REGISTRO'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Tahoma'
        Title.Font.Style = [fsBold]
        Width = 80
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    AlignWithMargins = True
    Left = 0
    Top = 264
    Width = 610
    Height = 25
    Margins.Left = 0
    Margins.Right = 0
    DataSource = dsPessoa
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbRefresh]
    Align = alBottom
    Hints.Strings = (
      'Primeiro Registro'
      'Registro Anterior'
      'Pr'#243'ximo Registro'
      #218'ltimo Registro'
      'Inclui Registro'
      'Apaga Registro'
      'Altera Registro'
      'Grava'
      'Cancela'
      'Atualiza'
      'Apply updates'
      'Cancel updates')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    BeforeAction = DBNavigator1BeforeAction
    ExplicitWidth = 529
  end
  object Panel1: TPanel
    Left = 0
    Top = 292
    Width = 610
    Height = 34
    Margins.Left = 0
    Margins.Top = 2
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    ExplicitWidth = 529
    object Button1: TButton
      AlignWithMargins = True
      Left = 504
      Top = 2
      Width = 106
      Height = 27
      Margins.Left = 0
      Margins.Top = 2
      Margins.Right = 0
      Align = alRight
      Caption = '&Sair'
      TabOrder = 0
      OnClick = Button1Click
      ExplicitLeft = 423
    end
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8080/wk/pessoa'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 96
    Top = 16
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 96
    Top = 48
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json'
    Left = 96
    Top = 88
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = fdmPessoa
    FieldDefs = <>
    Response = RESTResponse1
    Left = 96
    Top = 128
  end
  object fdmPessoa: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'idpessoa'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'flnatureza'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'dsdocumento'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'nmprimeiro'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'nmsegundo'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'dscep'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'dtregistro'
        DataType = ftWideString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 96
    Top = 184
  end
  object dsPessoa: TDataSource
    DataSet = fdmPessoa
    Left = 96
    Top = 232
  end
end

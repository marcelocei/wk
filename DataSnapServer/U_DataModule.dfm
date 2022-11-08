object dssmWK: TdssmWK
  OldCreateOrder = False
  Height = 490
  Width = 581
  object fdcWK: TFDConnection
    Params.Strings = (
      'Database=WK'
      'User_Name=postgres'
      'Password=sa123456'
      'Server=SERVIDOR-W7'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 96
    Top = 52
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 96
    Top = 112
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 96
    Top = 168
  end
  object qryGeral: TFDQuery
    Connection = fdcWK
    Left = 208
    Top = 56
  end
  object FDQuery1: TFDQuery
    Connection = fdcWK
    SQL.Strings = (
      'DO $$'
      '  DECLARE'
      '    ID_SEQ BIGINT;'
      'BEGIN'
      '  SELECT MAX(IDPESSOA) + 1 INTO ID_SEQ FROM PESSOA;'
      ''
      '  IF ID_SEQ IS NULL THEN ID_SEQ = 1;'
      '  END IF;'
      ''
      
        '  EXECUTE '#39'INSERT INTO PESSOA (IDPESSOA ,FLNATUREZA, DSDOCUMENTO' +
        ', NMPRIMEIRO, NMSEGUNDO, DTREGISTRO)'
      
        '           VALUES(||ID_SEQ||, &{FLNATUREZA}, &DSDOCUMENTO, &NMPR' +
        'IMEIRO, &NMSEGUNDO, CURRENT_DATE)'#39';'
      'END;'
      '$$ LANGUAGE plpgsql;')
    Left = 328
    Top = 200
  end
  object FDQuery2: TFDQuery
    Connection = fdcWK
    Left = 264
    Top = 360
  end
end

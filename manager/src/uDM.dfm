object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 720
  Top = 409
  Height = 120
  Width = 472
  object connMain: TUniConnection
    Database = 'D:\project\microfilter\project\inspection qr\src\bin\IQ.gdb'
    Left = 24
    Top = 19
    EncryptedPassword = ''
  end
  object sp: TUniStoredProc
    Connection = connMain
    Left = 64
    Top = 19
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 112
    Top = 18
  end
end

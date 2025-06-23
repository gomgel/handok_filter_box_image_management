unit uDM;

interface

uses
  SysUtils, Classes, UniProvider, SQLServerUniProvider, DB, MemDS, Dialogs,
  DBAccess, Uni, uConst, uConfig, ColCombo;

type
    TdmMain = class(TDataModule)
        connMain: TUniConnection;
        sp: TUniStoredProc;
        SQLServerUniProvider1: TSQLServerUniProvider;
        procedure DataModuleCreate(Sender: TObject);
        procedure DataModuleDestroy(Sender: TObject);
    private
        procedure init;
        procedure final;


    public
        function checkDBConnected : Boolean;
    end;

var
  dmMain: TdmMain;

implementation

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
    init;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
    final;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TdmMain.init;
begin
//    checkDBConnected;
end;

procedure TdmMain.final;
begin
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

function TdmMain.checkDBConnected : Boolean;
begin
    Result := False;

    try
        connMain.Connected := False;
    except
    end;

    connMain.ProviderName   := 'SQL Server';
    connMain.Server         := TConfig.GetObject.DBIP;
    connMain.Port           := StrToIntDef(TConfig.GetObject.DBPort, 1433);
    connMain.Username       := TConfig.GetObject.DBID;
    connMain.Password       := TConfig.GetObject.DBPW;
    connMain.Database       := TConfig.GetObject.DBName;

    try
        connMain.Connected  := True;

        Result := True;
    except
        Result := False;
    end;

end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////


end.

unit uThread;

interface

uses
    Windows, SysUtils, Classes, DB, DBAccess, Uni, UniProvider, SQLServerUniProvider, ActiveX, Forms,
    uConfig, DateUtils;

type
    TThreadForAutoDeletion = class(TThread)
    private

        FStarted                : Boolean;
        FDBConnected            : Boolean;

        FUniConnection      : TUniConnection;
        FUniProvider        : TSQLServerUniProvider;
        FUniStoredProc      : TUniStoredProc;

        FInterval           : Integer;

        function ConnectDB : Boolean;

        procedure Execute; override;

        procedure doTaskForDeletion(date : String);

    public
        constructor Create(APrioriy : TThreadPriority; AInterval : Integer);

        destructor Destroy; override;

        procedure Start;

        property Started : Boolean read FStarted write FStarted;

    end;

implementation

constructor TThreadForAutoDeletion.Create(APrioriy : TThreadPriority; AInterval : Integer);
var
    strServer : String;
begin
    Inherited Create(True);
    FreeOnTerminate     := False;
    Priority            := APrioriy;

    FInterval           := AInterval * 1000;

    FUniConnection := TUniConnection.Create(Nil);
    FUniStoredProc := TUniStoredProc.Create(Nil);
    FUniProvider   := TSQLServerUniProvider.Create(Nil);

    FUniStoredProc.Connection   := FUniConnection;

    Self.Start;
end;

destructor TThreadForAutoDeletion.Destroy;
begin

    if Assigned(FUniConnection) then
    begin
        FUniConnection.Disconnect;
        FreeAndNil(FUniConnection);
    end;

    if Assigned(FUniStoredProc) then FreeAndNil(FUniStoredProc);

    Inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

function TThreadForAutoDeletion.ConnectDB : Boolean;
begin
    Result := False;

    try
        FUniConnection.Connected := False;
    except
    end;

    FUniConnection.ProviderName   := 'SQL Server';
    FUniConnection.Server         := TConfig.GetObject.DBIP;
    FUniConnection.Port           := StrToIntDef(TConfig.GetObject.DBPort, 1433);
    FUniConnection.Username       := TConfig.GetObject.DBID;
    FUniConnection.Password       := TConfig.GetObject.DBPW;
    FUniConnection.Database       := TConfig.GetObject.DBName;

    try
        try
            CoInitialize(Nil);
            FUniConnection.Connected  := True;

            Result := True;
        except
            Result := False;
        end;
    finally
        CoUnInitialize;
    end;

end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TThreadForAutoDeletion.Start;
begin
    if FStarted then Exit;

    FStarted    := True;
    ConnectDB;

    Resume;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TThreadForAutoDeletion.doTaskForDeletion(date : String);
var
    index   : Integer;
    strTemp : String;
begin
    try

        if Not ConnectDB then Exit;

        with FUniStoredProc do
        begin
            Close;
            StoredProcName := '';
            StoredProcName := UpperCase('pda_get_screenshot');
            Params.Clear;

            Prepare;

            Params.ParamByName('p_action').AsString     := 'remove';
            Params.ParamByName('p_from_date').AsString  := date;

            Execute;

            if recordCount = 0 then Exit;

            try
                while Not Eof do
                begin

                    Next;
                end;
            finally
            end;
        end;

    except

        try
            FUniConnection.Ping;
        except
        end;

    end;
end;


////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TThreadForAutoDeletion.Execute;
var
    ni : Integer;
    date : String;
begin
    try
        ni := FInterval + 1;
        while Not Terminated do
        begin
            if ni > FInterval then
            begin
                ni := 0;

                date := FormatDateTime('YYYYMMDD', IncDay(Now, StrToIntDef('-' + TConfig.GetObject.EffectiveDuration, -365)));
                OutputDebugString(PChar('remove date : ' + date));

                doTaskForDeletion(date);
            end;
            
            Sleep(10); Application.ProcessMessages;
            inc(ni, 10);
        end;
    except
    end;
end;

end.

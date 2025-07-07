unit uThread;

interface

uses
    Windows, SysUtils, Classes, DB, DBAccess, Uni, UniProvider, SQLServerUniProvider, ActiveX, Forms,
    uConfig, DateUtils, uType;

type
    TThreadForAutoDeletion = class(TThread)
    private

        FStarted                : Boolean;
        FDBConnected            : Boolean;

        FUniConnection      : TUniConnection;
        FUniProvider        : TSQLServerUniProvider;
        FUniStoredProc      : TUniStoredProc;

        FInterval           : Integer;

        FStepEvent          : TNotifyStepEvent;

        function ConnectDB : Boolean;

        procedure Execute; override;

        function get(date : String) : Integer;
        function remove(list : TStringList) : Boolean;

        function removeFileOnLocal(path : String) : Boolean;
        function removeFileOnDB(uuid : String) : Boolean;


    public
        constructor Create(APrioriy : TThreadPriority; AInterval : Integer; AStepEvent : TNotifyStepEvent);

        destructor Destroy; override;

        procedure Start;

        property Started : Boolean read FStarted write FStarted;

    end;

implementation

constructor TThreadForAutoDeletion.Create(APrioriy : TThreadPriority; AInterval : Integer; AStepEvent : TNotifyStepEvent);
var
    strServer : String;
begin
    Inherited Create(True);
    FreeOnTerminate     := False;
    Priority            := APrioriy;

    FStepEvent          := AStepEvent;


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

function TThreadForAutoDeletion.removeFileOnLocal(path : String) : Boolean;
begin
    if FileExists(path) then
    begin
        if DeleteFile(path) then
        begin
            OutputDebugString(PChar('Deletion Success... : ' + path ));
        end
        else
        begin
            OutputDebugString(PChar('Deletion failed... : ' + path ));
        end;
    end
    else
    begin
        OutputDebugString(PChar('This file is not found : ' + path ));
    end;
end;

function TThreadForAutoDeletion.removeFileOnDB(uuid : String) : Boolean;
begin
    Result := False;

    if Not FUniConnection.Connected then Exit;

    with FUniStoredProc do
    begin
        Close;
        StoredProcName := '';
        StoredProcName := UpperCase('pda_set_screenshot');
        Params.Clear;

        Prepare;

        Params.ParamByName('p_action').AsString     := 'delete';
        Params.ParamByName('p_image_uuid').AsString  := uuid;

        Execute;

        OutputDebugString(PChar('Try to remove a file Info : ' + Params.ParamByName('p_result_code').AsString + ' - ' + Params.ParamByName('p_result_msg').AsString));

        result := True;
    end;

end;

function TThreadForAutoDeletion.remove(list : TStringList) : Boolean;
var
    ni : Integer;
    uuid, path : String;
begin
    if list.Count = 0 then
    begin
        Result := True;
        Exit;
    end;

    for ni := 0 to list.Count - 1 do
    begin
        if Terminated then Break;

        uuid := list.Names[ni];
        path := list.ValueFromIndex[ni];

        if removeFileOnDB(uuid) then
        begin
            removeFileOnLocal(path);
        end
        else
        begin
            Result := False;
            Exit;
        end;

        OutputDebugString(PChar( uuid + ' - ' + path));
    end;
    Result := True;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

function TThreadForAutoDeletion.get(date : String) : Integer;
var
    index   : Integer;
    strTemp : String;
    list    : TStringList;
begin
    try

        if Not ConnectDB then
        begin
            Result := -2;
            Exit;
        end;

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

            if recordCount = 0 then
            begin
                Result := 0;
                Exit;
            end;

            try

                list := TStringList.Create;

                while Not Eof do
                begin
                    OutputDebugString(PChar('file name that need to remove : ' + FieldByName('file_name').AsString));

                    list.Add(FieldByName('image_uuid').AsString +'='+ FieldByName('file_path').AsString);

                    Next;
                end;

                if list.Count > 0 then
                begin
                    if Not remove(list) then
                    begin
                        Result := -1;
                        Exit;
                    end;
                end;
            finally
                if Assigned(list) then FreeAndNil(list);
            end;
        end;

    except

        Result := -9;

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
    ni, nj : Integer;
    date : String;
    res : Integer;
begin
    try
        ni := FInterval + 1;
        while Not Terminated do
        begin
            if ni > FInterval then
            begin
                ni := 0;

                if Assigned(FStepEvent) then FStepEvent(1);

                nj := 0;
                while 1=1 do
                begin
                    if nj > 2000 then Break;
                    Sleep(10); Application.ProcessMessages;
                    inc(nj, 10);
                end;

                date := FormatDateTime('YYYYMMDD', IncDay(Now, StrToIntDef('-' + TConfig.GetObject.EffectiveDuration, -365)));
                OutputDebugString(PChar('remove date : ' + date));

                res := get(date);
                if Assigned(FStepEvent) then FStepEvent(res);
            end;
            
            Sleep(10); Application.ProcessMessages;
            inc(ni, 10);
        end;
    except
    end;
end;

end.

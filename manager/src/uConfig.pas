unit uConfig;

interface

uses
    Windows, SysUtils, Classes, IniFiles, Forms, Dialogs;

type
    TConfig = class
    private
        FVersion                : String;

        FDBIP                   : String;
        FDBPort                 : String;
        FDBName                 : String;
        FDBID                   : String;
        FDBPW                   : String;

        FIniFile                : TIniFile;

        FApplicationPath        : String;

        constructor Create;
        destructor Destroy; override;

        procedure Init;
        procedure Final;

        procedure Load;

        procedure SetConfig(AIndex : Integer; AValue : String);
    public
        class function GetObject : TConfig;

        property Version                : String    read FVersion;

        property DBIP                   : String    Index 0     read FDBIP                  write SetConfig;
        property DBPort                 : String    Index 1     read FDBPort                write SetConfig;
        property DBID                   : String    Index 2     read FDBID                  write SetConfig;
        property DBPW                   : String    Index 3     read FDBPW                  write SetConfig;
        property DBName                 : String    Index 4     read FDBName                write SetConfig;

        property ApplicationPath        : String                read FApplicationPath;
    end;

implementation

var
    config : TConfig;

class function TConfig.GetObject() : TConfig;
begin
    if Not Assigned(config) then config := TConfig.Create;
    Result := config;
end;

constructor TConfig.Create;
begin
    Init;
end;

destructor TConfig.Destroy;
begin
    Final;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TConfig.Init;
var
    strPath : String;
begin
    strPath := ExtractFilePath(Application.ExeName) + '\ini\config.ini';

    FApplicationPath := ExtractFilePath(Application.ExeName);

    if Not FileExists(strPath) then
    begin
        ShowMessage('환경설정 파일이 없습니다.');
        Application.Terminate;
        Exit;
    end;

    FIniFile := TIniFile.Create(strPath);

    Self.Load;
end;

procedure TConfig.Final;
begin
    if Assigned(FIniFile) then FreeAndNil(FIniFile);
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TConfig.Load();
begin
    if Not Assigned(FIniFile) then Exit;

    FVersion        := FIniFile.ReadString('COMMON', 'VERSION', '');

    FDBIP           := FIniFile.ReadString('COMMON', 'DBIP', '');
    FDBPort         := FIniFile.ReadString('COMMON', 'DBPORT', '');
    FDBID           := FIniFile.ReadString('COMMON', 'DBID', '');
    FDBPW           := FIniFile.ReadString('COMMON', 'DBPW', '');
    FDBName         := FIniFile.ReadString('COMMON', 'DBNAME', '');

end;

procedure TConfig.SetConfig(AIndex : Integer; AValue : String);
begin
    case aIndex of
        0 : begin FDBIP                         := aValue;  FIniFile.WriteString('COMMON',  'DBIP',         aValue);    end;
        1 : begin FDBPort                       := aValue;  FIniFile.WriteString('COMMON',  'DBPORT',       aValue);    end;
        2 : begin FDBID                         := aValue;  FIniFile.WriteString('COMMON',  'DBID',         aValue);    end;
        3 : begin FDBPW                         := aValue;  FIniFile.WriteString('COMMON',  'DBPW',         aValue);    end;
        4 : begin FDBName                       := aValue;  FIniFile.WriteString('COMMON',  'DBNAME',       aValue);    end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

Initialization
begin
    config := TConfig.Create;
end;

Finalization
begin
    if Assigned(config) then config.Free;
end;

end.

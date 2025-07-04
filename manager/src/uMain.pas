unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tmsAdvGridExcel, DB, MemDS, DBAccess, Uni, UniProvider,
  InterBaseUniProvider, Grids, AdvObj, BaseGrid, AdvGrid, AdvCGrid,
  StdCtrls, Mask, AdvSmoothEdit, AdvSmoothEditButton, AdvSmoothDatePicker,
  AdvMetroButton, AdvGlowButton, AdvOfficeImage, ExtCtrls, AdvCombo,
  ColCombo, AdvOfficeStatusBar, AdvOfficeStatusBarStylers, ShellAPi,
  AdvWiiProgressBar, uThread;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    AdvOfficeImage1: TAdvOfficeImage;
    btnClose: TAdvGlowButton;
    Panel14: TPanel;
    AdvMetroButton10: TAdvMetroButton;
    btnSearch: TAdvGlowButton;
    dpTo: TAdvSmoothDatePicker;
    dpFrom: TAdvSmoothDatePicker;
    Panel2: TPanel;
    AdvMetroButton1: TAdvMetroButton;
    btnExport: TAdvGlowButton;
    acg: TAdvColumnGrid;
    Panel3: TPanel;
    UniConnection: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    UniQuery: TUniQuery;
    AdvGridExcelIO: TAdvGridExcelIO;
    cbxLine: TColumnComboBox;
    asbInfo: TAdvOfficeStatusBar;
    AdvOfficeStatusBarOfficeStyler1: TAdvOfficeStatusBarOfficeStyler;
    pbProgress: TAdvWiiProgressBar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure acgDblClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    FThreadForAutoDeletion  : TThreadForAutoDeletion;

    procedure init;
    procedure final;
  public
    procedure get(fromDate, toDate, line : String);
    procedure getLine;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
    uDM;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    init;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
//
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    final;
end;

procedure TfrmMain.init;
begin

    Panel2.DoubleBuffered := True;

    dpFrom.Date := Now;
    dpTo.Date   := Now;

    FThreadForAutoDeletion := TThreadForAutoDeletion.Create(tpNormal, 5*60*1000);


    if dmMain.checkDBConnected then
    begin
        getLine;
        asbInfo.Panels[2].Progress.BackGround := $00F7BF00
    end
    else
    begin
        asbInfo.Panels[2].Progress.BackGround := $004242FF;
    end;

end;

procedure TfrmMain.final;
begin
    if Assigned(FThreadForAutoDeletion) then
    begin
        FThreadForAutoDeletion.Terminate;
        FThreadForAutoDeletion.WaitFor;
        FreeAndNil(FThreadForAutoDeletion);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
///////////////////////////////////////////////////////////////////////////////


procedure TfrmMain.get(fromDate, toDate, line : String);
var
    strTemp : String;
    grid : TAdvColumnGrid;
begin
    try
        grid := acg;
        grid.RowCount := 1;

        with dmMain.sp do
        begin
            Close;
            StoredProcName := '';
            StoredProcName := UpperCase('pda_get_screenshot');
            Params.Clear;

            Prepare;

            Params.ParamByName('p_action').AsString     := 'search';
            Params.ParamByName('p_from_date').AsString := fromDate;
            Params.ParamByName('p_to_date').AsString   := toDate;
            Params.ParamByName('p_line_no').AsString   := line;

            Execute;

            if recordCount = 0 then Exit;

            try

                grid.BeginUpdate;

                while Not Eof do
                begin

                    grid.RowCount := grid.RowCount + 1;                    

                    grid.Cells[grid.ColumnByName['no'].Index, grid.RowCount - 1]        := IntToStr(grid.RowCount - 1);
                    grid.Cells[grid.ColumnByName['image_uuid'].Index, grid.RowCount - 1]:= FieldByName('image_uuid').AsString;
                    grid.Cells[grid.ColumnByName['image_date'].Index, grid.RowCount - 1]:= FieldByName('image_date').AsString;
                    grid.Cells[grid.ColumnByName['line_no'].Index, grid.RowCount - 1]   := FieldByName('line_no').AsString;//FormatMaskText('0000-00-00 00:00:00;0', FieldByName('SCAN_DATE').AsString);
                    grid.Cells[grid.ColumnByName['line_nm'].Index, grid.RowCount - 1]   := FieldByName('line_nm').AsString;
                    grid.Cells[grid.ColumnByName['emp01_nm'].Index, grid.RowCount - 1]  := FieldByName('emp01_nm').AsString;
                    grid.Cells[grid.ColumnByName['emp02_nm'].Index, grid.RowCount - 1]  := FieldByName('emp02_nm').AsString;
                    grid.Cells[grid.ColumnByName['emp03_nm'].Index, grid.RowCount - 1]  := FieldByName('emp03_nm').AsString;
                    grid.Cells[grid.ColumnByName['file_name'].Index, grid.RowCount - 1] := FieldByName('file_name').AsString;
                    grid.Cells[grid.ColumnByName['file_path'].Index, grid.RowCount - 1] := FieldByName('file_path').AsString;
                    grid.Cells[grid.ColumnByName['cre_dt'].Index, grid.RowCount - 1]    := FieldByName('cre_dt').AsString;
                    grid.Cells[grid.ColumnByName['emp1'].Index, grid.RowCount - 1]      := FieldByName('emp1').AsString;
                    grid.Cells[grid.ColumnByName['emp2'].Index, grid.RowCount - 1]      := FieldByName('emp2').AsString;
                    grid.Cells[grid.ColumnByName['emp3'].Index, grid.RowCount - 1]      := FieldByName('emp3').AsString;


                    Next;
                end;
            finally
                grid.EndUpdate;
            end;
        end;
    except
        on E : Exception do
        begin
            //
        end;
    end;
end;

procedure TfrmMain.getLine;
var
    strTemp : String;
begin
    try
        with dmMain.sp do
        begin
            Close;
            StoredProcName := '';
            StoredProcName := UpperCase('pda_get_line');
            Params.Clear;

            Prepare;

            Params.ParamByName('p_action').AsString      := '';
            Params.ParamByName('p_wc_cd').AsString       := '';
            Params.ParamByName('p_line_nm_1st').AsString := '';
            Params.ParamByName('p_line_nm_2nd').AsString := '';
            Params.ParamByName('p_line_nm_3rd').AsString := '';

            Execute;

            if recordCount > 0 then
            begin
                while Not Eof do
                begin
                    with cbxLine.ComboItems.Add do
                    begin
                        Strings.Add(FieldByName('line_nm').AsString);
                        Strings.Add(FieldByName('line_no').AsString);
                    end;
                    Next;
                end;
            end;
        end;
    except
        on E : Exception do
        begin
            //
        end;
    end;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmMain.btnSearchClick(Sender: TObject);
var
    line : String;
begin
    if cbxLine.ItemIndex < 0 then line := ''
    else line := cbxLine.ColumnItems[cbxLine.ItemIndex, 1];

    get(
        FormatDateTime('YYYYMMDD', dpFrom.Date),
        FormatDateTime('YYYYMMDD', dpTo.Date),
        line
    )
end;

procedure TfrmMain.acgDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
    if ARow = 0 then Exit;
    if acg.ColumnByName['file_path'].Index <> ACol then Exit;
    if Not FileExists(acg.Cells[ACol, ARow]) then
    begin
        ShowMessage('존재 하지 않는 파일입니다.');
        Exit;    
    end;

    ShellExecute(Application.handle, 'open', PChar(acg.Cells[ACol, ARow]), '', Nil, sw_show);
end;

end.

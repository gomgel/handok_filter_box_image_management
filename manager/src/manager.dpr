program manager;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uConfig in 'uConfig.pas',
  uDM in 'uDM.pas' {dmMain: TDataModule},
  uConst in 'uConst.pas',
  uThread in 'uThread.pas',
  uType in 'uType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

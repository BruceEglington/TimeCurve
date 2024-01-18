unit TC_ShtExp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, OleCtrls, ExtCtrls, StdCtrls, FileCtrl, Grids,
  DBGrids, DB, DBTables, TTF160_TLB, AxCtrls, ADODB;

type
  TfmSheetExport = class(TForm)
    Panel1: TPanel;
    sbClose: TSpeedButton;
    sbSheet: TStatusBar;
    SaveDialogSprdSheet: TSaveDialog;
    gb3: TGroupBox;
    bbSaveSheet: TBitBtn;
    SprdSheet: TF1Book6;
    ds1: TDataSource;
    procedure sbCloseClick(Sender: TObject);
    procedure bbSaveSheetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MaxIsData : Integer;
    IsData : array[1..20000] of boolean;
    procedure FillSheet(StartCol : integer; DataName : string);
  end;

var
  fmSheetExport: TfmSheetExport;

implementation

uses mar_def, TC_dm;

{$R *.DFM}

procedure TfmSheetExport.sbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSheetExport.bbSaveSheetClick(Sender: TObject);
const
  Excel5Type = 4;
  Excel97Type = 11;
  VisualComponentType = 5;
  FormulaOne6Type = 12;
var
  pFileType : smallint;
  pBuf      : string;
  pTitle    : string;
  tmpStr    : string[3];
begin
  SaveDialogSprdSheet.InitialDir := ExportPath;
  SaveDialogSprdSheet.FileName := 'Summary';
  if SaveDialogSprdSheet.Execute then
  begin
    ExportPath := ExtractFilePath(SaveDialogSprdSheet.FileName);
    pFileType := Excel97Type;
    case SaveDialogSprdSheet.FilterIndex of
      1 : pFileType := Excel97Type;
      2 : pFileType := Excel5Type;
    end;
    pBuf := SaveDialogSprdSheet.FileName;
    SprdSheet.Write(pBuf,pFileType);
  end;
end;

procedure TfmSheetExport.FillSheet(StartCol : integer; Dataname : string);
var
  i, j : integer;
begin
  ds1.DataSet.DisableControls;
  try
    i := 1;
    ds1.DataSet.First;
    SprdSheet.Row := i;
    for j := 0 to ds1.DataSet.FieldCount - 1 do
    begin
      SprdSheet.Col := j+StartCol;
      SprdSheet.Text := ds1.DataSet.Fields[j].FieldName;
    end;
    i := i + 1;
    SprdSheet.Row := i;
    SprdSheet.Col := StartCol;
    SprdSheet.Text := DataName;
    for i := 1 to ds1.DataSet.RecordCount do
    begin
      SprdSheet.Row := i+2;
      for j := 0 to ds1.DataSet.FieldCount - 1 do
      begin
        SprdSheet.Col := j+StartCol;
        try
          SprdSheet.NumberFormatLocal := '####0.000000';
          SprdSheet.Number := ds1.DataSet.Fields[j].AsVariant;
        except
          SprdSheet.Text := ds1.DataSet.Fields[j].AsString;
        end;
      end;
      ds1.DataSet.Next;
    end;
    SprdSheet.Row := 1;
    ds1.DataSet.First;
  finally
    ds1.DataSet.EnableControls;
  end;
  SprdSheet.MaxCol := StartCol + ds1.DataSet.FieldCount + 2;
  {
  SprdSheet.MaxRow := ds1.DataSet.RecordCount + 2;
  }
  SprdSheet.Row := 1;
  SprdSheet.Col := 1;
  SprdSheet.ShowActiveCell;
end;

procedure TfmSheetExport.FormCreate(Sender: TObject);
begin
  MaxIsData := 3000;
end;

procedure TfmSheetExport.FormShow(Sender: TObject);
var
  tempi : integer;
  CanProceed : boolean;
begin
  gb3.enabled := true;
  bbSaveSheet.Enabled := true;
  with dmSea do
  begin
    cdsSeaRaw.FileName := cdsPath+'\'+'SeaRaw.cds';
    if not FileExists(cdsSeaRaw.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'\'+'SeaRaw.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'\'+'SeaRaw.cds',mtInformation,[mbOK],0);
      }
    end;
    CanProceed := true;
    cdsSeaRawAv.FileName := cdsPath+'\'+'SeaRawAv.cds';
    if not FileExists(cdsSeaRawAv.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'\'+'SeaRawAv.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'\'+'SeaRawAv.cds',mtInformation,[mbOK],0);
      }
    end;
    cdsSeaSpl.FileName := cdsPath+'\'+'SeaSpl.cds';
    if not FileExists(cdsSeaSpl.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'\'+'SeaSpl.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'\'+'SeaSpl.cds',mtInformation,[mbOK],0);
      }
    end;
    cdsSeaSplM.FileName := cdsPath+'\'+'SeaSplM.cds';
    if not FileExists(cdsSeaSplM.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'\'+'SeaSplM.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'\'+'SeaSplM.cds',mtInformation,[mbOK],0);
      }
    end;
    cdsSeaSplP.FileName := cdsPath+'\'+'SeaSplP.cds';
    if not FileExists(cdsSeaSplP.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'\'+'SeaSplP.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'\'+'SeaSplP.cds',mtInformation,[mbOK],0);
      }
    end;
    CanProceed := true;
    cdsMovAv.FileName := cdsPath+'\'+'MovAv.cds';
    if not FileExists(cdsMovAv.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'\'+'MovAv.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'\'+'MovAv.cds',mtInformation,[mbOK],0);
      }
    end;
    if CanProceed then
    begin
      try
        cdsSeaRaw.LoadFromFile(cdsPath+'\'+'SeaRaw.cds');
        cdsSeaRaw.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'\'+'SeaRaw.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaRawAv.LoadFromFile(cdsPath+'\'+'SeaRawAv.cds');
        cdsSeaRawAv.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'\'+'SeaRawAv.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSpl.LoadFromFile(cdsPath+'\'+'SeaSpl.cds');
        cdsSeaSpl.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'\'+'SeaSpl.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSplM.LoadFromFile(cdsPath+'\'+'SeaSplM.cds');
        cdsSeaSplM.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'\'+'SeaSplM.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSplP.LoadFromFile(cdsPath+'\'+'SeaSplP.cds');
        cdsSeaSplP.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'\'+'SeaSplP.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsMovAv.LoadFromFile(cdsPath+'\'+'MovAv.cds');
        cdsMovAv.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'\'+'MovAv.cds',mtWarning,[mbOK],0);
      end;
    end else
    begin
      Close;
    end;
  end;
  SprdSheet.NumSheets := 2;
  SprdSheet.Sheet := 2;
  {
  SprdSheet.SheetName[2] := 'AveragedData';
  }
  ds1.DataSet := dmSea.cdsSeaRawAv;
  tempi := 1;
  FillSheet(tempi,'AveragedData');
  SprdSheet.Sheet := 1;
  {
  SprdSheet.SheetName[1] := 'Curves';
  }
  ds1.DataSet := dmSea.cdsSeaSpl;
  tempi := 1;
  FillSheet(tempi,'Spline');
  tempi := tempi + ds1.DataSet.FieldCount;
  ds1.DataSet := dmSea.cdsSeaSplP;
  FillSheet(tempi,'Spline +95%');
  tempi := tempi + ds1.DataSet.FieldCount;
  ds1.DataSet := dmSea.cdsSeaSplM;
  FillSheet(tempi,'Spline -95%');
  tempi := tempi + ds1.DataSet.FieldCount;
  ds1.DataSet := dmSea.cdsMovAv;
  FillSheet(tempi,'MovingAverage');
end;


end.

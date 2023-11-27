unit tc_movav;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  Printers, Mask, DBCtrls, ActnList, Series, TeEngine, TeeProcs, Chart,
  DbChart, Mar_def, VclTee.TeeGDIPlus, System.Actions, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, SVGIconVirtualImageList;

type
  TfmMovAv = class(TForm)
    GroupBox4: TGroupBox;
    Panel5: TPanel;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ActionList1: TActionList;
    sbMovAv: TStatusBar;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    WMultStr: TEdit;
    WConstStr: TEdit;
    MovAvAgeIncrementStr: TEdit;
    pcMovAv: TPageControl;
    tsDefine: TTabSheet;
    tsGraph: TTabSheet;
    DBChart1: TDBChart;
    Series1: TPointSeries;
    Series4: TLineSeries;
    dbgSeaRaw: TDBGrid;
    tsSpline: TTabSheet;
    GroupBox1: TGroupBox;
    DBGrid4: TDBGrid;
    Panel3: TPanel;
    bbShowData: TBitBtn;
    bbShowMovAv: TBitBtn;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    eFromAge: TEdit;
    Label7: TLabel;
    eToAge: TEdit;
    bbClose: TBitBtn;
    bbPrinterSetup: TBitBtn;
    bbCalculate: TBitBtn;
    bbImport: TBitBtn;
    tsData: TTabSheet;
    bbPrintGraph: TBitBtn;
    DBNavigator1: TDBNavigator;
    Panel16: TPanel;
    rbAgeFrame: TRadioButton;
    RadioButton1: TRadioButton;
    PointIncrementStr: TEdit;
    Label3: TLabel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Panel6: TPanel;
    dbnMovAv: TDBNavigator;
    Panel7: TPanel;
    bbMovAv: TBitBtn;
    eCountMovAv: TEdit;
    Panel8: TPanel;
    dbgMovAv: TDBGrid;
    Panel12: TPanel;
    Panel9: TPanel;
    GroupBox2: TGroupBox;
    Panel10: TPanel;
    rbMean: TRadioButton;
    rbMedian: TRadioButton;
    rbTrimean: TRadioButton;
    SVGIconVirtualImageList1: TSVGIconVirtualImageList;
    procedure bbDefineClick(Sender: TObject);
    procedure bbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbPrinterSetupClick(Sender: TObject);
    procedure bbShowDataClick(Sender: TObject);
    procedure bbShowMovAvClick(Sender: TObject);
    procedure sbImportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbMovAvClick(Sender: TObject);
    procedure pcMovAvChange(Sender: TObject);
    procedure bbPrintGraphClick(Sender: TObject);
  private
    { Private declarations }
    ChosenAverage : string;
  public
    { Public declarations }
    function CalcMean(iStart,iEnd : integer) : double;
    function CalcMedian(iStart,iEnd : integer) : double;
    function CalcTrimean(iStart,iEnd : integer) : double;
    procedure Sort ( var A   : ArrayD; up, lo   : integer);
    procedure Hinges (    A   : ArrayD;
                      var HL  : double;
                      var HU  : double;
                          N   : integer);
  end;

var
  fmMovAv: TfmMovAv;

implementation

uses
  TC_dm, TC_ShtIm2;
{$R *.DFM}



procedure TfmMovAv.bbDefineClick(Sender: TObject);
var
  i, ii, j, k : integer;
  XX, YY, WW, Xt : double;
  SumY, SumX, SumY2 : double;
  XMean, YMean, WStd : double;
  ECode : integer;
  tmpAnyStr1,tmpAnyStr : string;
  SkipCheck : boolean;
  iPtIncDiv2, iRange : integer;
begin
  WStd := 0.0;
  if rbMean.Checked then ChosenAverage := 'Mean';
  if rbMedian.Checked then ChosenAverage := 'Median';
  if rbTrimean.Checked then ChosenAverage := 'Trimean';
  sbMovAv.Panels[0].Text := '';
  sbMovAv.Panels[1].Text := '';
  sbMovAv.Panels[2].Text := '';
  sbMovAv.Panels[3].Text := '';
  sbMovAv.Refresh;
  //ShowMessage('0a');
  WMultString := UpperCase(WMultStr.Text);
  WConstString := UpperCase(WConstStr.Text);
  PointIncrementString := UpperCase(PointIncrementStr.Text);
  MovAvAgeIncrementString := UpperCase(MovAvAgeIncrementStr.Text);
  AgeFromStr := UpperCase(eFromAge.Text);
  AgeToStr := UpperCase(eToAge.Text);
  Val(AgeFromStr,FromAge,ECode);
  Val(AgeToStr,ToAge,ECode);
  sbMovAv.Panels[0].Text := 'Emptying data tables';
  sbMovAv.Refresh;
  //ShowMessage('0b');
  dmSea.cdsSeaRaw.DisableControls;
  dmSea.cdsMovAv.DisableControls;
  try
    dmSea.cdsMovAv.EmptyDataSet;
    dmSea.cdsMovAv.Last;
    repeat
      dmSea.cdsMovAv.Delete;
    until dmSea.cdsMovAv.Bof;
  except
  end;
  sbMovAv.Panels[0].Text := ' ';
  sbMovAv.Refresh;
  SkipCheck := true;
  Fillchar(X, SizeOf(X), 0);
  Fillchar(Y, SizeOf(Y), 0);
  Fillchar(W, SizeOf(W), 0);
  //Fillchar(Yt, SizeOf(Yt), 0);
  Val(WMultStr.Text,WMult,ECode);
  Val(WConstStr.Text,WConst,ECode);
  Val(PointIncrementStr.Text,PointIncrement,ECode);
  Val(MovAvAgeIncrementStr.Text,MovAvAgeIncrement,ECode);
  //ShowMessage('0c');
  if ((PointIncrement mod 2) = 0) then
  begin
    PointIncrement := PointIncrement + 1;
    PointIncrementStr.Text := IntToStr(PointIncrement);
  end;
  DBChart1.Title.Text.Clear;
  DBChart1.Title.Text.Add('Moving '+ ChosenAverage + ' (' + IntToStr(PointIncrement) + ' point)');
  DBChart1.Title.Visible := true;
  iPtIncDiv2 := PointIncrement div 2;
  //ShowMessage('0d');
  dmSea.cdsSeaRaw.Close;
  dmSea.cdsSeaRaw.Open;
  //ShowMessage('0e');
  dmSea.cdsMovAv.Close;
  dmSea.cdsMovAv.Open;
  //ShowMessage('0f');
  //ShowMessage('WConst = '+FormatFloat('#####0.00000',WConst));
  //ShowMessage('WStd = '+FormatFloat('#####0.00000',WStd));
  if (WStd < WConst) then WStd:=WConst;
  sbMovAv.Panels[0].Text := 'Calculating curve';
  sbMovAv.Refresh;
  if (dmSea.cdsSeaRaw.RecordCount < 1) then MessageDlg('No data in table',mtWarning,[mbOK],0);
  ii := 1;
  dmSea.cdsSeaRaw.First;
  repeat
    X[ii] := dmSea.cdsSeaRawAge.AsFloat;
    Y[ii] := dmSea.cdsSeaRawRatio.AsFloat;
    dmSea.cdsSeaRaw.Next;
    ii := ii + 1;
  until ((dmSea.cdsSeaRaw.EOF) or (ii > NMax));
  ii := ii - 1;
  SumX := 0.0;
  SumY := 0.0;
  i := 1;
  //ShowMessage('1');
  for i := 1 to ii do
  begin
    if (i = 1) then
    begin
      YY := Y[i];
    end;
    if (i = ii) then
    begin
      YY := Y[i];
    end;
    if ((i >= iPtIncDiv2+1) and (i <= ii-iPtIncDiv2-1)) then
    begin
      if (ChosenAverage = 'Mean') then YY := CalcMean(i-iPtIncDiv2,i+iPtIncDiv2);
      if (ChosenAverage = 'Median') then YY := CalcMedian(i-iPtIncDiv2,i+iPtIncDiv2);
      if (ChosenAverage = 'Trimean') then YY := CalcTrimean(i-iPtIncDiv2,i+iPtIncDiv2);
    end else
    begin
      if (i < PointIncrement) then
      begin
        iRange := i - 1;
        if (ChosenAverage = 'Mean') then YY := CalcMean(i-iRange,i+iRange);
        if (ChosenAverage = 'Median') then YY := CalcMedian(i-iRange,i+iRange);
        if (ChosenAverage = 'Trimean') then YY := CalcTrimean(i-iRange,i+iRange);
      end;
      if (i > PointIncrement) then
      begin
        iRange := ii - i;
        if (ChosenAverage = 'Mean') then YY := CalcMean(i-iRange,i+iRange);
        if (ChosenAverage = 'Median') then YY := CalcMedian(i-iRange,i+iRange);
        if (ChosenAverage = 'Trimean') then YY := CalcTrimean(i-iRange,i+iRange);
      end;
    end;
    dmSea.cdsMovAv.Append;
    dmSea.cdsMovAvAge.AsFloat := X[i];
    dmSea.cdsMovAvRatio.AsFloat := YY;
    dmSea.cdsMovAv.Post;
  end;
  //ShowMessage('2');
  dmSea.cdsMovAv.IndexFieldNames := 'Age';
  dmSea.cdsSeaRaw.EnableControls;
  dmSea.cdsMovAv.EnableControls;
  dmSea.cdsSeaRaw.First;
  dmSea.cdsMovAv.First;
  sbMovAv.Panels[0].Text := 'All completed';
  sbMovAv.Panels[1].Text := '';
  sbMovAv.Panels[2].Text := '';
  sbMovAv.Panels[3].Text := '';
  sbMovAv.Refresh;
  with dmSea do
  begin
    cdsSeaRaw.Close;
    cdsMovAv.Close;
    cdsSeaRaw.Open;
    cdsMovAv.Open;
  end;
  tCount := dmSea.cdsMovAv.RecordCount;
  pcMovAv.ActivePage := tsGraph;
  bbPrintGraph.Enabled := true;
end;

function TfmMovAv.CalcMean(iStart,iEnd : integer) : double;
var
  SumY : double;
  i : integer;
begin
  // routine to calculate mean Y value for a range of points in a time series
  if (iEnd-iStart > 0) then
  begin
    //if (iEnd < 9) then ShowMessage(IntToStr(iStart)+'  '+IntToStr(iEnd));
    SumY := 0.0;
    for i := iStart to iEnd do
    begin
      SumY := SumY + Y[i];
    end;
    Result := SumY/(1.0*(iEnd-iStart+1));
  end else
  begin
    Result := Y[iStart];
  end;
end;

function TfmMovAv.CalcMedian(iStart,iEnd : integer) : double;
var
  i, j, ml : integer;
  Yt : ArrayD;
begin
  // routine to calculate median Y value for a range of points in a time series
  if (iEnd-iStart > 0) then
  begin
    //if (iEnd < 9) then ShowMessage(IntToStr(iStart)+'  '+IntToStr(iEnd));
    Fillchar(Yt, SizeOf(Yt), 0);
    j := 0;
    for i := iStart to iEnd do
    begin
      j := j + 1;
      Yt[j] := Y[i];
    end;
    Sort(Yt,j,1);
    ml := (j+1) div 2;
    {calculate the median}
    Result := 0.5*(Yt[ml] + Yt[j-ml+1]);
  end else
  begin
    Result := Y[iStart];
  end;
end;

function TfmMovAv.CalcTrimean(iStart,iEnd : integer) : double;
var
  i, j, ml : integer;
  Yt : ArrayD;
  XMed, UH, LH : double;
begin
  // routine to calculate median Y value for a range of points in a time series
  if (iEnd-iStart > 0) then
  begin
    //if (iEnd < 9) then ShowMessage(IntToStr(iStart)+'  '+IntToStr(iEnd));
    Fillchar(Yt, SizeOf(Yt), 0);
    j := 0;
    for i := iStart to iEnd do
    begin
      j := j + 1;
      Yt[j] := Y[i];
    end;
    Sort(Yt,j,1);
    ml := (j+1) div 2;
    {calculate the trimean}
    XMed := 0.5*(Yt[ml] + Yt[j-ml+1]);
    Hinges(Yt,LH,UH,j);
    Result := 0.5*XMed + 0.25*LH + 0.25*UH;
  end else
  begin
    Result := Y[iStart];
  end;
end;

procedure TfmMovAv.Sort ( var A   : ArrayD;
                         up, lo   : integer);
{shellsort routine}
var
  i, j : integer;
  d : integer;
  tempr : double;
begin
  d := up - lo + 1;
  while (d > 1) do
  begin
    if (d < 5) then d := 1
               else d := trunc(0.45454 * d);
    {do linear insertion sort in steps size d}
    for i := up-d downto lo do
    begin
      tempr := A[i];
      j := i+d;
      while (j <= up) do
      begin
        if tempr > A[j] then
        begin
          A[j-d] := A[j];
          j := j+d
        end else
        begin
          Break;
        end;
        A[j-d] := tempr;
      end;
    end;
  end;
end;

procedure TfmMovAv.Hinges   (    A   : ArrayD;
                             var HL  : double;
                             var HU  : double;
                                 N   : integer);
var
  il : integer;
begin
  il := (N+3) div 4;
  HL := 1.0*A[il];
  HU := 1.0*A[N-il+1];
  if (N mod 4 = 0) then
  begin
    HL := 0.5 * (HL + A[il+1]);
    HU := 0.5 * (HU + A[N-il]);
  end;
end;

procedure TfmMovAv.bbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMovAv.FormShow(Sender: TObject);
var
  CanProceed : boolean;
begin
  pcMovAv.ActivePage := tsDefine;
  tsDefine.TabVisible := true;
  tsGraph.TabVisible := true;
  tsData.TabVisible := true;
  DBChart1.Series[0].Clear;
  DBChart1.Series[1].Clear;
  DBChart1.Series[0].XValues.Order := loNone;
  DBChart1.Series[0].YValues.Order := loNone;
  DBChart1.Series[1].XValues.Order := loNone;
  DBChart1.Series[1].YValues.Order := loNone;
  dmSea.cdsSeaRaw.Active := false;
  dmSea.cdsMovAv.Active := false;
  PointIncrementStr.Text := PointIncrementString;
  WMultStr.Text := WMultString;
  WConstStr.Text := WConstString;
  CurveAdjustBy := 0.0;
  MovAvAgeIncrementStr.Text := MovAvAgeIncrementString;
  eFromAge.Text := AgeFromStr;
  eToAge.Text := AgeToStr;
  sbMovAv.Panels[0].Text := 'Prepare Moving Average Curve';
  sbMovAv.Refresh;
  with dmSea do
  begin
    cdsSeaRaw.FileName := cdsPath+'SeaRaw.cds';
    //ShowMessage('tc_movav_'+'1_'+cdsSeaRaw.FileName);
    if not FileExists(cdsSeaRaw.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaRaw.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'SeaRaw.cds',mtInformation,[mbOK],0);
      }
    end;
    CanProceed := true;
    cdsMovAv.FileName := cdsPath+'MovAv.cds';
    //ShowMessage('tc_movav_'+'2_'+cdsMovAv.FileName);
    if not FileExists(cdsMovAv.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'MovAv.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'MovAv.cds',mtInformation,[mbOK],0);
      }
    end;
    //ShowMessage('tc_movav '+'3');
    if CanProceed then
    begin
      try
        //ShowMessage('tc_movav_'+'3a_'+cdsPath+'SeaRaw.cds');
        //cdsSeaRaw.LogChanges := false;
        cdsSeaRaw.LoadFromFile(cdsPath+'SeaRaw.cds');
        cdsSeaRaw.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaRaw.cds',mtWarning,[mbOK],0);
      end;
      try
        //cdsMovAv.LogChanges := false;
        cdsMovAv.LoadFromFile(cdsPath+'MovAv.cds');
        cdsMovAv.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'MovAv.cds',mtWarning,[mbOK],0);
      end;
    end else
    begin
      Close;
    end;
  end;
  pcMovAv.ActivePage := tsDefine;
  //ShowMessage('tc_movav '+'4');
end;


procedure TfmMovAv.sbPrinterSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TfmMovAv.bbShowDataClick(Sender: TObject);
begin
  if (DBChart1.Series[0].Active) then
  begin
    DBChart1.Series[0].Active := false;
    bbShowData.Caption := 'Show data';
  end else
  begin
    DBChart1.Series[0].Active := true;
    bbShowData.Caption := 'Hide data';
  end;
end;

procedure TfmMovAv.bbShowMovAvClick(Sender: TObject);
begin
  if (DBChart1.Series[1].Active) then
  begin
    DBChart1.Series[1].Active := false;
    bbShowMovAv.Caption := 'Show mov. av.';
  end else
  begin
    DBChart1.Series[1].Active := true;
    bbShowMovAv.Caption := 'Hide mov. av.';
  end;
end;

procedure TfmMovAv.sbImportClick(Sender: TObject);
var
  ImportForm : TfmSheetImport;
  CanProceed : boolean;
begin
  try
    ImportForm := TfmSheetImport.Create(Self);
    //ImportForm.Left := SheetLeft;
    //ImportForm.Top := SheetTop;
    //ImportForm.Height := SheetHeight;
    //ImportForm.Width := SheetWidth;
    ImportForm.OpenDialogSprdSheet.FileName := 'MovAv';
    ImportForm.OpenDialogSprdSheet.InitialDir := ImportPath;
    ImportForm.ShowModal;
    if (ImportForm.ModalResult = mrClose) then
    begin
      CanProceed := true;
      SheetLeft := ImportForm.Left;
      SheetTop := ImportForm.Top;
      SheetHeight := ImportForm.Height;
      SheetWidth := ImportForm.Width;
    end;
  finally
    ImportForm.Free;
  end;
  NSplTot := 2*dmSea.cdsSeaRaw.RecordCount;
  if (NSplTot < 1) then NSplTot := NSplMax;
end;

procedure TfmMovAv.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  with dmSea do
  begin
    try
      cdsSeaRaw.SaveToFile(cdsPath+'SeaRaw.cds');
    except
    end;
    try
      cdsMovAv.SaveToFile(cdsPath+'MovAv.cds');
    except
    end;
  end;
end;

procedure TfmMovAv.bbMovAvClick(Sender: TObject);
begin
  dbgMovAv.DataSource := dmSea.dsMovAv;
  dbnMovAv.DataSource := dmSea.dsMovAv;
  eCountMovAv.Text := IntToStr(dmSea.cdsMovAv.RecordCount);
end;

procedure TfmMovAv.pcMovAvChange(Sender: TObject);
begin
  if not (pcMovAv.ActivePage = tsData) then
  begin
    dbgMovAv.DataSource := nil;
    dbnMovAv.DataSource := nil;
    eCountMovAv.Text := '';
  end;
  if (pcMovAv.ActivePage = tsGraph) then
  begin
    bbPrintGraph.Enabled := true;
  end else
  begin
    bbPrintGraph.Enabled := false;
  end;
end;

procedure TfmMovAv.bbPrintGraphClick(Sender: TObject);
begin
  DBChart1.PrintLandscape;
end;

end.

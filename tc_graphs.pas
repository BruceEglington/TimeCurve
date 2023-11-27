unit tc_graphs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  Printers, Mask, DBCtrls, ActnList, Series, TeEngine, TeeProcs, Chart,
  DbChart, Mar_def, VclTee.TeeGDIPlus, System.Actions, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, SVGIconVirtualImageList;

type
  TfmGraphs = class(TForm)
    Panel5: TPanel;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ActionList1: TActionList;
    sbSpline: TStatusBar;
    pcSpline: TPageControl;
    tsGraph: TTabSheet;
    DBChart1: TDBChart;
    Series1: TPointSeries;
    Series2: TLineSeries;
    Series4: TLineSeries;
    Panel3: TPanel;
    bbShowData: TBitBtn;
    bbShowSpline: TBitBtn;
    bbShowMovAv: TBitBtn;
    bbClose: TBitBtn;
    bbPrinterSetup: TBitBtn;
    tsData: TTabSheet;
    Panel4: TPanel;
    Panel6: TPanel;
    dbnSeaRawAv: TDBNavigator;
    bbSeaRawAv: TBitBtn;
    Panel7: TPanel;
    Panel8: TPanel;
    dbgSeaRawAv: TDBGrid;
    Splitter1: TSplitter;
    Panel9: TPanel;
    dbnSeaSpl: TDBNavigator;
    Panel10: TPanel;
    bbSeaSpl: TBitBtn;
    Panel11: TPanel;
    dbgSeaSpl: TDBGrid;
    Panel12: TPanel;
    Splitter2: TSplitter;
    Panel13: TPanel;
    dbnSeaSplP: TDBNavigator;
    Panel14: TPanel;
    bbSeaSplP: TBitBtn;
    Panel15: TPanel;
    dbgSeaSplP: TDBGrid;
    bbPrintGraph: TBitBtn;
    eCountRawDataAv: TEdit;
    eCountSpline: TEdit;
    eCountSplineP: TEdit;
    tsYPrime: TTabSheet;
    DBChart2: TDBChart;
    LineSeries1: TLineSeries;
    SVGIconVirtualImageList1: TSVGIconVirtualImageList;
    procedure bbCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbPrinterSetupClick(Sender: TObject);
    procedure bbShowDataClick(Sender: TObject);
    procedure bbShowSplineClick(Sender: TObject);
    procedure bbShowMovAvClick(Sender: TObject);
    procedure pcSplineChange(Sender: TObject);
    procedure bbPrintGraphClick(Sender: TObject);
    procedure bbSeaRawAvClick(Sender: TObject);
    procedure bbSeaSplClick(Sender: TObject);
    procedure bbSeaSplPClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmGraphs: TfmGraphs;

implementation

uses
  TC_dm;
{$R *.DFM}


procedure TfmGraphs.bbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmGraphs.FormShow(Sender: TObject);
var
  CanProceed : boolean;
begin
  DBChart1.Series[0].Clear;
  DBChart1.Series[1].Clear;
  DBChart1.Series[2].Clear;
  DBChart1.Series[0].XValues.Order := loNone;
  DBChart1.Series[0].YValues.Order := loNone;
  DBChart1.Series[1].XValues.Order := loNone;
  DBChart1.Series[1].YValues.Order := loNone;
  DBChart1.Series[2].XValues.Order := loNone;
  DBChart1.Series[2].YValues.Order := loNone;
  DBChart2.Series[0].Clear;
  DBChart2.Series[0].XValues.Order := loNone;
  DBChart2.Series[0].YValues.Order := loNone;
  dmSea.cdsSeaRaw.Active := false;
  dmSea.cdsSeaSpl.Active := false;
  dmSea.cdsMovAv.Active := false;
  with dmSea do
  begin
    cdsSeaRaw.FileName := cdsPath+'SeaRaw.cds';
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
    cdsSeaSpl.FileName := cdsPath+'SeaSpl.cds';
    if not FileExists(cdsSeaSpl.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaSpl.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      {
      MessageDlg('Found - '+cdsPath+'SeaSpl.cds',mtInformation,[mbOK],0);
      }
    end;
    if CanProceed then
    begin
      try
        cdsSeaRaw.LoadFromFile(cdsPath+'SeaRaw.cds');
        cdsSeaRaw.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaRaw.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsMovAv.LoadFromFile(cdsPath+'MovAv.cds');
        cdsMovAv.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'MovAv.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSpl.LoadFromFile(cdsPath+'SeaSpl.cds');
        cdsSeaSpl.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaSpl.cds',mtWarning,[mbOK],0);
      end;
    end else
    begin
      Close;
    end;
  end;
  pcSpline.ActivePage := tsGraph;
  bbPrintGraph.Enabled := true;
end;


procedure TfmGraphs.sbPrinterSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TfmGraphs.bbSeaRawAvClick(Sender: TObject);
begin
  dmSea.cdsSeaRawAv.Open;
  dbgSeaRawAv.DataSource := dmSea.dsSeaRawAv;
  dbnSeaRawAv.DataSource := dmSea.dsSeaRawAv;
  eCountRawDataAv.Text := IntToStr(dmSea.cdsSeaRawAv.RecordCount);
end;

procedure TfmGraphs.bbSeaSplClick(Sender: TObject);
begin
  dmSea.cdsSeaSpl.Open;
  dbgSeaSpl.DataSource := dmSea.dsSeaSpl;
  dbnSeaSpl.DataSource := dmSea.dsSeaSpl;
  eCountSpline.Text := IntToStr(dmSea.cdsSeaSpl.RecordCount);
end;

procedure TfmGraphs.bbSeaSplPClick(Sender: TObject);
begin
  dmSea.cdsSeaSplP.Open;
  dbgSeaSplP.DataSource := dmSea.dsSeaSplP;
  dbnSeaSplP.DataSource := dmSea.dsSeaSplP;
  eCountSplineP.Text := IntToStr(dmSea.cdsSeaSplP.RecordCount);
end;

procedure TfmGraphs.bbShowDataClick(Sender: TObject);
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

procedure TfmGraphs.bbShowSplineClick(Sender: TObject);
begin
  if (DBChart1.Series[1].Active) then
  begin
    DBChart1.Series[1].Active := false;
    bbShowSpline.Caption := 'Show spline';
  end else
  begin
    DBChart1.Series[1].Active := true;
    bbShowSpline.Caption := 'Hide spline';
  end;
end;

procedure TfmGraphs.bbShowMovAvClick(Sender: TObject);
begin
  if (DBChart1.Series[2].Active) then
  begin
    DBChart1.Series[2].Active := false;
    bbShowMovAv.Caption := 'Show Mov.Av.';
  end else
  begin
    DBChart1.Series[2].Active := true;
    bbShowMovAv.Caption := 'Hide Mov.Av.';
  end;
end;

procedure TfmGraphs.pcSplineChange(Sender: TObject);
begin
  if not (pcSpline.ActivePage = tsData) then
  begin
    dbgSeaRawAv.DataSource := nil;
    dbnSeaRawAv.DataSource := nil;
    dbgSeaSpl.DataSource := nil;
    dbnSeaSpl.DataSource := nil;
    dbgSeaSplP.DataSource := nil;
    dbnSeaSplP.DataSource := nil;
    eCountRawDataAv.Text := '';
    eCountSpline.Text := '';
    eCountSplineP.Text := '';
  end;
  if ((pcSpline.ActivePage = tsGraph) or (pcSpline.ActivePage = tsYPrime)) then
  begin
    bbPrintGraph.Enabled := true;
  end else
  begin
    bbPrintGraph.Enabled := false;
  end;
end;

procedure TfmGraphs.bbPrintGraphClick(Sender: TObject);
begin
  if (pcSpline.ActivePage = tsGraph) then DBChart1.PrintLandscape;
  if (pcSpline.ActivePage = tsYPrime) then DBChart2.PrintLandscape;
end;

end.

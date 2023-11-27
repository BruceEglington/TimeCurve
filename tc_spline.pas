unit tc_spline;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  Printers, Mask, DBCtrls, ActnList, Series, TeEngine, TeeProcs, Chart,
  DbChart, Mar_def, VclTee.TeeGDIPlus, System.Actions, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, SVGIconVirtualImageList;

type
  TfmSplineFit = class(TForm)
    GroupBox4: TGroupBox;
    Panel5: TPanel;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ActionList1: TActionList;
    sbSpline: TStatusBar;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SStr: TEdit;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    WMultStr: TEdit;
    WConstStr: TEdit;
    AgeIncrementStr: TEdit;
    pcSpline: TPageControl;
    tsDefine: TTabSheet;
    tsGraph: TTabSheet;
    cbIncreaseStdDev: TCheckBox;
    DBChart1: TDBChart;
    Series1: TPointSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    dbgSeaRaw: TDBGrid;
    tsSpline: TTabSheet;
    GroupBox1: TGroupBox;
    DBGrid4: TDBGrid;
    GroupBox2: TGroupBox;
    cbDoRawAverages: TCheckBox;
    cbSpline: TCheckBox;
    cbSplineP: TCheckBox;
    cbSplineM: TCheckBox;
    Panel3: TPanel;
    bbShowData: TBitBtn;
    bbShowSpline: TBitBtn;
    bbShowSplineP: TBitBtn;
    bbShowSplineM: TBitBtn;
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
    Series5: TPointSeries;
    bbShowDataAv: TBitBtn;
    bbPrintGraph: TBitBtn;
    DBNavigator1: TDBNavigator;
    Panel16: TPanel;
    eCountRawDataAv: TEdit;
    eCountSpline: TEdit;
    eCountSplineP: TEdit;
    tsYPrime: TTabSheet;
    DBChart2: TDBChart;
    LineSeries1: TLineSeries;
    Label8: TLabel;
    eNSpl: TEdit;
    cbLogAxis: TCheckBox;
    Label9: TLabel;
    eMin: TEdit;
    Label10: TLabel;
    eMax: TEdit;
    cbAutoAxis: TCheckBox;
    tsTimeStep: TTabSheet;
    DBChart3: TDBChart;
    LineSeries2: TLineSeries;
    Splitter3: TSplitter;
    Panel17: TPanel;
    Panel18: TPanel;
    bbShowIncrements: TBitBtn;
    eCountIncrements: TEdit;
    Panel19: TPanel;
    dbnIncrements: TDBNavigator;
    dbgIncrements: TDBGrid;
    SVGIconVirtualImageList1: TSVGIconVirtualImageList;
    procedure bbDefineClick(Sender: TObject);
    procedure bbCloseClick(Sender: TObject);
    procedure cbIncreaseStdDevClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbPrinterSetupClick(Sender: TObject);
    procedure bbShowDataClick(Sender: TObject);
    procedure bbShowSplineClick(Sender: TObject);
    procedure bbShowSplinePClick(Sender: TObject);
    procedure bbShowSplineMClick(Sender: TObject);
    procedure sbImportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbSeaRawAvClick(Sender: TObject);
    procedure pcSplineChange(Sender: TObject);
    procedure bbSeaSplClick(Sender: TObject);
    procedure bbSeaSplPClick(Sender: TObject);
    procedure bbShowDataAvClick(Sender: TObject);
    procedure bbPrintGraphClick(Sender: TObject);
    procedure bbChangeClick(Sender: TObject);
    procedure bbShowIncrementsClick(Sender: TObject);
  private
    { Private declarations }
    procedure SplineSmooth ( XVal : RealArray50;
                         YVal : RealArray50;
                         WVal : RealArray50;
                         TotalN           : integer;
                         S                : double;
                         DoAdjust         : boolean;
                         var AdjustBy     : double);
  public
    { Public declarations }
  end;

var
  fmSplineFit: TfmSplineFit;

implementation

uses
  TC_dm, TC_ShtIm2;
{$R *.DFM}


procedure TfmSplineFit.SplineSmooth ( XVal : RealArray50;
                         YVal : RealArray50;
                         WVal : RealArray50;
                         TotalN           : integer;
                         S                : double;
                         DoAdjust         : boolean;
                         var AdjustBy     : double);
label
   3640, 4000;
var
  Q, P, H, F,
  F2, G, E       : double;
  i,j,k,Dint,
  Iteration,
  Pointers,
  SplCalc,
  NSpl           : integer;
  iter           : integer;
  tmpAnyStr, tmpAnyStr1      : string;
  Lst : textfile;
  Sum1, Sum2, Sum3,
  txsmax,
  tx, ty, tys, tw, MSWD : double;
  strtys : string;
  iCode : integer;
begin
  Pointers:=0;
  Q:=1.0*TotalN*S*S;
  R[0]:=0.0;
  R[1]:=0.0;
  U[0]:=0.0;
  U[1]:=0.0;
  U[TotalN]:=0.0;
  U[TotalN+1]:=0.0;
  R1[TotalN]:=0.0;
  R2[TotalN]:=0.0;
  R2[TotalN+1]:=0.0;
  P:=0.0;
  H:=XVal[2]-XVal[1]-0.0000001;
  G := H;
  F:=(YVal[2]-YVal[1])/H;
  for i:=2 to TotalN-1 do
  begin
    G:=H;
    H:=XVal[i+1]-XVal[i]-0.0000001;
    E:=F;
    F:=(YVal[i+1]-YVal[i])/H;
    A[i]:=F-E;
    T[i]:=2.0*(G+H)/3.0;
    T1[i]:=H/3.0;
    R2[i]:=WVal[i-1]/G;
    R[i]:=WVal[i+1]/H;
    R1[i]:=-1.0*WVal[i]/G-WVal[i]/H;
  end;
  sbSpline.Panels[1].Text := '1st loop';
  sbSpline.Refresh;
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  for i:=2 to TotalN-1 do     //TotalN-1
  begin
    {
    fmSplineFit.ProgressBar1.StepIt;
    }
    B[i]:=R[i]*R[i] + R1[i]*R1[i] + R2[i]*R2[i];
    C[i]:=R[i]*R1[i+1] + R1[i]*R2[i+1];
    D[i]:=R[i]*R2[i+2];
  end;
  F2:=-1.0*Q;
  sbSpline.Panels[1].Text := '2nd loop';
  sbSpline.Refresh;
  Iteration:=0;
3640:
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  for i:=2 to TotalN-1 do     //TotalN-1
  begin
    R1[i-1]:=F*R[i-1];
    R2[i-2]:=G*R[i-2];
    R[i]:=(P*B[i] + T[i] - F*R1[i-1] - G*R2[i-2]);
    if R[i]=0.0
      then  R[i]:=1e-10
      else  R[i]:=1.0/R[i];
    U[i]:=A[i] - R1[i-1]*U[i-1] - R2[i-2]*U[i-2];
    F:=P*C[i] + T1[i] - H*R1[i-1];
    G:=H;
    H:=D[i]*P;
  end;
  i:=TotalN-1;
  sbSpline.Panels[1].Text := '3rd loop';
  sbSpline.Refresh;
  repeat
    U[i]:=R[i]*U[i] - R1[i]*U[i+1] - R2[i]*U[i+2];
    i:=i-1;
  until (i < 2);
  sbSpline.Panels[1].Text := '4th loop';
  sbSpline.Refresh;
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  E:=0.0;
  H:=0.0;
  for i:=1 to TotalN-1 do  //TotalN-1
  begin
    G:=H;
    H:=(U[i+1]-U[i])/(XVal[i+1]-XVal[i]-0.0000001);
    V[i]:=(H-G)*WVal[i]*WVal[i];
    E:=E + V[i]*(H-G);
  end;
  sbSpline.Panels[1].Text := '5th loop';
  sbSpline.Refresh;
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  G:=-H*WVal[TotalN]*WVal[TotalN];   {SplTln}
  V[TotalN]:=G;
  E:=E-G*H;
  G:=F2;
  F2:=E*P*P;
  if ((F2 >= Q) or (F2 <= G)) then goto 4000;
    F:=0.0;
    H:=(V[2]-V[1])/(XVal[2]-XVal[1]-0.0000001);
    for i:=2 to TotalN-1 do
    begin
      G:=H;
      H:=(V[i+1]-V[i])/(XVal[i+1]-XVal[i]-0.0000001);
      G:=H - G - R1[i-1]*R[i-1] - R2[i-2]*R[i-2];
      F:=F + G*R[i]*G;
      R[i]:=G;
    end;
    sbSpline.Panels[1].Text := '6th loop';
    sbSpline.Refresh;
    {
    fmSplineFit.ProgressBar1.StepIt;
    }
    H:=E-P*F;
    if (H <= 0.0) then goto 4000;
      P:=P+(Q-F2)/((Sqrt(Q/E)+P)*H);
      Iteration:=Iteration+1;
  goto 3640;
4000:
  for i:=1 to TotalN do
  begin
    A[i]:=YVal[i] - P*V[i];
    C[i]:=U[i];
  end;
  sbSpline.Panels[1].Text := '7th loop';
  sbSpline.Refresh;
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  for i:=1 to TotalN-1 do    //TotalN-1
  begin
    H:=XVal[I+1]-XVal[i]-0.0000001;
    D[i]:=(C[i+1] - C[i]) / (3.0*H);
    B[i]:=(A[i+1] - A[i])/H - (H*D[i] + C[i])*H;
  end;
  sbSpline.Panels[1].Text := '8th loop';
  sbSpline.Refresh;
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  Dint:=NSplTot div (TotalN);
  k:=0;
  dmSea.cdsSeaSpl.DisableControls;
  dmSea.cdsSeaSplM.DisableControls;
  dmSea.cdsSeaSplP.DisableControls;
  try
    for i:=1 to TotalN-1 do             //TotalN-1
    begin
      E:=XVal[i+1]-XVal[i]-0.0000001;
      for j:=0 to Dint-1 do
      begin
        k:=k+1;
        H:=1.0*j*E/Dint;
        XSplt:=XVal[i]+H;
        YSplt:=(A[i]+H*(B[i]+H*(C[i]+H*D[i])));
        YPrime:=(B[i]+2.0*H*C[i]+3.0*H*H*D[i])*10000.0;
        if ((i = 1) and (j = 0)) then
        begin
          if ((DoAdjust = false)) then AdjustBy := 1.0;
          {
          if (YSplt <= 0.0) then YSplt := PresentSeaRatio;
          }
          if ((DoAdjust = true) and (AdjustBy = 0.0) and (YSplt > 0.0))
             then AdjustBy := PresentSeaRatio/YSplt;
          {
          At(23,1); Write('Adjust curve by ',AdjustBy:8:6);
          }
        end;
        {
        Writeln(SplineDataFile,(XSplt):13:4,(AdjustBy*YSplt):13:6,
                               WMult*WConst:13:6,(YPrime):13:6,S:8:4);
        At(24,76); Write(k:3);
        }
        if (CurveToFit = 'SeaSpl') then
        begin
          dmSea.cdsSeaSpl.Append;
          dmSea.cdsSeaSplAge.AsFloat := XSplt;
          dmSea.cdsSeaSplRatio.AsFloat := AdjustBy*YSplt;
          dmSea.cdsSeaSplError.AsFloat := WMult*WConst;
          dmSea.cdsSeaSplYPrime.AsFloat := YPrime;
          dmSea.cdsSeaSplS.AsFloat := S;
          dmSea.cdsSeaSpl.Post;
          dmSea.cdsSeaSpl.Next;
        end;
        if (CurveToFit = 'SeaSplP') then
        begin
          dmSea.cdsSeaSplP.Append;
          dmSea.cdsSeaSplPAge.AsFloat := XSplt;
          dmSea.cdsSeaSplPRatio.AsFloat := AdjustBy*YSplt;
          dmSea.cdsSeaSplPError.AsFloat := WMult*WConst;
          dmSea.cdsSeaSplPYPrime.AsFloat := YPrime;
          dmSea.cdsSeaSplPS.AsFloat := S;
          dmSea.cdsSeaSplP.Post;
          dmSea.cdsSeaSplP.Next;
        end;
        if (CurveToFit = 'SeaSplM') then
        begin
          dmSea.cdsSeaSplM.Append;
          dmSea.cdsSeaSplMAge.AsFloat := XSplt;
          dmSea.cdsSeaSplMRatio.AsFloat := AdjustBy*YSplt;
          dmSea.cdsSeaSplMError.AsFloat := WMult*WConst;
          dmSea.cdsSeaSplMYPrime.AsFloat := YPrime;
          dmSea.cdsSeaSplMS.AsFloat := S;
          dmSea.cdsSeaSplM.Post;
          dmSea.cdsSeaSplM.Next;
        end;
      end;
      Pointers:=Pointers+Iteration+1;
    end;
    if (CurveToFit = 'SeaSpl') then
    begin
      sbSpline.Panels[1].Text := 'Calc. MSWD';
      sbSpline.Refresh;
      MSWD := 0.0;
      i := 0;
      Sum1 := 0.0;
      Sum2 := 0.0;
      Sum3 := 0.0;
      dmSea.cdsSeaRawAv.First;
      {
      dmSea.cdsSeaSpl.First;
      repeat
        i := i + 1;
        if (i < 5) then
        begin
          tx := dmSea.cdsSeaSplAge.AsFloat;
          tys := dmSea.cdsSeaSplRatio.AsFloat;
          ShowMessage(IntToStr(i)+'  tx '+FormatFloat('####0.0000',tx)+'  tys '+FormatFloat('####0.0000',tys));
        end;
        dmSea.cdsSeaSpl.Next;
      until dmSea.cdsSeaSpl.Eof;
      i := 0;
      }
      dmSea.cdsSeaSpl.Last;
      txsmax := dmSea.cdsSeaSplAge.AsFloat;
      dmSea.cdsSeaSpl.IndexFieldNames := 'Age';
      repeat
        i := i + 1;
        tx := dmSea.cdsSeaRawAvAge.AsFloat;
        ty := dmSea.cdsSeaRawAvRatio.AsFloat;
        dmSea.cdsSeaSpl.Locate('Age',tx,[loPartialKey]);
        tys := dmSea.cdsSeaSplRatio.AsFloat;
        tw := 1.0/(WVal[i]*WVal[i]);
        tys := ty-tys;
        {
        if (i < 5) then
        begin
          ShowMessage(IntToStr(i)+'  tw '+FormatFloat('####0.0000',tw)+'  diff '+FormatFloat('####0.0000',tys));
        end;
        }
        Sum1 := Sum1 + tw;
        Sum2 := Sum2 + tw*tys;
        Sum3 := Sum3 + tw*tys*tys;
        dmSea.cdsSeaRawAv.Next;
        tx := dmSea.cdsSeaRawAvAge.AsFloat;
      until ((dmSea.cdsSeaRawAv.Eof) or (tx > txsmax));
      //i := dmSea.cdsSeaRawAv.RecordCount;
      //ShowMessage('Sum1 '+FormatFloat('####0.0000',Sum1));
      //ShowMessage('Sum2 '+FormatFloat('####0.0000',Sum2));
      //ShowMessage('Sum3 '+FormatFloat('####0.0000',Sum3));
      if (Sum1 > 0.0) then MSWD := (Sum3-Sum2*Sum2/Sum1)/(1.0*(i-1))
                      else MSWD := -99.999;
      sbSpline.Panels[4].Text := 'MSWD = '+FormatFloat('####0.000',MSWD);
      sbSpline.Panels[2].Text := 'i = '+IntToStr(i);
    end;
  finally
    dmSea.cdsSeaSpl.EnableControls;
    dmSea.cdsSeaSplM.EnableControls;
    dmSea.cdsSeaSplP.EnableControls;
  end;
  sbSpline.Panels[1].Text := 'Complete';
  sbSpline.Refresh;
  {
  fmSplineFit.ProgressBar1.StepIt;
  }
  NSpl:=k+1;
  XSplt:=XVal[TotalN];
  YSplt:=A[TotalN];
end;

procedure TfmSplineFit.bbDefineClick(Sender: TObject);
var
  ii, j, k : integer;
  XX, YY, WW, Xt : double;
  Yt : array[1..100] of double;
  SumY, SumX, SumY2 : double;
  XMean, YMean, WStd : double;
  ECode : integer;
  tmpAnyStr1,tmpAnyStr : string;
  SkipCheck : boolean;
begin
  sbSpline.Panels[0].Text := '';
  sbSpline.Panels[1].Text := '';
  sbSpline.Panels[2].Text := '';
  sbSpline.Panels[3].Text := '';
  sbSpline.Refresh;
  WMultString := UpperCase(WMultStr.Text);
  WConstString := UpperCase(WConstStr.Text);
  SString := UpperCase(SStr.Text);
  AgeIncrementString := UpperCase(AgeIncrementStr.Text);
  AgeFromStr := UpperCase(eFromAge.Text);
  AgeToStr := UpperCase(eToAge.Text);
  Val(AgeFromStr,FromAge,ECode);
  Val(AgeToStr,ToAge,ECode);
  Val(eNspl.Text,NSplTot,ECode);
  sbSpline.Panels[0].Text := 'Emptying data tables';
  sbSpline.Refresh;
  if (cbDoRawAverages.Checked) then
  begin
    dmSea.cdsSearawAv.EmptyDataSet;
    dmSea.cdsSeaRaw.DisableControls;
    dmSea.cdsSeaRawAv.DisableControls;
  end;
  if (cbSpline.Checked) then
  begin
    dmSea.cdsSeaSpl.EmptyDataSet;
  end;
  if (cbSplineP.Checked) then
  begin
    dmSea.cdsSeaSplP.EmptyDataSet;
  end;
  if (cbSplineM.Checked) then
  begin
    dmSea.cdsSeaSplM.EmptyDataSet;
  end;
  SkipCheck := true;
  Fillchar(Yt, SizeOf(Yt), 0);
  Val(WMultStr.Text,WMult,ECode);
  Val(WConstStr.Text,WConst,ECode);
  Val(SStr.Text,S,ECode);
  Val(AgeIncrementStr.Text,AgeIncrement,ECode);
  dmSea.cdsSeaRaw.Open;
  {
  repeat
    dmSea.cdsSeaRawAv.Append;
    dmSea.cdsSeaRawAvAge.Value := dmSea.cdsSeaRawAge.Value;
    dmSea.cdsSeaRawAvRatio.Value := dmSea.cdsSeaRawRatio.Value;
    dmSea.cdsSeaRawAvError.Value := dmSea.cdsSeaRawError.Value;
    dmSea.cdsSearawAvN.Value := 1;
    dmSea.cdsSeaRaw.Post;
    dmSea.cdsSeaRaw.Next;
  until dmSea.cdsSeaRaw.EOF;
  }
  dmSea.cdsSeaRawAv.Close;
  dmSea.cdsSeaRawAv.Open;
  if (cbDoRawAverages.Checked) then
  begin
    dbgSeaRaw.DataSource := nil;
    sbSpline.Panels[0].Text := 'Copying and Averaging data';
    sbSpline.Refresh;
    dmSea.cdsSeaRawAv.EmptyDataSet;
    dmSea.cdsSeaRawAv.First;
    {
    if (SeaSpline) then
    begin
      dmSea.cdsSeaRawAv.Append;
      dmSea.cdsSeaRawAvAge.AsFloat := 0.0001;
      dmSea.cdsSeaRawAvRatio.AsFloat := PresentSeaRatio;
      dmSea.cdsSeaRawAvError.AsFloat := WConst;
      dmSea.cdsSeaRawAvN.AsInteger := 1;
      dmSea.cdsSeaRawAv.Next;
    end;
    }
    dmSea.cdsSeaRaw.First;
    XX := dmSea.cdsSeaRawAge.AsFloat;
    YY := dmSea.cdsSeaRawRatio.AsFloat;
    WW := dmSea.cdsSeaRawError.AsFloat;
    SumX:=0.0;
    SumY:=0.0;
    j:=0;
        if not SkipCheck then
        begin
          Str(XX:7:3,tmpAnyStr);
          Str(YY:9:6,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          Str(WW:9:6,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          Str(j:3,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          if MessageDlg(tmpAnyStr,mtInformation,[mbIgnore,mbCancel],0) = mrCancel
          then SkipCheck := true;
        end;
    Xt:=XX;
    Yt[1]:=YY;
    repeat
      XX := dmSea.cdsSeaRawAge.AsFloat;
      YY := dmSea.cdsSeaRawRatio.AsFloat;
      WW := dmSea.cdsSeaRawError.AsFloat;
      if (Abs(XX-Xt) < AgeIncrement) then
      begin
        j:=j + 1;
        Yt[j]:=YY;
        SumX:=SumX + XX;
        SumY:=SumY + YY;
        if not SkipCheck then
        begin
          Str(XX:7:3,tmpAnyStr);
          Str(YY:9:6,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          Str(WW:9:6,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          Str(j:3,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          if MessageDlg(tmpAnyStr,mtInformation,[mbIgnore,mbCancel],0) = mrCancel
          then SkipCheck := true;
        end;
      end else
      begin
        if (j > 1) then
        begin
          if not SkipCheck then
          begin
            Str(SumX:9:3,tmpAnyStr);
            Str(SumY:11:6,tmpAnyStr1);
            tmpAnyStr := tmpAnyStr + tmpAnyStr1;
            Str(j:4,tmpAnyStr1);
            tmpAnyStr := tmpAnyStr + tmpAnyStr1;
            if MessageDlg('Mean '+tmpAnyStr,mtInformation,[mbIgnore,mbCancel],0) = mrCancel
            then SkipCheck := true;
          end;
          XMean:=SumX/(1.0*j);
          YMean:=SumY/(1.0*j);
          SumY2:=0.0;
          for k:=1 to j do
          begin
            SumY2:=SumY2+(Yt[k]-YMean)*(Yt[k]-YMean);
          end;
          if (SumY2 > 0.0) then WStd:=Sqrt(SumY2/(1.0*j-1.0))
                           else WStd:=WConst;
        end else
        begin
          XMean:=Xt;
          YMean:=Yt[1];
          WStd:=WW;
        end;
        if WStd<WConst then WStd:=WConst;
        if (cbIncreaseStdDev.Checked) then
        begin
          ExtraMult := 1.0;
          if ((SeaSpline) and (XMean <= 100.0)) then ExtraMult := 1.0;
          if ((SeaSpline) and (XMean > 100.0)) then ExtraMult := 1.5;
          if ((SeaSpline) and (XMean > 150.0)) then ExtraMult := 3.5;
          if ((SeaSpline) and (XMean > 250.0)) then ExtraMult := 3.0;
          WStd:=WStd*ExtraMult;
        end;
        if not SkipCheck then
        begin
          Str(XMean:7:3,tmpAnyStr);
          Str(YMean:9:6,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          Str(WStd:9:6,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          Str(j:3,tmpAnyStr1);
          tmpAnyStr := tmpAnyStr + tmpAnyStr1;
          if MessageDlg('Mean '+tmpAnyStr,mtInformation,[mbIgnore,mbCancel],0) = mrCancel
          then SkipCheck := true;
        end;
        if ((XMean > FromAge) and (XMean < ToAge)) then
        begin
          dmSea.cdsSeaRawAv.Append;
          dmSea.cdsSeaRawAvAge.AsFloat := XMean;
          dmSea.cdsSeaRawAvRatio.AsFloat := YMean;
          dmSea.cdsSeaRawAvError.AsFloat := WStd;
          dmSea.cdsSeaRawAvN.AsInteger := j;
          dmSea.cdsSeaRawAv.Post;
        end;
        j:=1;
        {
        XMean:=XX;
        YMean:=YY;
        WStd:=WW;
        }
        Xt:=XX;
        SumX:=XX;
        SumY:=YY;
        Yt[1]:=YY;
      end;
      dmSea.cdsSeaRaw.Next;
    until (dmSea.cdsSeaRaw.EOF);
  end;
  dmSea.cdsSeaRaw.First;
  dmSea.cdsSeaRawAv.First;
  sbSpline.Panels[0].Text := 'Reading average data';
  sbSpline.Refresh;
  dbgSeaRaw.DataSource := nil;
  ii:=1;
  dmSea.cdsSeaRawAv.First;
  repeat
    X[ii] := dmSea.cdsSeaRawAvAge.AsFloat;
    Y[ii] := dmSea.cdsSeaRawAvRatio.AsFloat;
    W[ii] := dmSea.cdsSeaRawAvError.AsFloat;
    W1[ii] := W[ii];
    W[ii]:=W[ii]*WMult;
    dmSea.cdsSeaRawAv.Next;
    ii := ii + 1;
  until ((dmSea.cdsSeaRawAv.EOF) or (ii > NMax));
  ii := ii-1;
  if (NsplTot < 2*ii) then NSplTot := 2*ii;
  eNSpl.Text := IntToStr(NSplTot);
  dbgSeaRaw.DataSource := dmSea.dsSeaRaw;
  dmSea.cdsSeaRaw.EnableControls;
  dmSea.cdsSeaRawAv.EnableControls;
  dmSea.cdsSeaSpl.Close;
  dmSea.cdsSeaSpl.Open;
  if (cbSpline.Checked) then
  begin
    dmSea.cdsSeaSpl.EmptyDataSet;
    CurveToFit := 'SeaSpl';
    sbSpline.Panels[0].Text := 'Smoothing central curve';
    sbSpline.Panels[2].Text := IntToStr(ii);
    sbSpline.Refresh;
    SplineSmooth(X,Y,W,ii,S,DoAdjust,CurveAdjustBy);
    sbSpline.Panels[0].Text := 'Central curve completed';
    sbSpline.Refresh;
  end;
  //ShowMessage('1');
  for j:=1 to ii do
  begin
    Y1[j] := Y[j] + W1[j]*WMult;
  end;
  dmSea.cdsSeaSplP.Close;
  dmSea.cdsSeaSplP.Open;
  if (cbSplineP.Checked) then
  begin
    dmSea.cdsSeaSplP.EmptyDataSet;
    CurveToFit := 'SeaSplP';
    sbSpline.Panels[0].Text := 'Smoothing plus error curve';
    sbSpline.Panels[2].Text := IntToStr(ii);
    sbSpline.Refresh;
    SplineSmooth(X,Y1,W,ii,S,DoAdjust,CurveAdjustBy);
    sbSpline.Panels[0].Text := 'Plus error curve completed';
    sbSpline.Refresh;
  end;
  for j:=1 to ii do
  begin
    Y1[j] := Y[j] - W1[j]*WMult;
  end;
  dmSea.cdsSeaSplM.Close;
  dmSea.cdsSeaSplM.Open;
  if (cbSplineM.Checked) then
  begin
    dmSea.cdsSeaSplM.EmptyDataSet;
    CurveToFit := 'SeaSplM';
    sbSpline.Panels[0].Text := 'Smoothing minus error curve';
    sbSpline.Panels[2].Text := IntToStr(ii);
    sbSpline.Refresh;
    SplineSmooth(X,Y1,W,ii,S,DoAdjust,CurveAdjustBy);
    sbSpline.Panels[0].Text := 'Minus error curve completed';
    sbSpline.Refresh;
  end;
  dmSea.cdsSeaRaw.EnableControls;
  dmSea.cdsSearawAv.EnableControls;
  dmSea.cdsSeaSpl.EnableControls;
  dmSea.cdsSeaSplP.EnableControls;
  dmSea.cdsSeaSplM.EnableControls;
  dmSea.cdsSeaRaw.First;
  dmSea.cdsSearawAv.First;
  dmSea.cdsSeaSpl.First;
  dmSea.cdsSeaSplP.First;
  dmSea.cdsSeaSplM.First;
  sbSpline.Panels[0].Text := 'All completed';
  sbSpline.Panels[1].Text := '';
  //sbSpline.Panels[2].Text := '';
  //sbSpline.Panels[3].Text := '';
  sbSpline.Refresh;
  with dmSea do
  begin
    cdsSeaRaw.Close;
    cdsSeaRawAv.Close;
    cdsSeaSpl.Close;
    cdsSeaSplM.Close;
    cdsSeaSplP.Close;
    cdsSeaRaw.Open;
    cdsSeaRawAv.Open;
    cdsSeaSpl.Open;
    cdsSeaSplM.Open;
    cdsSeaSplP.Open;
  end;
  tCount := dmSea.cdsSeaRawAv.RecordCount;
  sbSpline.Panels[3].Text := FormatFloat('##0.000',(tCount-Sqrt(2*tCount))/tCount)+' < S < '+FormatFloat('##0.000',(tCount+Sqrt(2*tCount))/tCount);
  pcSpline.ActivePage := tsGraph;
  bbPrintGraph.Enabled := true;
end;

procedure TfmSplineFit.bbChangeClick(Sender: TObject);
var
  tMin, tMax : double;
  iCode : integer;
begin
  DBChart1.LeftAxis.Automatic := cbAutoAxis.Checked;
  Val(eMin.Text,tMin,iCode);
  if (iCode = 0) then
  begin
    DBChart1.LeftAxis.Minimum := tMin;
  end;
  Val(eMax.Text,tMax,iCode);
  if (iCode = 0) then
  begin
    DBChart1.LeftAxis.Maximum := tMax;
  end;
  if cbLogAxis.Checked then
  begin
    try
      DBChart1.LeftAxis.Logarithmic := true;
    except
    end;
  end else
  begin
    try
      DBChart1.LeftAxis.Logarithmic := false;
    except
    end;
  end;
end;

procedure TfmSplineFit.bbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSplineFit.cbIncreaseStdDevClick(Sender: TObject);
begin
  {
  case cbIncreaseStdDev.Checked of
    True : begin
      WMultStr.Enabled := true;
      WConstStr.Enabled := true;
    end;
    False : begin
      WMultStr.Enabled := false;
      WConstStr.Enabled := false;
    end;
  end;
  }
end;

procedure TfmSplineFit.FormShow(Sender: TObject);
var
  CanProceed : boolean;
begin
  pcSpline.ActivePage := tsDefine;
  tsDefine.TabVisible := true;
  tsGraph.TabVisible := true;
  tsData.TabVisible := true;
  tsYPrime.TabVisible := true;
  tsTimeStep.TabVisible := true;
  tsSpline.TabVisible := false;
  DBChart1.Series[0].Clear;
  DBChart1.Series[1].Clear;
  DBChart1.Series[2].Clear;
  DBChart1.Series[3].Clear;
  DBChart1.Series[4].Clear;
  DBChart1.Series[0].XValues.Order := loNone;
  DBChart1.Series[0].YValues.Order := loNone;
  DBChart1.Series[1].XValues.Order := loNone;
  DBChart1.Series[1].YValues.Order := loNone;
  DBChart1.Series[2].XValues.Order := loNone;
  DBChart1.Series[2].YValues.Order := loNone;
  DBChart1.Series[3].XValues.Order := loNone;
  DBChart1.Series[3].YValues.Order := loNone;
  DBChart1.Series[4].XValues.Order := loNone;
  DBChart1.Series[4].YValues.Order := loNone;
  DBChart2.Series[0].Clear;
  DBChart2.Series[0].XValues.Order := loNone;
  DBChart2.Series[0].YValues.Order := loNone;
  dmSea.cdsSeaRaw.Active := false;
  dmSea.cdsSeaRawAv.Active := false;
  dmSea.cdsSeaSpl.Active := false;
  dmSea.cdsSeaSplP.Active := false;
  dmSea.cdsSeaSplM.Active := false;
  dmSea.cdsDeltaT.Active := false;
  SStr.Text := SString;
  WMultStr.Text := WMultString;
  WConstStr.Text := WConstString;
  CurveAdjustBy := 0.0;
  AgeIncrementStr.Text := AgeIncrementString;
  eFromAge.Text := AgeFromStr;
  eToAge.Text := AgeToStr;
  eNspl.Text := IntToStr(NSplTot);
  sbSpline.Panels[0].Text := 'Prepare Calibration Curve';
  sbSpline.Refresh;
  with dmSea do
  begin
    cdsSeaRaw.FileName := cdsPath+'SeaRaw.cds';
    if not FileExists(cdsSeaRaw.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaRaw.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      //MessageDlg('Found - '+cdsPath+'SeaRaw.cds',mtInformation,[mbOK],0);
    end;
    CanProceed := true;
    cdsSeaRawAv.FileName := cdsPath+'SeaRawAv.cds';
    if not FileExists(cdsSeaRawAv.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaRawAv.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      //MessageDlg('Found - '+cdsPath+'SeaRawAv.cds',mtInformation,[mbOK],0);
    end;
    cdsSeaSpl.FileName := cdsPath+'SeaSpl.cds';
    if not FileExists(cdsSeaSpl.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaSpl.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      //MessageDlg('Found - '+cdsPath+'SeaSpl.cds',mtInformation,[mbOK],0);
    end;
    cdsSeaSplM.FileName := cdsPath+'SeaSplM.cds';
    if not FileExists(cdsSeaSplM.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaSplM.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      //MessageDlg('Found - '+cdsPath+'SeaSplM.cds',mtInformation,[mbOK],0);
    end;
    cdsSeaSplP.FileName := cdsPath+'SeaSplP.cds';
    if not FileExists(cdsSeaSplP.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'SeaSplP.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      //MessageDlg('Found - '+cdsPath+'SeaSplP.cds',mtInformation,[mbOK],0);
    end;
    cdsDeltaT.FileName := cdsPath+'DeltaT.cds';
    if not FileExists(cdsDeltaT.FileName) then
    begin
      MessageDlg('Required internal file not found - '+cdsPath+'DeltaT.cds',mtWarning,[mbOK],0);
      CanProceed := false;
    end else
    begin
      //MessageDlg('Found - '+cdsPath+'SeaSplP.cds',mtInformation,[mbOK],0);
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
        cdsSeaRawAv.LoadFromFile(cdsPath+'SeaRawAv.cds');
        cdsSeaRawAv.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaRawAv.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSpl.LoadFromFile(cdsPath+'SeaSpl.cds');
        cdsSeaSpl.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaSpl.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSplM.LoadFromFile(cdsPath+'SeaSplM.cds');
        cdsSeaSplM.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaSplM.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsSeaSplP.LoadFromFile(cdsPath+'SeaSplP.cds');
        cdsSeaSplP.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'SeaSplP.cds',mtWarning,[mbOK],0);
      end;
      try
        cdsDeltaT.LoadFromFile(cdsPath+'DeltaT.cds');
        cdsDeltaT.Open;
      except
        MessageDlg('Unable to open file - '+cdsPath+'DeltaT.cds',mtWarning,[mbOK],0);
      end;
    end else
    begin
      Close;
    end;
  end;
  pcSpline.ActivePage := tsDefine;
end;


procedure TfmSplineFit.sbPrinterSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TfmSplineFit.bbShowDataClick(Sender: TObject);
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

procedure TfmSplineFit.bbShowIncrementsClick(Sender: TObject);
begin
  dbgIncrements.DataSource := dmSea.dsDeltaT;
  dbnIncrements.DataSource := dmSea.dsDeltaT;
  eCountIncrements.Text := IntToStr(dmSea.cdsDeltaT.RecordCount);
end;

procedure TfmSplineFit.bbShowSplineClick(Sender: TObject);
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

procedure TfmSplineFit.bbShowSplinePClick(Sender: TObject);
begin
  if (DBChart1.Series[2].Active) then
  begin
    DBChart1.Series[2].Active := false;
    bbShowSplineP.Caption := 'Show +95%';
  end else
  begin
    DBChart1.Series[2].Active := true;
    bbShowSplineP.Caption := 'Hide +95%';
  end;
end;

procedure TfmSplineFit.bbShowSplineMClick(Sender: TObject);
begin
  if (DBChart1.Series[3].Active) then
  begin
    DBChart1.Series[3].Active := false;
    bbShowSplineM.Caption := 'Show -95%';
  end else
  begin
    DBChart1.Series[3].Active := true;
    bbShowSplineM.Caption := 'Hide -95%';
  end;
end;

procedure TfmSplineFit.sbImportClick(Sender: TObject);
var
  ImportForm : TfmSheetImport;
  CanProceed : boolean;
begin
  try
    ImportForm := TfmSheetImport.Create(Self);
    ImportForm.Left := SheetLeft;
    ImportForm.Top := SheetTop;
    ImportForm.Height := SheetHeight;
    ImportForm.Width := SheetWidth;
    ImportForm.OpenDialogSprdSheet.FileName := 'SeaRaw';
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

procedure TfmSplineFit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {
  with dmSea do
  begin
    try
      cdsSeaRaw.SaveToFile(cdsPath+'SeaRaw.cds');
    except
    end;
    try
      cdsSeaRawAv.SaveToFile(cdsPath+'SeaRawAv.cds');
    except
    end;
    try
      cdsSeaSpl.SaveToFile(cdsPath+'SeaSpl.cds');
    except
    end;
    try
      cdsSeaSplM.SaveToFile(cdsPath+'SeaSplM.cds');
    except
    end;
    try
      cdsSeaSplP.SaveToFile(cdsPath+'SeaSplP.cds');
    except
    end;
    try
      cdsDeltaT.SaveToFile(cdsPath+'DeltaT.cds');
    except
    end;
  end;
  }
end;

procedure TfmSplineFit.bbSeaRawAvClick(Sender: TObject);
begin
  dbgSeaRawAv.DataSource := dmSea.dsSeaRawAv;
  dbnSeaRawAv.DataSource := dmSea.dsSeaRawAv;
  eCountRawDataAv.Text := IntToStr(dmSea.cdsSeaRawAv.RecordCount);
end;

procedure TfmSplineFit.pcSplineChange(Sender: TObject);
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

procedure TfmSplineFit.bbSeaSplClick(Sender: TObject);
begin
  dbgSeaSpl.DataSource := dmSea.dsSeaSpl;
  dbnSeaSpl.DataSource := dmSea.dsSeaSpl;
  eCountSpline.Text := IntToStr(dmSea.cdsSeaSpl.RecordCount);
end;

procedure TfmSplineFit.bbSeaSplPClick(Sender: TObject);
begin
  dbgSeaSplP.DataSource := dmSea.dsSeaSplP;
  dbnSeaSplP.DataSource := dmSea.dsSeaSplP;
  eCountSplineP.Text := IntToStr(dmSea.cdsSeaSplP.RecordCount);
end;

procedure TfmSplineFit.bbShowDataAvClick(Sender: TObject);
begin
  if (DBChart1.Series[4].Active) then
  begin
    DBChart1.Series[4].Active := false;
    bbShowDataAv.Caption := 'Show data (av)';
  end else
  begin
    DBChart1.Series[4].Active := true;
    bbShowDataAv.Caption := 'Hide data (av)';
  end;
end;

procedure TfmSplineFit.bbPrintGraphClick(Sender: TObject);
begin
  if (pcSpline.ActivePage = tsGraph) then DBChart1.PrintLandscape;
  if (pcSpline.ActivePage = tsYPrime) then DBChart2.PrintLandscape;
end;

end.

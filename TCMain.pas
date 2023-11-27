unit TCMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Menus, ExtCtrls, IniFiles, System.ImageList,
  System.IOUtils, System.UITypes, VCL.Themes,  System.Variants,
  VCL.FlexCel.Core, FlexCel.XlsAdapter, FlexCel.Report,
  ActnMan, XPStyleActnCtrls, DBCtrls, VclTee.TeeProcs,
  VclTee.TeeHistogram, VclTee.TeEngine, VclTee.Chart, VclTee.TeeComma, VclTee.TeeEdit,
  Vcl.PlatformDefaultStyleActnCtrls, VclTee.TeeGDIPlus, System.Actions, Data.DB,
  VCLTee.StatChar, VCLTee.DBChart, VCLTee.TeeTools, VCLTee.TeeLegendScrollBar,
  VCLTee.TeePoin3,
  VCLTee.TeeVideo, VCLTee.TeeSurfa, VCLTee.TeeTriSurface, VCLTee.Series,
  Vcl.ImgList, Vcl.VirtualImageList, SVGIconVirtualImageList;

type
  TfmTCmain = class(TForm)
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    Panel2: TPanel;
    File1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    Curve1: TMenuItem;
    Printersetup1: TMenuItem;
    N1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    About1: TMenuItem;
    Spline1: TMenuItem;
    bbExit: TBitBtn;
    MovingAverage1: TMenuItem;
    CompareGraphs1: TMenuItem;
    N2: TMenuItem;
    Exportcurvedata1: TMenuItem;
    ExportSpline: TMenuItem;
    ExportSplineP: TMenuItem;
    ExportSplineM: TMenuItem;
    ExportMovingAverage: TMenuItem;
    SVGIconVirtualImageList1: TSVGIconVirtualImageList;
    Button1: TButton;
    Styles1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure sbFileExitClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Printersetup1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Spline1Click(Sender: TObject);
    procedure MovingAverage1Click(Sender: TObject);
    procedure CompareGraphs1Click(Sender: TObject);
    procedure ExportSplineClick(Sender: TObject);
    procedure ExportSplinePClick(Sender: TObject);
    procedure ExportSplineMClick(Sender: TObject);
    procedure ExportMovingAverageClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StyleClick(Sender: TObject);
  private
    { Private declarations }
    MyCurrentStyle : string;
    procedure GetIniFile;
    procedure SetIniFile;
    procedure ApplySelectedThemeToCharts(CurrentStyle : string);
  public
    { Public declarations }
  end;

var
  fmTCmain: TfmTCmain;

implementation

uses
  //shlobj,
  mar_def, tc_spline, TC_About, tc_movav, tc_graphs, TC_dm, tc_varb;

{$R *.DFM}
{$D+}

procedure TfmTCmain.FormCreate(Sender: TObject);
var
  Style: String;
  Item: TMenuItem;
begin
  SeaSpline := true;
  WConst := 0.1;
  WMult := 1.96;
  S := 0.8;
  FromRowValueString := '1';
  ToRowValueString := '2';
  GlobalChosenStyle := 'Windows';
  //UncheckAllThemes;
  //Windows101.Checked := true;
  //MyCurrentStyle := 'Windows10';
  //TStyleManager.TrySetStyle(MyCurrentStyle);
  GetIniFile;
  TStyleManager.TrySetStyle(GlobalChosenStyle);
  //Add child menu items based on available styles.
  for Style in TStyleManager.StyleNames do
  begin
    Item := TMenuItem.Create(Styles1);
    Item.Caption := Style;
    Item.OnClick := StyleClick;
    if TStyleManager.ActiveStyle.Name = Style then
      Item.Checked := true;
    Styles1.Add(Item);
  end;
end;

procedure TfmTCmain.sbFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmTCmain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmTCmain.Printersetup1Click(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TfmTCmain.About1Click(Sender: TObject);
var
  TCAboutBox : TAboutBox;
begin
  try
    TCAboutBox := TAboutBox.Create(self);
    TCAboutBox.ShowModal;
  finally
    TCAboutBox.Free;
  end;
end;

procedure TfmTCmain.FormShow(Sender: TObject);
begin
  //GetIniFile;
  {
  fmTCMain.Left := MainLeft;
  fmTCMain.Top := MainTop;
  fmTCMain.Height := MainHeight;
  fmTCMain.Width := MainWidth;
  }
  NSplTot := NSplMax;
  {
  try
    NSplTot := dmSea.cdsSeaRaw.RecordCount;
    if (NSplTot < 1) then NSplTot := NSplMax;
  except
  end;
  }
  //ShowMessage(IntToStr(NSplTot));
end;

procedure TfmTCmain.GetIniFile;
var
  PublicPath : string;
  AppIni   : TIniFile;
  //zpath: array [0..MAX_PATH] of char;
begin
  //uses ShlObj
  // this gives access to all the systemed defined folders, no direct dependency on env. variables.
  //SHGetFolderPath(0, CSIDL_COMMON_APPDATA or CSIDL_FLAG_CREATE, 0, SHGFP_TYPE_CURRENT, @zpath);
  //PublicPath := TPath.GetPublicPath;
  //Used to use CSIDL_COMMON_APPDATA but some users do not have access to this
  //and don't know how to change their system settings and permissions to all
  //software to write to this path.
  //Now changed to use CSIDL_COMMON_DOCUMENTS which automatically permits
  //all users to have both read and write permission
  PublicPath := TPath.GetHomePath;
  //dmSea.CommonFilePath := IncludeTrailingPathDelimiter(PublicPath) + 'EggSoft/';
  //dmSea.CommonFilePath := IncludeTrailingPathDelimiter(string(zpath)) + 'EggSoft\TimeCurve\';
  //dmSea.IniFilename := IncludeTrailingPathDelimiter(string(zpath)) + 'EggSoft\TimeCurve\'+'TimeCurve.INI';
  dmSea.CommonFilePath := IncludeTrailingPathDelimiter(PublicPath) + 'EggSoft\';
  dmSea.IniFilename := IncludeTrailingPathDelimiter(PublicPath) + 'EggSoft\'+'TimeCurve.INI';
  AppIni := TIniFile.Create(dmSea.IniFilename);
  //ShowMessage(dmSea.IniFilename);
  try
    DataPath := AppIni.ReadString('File Paths','Data spreadsheets',dmSea.CommonFilePath+'TimeCurve\Data\');
    cdsPath := AppIni.ReadString('File Paths','Internal files',dmSea.CommonFilePath+'TimeCurve\Data\');
    ImportPath := AppIni.ReadString('File Paths','Data import path',dmSea.CommonFilePath+'TimeCurve\Data\');
    ExportPath := AppIni.ReadString('File Paths','Data export path',dmSea.CommonFilePath+'TimeCurve\Exports\');
    FlexTemplatePath := AppIni.ReadString('File Paths','Template path',dmSea.CommonFilePath+'TimeCurve\Templates\');
    if DataPath[Length(DataPath)] <> '\' then DataPath := DataPath+'\';
    if cdsPath[Length(cdsPath)] <> '\' then cdsPath := cdsPath+'\';
    if ImportPath[Length(ImportPath)] <> '\' then ImportPath := ImportPath+'\';
    //ShowMessage(DataPath);
    //ShowMessage(cdsPath);
    //ShowMessage(ImportPath);
    GlobalChosenStyle := AppIni.ReadString('Styles','Chosen style','Windows');
    if (GlobalChosenStyle = '') then GlobalChosenStyle := 'Windows';
    dmSea.ChosenStyle := GlobalChosenStyle;
    SeaSpline := AppIni.ReadBool('Curve parameters','Marine Sr isotope',false);
    WConstString := AppIni.ReadString('Curve parameters','Minimum uncertainty','0.1');
    WMultString := AppIni.ReadString('Curve parameters','Students t multiplier','1.96');
    SString := AppIni.ReadString('Curve parameters','Required smoothing precision','0.8');
    PointIncrementString := AppIni.ReadString('Curve parameters','Number of points to average','5');
    MovAvAgeIncrementString := AppIni.ReadString('Curve parameters','Moving average age window','1.0');
    AgeIncrementString := AppIni.ReadString('Curve parameters','Age range to average','0.1');
    XColStr := AppIni.ReadString('Input fields','X Column','A');
    YColStr := AppIni.ReadString('Input fields','Y Column','B');
    YerrColStr := AppIni.ReadString('Input fields','Y err Column','C');
    AgeFromStr := AppIni.ReadString('Input fields','Age from','0.0');
    AgeToStr := AppIni.ReadString('Input fields','Age to','1.0');
    FromRowValueString := AppIni.ReadString('Input fields','From Row','2');
    ToRowValueString := AppIni.ReadString('Input fields','To Row','3');
    MainLeft := AppIni.ReadInteger('Form positions','Main Left',1);
    MainTop := AppIni.ReadInteger('Form positions','Main Top',1);
    MainHeight := AppIni.ReadInteger('Form positions','Main Height',480);
    MainWidth := AppIni.ReadInteger('Form positions','Main Width',800);
    SheetLeft := AppIni.ReadInteger('Form positions','Sheet Left',1);
    SheetTop := AppIni.ReadInteger('Form positions','Sheet Top',50);
    SheetHeight := AppIni.ReadInteger('Form positions','Sheet Height',530);
    SheetWidth := AppIni.ReadInteger('Form positions','Sheet Width',800);
    SplineLeft := AppIni.ReadInteger('Form positions','Spline Left',1);
    SplineTop := AppIni.ReadInteger('Form positions','Spline Top',50);
    SplineHeight := AppIni.ReadInteger('Form positions','Spline Height',530);
    SplineWidth := AppIni.ReadInteger('Form positions','Spline Width',800);
    MovAvLeft := AppIni.ReadInteger('Form positions','Moving Average Left',1);
    MovAvTop := AppIni.ReadInteger('Form positions','Moving Average Top',50);
    MovAvHeight := AppIni.ReadInteger('Form positions','Moving Average Height',530);
    MovAvWidth := AppIni.ReadInteger('Form positions','Moving Average Width',800);
    GraphLeft := AppIni.ReadInteger('Form positions','Graph Left',1);
    GraphTop := AppIni.ReadInteger('Form positions','Graph Top',50);
    GraphHeight := AppIni.ReadInteger('Form positions','Graph Height',530);
    GraphWidth := AppIni.ReadInteger('Form positions','Graph Width',800);
    ExportLeft := AppIni.ReadInteger('Form positions','Export Left',1);
    ExportTop := AppIni.ReadInteger('Form positions','Export Top',50);
    ExportHeight := AppIni.ReadInteger('Form positions','Export Height',530);
    ExportWidth := AppIni.ReadInteger('Form positions','Export Width',800);
  finally
    AppIni.Free;
  end;
end;

procedure TfmTCmain.SetIniFile;
var
  AppIni   : TIniFile;
  DateAsString : string;
  TimeAsString : string;
begin
  //ShowMessage(dmSea.IniFilename);
  //ShowMessage(DataPath);
  //ShowMessage(cdsPath);
  DataPath := UpperCase(DataPath);
  cdsPath := UpperCase(cdsPath);
  DateAsString := DateToStr(Now);
  TimeAsString := TimeToStr(Now);
  AppIni := TIniFile.Create(dmSea.IniFilename);
  try
    AppIni.WriteString('File Paths','Data spreadsheets',DataPath);
    AppIni.WriteString('File Paths','Internal files',cdsPath);
    AppIni.WriteString('File Paths','Data import path',ImportPath);
    AppIni.WriteString('File Paths','Data export path',ExportPath);
    AppIni.WriteString('File Paths','Template path',FlexTemplatePath);
    AppIni.WriteString('Styles','Chosen style',GlobalChosenStyle);
    AppIni.WriteString('MyStyle','MyCurrentDate',DateAsString);
    AppIni.WriteString('MyStyle','MyCurrentTime',TimeAsString);
    AppIni.WriteBool('Curve parameters','Marine Sr isotope',SeaSpline);
    AppIni.WriteString('Curve parameters','Minimum uncertainty',WConstString);
    AppIni.WriteString('Curve parameters','Students t multiplier',WMultString);
    AppIni.WriteString('Curve parameters','Required smoothing precision',SString);
    AppIni.WriteString('Curve parameters','Age range to average',AgeIncrementString);
    AppIni.WriteString('Curve parameters','Number of points to average',PointIncrementString);
    AppIni.WriteString('Curve parameters','Moving average age window',MovAvAgeIncrementString);
    AppIni.WriteString('Input fields','X Column',XColStr);
    AppIni.WriteString('Input fields','Y Column',YColStr);
    AppIni.WriteString('Input fields','Y err Column',YerrColStr);
    AppIni.WriteString('Input fields','Age from',AgeFromStr);
    AppIni.WriteString('Input fields','Age to',AgeToStr);
    AppIni.WriteString('Input fields','From Row',FromRowValueString);
    AppIni.WriteString('Input fields','To Row',ToRowValueString);
    AppIni.WriteInteger('Form positions','Main Left',MainLeft);
    AppIni.WriteInteger('Form positions','Main Top',mainTop);
    AppIni.WriteInteger('Form positions','Main Height',MainHeight);
    AppIni.WriteInteger('Form positions','Main Width',MainWidth);
    AppIni.WriteInteger('Form positions','Sheet Left',SheetLeft);
    AppIni.WriteInteger('Form positions','Sheet Top',SheetTop);
    AppIni.WriteInteger('Form positions','Sheet Height',SheetHeight);
    AppIni.WriteInteger('Form positions','Sheet Width',SheetWidth);
    AppIni.WriteInteger('Form positions','Spline Left',SplineLeft);
    AppIni.WriteInteger('Form positions','Spline Top',SplineTop);
    AppIni.WriteInteger('Form positions','Spline Height',SplineHeight);
    AppIni.WriteInteger('Form positions','Spline Width',SplineWidth);
    AppIni.WriteInteger('Form positions','Moving Average Left',MovAvLeft);
    AppIni.WriteInteger('Form positions','Moving Average Top',MovAvTop);
    AppIni.WriteInteger('Form positions','Moving Average Height',MovAvHeight);
    AppIni.WriteInteger('Form positions','Moving Average Width',MovAvWidth);
    AppIni.WriteInteger('Form positions','Graph Left',GraphLeft);
    AppIni.WriteInteger('Form positions','Graph Top',GraphTop);
    AppIni.WriteInteger('Form positions','Graph Height',GraphHeight);
    AppIni.WriteInteger('Form positions','Graph Width',GraphWidth);
    AppIni.WriteInteger('Form positions','Export Left',ExportLeft);
    AppIni.WriteInteger('Form positions','Export Top',ExportTop);
    AppIni.WriteInteger('Form positions','Export Height',ExportHeight);
    AppIni.WriteInteger('Form positions','Export Width',ExportWidth);
  finally
    AppIni.Free;
  end;
end;

procedure TfmTCmain.StyleClick(Sender: TObject);
var
  StyleName : String;
  i : integer;
begin
  //get style name
  StyleName := TMenuItem(Sender).Caption;
  StyleName := StringReplace(StyleName, '&', '',
    [rfReplaceAll,rfIgnoreCase]);
  GlobalChosenStyle := StyleName;
  dmSea.ChosenStyle := GlobalChosenStyle;
  //set active style
  Application.HandleMessage;
  TStyleManager.SetStyle(GlobalChosenStyle);
  dmSea.ChosenStyle := GlobalChosenStyle;
  Application.HandleMessage;
  //check the currently selected menu item
  (Sender as TMenuItem).Checked := true;
  //uncheck all other style menu items
  for i := 0 to Styles1.Count-1 do
  begin
    if not Styles1.Items[i].Equals(Sender) then
      Styles1.Items[i].Checked := false;
  end;
  for i := 0 to Styles1.Count-1 do
  begin
    if Styles1.Items[i].Checked then GlobalChosenStyle := StringReplace(Styles1.Items[i].Caption, '&', '',
    [rfReplaceAll,rfIgnoreCase]);
  end;
  TStyleManager.SetStyle(GlobalChosenStyle);
  try
    dmSea.ChosenStyle := GlobalChosenStyle;
  finally
    dmSea.ChosenStyle := GlobalChosenStyle;
  end;
  ApplySelectedThemeToCharts(StyleName);
end;

procedure TfmTCmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainLeft := fmTCMain.Left;
  MainTop := fmTCMain.Top;
  MainHeight := fmTCMain.Height;
  MainWidth := fmTCMain.Width;
  SetIniFile;
end;

procedure TfmTCmain.Spline1Click(Sender: TObject);
var
  SplineForm : TfmSplineFit;
  CanProceed : boolean;
begin
  try
    //ShowMessage('starting SplineFit');
    SplineForm := TfmSplineFit.Create(Self);
    //SplineForm.Left := SplineLeft;
    //SplineForm.Top := SplineTop;
    //SplineForm.Height := SplineHeight;
    //SplineForm.Width := SplineWidth;
    SplineForm.ShowModal;
    if (SplineForm.ModalResult = mrClose) then
    begin
      CanProceed := true;
      SplineLeft := SplineForm.Left;
      SplineTop := SplineForm.Top;
      SplineHeight := SplineForm.Height;
      SplineWidth := SplineForm.Width;
    end;
  finally
    SplineForm.Free;
  end;
end;

procedure TfmTCmain.MovingAverage1Click(Sender: TObject);
var
  MovAvForm : TfmMovAv;
  CanProceed : boolean;
begin
  //ShowMessage('1');
  try
    MovAvForm := TfmMovAv.Create(Self);
    {
    MovAvForm.Left := MovAvLeft;
    MovAvForm.Top := MovAvTop;
    MovAvForm.Height := MovAvHeight;
    MovAvForm.Width := MovAvWidth;
    }
    MovAvForm.ModalResult := mrNone;
    dmSea.cdsSeaRaw.LogChanges := false;
    dmSea.cdsMovAv.LogChanges := false;
    //ShowMessage('2');
    MovAvForm.ShowModal;
    //MovAvForm.Show;
    if (MovAvForm.ModalResult = mrClose) then
    begin
      //ShowMessage('3');
      CanProceed := true;
      MovAvLeft := MovAvForm.Left;
      MovAvTop := MovAvForm.Top;
      MovAvHeight := MovAvForm.Height;
      MovAvWidth := MovAvForm.Width;
    end;
  finally
    //MovAvForm.Free;
  end;
end;

procedure TfmTCmain.Button1Click(Sender: TObject);
begin
  GetIniFile;
end;

procedure TfmTCmain.CompareGraphs1Click(Sender: TObject);
var
  GraphForm : TfmGraphs;
  CanProceed : boolean;
begin
  try
    GraphForm := TfmGraphs.Create(Self);
    {
    GraphForm.Left := GraphLeft;
    GraphForm.Top := GraphTop;
    GraphForm.Height := GraphHeight;
    GraphForm.Width := GraphWidth;
    }
    GraphForm.ShowModal;

    if (GraphForm.ModalResult = mrClose) then
    begin
      CanProceed := true;
      GraphLeft := GraphForm.Left;
      GraphTop := GraphForm.Top;
      GraphHeight := GraphForm.Height;
      GraphWidth := GraphForm.Width;
    end;
  finally
    GraphForm.Free;
  end;
end;

procedure TfmTCmain.ExportSplineClick(Sender: TObject);
var
  fr: TFlexCelReport;
  frTemplateStr, frFileNameStr : string;
begin
  frTemplateStr := FlexTemplatePath+'TimeCurve_Smoothed_Spline.xlsx';
  dmSea.SaveDialogFlex.InitialDir := ExportPath;
  dmSea.SaveDialogFlex.FileName := 'TimeCurve_Smoothed_Spline_1';
  if dmSea.SaveDialogFlex.Execute then
  begin
    frFileNameStr := dmSea.SaveDialogFlex.FileName;
    ExportPath := ExtractFilePath(dmSea.SaveDialogFlex.FileName);
    fr := TFlexCelReport.Create(true);
    try
      fr.AddTable('cdsSeaSpl',dmSea.cdsSeaSpl);
      fr.Run(
         frTemplateStr,frFileNameStr
      );
    finally
      fr.Free;
    end;
  end;
end;

procedure TfmTCmain.ExportSplinePClick(Sender: TObject);
var
  fr: TFlexCelReport;
  frTemplateStr, frFileNameStr : string;
begin
  frTemplateStr := FlexTemplatePath+'TimeCurve_Smoothed_SplineP.xlsx';
  dmSea.SaveDialogFlex.InitialDir := ExportPath;
  dmSea.SaveDialogFlex.FileName := 'TimeCurve_Smoothed_SplineP_1';
  if dmSea.SaveDialogFlex.Execute then
  begin
    frFileNameStr := dmSea.SaveDialogFlex.FileName;
    ExportPath := ExtractFilePath(dmSea.SaveDialogFlex.FileName);
    fr := TFlexCelReport.Create(true);
    try
      fr.AddTable('cdsSeaSplP',dmSea.cdsSeaSplP);
      fr.Run(
         frTemplateStr,frFileNameStr
      );
    finally
      fr.Free;
    end;
  end;
end;

procedure TfmTCmain.ExportSplineMClick(Sender: TObject);
var
  fr: TFlexCelReport;
  frTemplateStr, frFileNameStr : string;
begin
  frTemplateStr := FlexTemplatePath+'TimeCurve_Smoothed_SplineM.xlsx';
  dmSea.SaveDialogFlex.InitialDir := ExportPath;
  dmSea.SaveDialogFlex.FileName := 'TimeCurve_Smoothed_SplineM_1';
  if dmSea.SaveDialogFlex.Execute then
  begin
    frFileNameStr := dmSea.SaveDialogFlex.FileName;
    ExportPath := ExtractFilePath(dmSea.SaveDialogFlex.FileName);
    fr := TFlexCelReport.Create(true);
    try
      fr.AddTable('cdsSeaSplM',dmSea.cdsSeaSplM);
      fr.Run(
         frTemplateStr,frFileNameStr
      );
    finally
      fr.Free;
    end;
  end;
end;

procedure TfmTCmain.ExportMovingAverageClick(Sender: TObject);
var
  fr: TFlexCelReport;
  frTemplateStr, frFileNameStr : string;
begin
  frTemplateStr := FlexTemplatePath+'TimeCurve_Smoothed_MovAv.xlsx';
  dmSea.SaveDialogFlex.InitialDir := ExportPath;
  dmSea.SaveDialogFlex.FileName := 'TimeCurve_Smoothed_MovAv_1';
  if dmSea.SaveDialogFlex.Execute then
  begin
    frFileNameStr := dmSea.SaveDialogFlex.FileName;
    ExportPath := ExtractFilePath(dmSea.SaveDialogFlex.FileName);
    fr := TFlexCelReport.Create(true);
    try
      fr.AddTable('cdsMovAv',dmSea.cdsMovAv);
      fr.Run(
         frTemplateStr,frFileNameStr
      );
    finally
      fr.Free;
    end;
  end;
end;

procedure TfmTCmain.ApplySelectedThemeToCharts(CurrentStyle : string);
begin
  //pc1.ActivePage := tsDefine;
  //TSystemTheme.ApplyStyle(ChartOriginalData);
  //TSystemTheme.ApplyStyle(DBChart1);
  //TSystemTheme.ApplyStyle(ChartPDF);
  //TSystemTheme.ApplyStyle(ChartCum);
  //TSystemTheme.ApplyStyle(ChartGeotectonic);
  //TSystemTheme.ApplyStyle(ChartHeat);
end;

end.

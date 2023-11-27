program TimeCurve;

uses
  Forms,
  mar_def in 'mar_def.pas',
  TCMain in 'TCMain.pas' {fmTCmain},
  TC_About in 'TC_About.pas' {AboutBox},
  tc_spline in 'tc_spline.pas' {fmSplineFit},
  TC_dm in 'TC_dm.pas' {dmSea: TDataModule},
  TC_ShtIm2 in 'TC_ShtIm2.pas' {fmSheetImport},
  tc_movav in 'tc_movav.pas' {fmMovAv},
  tc_graphs in 'tc_graphs.pas' {fmGraphs},
  tc_varb in 'tc_varb.pas',
  Allsorts in '..\Eglington Delphi common code items\Allsorts.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Windows10');
  Application.Title := 'Time Curve';
  Application.CreateForm(TdmSea, dmSea);
  Application.CreateForm(TfmTCmain, fmTCmain);
  Application.Run;
end.

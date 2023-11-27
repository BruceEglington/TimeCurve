unit TC_dm;

interface

uses
  SysUtils, Classes, DB, Provider, DBClient,
  XLSAdapter, Dialogs,
  midaslib,
  VCL.FlexCel.Core, Vcl.BaseImageCollection, SVGIconImageCollection;

type
  TdmSea = class(TDataModule)
    cdsSeaRaw: TClientDataSet;
    cdsSeaSpl: TClientDataSet;
    cdsSeaRawAv: TClientDataSet;
    cdsSeaSplM: TClientDataSet;
    cdsSeaSplP: TClientDataSet;
    dsSeaRaw: TDataSource;
    cdsSeaRawAge: TFloatField;
    cdsSeaRawRatio: TFloatField;
    cdsSeaRawError: TFloatField;
    cdsSeaRawAvAge: TFloatField;
    cdsSeaRawAvRatio: TFloatField;
    cdsSeaRawAvError: TFloatField;
    cdsSeaRawAvN: TSmallintField;
    cdsSeaSplAge: TFloatField;
    cdsSeaSplRatio: TFloatField;
    cdsSeaSplError: TFloatField;
    cdsSeaSplYPrime: TFloatField;
    cdsSeaSplS: TFloatField;
    cdsSeaSplMAge: TFloatField;
    cdsSeaSplMRatio: TFloatField;
    cdsSeaSplMError: TFloatField;
    cdsSeaSplMYPrime: TFloatField;
    cdsSeaSplMS: TFloatField;
    cdsSeaSplPAge: TFloatField;
    cdsSeaSplPRatio: TFloatField;
    cdsSeaSplPError: TFloatField;
    cdsSeaSplPYPrime: TFloatField;
    cdsSeaSplPS: TFloatField;
    dsSeaRawAv: TDataSource;
    dsSeaSpl: TDataSource;
    dsSeaSplM: TDataSource;
    dsSeaSplP: TDataSource;
    cdsMovAv: TClientDataSet;
    dsMovAv: TDataSource;
    cdsMovAvAge: TFloatField;
    cdsMovAvRatio: TFloatField;
    cdsMovAvError: TFloatField;
    cdsMovAvN: TSmallintField;
    //FlexSpline: TFlexCelReport;
    SaveDialogFlex: TSaveDialog;
    //FlexSplP: TFlexCelReport;
    //FlexSplM: TFlexCelReport;
    //FlexMovAv: TFlexCelReport;
    cdsDeltaT: TClientDataSet;
    dsDeltaT: TDataSource;
    cdsDeltaTAge: TFloatField;
    cdsDeltaTDeltaT: TFloatField;
    SVGIconImageCollection1: TSVGIconImageCollection;
  private
    { Private declarations }
  public
    { Public declarations }
    CommonFilePath : string;
    IniFilename : string;
    ChosenStyle : string;
  end;

var
  dmSea: TdmSea;

implementation

{$R *.dfm}

end.

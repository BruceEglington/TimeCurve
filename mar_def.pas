unit mar_def;

interface

const
   FileSource = 'General';  {General or IsoProj}
   NMax      =  50000;
   NSplMax   =  50000;
   PresentSeaRatio  : double = 0.7092;
   MinimumSeaRatio  : double = 0.7000;
   AgeIncrement     : double = 0.1;
   MovAvAgeIncrement  : double = 1.0;
   PointIncrement   : integer = 5;
   DoAdjust    : boolean = false;
   SeaSpline   : boolean = true;
   NBS987Val   : double = 0.710275;
   MaxSplPts = 50500;
const
  VtChAxisIDX = 0;
  VtChAxisIDY = 0;

type
  RealArray50 = array[0..NMax] of single;
  RealArray200 = array[0..NMax] of double;
  ArrayD = array[1..101] of double;

var
  XColStr, YColStr, YerrColStr : string;
  XCol, YCol, YerrCol : integer;
  tCount : double;
  FromRowValueString, ToRowValueString : string;
  FromRow, ToRow : integer;
  MainLeft, MainTop, MainHeight, MainWidth : integer;
  SheetLeft, SheetTop, SheetHeight, SheetWidth : integer;
  SplineLeft, SplineTop, SplineHeight, SplineWidth : integer;
  MovAvLeft, MovAvTop, MovAvHeight, MovAvWidth : integer;
  GraphLeft, GraphTop, GraphHeight, GraphWidth : integer;
  ExportLeft, ExportTop, ExportHeight, ExportWidth : integer;
  FromAge, ToAge : double;
  ImportPath, DataPath, cdspath, ExportPath : string;
  CurveToFit : string;
  WConstString, WMultString, SString, AgeIncrementString,
  MovAvAgeIncrementString, PointIncrementString : string;
  AgeFromStr, AgeToStr : string;
  FlexTemplatePath : string;
  X, Y, W,
  W1, Y1         : RealArray50;
  i, j, k, ii    : integer;
  XX, YY, WW, Xt,
  S, WConst      : double;
  WMult          : double;
  StdDevChoice   : char;
  SumX,
  SumY, SumY2    : double;
  Yt             : ArrayD;
  XSplt, YSplt,
  YPrime         : double;
  T, T1, V,
  R2, U,
  A, B, C,
  D, R, R1       : RealArray200;

  ExtraMult      : double;
  CurveAdjustBy  : double;
  temp           : double;
  NewAge         : double;
  Diff           : double;
  AgeSmpErrP, AgeSmpErrM,
  AgeGlbErrP, AgeGlbErrM : double;
  StartAge, FinishAge    : double;
  NBS987Ms               : double;
  Deriv, Resol           : double;
  InitRatio, InitRatioError : double;
  Age, AgeError, T_Mult  : double;
  UprAgeError, LwrAgeError  : double;
  N_Rep                  : integer;
  NSplTot           : integer;

function TMultiplier(N : double) : double;

implementation

function TMultiplier(N : double) : double;
{from Ludwig 1990 - ISOPLOT}
var
  W    : double;
begin
  Result := 1.96;
  if N=1.0 then Result := 12.706;
  if N>1.0 then
  begin
    W:=N-0.85;
    Result :=    1.96 - 0.00554568/Sqrt(W)
                      + 2.4059333/W
                      + 0.6711777/(W*W)
                      - 0.3831214/(W*W*W);
  end;
  if N<1.0 then
  begin
    Result := 1.0/(  N * -0.00765
                      + (N*N) * 0.11085
                      - (N*N*N) * 0.02446);
  end;
end;


end.

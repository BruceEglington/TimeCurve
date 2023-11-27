unit tc_varb;

interface
const
  zero         = 0;
  DefaultZeroLimit = 1.0e-14;

var
  NPts        : integer;
  Total       : double;
  DefaultMinimum : double;
  GlobalChosenStyle : string;

var
   done                  : boolean;
   AnyKey                : char;
   ImportSheetNumber,
   DataCol, SigmaCol, UnitAgeCol : integer;
   DataColStr, SigmaColStr, UnitAgeColStr     : string;
   FromRowValueString, ToRowValueString : string;
   DefaultMinimumSigmaStr : string;
   FromRow, ToRow : integer;

implementation

end.

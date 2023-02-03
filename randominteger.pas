unit RandomInteger;

interface

function RandomInteger (MinVal, MaxVal : Integer) : Integer;

implementation

function RandomInteger (MinVal, MaxVal : Integer) : Integer;
  begin
    RandomInteger := Trunc (MinVal + (MaxVal - MinVal + 1) * Random)
  end;
end.

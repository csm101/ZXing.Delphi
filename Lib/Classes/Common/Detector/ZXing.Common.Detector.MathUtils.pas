unit ZXing.Common.Detector.MathUtils;

{
  * Copyright 2008 ZXing authors
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  *      http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.

  * Implemented by E. Spelt for Delphi
  * Restructured by K. Gossens
}
interface

uses 
  System.SysUtils;

type
  TMathUtils = class sealed
  public
    class function distance(const aX, aY, bX, bY: Double): Single; static;
    class function round(d: Single): Integer; static;
    // class function Asr(x, y: integer): integer; overload; static;

    // created two distinct versions of ASR because assigning the result of int64 version to an int variable
    // without doing an explicit cast to integer often raises a "range check error" if library is compiled with "range checking on"
    class function Asr64(const Value: Int64; const ShiftBits: integer): Int64; static;
    class function Asr(const Value: Int64; const ShiftBits: integer): integer; static;
  end;

implementation

{ TMathUtils }

class function TMathUtils.distance(const aX, aY, bX, bY: Double): Single;
var
  xDiff, yDiff: double;
begin
  xDiff := aX - bX;
  yDiff := aY - bY;
  result := Sqrt(xDiff * xDiff + yDiff * yDiff);
end;

class function TMathUtils.round(d: Single): Integer;
begin
  if (Single.IsNaN(d)) then
  begin
    Result := 0;
    exit
  end;
  if (Single.IsPositiveInfinity(d)) then
  begin
    Result := $7fffffff;
    exit;
  end;



  if (d < 0)
  then
     Result := Trunc(d + (-0.5))
  else
     Result := Trunc(d + 0.5);
end;

{
  class function TMathUtils.Asr(x, y: integer): integer;
  begin
  result := x div (1 shl y);
  end;
}
class function TMathUtils.Asr64(const Value: Int64; const ShiftBits: integer): Int64;
begin
  result := Value shr ShiftBits;
  if (Value and $8000000000000000) > 0 then
    result := result or ($FFFFFFFFFFFFFFFF shl (64 - ShiftBits));
end;

class function TMathUtils.Asr(const Value: Int64; const ShiftBits: integer): integer;
begin
  result := integer(TMathUtils.Asr64(Value,ShiftBits));
end;

end.
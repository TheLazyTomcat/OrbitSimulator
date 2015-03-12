unit OrbitalSystem;

interface

const
  G             = 6.673e-11;  (* gravitational constant [N(m/kg)^2] *) 
  ReducedG      = 6.673;      (* by 10^-11 *) 
  def_TimeStep  = 60;         (* [s] *)
  cTrailSteps   = 100;
  def_TrailTime = 1000000;    (* [s] *)

type
  TVector3e = Array[0..2] of Extended;

  TVector3er = packed record
    X:  Extended;
    Y:  Extended;
    Z:  Extended;
  end;

  TTrailArray = Array[0..Pred(cTrailSteps)] of TVector3e;

const
  ZeroVector3e: TVector3e = (0.0,0.0,0.0);
  
//==============================================================================

type
  TBody = class(TObject)
  private
    fCenterBody:        TBody;
    fIdentifier:        TGUID;
    fName:              String;
    fReducedValues:     Boolean;
    fMass:              Extended;
    fPosition:          TVector3e;
    fVelocity:          TVector3e;
    fAcceleration:      TVector3e;
    fElapsedTime:       Int64;
    fData:              Pointer;
    fInteractingBodies: Array of TBody;
    fStoreTrail:        Boolean;
    fTrailTime:         Int64;
    fTrailStep:         Int64;
    fTrailCount:        Integer;
    fTrailLast:         Int64;
    fTrail:             TTrailArray;
    Function GetInteractingBody(Index: Integer): TBody;
    Function GetInteractingBodiesCount: Integer;
    procedure SetStoreTrail(Value: Boolean);
    procedure SetTrailTime(Value: Int64);
    Function GetTrail(Index: Integer): TVector3e;
  protected
    Function IndexOfBody(Identifier: TGUID): Integer; virtual;
  public
    constructor Create(CenterBody: TBody; Mass: Extended; InitialPosition, InitialVelocity: TVector3e);
    destructor Destroy; override;
    procedure AddInteractingBody(Body: TBody); virtual;
    procedure RemoveInteractingBody(Body: TBody); virtual;
    procedure ClearInteractingBodies; virtual;
    procedure CalculateVectors(TimeDelta: LongWord = def_TimeStep); virtual;
    procedure MoveByVector(TimeDelta: LongWord = def_TimeStep); virtual;
    procedure MakeTrail; virtual;
    property CenterBody: TBody read fCenterBody;
    property Identifier: TGUID read fIdentifier;
    property Name: String read fName write fName;
    property ReducedValues: Boolean read fReducedValues write fReducedValues;
    property Mass: Extended read fMass write fMass;
    property Position: TVector3e read fPosition write fPosition;
    property PositionX: Extended read fPosition[0] write fPosition[0];
    property PositionY: Extended read fPosition[1] write fPosition[1];
    property PositionZ: Extended read fPosition[2] write fPosition[2];
    property Velocity: TVector3e read fVelocity write fVelocity;
    property VelocityX: Extended read fVelocity[0] write fVelocity[0];
    property VelocityY: Extended read fVelocity[1] write fVelocity[1];
    property VelocityZ: Extended read fVelocity[2] write fVelocity[2];
    property Acceleration: TVector3e read fAcceleration write fAcceleration;
    property AccelerationX: Extended read fAcceleration[0] write fAcceleration[0];
    property AccelerationY: Extended read fAcceleration[1] write fAcceleration[1];
    property AccelerationZ: Extended read fAcceleration[2] write fAcceleration[2];
    property ElapsedTime: Int64 read fElapsedTime;
    property InteractingBodies[Index: Integer]: TBody read GetInteractingBody;
    property InteractingBodiesCount: Integer read GetInteractingBodiesCount;
    property Data: Pointer read fData write fData;
    property StoreTrail: Boolean read fStoreTrail write SetStoreTrail;
    property TrailTime: Int64 read fTrailTime write SetTrailTime;
    property TrailStep: Int64 read fTrailStep;
    property TrailCount: Integer read fTrailCount;
    property Trail[Index: Integer]: TVector3e read GetTrail;
  end;
  
//==============================================================================  

  TBodyEvent = procedure(Sender: TObject; Body: TBody) of object;

  TOrbitalSystem = class(TObject)
  private
    fElapsedTime:   Int64;
    fBodies:        Array of TBody;
    fOnBodyCreate:  TBodyEvent;
    fOnBodyDestroy: TBodyEvent;
    Function GetBody(Index: Integer): TBody;
    Function GetBodiesCount: Integer;
  protected
    Function CheckDistances(Body: TBody): Boolean; virtual;
    procedure AddInteractingBodyToSystem(Body: TBody); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    Function IndexOfBody(Body: TBody): Integer; overload; virtual;
    Function IndexOfBody(BodyIdentifier: TGUID): Integer; overload; virtual;
    Function IndexOfBody(BodyName: String): Integer; overload; virtual;
    Function AddBody(CenterBody: TBody; Mass: Extended; InitialPosition, InitialVelocity: TVector3e): TBody; overload; virtual;
    Function AddBody(CenterBodyIdx: Integer; Mass: Extended; InitialPosition, InitialVelocity: TVector3e): TBody; overload; virtual;
    Function RemoveBody(Body: TBody): Integer; virtual;
    procedure DeleteBody(Index: Integer); virtual;
    procedure ClearBodies; virtual;
    procedure ProcessStep(TimeDelta: LongWord = def_TimeStep); virtual;
    procedure SetReducedMode(Active: Boolean);
    property ElapsedTime: Int64 read fElapsedTime;
    property Bodies[Index: Integer]: TBody read GetBody;
    property BodiesCount: Integer read GetBodiesCount;
    property OnBodyCreate: TBodyEvent read fOnBodyCreate write fOnBodyCreate;
    property OnBodyDestroy: TBodyEvent read fOnBodyDestroy write fOnBodyDestroy;
  end;

  Function Vector3e(X,Y,Z: Extended): TVector3e;
  Function Vector3eToStr(Vector: TVector3e; Rounding: Integer = MAXINT): String;
  Function AddVectors(Vec1,Vec2: TVector3e): TVector3e;
  Function SubstractVectors(Vec1,Vec2: TVector3e): TVector3e;
  Function VectorScalarMultiply(Vector: TVector3e; Scalar: Extended): TVector3e;
  Function PointsDistance(Pt1,Pt2: TVector3e): Extended;
  Function VectorMagnitude(Vector: TVector3e): Extended;
  Function OppositeVector(Vector: TVector3e): TVector3e;

implementation

uses
  SysUtils, Math;

Function Vector3e(X,Y,Z: Extended): TVector3e;
begin
Result[0] := X;
Result[1] := Y;
Result[2] := Z;
end;

//------------------------------------------------------------------------------

Function Vector3eToStr(Vector: TVector3e; Rounding: Integer = MAXINT): String;
begin
If Rounding < MAXINT then
  Result := '[X: ' + FloatToStr(RoundTo(Vector[0],Rounding)) +
           '; Y: ' + FloatToStr(RoundTo(Vector[1],Rounding)) +
           '; Z: ' + FloatToStr(RoundTo(Vector[2],Rounding)) + ']'
else
  Result := '[X: ' + FloatToStr(Vector[0]) +
           '; Y: ' + FloatToStr(Vector[1]) +
           '; Z: ' + FloatToStr(Vector[2]) + ']';
end;

//------------------------------------------------------------------------------

Function AddVectors(Vec1,Vec2: TVector3e): TVector3e;
begin
Result[0] := Vec1[0] + Vec2[0];
Result[1] := Vec1[1] + Vec2[1];
Result[2] := Vec1[2] + Vec2[2];
end;

Function SubstractVectors(Vec1,Vec2: TVector3e): TVector3e;
begin
Result[0] := Vec1[0] - Vec2[0];
Result[1] := Vec1[1] - Vec2[1];
Result[2] := Vec1[2] - Vec2[2];
end;

//------------------------------------------------------------------------------

Function VectorScalarMultiply(Vector: TVector3e; Scalar: Extended): TVector3e;
begin
Result[0] := Vector[0] * Scalar;
Result[1] := Vector[1] * Scalar;
Result[2] := Vector[2] * Scalar;
end;

//------------------------------------------------------------------------------

Function PointsDistance(Pt1,Pt2: TVector3e): Extended;
begin
Result := Sqrt(Sqr(Pt1[0] - Pt2[0]) + Sqr(Pt1[1] - Pt2[1]) + Sqr(Pt1[2] - Pt2[2]));
end;

//------------------------------------------------------------------------------

Function VectorMagnitude(Vector: TVector3e): Extended;
begin
Result := Sqrt(Sqr(Vector[0]) + Sqr(Vector[1]) + Sqr(Vector[2]));
end;

//------------------------------------------------------------------------------

Function OppositeVector(Vector: TVector3e): TVector3e;
begin
Result[0] := -Vector[0];
Result[1] := -Vector[1];
Result[2] := -Vector[2];
end;

//==============================================================================
//******************************************************************************
//==============================================================================

Function TBody.GetInteractingBody(Index: Integer): TBody;
begin
If (Index >= Low(fInteractingBodies)) and (Index <= High(fInteractingBodies)) then
  Result := fInteractingBodies[Index]
else raise Exception.Create('TBody.GetInteractingBody: Index (' + IntToStr(Index) + ') out of bounds.');
end;

//------------------------------------------------------------------------------

Function TBody.GetInteractingBodiesCount: Integer;
begin
Result := Length(fInteractingBodies);
end;

//------------------------------------------------------------------------------

procedure TBody.SetStoreTrail(Value: Boolean);
begin
If Value <> fStoreTrail then
  begin
    If Value then
      begin
        fTrailCount := 0;
        fTrailLast := -fTrailStep + 1;
      end
    else fTrailCount := 0;
    fStoreTrail := Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TBody.SetTrailTime(Value: Int64);
begin
fTrailCount := 0;
fTrailTime := Value;
fTrailStep := Round(Value / cTrailSteps);
fTrailLast := -fTrailStep + 1;
end;

//------------------------------------------------------------------------------

Function TBody.GetTrail(Index: Integer): TVector3e;
begin
If (Index >= 0) and (Index < fTrailCount) then
  Result := fTrail[Index]
else raise Exception.Create('TBody.GetTrail: Index (' + IntToStr(Index) + ') out of bounds.');
end;

//==============================================================================

Function TBody.IndexOfBody(Identifier: TGUID): Integer;
begin
If Length(fInteractingBodies) > 0 then
  For Result := Low(fInteractingBodies) to High(fInteractingBodies) do
    If IsEqualGUID(Identifier,fInteractingBodies[Result].Identifier) then Exit;
Result := -1;
end;

//==============================================================================

constructor TBody.Create(CenterBody: TBody; Mass: Extended; InitialPosition, InitialVelocity: TVector3e);
begin
inherited Create;
fCenterBody := CenterBody;
CreateGUID(fIdentifier);
fName := GUIDToString(fIdentifier);
fReducedValues := True;
fMass := Mass;
If Assigned(CenterBody) then
  begin
    fPosition := AddVectors(InitialPosition,CenterBody.Position);
    fVelocity := AddVectors(InitialVelocity,CenterBody.Velocity);
  end
else
  begin
    fPosition := InitialPosition;
    fVelocity := InitialVelocity;
  end;
fAcceleration := ZeroVector3e;
fElapsedTime := 0;
SetLength(fInteractingBodies,0);
fStoreTrail := True;
SetTrailTime(def_TrailTime);
fTrailCount := 0;
fTrailLast := -fTrailStep + 1;
end;

//------------------------------------------------------------------------------

destructor TBody.Destroy;
begin
ClearInteractingBodies;
inherited;
end;

//------------------------------------------------------------------------------

procedure TBody.AddInteractingBody(Body: TBody);
begin
If not IsEqualGUID(Body.Identifier,Self.Identifier) and (IndexOfBody(Body.Identifier) < 0) then
  begin
    SetLength(fInteractingBodies,Length(fInteractingBodies) + 1);
    fInteractingBodies[High(fInteractingBodies)] := Body;
  end;
end;

//------------------------------------------------------------------------------

procedure TBody.RemoveInteractingBody(Body: TBody);
var
  Index,i:  Integer;
begin
If Body = fCenterBody then fCenterBody := nil;
Index := IndexOfBody(Body.Identifier);
If Index >= 0 then
  begin
    For i := Index to Pred(High(fInteractingBodies)) do
      fInteractingBodies[i] := fInteractingBodies[i + 1];
    SetLength(fInteractingBodies,Length(fInteractingBodies) - 1)
  end;
end;

//------------------------------------------------------------------------------

procedure TBody.ClearInteractingBodies;
begin
SetLength(fInteractingBodies,0);
end;

//------------------------------------------------------------------------------

procedure TBody.CalculateVectors(TimeDelta: LongWord = def_TimeStep);
(*
  Ai = (G * Mj * (Pj - Pi)) / (Rij ^ 3)

  Ai  - resulting acceleration vector
  G   - gravitational constant
  Mj  - mass of interacting body
  Pj  - position vector of interacting body
  Pi  - position vector of this body
  Rij - distance between both bodies
*)
var
  TempAccVector:  TVector3e;
  i,j:            Integer;
  Distance:       Extended;
  BigG:           Extended;
begin
If ReducedValues then BigG := ReducedG
  else BigG := G;
fAcceleration := ZeroVector3e;
For i := Low(fInteractingBodies) to High(fInteractingBodies) do
  begin
    Distance := PointsDistance(fInteractingBodies[i].Position,Self.Position);
    TempAccVector := ZeroVector3e;    
    For j := Low(TVector3e) to High(TVector3e) do
      TempAccVector[j] := (BigG * fInteractingBodies[i].Mass * (fInteractingBodies[i].Position[j] - Self.Position[j])) / Power(Distance,3);
    fAcceleration := AddVectors(fAcceleration,TempAccVector);
  end;
fVelocity := AddVectors(fVelocity,VectorScalarMultiply(fAcceleration,TimeDelta));
end;

//------------------------------------------------------------------------------

procedure TBody.MoveByVector(TimeDelta: LongWord = def_TimeStep);
begin
fPosition := AddVectors(fPosition,VectorScalarMultiply(fVelocity,TimeDelta));
fElapsedTime := fElapsedTime + TimeDelta;
end;

//------------------------------------------------------------------------------

procedure TBody.MakeTrail;
begin
If fStoreTrail then
  If (fElapsedTime - fTrailLast) > fTrailStep then
    begin
      If fTrailCount >= cTrailSteps then
        begin
          fTrailCount := cTrailSteps;
          Move(fTrail[1],fTrail[0],(cTrailSteps - 1) * SizeOf(TVector3e));
        end
      else Inc(fTrailCount);
      If Assigned(fCenterBody) then
        fTrail[Pred(fTrailCount)] := SubstractVectors(fPosition,fCenterBody.Position)
      else
        fTrail[Pred(fTrailCount)] := fPosition;
      fTrailLast := fElapsedTime;
    end;
end;

//==============================================================================
//******************************************************************************
//==============================================================================

Function TOrbitalSystem.GetBody(Index: Integer): TBody;
begin
If Length(fBodies) > 0 then
  begin
    If (Index >= Low(fBodies)) and (Index <= High(fBodies)) then
      Result := fBodies[Index]
    else
      raise Exception.Create('TOrbitalSystem.GetBody: Index (' + IntToStr(Index) + ') out of bounds.');
  end
else Result := nil;
end;

//------------------------------------------------------------------------------

Function TOrbitalSystem.GetBodiesCount: Integer;
begin
Result := Length(fBodies);
end;

//==============================================================================

Function TOrbitalSystem.CheckDistances(Body: TBody): Boolean;
var
  i:  Integer;
begin
Result := True;
For i := Low(fBodies) to High(fBodies) do
  If PointsDistance(fBodies[i].Position,Body.Position) = 0 then
    begin
      Result := False;
      Break;
    end;
end;

//------------------------------------------------------------------------------

procedure TOrbitalSystem.AddInteractingBodyToSystem(Body: TBody);
var
  i:  Integer;
begin
For i := Low(fBodies) to High(fBodies) do
  begin
    fBodies[i].AddInteractingBody(Body);
    Body.AddInteractingBody(fBodies[i]);
  end;
end;

//==============================================================================

constructor TOrbitalSystem.Create;
begin
inherited Create;
fElapsedTime := 0;
SetLength(fBodies,0);
end;

//------------------------------------------------------------------------------

destructor TOrbitalSystem.Destroy;
begin
ClearBodies;
inherited;
end;

//------------------------------------------------------------------------------

Function TOrbitalSystem.IndexOfBody(Body: TBody): Integer;
begin
If Length(fBodies) > 0 then
  For Result := Low(fBodies) to High(fBodies) do
    If fBodies[Result] = Body then Exit;
Result := -1;
end;

//---                                                                        ---

Function TOrbitalSystem.IndexOfBody(BodyIdentifier: TGUID): Integer;
begin
If Length(fBodies) > 0 then
  For Result := Low(fBodies) to High(fBodies) do
    If IsEqualGUID(fBodies[Result].Identifier, BodyIdentifier) then Exit;
Result := -1;
end;

//---                                                                        ---

Function TOrbitalSystem.IndexOfBody(BodyName: String): Integer;
begin
If Length(fBodies) > 0 then
  For Result := Low(fBodies) to High(fBodies) do
    If AnsiSameText(fBodies[Result].Name, BodyName) then Exit;
Result := -1;
end;

//------------------------------------------------------------------------------

Function TOrbitalSystem.AddBody(CenterBody: TBody; Mass: Extended; InitialPosition, InitialVelocity: TVector3e): TBody;
begin
Result := nil;
If Assigned(CenterBody) and (IndexOfBody(CenterBody) < 0) then
  raise Exception.Create('TOrbitalSystem.AddBody: Passed CenterBody is not in list of system bodies.');
Result := TBody.Create(CenterBody,Mass,InitialPosition,InitialVelocity);
If not CheckDistances(Result) then
  begin
    FreeAndNil(Result);
    raise Exception.Create('TOrbitalSystem.AddBody: Detected zero distance to other body.');
  end;
SetLength(fBodies,Length(fBodies) + 1);
fBodies[High(fBodies)] := Result;
AddInteractingBodyToSystem(Result);
If Assigned(fOnBodyCreate) then fOnBodyCreate(Self,Result); 
end;

//---                                                                        ---

Function TOrbitalSystem.AddBody(CenterBodyIdx: Integer; Mass: Extended; InitialPosition, InitialVelocity: TVector3e): TBody;
begin
If (Length(fBodies) > 0) and (CenterBodyIdx >= Low(fBodies)) and (CenterBodyIdx <= High(fBodies)) then
  Result := AddBody(fBodies[CenterBodyIdx],Mass,InitialPosition,InitialVelocity)
else
  Result := AddBody(nil,Mass,InitialPosition,InitialVelocity);
end;

//------------------------------------------------------------------------------

Function TOrbitalSystem.RemoveBody(Body: TBody): Integer;
begin
Result := IndexOfBody(Body);
If Result >= 0 then DeleteBody(Result);
end;

//------------------------------------------------------------------------------

procedure TOrbitalSystem.DeleteBody(Index: Integer);
var
  i:  Integer;
begin
If Length(fBodies) > 0 then
  begin
    If (Index >= Low(fBodies)) and (Index <= High(fBodies)) then
      begin
        For i := Low(fBodies) to High(fBodies) do
          fBodies[i].RemoveInteractingBody(fBodies[Index]);
        If Assigned(fOnBodyDestroy) then fOnBodyDestroy(Self,fBodies[Index]);
        fBodies[Index].Free;
        For i := Index to Pred(High(fBodies)) do
          fBodies[i] := fBodies[i + 1];
        SetLength(fBodies,Length(fBodies) - 1)
      end
    else
      raise Exception.Create('TOrbitalSystem.DeleteBody: Index (' + IntToStr(Index) + ') out of bounds.');
  end;
end;

//------------------------------------------------------------------------------

procedure TOrbitalSystem.ClearBodies;
var
  i:  Integer;
begin
For i := Low(fBodies) to High(fBodies) do
  begin
    If Assigned(fOnBodyDestroy) then fOnBodyDestroy(Self,fBodies[i]);
    fBodies[i].Free;
  end;
fElapsedTime := 0;
SetLength(fBodies,0);
end;

//------------------------------------------------------------------------------

procedure TOrbitalSystem.ProcessStep(TimeDelta: LongWord = def_TimeStep);
var
  i:  Integer;
begin
For i := Low(fBodies) to High(fBodies) do
  fBodies[i].CalculateVectors(TimeDelta);
For i := Low(fBodies) to High(fBodies) do
  fBodies[i].MoveByVector(TimeDelta);
For i := Low(fBodies) to High(fBodies) do
  fBodies[i].MakeTrail;  
fElapsedTime := fElapsedTime + TimeDelta;
end;

//------------------------------------------------------------------------------

procedure TOrbitalSystem.SetReducedMode(Active: Boolean);
var
  i:  Integer;
begin
For i := Low(fBodies) to High(fBodies) do
  fBodies[i].ReducedValues := Active;
end;   

end.

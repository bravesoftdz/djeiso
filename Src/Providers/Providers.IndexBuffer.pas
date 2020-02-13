unit Providers.IndexBuffer;

interface

uses
  Providers.Types;

type
  TIndexBuffer = class
  private
    FPosition: array of Integer;
    FIndexLength: array of Integer;
    FType: array of TJSONTokens;
    FCount: Integer;

    function GetIndexLength(AIndex: Integer): Integer;
    function GetPosition(AIndex: Integer): Integer;
    procedure SetIndexLength(AIndex: Integer; const Value: Integer);
    procedure SetPosition(AIndex: Integer; const Value: Integer);
    function GetType(AIndex: Integer): TJSONTokens;
    procedure SetType(AIndex: Integer; const Value: TJSONTokens);

    procedure IncSize(ATo: Integer);
  public
    property Position[AIndex: Integer]: Integer read GetPosition write SetPosition;
    property IndexLength[AIndex: Integer]: Integer read GetIndexLength write SetIndexLength;
    property &Type[AIndex: Integer]: TJSONTokens read GetType write SetType;
    property Count: Integer read FCount;
  end;

implementation

{ TIndexBuffer }

function TIndexBuffer.GetIndexLength(AIndex: Integer): Integer;
begin
  Result := FIndexLength[AIndex];
end;

function TIndexBuffer.GetPosition(AIndex: Integer): Integer;
begin
  Result := FPosition[AIndex];
end;

function TIndexBuffer.GetType(AIndex: Integer): TJSONTokens;
begin
  Result := FType[AIndex];
end;

procedure TIndexBuffer.IncSize(ATo: Integer);
begin
  if ATo > Length(FIndexLength) - 1 then
  begin
    SetLength(FIndexLength, ATo + 1);
    SetLength(FPosition, ATo + 1);
    SetLength(FType, ATo + 1);
    FCount := ATo + 1;
  end;
end;

procedure TIndexBuffer.SetIndexLength(AIndex: Integer; const Value: Integer);
begin
  IncSize(AIndex);
  FIndexLength[AIndex] := Value;
end;

procedure TIndexBuffer.SetPosition(AIndex: Integer; const Value: Integer);
begin
  IncSize(AIndex);
  FPosition[AIndex] := Value;
end;

procedure TIndexBuffer.SetType(AIndex: Integer; const Value: TJSONTokens);
begin
  IncSize(AIndex);
  FType[AIndex] := Value;
end;

end.

unit JSON.Parser;

interface

{$SCOPEDENUMS ON}

uses
  JSON.Types, Providers.IndexBuffer, Providers.DataBuffer, Providers.Types;

type
  TJSONTokenizerContext = record
  var
    StateStack: array [Byte] of TJSONStates;
    StateIndex: Byte;

    DataPosition: Int64;
    ElementIndex: Int64;

    function Create: TJSONTokenizerContext;

    procedure PushState(ANew: TJSONStates);
    procedure PutState(ANew: TJSONStates);
    function PopState: TJSONStates;
    procedure IncElementIndex;
    procedure IncDataPosition(AN: Integer = 1);
  end;

  TJSONTokenizer = class
  private
    FContext: TJSONTokenizerContext;
    FIndexBuffer: TIndexBuffer;
    FDataBuffer: TDataBuffer;

    function GetChar(AJSON: TDataBuffer; AIndex: Integer): Char;

    procedure ParseNumber(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
    procedure ParseTrue(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
    procedure ParseFalse(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
    procedure ParseNull(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);

    procedure SetElementDataLength1(AIndexBuffer: TIndexBuffer; AType: TJSONTokens; APosition: Integer);
    procedure SetElementDataNoLength(AIndexBuffer: TIndexBuffer; AType: TJSONTokens; APosition: Integer);
    procedure SetElementData(AIndexBuffer: TIndexBuffer; AType: TJSONTokens; APosition: Integer; ALength: Integer);
  public
    property Context: TJSONTokenizerContext read FContext write FContext;

    procedure Parse(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
  end;

implementation

{ TJSONTokenizer }

function TJSONTokenizer.GetChar(AJSON: TDataBuffer; AIndex: Integer): Char;
begin
  Result := AJSON.Data[AIndex];
end;

procedure TJSONTokenizer.Parse(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
var
  LChar: Char;
begin
  Context.PutState(TJSONStates.FIELD_NAME);

  while Context.DataPosition < AJSON.Count - 1 do
  begin
    LChar := AJSON.Data[Context.DataPosition];

    case LChar of
      '{':
        begin
          SetElementDataLength1(AIndexBuffer, TJSONTokens.JSON_OBJECT_START, Context.DataPosition);
          Context.IncElementIndex;
          Context.PushState(TJSONStates.&OBJECT);
          Context.PutState(TJSONStates.FIELD_NAME);
        end;

      '}':
        begin
          SetElementDataLength1(AIndexBuffer, TJSONTokens.JSON_OBJECT_END, Context.DataPosition);
          Context.IncElementIndex;
          Context.PopState;
        end;

      '[':
        begin
          SetElementDataLength1(AIndexBuffer, TJSONTokens.JSON_ARRAY_START, Context.DataPosition);
          Context.IncElementIndex;
          Context.PushState(TJSONStates.&ARRAY);
          Context.PutState(TJSONStates.FIELD_VALUE);
        end;

      ']':
        begin
          SetElementDataLength1(AIndexBuffer, TJSONTokens.JSON_ARRAY_END, Context.DataPosition);
          Context.IncElementIndex;
          Context.PopState;
        end;

      't':
        begin
          ParseTrue(AJSON, AIndexBuffer);
          Context.IncElementIndex;
        end;
      'f':
        begin
          ParseFalse(AJSON, AIndexBuffer);
          Context.IncElementIndex;
        end;
      'n':
        begin
          ParseNull(AJSON, AIndexBuffer);
          Context.IncElementIndex;
        end;

      '0'.. '9':
        begin
           ParseNumber(AJSON, AIndexBuffer);
           Context.IncElementIndex;
        end;
      ':': Context.PutState(TJSONStates.FIELD_VALUE);
      ',':
        begin
          if Context.StateStack[Context.StateIndex - 1] = TJSONStates.&ARRAY then
            Context.PutState(TJSONStates.FIELD_VALUE)
          else
            Context.PutState(TJSONStates.FIELD_NAME);
        end;



    end;

    Context.IncDataPosition();
  end;
end;

procedure TJSONTokenizer.ParseFalse(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
var
  LCurrentPosition: Integer;
begin
  LCurrentPosition := Context.DataPosition;
  if (GetChar(AJSON, LCurrentPosition + 1) = 'a')
    and (GetChar(AJSON, LCurrentPosition + 2) = 'l')
    and (GetChar(AJSON, LCurrentPosition + 3) = 's')
    and (GetChar(AJSON, LCurrentPosition + 4) = 'e') then
  begin
    if Context.StateStack[Context.StateIndex - 1] = TJSONStates.&OBJECT then
        setElementData(AIndexBuffer, TJSONTokens.JSON_PROPERTY_VALUE_BOOLEAN, LCurrentPosition, 5)
    else
      setElementData(AIndexBuffer, TJSONTokens.JSON_ARRAY_VALUE_BOOLEAN, LCurrentPosition, 5);

    Context.IncDataPosition(4);
  end;

end;

procedure TJSONTokenizer.ParseNull(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
var
  LCurrentPosition: Integer;
begin
  LCurrentPosition := Context.DataPosition;
  if (GetChar(AJSON, LCurrentPosition + 1) = 'u')
    and (GetChar(AJSON, LCurrentPosition + 2) = 'l')
    and (GetChar(AJSON, LCurrentPosition + 3) = 'l') then
  begin
    if Context.StateStack[Context.StateIndex - 1] = TJSONStates.&OBJECT then
        SetElementDataNoLength(AIndexBuffer, TJSONTokens.JSON_PROPERTY_VALUE_NULL, LCurrentPosition)
    else
      SetElementDataNoLength(AIndexBuffer, TJSONTokens.JSON_ARRAY_VALUE_NULL, LCurrentPosition);

    Context.IncDataPosition(3);
  end;
end;

procedure TJSONTokenizer.ParseNumber(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
var
  LTempPosition: Integer;
  IsEndOfNumber: Boolean;
begin
  IsEndOfNumber := False;
  LTempPosition := Context.DataPosition;
  while not IsEndOfNumber do
  begin
    Inc(LTempPosition);
    if not (AJSON.Data[LTempPosition] in ['0' .. '1', '.']) then
      IsEndOfNumber := True;
  end;
  if Context.StateStack[Context.StateIndex - 1] = TJSONStates.&OBJECT then
    SetElementData(AIndexBuffer, TJSONTokens.JSON_PROPERTY_VALUE_NUMBER, Context.DataPosition,
      LTempPosition - Context.DataPosition)
  else
    SetElementData(AIndexBuffer, TJSONTokens.JSON_ARRAY_VALUE_BOOLEAN, Context.DataPosition,
      LTempPosition - Context.DataPosition);

  Context.IncDataPosition(LTempPosition - Context.DataPosition - 1);
end;

procedure TJSONTokenizer.ParseTrue(AJSON: TDataBuffer; AIndexBuffer: TIndexBuffer);
var
  LCurrentPosition: Integer;
begin
  LCurrentPosition := Context.DataPosition;
  if (GetChar(AJSON, LCurrentPosition + 1) = 'r')
    and (GetChar(AJSON, LCurrentPosition + 2) = 'u')
    and (GetChar(AJSON, LCurrentPosition + 3) = 'e') then
  begin
    if Context.StateStack[Context.StateIndex - 1] = TJSONStates.&OBJECT then
        setElementData(AIndexBuffer, TJSONTokens.JSON_PROPERTY_VALUE_BOOLEAN, LCurrentPosition, 4)
    else
      setElementData(AIndexBuffer, TJSONTokens.JSON_ARRAY_VALUE_BOOLEAN, LCurrentPosition, 4);

    Context.IncDataPosition(3);
  end;
end;

procedure TJSONTokenizer.SetElementData(AIndexBuffer: TIndexBuffer; AType: TJSONTokens; APosition: Integer; ALength: Integer);
begin
  AIndexBuffer.&Type[Context.ElementIndex] := AType;
  AIndexBuffer.Position[Context.ElementIndex] := APosition;
  AIndexBuffer.IndexLength[Context.ElementIndex] := ALength;
end;

procedure TJSONTokenizer.SetElementDataLength1(AIndexBuffer: TIndexBuffer; AType: TJSONTokens; APosition: Integer);
begin
  AIndexBuffer.&Type[Context.ElementIndex] := AType;
  AIndexBuffer.Position[Context.ElementIndex] := APosition;
  AIndexBuffer.IndexLength[Context.ElementIndex] := 1;
end;

procedure TJSONTokenizer.SetElementDataNoLength(AIndexBuffer: TIndexBuffer; AType: TJSONTokens; APosition: Integer);
begin
  AIndexBuffer.&Type[Context.ElementIndex] := AType;
  AIndexBuffer.Position[Context.ElementIndex] := APosition;
  AIndexBuffer.IndexLength[Context.ElementIndex] := 0;
end;

{ TJSONTokenizerContext }

function TJSONTokenizerContext.Create: TJSONTokenizerContext;
begin
  Result.StateIndex := 0;
  Result.DataPosition := 0;
  Result.ElementIndex := 0;
end;

procedure TJSONTokenizerContext.IncDataPosition(AN: Integer);
begin
  Inc(Self.DataPosition, AN);
end;

procedure TJSONTokenizerContext.IncElementIndex;
begin
  Inc(Self.ElementIndex);
end;

function TJSONTokenizerContext.PopState: TJSONStates;
begin
  Dec(Self.StateIndex)
end;

procedure TJSONTokenizerContext.PushState(ANew: TJSONStates);
begin
  PutState(ANew);
  Inc(Self.StateIndex);
end;

procedure TJSONTokenizerContext.PutState(ANew: TJSONStates);
begin
  Self.StateStack[Self.StateIndex] := ANew;
end;

end.

unit JSON.Types;

interface

uses
  System.Generics.Collections;

type
  IJSONType = interface
    ['{79948817-3650-45D8-B7C6-CF07BAD98930}']

    function ToString: string;
  end;

  TJSONString = class(TInterfacedObject, IJSONType)
  private
    FValue: string;
  public
    function ToString: string;
    procedure Parse(AJSON: String);
  end;

  TJSONNumber = class(TInterfacedObject, IJSONType)
    FNumber: Double;
  public
    function ToString: string;
    procedure Parse(AJSON: String);
  end;

  TJSONObject = class(TInterfacedObject, IJSONType)
  private
    FValue: TDictionary<string, IJSONType>;
  public
    function ToString: string;
    constructor Create;
    destructor Destroy; override;
    procedure Parse(AJSON: String);
  end;

  TJSONArray = class(TInterfacedObject, IJSONType)
  private
    FValue: array of IJSONType;
  public
    function ToString: string;
    procedure Parse(AJSON: String);
  end;

  TJSONBoolean = class(TInterfacedObject, IJSONType)
  private
    FValue: Boolean;
    const
    TRUE_JSON = 'true';
    FALSE_JSON = 'false';
  public
    function ToString: string;
    procedure Parse(AJSON: String);
  end;

  TJSONNull = class(TInterfacedObject, IJSONType)
  public
    function ToString: string;
    procedure Parse(AJSON: String);
  end;

function test: IJSONType;

implementation

uses
  System.SysUtils;

function test: IJSONType;
var
  LTest: TJSONObject;
  LTemp: IJSONType;
begin
  LTest := TJSONObject.Create;
  LTest.FValue.Add('Null', TJSONNull.Create);

  LTemp := TJSONString.Create;
  TJSONString(LTemp).FValue := 'Rodrigo Bernardi';
  LTest.FValue.Add('String', LTemp);

  LTemp := TJSONBoolean.Create;
  TJSONBoolean(LTemp).FValue := True;
  LTest.FValue.Add('bool', LTemp);

  LTemp := TJSONNumber.Create;
  TJSONNumber(LTemp).FNumber := 1.23456;
  LTest.FValue.Add('num', LTemp);

  LTemp := TJSONNumber.Create;
  TJSONNumber(LTemp).FNumber := 123456;
  LTest.FValue.Add('num_int', LTemp);

  LTemp := TJSONArray.Create;
  TJSONArray(LTemp).FValue := [LTest.FValue['bool'], LTest.FValue['String']];
  LTest.FValue.Add('array', LTemp);

  Result := LTest;
end;

{ TJSONObject }

constructor TJSONObject.Create;
begin
  FValue := TDictionary<string, IJSONType>.Create();
end;

destructor TJSONObject.Destroy;
begin
  FValue.Free;
  inherited;
end;

procedure TJSONObject.Parse(AJSON: String);
begin

end;

function TJSONObject.ToString: string;
var
  LItem: TPair<string, IJSONType>;
  LIsFirst: Boolean;
begin
  LIsFirst := True;
  Result := '{';
  for LItem in FValue do
  begin
    if not LIsFirst then
      Result := Result + ',';

    Result := Result + '"' + LItem.Key + '": ' + LItem.Value.ToString;

    LIsFirst := False;
  end;
  Result := Result + '}';
end;

{ TJSONBoolean }

procedure TJSONBoolean.Parse(AJSON: String);
begin
  FValue := AJSON = 'true';
end;

function TJSONBoolean.ToString: string;
begin
  if FValue then
    Exit(TRUE_JSON)
  else
    Exit(FALSE_JSON);
end;

{ TJSONArray }

procedure TJSONArray.Parse(AJSON: String);
begin

end;

function TJSONArray.ToString: string;
var
  LItem: IJSONType;
  LIsFirst: Boolean;
begin
  Result := '[';
  LIsFirst := True;

  for LItem in FValue do
  begin
    if not LIsFirst then
      Result := Result + ',';

    Result := Result + LItem.ToString;
    LIsFirst := False;
  end;

  Result := Result + ']';
end;

{ TJSONString }

procedure TJSONString.Parse(AJSON: String);
begin

end;

function TJSONString.ToString: string;
begin
  Result := '"' + FValue + '"';
end;

{ TJSONNumber }

procedure TJSONNumber.Parse(AJSON: String);
begin

end;

function TJSONNumber.ToString: string;
begin
  Result := FloatToStr(FNumber, TFormatSettings.Invariant);
end;

{ TJSONNull }

procedure TJSONNull.Parse(AJSON: String);
begin
//
end;

function TJSONNull.ToString: string;
begin
  Result := 'null';
end;

end.

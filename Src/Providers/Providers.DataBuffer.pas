unit Providers.DataBuffer;

interface

type
  TDataBuffer = class
  public
    Data: string;
    Count: Integer;
    constructor Create(AData: string); overload;
    constructor Create(ACount: Integer); overload;
    constructor Create; overload;
  end;

implementation

{ TDataBuffer }

constructor TDataBuffer.Create(AData: string);
begin
  Data := AData;
  Count := Length(Data);
end;

constructor TDataBuffer.Create(ACount: Integer);
begin
  Count := ACount;
end;

constructor TDataBuffer.Create;
begin
  Count := 0;
end;

end.

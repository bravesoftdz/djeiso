unit Providers.IndexBuffer;

interface

uses
  Providers.Types;

type
  TIndexBuffer = class
    Position: array of Integer;
    IndexLength: array of Integer;
    &Type: array of TJSONTokens;
    Count: Integer;
    constructor Create(ACapacity: Integer; AUseTypeArray: Boolean);
  end;

implementation

{ TIndexBuffer }

constructor TIndexBuffer.Create(ACapacity: Integer; AUseTypeArray: Boolean);
begin
  SetLength(Self.Position, ACapacity);
  SetLength(Self.IndexLength, ACapacity);
  if AUseTypeArray then
    SetLength(Self.&Type, ACapacity);
end;

end.

program Sample;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  IOUtils,
  JSON.Types in '..\Src\JSON.Types.pas',
  JSON in '..\Src\JSON.pas',
  JSON.Parser in '..\Src\JSON.Parser.pas',
  Providers.IndexBuffer in '..\Src\Providers\Providers.IndexBuffer.pas',
  Providers.DataBuffer in '..\Src\Providers\Providers.DataBuffer.pas',
  Providers.Types in '..\Src\Providers\Providers.Types.pas', Winapi.Windows;

const
  JSON_DEMO = '' + '{' + '"Actors": [' + '{' + '"name": "Tom Cruise",' + '"age": 56,' + '"Born At": "Syracuse, NY",' +
    '"Birthdate": "July 3, 1962",' + '"photo": "https://jsonformatter.org/img/tom-cruise.jpg",' + '"wife": null,' +
    '"weight": 67.5,' + '"hasChildren": true,' + '"hasGreyHair": false,' + '"children": [' + '"Suri",' +
    '"Isabella Jane",' + '"Connor"' + ']' + '},' + '{' + '"name": "Robert Downey Jr.",' + '"age": 53,' +
    '"Born At": "New York City, NY",' + '"Birthdate": "April 4, 1965",' +
    '"photo": "https://jsonformatter.org/img/Robert-Downey-Jr.jpg",' + '"wife": "Susan Downey",' + '"weight": 77.1,' +
    '"hasChildren": true,' + '"hasGreyHair": false,' + '"children": [' + '"Indio Falconer",' + '"Avri Roel",' +
    '"Exton Elias"' + ']' + '}' + ']' + '}';

  JSON_2 = '{"asd":[1,2]}';

function ReadFromFile(AFile: string): string;
begin
  Result := TFile.ReadAllText(AFile);
end;

var
  LT: TJSONTokenizer;
  LData: TDataBuffer;
  LIndexes: TIndexBuffer;
  c1, c2, f: Int64;

begin
  try
    LT := TJSONTokenizer.Create;

    LIndexes := TIndexBuffer.Create;
    LData := TDataBuffer.Create(JSON_DEMO);
    // ReadFromFile('C:\Users\color\Documents\projetos\delphi\djeiso\sample\Win32\citylots.json')
    QueryPerformanceFrequency(f);
    QueryPerformanceCounter(c1);

    LT.Parse(LData, LIndexes);
    QueryPerformanceCounter(c2);
    Writeln(FloatToStr((c2 - c1) / f) + 'secs');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

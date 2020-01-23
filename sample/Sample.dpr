program Sample;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  JSON.Types in '..\Src\JSON.Types.pas',
  JSON in '..\Src\JSON.pas';

const
JSON_DEMO = '' + '{' + '"Actors": [' + '{' + '"name": "Tom Cruise",' + '"age": 56,' + '"Born At": "Syracuse, NY",' +
  '"Birthdate": "July 3, 1962",' + '"photo": "https://jsonformatter.org/img/tom-cruise.jpg",' + '"wife": null,' +
  '"weight": 67.5,' + '"hasChildren": true,' + '"hasGreyHair": false,' + '"children": [' + '"Suri",' +
  '"Isabella Jane",' + '"Connor"' + ']' + '},' + '{' + '"name": "Robert Downey Jr.",' + '"age": 53,' +
  '"Born At": "New York City, NY",' + '"Birthdate": "April 4, 1965",' +
  '"photo": "https://jsonformatter.org/img/Robert-Downey-Jr.jpg",' + '"wife": "Susan Downey",' + '"weight": 77.1,' +
  '"hasChildren": true,' + '"hasGreyHair": false,' + '"children": [' + '"Indio Falconer",' + '"Avri Roel",' +
  '"Exton Elias"' + ']' + '}' + ']' + '}';

begin
  try
    Writeln(ReadJSON(JSON_DEMO).ToString);
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

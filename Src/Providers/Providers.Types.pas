unit Providers.Types;

interface

type
  TJSONTokens = (JSON_OBJECT_START, //
    JSON_OBJECT_END, // }
    JSON_ARRAY_START, // [
    JSON_ARRAY_VALUE_STRING, //
    JSON_ARRAY_VALUE_STRING_ENC, // String with encoded characters, like \t or \u2345
    JSON_ARRAY_VALUE_NUMBER, // [
    JSON_ARRAY_VALUE_BOOLEAN, // [
    JSON_ARRAY_VALUE_NULL, // [
    JSON_ARRAY_END, // ]
    JSON_PROPERTY_NAME, //
    JSON_PROPERTY_VALUE_STRING, //
    JSON_PROPERTY_VALUE_STRING_ENC, // String with encoded characters, like \t or \u2345
    JSON_PROPERTY_VALUE_NUMBER, //
    JSON_PROPERTY_VALUE_BOOLEAN, //
    JSON_PROPERTY_VALUE_NULL //
    );

  TJSONStates = (FIELD_NAME, FIELD_VALUE, &OBJECT, &ARRAY);

implementation

end.

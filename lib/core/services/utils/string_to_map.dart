import 'dart:convert';

Map<String, dynamic> stringToMap(String inputString) {
  try {
    Map<String, dynamic> jsonMap = jsonDecode(inputString);
    return jsonMap;
  } catch (e) {
    print("Invalid JSON string");
    return {};
  }
}

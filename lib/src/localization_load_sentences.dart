import 'dart:convert';

void loadSentencesByJsonString(String data, Map<String, String> output) {
  late Map<String, dynamic> result;
  try {
    result = json.decode(data);
  } catch (e) {
    print("[Error] load json data fail $e");
    result = {};
  }
  void inner(Map<String, dynamic> node, String keyPrefix) {
    node.forEach((nodeKey, nodeValue) {
      if (nodeValue == null) return;
      String key = keyPrefix;
      if (keyPrefix == "") {
        key = key + nodeKey;
      } else {
        key = key + "." + nodeKey;
      }
      if (nodeValue is String) {
        output[key] = nodeValue;
        return;
      } else if (nodeValue is Map<String, dynamic>) {
        inner(nodeValue, key);
        return;
      } else {
        print("[Warning]load sentences BAD node: `$nodeKey`");
      }
    });
  }

  inner(result, "");
}

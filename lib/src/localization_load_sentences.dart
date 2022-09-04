import 'dart:convert';

Future loadSentencesByJsonString(String data, Map<String, String> output) async {
  late Map<String, dynamic> result;

  try {
    result = json.decode(data);
  } catch (e) {
    result = {};
  }
  void inner(Map<String, dynamic> node, String keyPrefix) {
    node.forEach((nodeKey, nodeValue) {
      if (nodeValue == null) return;
      if (nodeValue is String) {
        final key = keyPrefix + "." + nodeKey;
        output[key] = nodeValue;
        return;
      } else if (nodeValue is Map<String, dynamic>) {
        inner(nodeValue, nodeKey);
        return;
      } else {
        print("load sentences warning: `$nodeKey`");
      }
    });
  }

  inner(result, "");
}

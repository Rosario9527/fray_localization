import 'dart:io';
import 'src/localization_load_sentences.dart';

void generateStaticDeclareClass(Map<String, dynamic> config) async {
  final sources = config['sources'] as List<String>;
  final destination = config['destination'];
  final destPath = destination['path'];
  final destClassName = destination['classname'];

  print("Generate Start.");
  print("sources: `${sources.join(",")}`");
  print("destination path: `$destPath` classname: `$destClassName`");

  final sentences = <String, String>{};
  for (var i = 0; i < sources.length; i++) {
    final filepath = sources[i];
    final data = File(filepath).readAsStringSync();
    loadSentencesByJsonString(data, sentences);
  }

  final file = File(destPath);
  List<String> content = [];
  final now = DateTime.now();
  content.add("// DO NOT edit this file! It's Auto Generated.");
  content.add("// Generated At: ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second} ");
  content.add("class $destClassName {");
  sentences.forEach((key, _) {
    final variableName = key.toUpperCase().replaceAll(".", "_");
    final varibaleValue = "\"" + "$key".replaceAll("\$", "\\\$") + "\";";
    content.add("\t static const $variableName = $varibaleValue");
  });
  content.add("}");
  final str = content.join("\n");
  await file.writeAsString(str);
  print('Generate Success.');
}

import 'dart:io';

import '../lib/cli_commands.dart';
import 'package:yaml/yaml.dart';

void main() {
  _generate();
}

Map<String, dynamic> _getConfig() {
  final String filePath = 'pubspec.yaml';
  final Map yamlMap = loadYaml(File(filePath).readAsStringSync()) as Map;
  if (yamlMap['fray_localization'] is! Map) {
    print("Your `$filePath` file does not contain a `fray_localization section.`");
    exit(1);
  }
  return _yamlToMap(yamlMap['fray_localization'] as YamlMap);
}

Map<String, dynamic> _yamlToMap(YamlMap yamlMap) {
  final Map<String, dynamic> map = <String, dynamic>{};
  for (final MapEntry<dynamic, dynamic> entry in yamlMap.entries) {
    if (entry.value is YamlList) {
      final list = <String>[];
      for (final value in entry.value as YamlList) {
        if (value is String) {
          list.add(value);
        }
      }
      map[entry.key as String] = list;
    } else if (entry.value is YamlMap) {
      map[entry.key as String] = _yamlToMap(entry.value as YamlMap);
    } else {
      map[entry.key as String] = entry.value;
    }
  }
  return map;
}

void _generate() {
  final config = _getConfig();
  generateStaticDeclareClass(config);
}

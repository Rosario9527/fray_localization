import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fray_localization/src/localization_load_sentences.dart';
import 'localization_defalut_replace.dart';
import 'package:path/path.dart' as p;

typedef LocateFilesFunc = List<String> Function(Locale locale);
typedef ReplaceVarFunc = String Function(String key, String raw, List<String>? args);

class LocalizationService {
  static LocalizationService? _instance;
  bool showDebugPrintMode = true;

  static LocalizationService get instance {
    _instance ??= LocalizationService();
    return _instance!;
  }

  final _sentences = <String, String>{};

  Future changeLanguage(Locale locale, LocateFilesFunc locateFiles) async {
    clearSentences();
    final files = locateFiles(locale);
    for (var f in files) {
      final data = await rootBundle.loadString(f);
      loadSentencesByJsonString(data, _sentences);
    }
  }

  @visibleForTesting
  void addSentence(String key, String value) {
    _sentences[key] = value;
  }

  String read(
    String key,
    List<String> arguments, {
    List<bool>? conditions,
  }) {
    if (!_sentences.containsKey(key)) {
      return key;
    }

    final value = _sentences[key]!;
    print("i18n read $key $value");

    return LocalizationDefaultReplace.replace(key, value, arguments);
  }

  void clearSentences() {
    _sentences.clear();
  }
}

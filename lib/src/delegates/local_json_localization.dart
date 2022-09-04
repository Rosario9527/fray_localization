import 'package:flutter/material.dart';
import '../localization_service.dart';
import 'package:path/path.dart' as p;

List<String> defaultLocateFiles(Locale locale) {
  final selectedLanguage = locale.toString();
  return [p.join("assets/i18n", "$selectedLanguage.json")];
}

class LocalJsonLocalization extends LocalizationsDelegate {
  LocateFilesFunc locateFiles = defaultLocateFiles;

  bool showDebugPrintMode = true;
  LocalJsonLocalization._();

  static final delegate = LocalJsonLocalization._();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<dynamic> load(Locale locale) async {
    LocalizationService.instance.showDebugPrintMode = showDebugPrintMode;
    await LocalizationService.instance.changeLanguage(locale, locateFiles);
  }

  @override
  bool shouldReload(LocalJsonLocalization old) => false;
}

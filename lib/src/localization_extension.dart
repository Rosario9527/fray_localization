import 'localization_service.dart';

extension LocalizationExtension on String {
  String i18n([dynamic arguments]) {
    List<String> args = [];
    if (arguments != null) {
      if (arguments is String) {
        args.add(arguments);
      } else if (arguments is List<String>) {
        args = arguments;
      } else {
        //Only String , [String], null
      }
    }
    return LocalizationService.instance.read(
      this,
      args,
    );
  }
}

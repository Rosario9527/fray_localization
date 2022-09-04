import 'dart:math';

import 'package:flutter/material.dart';

class LocalizationDefaultReplace {
  static const dollar = 36; // '$'

  static bool isValidVarCode(int rune) {
    return rune == dollar ||
        rune == 95 /* . */ ||
        (rune >= 48 /* 0 */ && rune <= 57 /* 9 */) ||
        (rune >= 65 /* A */ && rune <= 90 /* Z */) ||
        (rune >= 97 /* a */ && rune <= 122 /* z */);
  }

  static String replace(String key, String raw, List<String>? args) {
    List<int> varCode = [];
    List<String> replaceable = [];
    var varStart = false;
    raw.runes.forEach((rune) {
      if (!varStart && rune == dollar) {
        varStart = true;
        varCode.add(rune);
        return;
      }
      if (!varStart) return;
      if (isValidVarCode(rune)) {
        varCode.add(rune);
        return;
      }
      replaceable.add(String.fromCharCodes(varCode));
      varStart = false;
    });
    //检查到最后，还是检测变量状态中，这次也要替换。
    if (varStart) replaceable.add(String.fromCharCodes(varCode));
    final replaceableLen = replaceable.length;
    final argsLen = args?.length;
    if (replaceableLen == 0 || argsLen == null || argsLen == 0) {
      return raw;
    }
    final minLen = min(replaceableLen, argsLen);
    for (var i = 0; i < minLen; i++) {
      raw = raw.replaceFirst(replaceable[i], args![i]);
    }
    return raw;
  }
}

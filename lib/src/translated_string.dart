import 'package:flutter/foundation.dart';
import 'package:siberian_intl/siberian_intl.dart';

@immutable
class TranslatedString {
  static String defaultLanguage = '';

  late final Map<String, String?> _texts;

  String operator [](String languageCode) {
    final result = _texts[languageCode] ?? _texts[defaultLanguage] ?? '';
    return result;
  }

  @override
  String toString() => _texts.toString();

  TranslatedString(Map? texts) {
    _texts = texts?.map((key, value) => MapEntry('$key', '$value')) ?? {};
  }

  String get translated => this[translator.languageCode];
}

import 'dart:async';
import 'dart:convert';

import 'package:siberian_intl/siberian_intl.dart';
import 'package:siberian_intl/src/loaders/translation_loader.dart';
import 'package:siberian_intl/src/types.dart';

class JsonTranslationLoader<T extends TranslatorDictionary> extends TranslationLoader {
  const JsonTranslationLoader();

  @override
  FutureOr<Map<String, dynamic>> parseTranslation(String text) {
    Map<String, dynamic> data = jsonDecode(text);
    return data;
  }
}

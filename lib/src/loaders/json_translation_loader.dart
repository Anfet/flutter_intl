import 'dart:async';
import 'dart:convert';

import 'package:flutter_intl/flutter_intl.dart';
import 'package:flutter_intl/src/loaders/translation_loader.dart';
import 'package:flutter_intl/src/types.dart';

class JsonTranslationLoader<T extends TranslatorDictionary> extends TranslationLoader {
  const JsonTranslationLoader();

  @override
  FutureOr<Map<String, dynamic>> parseTranslation(String text) {
    Map<String, dynamic> data = jsonDecode(text);
    return data;
  }
}

import 'dart:async';

import 'package:siberian_intl/src/loaders/sources/translation_loader_source.dart';
import 'package:siberian_intl/src/types.dart';

abstract class TranslationLoader<T extends TranslatorDictionary> {
  const TranslationLoader();

  FutureOr<Map<String, dynamic>> loadFrom<X>(TranslationLoaderSource<X> source) async {
    var text = await source.string;
    return parseTranslation(text);
  }

  FutureOr<Map<String, dynamic>> parseTranslation(String text);
}

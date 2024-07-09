import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter_intl/flutter_intl.dart';
import 'package:flutter_intl/src/loaders/translation_loader.dart';

final _pluralPattern = RegExp(r'_plural_(zero|one|two|many)$');
final _specPattern = RegExp(r'(zero|one|two|many)$');
final _keyNamePattern = RegExp(r'^.+(?=_plural_(zero|one|two|many)$)');

class CsvTranslationLoader<T extends TranslatorDictionary> extends TranslationLoader {
  const CsvTranslationLoader();

  @override
  FutureOr<Map<String, dynamic>> parseTranslation(String text) {
    List<List<String>> rowsAsListOfValues = const CsvToListConverter().convert<String>(
      text,
      shouldParseNumbers: false,
    );
    var header = rowsAsListOfValues.removeAt(0);
    var translations = <String, Map<String, dynamic>>{};
    var languageIndices = <String, int>{};
    for (var i = 1; i < header.length; i++) {
      var language = header[i];
      translations.putIfAbsent(language, () => <String, dynamic>{});
      languageIndices[language] = i;
    }

    while (rowsAsListOfValues.isNotEmpty) {
      var row = rowsAsListOfValues.removeAt(0);
      var key = row[0];
      if (key.isEmpty) {
        continue;
      }

      var isPlural = _pluralPattern.hasMatch(key);

      if (isPlural) {
        var plural = '${_keyNamePattern.firstMatch(key)!.group(0)}_plural';
        var spec = _pluralSpecFrom(key);

        for (var language in languageIndices.keys) {
          var value = row[languageIndices[language]!];
          translations[language]!.putIfAbsent(plural, () => <String, String>{});
          translations[language]![plural][spec.name] = value;
        }
      } else {
        for (var language in languageIndices.keys) {
          var value = row[languageIndices[language]!];
          translations[language]![key] = value;
        }
      }
    }
    print(translations);
    return translations;
  }

  PluralSpec _pluralSpecFrom(String key) {
    var ending = _specPattern.firstMatch(key)?.group(0);
    return switch (ending) {
      'zero' => PluralSpec.zero,
      'one' => PluralSpec.one,
      'two' => PluralSpec.two,
      'many' => PluralSpec.many,
      _ => throw LocalizationNotProvidedException("invalid plural spec '$ending' for '$key'"),
    };
  }
}

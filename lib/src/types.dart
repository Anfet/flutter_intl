import 'package:siberian_intl/siberian_intl.dart';

typedef PluralSpecResolver = PluralSpec Function(int amount);
typedef TextToDictionaryResolver<TranslatorDictionary> = TranslatorDictionary? Function(String text);

final _specPattern = RegExp(r'_(zero|one|two|many)$');

mixin TranslatorDictionary {
  String get key;

  bool get isPlural => key.contains('_plural_') || key.endsWith('_plural');

  PluralSpec get pluralSpec {
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

class Translation<Dictionary extends TranslatorDictionary> {
  final String languageCode;
  final Map<Dictionary, dynamic> texts;
  final PluralSpecResolver specResolver;

  const Translation({
    required this.languageCode,
    required this.texts,
    required this.specResolver,
  });
}

enum PluralSpec { zero, one, two, many }

class Plural {
  //все что заканчивается на 0. (0, 10, 20)
  final String zero;

  //заканчивающиееся на 1
  final String one;

  //заканчивающиееся на 2
  final String two;

  //множественное кол-во
  final String many;

  const Plural({
    required this.zero,
    required this.one,
    required this.two,
    required this.many,
  });

  String get(PluralSpec spec) => switch (spec) {
        PluralSpec.zero => zero,
        PluralSpec.one => one,
        PluralSpec.two => two,
        _ => many,
      };
}

extension TranslatedDictionaryExt<T extends TranslatorDictionary> on T {
  String get text => translator.translate(this);

  String format(args) => translator.translate(this, args);

  String quantity(int amount) => translator.translate(this, amount);
}

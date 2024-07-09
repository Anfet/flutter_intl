import 'package:flutter_intl/flutter_intl.dart';

typedef PluralSpecResolver = PluralSpec Function(int amount);
typedef TextToDictionaryResolver<TranslatorDictionary> = TranslatorDictionary? Function(String text);

mixin TranslatorDictionary {
  String get key;

  bool get isPlural => key.endsWith('_plural');
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

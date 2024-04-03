import 'package:siberian_intl/siberian_intl.dart';

typedef TextResolver<T> = String? Function(T resId);
typedef PluralSpecResolver = PluralSpec Function(int amount);
typedef PluralResolver<P> = Plural? Function(P resId);
typedef TextToDictionaryResolver<TranslatorDictionary> = TranslatorDictionary Function(String text);
typedef TextToPluralResolver<TranslatorPlurals> = TranslatorPlurals Function(String text);

abstract interface class TranslatorDictionary {}

abstract interface class TranslatorPlurals {}

class Translation<Dictionary extends TranslatorDictionary, Plurals extends TranslatorPlurals> {
  final String languageCode;
  final TextResolver<Dictionary> textResolver;
  final PluralResolver<Plurals> pluralResolver;
  final PluralSpecResolver specResolver;

  const Translation({
    required this.languageCode,
    required this.textResolver,
    required this.pluralResolver,
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
}

extension TranslatedPluralsExt<T extends TranslatorPlurals> on T {
  String get(int quantity) => translator.quantity(this, quantity);
}
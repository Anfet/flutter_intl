import 'package:siberian_intl/siberian_intl.dart';

enum Dictionary implements TranslatorDictionary {
  helloWorld,
  ok,
  formattedWorld,
  notFound,
  complexTranslation,
  intFormatter,
}

enum Plurals implements TranslatorPlurals {
  days,
  seconds,
}

final translationEn = {
  Dictionary.helloWorld: 'Hello world',
  Dictionary.ok: 'ok',
  Dictionary.formattedWorld: 'Hello %s',
  Dictionary.complexTranslation: '%s + %s = %s',
  Dictionary.intFormatter: '%i + %i = %i',
};

final pluralsEn = {
  Plurals.days: const Plural(zero: '%s days', one: '%s day', two: '%s days', many: '%s days'),
};

final translationRu = {
  Dictionary.helloWorld: 'Привет мир',
};

final pluralsRu = {
  Plurals.days: const Plural(zero: '%s дней', one: '%s день', two: '%s дня', many: '%s дней'),
};

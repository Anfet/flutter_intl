import 'package:flutter_intl/flutter_intl.dart';

enum Dictionary with TranslatorDictionary {
  helloWorld,
  ok,
  formattedWorld,
  notFound,
  complexTranslation,
  days_plural,
  ;

  final String? _key;

  @override
  String get key => _key ?? name;

  // ignore: unused_element
  const Dictionary([this._key]);
}

final translationEn = <Dictionary, dynamic>{
  Dictionary.helloWorld: 'Hello world',
  Dictionary.ok: 'ok',
  Dictionary.formattedWorld: 'Hello {{world}}',
  Dictionary.complexTranslation: '{{0}} + {{1}} = {{2}}',
  Dictionary.days_plural: {
    'zero': '{{0}} days',
    'one': '{{0}} day',
    'two': '{{0}} days',
    'many': '{{0}} days',
  }
};

final translationRu = {
  Dictionary.helloWorld: 'Привет мир',
};

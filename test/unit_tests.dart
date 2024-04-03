import 'package:flutter_test/flutter_test.dart';
import 'package:siberian_intl/siberian_intl.dart';

import 'data/loadable_translations.dart';
import 'data/translation_enums.dart';

void main() {
  var translator = Translator<Dictionary>.setupWith(
    defaultLanguageCode: 'en',
    translations: [],
    textToDictionaryResolver: (text) => Dictionary.values.where((it) => it.key == text).firstOrNull,
  );

  test('default translator is installed', () {
    installTranslator(translator);
    assert(isTranslatorSet);
  });

  test('translation is registered with success', () {
    translator.registerTranslation(Translation<Dictionary>(languageCode: 'en', texts: translationEn, specResolver: specResolverEn));
    assert(translator.supportedLanguages.contains('en'));
  });

  test('translation is ok', () {
    var helloText = translator.translate(Dictionary.helloWorld);
    assert(helloText == 'Hello world');
  });

  test('translation not found', () {
    var helloText = translator.translate(Dictionary.notFound);
    assert(helloText != 'Hello world');
    assert(helloText == '${Dictionary.notFound}');
  });

  test('translation format arg is text', () {
    var translator = Translator<Dictionary>.setupWith(
      defaultLanguageCode: 'en',
      translations: [],
      textToDictionaryResolver: (text) => Dictionary.values.byName(text),
    );

    translator.registerTranslation(Translation<Dictionary>(languageCode: 'en', texts: translationEn, specResolver: specResolverEn));
    var badText = translator.translate(Dictionary.formattedWorld, 'Saturn');
    assert(badText == 'Hello {{world}}');
    var goodText = translator.translate(Dictionary.formattedWorld, {'world': 'Saturn'});
    assert(goodText == 'Hello Saturn');
  });

  test('complex formatting', () {
    var translator = Translator<Dictionary>.setupWith(
        defaultLanguageCode: 'en', translations: [], textToDictionaryResolver: (text) => Dictionary.values.byName(text));

    translator.registerTranslation(Translation<Dictionary>(languageCode: 'en', texts: translationEn, specResolver: specResolverEn));

    var helloText = translator.translate(Dictionary.complexTranslation, ['2', '2', '4']);
    assert(helloText == '2 + 2 = 4');
  });

  test('plural format; have value', () {
    var text = Dictionary.days_plural.quantity(5);
    assert(text == '5 days');
  });

  test('other language; have dictionary', () {
    translator.registerTranslation(
      Translation<Dictionary>(languageCode: 'ru', texts: translationRu, specResolver: specResolverRu),
    );

    translator.languageCode = 'ru';
    var text = translator.translate(Dictionary.helloWorld);
    assert(text == 'Привет мир');
  });

  test('other language; default dictionary', () {
    translator.languageCode = 'ru';
    var text = translator.translate(Dictionary.formattedWorld);
    assert(text == 'Hello {{world}}');
  });

  test('loadable translation', () {
    translator.registerTranslationMap(
      languageCode: 'en',
      translationMap: loadableTranslationEn,
      specResolver: defaultSpecResolver,
    );
    translator.languageCode = 'en';
    var text = Dictionary.days_plural.quantity(11);
    assert(text == '11 days');
  });

  test('loadable translation; extensions', () {
    translator.languageCode = 'en';
    var text = Dictionary.helloWorld.text;
    assert(text == 'Hello world');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:siberian_intl/siberian_intl.dart';

import 'data/translation_enums.dart';

void main() {
  var translator = Translator<Dictionary, Plurals>.setupWith(
    defaultLanguageCode: 'en',
    translations: [],
    textToDictionaryResolver: (text) => Dictionary.values.byName(text),
    textToPluralResolver: (text) => Plurals.values.byName(text),
  );

  test('default translator is installed', () {
    installTranslator(translator);
    assert(isTranslatorSet);
  });

  test('translation is registered with success', () {
    translator.registerTranslation(
      Translation<Dictionary, Plurals>(
          languageCode: 'en',
          pluralResolver: (resId) => pluralsEn[resId],
          textResolver: (resId) => translationEn[resId],
          specResolver: specResolverEn),
    );

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
    var helloText = translator.translate(Dictionary.formattedWorld, 'Saturn');
    assert(helloText == 'Hello Saturn');
  });

  test('complex formatting', () {
    var helloText = translator.translate(Dictionary.complexTranslation, ['2', '2', '4']);
    assert(helloText == '2 + 2 = 4');
  });

  test('int formatting', () {
    var helloText = translator.translate(Dictionary.intFormatter, [5, 5, 10]);
    assert(helloText == '5 + 5 = 10');
  });

  test('plural format; have value', () {
    var text = translator.quantity(Plurals.days, 5);
    assert(text == '5 days');
  });

  test('plural format; no value ', () {
    var text = translator.quantity(Plurals.seconds, 5);
    assert(text == 'Plurals.seconds(5)');
  });

  test('other language; have dictionary', () {
    translator.registerTranslation(
      Translation<Dictionary, Plurals>(
        languageCode: 'ru',
        pluralResolver: (resId) => pluralsRu[resId],
        textResolver: (resId) => translationRu[resId],
        specResolver: specResolverRu,
      ),
    );

    translator.languageCode = 'ru';
    var text = translator.translate(Dictionary.helloWorld);
    assert(text == 'Привет мир');
  });

  test('other language; default dictionary', () {
    translator.languageCode = 'ru';
    var text = translator.translate(Dictionary.formattedWorld);
    assert(text == 'Hello %s');
  });

  test('loadable translation', () {
    translator.languageCode = 'en';
    var text = translator.translate(Dictionary.helloWorld);
    assert(text == 'Hello world');
  });

  test('loadable translation; extensions', () {
    translator.languageCode = 'en';
    var text = Dictionary.helloWorld.text;
    assert(text == 'Hello world');
  });
}

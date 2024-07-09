import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_intl/flutter_intl.dart';

import 'data/translation_enums.dart';

void main() {
  var translator = Translator<Dictionary>.setupWith(
    defaultLanguageCode: 'en',
    translations: [],
    textToDictionaryResolver: (text) => Dictionary.values.byName(text),
  );

  translator.registerTranslation(
    Translation<Dictionary>(languageCode: 'en', texts: translationEn, specResolver: specResolverEn),
  );

  translator.registerTranslation(
    Translation<Dictionary>(languageCode: 'ru', texts: translationRu, specResolver: specResolverRu),
  );

  installTranslator(translator);

  testWidgets('translated widget has correct title', (tester) async {
    translator.languageCode = 'en';
    await tester.pumpWidget(MaterialApp(home: TranslatedWidget(builder: (context, child) => Text(Dictionary.helloWorld.text))));
    expect(find.text('Hello world'), findsOneWidget);
  });

  testWidgets('translated widget has correct title and changes', (tester) async {
    translator.languageCode = 'en';
    await tester.pumpWidget(MaterialApp(home: TranslatedWidget(builder: (context, child) => Text(Dictionary.helloWorld.text))));
    expect(find.text('Hello world'), findsOneWidget);

    translator.languageCode = 'ru';
    await tester.pump();
    expect(find.text('Привет мир'), findsOneWidget);
  });
}

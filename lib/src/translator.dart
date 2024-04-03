import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:siberian_intl/siberian_intl.dart';
import 'package:sprintf/sprintf.dart';

Translator? _translator;

Translator get translator => _translator!;

void installTranslator(Translator other) => _translator = other;

bool get isTranslatorSet => _translator != null;

class Translator<Dictionary extends TranslatorDictionary, Plurals extends TranslatorPlurals> with ChangeNotifier {
  final Map<String, Translation<Dictionary, Plurals>> _translations = {};

  final TextToDictionaryResolver dictionaryResolver;
  final TextToPluralResolver pluralResolver;

  String _defaultLanguageCode;
  String _languageCode;

  String get languageCode => _languageCode.toLowerCase();

  set languageCode(String code) {
    final lowerCaseCode = code.toLowerCase();
    if (_languageCode != lowerCaseCode) {
      _languageCode = lowerCaseCode;
      notifyListeners();
      // WidgetsFlutterBinding.ensureInitialized().reassembleApplication();
    }
  }

  Locale get locale => Locale(_languageCode.toLowerCase(), _languageCode.toUpperCase());

  set locale(Locale locale) => languageCode = locale.languageCode;

  Translation<Dictionary, Plurals> get _currentTranslation {
    final translation = _translations[_languageCode] ?? _translations[_defaultLanguageCode];
    if (translation == null) {
      throw LocalizationNotProvidedException(
          "No translation for '$_languageCode' ${_languageCode != _defaultLanguageCode ? 'or \'$_defaultLanguageCode\'' : ''} language(s)");
    }

    return translation;
  }

  Translation<Dictionary, Plurals> get _defaultTranslation {
    final translation = _translations[_defaultLanguageCode];
    assert(translation != null, 'no default translation $_defaultLanguageCode found!');
    return translation!;
  }

  Iterable<String> get supportedLanguages => _translations.keys;

  Translator._(
    this._languageCode,
    this.dictionaryResolver,
    this.pluralResolver,
  ) : _defaultLanguageCode = _languageCode {
    TranslatedString.defaultLanguage = _languageCode;
  }

  factory Translator.setupWith({
    required String defaultLanguageCode,
    required Iterable<Translation<Dictionary, Plurals>> translations,
    required TextToDictionaryResolver<Dictionary> textToDictionaryResolver,
    required TextToPluralResolver<Plurals> textToPluralResolver,
  }) {
    var translator = Translator<Dictionary, Plurals>._(
      defaultLanguageCode,
      textToDictionaryResolver,
      textToPluralResolver,
    );
    for (var it in translations) {
      translator.registerTranslation(it);
    }
    return translator;
  }

  void registerTranslation(Translation<Dictionary, Plurals> translation) {
    _translations[translation.languageCode] = translation;
    initializeDateFormatting(translation.languageCode);
  }

  void registerTranslationMap({
    required String languageCode,
    Map<String, String>? translationMap,
    Map<String, Map<String, String>>? pluralMap,
    PluralSpecResolver? specResolver,
  }) {
    Map<Dictionary, String> texts = (translationMap ?? {}).map((key, value) => MapEntry(dictionaryResolver(key), value));
    Map<Plurals, Plural> plurals = (pluralMap ?? {}).map(
      (key, value) => MapEntry(
        pluralResolver(key),
        Plural(
          zero: value['zero'] ?? '',
          one: value['one'] ?? '',
          two: value['two'] ?? '',
          many: value['many'] ?? '',
        ),
      ),
    );
    Translation<Dictionary, Plurals> translation = Translation(
      languageCode: languageCode,
      textResolver: (resId) => texts[resId],
      pluralResolver: (resId) => plurals[resId],
      specResolver: specResolver ?? defaultSpecResolver,
    );
    registerTranslation(translation);
  }

  String translate(Dictionary resId, [arg]) {
    final text = _currentTranslation.textResolver(resId) ?? _defaultTranslation.textResolver(resId) ?? '$resId';
    return arg != null ? sprintf(text, arg is Iterable ? arg : [arg]) : text;
  }

  String quantity(Plurals resId, int amount, {NumberFormat? formatter}) {
    final plural = _currentTranslation.pluralResolver(resId) ?? _defaultTranslation.pluralResolver(resId);

    if (plural == null) {
      return '$resId($amount)';
    }

    final spec = _currentTranslation.specResolver(amount);
    final pattern = plural.get(spec);

    if (pattern.isEmpty) {
      throw QuantityLocalizationNotProvidedException("No quantity string provided for $languageCode/$resId");
    }

    String result = '';
    if (pattern.contains("%s") && formatter != null) {
      var amountText = formatter.format(amount).trim();
      result = sprintf(pattern, [amountText]);
    } else {
      result = sprintf(pattern, [amount]);
    }

    return result;
  }
}
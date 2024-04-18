import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siberian_intl/siberian_intl.dart';

Translator? _translator;

Translator get translator => _translator!;

void installTranslator(Translator other) => _translator = other;

bool get isTranslatorSet => _translator != null;

final paramReg = RegExp(r'{{[\d\w]+}}');

class Translator<Dictionary extends TranslatorDictionary> with ChangeNotifier {
  final Map<String, Translation<Dictionary>> _translations = {};

  final TextToDictionaryResolver<Dictionary> dictionaryResolver;

  String _defaultLanguageCode;
  String _languageCode;

  String get languageCode => _languageCode.toLowerCase();

  set languageCode(String code) {
    final lowerCaseCode = code.toLowerCase();
    if (_languageCode != lowerCaseCode) {
      _languageCode = lowerCaseCode;
      notifyUpdated();
    }
  }

  Locale get locale => Locale(_languageCode.toLowerCase(), _languageCode.toUpperCase());

  set locale(Locale locale) => languageCode = locale.languageCode;

  Translation<Dictionary> get _currentTranslation {
    final translation = _translations[_languageCode] ?? _translations[_defaultLanguageCode];
    if (translation == null) {
      throw LocalizationNotProvidedException(
          "No translation for '$_languageCode' ${_languageCode != _defaultLanguageCode ? 'or \'$_defaultLanguageCode\'' : ''} language(s)");
    }

    return translation;
  }

  Translation<Dictionary> get _defaultTranslation {
    final translation = _translations[_defaultLanguageCode];
    assert(translation != null, 'no default translation $_defaultLanguageCode found!');
    return translation!;
  }

  Iterable<String> get supportedLanguages => _translations.keys;

  Translator._(
    this._languageCode,
    this.dictionaryResolver,
  ) : _defaultLanguageCode = _languageCode {
    TranslatedString.defaultLanguage = _languageCode;
  }

  factory Translator.setupWith({
    required String defaultLanguageCode,
    required Iterable<Translation<Dictionary>> translations,
    required TextToDictionaryResolver<Dictionary> textToDictionaryResolver,
  }) {
    var translator = Translator<Dictionary>._(
      defaultLanguageCode,
      textToDictionaryResolver,
    );
    for (var it in translations) {
      translator.registerTranslation(it);
    }
    return translator;
  }

  void registerTranslation(Translation<Dictionary> translation) {
    _translations[translation.languageCode] = translation;
    initializeDateFormatting(translation.languageCode);
  }

  void removeTranslation(String languageCode) {
    _translations.remove(languageCode);
  }

  void clear() {
    _translations.clear();
  }

  void notifyUpdated({bool hard = false}) {
    hard ? WidgetsFlutterBinding.ensureInitialized().reassembleApplication() : notifyListeners();
  }

  void registerTranslationMap({
    required String languageCode,
    Map<String, dynamic>? translationMap,
    PluralSpecResolver? specResolver,
  }) {
    Iterable<Dictionary> validKeys = translationMap?.keys
            .map((key) {
              Dictionary? dictionary = dictionaryResolver(key);
              if (dictionary == null) {
                debugPrint("No dictionary for key '$key'");
              }
              return dictionary;
            })
            .nonNulls
            .cast<Dictionary>() ??
        [];

    final texts = Map<Dictionary, dynamic>.fromEntries(validKeys.map((e) => MapEntry(e, translationMap?[e.key])));

    Translation<Dictionary> translation = Translation(
      languageCode: languageCode,
      texts: texts,
      specResolver: specResolver ?? defaultSpecResolver,
    );
    registerTranslation(translation);
  }

  List<String> _argumentsToList(dynamic arg) {
    if (arg == null) {
      return [];
    }

    if (arg is Map) {
      arg = (arg).values;
    }

    if (arg is Iterable) {
      return (arg).map((e) => '$e').toList(growable: false);
    }

    return ['$arg'];
  }

  Map<String, String> _argumentsToMap(dynamic arg) {
    if (arg == null) {
      return {};
    }

    if (arg is Map) {
      return (arg).map((key, value) => MapEntry('$key', '$value'));
    }

    if (arg is Iterable) {
      final map = <String, String>{};
      for (var it in (arg).indexed) {
        var (index, value) = it;
        map['$index'] = value;
      }

      return map;
    }

    return {'0': '$arg'};
  }

  String _internalTranslate(String text, dynamic arg) {
    var startIndex = 0;
    while (startIndex < text.length) {
      var matches = paramReg.allMatches(text, startIndex);
      if (matches.isEmpty) {
        break;
      }

      var match = matches.first;
      var param = text.substring(match.start + 2, match.end - 2);
      var index = int.tryParse(param);
      String? value;
      if (index != null) {
        //param is integer
        var args = _argumentsToList(arg);
        value = args[index] ?? '';
      } else {
        //param is a text
        var args = _argumentsToMap(arg);
        value = args[param];
      }

      if (value != null) {
        var replacementLength = value.length;
        text = text.replaceRange(match.start, match.end, value);
        startIndex = match.start + replacementLength;
      } else {
        startIndex = match.end;
      }
    }

    return text;
  }

  String translate(Dictionary resId, [arg]) {
    var translation = _currentTranslation;
    dynamic data = translation.texts[resId];
    if (data == null) {
      translation = _defaultTranslation;
      data = translation.texts[resId];
    }

    if (data == null) {
      return '$resId';
    }

    String text;
    if (resId.isPlural) {
      var spec = translation.specResolver(arg as int);
      assert(data is Map<String, dynamic>, "'$resId' value '$data' is not Map<String, dynamic>");
      var plural = data as Map<String, dynamic>;
      text = plural[spec.name] ?? '';
    } else {
      text = '$data';
    }

    return _internalTranslate(text, arg);
  }
}

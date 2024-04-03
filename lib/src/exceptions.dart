class LocalizationException implements Exception {
  final String? message;

  LocalizationException(this.message);

  @override
  String toString() => message ?? '$runtimeType';
}

class LocalizationNotProvidedException extends LocalizationException {
  LocalizationNotProvidedException(super.message);
}

class QuantityLocalizationNotProvidedException extends LocalizationException {
  QuantityLocalizationNotProvidedException(super.message);
}

class LocaleNotSupportedException extends LocalizationException {
  LocaleNotSupportedException(super.message);
}

import 'package:siberian_intl/src/types.dart';

PluralSpec specResolverEn(int amount) {
  amount = amount.abs();
  var remainder = amount.remainder(10);
  var result = switch (remainder) {
    1 => PluralSpec.one,
    _ => PluralSpec.many,
  };
  return result;
}

PluralSpec specResolverRu(int amount) {
  if (amount == 0) {
    return PluralSpec.zero;
  } else {
    amount = amount.abs();
    var remainder10 = amount.remainder(10);
    var remainder100 = amount.remainder(100);
    var result = switch (remainder10) {
      0 => PluralSpec.zero,
      1 => amount.remainder(100) == 11 ? PluralSpec.many : PluralSpec.one,
      2 || 3 || 4 => remainder100 >= 10 && remainder100 < 19 ? PluralSpec.many : PluralSpec.two,
      _ => PluralSpec.many,
    };
    return result;
  }
}

PluralSpec defaultSpecResolver(int amount) {
  if (amount == 0) {
    return PluralSpec.zero;
  } else {
    amount = amount.abs();
    var remainder = amount.remainder(10);
    var result = switch (remainder) {
      0 => PluralSpec.zero,
      1 => PluralSpec.one,
      2 => PluralSpec.two,
      _ => PluralSpec.many,
    };
    return result;
  }
}

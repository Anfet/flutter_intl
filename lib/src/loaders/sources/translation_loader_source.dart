import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

sealed class TranslationLoaderSource<T> {
  FutureOr<T> get data;

  FutureOr<String> get string;

  static TranslationLoaderSource uint8list(FutureOr<Uint8List> data) => TranslationLoaderSourceUint8List._(data);

  static TranslationLoaderSource byteData(FutureOr<ByteData> data) => TranslationLoaderSourceByteData._(data);

  static TranslationLoaderSource text(FutureOr<String> data) => TranslationLoaderSourceString._(data);

  static TranslationLoaderSource asset(String assetName) => TranslationLoaderSourceAsset._(assetName);
}

@immutable
class TranslationLoaderSourceUint8List implements TranslationLoaderSource<Uint8List> {
  @override
  final FutureOr<Uint8List> data;

  const TranslationLoaderSourceUint8List._(this.data);

  @override
  FutureOr<String> get string => Future.value(data).then((list) => utf8.decode(list));
}

@immutable
class TranslationLoaderSourceByteData implements TranslationLoaderSource<ByteData> {
  @override
  final FutureOr<ByteData> data;

  @override
  FutureOr<String> get string => Future.value(data).then((bytes) => utf8.decode(bytes.buffer.asUint8List()));

  const TranslationLoaderSourceByteData._(this.data);
}

@immutable
class TranslationLoaderSourceString implements TranslationLoaderSource<String> {
  @override
  final FutureOr<String> data;

  @override
  FutureOr<String> get string => data;

  const TranslationLoaderSourceString._(this.data);
}

@immutable
class TranslationLoaderSourceAsset implements TranslationLoaderSource<String> {
  @override
  final FutureOr<String> data;

  @override
  FutureOr<String> get string => data;

  TranslationLoaderSourceAsset._(String assetName) : data = rootBundle.loadString(assetName);
}

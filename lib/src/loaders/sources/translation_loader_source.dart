import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

sealed class TranslationLoaderSource<T> {
  Future<T> get data;

  Future<String> get string;

  static TranslationLoaderSource uint8list(Future<Uint8List> data) => TranslationLoaderSourceUint8List._(data);

  static TranslationLoaderSource byteData(Future<ByteData> data) => TranslationLoaderSourceByteData._(data);

  static TranslationLoaderSource text(Future<String> data) => TranslationLoaderSourceString._(data);

  static TranslationLoaderSource asset(String assetName) => TranslationLoaderSourceAsset._(assetName);
}

@immutable
class TranslationLoaderSourceUint8List implements TranslationLoaderSource<Uint8List> {
  @override
  final Future<Uint8List> data;

  const TranslationLoaderSourceUint8List._(this.data);

  @override
  Future<String> get string => data.then((list) => utf8.decode(list));
}

@immutable
class TranslationLoaderSourceByteData implements TranslationLoaderSource<ByteData> {
  @override
  final Future<ByteData> data;

  @override
  Future<String> get string => data.then((bytes) => utf8.decode(bytes.buffer.asUint8List()));

  const TranslationLoaderSourceByteData._(this.data);
}

@immutable
class TranslationLoaderSourceString implements TranslationLoaderSource<String> {
  @override
  final Future<String> data;

  @override
  Future<String> get string => data;

  const TranslationLoaderSourceString._(this.data);
}

@immutable
class TranslationLoaderSourceAsset implements TranslationLoaderSource<String> {
  @override
  final Future<String> data;

  @override
  Future<String> get string => data;

  TranslationLoaderSourceAsset._(String assetName) : data = rootBundle.loadString(assetName);
}

import 'package:flutter/material.dart';
import 'package:siberian_intl/siberian_intl.dart';

class Translated extends StatelessWidget {
  final Translator? customTranslator;
  final ValueGetter<Widget> child;

  const Translated({
    super.key,
    this.customTranslator,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (customTranslator == null && !isTranslatorSet) {
      throw LocalizationException('Cannot build translatable. specify translator or \'installTranslator\'');
    }

    return ListenableBuilder(
      listenable: customTranslator ?? translator,
      builder: (context, _) => child(),
    );
  }
}

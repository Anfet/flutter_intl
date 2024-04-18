import 'package:flutter/material.dart';
import 'package:siberian_intl/siberian_intl.dart';

class TranslatedWidget extends StatelessWidget {
  final Translator? customTranslator;
  final TransitionBuilder builder;
  final Widget? child;

  const TranslatedWidget({
    super.key,
    this.customTranslator,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (customTranslator == null && !isTranslatorSet) {
      throw LocalizationException('Cannot build translatable. specify translator or \'installTranslator\'');
    }

    return ListenableBuilder(
      listenable: customTranslator ?? translator,
      builder: builder,
      child: child,
    );
  }
}

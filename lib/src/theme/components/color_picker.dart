
import 'package:flutter/widgets.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

@immutable
class ShadColorPickerTheme {
  const ShadColorPickerTheme({
    this.merge = true,
    this.buttonVariant,
    this.buttonPadding,
    this.popoverConstraints,
    this.buttonTheme = const ShadButtonTheme(),
    this.editorTheme = const ShadColorEditorTheme(),
    this.popoverTheme = const ShadPopoverTheme(),
  });

  final bool merge;
  final ShadButtonVariant? buttonVariant;
  final EdgeInsets? buttonPadding;
  final BoxConstraints? popoverConstraints;
  final ShadButtonTheme buttonTheme;
  final ShadColorEditorTheme editorTheme;
  final ShadPopoverTheme popoverTheme;

  static ShadColorPickerTheme lerp(
    ShadColorPickerTheme a,
    ShadColorPickerTheme b,
    double t,
  ) {
    return ShadColorPickerTheme(
      merge: b.merge,
      buttonVariant: t < 0.5 ? a.buttonVariant : b.buttonVariant,
      buttonPadding: EdgeInsets.lerp(a.buttonPadding, b.buttonPadding, t),
      popoverConstraints:
          BoxConstraints.lerp(a.popoverConstraints, b.popoverConstraints, t),
      buttonTheme: ShadButtonTheme.lerp(a.buttonTheme, b.buttonTheme, t),
      editorTheme: ShadColorEditorTheme.lerp(a.editorTheme, b.editorTheme, t),
      popoverTheme: ShadPopoverTheme.lerp(a.popoverTheme, b.popoverTheme, t),
    );
  }

  ShadColorPickerTheme mergeWith(ShadColorPickerTheme? other) {
    if (other == null) return this;
    if (!other.merge) return other;
    return copyWith(
      buttonVariant: other.buttonVariant,
      buttonPadding: other.buttonPadding,
      popoverConstraints: other.popoverConstraints,
      buttonTheme: buttonTheme.mergeWith(other.buttonTheme),
      editorTheme: editorTheme.mergeWith(other.editorTheme),
      popoverTheme: popoverTheme.mergeWith(other.popoverTheme),
    );
  }

  ShadColorPickerTheme copyWith({
    bool? merge,
    ShadButtonVariant? buttonVariant,
    EdgeInsets? buttonPadding,
    BoxConstraints? popoverConstraints,
    ShadButtonTheme? buttonTheme,
    ShadColorEditorTheme? editorTheme,
    ShadPopoverTheme? popoverTheme,
  }) {
    return ShadColorPickerTheme(
      merge: merge ?? this.merge,
      buttonVariant: buttonVariant ?? this.buttonVariant,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      popoverConstraints: popoverConstraints ?? this.popoverConstraints,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      editorTheme: editorTheme ?? this.editorTheme,
      popoverTheme: popoverTheme ?? this.popoverTheme,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadColorPickerTheme &&
          runtimeType == other.runtimeType &&
          merge == other.merge &&
          buttonVariant == other.buttonVariant &&
          buttonPadding == other.buttonPadding &&
          popoverConstraints == other.popoverConstraints &&
          buttonTheme == other.buttonTheme &&
          editorTheme == other.editorTheme &&
          popoverTheme == other.popoverTheme;

  @override
  int get hashCode =>
      merge.hashCode ^
      buttonVariant.hashCode ^
      buttonPadding.hashCode ^
      popoverConstraints.hashCode ^
      buttonTheme.hashCode ^
      editorTheme.hashCode ^
      popoverTheme.hashCode;
}
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@immutable
class ShadColorEditorTheme {
  const ShadColorEditorTheme({
    this.merge = true,
    this.columnSpacing,
    this.rowSpacing,
    this.mainRowSpacing,
    this.tabsPadding,
    this.inputLabelPadding,
    this.sliderLabelPadding,
    this.tabLabelStyle,
    this.sliderLabelStyle,
    this.inputLabelStyle,
    this.inputStyle,
    this.inputSuffixStyle,
    this.inputDecoration,
    this.tabsTheme = const ShadTabsTheme(),
    this.sliderTheme = const ShadSliderTheme(),
    this.strings,
  });

  final bool merge;
  final double? columnSpacing;
  final double? rowSpacing;
  final double? mainRowSpacing;
  final EdgeInsets? tabsPadding;
  final EdgeInsets? inputLabelPadding;
  final EdgeInsets? sliderLabelPadding;

  final TextStyle? tabLabelStyle;
  final TextStyle? sliderLabelStyle;
  final TextStyle? inputLabelStyle;
  final TextStyle? inputStyle;
  final TextStyle? inputSuffixStyle;
  final ShadDecoration? inputDecoration;
  final ShadTabsTheme tabsTheme;
  final ShadSliderTheme sliderTheme;
  final ShadColorEditorStringMap? strings;

  static ShadColorEditorTheme lerp(
    ShadColorEditorTheme a,
    ShadColorEditorTheme b,
    double t,
  ) {
    return ShadColorEditorTheme(
      merge: b.merge,
      columnSpacing: lerpDouble(a.columnSpacing, b.columnSpacing, t),
      rowSpacing: lerpDouble(a.rowSpacing, b.rowSpacing, t),
      mainRowSpacing: lerpDouble(a.mainRowSpacing, b.mainRowSpacing, t),
      tabsPadding: EdgeInsets.lerp(a.tabsPadding, b.tabsPadding, t),
      inputLabelPadding:
          EdgeInsets.lerp(a.inputLabelPadding, b.inputLabelPadding, t),
      sliderLabelPadding:
          EdgeInsets.lerp(a.sliderLabelPadding, b.sliderLabelPadding, t),
      sliderLabelStyle:
          TextStyle.lerp(a.sliderLabelStyle, b.sliderLabelStyle, t),
      tabLabelStyle: TextStyle.lerp(a.tabLabelStyle, b.tabLabelStyle, t),
      inputLabelStyle: TextStyle.lerp(a.inputLabelStyle, b.inputLabelStyle, t),
      inputStyle: TextStyle.lerp(a.inputStyle, b.inputStyle, t),
      inputSuffixStyle:
          TextStyle.lerp(a.inputSuffixStyle, b.inputSuffixStyle, t),
      inputDecoration:
          ShadDecoration.lerp(a.inputDecoration, b.inputDecoration, t),
      tabsTheme: ShadTabsTheme.lerp(a.tabsTheme, b.tabsTheme, t),
      sliderTheme: ShadSliderTheme.lerp(a.sliderTheme, b.sliderTheme, t),
      strings: t > 0.5 ? b.strings : a.strings,
    );
  }

  ShadColorEditorTheme mergeWith(ShadColorEditorTheme? other) {
    if (other == null) return this;
    if (!other.merge) return other;
    return copyWith(
      columnSpacing: other.columnSpacing,
      rowSpacing: other.rowSpacing,
      mainRowSpacing: other.mainRowSpacing,
      tabsPadding: other.tabsPadding,
      inputLabelPadding: other.inputLabelPadding,
      sliderLabelPadding: other.sliderLabelPadding,
      sliderLabelStyle: other.sliderLabelStyle,
      tabLabelStyle: other.tabLabelStyle,
      inputLabelStyle: other.inputLabelStyle,
      inputStyle: other.inputStyle,
      inputSuffixStyle: other.inputSuffixStyle,
      inputDecoration: other.inputDecoration,
      tabsTheme: tabsTheme.mergeWith(other.tabsTheme),
      sliderTheme: sliderTheme.mergeWith(other.sliderTheme),
      strings: <ShadColorEditorStringKey, String>{
        ...?strings,
        ...?other.strings,
      },
    );
  }

  ShadColorEditorTheme copyWith({
    bool? merge,
    double? columnSpacing,
    double? rowSpacing,
    double? mainRowSpacing,
    EdgeInsets? tabsPadding,
    EdgeInsets? inputLabelPadding,
    EdgeInsets? sliderLabelPadding,
    TextStyle? tabLabelStyle,
    TextStyle? sliderLabelStyle,
    TextStyle? inputLabelStyle,
    TextStyle? inputStyle,
    TextStyle? inputSuffixStyle,
    ShadDecoration? inputDecoration,
    ShadTabsTheme? tabsTheme,
    ShadSliderTheme? sliderTheme,
    ShadColorEditorStringMap? strings,
  }) {
    return ShadColorEditorTheme(
      merge: merge ?? this.merge,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      mainRowSpacing: mainRowSpacing ?? this.mainRowSpacing,
      tabsPadding: tabsPadding ?? this.tabsPadding,
      inputLabelPadding: inputLabelPadding ?? this.inputLabelPadding,
      sliderLabelPadding: sliderLabelPadding ?? this.sliderLabelPadding,
      tabLabelStyle: tabLabelStyle ?? this.tabLabelStyle,
      sliderLabelStyle: sliderLabelStyle ?? this.sliderLabelStyle,
      inputLabelStyle: inputLabelStyle ?? this.inputLabelStyle,
      inputStyle: inputStyle ?? this.inputStyle,
      inputSuffixStyle: inputSuffixStyle ?? this.inputSuffixStyle,
      inputDecoration: inputDecoration ?? this.inputDecoration,
      tabsTheme: tabsTheme ?? this.tabsTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      strings: strings ?? this.strings,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadColorEditorTheme &&
          runtimeType == other.runtimeType &&
          merge == other.merge &&
          columnSpacing == other.columnSpacing &&
          rowSpacing == other.rowSpacing &&
          mainRowSpacing == other.mainRowSpacing &&
          tabsPadding == other.tabsPadding &&
          inputLabelPadding == other.inputLabelPadding &&
          sliderLabelPadding == other.sliderLabelPadding &&
          tabLabelStyle == other.tabLabelStyle &&
          sliderLabelStyle == other.sliderLabelStyle &&
          inputLabelStyle == other.inputLabelStyle &&
          inputStyle == other.inputStyle &&
          inputSuffixStyle == other.inputSuffixStyle &&
          inputDecoration == other.inputDecoration &&
          tabsTheme == other.tabsTheme &&
          sliderTheme == other.sliderTheme &&
          strings == other.strings;

  @override
  int get hashCode =>
      merge.hashCode ^
      columnSpacing.hashCode ^
      rowSpacing.hashCode ^
      mainRowSpacing.hashCode ^
      tabsPadding.hashCode ^
      inputLabelPadding.hashCode ^
      sliderLabelPadding.hashCode ^
      tabLabelStyle.hashCode ^
      sliderLabelStyle.hashCode ^
      inputLabelStyle.hashCode ^
      inputStyle.hashCode ^
      inputSuffixStyle.hashCode ^
      inputDecoration.hashCode ^
      tabsTheme.hashCode ^
      sliderTheme.hashCode ^
      strings.hashCode;
}

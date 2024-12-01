import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

typedef ShadColorEditorStringMap = Map<ShadColorEditorStringKey, String>;

class ShadColorEditor extends StatefulWidget {
  const ShadColorEditor({
    super.key,
    required this.controller,
    this.tabs,
    this.onChanged,
    this.columnSpacing,
    this.rowSpacing,
    this.mainRowSpacing,
    this.tabsPadding,
    this.tabLabelStyle,
    this.sliderLabelStyle,
    this.inputLabelStyle,
    this.inputStyle,
    this.inputSuffixStyle,
    this.inputDecoration,
    this.inputLabelPadding,
    this.sliderLabelPadding,
    this.tabsTheme,
    this.sliderTheme,
    this.strings,
  });

  /// {@template ShadColorEditor.tabs}
  /// The tabs to display in the editor.
  /// A tab bar will only be displayed if there is more than one tab.
  /// {@endtemplate}
  final List<ShadColorEditorTab>? tabs;

  /// The controller for the color editor.
  final ShadColorEditorController controller;

  /// {@template ShadColorEditor.columnSpacing}
  /// The spacing between widgets in the editor's columns.
  /// {@endtemplate}
  final double? columnSpacing;

  /// {@template ShadColorEditor.rowSpacing}
  /// The spacing between widgets in the editor's rows,
  /// excluding the main row. Used by the RGB and HSL input rows.
  /// {@endtemplate}
  final double? rowSpacing;

  /// {@template ShadColorEditor.mainRowSpacing}
  /// The spacing between the main row and the sidebar.
  /// Will only be used if a color area is displayed.
  /// {@endtemplate}
  final double? mainRowSpacing;

  /// {@template ShadColorEditor.tabsPadding}
  /// The padding around the tabs bar.
  /// {@endtemplate}
  final EdgeInsets? tabsPadding;

  /// {@template ShadColorEditor.tabLabelStyle}
  /// The style for the tab labels.
  /// {@endtemplate}
  final TextStyle? tabLabelStyle;

  /// {@template ShadColorEditor.sliderLabelStyle}
  /// The style for the color slider labels.
  /// {@endtemplate}
  final TextStyle? sliderLabelStyle;

  /// {@template ShadColorEditor.inputLabelStyle}
  /// The [TextStyle] for the color input field labels.
  /// {@endtemplate}
  final TextStyle? inputLabelStyle;

  /// {@template ShadColorEditor.inputStyle}
  /// The [TextStyle] for the color input fields.
  /// {@endtemplate}
  final TextStyle? inputStyle;

  /// {@template ShadColorEditor.inputSuffixStyle}
  /// The [TextStyle] for the color input field suffixes.
  /// {@endtemplate}
  final TextStyle? inputSuffixStyle;

  /// {@template ShadColorEditor.inputDecoration}
  /// The [InputDecoration] for the color input fields.
  /// {@endtemplate}
  final ShadDecoration? inputDecoration;

  /// {@template ShadColorEditor.inputLabelPadding}
  /// The padding around the color input field labels.
  /// {@endtemplate}
  final EdgeInsets? inputLabelPadding;

  /// {@template ShadColorEditor.sliderLabelPadding}
  /// The padding around the color slider labels.
  /// {@endtemplate}
  final EdgeInsets? sliderLabelPadding;

  /// {@template ShadColorEditor.tabsTheme}
  /// Theme overrides for the tab bar in the color picker.
  /// Will be merged with the [ShadTabsTheme] of the current [ShadTheme].
  /// {@endtemplate}
  final ShadTabsTheme? tabsTheme;

  /// {@template ShadColorEditor.sliderTheme}
  /// Theme overrides for the sliders in the color picker.
  /// Will be merged with the [ShadSliderTheme] of the current [ShadTheme].
  /// {@endtemplate}
  final ShadSliderTheme? sliderTheme;

  /// {@template ShadColorEditor.strings}
  /// The strings to use in the color editor.
  /// Can be used to localize the editor.
  /// {@endtemplate}
  final ShadColorEditorStringMap? strings;

  /// Called when the color changes.
  final ValueChanged<Color>? onChanged;

  @override
  State<ShadColorEditor> createState() => _ShadColorEditorState();
}

class _ShadColorEditorState extends State<ShadColorEditor> {
  final ShadTabsController<int> controller = ShadTabsController(value: 0);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final effectiveTabs = widget.tabs ?? theme.colorEditorTheme.tabs ?? [];
    if (controller.selected >= effectiveTabs.length) {
      controller.selected = 0;
    }

    final effectiveTabsPadding = widget.tabsPadding ??
        const EdgeInsets.only(
          bottom: 8,
          left: 4,
          right: 4,
          top: 4,
        );

    return Material(
      type: MaterialType.transparency,
      child: ShadTheme(
        data: theme.copyWith(
          tabsTheme: theme.tabsTheme.mergeWith(
            widget.tabsTheme ?? theme.colorEditorTheme.tabsTheme,
          ),
          sliderTheme: theme.sliderTheme.mergeWith(
            widget.sliderTheme ?? theme.colorEditorTheme.sliderTheme,
          ),
        ),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (effectiveTabs.length > 1)
                Padding(
                  padding: effectiveTabsPadding,
                  child: ShadTabs<int>(
                    tabs: effectiveTabs
                        .mapIndexed(
                          (i, e) => ShadTab(
                        value: i,
                        child: Text(
                          e.title,
                          style: widget.tabLabelStyle,
                        ),
                      ),
                    )
                        .toList(),
                    expandContent: false,
                    controller: controller,
                  ),
                ),
              buildTab(effectiveTabs[controller.selected]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTab(ShadColorEditorTab tab) {
    final centerGap = widget.mainRowSpacing ?? 16;
    return IntrinsicHeight(
      child: switch (
          tab.features.contains(ShadColorEditorFeature.colorArea)) {
        true => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  // Align with text fields and sliders
                  padding: const EdgeInsets.only(left: 4, bottom: 4, top: 4),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ShadColorEditorColorArea(
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                    ),
                  ),
                ),
              ),
              SizedBox(width: centerGap),
              Flexible(flex: 4, child: buildColumn(tab)),
            ],
          ),
        false => buildColumn(tab),
      },
    );
  }

  Widget buildColumn(ShadColorEditorTab tab) {
    final sortedFeatures = tab.features.toList()
      ..removeWhere((e) => !e.sidebar)
      ..sortedByCompare(
        (e) => e.precedence,
        (a, b) => a.compareTo(b),
      );

    if (!widget.controller.transparency) {
      sortedFeatures.remove(ShadColorEditorFeature.alphaSlider);
    }

    final theme = ShadTheme.of(context);
    final effectiveGap = widget.columnSpacing ?? 8;

    final children = <Widget>[];
    var latestSection = 0;
    for (final feature in sortedFeatures) {
      final section = feature.precedence ~/ 10;
      if (latestSection != section) {
        latestSection = section;
        if (children.isNotEmpty) {
          children.add(
            Flexible(
              fit: tab.expandSpacer ? FlexFit.tight : FlexFit.loose,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: effectiveGap),
              ),
            ),
          );
        }
      } else {
        children.add(SizedBox(height: effectiveGap));
      }
      children.add(buildFeature(tab, feature, theme));
    }

    return Column(
      children: children,
    );
  }

  Widget buildFeature(
    ShadColorEditorTab tab,
    ShadColorEditorFeature feat,
    ShadThemeData theme,
  ) {
    final sliderStyle = tab.showSliderLabels
        ? ComponentEditorStyle.sliderLabel
        : ComponentEditorStyle.slider;

    final editorTheme = theme.colorEditorTheme;

    final effectiveColumnSpacing =
        widget.columnSpacing ?? editorTheme.columnSpacing ?? 8;
    final effectiveRowSpacing =
        widget.rowSpacing ?? editorTheme.rowSpacing ?? 4;
    final effectiveSliderLabelStyle =
        widget.sliderLabelStyle ?? editorTheme.sliderLabelStyle;
    final effectiveInputLabelStyle =
        widget.inputLabelStyle ?? editorTheme.inputLabelStyle;
    final effectiveInputStyle = widget.inputStyle ?? editorTheme.inputStyle;
    final effectiveInputSuffixStyle =
        widget.inputSuffixStyle ?? editorTheme.inputSuffixStyle;
    final effectiveInputDecoration =
        widget.inputDecoration ?? editorTheme.inputDecoration;
    final effectiveInputLabelPadding =
        widget.inputLabelPadding ?? editorTheme.inputLabelPadding;
    final effectiveSliderLabelPadding =
        widget.sliderLabelPadding ?? editorTheme.sliderLabelPadding;
    final effectiveStrings = ShadColorEditorStringKey.filled(
      <ShadColorEditorStringKey, String>{
        ...?widget.strings,
        ...?editorTheme.strings,
      },
    );

    switch (feat) {
      case ShadColorEditorFeature.colorArea:
        throw UnimplementedError();
      case ShadColorEditorFeature.hueSlider:
        return ShadHSLComponentSlider(
          component: HSLComponent.hue,
          controller: widget.controller,
          onChanged: widget.onChanged,
          fixedGradient: tab.fixedGradient,
          style: sliderStyle,
          sliderLabelStyle: effectiveSliderLabelStyle,
          sliderLabelPadding: effectiveSliderLabelPadding,
          strings: effectiveStrings,
        );
      case ShadColorEditorFeature.saturationSlider:
        return ShadHSLComponentSlider(
          component: HSLComponent.saturation,
          controller: widget.controller,
          onChanged: widget.onChanged,
          fixedGradient: tab.fixedGradient,
          style: sliderStyle,
          sliderLabelStyle: effectiveSliderLabelStyle,
          sliderLabelPadding: effectiveSliderLabelPadding,
          strings: effectiveStrings,
        );
      case ShadColorEditorFeature.luminanceSlider:
        return ShadHSLComponentSlider(
          component: HSLComponent.luminance,
          controller: widget.controller,
          onChanged: widget.onChanged,
          fixedGradient: tab.fixedGradient,
          style: sliderStyle,
          sliderLabelStyle: effectiveSliderLabelStyle,
          sliderLabelPadding: effectiveSliderLabelPadding,
          strings: effectiveStrings,
        );
      case ShadColorEditorFeature.alphaSlider:
        return ShadHSLComponentSlider(
          component: HSLComponent.alpha,
          controller: widget.controller,
          onChanged: widget.onChanged,
          fixedGradient: tab.fixedGradient,
          style: sliderStyle,
          sliderLabelStyle: effectiveSliderLabelStyle,
          sliderLabelPadding: effectiveSliderLabelPadding,
          strings: effectiveStrings,
        );
      case ShadColorEditorFeature.rgbSliders:
        return Column(
          children: [
            RGBComponentSlider(
              component: RGBComponent.red,
              controller: widget.controller,
              onChanged: widget.onChanged,
              style: sliderStyle,
              sliderLabelStyle: effectiveSliderLabelStyle,
              sliderLabelPadding: effectiveSliderLabelPadding,
              strings: effectiveStrings,
            ),
            SizedBox(height: effectiveColumnSpacing),
            RGBComponentSlider(
              component: RGBComponent.green,
              controller: widget.controller,
              onChanged: widget.onChanged,
              style: sliderStyle,
              sliderLabelStyle: effectiveSliderLabelStyle,
              sliderLabelPadding: effectiveSliderLabelPadding,
              strings: effectiveStrings,
            ),
            SizedBox(height: effectiveColumnSpacing),
            RGBComponentSlider(
              component: RGBComponent.blue,
              controller: widget.controller,
              onChanged: widget.onChanged,
              style: sliderStyle,
              sliderLabelStyle: effectiveSliderLabelStyle,
              sliderLabelPadding: effectiveSliderLabelPadding,
              strings: effectiveStrings,
            ),
          ],
        );
      case ShadColorEditorFeature.hexField:
        return ShadHexComponentInput(
          controller: widget.controller,
          onChanged: widget.onChanged,
          inputStyle: effectiveInputStyle,
        );
      case ShadColorEditorFeature.rgbRow:
        return Row(
          children: [
            Flexible(
              child: RGBComponentSlider(
                component: RGBComponent.red,
                controller: widget.controller,
                onChanged: widget.onChanged,
                inputLabelStyle: effectiveInputLabelStyle,
                inputStyle: effectiveInputStyle,
                inputDecoration: effectiveInputDecoration,
                inputLabelPadding: effectiveInputLabelPadding,
                strings: effectiveStrings,
              ),
            ),
            SizedBox(width: effectiveRowSpacing),
            Flexible(
              child: RGBComponentSlider(
                component: RGBComponent.green,
                controller: widget.controller,
                onChanged: widget.onChanged,
                inputLabelStyle: effectiveInputLabelStyle,
                inputStyle: effectiveInputStyle,
                inputDecoration: effectiveInputDecoration,
                inputLabelPadding: effectiveInputLabelPadding,
                strings: effectiveStrings,
              ),
            ),
            SizedBox(width: effectiveRowSpacing),
            Flexible(
              child: RGBComponentSlider(
                component: RGBComponent.blue,
                controller: widget.controller,
                onChanged: widget.onChanged,
                inputLabelStyle: effectiveInputLabelStyle,
                inputStyle: effectiveInputStyle,
                inputDecoration: effectiveInputDecoration,
                inputLabelPadding: effectiveInputLabelPadding,
                strings: effectiveStrings,
              ),
            ),
          ],
        );
      case ShadColorEditorFeature.hslRow:
        return Row(
          children: [
            Flexible(
              child: ShadHSLComponentSlider(
                component: HSLComponent.hue,
                controller: widget.controller,
                onChanged: widget.onChanged,
                inputLabelStyle: effectiveInputLabelStyle,
                inputStyle: effectiveInputStyle,
                inputSuffixStyle: effectiveInputSuffixStyle,
                inputDecoration: effectiveInputDecoration,
                inputLabelPadding: effectiveInputLabelPadding,
                strings: effectiveStrings,
              ),
            ),
            SizedBox(width: effectiveRowSpacing),
            Flexible(
              child: ShadHSLComponentSlider(
                component: HSLComponent.saturation,
                controller: widget.controller,
                onChanged: widget.onChanged,
                inputLabelStyle: effectiveInputLabelStyle,
                inputStyle: effectiveInputStyle,
                inputSuffixStyle: effectiveInputSuffixStyle,
                inputDecoration: effectiveInputDecoration,
                inputLabelPadding: effectiveInputLabelPadding,
                strings: effectiveStrings,
              ),
            ),
            SizedBox(width: effectiveRowSpacing),
            Flexible(
              child: ShadHSLComponentSlider(
                component: HSLComponent.luminance,
                controller: widget.controller,
                onChanged: widget.onChanged,
                inputLabelStyle: effectiveInputLabelStyle,
                inputStyle: effectiveInputStyle,
                inputSuffixStyle: effectiveInputSuffixStyle,
                inputDecoration: effectiveInputDecoration,
                inputLabelPadding: effectiveInputLabelPadding,
                strings: effectiveStrings,
              ),
            ),
          ],
        );
    }
  }
}

class ShadColorEditorController extends ValueNotifier<HSLColor> {
  ShadColorEditorController(
    super.value, {
    bool transparency = true,
  }) : _transparency = transparency;

  bool _transparency;

  bool get transparency => _transparency;

  set transparency(bool value) {
    _transparency = value;
    if (!transparency) {
      this.value = this.value.withAlpha(1);
    }
  }

  HSLColor get rawColor => value.withAlpha(1);

  set rawColor(HSLColor color) {
    if (transparency) {
      value = color.withAlpha(value.alpha);
    } else {
      value = color.withAlpha(1);
    }
  }

  Color get color => value.toColor();

  Color get hueColor => HSLColor.fromAHSL(1, value.hue, 1, 0.5).toColor();

  set color(Color color) => value = HSLColor.fromColor(color);
}

enum ShadColorEditorFeature {
  colorArea(false, -1),
  hueSlider(true, 1),
  saturationSlider(true, 2),
  luminanceSlider(true, 3),
  alphaSlider(true, 4),
  rgbSliders(true, 5),
  hexField(true, 10),
  rgbRow(true, 11),
  hslRow(true, 12);

  const ShadColorEditorFeature(this.sidebar, this.precedence);

  final int precedence;
  final bool sidebar;
}

enum ShadColorEditorStringKey {
  hue('Hue'),
  saturation('Sat'),
  luminance('Lum'),
  alpha('Alpha'),
  red('Red'),
  green('Green'),
  blue('Blue');

  const ShadColorEditorStringKey(this.defaultValue);

  final String defaultValue;

  String resolve(ShadColorEditorStringMap? map) {
    return map?[this] ?? defaultValue;
  }

  static Map<ShadColorEditorStringKey, String> filled(
    Map<ShadColorEditorStringKey, String>? map,
  ) {
    return {
      for (final key in ShadColorEditorStringKey.values)
        key: map?[key] ?? key.defaultValue,
    };
  }
}

class ShadColorEditorTab {
  const ShadColorEditorTab({
    required this.title,
    required this.features,
    this.showSliderLabels = false,
    this.expandSpacer = true,
    this.fixedGradient = false,
  });

  final String title;
  final Set<ShadColorEditorFeature> features;
  final bool showSliderLabels;
  final bool expandSpacer;
  final bool fixedGradient;
}

class ShadColorEditorColorArea extends StatefulWidget {
  const ShadColorEditorColorArea({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
  });

  final ShadColorEditorController controller;
  final FocusNode? focusNode;
  final ValueChanged<Color>? onChanged;

  @override
  State<ShadColorEditorColorArea> createState() =>
      _ShadColorEditorColorAreaState();
}

class _ShadColorEditorColorAreaState extends State<ShadColorEditorColorArea> {
  double x = 0;
  double y = 0;
  double hue = 0;
  bool isFocused = false;

  late final FocusNode focusNode = widget.focusNode ?? FocusNode();

  double get cHue => widget.controller.value.hue;

  Color get cColor => widget.controller.color;

  @override
  void initState() {
    final (ix, iy) = _findXYH(cHue, cColor);
    x = ix;
    y = iy;
    hue = cHue;

    widget.controller.addListener(handleUpdate);

    super.initState();
  }

  void handleUpdate() {
    setState(() {
      final distance = _colorDistance(cColor, _colorFromXYH(hue, x, y));
      if (distance > _xyhTolerance) {
        final (x, y) = _adjustXYH(cHue, cColor, this.x, this.y);
        this.x = x;
        this.y = y;
        hue = cHue;
      } else {
        hue = cHue;
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleUpdate);
    super.dispose();
  }

  void moveCursor(double dx, double dy) {
    setState(() {
      x = (x + dx).clamp(0.0, 1.0);
      y = (y + dy).clamp(0.0, 1.0);
      widget.controller.rawColor = _transformXYH(hue, x, y);
      widget.onChanged?.call(cColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (focused) {
        setState(() {
          isFocused = focused;
        });
      },
      onKeyEvent: (node, event) {
        const sensitivity = 0.02;
        final isEffective = event is KeyDownEvent || event is KeyRepeatEvent;
        switch (event.logicalKey) {
          case LogicalKeyboardKey.arrowLeft:
            if (isEffective) moveCursor(-sensitivity, 0);
            return KeyEventResult.handled;
          case LogicalKeyboardKey.arrowRight:
            if (isEffective) moveCursor(sensitivity, 0);
            return KeyEventResult.handled;
          case LogicalKeyboardKey.arrowUp:
            if (isEffective) moveCursor(0, -sensitivity);
            return KeyEventResult.handled;
          case LogicalKeyboardKey.arrowDown:
            if (isEffective) moveCursor(0, sensitivity);
            return KeyEventResult.handled;
          default:
            return KeyEventResult.ignored;
        }
      },
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            final size = context.size!;
            x = (details.localPosition.dx / size.width).clamp(0.0, 1.0);
            y = (details.localPosition.dy / size.height).clamp(0.0, 1.0);
            widget.controller.rawColor = _transformXYH(hue, x, y);
            widget.onChanged?.call(cColor);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            final size = context.size!;
            x = (details.localPosition.dx / size.width).clamp(0.0, 1.0);
            y = (details.localPosition.dy / size.height).clamp(0.0, 1.0);
            widget.controller.rawColor = _transformXYH(hue, x, y);
            widget.onChanged?.call(cColor);
          });
        },
        child: CustomPaint(
          painter: ShadColorEditorColorFieldPainter(
            hue: hue,
            x: x,
            y: y,
            theme: ShadTheme.of(context),
            isFocused: isFocused,
          ),
        ),
      ),
    );
  }
}

enum HSLComponent {
  hue,
  saturation,
  luminance,
  alpha;

  double get maxEditorValue => switch (this) {
        HSLComponent.hue => 360,
        HSLComponent.saturation => 100,
        HSLComponent.luminance => 100,
        HSLComponent.alpha => 100,
      };

  double getValue(HSLColor color) {
    return switch (this) {
      HSLComponent.hue => color.hue / 360,
      HSLComponent.saturation => color.saturation,
      HSLComponent.luminance => color.lightness,
      HSLComponent.alpha => color.alpha,
    };
  }

  HSLColor applyValue(HSLColor color, double value) {
    return switch (this) {
      HSLComponent.hue => HSLColor.fromAHSL(
          color.alpha,
          clampDouble(value * 360, 0, 360),
          color.saturation,
          color.lightness,
        ),
      HSLComponent.saturation => HSLColor.fromAHSL(
          color.alpha,
          color.hue,
          clampDouble(value, 0, 1),
          color.lightness,
        ),
      HSLComponent.luminance => HSLColor.fromAHSL(
          color.alpha,
          color.hue,
          color.saturation,
          clampDouble(value, 0, 1),
        ),
      HSLComponent.alpha => HSLColor.fromAHSL(
          clampDouble(value, 0, 1),
          color.hue,
          color.saturation,
          color.lightness,
        ),
    };
  }

  LinearGradient createGradient(HSLColor color, bool fixedGradient) {
    if (fixedGradient) {
      return switch (this) {
        HSLComponent.hue => _hlsHueGradient,
        HSLComponent.saturation =>
          const LinearGradient(colors: [Colors.grey, Colors.red]),
        HSLComponent.luminance =>
          const LinearGradient(colors: [Colors.black, Colors.white]),
        HSLComponent.alpha => const LinearGradient(
            colors: [Colors.transparent, Colors.black],
          ),
      };
    } else {
      return switch (this) {
        HSLComponent.hue => _sampleGradient(
            16,
            (time) => HSLColor.fromAHSL(
              1,
              time * 360,
              color.saturation,
              color.lightness,
            ).toColor(),
          ),
        HSLComponent.saturation => _sampleGradient(
            16,
            (time) => HSLColor.fromAHSL(1, color.hue, time, color.lightness)
                .toColor(),
          ),
        HSLComponent.luminance => _sampleGradient(
            16,
            (time) => HSLColor.fromAHSL(1, color.hue, color.saturation, time)
                .toColor(),
          ),
        HSLComponent.alpha => LinearGradient(
            colors: [
              HSLColor.fromAHSL(0, color.hue, color.saturation, color.lightness)
                  .toColor(),
              HSLColor.fromAHSL(1, color.hue, color.saturation, color.lightness)
                  .toColor(),
            ],
          ),
      };
    }
  }
}

enum ComponentEditorStyle { slider, sliderLabel, input }

enum RGBComponent {
  red,
  green,
  blue,
  alpha;

  double getValue(Color color) {
    return switch (this) {
      RGBComponent.red => color.red / 255,
      RGBComponent.green => color.green / 255,
      RGBComponent.blue => color.blue / 255,
      RGBComponent.alpha => color.alpha / 255,
    };
  }

  Color applyValue(Color color, double value) {
    return switch (this) {
      RGBComponent.red => Color.fromARGB(
          color.alpha,
          (value * 255).toInt(),
          color.green,
          color.blue,
        ),
      RGBComponent.green => Color.fromARGB(
          color.alpha,
          color.red,
          (value * 255).toInt(),
          color.blue,
        ),
      RGBComponent.blue => Color.fromARGB(
          color.alpha,
          color.red,
          color.green,
          (value * 255).toInt(),
        ),
      RGBComponent.alpha => Color.fromARGB(
          (value * 255).toInt(),
          color.red,
          color.green,
          color.blue,
        ),
    };
  }
}

class ShadHexComponentInput extends StatelessWidget {
  const ShadHexComponentInput({
    super.key,
    required this.controller,
    required this.inputStyle,
    this.onChanged,
  });

  final ShadColorEditorController controller;
  final TextStyle? inputStyle;
  final ValueChanged<Color>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return ShadInput(
          controller: TextEditingController(
            text: colorToHex(value.toColor()),
          ),
          inputFormatters: switch (controller.transparency) {
            true => [
                FilteringTextInputFormatter.allow(RegExp('^#?[0-9a-fA-F]*')),
                LengthLimitingTextInputFormatter(9),
              ],
            false => [
                FilteringTextInputFormatter.allow(RegExp('^#?[0-9a-fA-F]*')),
                LengthLimitingTextInputFormatter(7),
              ],
          },
          onSubmitted: (text) {
            final parsed = colorFromHex(text);
            if (parsed == null) return;
            controller.value = HSLColor.fromColor(parsed);
            onChanged?.call(controller.value.toColor());
          },
        );
      },
    );
  }
}

class ShadHSLComponentSlider extends StatefulWidget {
  const ShadHSLComponentSlider({
    super.key,
    required this.component,
    required this.controller,
    this.strings,
    this.onChanged,
    this.fixedGradient = false,
    this.style = ComponentEditorStyle.input,
    this.sliderLabelStyle,
    this.inputLabelStyle,
    this.inputStyle,
    this.inputSuffixStyle,
    this.inputDecoration,
    this.inputLabelPadding,
    this.sliderLabelPadding,
  });

  final HSLComponent component;
  final ShadColorEditorController controller;
  final bool fixedGradient;
  final ComponentEditorStyle style;
  final TextStyle? sliderLabelStyle;
  final TextStyle? inputLabelStyle;
  final TextStyle? inputStyle;
  final TextStyle? inputSuffixStyle;
  final ShadDecoration? inputDecoration;
  final EdgeInsets? inputLabelPadding;
  final EdgeInsets? sliderLabelPadding;

  final ValueChanged<Color>? onChanged;
  final ShadColorEditorStringMap? strings;

  @override
  State<ShadHSLComponentSlider> createState() => _ShadHSLComponentSliderState();
}

class _ShadHSLComponentSliderState extends State<ShadHSLComponentSlider> {
  double value = 0;
  bool isFocused = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    updateValue();
    widget.controller.addListener(updateValue);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateValue);
    super.dispose();
  }

  void updateValue() {
    setState(() {
      value = widget.component.getValue(widget.controller.value);
      final newText =
          (value * widget.component.maxEditorValue).round().toString();
      if (textController.text != newText) {
        textController.text = newText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      skipTraversal: true,
      onFocusChange: (focused) {
        setState(() {
          isFocused = focused;
        });
      },
      child: switch (widget.style) {
        ComponentEditorStyle.slider => _buildSlider(context, false),
        ComponentEditorStyle.sliderLabel => _buildSlider(context, true),
        ComponentEditorStyle.input => _buildInput(context),
      },
    );
  }

  String get labelContent => switch (widget.component) {
        HSLComponent.hue =>
          ShadColorEditorStringKey.hue.resolve(widget.strings),
        HSLComponent.saturation =>
          ShadColorEditorStringKey.saturation.resolve(widget.strings),
        HSLComponent.luminance =>
          ShadColorEditorStringKey.luminance.resolve(widget.strings),
        HSLComponent.alpha =>
          ShadColorEditorStringKey.alpha.resolve(widget.strings),
      };

  Widget _buildInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.inputLabelPadding ?? const EdgeInsets.only(left: 4),
          child: Text(
            labelContent,
            style: widget.inputLabelStyle,
          ),
        ),
        ShadInput(
          controller: textController,
          style: widget.inputStyle,
          decoration: widget.inputDecoration,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.end,
          gap: 0,
          suffix: Text(
            widget.component.maxEditorValue == 360 ? '°' : '%',
            style: widget.inputSuffixStyle,
          ),
          maxLength: 3,
          onSubmitted: (text) {
            final parsed = int.tryParse(text);
            if (parsed == null) return;
            final newValue = parsed / widget.component.maxEditorValue;
            widget.controller.value = widget.component.applyValue(
              widget.controller.value,
              newValue,
            );
            widget.onChanged?.call(widget.controller.color);
          },
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, bool useLabel) {
    final theme = ShadTheme.of(context);
    final gradient = widget.component.createGradient(
      widget.controller.value,
      widget.fixedGradient,
    );
    return Padding(
      padding: useLabel
          ? widget.sliderLabelPadding ?? const EdgeInsets.only(left: 4)
          : EdgeInsets.zero,
      child: Row(
        children: [
          if (useLabel)
            Expanded(
              child: Text(
                labelContent,
                style: widget.sliderLabelStyle,
              ),
            ),
          Flexible(
            flex: 3,
            child: CustomPaint(
              painter: GradientTrackPainter(
                gradient: gradient,
                theme: theme,
                checkerboard: widget.component == HSLComponent.alpha,
              ),
              child: SliderTheme(
                data: Theme.of(context).sliderTheme.copyWith(
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbShape: ShadSliderThumbShape(
                        radius: theme.sliderTheme.thumbRadius!,
                        borderColor: theme.sliderTheme.thumbBorderColor!,
                        thumbColor: switch (widget.fixedGradient) {
                          true => Color.alphaBlend(
                              _calcGradientColor(value, gradient),
                              theme.sliderTheme.thumbColor ?? Colors.white,
                            ),
                          false => widget.controller.color.withOpacity(1),
                        },
                        disabledBorderColor: Colors.white,
                        disabledThumbColor: Colors.white,
                        focused: isFocused,
                      ),
                    ),
                child: Slider(
                  value: value,
                  onChanged: (newVal) {
                    widget.controller.value = widget.component.applyValue(
                      widget.controller.value,
                      newVal,
                    );
                    widget.onChanged?.call(widget.controller.color);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RGBComponentSlider extends StatefulWidget {
  const RGBComponentSlider({
    super.key,
    required this.component,
    required this.controller,
    this.onChanged,
    this.style = ComponentEditorStyle.input,
    this.sliderLabelStyle,
    this.inputLabelStyle,
    this.inputStyle,
    this.inputDecoration,
    this.inputLabelPadding,
    this.sliderLabelPadding,
    this.strings,
  });

  final RGBComponent component;
  final ShadColorEditorController controller;
  final ComponentEditorStyle style;
  final TextStyle? sliderLabelStyle;
  final TextStyle? inputLabelStyle;
  final TextStyle? inputStyle;
  final ShadDecoration? inputDecoration;
  final ValueChanged<Color>? onChanged;
  final EdgeInsets? inputLabelPadding;
  final EdgeInsets? sliderLabelPadding;
  final ShadColorEditorStringMap? strings;

  @override
  State<RGBComponentSlider> createState() => _RGBComponentSliderState();
}

class _RGBComponentSliderState extends State<RGBComponentSlider> {
  final ShadSliderController sliderController =
      ShadSliderController(initialValue: 0);
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    updateController();
    widget.controller.addListener(updateController);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateController);
    super.dispose();
  }

  void updateController() {
    sliderController.value = widget.component.getValue(widget.controller.color);
    final newText = (sliderController.value * 255).round().toString();
    if (textController.text != newText) {
      textController.text = newText;
    }
  }

  String get labelContent => switch (widget.component) {
        RGBComponent.red =>
          ShadColorEditorStringKey.red.resolve(widget.strings),
        RGBComponent.green =>
          ShadColorEditorStringKey.green.resolve(widget.strings),
        RGBComponent.blue =>
          ShadColorEditorStringKey.blue.resolve(widget.strings),
        RGBComponent.alpha =>
          ShadColorEditorStringKey.alpha.resolve(widget.strings),
      };

  @override
  Widget build(BuildContext context) {
    return switch (widget.style) {
      ComponentEditorStyle.slider => _buildSlider(context, false),
      ComponentEditorStyle.sliderLabel => _buildSlider(context, true),
      ComponentEditorStyle.input => _buildInput(context),
    };
  }

  Widget _buildInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.inputLabelPadding ?? const EdgeInsets.only(left: 4),
          child: Text(
            labelContent,
            style: widget.inputLabelStyle,
          ),
        ),
        ShadInput(
          controller: textController,
          style: widget.inputStyle,
          decoration: widget.inputDecoration,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          gap: 0,
          maxLength: 3,
          onSubmitted: (text) {
            final parsed = int.tryParse(text);
            if (parsed == null) return;
            final newValue = parsed / 255;
            widget.controller.color = widget.component.applyValue(
              widget.controller.color,
              newValue,
            );
            widget.onChanged?.call(widget.controller.color);
          },
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, bool useLabel) {
    return Padding(
      padding: useLabel
          ? widget.sliderLabelPadding ?? const EdgeInsets.only(left: 4)
          : EdgeInsets.zero,
      child: Row(
        children: [
          if (useLabel)
            Expanded(
              child: Text(
                labelContent,
                style: widget.sliderLabelStyle,
              ),
            ),
          Flexible(
            flex: 3,
            child: ShadSlider(
              controller: sliderController,
              onChanged: (v) {
                final color = widget.controller.color;
                widget.controller.color = widget.component.applyValue(color, v);
                widget.onChanged?.call(widget.controller.color);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShadColorEditorColorFieldPainter extends CustomPainter {
  ShadColorEditorColorFieldPainter({
    required this.hue,
    required this.x,
    required this.y,
    required this.theme,
    this.isFocused = false,
  }) {
    xGradient = LinearGradient(
      colors: [
        Colors.white,
        HSLColor.fromAHSL(1, hue, 1, 0.5).toColor(),
      ],
    );
    yGradient = const LinearGradient(
      colors: [
        Colors.white,
        Colors.black,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  final double hue;
  final double x;
  final double y;
  final ShadThemeData theme;
  final bool isFocused;

  late LinearGradient xGradient;
  late LinearGradient yGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rounded = theme.radius.toRRect(rect);

    canvas
      ..drawRRect(
        rounded,
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..shader = xGradient.createShader(rect),
      )
      ..drawRRect(
        rounded,
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..shader = yGradient.createShader(rect)
          ..blendMode = BlendMode.multiply,
      );

    final cursorPos = Offset(x * size.width, y * size.height);
    final radius = theme.sliderTheme.thumbRadius!;
    final actualRadius = switch (isFocused) {
      true => radius + 4,
      false => radius,
    };
    final color = _colorFromXYH(hue, x, y);
    canvas
      ..drawShadow(
        Path()
          ..addOval(Rect.fromCircle(center: cursorPos, radius: actualRadius)),
        Colors.black,
        4,
        false,
      )
      ..drawCircle(
        cursorPos,
        actualRadius,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      )
      ..drawCircle(
        cursorPos,
        radius,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );

    if (isFocused) {
      canvas.drawCircle(
        cursorPos,
        actualRadius,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(ShadColorEditorColorFieldPainter oldDelegate) {
    return oldDelegate.hue != hue ||
        oldDelegate.x != x ||
        oldDelegate.y != y ||
        oldDelegate.isFocused != isFocused;
  }
}

class GradientTrackPainter extends CustomPainter {
  GradientTrackPainter({
    required this.gradient,
    required this.theme,
    this.checkerboard = false,
  });

  final LinearGradient gradient;
  final ShadThemeData theme;
  final bool checkerboard;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - theme.sliderTheme.thumbRadius! * 2,
      // Don't ask me why + 2, but otherwise the sizes don't match
      height: (theme.sliderTheme.trackHeight ?? 8) + 2,
    );

    final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    final avgLuminance = gradient.colors
            .map((e) => e.computeLuminance())
            .reduce((a, b) => a + b) /
        gradient.colors.length;

    if (avgLuminance > 0.5 && theme.brightness == Brightness.light) {
      final lerp = (avgLuminance - 0.5) / 0.5;
      _paintBoxShadows(
        canvas,
        rounded,
        [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        opacity: lerp,
      );
    } else if (avgLuminance < 0.5 && theme.brightness == Brightness.dark) {
      final lerp = (0.5 - avgLuminance) / 0.5;
      _paintBoxShadows(
        canvas,
        rounded,
        [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        opacity: lerp,
      );
    }

    if (checkerboard) {
      canvas.clipRRect(rounded);

      final quadHeight = rect.height / 2;
      const evenColor = Color(0xFFE0E0E0);
      const oddColor = Color(0xFFB0B0B0);

      final xCount = (rect.width / quadHeight).ceil();

      for (var x = 0; x < xCount; x++) {
        for (var y = 0; y < 2; y++) {
          final color = (x + y).isEven ? evenColor : oddColor;
          final r = Rect.fromLTWH(
            x * quadHeight + rect.left,
            y * quadHeight + rect.top,
            quadHeight,
            quadHeight,
          );
          canvas.drawRect(r, Paint()..color = color);
        }
      }
    }
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GradientTrackPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.checkerboard != checkerboard;
  }
}

class ColorPreviewPainter extends CustomPainter {
  const ColorPreviewPainter({
    required this.color,
    required this.radius,
    required this.checkerboard,
    required this.showAlpha,
    required this.shadows,
  });

  final Color color;
  final BorderRadius radius;
  final bool checkerboard;
  final bool showAlpha;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rounded = radius.toRRect(rect);

    _paintBoxShadows(canvas, rounded, shadows);

    if (checkerboard && color.alpha < 255) {
      canvas.clipRRect(rounded);

      final quadHeight = rect.height / 2;
      const evenColor = Color(0xFFE0E0E0);
      const oddColor = Color(0xFFB0B0B0);

      final xCount = (rect.width / quadHeight).ceil();

      for (var x = 0; x < xCount; x++) {
        for (var y = 0; y < 2; y++) {
          final color = (x + y).isEven ? evenColor : oddColor;
          final r = Rect.fromLTWH(
            x * quadHeight + rect.left,
            y * quadHeight + rect.top,
            quadHeight,
            quadHeight,
          );
          canvas.drawRect(r, Paint()..color = color);
        }
      }
    }

    final paint = Paint()
      ..color = switch (showAlpha) {
        true => color,
        false => color.withOpacity(1),
      }
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rounded, paint);
  }

  @override
  bool shouldRepaint(covariant ColorPreviewPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.checkerboard != checkerboard ||
        oldDelegate.showAlpha != showAlpha ||
        oldDelegate.radius != radius;
  }
}

//<editor-fold desc="Utils">
String colorToHex(Color color) {
  var hex = color.value.toRadixString(16).padLeft(8, '0');
  if (hex.startsWith('ff')) {
    hex = hex.substring(2);
  }
  return '#$hex';
}

Color? colorFromHex(String hex) {
  var trimmed = hex.replaceAll('#', '');
  if (trimmed.length == 6) {
    trimmed = 'ff$hex';
  }
  final parsed = int.tryParse(trimmed, radix: 16);
  return parsed != null ? Color(parsed) : null;
}

final LinearGradient _hlsHueGradient = _sampleGradient(
  360,
  (time) => HSLColor.fromAHSL(1, time * 360, 1, 0.5).toColor(),
);

LinearGradient _sampleGradient(
  int sampleSize,
  Color Function(double time) sampler,
) {
  return LinearGradient(
    colors: List.generate(sampleSize, (i) => sampler(i / (sampleSize - 1))),
  );
}

void _paintBoxShadows(
  Canvas canvas,
  RRect rect,
  List<BoxShadow> shadows, {
  double opacity = 1,
}) {
  for (final shadow in shadows) {
    final spreadRect = rect.inflate(shadow.spreadRadius);
    final shadowRect = spreadRect.shift(shadow.offset);
    final paint = Paint()
      ..color = shadow.color.withOpacity(shadow.color.opacity * opacity)
      ..maskFilter = MaskFilter.blur(shadow.blurStyle, shadow.blurSigma);
    canvas.drawRRect(shadowRect, paint);
  }
}

/// Computes the value of the gradient at the given time.
Color _calcGradientColor(double t, LinearGradient gradient) {
  final colors = gradient.colors;
  var stops = gradient.stops;
  if (stops == null) {
    final count = colors.length;
    final step = 1 / (count - 1);
    stops = List.generate(count, (index) => index * step);
  }
  assert(colors.length == stops.length);
  if (colors.length == 1) {
    return colors[0];
  }
  if (t <= stops.first) {
    return colors.first;
  }
  if (t >= stops.last) {
    return colors.last;
  }
  for (var i = 0; i < stops.length - 1; i++) {
    final start = stops[i];
    final end = stops[i + 1];
    if (t >= start && t <= end) {
      final scaledT = (t - start) / (end - start);
      return Color.lerp(colors[i], colors[i + 1], scaledT)!;
    }
  }
  return colors.last;
}

/// The tolerance for the XYH color picker.
const double _xyhTolerance = 2;

/// Returns the color at the given XYH point.
Color _colorFromXYH(double hue, double x, double y) {
  final hueColor = HSLColor.fromAHSL(1, hue, 1, 0.5).toColor();
  final invY = 1 - clampDouble(y, 0, 1);
  final xColor = Color.lerp(Colors.white, hueColor, clampDouble(x, 0, 1))!;
  return Color.fromARGB(
    255,
    (xColor.red * invY).toInt(),
    (xColor.green * invY).toInt(),
    (xColor.blue * invY).toInt(),
  );
}

/// Clamps the give XYH point to the valid range of 0 to 1.
(double, double) _clampXYH(double x, double y) {
  return (x.clamp(0, 1), y.clamp(0, 1));
}

/// Transform a XYH value to [HSLColor] with the given hue.
HSLColor _transformXYH(double hue, double x, double y) {
  // This almost always is exactly the same color regardless of the changed
  // hue. I initially wrote an algorithm to adjust it if it wasn't, but it
  // was effectively never triggered in practice therefore I removed it.
  return HSLColor.fromColor(_colorFromXYH(hue, x, y)).withHue(hue);
}

/// Adjusts the x and y values to be approximately the target color using an
/// iterative search algorithm. Returns an (x, y) tuple with the best
/// approximation.
///
/// Will fall back to [_findXYH] if the color is too far away from the target.
(double x, double y) _adjustXYH(
  double hue,
  Color target,
  double xPrev,
  double yPrev,
) {
  const minS = 0.001;
  var d = _colorDistance(target, _colorFromXYH(hue, xPrev, yPrev));
  // Only search if the color is close enough to justify the smoothing
  if (d < 64) {
    var (x, y) = (xPrev, yPrev);
    var s = 0.075;
    var i = 0;
    var f = false; // Orthogonal search flag
    while (i++ < 16) {
      // ignore: avoid_multiple_declarations_per_line
      final double x1, y1, x2, y2, x3, y3, x4, y4;
      if (f) {
        (x1, y1) = _clampXYH(x - s, y - s);
        (x2, y2) = _clampXYH(x + s, y - s);
        (x3, y3) = _clampXYH(x - s, y + s);
        (x4, y4) = _clampXYH(x + s, y + s);
      } else {
        (x1, y1) = _clampXYH(x - s, y);
        (x2, y2) = _clampXYH(x + s, y);
        (x3, y3) = _clampXYH(x, y - s);
        (x4, y4) = _clampXYH(x, y + s);
      }
      final d1 = _colorDistance(target, _colorFromXYH(hue, x1, y1));
      final d2 = _colorDistance(target, _colorFromXYH(hue, x2, y2));
      final d3 = _colorDistance(target, _colorFromXYH(hue, x3, y3));
      final d4 = _colorDistance(target, _colorFromXYH(hue, x4, y4));
      final minDist = [d, d1, d2, d3, d4].reduce(min);
      if (minDist == d) {
        s /= 4;
        if (s < minS) {
          if (f) {
            // Center is still the best, but we are already at the minimum
            // step size, so we can't go any further.
            break;
          }
          // Try searching orthogonally, sometimes this finds a solution
          f = true;
          s = 0.01;
        }
      } else if (minDist == d1) {
        (x, y) = (x1, y1);
      } else if (minDist == d2) {
        (x, y) = (x2, y2);
      } else if (minDist == d3) {
        (x, y) = (x3, y3);
      } else {
        (x, y) = (x4, y4);
      }
      if (minDist != d) {}

      d = minDist;
      if (d < _xyhTolerance) break;
    }
    return (x, y);
  } else {
    return _findXYH(hue, target);
  }
}

/// Finds the x and y values for a given hue and color that are closest to the
/// target color using divide-and-conquer algorithm derived from a binary
/// search. Returns an (x, y) tuple with the best approximation.
(double x, double y) _findXYH(double hue, Color color) {
  final target = color;
  var x = 0.5;
  var y = 0.5;
  var step = 0.25;
  for (var i = 0; i < 8; i++) {
    final (x1, y1) = (x - step, y - step);
    final (x2, y2) = (x + step, y + step);
    final (x3, y3) = (x - step, y + step);
    final (x4, y4) = (x + step, y - step);
    final d1 = _colorDistance(target, _colorFromXYH(hue, x1, y1));
    final d2 = _colorDistance(target, _colorFromXYH(hue, x2, y2));
    final d3 = _colorDistance(target, _colorFromXYH(hue, x3, y3));
    final d4 = _colorDistance(target, _colorFromXYH(hue, x4, y4));
    final minDist = [d1, d2, d3, d4].reduce(min);
    if (minDist == d1) {
      (x, y) = (x1, y1);
    } else if (minDist == d2) {
      (x, y) = (x2, y2);
    } else if (minDist == d3) {
      (x, y) = (x3, y3);
    } else {
      (x, y) = (x4, y4);
    }
    step /= 2;
  }
  return (x, y);
}

/// Returns the euclidean distance between two colors.
double _colorDistance(Color a, Color b) {
  final dr = a.red - b.red;
  final dg = a.green - b.green;
  final db = a.blue - b.blue;
  return sqrt(dr * dr + dg * dg + db * db);
}
//</editor-fold>

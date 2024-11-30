import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  final controller = ShadColorPickerController(
    const HSLColor.fromAHSL(1, 0, 1, 0.5),
  );

  void showColorPicker(BuildContext context) {
    showShadDialog<void>(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Color Picker'),
        constraints: const BoxConstraints(maxWidth: 600),
        child: ColorPickerTabView(
          tabs: const [
            ShadColorPickerTab(
              title: 'HSL',
              features: {
                ShadColorPickerFeature.colorPicker,
                ShadColorPickerFeature.hueSlider,
                ShadColorPickerFeature.alphaSlider,
                ShadColorPickerFeature.hexField,
                ShadColorPickerFeature.hslRow,
              },
            ),
            ShadColorPickerTab(
              title: 'RGB',
              features: {
                ShadColorPickerFeature.colorPicker,
                ShadColorPickerFeature.hueSlider,
                ShadColorPickerFeature.alphaSlider,
                ShadColorPickerFeature.hexField,
                ShadColorPickerFeature.rgbRow,
              },
            ),
            ShadColorPickerTab(
              title: 'VisHSL',
              features: {
                ShadColorPickerFeature.colorPicker,
                ShadColorPickerFeature.hueSlider,
                ShadColorPickerFeature.saturationSlider,
                ShadColorPickerFeature.luminanceSlider,
                ShadColorPickerFeature.alphaSlider,
                ShadColorPickerFeature.hexField,
                ShadColorPickerFeature.hslRow,
              },
              showSliderLabels: true,
            ),
            ShadColorPickerTab(
              title: 'VisRGB',
              features: {
                ShadColorPickerFeature.colorPicker,
                ShadColorPickerFeature.rgbSliders,
                ShadColorPickerFeature.alphaSlider,
                ShadColorPickerFeature.hexField,
                ShadColorPickerFeature.rgbRow,
              },
              showSliderLabels: true,
            ),
          ],
          controller: controller,
        ),
      ),
    );
  }

  runApp(
    ShadApp.material(
      darkTheme: ShadThemeData(
          colorScheme: const ShadNeutralColorScheme.dark(),
          brightness: Brightness.dark),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: value.toColor(),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      return ShadDecorator(
                          decoration: ShadTheme.of(context)
                              .decoration
                              .mergeWith(
                                  ShadTheme.of(context).selectTheme.decoration),
                          child: Padding(
                            padding: ShadTheme.of(context).inputTheme.padding!,
                            child: Text("Color"),
                          ));
                    },
                  ),
                  ShadColorPicker(
                    controller: controller,
                  ),
                  Builder(
                    builder: (context) {
                      return ShadButton.outline(
                        padding:
                            ShadTheme.of(context).datePickerTheme.buttonPadding,
                        height: ShadTheme.of(context).datePickerTheme.height,
                        size: ShadButtonSize.sm,
                        onPressed: () {
                          showColorPicker(context);
                        },
                        child: Row(
                          children: [
                            Text(
                                '#${controller.color.value.toRadixString(16)}'),
                            const SizedBox(width: 8),
                            ValueListenableBuilder(
                              valueListenable: controller,
                              builder: (context, value, _) {
                                return SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CustomPaint(
                                    painter: ColorPreviewPainter(
                                      color: value.toColor(),
                                      radius: BorderRadius.circular(4),
                                      checkerboard: true,
                                      showAlpha: true,
                                      shadows: ShadShadows.sm,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ShadSelect<String>(
                    initialValue: '1',
                    options: [
                      ShadOption(value: "1", child: const Text("One")),
                      ShadOption(value: "2", child: const Text("Two")),
                      ShadOption(value: "3", child: const Text("Three")),
                    ],
                    selectedOptionBuilder: (context, option) {
                      return Text(option);
                    },
                  )
                ],
              ),
              Builder(
                builder: (context) {
                  return ShadButton(
                    onPressed: () {
                      showColorPicker(context);
                    },
                    child: const Text("Open Color Picker"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class ShadColorPicker extends StatefulWidget {
  const ShadColorPicker({
    super.key,
    this.popoverController,
    this.controller,
  });

  final ShadPopoverController? popoverController;
  final ShadColorPickerController? controller;

  @override
  State<ShadColorPicker> createState() => _ShadColorPickerState();
}

class _ShadColorPickerState extends State<ShadColorPicker> {
  ShadColorPickerController? _controller;

  ShadColorPickerController get controller => widget.controller ?? _controller!;

  ShadPopoverController? _popoverController;

  ShadPopoverController get popoverController =>
      widget.popoverController ?? _popoverController!;

  @override
  void initState() {
    if (widget.controller == null) {
      _controller =
          ShadColorPickerController(const HSLColor.fromAHSL(1, 0, 1, 0.5));
    }

    if (widget.popoverController == null) {
      _popoverController = ShadPopoverController();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      controller: popoverController,
      popover: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
            ),
            child: ColorPickerTabView(
              tabs: const [
                ShadColorPickerTab(
                  title: 'HSL',
                  features: {
                    ShadColorPickerFeature.colorPicker,
                    ShadColorPickerFeature.hueSlider,
                    ShadColorPickerFeature.alphaSlider,
                    ShadColorPickerFeature.hexField,
                    ShadColorPickerFeature.hslRow,
                  },
                ),
                ShadColorPickerTab(
                  title: 'RGB',
                  features: {
                    ShadColorPickerFeature.colorPicker,
                    ShadColorPickerFeature.hueSlider,
                    ShadColorPickerFeature.alphaSlider,
                    ShadColorPickerFeature.hexField,
                    ShadColorPickerFeature.rgbRow,
                  },
                ),
                ShadColorPickerTab(
                  title: 'VisHSL',
                  features: {
                    ShadColorPickerFeature.colorPicker,
                    ShadColorPickerFeature.hueSlider,
                    ShadColorPickerFeature.saturationSlider,
                    ShadColorPickerFeature.luminanceSlider,
                    ShadColorPickerFeature.alphaSlider,
                    ShadColorPickerFeature.hexField,
                    ShadColorPickerFeature.hslRow,
                  },
                  showSliderLabels: true,
                ),
                ShadColorPickerTab(
                    title: 'VisRGB',
                    features: {
                      ShadColorPickerFeature.colorPicker,
                      ShadColorPickerFeature.rgbSliders,
                      ShadColorPickerFeature.alphaSlider,
                      ShadColorPickerFeature.hexField,
                      ShadColorPickerFeature.rgbRow,
                    },
                    showSliderLabels: true),
              ],
              controller: controller,
            ),
          ),
        );
      },
      child: ShadButton.outline(
        padding: ShadTheme.of(context).datePickerTheme.buttonPadding,
        height: ShadTheme.of(context).datePickerTheme.height,
        size: ShadButtonSize.sm,
        onPressed: () {
          popoverController.toggle();
        },
        child: Row(
          children: [
            Text('#${controller.color.value.toRadixString(16)}'),
            const SizedBox(width: 8),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, _) {
                return SizedBox(
                  width: 16,
                  height: 16,
                  child: CustomPaint(
                    painter: ColorPreviewPainter(
                      color: value.toColor(),
                      radius: BorderRadius.circular(4),
                      checkerboard: true,
                      showAlpha: true,
                      shadows: ShadShadows.sm,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerTabView extends StatefulWidget {
  const ColorPickerTabView(
      {super.key, required this.tabs, required this.controller});

  final List<ShadColorPickerTab> tabs;
  final ShadColorPickerController controller;

  @override
  State<ColorPickerTabView> createState() => _ColorPickerTabViewState();
}

class _ColorPickerTabViewState extends State<ColorPickerTabView> {
  final ShadTabsController<int> controller = ShadTabsController(value: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.tabs.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ShadTabs<int>(
                tabs: widget.tabs
                    .mapIndexed((i, e) => ShadTab(
                          value: i,
                          child: Text(e.title),
                        ))
                    .toList(),
                expandContent: false,
                controller: controller,
                onChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          widget.tabs[currentIndex].build(widget.controller),
        ],
      ),
    );
  }
}

enum ShadColorPickerFeature {
  colorPicker,
  hueSlider,
  alphaSlider,
  saturationSlider,
  luminanceSlider,
  rgbSliders,
  hexField,
  rgbRow,
  hslRow;
}

class ShadColorPickerTab {
  const ShadColorPickerTab({
    required this.title,
    required this.features,
    this.showSliderLabels = false,
  });

  final String title;
  final Set<ShadColorPickerFeature> features;
  final bool showSliderLabels;

  Widget build(ShadColorPickerController controller) {
    return IntrinsicHeight(
      child: switch (features.contains(ShadColorPickerFeature.colorPicker)) {
        true => Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _ShadColorPickerPalette(
                      controller: controller,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(flex: 4, child: buildSidebar(controller)),
            ],
          ),
        false => buildSidebar(controller),
      },
    );
  }

  Widget buildSidebar(ShadColorPickerController controller) {
    final sliderStyle = showSliderLabels
        ? ComponentEditorStyle.sliderLabel
        : ComponentEditorStyle.slider;
    return Column(
      children: [
        if (features.contains(ShadColorPickerFeature.hueSlider))
          HSLComponentSlider(
            component: HSLComponent.hue,
            controller: controller,
            style: sliderStyle,
          ),
        if (features.contains(ShadColorPickerFeature.saturationSlider))
          HSLComponentSlider(
            component: HSLComponent.saturation,
            controller: controller,
            style: sliderStyle,
          ),
        if (features.contains(ShadColorPickerFeature.luminanceSlider))
          HSLComponentSlider(
            component: HSLComponent.lightness,
            controller: controller,
            style: sliderStyle,
          ),
        if (features.contains(ShadColorPickerFeature.rgbSliders)) ...[
          RGBComponentSlider(
            component: RGBComponent.red,
            controller: controller,
            style: sliderStyle,
          ),
          RGBComponentSlider(
            component: RGBComponent.green,
            controller: controller,
            style: sliderStyle,
          ),
          RGBComponentSlider(
            component: RGBComponent.blue,
            controller: controller,
            style: sliderStyle,
          ),
        ],
        if (features.contains(ShadColorPickerFeature.alphaSlider))
          HSLComponentSlider(
            component: HSLComponent.alpha,
            controller: controller,
            style: sliderStyle,
          ),
        if (features.intersection({
          ShadColorPickerFeature.hueSlider,
          ShadColorPickerFeature.alphaSlider,
          ShadColorPickerFeature.saturationSlider,
          ShadColorPickerFeature.luminanceSlider,
        }).isNotEmpty)
          const Spacer(),
        if (features.contains(ShadColorPickerFeature.hexField))
          HexComponentInput(controller: controller),
        if (features.contains(ShadColorPickerFeature.hexField) &&
            (features.contains(ShadColorPickerFeature.rgbRow) ||
                features.contains(ShadColorPickerFeature.hslRow)))
          const SizedBox(height: 8),
        if (features.contains(ShadColorPickerFeature.rgbRow))
          Row(
            children: [
              Flexible(
                child: RGBComponentSlider(
                  component: RGBComponent.red,
                  controller: controller,
                ),
              ),
              Flexible(
                child: RGBComponentSlider(
                  component: RGBComponent.green,
                  controller: controller,
                ),
              ),
              Flexible(
                child: RGBComponentSlider(
                  component: RGBComponent.blue,
                  controller: controller,
                ),
              ),
            ],
          ),
        if (features.contains(ShadColorPickerFeature.hslRow))
          Row(
            children: [
              Flexible(
                child: HSLComponentSlider(
                  component: HSLComponent.hue,
                  controller: controller,
                ),
              ),
              Flexible(
                child: HSLComponentSlider(
                  component: HSLComponent.saturation,
                  controller: controller,
                ),
              ),
              Flexible(
                child: HSLComponentSlider(
                  component: HSLComponent.lightness,
                  controller: controller,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class ShadColorPickerController extends ValueNotifier<HSLColor> {
  ShadColorPickerController(super.value);

  Color get color => value.toColor();

  Color get hueColor => HSLColor.fromAHSL(1, value.hue, 1, 0.5).toColor();

  set color(Color color) => value = HSLColor.fromColor(color);
}

class _ShadColorPickerPalette extends StatefulWidget {
  const _ShadColorPickerPalette({
    super.key,
    required this.controller,
    this.focusNode,
  });

  final ShadColorPickerController controller;
  final FocusNode? focusNode;

  @override
  State<_ShadColorPickerPalette> createState() =>
      _ShadColorPickerPaletteState();
}

class _ShadColorPickerPaletteState extends State<_ShadColorPickerPalette> {
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
      widget.controller.value =
          _transformXYH(hue, x, y).withAlpha(cColor.opacity);
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
            widget.controller.value =
                _transformXYH(hue, x, y).withAlpha(cColor.opacity);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            final size = context.size!;
            x = (details.localPosition.dx / size.width).clamp(0.0, 1.0);
            y = (details.localPosition.dy / size.height).clamp(0.0, 1.0);
            widget.controller.value =
                _transformXYH(hue, x, y).withAlpha(cColor.opacity);
          });
        },
        child: CustomPaint(
          painter: _ShadColorPickerPalettePainter(
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

class _ShadColorPickerPalettePainter extends CustomPainter {
  _ShadColorPickerPalettePainter({
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
          ..color = theme.sliderTheme.thumbBorderColor!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );

    if (isFocused) {
      canvas.drawCircle(
        cursorPos,
        actualRadius,
        Paint()
          ..color = theme.sliderTheme.thumbBorderColor!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_ShadColorPickerPalettePainter oldDelegate) {
    return oldDelegate.hue != hue ||
        oldDelegate.x != x ||
        oldDelegate.y != y ||
        oldDelegate.isFocused != isFocused;
  }
}

enum HSLComponent {
  hue,
  saturation,
  lightness,
  alpha;

  String get label => switch (this) {
        HSLComponent.hue => 'Hue',
        HSLComponent.saturation => 'Sat',
        HSLComponent.lightness => 'Lum',
        HSLComponent.alpha => 'Alpha',
      };

  double get maxEditorValue => switch (this) {
        HSLComponent.hue => 360,
        HSLComponent.saturation => 100,
        HSLComponent.lightness => 100,
        HSLComponent.alpha => 100,
      };

  double getValue(HSLColor color) {
    return switch (this) {
      HSLComponent.hue => color.hue / 360,
      HSLComponent.saturation => color.saturation,
      HSLComponent.lightness => color.lightness,
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
      HSLComponent.lightness => HSLColor.fromAHSL(
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
        HSLComponent.lightness =>
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
        HSLComponent.lightness => _sampleGradient(
            16,
            (time) => HSLColor.fromAHSL(1, color.hue, color.saturation, time)
                .toColor(),
          ),
        HSLComponent.alpha => LinearGradient(
            colors: [
              HSLColor.fromAHSL(0, color.hue, color.saturation, color.lightness)
                  .toColor(),
              HSLColor.fromAHSL(1, color.hue, color.saturation, color.lightness)
                  .toColor()
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

  String get label => switch (this) {
        RGBComponent.red => 'Red',
        RGBComponent.green => 'Green',
        RGBComponent.blue => 'Blue',
        RGBComponent.alpha => 'Alpha',
      };

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

class HexComponentInput extends StatelessWidget {
  const HexComponentInput({super.key, required this.controller});

  final ShadColorPickerController controller;

  static String toHex(Color color) {
    var hex = color.value.toRadixString(16);
    if (hex.startsWith('ff')) {
      hex = hex.substring(2);
    }
    return '#$hex';
  }

  static Color? fromHex(String hex) {
    var trimmed = hex.replaceAll('#', '');
    if (trimmed.length == 6) {
      trimmed = 'ff$hex';
    }
    final parsed = int.tryParse(trimmed, radix: 16);
    return parsed != null ? Color(parsed) : null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return ShadInput(
          controller: TextEditingController(text: toHex(value.toColor())),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('^#?[0-9a-fA-F]*')),
            LengthLimitingTextInputFormatter(9),
          ],
          onSubmitted: (text) {
            final parsed = fromHex(text);
            if (parsed == null) return;
            controller.value = HSLColor.fromColor(parsed);
          },
          // suffix: Container(
          //   width: 16,
          //   height: 16,
          //   decoration: BoxDecoration(
          //     color: controller.color,
          //     borderRadius: BorderRadius.circular(4),
          //   ),
          // ),
        );
      },
    );
  }
}

class HSLComponentSlider extends StatefulWidget {
  const HSLComponentSlider({
    super.key,
    required this.component,
    required this.controller,
    this.fixedGradient = false,
    this.style = ComponentEditorStyle.input,
  });

  final HSLComponent component;
  final ShadColorPickerController controller;
  final bool fixedGradient;
  final ComponentEditorStyle style;

  @override
  State<HSLComponentSlider> createState() => _HSLComponentSliderState();
}

class _HSLComponentSliderState extends State<HSLComponentSlider> {
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

  Widget _buildInput(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            widget.component.label,
            style: theme.textTheme.small,
          ),
        ),
        ShadInput(
          controller: textController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.end,
          gap: 0,
          suffix: Text(
            widget.component.maxEditorValue == 360 ? '°' : '%',
            style: theme.textTheme.muted,
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
      padding: EdgeInsets.only(bottom: 8, left: useLabel ? 4 : 0),
      child: Row(
        children: [
          if (useLabel)
            Expanded(
              child: Text(
                widget.component.label,
                style: theme.textTheme.small,
              ),
            ),
          Flexible(
            flex: 3,
            child: CustomPaint(
              painter: GradientTrackPainter(
                gradient: gradient,
                theme: theme.sliderTheme,
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
                          true => _calcGradientColor(value, gradient),
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
    Key? key,
    required this.component,
    required this.controller,
    this.style = ComponentEditorStyle.input,
  }) : super(key: key);
  final RGBComponent component;
  final ShadColorPickerController controller;
  final ComponentEditorStyle style;

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

  @override
  Widget build(BuildContext context) {
    return switch (widget.style) {
      ComponentEditorStyle.slider => _buildSlider(context, false),
      ComponentEditorStyle.sliderLabel => _buildSlider(context, true),
      ComponentEditorStyle.input => _buildInput(context),
    };
  }

  Widget _buildInput(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            widget.component.label,
            style: theme.textTheme.small,
          ),
        ),
        ShadInput(
          controller: textController,
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
          },
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, bool useLabel) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: useLabel ? 4 : 0),
      child: Row(
        children: [
          if (useLabel)
            Expanded(
              child: Text(
                widget.component.label,
                style: ShadTheme.of(context).textTheme.small,
              ),
            ),
          Flexible(
            flex: 3,
            child: ShadSlider(
              controller: sliderController,
              onChanged: (v) {
                final color = widget.controller.color;
                widget.controller.color = widget.component.applyValue(color, v);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GradientTrackPainter extends CustomPainter {
  GradientTrackPainter({
    required this.gradient,
    required this.theme,
    this.checkerboard = false,
  });

  final LinearGradient gradient;
  final ShadSliderTheme theme;
  final bool checkerboard;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - theme.thumbRadius! * 2,
      height: theme.trackHeight ?? 4,
    );
    final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(4));

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

    for (final shadow in shadows) {
      canvas.drawRRect(
        rounded.shift(shadow.offset).inflate(shadow.spreadRadius),
        Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(shadow.blurStyle, shadow.blurSigma),
      );
    }

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

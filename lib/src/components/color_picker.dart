import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ShadColorPicker extends StatefulWidget {
  const ShadColorPicker({
    super.key,
    this.popoverController,
    this.controller,
    this.initialValue,
    this.tabs,
    this.popoverConstraints,

    // Editor
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

    // Popover
    this.groupId,
    this.popoverPadding,
    this.closeOnTapOutside = true,
    this.focusNode,
    this.anchor,
    this.effects,
    this.shadows,
    this.popoverDecoration,
    this.filter,
    this.areaGroupId,
    this.useSameGroupIdForChild = true,

    // Button
    this.onPressed,
    this.onLongPress,
    this.icon,
    this.buttonChild,
    this.buttonVariant,
    this.size,
    this.applyIconColorFilter,
    this.cursor,
    this.width,
    this.height,
    this.buttonPadding,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.foregroundColor,
    this.hoverForegroundColor,
    this.autofocus = false,
    this.buttonFocusNode,
    this.pressedBackgroundColor,
    this.pressedForegroundColor,
    this.buttonShadows,
    this.gradient,
    this.textDecoration,
    this.hoverTextDecoration,
    this.buttonDecoration,
    this.enabled = true,
    this.statesController,
    this.gap,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.hoverStrategies,
    this.onHoverChange,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onLongPressStart,
    this.onLongPressCancel,
    this.onLongPressUp,
    this.onLongPressDown,
    this.onLongPressEnd,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.longPressDuration,
    this.textDirection,
    this.onFocusChange,
  });

  /// The controller that will be used to control the popover.
  final ShadPopoverController? popoverController;

  /// The controller that will be used to control the color picker.
  final ShadColorEditorController? controller;

  /// The initial value of the color picker.
  final Color? initialValue;

  /// {@template ShadColorPicker.popoverConstraints}
  /// The constraints that will be applied to the popover.
  /// {@endtemplate}
  ///
  final BoxConstraints? popoverConstraints;

  // Editor
  /// {@macro ShadColorEditor.tabs}
  final List<ShadColorEditorTab>? tabs;
  /// {@macro ShadColorEditor.columnSpacing}
  final double? columnSpacing;
  /// {@macro ShadColorEditor.rowSpacing}
  final double? rowSpacing;
  /// {@macro ShadColorEditor.mainRowSpacing}
  final double? mainRowSpacing;
  /// {@macro ShadColorEditor.tabsPadding}
  final EdgeInsets? tabsPadding;
  /// {@macro ShadColorEditor.tabLabelStyle}
  final TextStyle? tabLabelStyle;
  /// {@macro ShadColorEditor.sliderLabelStyle}
  final TextStyle? sliderLabelStyle;
  /// {@macro ShadColorEditor.inputLabelStyle}
  final TextStyle? inputLabelStyle;
  /// {@macro ShadColorEditor.inputStyle}
  final TextStyle? inputStyle;
  /// {@macro ShadColorEditor.inputSuffixStyle}
  final TextStyle? inputSuffixStyle;
  /// {@macro ShadColorEditor.inputDecoration}
  final ShadDecoration? inputDecoration;
  /// {@macro ShadColorEditor.inputLabelPadding}
  final EdgeInsets? inputLabelPadding;
  /// {@macro ShadColorEditor.sliderLabelPadding}
  final EdgeInsets? sliderLabelPadding;
  /// {@macro ShadColorEditor.tabsTheme}
  final ShadTabsTheme? tabsTheme;
  /// {@macro ShadColorEditor.sliderTheme}
  final ShadSliderTheme? sliderTheme;

  /// {@macro ShadColorEditor.strings}
  final ShadColorEditorStringMap? strings;

  // Popover
  /// {@macro ShadPopover.groupId}
  final Object? groupId;

  /// {@macro ShadPopover.padding}
  final EdgeInsets? popoverPadding;

  /// {@macro ShadPopover.closeOnTapOutside}
  final bool closeOnTapOutside;

  /// {@macro ShadPopover.focusNode}
  final FocusNode? focusNode;

  ///{@macro ShadPopover.anchor}
  final ShadAnchorBase? anchor;

  /// {@macro ShadPopover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro ShadPopover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro ShadPopover.decoration}
  final ShadDecoration? popoverDecoration;

  /// {@macro ShadPopover.filter}
  final ImageFilter? filter;

  /// {@macro ShadMouseArea.groupId}
  final Object? areaGroupId;

  /// {@macro ShadPopover.useSameGroupIdForChild}
  final bool useSameGroupIdForChild;

  // Button

  /// {@macro ShadButton.onPressed}
  final VoidCallback? onPressed;

  /// {@macro ShadButton.onLongPress}
  final VoidCallback? onLongPress;

  /// {@macro ShadButton.icon}
  final Widget? icon;

  /// {@macro ShadButton.child}
  final Widget? buttonChild;

  /// {@macro ShadButton.variant}
  final ShadButtonVariant? buttonVariant;

  /// {@macro ShadButton.size}
  final ShadButtonSize? size;

  /// {@macro ShadButton.applyIconColorFilter}
  final bool? applyIconColorFilter;

  /// {@macro ShadButton.cursor}
  final MouseCursor? cursor;

  /// {@macro ShadButton.width}
  final double? width;

  /// {@macro ShadButton.height}
  final double? height;

  /// {@macro ShadButton.padding}
  final EdgeInsetsGeometry? buttonPadding;

  /// {@macro ShadButton.backgroundColor}
  final Color? backgroundColor;

  /// {@macro ShadButton.hoverBackgroundColor}
  final Color? hoverBackgroundColor;

  /// {@macro ShadButton.foregroundColor}
  final Color? foregroundColor;

  /// {@macro ShadButton.hoverForegroundColor}
  final Color? hoverForegroundColor;

  /// {@macro ShadButton.autofocus}
  final bool autofocus;

  /// {@macro ShadButton.focusNode}
  final FocusNode? buttonFocusNode;

  /// {@macro ShadButton.pressedBackgroundColor}
  final Color? pressedBackgroundColor;

  /// {@macro ShadButton.pressedForegroundColor}
  final Color? pressedForegroundColor;

  /// {@macro ShadButton.shadows}
  final List<BoxShadow>? buttonShadows;

  /// {@macro ShadButton.gradient}
  final Gradient? gradient;

  /// {@macro ShadButton.textDecoration}
  final TextDecoration? textDecoration;

  /// {@macro ShadButton.hoverTextDecoration}
  final TextDecoration? hoverTextDecoration;

  /// {@macro ShadButton.decoration}
  final ShadDecoration? buttonDecoration;

  /// {@macro ShadButton.enabled}
  final bool enabled;

  /// {@macro ShadButton.statesController}
  final ShadStatesController? statesController;

  /// {@macro ShadButton.gap}
  final double? gap;

  /// {@macro ShadButton.mainAxisAlignment}
  final MainAxisAlignment? mainAxisAlignment;

  /// {@macro ShadButton.crossAxisAlignment}
  final CrossAxisAlignment? crossAxisAlignment;

  /// {@macro ShadButton.hoverStrategies}
  final ShadHoverStrategies? hoverStrategies;

  /// {@macro ShadButton.onHoverChange}
  final ValueChanged<bool>? onHoverChange;

  /// {@macro ShadButton.onTapDown}
  final ValueChanged<TapDownDetails>? onTapDown;

  /// {@macro ShadButton.onTapUp}
  final ValueChanged<TapUpDetails>? onTapUp;

  /// {@macro ShadButton.onTapCancel}
  final VoidCallback? onTapCancel;

  /// {@macro ShadButton.onSecondaryTapDown}
  final ValueChanged<TapDownDetails>? onSecondaryTapDown;

  /// {@macro ShadButton.onSecondaryTapUp}
  final ValueChanged<TapUpDetails>? onSecondaryTapUp;

  /// {@macro ShadButton.onSecondaryTapCancel}
  final VoidCallback? onSecondaryTapCancel;

  /// {@macro ShadButton.onLongPressStart}
  final ValueChanged<LongPressStartDetails>? onLongPressStart;

  /// {@macro ShadButton.onLongPressCancel}
  final VoidCallback? onLongPressCancel;

  /// {@macro ShadButton.onLongPressUp}
  final VoidCallback? onLongPressUp;

  /// {@macro ShadButton.onLongPressDown}
  final ValueChanged<LongPressDownDetails>? onLongPressDown;

  /// {@macro ShadButton.onLongPressEnd}
  final ValueChanged<LongPressEndDetails>? onLongPressEnd;

  /// {@macro ShadButton.onDoubleTap}
  final VoidCallback? onDoubleTap;

  /// {@macro ShadButton.onDoubleTapDown}
  final ValueChanged<TapDownDetails>? onDoubleTapDown;

  /// {@macro ShadButton.onDoubleTapCancel}
  final VoidCallback? onDoubleTapCancel;

  /// {@macro ShadButton.longPressDuration}
  final Duration? longPressDuration;

  /// {@macro ShadButton.textDirection}
  final TextDirection? textDirection;

  /// {@macro ShadButton.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  @override
  State<ShadColorPicker> createState() => _ShadColorPickerState();
}

class _ShadColorPickerState extends State<ShadColorPicker> {
  late final ShadColorEditorController controller = widget.controller ??
      ShadColorEditorController(
        widget.initialValue != null
            ? HSLColor.fromColor(widget.initialValue!)
            : const HSLColor.fromAHSL(1, 0, 1, 0.5),
      );

  late final ShadPopoverController popoverController =
      widget.popoverController ?? ShadPopoverController();

  late final ShadColorEditorTheme editorThemeMerge = ShadColorEditorTheme(
    columnSpacing: widget.columnSpacing,
    rowSpacing: widget.rowSpacing,
    mainRowSpacing: widget.mainRowSpacing,
    tabsPadding: widget.tabsPadding,
    tabLabelStyle: widget.tabLabelStyle,
    sliderLabelStyle: widget.sliderLabelStyle,
    inputLabelStyle: widget.inputLabelStyle,
    inputStyle: widget.inputStyle,
    inputSuffixStyle: widget.inputSuffixStyle,
    inputDecoration: widget.inputDecoration,
    inputLabelPadding: widget.inputLabelPadding,
    sliderLabelPadding: widget.sliderLabelPadding,
    tabsTheme: widget.tabsTheme ?? const ShadTabsTheme(),
    sliderTheme: widget.sliderTheme ?? const ShadSliderTheme(),
    strings: widget.strings,
    tabs: widget.tabs,
  );

  late final ShadPopoverTheme popoverThemeMerge = ShadPopoverTheme(
    padding: widget.popoverPadding,
    anchor: widget.anchor,
    effects: widget.effects,
    shadows: widget.shadows,
    decoration: widget.popoverDecoration,
    filter: widget.filter,
  );

  late final ShadButtonTheme buttonThemeMerge = ShadButtonTheme(
    size: widget.size,
    applyIconColorFilter: widget.applyIconColorFilter,
    cursor: widget.cursor,
    width: widget.width,
    height: widget.height,
    backgroundColor: widget.backgroundColor,
    hoverBackgroundColor: widget.hoverBackgroundColor,
    foregroundColor: widget.foregroundColor,
    hoverForegroundColor: widget.hoverForegroundColor,
    pressedBackgroundColor: widget.pressedBackgroundColor,
    pressedForegroundColor: widget.pressedForegroundColor,
    shadows: widget.buttonShadows,
    gradient: widget.gradient,
    textDecoration: widget.textDecoration,
    hoverTextDecoration: widget.hoverTextDecoration,
    decoration: widget.buttonDecoration,
    gap: widget.gap,
    mainAxisAlignment: widget.mainAxisAlignment,
    crossAxisAlignment: widget.crossAxisAlignment,
    hoverStrategies: widget.hoverStrategies,
    longPressDuration: widget.longPressDuration,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final pickerTheme = theme.colorPickerTheme;

    final popoverTheme =
        theme.colorPickerTheme.popoverTheme.mergeWith(popoverThemeMerge);
    final buttonTheme =
        theme.colorPickerTheme.buttonTheme.mergeWith(buttonThemeMerge);

    return ShadPopover(
      controller: popoverController,
      padding: popoverTheme.padding,
      shadows: popoverTheme.shadows,
      decoration: popoverTheme.decoration,
      anchor: popoverTheme.anchor,
      effects: popoverTheme.effects,
      filter: popoverTheme.filter,
      closeOnTapOutside: widget.closeOnTapOutside,
      focusNode: widget.focusNode,
      areaGroupId: widget.areaGroupId,
      groupId: widget.groupId,
      useSameGroupIdForChild: widget.useSameGroupIdForChild,
      popover: (BuildContext context) {
        return ConstrainedBox(
          constraints: widget.popoverConstraints ??
              pickerTheme.popoverConstraints ??
              const BoxConstraints(),
          child: ShadTheme(
            data: theme.copyWith(
              colorEditorTheme: theme.colorEditorTheme.mergeWith(
                editorThemeMerge,
              ),
            ),
            child: ShadColorEditor(
              controller: controller,
            ),
          ),
        );
      },
      child: ShadButton.raw(
        variant: widget.buttonVariant ??
            pickerTheme.buttonVariant ??
            ShadButtonVariant.outline,
        padding: widget.buttonPadding ?? pickerTheme.buttonPadding,
        height: buttonTheme.height,
        width: buttonTheme.width,
        size: buttonTheme.size,
        icon: widget.icon,
        gap: buttonTheme.gap,
        mainAxisAlignment: buttonTheme.mainAxisAlignment,
        crossAxisAlignment: buttonTheme.crossAxisAlignment,
        decoration: buttonTheme.decoration,
        hoverTextDecoration: buttonTheme.hoverTextDecoration,
        cursor: buttonTheme.cursor,
        hoverBackgroundColor: buttonTheme.hoverBackgroundColor,
        hoverForegroundColor: buttonTheme.hoverForegroundColor,
        backgroundColor: buttonTheme.backgroundColor,
        foregroundColor: buttonTheme.foregroundColor,
        pressedBackgroundColor: buttonTheme.pressedBackgroundColor,
        pressedForegroundColor: buttonTheme.pressedForegroundColor,
        hoverStrategies: buttonTheme.hoverStrategies,
        applyIconColorFilter: buttonTheme.applyIconColorFilter,
        gradient: buttonTheme.gradient,
        shadows: buttonTheme.shadows,
        textDirection: buttonTheme.textDirection,
        textDecoration: buttonTheme.textDecoration,
        longPressDuration: buttonTheme.longPressDuration,
        onFocusChange: widget.onFocusChange,
        onDoubleTap: widget.onDoubleTap,
        onDoubleTapCancel: widget.onDoubleTapCancel,
        onDoubleTapDown: widget.onDoubleTapDown,
        onHoverChange: widget.onHoverChange,
        onLongPressCancel: widget.onLongPressCancel,
        onLongPressDown: widget.onLongPressDown,
        onLongPressEnd: widget.onLongPressEnd,
        onLongPressStart: widget.onLongPressStart,
        onLongPressUp: widget.onLongPressUp,
        onSecondaryTapCancel: widget.onSecondaryTapCancel,
        onSecondaryTapDown: widget.onSecondaryTapDown,
        onSecondaryTapUp: widget.onSecondaryTapUp,
        onTapCancel: widget.onTapCancel,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        onLongPress: widget.onLongPress,
        statesController: widget.statesController,
        focusNode: widget.buttonFocusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        onPressed: () {
          popoverController.toggle();
          widget.onPressed?.call();
        },
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, _) {
            return SizedBox(
              width: 100,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(colorToHex(controller.value.toColor())),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CustomPaint(
                      painter: ShadColorEditorPreviewPainter(
                        color: value.toColor(),
                        radius: BorderRadius.circular(4),
                        checkerboard: true,
                        showAlpha: true,
                        shadows: ShadShadows.sm,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

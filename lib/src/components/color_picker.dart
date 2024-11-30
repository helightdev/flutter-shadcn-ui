
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';


class ShadColorPicker extends StatefulWidget {
  const ShadColorPicker({
    super.key,
    this.popoverController,
    this.controller,
    this.initialValue,
    this.tabs = const [],
  });

  final ShadPopoverController? popoverController;
  final ShadColorEditorController? controller;
  final Color? initialValue;
  final List<ShadColorEditorTab> tabs;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      controller: popoverController,
      // padding: EdgeInsets.zero,
      popover: (BuildContext context) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: ShadColorEditor(
            tabs: widget.tabs,
            controller: controller,
          ),
        );
      },
      child: ShadButton.outline(
        padding: ShadTheme.of(context).datePickerTheme.buttonPadding,
        height: ShadTheme.of(context).datePickerTheme.height,
        size: ShadButtonSize.sm,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        onPressed: () {
          popoverController.toggle();
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
                      painter: ColorPreviewPainter(
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

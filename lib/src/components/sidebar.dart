import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shadcn_ui/src/components/time_picker.dart';
import 'package:shadcn_ui/src/utils/separated_iterable.dart';

class ShadSidebarController extends ValueNotifier<bool> {
  ShadSidebarController({bool value = false}) : super(value);
}

class ShadSidebar extends StatefulWidget {
  const ShadSidebar({
    super.key,
    this.content = const [],
    this.controller,
  });

  final ShadSidebarController? controller;
  final List<Widget> content;

  @override
  State<ShadSidebar> createState() => _ShadSidebarState();
}

class _ShadSidebarState extends State<ShadSidebar> {
  late final ShadSidebarController controller =
      widget.controller ?? ShadSidebarController(value: true);

  late bool showRemoveChild = controller.value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IconTheme(
        data: IconThemeData(
          size: 16,
          color: ShadTheme.of(context).colorScheme.foreground,
        ),
        child: ClipRect(
          child: ValueListenableBuilder<bool>(
            valueListenable: controller,
            builder: (context, shown, _) {
              return Visibility(
                visible: !showRemoveChild || shown,
                child: Animate(
                  target: shown ? 1 : 0,
                  effects: [
                    SlideEffect(begin: Offset(-1, 0), end: Offset.zero),
                    SizeEffect(
                      begin: 0,
                      end: 1,
                      axis: Axis.horizontal,
                    ),
                  ],
                  onComplete: (_) {
                    setState(() {
                      showRemoveChild = !shown;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.content,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShadSidebarGroup extends StatefulWidget {
  const ShadSidebarGroup({
    required this.items,
    required this.child,
    super.key,
  });

  final List<Widget> items;
  final Widget child;

  @override
  State<ShadSidebarGroup> createState() => _ShadSidebarGroupState();
}

class _ShadSidebarGroupState extends State<ShadSidebarGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(width: 8 + 8 + 2),
            DefaultTextStyle(
              style: ShadTheme.of(context).textTheme.muted,
              child: widget.child,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items,
        ),
      ],
    );
  }
}

class ShadSidebarMenuItem extends StatefulWidget {
  const ShadSidebarMenuItem({
    super.key,
    required this.child,
    this.icon,
    this.trailing,
    this.items,
    this.showTrailingOnHover = false,
  });

  final Widget? icon;
  final Widget child;
  final Widget? trailing;
  final List<Widget>? items;
  final bool showTrailingOnHover;

  @override
  State<ShadSidebarMenuItem> createState() => _ShadSidebarMenuItemState();
}

class _ShadSidebarMenuItemState extends State<ShadSidebarMenuItem> {
  final hoverNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var effectiveTrailing = widget.trailing;

    if (effectiveTrailing != null && widget.showTrailingOnHover) {
      final closedTrailing = effectiveTrailing;
      effectiveTrailing = ValueListenableBuilder(
        valueListenable: hoverNotifier,
        builder: (context, hovered, _) => Opacity(
          opacity: hovered ? 1 : 0,
          child: closedTrailing,
        ),
      );
    }

    return ShadButton.raw(
      variant: ShadButtonVariant.ghost,
      size: ShadButtonSize.sm,
      mainAxisAlignment: MainAxisAlignment.start,
      onHoverChange: (hovered) {
        hoverNotifier.value = hovered;
      },
      child: Expanded(
        child: Row(
          children: [
            if (widget.icon != null) widget.icon!,
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.child,
              ),
            ),
            if (effectiveTrailing != null) effectiveTrailing,
          ].separatedBy(const SizedBox(width: 12)),
        ),
      ),
    );
  }
}

class ShadSidebarMenuSub extends StatefulWidget {
  const ShadSidebarMenuSub({
    super.key,
    required this.items,
    required this.child,
    this.icon,
    this.trailing,
    this.trailingEffects,
  });

  final List<Widget> items;
  final Widget? icon;
  final Widget child;
  final Widget? trailing;
  final List<Effect<dynamic>>? trailingEffects;

  @override
  State<ShadSidebarMenuSub> createState() => _ShadSidebarMenuSubState();
}

class _ShadSidebarMenuSubState extends State<ShadSidebarMenuSub> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShadButton.raw(
          variant: ShadButtonVariant.ghost,
          size: ShadButtonSize.sm,
          mainAxisAlignment: MainAxisAlignment.start,
          onPressed: () {
            setState(() {
              isToggled = !isToggled;
            });
          },
          child: Expanded(
            child: Row(
              children: [
                if (widget.icon != null) widget.icon!,
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: widget.child,
                  ),
                ),
                if (widget.trailing != null) Animate(
                  target: isToggled ? 1 : 0,
                  effects: widget.trailingEffects ??
                      [
                        const RotateEffect(
                          begin: 0,
                          end: 0.25,
                        ),
                      ],
                  child: widget.trailing!,
                ),
              ].separatedBy(SizedBox(width: 12)),
            ),
          ),
        ),
        Visibility(
          visible: isToggled,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 8 + 8 + ((16 - (2)) / 2)),
                Container(
                  width: 2,
                  decoration: BoxDecoration(
                      color: ShadTheme.of(context).colorScheme.muted
                  ),
                ),
                SizedBox(width: 3,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.items,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

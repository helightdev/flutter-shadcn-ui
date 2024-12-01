import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  final ShadPopoverController popover0 = ShadPopoverController();
  final ShadPopoverController popover1 = ShadPopoverController();

  final ShadPopoverController popover2 = ShadPopoverController();
  final ShadPopoverController popover3 = ShadPopoverController();

  late ShadColorEditorController editor0 =
      ShadColorEditorController(HSLColor.fromColor(Colors.indigoAccent));
  late ShadColorEditorController editor1 =
      ShadColorEditorController(HSLColor.fromColor(Colors.pinkAccent));
  late ShadColorEditorController editor2 = ShadColorEditorController(
      HSLColor.fromColor(Colors.orangeAccent),
      transparency: false);
  late ShadColorEditorController editor3 =
      ShadColorEditorController(HSLColor.fromColor(Colors.greenAccent));

  bool transparency = true;

  void toggleTransparency() {
    editor0.transparency = transparency;
    editor1.transparency = transparency;
    editor3.transparency = transparency;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = ShadTheme.of(context);
    return BaseScaffold(
      appBarTitle: 'ColorEditor',
      editable: [
        MyBoolProperty(
            label: "Transparency",
            value: transparency,
            onChanged: (value) {
              setState(() {
                transparency = value;
                toggleTransparency();
              });
            }),
      ],
      children: [
        Text('Default', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor0,
          popoverController: popover0,
        ),
        const Divider(),
        Text('HSL Editor', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor1,
          popoverController: popover1,
          tabs: const [
            ShadColorEditorTab(
                title: "HSL",
                features: {
                  ShadColorEditorFeature.colorArea,
                  ShadColorEditorFeature.hueSlider,
                  ShadColorEditorFeature.saturationSlider,
                  ShadColorEditorFeature.luminanceSlider,
                  ShadColorEditorFeature.alphaSlider,
                  ShadColorEditorFeature.hexField,
                  ShadColorEditorFeature.hslRow,
                },
                expandSpacer: true)
          ],
        ),
        const Divider(),
        Text('Combined', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor2,
          popoverController: popover2,
          tabs: const [
            ShadColorEditorTab(
                title: "HSL",
                features: {
                  ShadColorEditorFeature.colorArea,
                  ShadColorEditorFeature.hueSlider,
                  ShadColorEditorFeature.hexField,
                  ShadColorEditorFeature.hslRow,
                  ShadColorEditorFeature.rgbRow,
                },
                expandSpacer: true)
          ],
        ),
        const Divider(),
        Text('Tabbed', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor3,
          popoverController: popover3,
          tabs: const [
            ShadColorEditorTab(
              title: "HSL",
              features: {
                ShadColorEditorFeature.colorArea,
                ShadColorEditorFeature.hueSlider,
                ShadColorEditorFeature.saturationSlider,
                ShadColorEditorFeature.luminanceSlider,
                ShadColorEditorFeature.alphaSlider,
                ShadColorEditorFeature.hexField,
                ShadColorEditorFeature.hslRow,
              },
            ),
            ShadColorEditorTab(
              title: "RGB",
              features: {
                ShadColorEditorFeature.colorArea,
                ShadColorEditorFeature.rgbSliders,
                ShadColorEditorFeature.alphaSlider,
                ShadColorEditorFeature.rgbRow,
              },
              fixedGradient: true,
            )
          ],
        )
      ],
    );
  }
}

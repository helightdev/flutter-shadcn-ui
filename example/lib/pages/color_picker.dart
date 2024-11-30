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
  final ShadPopoverController popover1 = ShadPopoverController();

  final ShadPopoverController popover2 = ShadPopoverController();
  final ShadPopoverController popover3 = ShadPopoverController();

  late ShadColorEditorController editor1 =
      ShadColorEditorController(HSLColor.fromColor(Colors.red));
  late ShadColorEditorController editor2 = ShadColorEditorController(
      HSLColor.fromColor(Colors.blue),
      transparency: false);
  late ShadColorEditorController editor3 =
      ShadColorEditorController(HSLColor.fromColor(Colors.green));

  bool transparency = true;

  void toggleTransparency() {
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
        Text('HSL Editor', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor1,
          popoverController: popover1,
          tabs: [
            ShadColorEditorTab(
                title: "HSL",
                features: {
                  ShadColorPickerFeature.colorPicker,
                  ShadColorPickerFeature.hueSlider,
                  ShadColorPickerFeature.saturationSlider,
                  ShadColorPickerFeature.luminanceSlider,
                  ShadColorPickerFeature.alphaSlider,
                  ShadColorPickerFeature.hexField,
                  ShadColorPickerFeature.hslRow,
                },
                expandSpacer: true)
          ],
        ),
        Divider(),
        Text('Combined', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor2,
          popoverController: popover2,
          tabs: [
            ShadColorEditorTab(
                title: "HSL",
                features: {
                  ShadColorPickerFeature.colorPicker,
                  ShadColorPickerFeature.hueSlider,
                  ShadColorPickerFeature.hexField,
                  ShadColorPickerFeature.hslRow,
                  ShadColorPickerFeature.rgbRow,
                },
                expandSpacer: true)
          ],
        ),
        Divider(),
        Text('Tabbed', style: theme.textTheme.h4),
        ShadColorPicker(
          controller: editor3,
          popoverController: popover3,
          tabs: [
            ShadColorEditorTab(title: "HSL", features: {
              ShadColorPickerFeature.colorPicker,
              ShadColorPickerFeature.hueSlider,
              ShadColorPickerFeature.saturationSlider,
              ShadColorPickerFeature.luminanceSlider,
              ShadColorPickerFeature.alphaSlider,
              ShadColorPickerFeature.hexField,
              ShadColorPickerFeature.hslRow,
            },),
            ShadColorEditorTab(
              title: "RGB",
              features: {
                ShadColorPickerFeature.colorPicker,
                ShadColorPickerFeature.rgbSliders,
                ShadColorPickerFeature.alphaSlider,
                ShadColorPickerFeature.rgbRow,
              },
              fixedGradient: true,
            )
          ],
        )
      ],
    );
  }
}

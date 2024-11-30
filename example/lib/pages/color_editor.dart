import 'package:example/common/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ColorEditorPage extends StatefulWidget {
  const ColorEditorPage({super.key});

  @override
  State<ColorEditorPage> createState() => _ColorEditorPageState();
}

class _ColorEditorPageState extends State<ColorEditorPage> {

  final ShadColorEditorController editor1 = ShadColorEditorController(HSLColor.fromColor(Colors.red));

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'ColorEditor',
      editable: const [],
      children: [
        ShadColorEditor(
          tabs: const [
            ShadColorEditorTab(
              title: 'HSL',
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
            ShadColorEditorTab(
              title: 'RGB',
              features: {
                ShadColorPickerFeature.colorPicker,
                ShadColorPickerFeature.hueSlider,
                ShadColorPickerFeature.rgbSliders,
                ShadColorPickerFeature.alphaSlider,
                ShadColorPickerFeature.hexField,
                ShadColorPickerFeature.rgbRow,
              },
              showSliderLabels: true,
            )
          ], controller: editor1,
        ),
      ],
    );
  }
}

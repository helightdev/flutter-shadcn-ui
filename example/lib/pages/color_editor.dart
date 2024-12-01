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
                ShadColorEditorFeature.colorPicker,
                ShadColorEditorFeature.hueSlider,
                ShadColorEditorFeature.saturationSlider,
                ShadColorEditorFeature.luminanceSlider,
                ShadColorEditorFeature.alphaSlider,
                ShadColorEditorFeature.hexField,
                ShadColorEditorFeature.hslRow,
              },
              showSliderLabels: true,
            ),
            ShadColorEditorTab(
              title: 'RGB',
              features: {
                ShadColorEditorFeature.colorPicker,
                ShadColorEditorFeature.hueSlider,
                ShadColorEditorFeature.rgbSliders,
                ShadColorEditorFeature.alphaSlider,
                ShadColorEditorFeature.hexField,
                ShadColorEditorFeature.rgbRow,
              },
              showSliderLabels: true,
            )
          ], controller: editor1,
        ),
      ],
    );
  }
}

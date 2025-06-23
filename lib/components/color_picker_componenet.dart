import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void showColorPickerDialog(
    BuildContext context,
    Color initialColor,
    ValueChanged<Color> onColorSelected,
  ) {

  // create some values
  Color pickerColor = initialColor;

  void changeColor(Color color) {
    pickerColor = color;
  }

  // raise the [showDialog] widget
  showDialog(
    builder: (context) => AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
        ),
        // Use Material color picker:
        //
        // child: MaterialPicker(
        //   pickerColor: pickerColor,
        //   onColorChanged: changeColor,
        //   showLabel: true, // only on portrait mode
        // ),
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: currentColor,
        //   onColorChanged: changeColor,
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Got it'),
          onPressed: () {
            onColorSelected(pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    ), context: context,
  );
}
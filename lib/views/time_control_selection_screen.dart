import 'package:flutter/material.dart';
import 'package:tempus/components/time_control_component.dart';
import 'package:tempus/controllers/common/control_presets.dart';

import '../controllers/timer_controller.dart';

class TimeControlSelectionScreen extends StatelessWidget {
  const TimeControlSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final String selectedName = TimerController.currentTimeControl.name;

    return Scaffold(
      body: ListView.builder(
        itemCount: timeControlPresets.length,
        itemBuilder: (context, index) {
          return TimeControlComponent(model: timeControlPresets[index], isSelected: timeControlPresets[index].name == selectedName ? true : false,);
        },
      ),
    );
  }
}

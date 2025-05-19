import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/timer_controller.dart';

import '../controllers/common/icons.dart';
import '../models/time_control.dart';
import '../views/clock_screen.dart';

class TimeControlComponent extends StatelessWidget {
  final TimeControl model;
  final bool isSelected;
  const TimeControlComponent({super.key, required this.model, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Theme.of(context).cardColor,
          border: isSelected ? null : Border.fromBorderSide(BorderSide(color: Colors.black12)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 24,
                  child: model.seconds < 180 ? icons["bullet"]!
                      : model.seconds < 600 ? icons["blitz"]!
                      : icons["rapid"]!,
                ),
                const SizedBox(width: 8),
                Text(model.name),
              ],
            ),
            Text(model.toString()),
          ],
        ),
      ),
      onTap: () {
        TimerController.choosePreset(model.name);
        Get.to(() => const ClockScreen(), transition: Transition.fade);
      },
    );
  }
}

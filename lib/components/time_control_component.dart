import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tempus/controllers/timer_controller.dart';

import '../models/time_control.dart';

class TimeControlComponent extends StatelessWidget {
  final TimeControl model;
  final bool isSelected;
  const TimeControlComponent({super.key, required this.model, required this.isSelected});


  @override
  Widget build(BuildContext context) {

    return Container(
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
            children: [
              Icon(
                  model.seconds < 180 ? CupertinoIcons.calendar
                      : model.seconds < 600 ? CupertinoIcons.clock
                      : CupertinoIcons.clock
              ),
              const SizedBox(width: 8),
              Text(model.name),
            ],
          ),
          Text(model.toString()),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:tempus/controllers/theme_controller.dart';
import 'package:tempus/controllers/time_control_controller.dart';

import '../controllers/common/icons.dart';
import '../models/time_control.dart';

class TimeControlComponent extends StatefulWidget {
  final TimeControl model;
  final bool isSelected;
  const TimeControlComponent({super.key, required this.model, required this.isSelected});

  @override
  State<TimeControlComponent> createState() => _TimeControlComponentState();
}

class _TimeControlComponentState extends State<TimeControlComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: widget.isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardColor,
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.14),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0.1, 0.5),
            )
          ]
              : [],
          border: !widget.isSelected ? Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: Colors.grey[700]!, width: 1)
              : null : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 24,
                      child: ColorFiltered(
                          colorFilter: widget.isSelected ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) :  ThemeController.to.isDarkMode ?
                              const ColorFilter.mode(Colors.white, BlendMode.srcIn) :
                              const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          child: widget.model.player.seconds < 180 ? icons["bullet"]!
                              : widget.model.player.seconds < 600 ? icons["blitz"]!
                              : icons["rapid"]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(widget.model.name, style: widget.isSelected ? TextStyle(color: Colors.white) : null,),
                  ],
                ),
                Text(widget.model.toString(), style: widget.isSelected ? TextStyle(color: Colors.white) : null,),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          TimeControlController.selectPreset(widget.model.name);
        });
      },
    );
  }
}

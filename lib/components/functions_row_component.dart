import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';

class FunctionsRowComponent extends StatelessWidget {
  const FunctionsRowComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final timerController = CountdownTimerController.to;

    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.fromBorderSide(BorderSide(color: Colors.black12)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Reset Button
          IconButton(
            icon: Icon(Icons.restart_alt_rounded, size: 36),
            onPressed: timerController.reset,
            tooltip: 'Reset Clock',
          ),

          // Play/Pause Button
          IconButton(
            icon: Icon(
              timerController.isRunning.value
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 36,
            ),
            onPressed: () {
              if (timerController.isRunning.value) {
                timerController.pause();
              } else {
                timerController.startClock();
              }
            },
            tooltip: timerController.isRunning.value ? 'Pause' : 'Start',
          ),

          // Turn Switch Button (only visible when clock is running)
          if (timerController.isRunning.value && !timerController.isGameOver.value)
            IconButton(
              icon: Icon(
                Icons.swap_vert,
                size: 36,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: timerController.switchTurn,
              tooltip: 'Switch Turn',
            )
          else
            const SizedBox(width: 48), // Placeholder for consistent spacing

          // Settings Button
          IconButton(
            icon: Icon(Icons.settings_rounded, size: 36),
            onPressed: () {
              // Add your settings navigation here
            },
            tooltip: 'Settings',
          ),

          // Sound Toggle Button
          IconButton(
            icon: Icon(Icons.volume_up, size: 36),
            onPressed: () {
              // Add your sound toggle logic here
            },
            tooltip: 'Sound Toggle',
          ),
        ],
      ),
    ));
  }
}
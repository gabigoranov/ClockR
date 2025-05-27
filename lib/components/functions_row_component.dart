import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';
import 'package:tempus/views/time_control_selection_screen.dart';

import '../l10n/app_localizations.dart';
import 'are_you_sure_dialog.dart';

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
            onPressed: () async {
              CountdownTimerController.to.pause();
              final bool? result = await showAreYouSureDialog(
                context: context,
                title: AppLocalizations.of(context).resetTimer,
                content: AppLocalizations.of(context).resetTimerDialog,
                confirmText: AppLocalizations.of(context).reset,
                cancelText: AppLocalizations.of(context).cancel,
                confirmColor: Colors.blue, // Custom color for the confirm button
              );

              if (result == true) {
                // User confirmed - perform the action
                CountdownTimerController.to.reset();
              }
            },
            tooltip: AppLocalizations.of(context).resetTimer,
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
            tooltip: timerController.isRunning.value ? AppLocalizations.of(context).pause : AppLocalizations.of(context).play,
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
              tooltip: AppLocalizations.of(context).switchTurn,
            )
          else
            const SizedBox(width: 48), // Placeholder for consistent spacing

          // Settings Button
          IconButton(
            icon: Icon(Icons.settings_rounded, size: 36),
            onPressed: () {
              timerController.pause();
              Get.to(() => const TimeControlSelectionScreen(), transition: Transition.fade);
            },
            tooltip: AppLocalizations.of(context).settings,
          ),

          // Sound Toggle Button
          IconButton(
            icon: CountdownTimerController.to.isMuted.value
                ? Icon(Icons.volume_off, size: 36)
                : Icon(Icons.volume_up, size: 36),
            onPressed: () {
              CountdownTimerController.to.toggleSound();
            },
            tooltip: AppLocalizations.of(context).soundToggle,
          ),
        ],
      ),
    ));
  }
}
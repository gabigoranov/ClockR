import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/countdown_timer_component.dart';
import '../components/functions_row_component.dart';
import '../controllers/countdown_timer_controller.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerController = CountdownTimerController.to;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Opponent Timer (top)
            Obx(() => CountdownTimerComponent(
              isActive: !timerController.isPlayerTurn.value &&
                  timerController.isRunning.value,
              onTap: () {
                if (!timerController.isRunning.value) {
                  timerController.startBothTimers();
                  timerController.switchTurn();
        
                } else {
                  timerController.switchTurn();
                }
              },
              onFinished: () => print('Opponent time expired'),
              rotation: 2,
              isPlayer: false,
            )),
        
            // Control buttons row
            FunctionsRowComponent(),
        
            // Player Timer (bottom)
            Obx(() => CountdownTimerComponent(
              isActive: timerController.isPlayerTurn.value &&
                  timerController.isRunning.value,
              onTap: () {
                if (!timerController.isRunning.value) {
                  timerController.startBothTimers();
                  timerController.switchTurn();
        
                } else {
                  timerController.switchTurn();
                }
              },
              onFinished: () => print('Player time expired'),
              rotation: 0,
              isPlayer: true,
            )),
          ],
        ),
      ),
    );
  }
}
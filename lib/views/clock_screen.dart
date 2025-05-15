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
              onTap: () async{
                if (!timerController.isRunning.value) {
                  await timerController.startClock(didPlayerStart: false);
        
                } else {
                  if(!timerController.isPlayerTurn.value)
                  {
                    await timerController.switchTurn();
                  }
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
              onTap: () async {
                if (!timerController.isRunning.value) {
                  await timerController.startClock(didPlayerStart: true);
                } else {
                  if(timerController.isPlayerTurn.value)
                  {
                    await timerController.switchTurn();
                  }
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
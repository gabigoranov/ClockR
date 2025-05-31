import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/countdown_timer_component.dart';
import '../components/functions_column_component.dart';
import '../controllers/countdown_timer_controller.dart';

class ClockScreenLandscape extends StatefulWidget {
  const ClockScreenLandscape({super.key});

  @override
  State<ClockScreenLandscape> createState() => _ClockScreenLandscapeState();
}

class _ClockScreenLandscapeState extends State<ClockScreenLandscape> {
  @override
  Widget build(BuildContext context) {
    final timerController = CountdownTimerController.to;

    return Scaffold(
      body: Row(
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
            rotation: 0,
            isPlayer: false,
          )),

          // Control buttons row
          const FunctionsColumnComponent(),

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
    );
  }
}
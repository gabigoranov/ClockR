import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/countdown_timer_component.dart';
import '../components/functions_row_component.dart';
import '../controllers/countdown_timer_controller.dart';

class ClockScreenPortrait extends StatefulWidget {
  const ClockScreenPortrait({super.key});

  @override
  State<ClockScreenPortrait> createState() => _ClockScreenPortraitState();
}

class _ClockScreenPortraitState extends State<ClockScreenPortrait> {
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
              isTimeUp: timerController.isGameOver.value && timerController.opponentTime.value <= 0,
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
            const FunctionsRowComponent(),

            // Player Timer (bottom)
            Obx(() => CountdownTimerComponent(
              isActive: timerController.isPlayerTurn.value &&
                  timerController.isRunning.value,
              isTimeUp: timerController.isGameOver.value && timerController.playerTime.value <= 0,
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
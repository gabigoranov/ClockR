import 'dart:async';
import 'dart:ui';
import 'package:get/get.dart';

import '../services/audio_service.dart';

class CountdownTimerController extends GetxController {
  static CountdownTimerController get to => Get.find();

  // Reactive state variables
  final playerTime = 0.obs;
  final opponentTime = 0.obs;
  final isPlayerTurn = true.obs;
  final isRunning = false.obs;
  final isGameOver = false.obs;

  // Timer references
  Timer? _playerTimer;
  Timer? _opponentTimer;

  // Time tracking
  int? _lastPlayerTimestamp;
  int? _lastOpponentTimestamp;
  late int _initialTime;

  // Callbacks for game events
  final VoidCallback? onPlayerTimeOut;
  final VoidCallback? onOpponentTimeOut;
  final VoidCallback? onTurnChanged;

  CountdownTimerController({
    this.onPlayerTimeOut,
    this.onOpponentTimeOut,
    this.onTurnChanged,
  });

  @override
  void onInit() {
    super.onInit();
    initialize(300); // Default to 5 minutes
  }

  void initialize(int initialTimeInSeconds) {
    _initialTime = initialTimeInSeconds * 1000;
    reset();
  }

  void startClock() {
    if (isGameOver.value) return;

    isRunning.value = true;
    if (isPlayerTurn.value) {
      _startPlayerTimer();
    } else {
      _startOpponentTimer();
    }

    AudioService.playSound('sounds/clock_tap.wav');
  }
  // Add this to your CountdownTimerController
  void startBothTimers() {
    if (isGameOver.value) return;

    isRunning.value = true;
    _startPlayerTimer();
    _startOpponentTimer();

  }

  void _startPlayerTimer() {
    _playerTimer?.cancel();
    _lastPlayerTimestamp = DateTime.now().millisecondsSinceEpoch;

    _playerTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!isPlayerTurn.value) return; // Only count down if it's player's turn

      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - _lastPlayerTimestamp!;
      _lastPlayerTimestamp = now;

      playerTime.value -= elapsed;

      if (playerTime.value <= 0) {
        playerTime.value = 0;
        isGameOver.value = true;
        onPlayerTimeOut?.call();
      }
    });
  }

  void _startOpponentTimer() {
    _opponentTimer?.cancel();
    _lastOpponentTimestamp = DateTime.now().millisecondsSinceEpoch;

    _opponentTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (isPlayerTurn.value) return; // Only count down if it's opponent's turn

      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - _lastOpponentTimestamp!;
      _lastOpponentTimestamp = now;

      opponentTime.value -= elapsed;

      if (opponentTime.value <= 0) {
        opponentTime.value = 0;
        isGameOver.value = true;
        onOpponentTimeOut?.call();
      }
    });
  }

// Modify your switchTurn method to only change turns, not start/stop timers
  void switchTurn() {
    if (!isRunning.value || isGameOver.value) return;
    isPlayerTurn.value = !isPlayerTurn.value;
    onTurnChanged?.call();

    AudioService.playSound('sounds/clock_tap.wav');
  }

  void pause() {
    isRunning.value = false;
    _stopPlayerTimer();
    _stopOpponentTimer();

  }

  void reset() {
    print('Resetting timer...');
    pause();
    playerTime.value = _initialTime;
    opponentTime.value = _initialTime;
    isPlayerTurn.value = true;
    isGameOver.value = false;
    print('Reset complete - playerTime: ${playerTime.value}');
  }

  void _stopPlayerTimer() {
    _playerTimer?.cancel();
    _playerTimer = null;
    _lastPlayerTimestamp = null;
  }

  void _stopOpponentTimer() {
    _opponentTimer?.cancel();
    _opponentTimer = null;
    _lastOpponentTimestamp = null;
  }

  String formatTime(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _playerTimer?.cancel();
    _opponentTimer?.cancel();
    super.onClose();
  }
}
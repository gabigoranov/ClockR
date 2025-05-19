import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/timer_controller.dart';

import '../services/audio_service.dart';

class CountdownTimerController extends GetxController with GetTickerProviderStateMixin {
  static CountdownTimerController get to => Get.find();

  // Reactive state variables
  final playerTime = 0.obs;
  final opponentTime = 0.obs;
  final isPlayerTurn = true.obs;
  final isRunning = false.obs;
  final isGameOver = false.obs;
  final isMuted = false.obs;

  // Tickers for precise timing
  Ticker? _playerTicker;
  Ticker? _opponentTicker;

  // Time tracking
  int? _lastPlayerTimestamp;
  int? _lastOpponentTimestamp;
  late int _initialTime;
  late int _increment;

  // Beep tracking
  final Set<int> _beepThresholds = {30000, 20000, 15000, 10000, 5000, 4000, 3000, 2000, 1000};
  final Set<int> _triggeredBeeps = {};

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
    initialize(TimerController.currentTimeControl.value.seconds, TimerController.currentTimeControl.value.increment); // Default to 5 minutes
  }

  void initialize(int initialTimeInSeconds, int increment) {
    _initialTime = initialTimeInSeconds * 1000;
    _increment = increment * 1000;
    reset();
  }

  void mute(){
    isMuted.value = true;
  }

  void unMute(){
    isMuted.value = false;
  }

  void toggleSound(){
    isMuted.value = !isMuted.value;
  }

  Future<void> startClock({bool didPlayerStart = true}) async {
    if (isGameOver.value) return;

    isPlayerTurn.value = !didPlayerStart;
    isRunning.value = true;
    if (didPlayerStart) {
      _startOpponentTicker();
    } else {
      _startPlayerTicker();
    }

    await playRespectiveSound();
  }

  void startBothTimers() {
    if (isGameOver.value) return;

    isRunning.value = true;
    _startPlayerTicker();
    _startOpponentTicker();
  }

  void _startPlayerTicker() {
    opponentTime.value += _increment; // Add increment to opponent's time
    _lastPlayerTimestamp = DateTime.now().millisecondsSinceEpoch;

    _playerTicker = createTicker((_) {
      if (!isPlayerTurn.value || !isRunning.value) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - _lastPlayerTimestamp!;
      _lastPlayerTimestamp = now;

      playerTime.value -= elapsed;
      _checkForBeep(playerTime.value);

      if (playerTime.value <= 0) {
        playerTime.value = 0;
        _handleTimeOut(isPlayer: true);
      }
    });
    _playerTicker!.start();
  }

  void _handleTimeOut({required bool isPlayer}) {
    isGameOver.value = true;
    pause(); // This stops both tickers

    if (isPlayer) {
      onPlayerTimeOut?.call();
    } else {
      onOpponentTimeOut?.call();
    }

    update(); // Force UI refresh
  }

  void _startOpponentTicker() {
    playerTime.value += _increment; // Add increment to opponent's time

    _stopPlayerTicker();    // Ensure only opponent ticker runs
    _stopOpponentTicker();  // Stop any existing ticker before creating a new one

    _lastOpponentTimestamp = DateTime.now().millisecondsSinceEpoch;

    _opponentTicker = createTicker((_) {
      if (isPlayerTurn.value) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - _lastOpponentTimestamp!;
      _lastOpponentTimestamp = now;

      opponentTime.value -= elapsed;
      _checkForBeep(opponentTime.value);

      if (opponentTime.value <= 0) {
        opponentTime.value = 0;
        _handleTimeOut(isPlayer: false);
      }
    });

    _opponentTicker!.start();
  }

  Future<void> _checkForBeep(int time) async {
    // Check if we've crossed any threshold from above
    for (final threshold in _beepThresholds) {
      if (time > threshold && time - threshold <= 100) { // Small buffer to account for tick rate
        if (!_triggeredBeeps.contains(threshold)) {
          _triggeredBeeps.add(threshold);
          await AudioService.playSound('sounds/alarm.wav');
        }
      }
    }
  }

  Future<void> switchTurn() async {
    if (isGameOver.value) return;

    isPlayerTurn.value = !isPlayerTurn.value;
    onTurnChanged?.call();

    if (isPlayerTurn.value) {
      _startPlayerTicker();
    } else {
      _startOpponentTicker();
    }

    await playRespectiveSound();
  }

  void pause() {
    isRunning.value = false;
    _stopPlayerTicker();
    _stopOpponentTicker();
  }

  Future<void> playRespectiveSound() async {
    if (!isPlayerTurn.value) {
      await AudioService.playSound('sounds/clock_tap_2.wav');
      return;
    }
    await AudioService.playSound('sounds/clock_tap_1.wav');
  }

  void reset() {
    pause();

    playerTime.value = _initialTime;
    opponentTime.value = _initialTime;

    isPlayerTurn.value = true;
    isGameOver.value = false;
    _triggeredBeeps.clear();
  }

  void _stopPlayerTicker() {
    _playerTicker?.stop();
    _playerTicker?.dispose();
    _playerTicker = null;
    _lastPlayerTimestamp = null;
  }

  void _stopOpponentTicker() {
    _opponentTicker?.stop();
    _opponentTicker?.dispose();
    _opponentTicker = null;
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
    _stopPlayerTicker();
    _stopOpponentTicker();
    super.onClose();
  }
}
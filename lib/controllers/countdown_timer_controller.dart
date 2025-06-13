import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/timer_controller.dart';

import '../services/audio_service.dart';

/// CountdownTimerController manages the countdown timer for a chess game.
class CountdownTimerController extends GetxController with GetTickerProviderStateMixin {
  static CountdownTimerController get to => Get.find();

  final audioService = Get.find<AudioService>();

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

  /// Initializes the timer with the given initial time in seconds and increment in miliseconds.
  void initialize(int initialTimeInSeconds, int increment) {
    _initialTime = initialTimeInSeconds * 1000;
    _increment = increment * 1000;
    reset();
  }

  /// Mute the timer sounds
  void mute(){
    isMuted.value = true;
  }

  /// UnMute the timer sounds
  void unMute(){
    isMuted.value = false;
  }

  /// Toggle the sound state
  void toggleSound(){
    isMuted.value = !isMuted.value;
  }

  /// Starts the clock for the player or opponent based on who initiated it.
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

  /// Starts the player ticker, which counts down the player's time.
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

  /// Handles the timeout logic for either player or opponent.
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

  /// Starts the opponent ticker, which counts down the opponent's time.
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

  /// Checks if the current time has crossed any beep thresholds and plays a sound if it has.
  Future<void> _checkForBeep(int time) async {
    // Check if we've crossed any threshold from above
    for (final threshold in _beepThresholds) {
      if (time > threshold && time - threshold <= 100) { // Small buffer to account for tick rate
        await audioService.playSound('sounds/alarm.wav');
      }
    }
  }

  /// Switches the turn between player and opponent.
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

  /// Pauses the timer, stopping both player and opponent tickers.
  void pause() {
    isRunning.value = false;
    _stopPlayerTicker();
    _stopOpponentTicker();
  }

  /// UnPauses the timer, starting the current player's ticker.
  void unPause() {
    isRunning.value = true;
    if(isPlayerTurn.value){
      _startPlayerTicker();
    } else {
      _startOpponentTicker();
    }
  }

  /// Plays a sound based on whose turn it is.
  Future<void> playRespectiveSound() async {
    if (!isPlayerTurn.value) {
      await audioService.playSound('sounds/clock_tap_2.wav');
      return;
    }
    await audioService.playSound('sounds/clock_tap_1.wav');
  }

  /// Resets the timer to its initial state.
  void reset() {
    pause();

    playerTime.value = _initialTime;
    opponentTime.value = _initialTime;

    isPlayerTurn.value = true;
    isGameOver.value = false;

    update();
  }

  /// Stops the player ticker and resets its state.
  void _stopPlayerTicker() {
    _playerTicker?.stop();
    _playerTicker?.dispose();
    _playerTicker = null;
    _lastPlayerTimestamp = null;
  }

  /// Stops the opponent ticker and resets its state.
  void _stopOpponentTicker() {
    _opponentTicker?.stop();
    _opponentTicker?.dispose();
    _opponentTicker = null;
    _lastOpponentTimestamp = null;
  }

  /// Formats the time in MM:SS format.
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
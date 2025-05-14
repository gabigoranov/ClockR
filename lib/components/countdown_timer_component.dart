import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';

class CountdownTimerComponent extends StatefulWidget {
  final VoidCallback? onFinished;
  final VoidCallback onTap;
  final bool isActive;
  final bool isPlayer;
  final int rotation;

  const CountdownTimerComponent({
    super.key,
    this.onFinished,
    required this.onTap,
    required this.isActive,
    required this.rotation,
    required this.isPlayer,
  });

  @override
  State<CountdownTimerComponent> createState() => _CountdownTimerComponentState();
}

class _CountdownTimerComponentState extends State<CountdownTimerComponent>
    with SingleTickerProviderStateMixin {
  late int remainingSeconds;
  Timer? timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.isPlayer ? (CountdownTimerController.to.playerTime.value / 1000).floor() : (CountdownTimerController.to.opponentTime.value / 1000).floor();

    // Faster animation controller (120ms)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.isActive) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(CountdownTimerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    remainingSeconds = widget.isPlayer ? (CountdownTimerController.to.playerTime.value / 1000).floor() : (CountdownTimerController.to.opponentTime.value / 1000).floor();
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        startTimer();
      } else {
        stopTimer();
      }
    }
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        stopTimer();
        widget.onFinished?.call();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _handleTap() async {
    widget.onTap(); // Immediate response
    await Future.wait([
      HapticFeedback.lightImpact(),
      _animationController.forward().then((_) => _animationController.reverse()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isActive ? Colors.blue[50] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isActive ? Colors.blue : Colors.transparent,
                    width: 4,
                  ),
                  boxShadow: [
                    if (widget.isActive)
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Active indicator pulse
                    if (widget.isActive)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            opacity: widget.isActive ? 0.2 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    RotatedBox(
                      quarterTurns: widget.rotation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Turn indicator
                              AnimatedOpacity(
                                opacity: widget.isActive ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                formatTime(remainingSeconds),
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isActive
                                      ? Colors.blue[800]
                                      : Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
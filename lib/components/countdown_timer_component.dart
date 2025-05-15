import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

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
            final isTimeUp = (widget.isPlayer
                ? CountdownTimerController.to.playerTime.value
                : CountdownTimerController.to.opponentTime.value) <= 0;

            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isTimeUp
                      ? Colors.red[300]  // Red background when time's up
                      : widget.isActive
                      ? Colors.blue[50]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isTimeUp
                        ? Colors.red  // Red border when time's up
                        : widget.isActive
                        ? Colors.blue
                        : Colors.transparent,
                    width: 4,
                  ),
                  boxShadow: [
                    if (widget.isActive && !isTimeUp)
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Active indicator pulse (only when not time up)
                    if (widget.isActive && !isTimeUp)
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
                              // Turn indicator (hidden when time's up)
                              if (!isTimeUp)
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
                              Obx(() {
                                final milliseconds = widget.isPlayer
                                    ? CountdownTimerController.to.playerTime.value
                                    : CountdownTimerController.to.opponentTime.value;
                                final isTimeUp = milliseconds <= 0;

                                return Text(
                                  formatTime((milliseconds / 1000).floor()),
                                  style: TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    color: isTimeUp
                                        ? Colors.white  // White text for better contrast on red
                                        : widget.isActive
                                        ? Colors.blue[800]
                                        : Colors.grey[800],
                                  ),
                                );
                              }),
                              // Time's up message
                              if (isTimeUp)
                                const Text(
                                  'TIME UP!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
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
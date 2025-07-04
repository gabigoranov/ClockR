import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';
import 'package:tempus/l10n/app_localizations.dart';

class CountdownTimerComponent extends StatefulWidget {
  final VoidCallback? onFinished;
  final VoidCallback onTap;
  final bool isActive;
  final bool isPlayer;
  final bool isTimeUp;
  final int rotation;

  const CountdownTimerComponent({
    super.key,
    this.onFinished,
    required this.onTap,
    required this.isActive,
    required this.isTimeUp,
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
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This forces a rebuild when theme changes
    setState(() {
      Get.find<CountdownTimerController>().update();
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _handleTapDown(TapDownDetails details) async {
    if (!_isTapped) {
      _isTapped = true;
      await HapticFeedback.lightImpact();
      await _animationController.forward();
      await Future.delayed(const Duration(seconds: 5));
      await _animationController.reverse();
      _isTapped = false;
    }
  }

  Future<void> _handleTapUp(TapUpDetails details) async {
    if (_isTapped) {
      _isTapped = false;
      widget.onTap();
      await _animationController.reverse();
    }
  }

  Future<void> _handleTapCancel() async {
    if (_isTapped) {
      _isTapped = false;
      await _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          _handleTapDown(TapDownDetails(globalPosition: event.position));
        },
        onPointerUp: (details) => _handleTapUp(TapUpDetails(
          kind: details.kind,
          globalPosition: details.position,
        )),
        onPointerCancel: (PointerCancelEvent event) {
          _handleTapCancel();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isTimeUp
                      ? Theme.of(context).colorScheme.errorContainer
                      : widget.isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isTimeUp
                        ? Get.theme.colorScheme.error
                        : !Get.isDarkMode
                        ? Get.theme.colorScheme.outline.withValues(alpha: 0.1)
                        : Colors.transparent,
                    width: widget.isTimeUp ? 4 : 1,
                  ),
                  boxShadow: [
                    if (widget.isActive && !widget.isTimeUp)
                      BoxShadow(
                        color: Get.theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 0.10,
                        spreadRadius: 0.2,
                      ),
                    if (!Get.isDarkMode && !widget.isTimeUp && !widget.isActive)
                      BoxShadow(
                        color: Get.theme.colorScheme.outline.withValues(alpha: 0.1),
                        blurRadius: 0.2,
                        spreadRadius: 0.1,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (widget.isActive && !widget.isTimeUp)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            opacity: widget.isActive ? 0.2 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary,
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
                              Obx(() {
                                final milliseconds = widget.isPlayer
                                    ? CountdownTimerController.to.playerTime.value
                                    : CountdownTimerController.to.opponentTime.value;
                                final isTimeUp = milliseconds <= 0;

                                return Text(
                                  formatTime((milliseconds / 1000).floor()),
                                  style: Get.theme.textTheme.displayLarge?.copyWith(
                                    color: isTimeUp
                                        ? Get.theme.colorScheme.onErrorContainer
                                        : widget.isActive
                                        ? Get.theme.colorScheme.onPrimaryContainer
                                        : Get.theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                              if (widget.isTimeUp)
                                Text(
                                  AppLocalizations.of(context).timeUp,
                                  style: Get.theme.textTheme.titleLarge?.copyWith(
                                    color: Get.theme.colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
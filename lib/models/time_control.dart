class TimeControl {
  final int seconds;
  final int increment;

  const TimeControl(this.seconds, this.increment);

  @override
  String toString() {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes min ${remainingSeconds > 0 ? '$remainingSeconds s' : ''} + $increment s';
  }
}

class TimeControl {
  final int seconds;
  final int increment;
  final String name;
  final bool isCustom;

  const TimeControl(this.seconds, this.increment, this.name, {this.isCustom = false});

  @override
  String toString() {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes min ${remainingSeconds > 0 ? '$remainingSeconds s' : ''} + $increment s';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'seconds': seconds,
      'increment': increment,
      'isCustom': isCustom,
    };
  }
}

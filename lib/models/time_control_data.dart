class TimeControlData{
  int seconds;
  int increment;

  TimeControlData(this.seconds, this.increment);

  TimeControlData.fromJson(Map<String, dynamic> json)
      : seconds = json['seconds'] ?? 0,
        increment = json['increment'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'seconds': seconds,
      'increment': increment,
    };
  }

  @override
  String toString() {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes min ${remainingSeconds > 0 ? '$remainingSeconds s' : ''} + $increment s';

  }
}


class DurationFormatter {
  static String format(Duration duration) {
    final seconds = duration.inSeconds;
    if (seconds <= 0) {
      return '00:00';
    }

    final s = seconds % 60;
    final m = (seconds ~/ 60) % 60;
    final h = (seconds ~/ 3600);

    String twoDigits(int n) {
      if (n >= 10) {
        return '$n';
      } else {
        return '0$n';
      }
    }

    if (h > 0) {
      return '$h:${twoDigits(m)}:${twoDigits(s)}';
    } else {
      return '${twoDigits(m)}:${twoDigits(s)}';
    }
  }

  static Duration calculateDuration(double value, Duration totalTime) {
    final newSeconds = (totalTime.inSeconds * value).round();
    return Duration(seconds: newSeconds);
  }
}

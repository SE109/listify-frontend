Duration calculateDifference(DateTime date, DateTime other) {
  return date.difference(other);
}

String getLabelFromDuration(Duration duration) {
  final dayDifference = (duration.inMinutes / 3600).round();
  if (dayDifference == 1) return 'Tomorrow';
  if (dayDifference == 0) return 'Today';
  if (dayDifference == -1) return 'Yesterday';

  return '';
}

bool isToday(time) {
  final now = DateTime.now();
  final daysDifference = (now.difference(time).inMinutes / 3600).round();
  return daysDifference == 0;
}

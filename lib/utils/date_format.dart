import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  return date != null ? DateFormat.MMMEd().format(date) : '';
}

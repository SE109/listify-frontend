import 'package:intl/intl.dart';

class FormatUtils {
  static String formatDateTime(DateTime dateTime,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final dateFormatter = DateFormat(format);
    return dateFormatter.format(dateTime);
  }

  static String formatTaskDetailDateTime(DateTime dateTime,
      {String format = 'EEE, MMM dd'}) {
    final dateFormatter = DateFormat(format);
    return dateFormatter.format(dateTime);
  }

  // Other utility methods for time formatting can be added here
}

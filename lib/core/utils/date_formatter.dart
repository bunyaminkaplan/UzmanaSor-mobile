import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd MMM yyyy').format(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} gn önce';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} sa önce';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} dk önce';
    } else {
      return 'Az önce';
    }
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('dd MMMM yyyy HH:mm').format(date);
  }
}

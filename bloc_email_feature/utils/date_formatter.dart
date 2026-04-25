import 'package:intl/intl.dart';

/// Utility class for formatting dates in email context
class DateFormatter {
  /// Formats date for email list display
  /// - Today: "14:30"
  /// - Yesterday: "Hôm qua"
  /// - This week: Weekday name
  /// - Older: Date format
  static String formatEmailDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final emailDate = DateTime(date.year, date.month, date.day);

    // Today - show time
    if (emailDate == today) {
      return DateFormat('HH:mm').format(date);
    }

    // Yesterday
    if (emailDate == yesterday) {
      return 'Hôm qua';
    }

    // This week - show weekday
    final daysAgo = today.difference(emailDate).inDays;
    if (daysAgo < 7) {
      return _getVietnameseWeekday(date.weekday);
    }

    // This year - show date without year
    if (date.year == now.year) {
      return DateFormat('dd/MM').format(date);
    }

    // Older - show full date
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formats full date with time
  static String formatFullDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Gets Vietnamese weekday name
  static String _getVietnameseWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.saturday:
        return 'Thứ Bảy';
      case DateTime.sunday:
        return 'Chủ Nhật';
      default:
        return '';
    }
  }

  /// Formats file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

import 'package:intl/intl.dart';

class StringUtils {
  /// Truncates a string to a given length and adds '...' if needed.
  static String truncate(String text, int maxLength) {
    return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
  }

  /// Formats a date string with optional timestamp or only time.
  static String formatLastActive(String lastActive) {
    final now = DateTime.now();
    final difference = now.difference(DateTime.tryParse(lastActive) ?? DateTime.now());

    if (difference.inDays == 0) {
      // Today: Show time for today
      if (difference.inHours < 1) {
        // Less than an hour ago
        if (difference.inMinutes == 1) {
          return '1 minute ago';
        } else if (difference.inMinutes < 60) {
          return '${difference.inMinutes} minutes ago';
        } else {
          return 'Just now';
        }
      } else if (difference.inHours < 24) {
        // More than an hour but less than a day
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else {
        // More than 1 hour today, show time
        return 'Today at ${DateFormat('h:mm a').format(DateTime.tryParse(lastActive) ?? DateTime.now())}';
      }
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday at ${DateFormat('h:mm a').format(DateTime.tryParse(lastActive) ?? DateTime.now())}';
    } else if (difference.inDays < 7) {
      // Day of the week (e.g., Monday)
      return DateFormat('EEEE, h:mm a').format(DateTime.tryParse(lastActive) ?? DateTime.now());
    } else if (now.year == (DateTime.tryParse(lastActive) ?? DateTime.now()).year) {
      // Last week
      return 'Last week at ${DateFormat('h:mm a').format(DateTime.tryParse(lastActive) ?? DateTime.now())}';
    } else if (now.year - (DateTime.tryParse(lastActive) ?? DateTime.now()).year == 1) {
      // Last year
      return 'Last year at ${DateFormat('h:mm a').format(DateTime.tryParse(lastActive) ?? DateTime.now())}';
    } else {
      // For older dates, show full date and time
      return DateFormat('d MMMM yyyy, h:mm a').format(DateTime.tryParse(lastActive) ?? DateTime.now());
    }
  }

  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  /// Gets initials from two given strings.
  static String getInitials(String firstName, String lastName) {
    if (firstName.isEmpty || lastName.isEmpty) return '';
    return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
  }

  /// Formats a currency string input for Nigeria (₦).
  static String formatCurrencyInput(String amount) {
    final formatter = NumberFormat.currency(
      locale: "en_NG",
      symbol: "₦",
      decimalDigits: 2,
    );

    amount = amount.replaceAll(RegExp(r'[^0-9.]'), "");
    final amountDouble = double.tryParse(amount);
    return amountDouble != null ? formatter.format(amountDouble) : "";
  }

  /// Formats a number with commas (e.g., 1,234,567).
  static String formatNumber(String amount) {
    return NumberFormat("#,##0", "en_US").format(double.tryParse(amount) ?? 0);
  }

  /// Returns a greeting based on the current time.
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Morning";
    if (hour < 17) return "Afternoon";
    return "Evening";
  }

  /// Formats a phone number for API use, removing the leading zero if present.
  static String formatPhoneNumberForApi(
    String phoneNumber,
  ) {
    return phoneNumber.startsWith("0") ? phoneNumber.substring(1) : phoneNumber;
  }

  /// Capitalizes the first letter of a string.
  static String capitalize(String text) {
    if (text.isEmpty) return "";
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Formats a [Duration] into `mm:ss` format.
  static String formatTimeInMinutes(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:'
        '${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}';
  }

  /// Splits a camel case string and joins with spaces.
  static String splitAndJoinEachUpperCase(String text) {
    return text.split(RegExp('(?=[A-Z])')).join(' ');
  }
}

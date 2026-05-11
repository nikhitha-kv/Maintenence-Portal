import 'package:intl/intl.dart';

class DateFormatter {
  static String formatSAPDate(String sapDate) {
    if (sapDate.isEmpty || sapDate == '00000000') return 'N/A';
    
    // Try native parsing first (handles ISO 8601 like YYYY-MM-DD)
    final parsed = DateTime.tryParse(sapDate);
    if (parsed != null) {
      return DateFormat('dd MMM yyyy').format(parsed.toLocal());
    }

    // Handle /Date(1715418216000)/ format with potential timezone offsets
    if (sapDate.contains('/Date(')) {
      final match = RegExp(r'(\d+)').firstMatch(sapDate);
      if (match != null) {
        final milliseconds = int.tryParse(match.group(1)!);
        if (milliseconds != null) {
          final date = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true).toLocal();
          return DateFormat('dd MMM yyyy').format(date);
        }
      }
    }
    
    // Handle YYYYMMDD format
    if (sapDate.length == 8 && int.tryParse(sapDate) != null) {
      try {
        final year = int.parse(sapDate.substring(0, 4));
        final month = int.parse(sapDate.substring(4, 6));
        final day = int.parse(sapDate.substring(6, 8));
        final date = DateTime(year, month, day);
        return DateFormat('dd MMM yyyy').format(date);
      } catch (_) {}
    }
    
    return sapDate; // Return as is if format unknown
  }

  static DateTime? toDateTime(String sapDate) {
    if (sapDate.isEmpty || sapDate == '00000000') return null;
    
    // Try native parsing first (handles ISO 8601 like YYYY-MM-DD)
    final parsed = DateTime.tryParse(sapDate);
    if (parsed != null) return parsed.toLocal();

    if (sapDate.contains('/Date(')) {
      final match = RegExp(r'(\d+)').firstMatch(sapDate);
      if (match != null) {
        final milliseconds = int.tryParse(match.group(1)!);
        if (milliseconds != null) {
          return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true).toLocal();
        }
      }
    }
    
    if (sapDate.length == 8 && int.tryParse(sapDate) != null) {
      try {
        final year = int.parse(sapDate.substring(0, 4));
        final month = int.parse(sapDate.substring(4, 6));
        final day = int.parse(sapDate.substring(6, 8));
        return DateTime(year, month, day);
      } catch (_) {}
    }
    
    return null;
  }
}

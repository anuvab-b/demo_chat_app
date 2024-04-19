import 'package:jiffy/jiffy.dart';

class Utils {
  static String formatDate(DateTime? date,
      {String outputFormat = "dd/MM/yyyy"}) {
    try {
      if (date != null) {
        return Jiffy.parseFromDateTime(date).format(pattern: outputFormat);
      } else {
        return "-";
      }
    } catch (e) {
      return "-";
    }
  }

  /// Convert a String format Date into DateTime
  static DateTime formatDateString(String? date,
      {String inputFormat = "dd-MM-yyyy"}) {
    try {
      if (date != null) {
        return Jiffy.parse(date,pattern: inputFormat).dateTime;
      } else {
        return DateTime.now();
      }
    } catch (e) {
      return DateTime.now();
    }
  }
}
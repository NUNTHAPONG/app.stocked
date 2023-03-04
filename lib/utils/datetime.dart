class DateTimeService {
  static String formatDate(DateTime date) {
    return date.toIso8601String().split('T').elementAt(0);
  }

  static String formatTime(DateTime date) {
    String d = date.toIso8601String().split('T').elementAt(0);
    String t =
        date.toIso8601String().split('T').elementAt(1).split('.').elementAt(0);
    return '$d $t';
  }
}

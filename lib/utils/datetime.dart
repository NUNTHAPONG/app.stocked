class DateTimeService {
  static String getThMonthName(int month, [bool init = false]) {
    String result = '';
    switch (month) {
      case 1:
        result = init ? 'ม.ค.' : 'มกราคม';
        break;
      case 2:
        result = init ? 'ก.พ.' : 'กุมภาพันธ์';
        break;
      case 3:
        result = init ? 'มี.ค.' : 'มีนาคม';
        break;
      case 4:
        result = init ? 'เม.ย.' : 'เมษายน';
        break;
      case 5:
        result = init ? 'พ.ค.' : 'พฤษภาคม';
        break;
      case 6:
        result = init ? 'มิ.ย.' : 'มิถุนายน';
        break;
      case 7:
        result = init ? 'ก.ค.' : 'กรกฎาคม';
        break;
      case 8:
        result = init ? 'ส.ค.' : 'สิงหาคม';
        break;
      case 9:
        result = init ? 'ก.ย.' : 'กันยายน';
        break;
      case 10:
        result = init ? 'ต.ค.' : 'ตุลาคม';
        break;
      case 11:
        result = init ? 'พ.ย.' : 'พฤศจิกายน';
        break;
      case 12:
        result = init ? 'ธ.ค.' : 'ธันวาคม';
        break;
    }
    return result;
  }

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

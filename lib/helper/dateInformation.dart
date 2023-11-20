import 'package:intl/intl.dart';

String AnniversaryCountDown() {
  const int anniversaryDay = 22;
  DateTime now = DateTime.now();
  DateTime nextAnniversary = DateTime(now.year, now.month, anniversaryDay);
  String countdownMessage;
  if (now.day == anniversaryDay) {
    countdownMessage = "Happy Anniversary! I love you so much sweetie!!!";
  } else {
    if (now.day > anniversaryDay) {
      nextAnniversary = DateTime(now.year, now.month + 1, anniversaryDay);
    }
    Duration duration = nextAnniversary.difference(now);
    countdownMessage =
        '${duration.inDays}d, ${duration.inHours % 24}h, ${duration.inMinutes % 60}m, ${duration.inSeconds % 60}s until the next anniversary';
  }
  return countdownMessage;
}

String DateStringToDisplayFormat(String date) {
  return DateFormat('LLLL d, y').format(DateTime.parse(date));
}

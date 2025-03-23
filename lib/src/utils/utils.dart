import 'dart:math';

import 'package:intl/intl.dart';

String generateRandomValueKey() {
  var random = Random();
  var randomValueKey = random.nextInt(999999).toString();
  return randomValueKey;
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  if (text.length == 1) return text.toUpperCase();
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String formatDateFromYearToSecond(DateTime date) {
  return DateFormat('dd MMMM yyyy HH:mm:ss', "id").format(date);
}

String formatDateFromYearToDay(DateTime date) {
  return DateFormat('dd MMMM yyyy', "id").format(date);
}

String getYesOrNo(bool condition) {
  return condition ? 'Yes' : 'No';
}

String formatDateString(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}

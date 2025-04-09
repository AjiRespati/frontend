import 'dart:math';

import 'package:flutter/material.dart';
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

String formatMonthDay(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('MM/dd');
  return formatter.format(dateTime);
}

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
}) async {
  DateTime? selectedDate;

  await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        child: CalendarDatePicker(
          initialDate: initialDate, // DateTime.now(),
          firstDate: firstDate, //DateTime(1900),
          lastDate: DateTime(3000),
          onDateChanged: (DateTime date) {
            selectedDate = date;
            Navigator.of(context).pop(date); // Close and return date
          },
        ),
      );
    },
  );

  return selectedDate;
}

String formatCurrency(num number) {
  // Floor rounding the number
  int roundedNumber = number.floor();

  // Create a NumberFormat for Indonesian Rupiah
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0, // No decimal digits
  );

  // Format the rounded number
  return currencyFormatter.format(roundedNumber);
}

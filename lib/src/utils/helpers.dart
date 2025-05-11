import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/src/models/freezer_status.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
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
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}

String formatDateStringHM(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  final formatter = DateFormat('yyyy-MM-dd, HH:mm');
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

// --- Helper Function to convert String to Enum ---
// It's good practice to handle potential mismatches
FreezerStatus freezerStatusFromString(
  String statusStr, {
  FreezerStatus fallback = FreezerStatus.idle,
}) {
  // Normalize the input string (lowercase) for case-insensitive comparison
  final normalizedStr = statusStr.toLowerCase();
  try {
    // Find the enum value whose display name matches the normalized input string
    return FreezerStatus.values.firstWhere(
      (el) => el.name == normalizedStr,
      // (e) => e.displayName.toLowerCase() == normalizedStr,
    );
  } catch (e) {
    // Handle cases where the string doesn't match any enum value
    print(
      "Warning: Received unknown status '$statusStr' from backend. Falling back to ${fallback.displayName}",
    );
    return fallback; // Return the fallback value (e.g., idle)
  }
}
// --- End Helper Function ---

void snackbarGenerator(BuildContext context, StockViewModel model) {
  return WidgetsBinding.instance.addPostFrameCallback((_) {
    if (model.isNoSession) {
      Navigator.pushNamed(context, signInRoute);
      model.isNoSession = false;
    } else if (model.isError == true) {
      _showSnackBar(
        context,
        model.errorMessage ?? "Error",
        color: Colors.red.shade400,
        duration: Duration(seconds: 2),
      );
      model.isError = null;
      model.errorMessage = null;
    } else if (model.isSuccess) {
      _showSnackBar(
        context,
        model.successMessage ?? "Success",
        color: Colors.green.shade400,
        duration: Duration(seconds: 2),
      );
      model.isSuccess = false;
      model.successMessage = null;
    }
  });
}

// Helper function to show SnackBars
void _showSnackBar(
  BuildContext context,
  String message, {
  Color color = Colors.blue,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration,
    ),
  );
}

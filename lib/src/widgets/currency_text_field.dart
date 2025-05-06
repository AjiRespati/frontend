import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final ValueChanged<String>? onChanged;

  const CurrencyTextField({
    super.key,
    required this.controller,
    this.label,
    this.onChanged,
  });

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  bool _isFormatting = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatInput);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatInput);
    super.dispose();
  }

  void _formatInput() {
    if (_isFormatting) return;

    final rawText = widget.controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (rawText.isEmpty) {
      widget.onChanged?.call('');
      return;
    }

    final number = int.parse(rawText);
    final formatted = _currencyFormatter.format(number);

    _isFormatting = true;
    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _isFormatting = false;

    widget.onChanged?.call(rawText);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.label ?? 'Jumlah Pembayaran',
      ),
    );
  }
}

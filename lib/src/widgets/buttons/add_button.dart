import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    this.size,
    required this.message,
    required this.onPressed,
    super.key,
  });

  final double? size;
  final String? message;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: SizedBox(
        height: size ?? 25,
        width: size ?? 25,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(0),
          ),
          onPressed: onPressed,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: size == null ? 20 : size! * 0.8,
          ),
        ),
      ),
    );
  }
}

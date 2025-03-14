import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    this.size,
    required this.onPressed,
    super.key,
  });

  final double? size;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 25,
      width: size ?? 25,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          // overlayColor: Colors.transparent,
          // foregroundColor: Colors.transparent,
          // surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
        ),
        onPressed: onPressed,
        child: Icon(
          Icons.arrow_back_ios_new,
          // color: Colors.white,
          size: size == null ? 20 : size! * 0.8,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GradientElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double elevation;
  final double borderRadius;
  final double buttonHeight;

  const GradientElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.elevation = 8.0,
    this.borderRadius = 10.0,
    this.buttonHeight = 40,
  });

  @override
  State<GradientElevatedButton> createState() => _GradientElevatedButtonState();
}

class _GradientElevatedButtonState extends State<GradientElevatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed == null
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null
          ? null
          : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.onPressed == null
          ? null
          : () => setState(() => _isPressed = false),
      child: InkWell(
        onTap: widget.onPressed == null
            ? null
            : () {
                setState(() => _isPressed = true);
                Future.delayed(
                  Durations.short3,
                  () {
                    setState(() => _isPressed = false);
                    widget.onPressed!();
                  },
                );
              },
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          height: widget.buttonHeight,
          decoration: BoxDecoration(
            gradient: widget.onPressed == null
                ? LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _isPressed
                ? []
                : [
                    const BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 8.0,
                    ),
                  ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}

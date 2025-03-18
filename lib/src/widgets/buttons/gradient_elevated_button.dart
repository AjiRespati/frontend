import 'package:flutter/material.dart';

class GradientElevatedButton extends StatefulWidget {
  const GradientElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.blue, Color.fromRGBO(30, 48, 241, 1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.elevation = 8.0,
    this.borderRadius = 10.0,
    this.buttonHeight = 40,
    this.inactiveDelay = Durations.extralong4,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double elevation;
  final double borderRadius;
  final double buttonHeight;
  final Duration inactiveDelay;

  @override
  State<GradientElevatedButton> createState() => _GradientElevatedButtonState();
}

class _GradientElevatedButtonState extends State<GradientElevatedButton> {
  bool _isPressed = false;
  bool _isInactive = false;

  @override
  void dispose() {
    super.dispose();
    _isPressed = false;
    _isInactive = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          _isInactive
              ? null
              : widget.onPressed == null
              ? null
              : (_) => setState(() => _isPressed = true),
      onTapUp:
          _isInactive
              ? null
              : widget.onPressed == null
              ? null
              : (_) => setState(() => _isPressed = false),
      onTapCancel:
          _isInactive
              ? null
              : widget.onPressed == null
              ? null
              : () => setState(() => _isPressed = false),
      child: InkWell(
        onTap:
            _isInactive
                ? null
                : widget.onPressed == null
                ? null
                : () async {
                  setState(() => _isPressed = true);
                  await Future.delayed(Durations.short3, () {
                    setState(() {
                      _isPressed = false;
                      _isInactive = true;
                    });
                  });
                  await Future.delayed(widget.inactiveDelay, () {
                    setState(() {
                      _isInactive = false;
                    });
                  });
                  await Future.delayed(Durations.short3, () {
                    widget.onPressed!();
                  });
                },
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: Colors.white.withAlpha(200),
        highlightColor: Colors.white.withAlpha(100),
        child: Container(
          height: widget.buttonHeight,
          decoration: BoxDecoration(
            gradient:
                widget.onPressed == null
                    ? LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow:
                _isPressed
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
            children: [Center(child: widget.child)],
          ),
        ),
      ),
    );
  }
}

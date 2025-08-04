import 'package:flutter/material.dart';

class GradientElevatedButton extends StatefulWidget {
  const GradientElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.red, Color.fromARGB(255, 249, 84, 72)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.elevation = 8.0,
    this.borderRadius = 10.0,
    this.buttonHeight = 40,
    this.inactiveDelay = Durations.extralong4,
    this.padding,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double elevation;
  final double borderRadius;
  final double buttonHeight;
  final Duration inactiveDelay;
  final EdgeInsetsGeometry? padding;

  @override
  State<GradientElevatedButton> createState() => _GradientElevatedButtonState();
}

class _GradientElevatedButtonState extends State<GradientElevatedButton> {
  // bool _isPressed = false;
  // bool _isInactive = false;

  // @override
  // void dispose() {
  //   super.dispose();
  //   _isPressed = false;
  //   _isInactive = false;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.buttonHeight,
      decoration: BoxDecoration(
        // Define the gradient here
        gradient: widget.gradient,
        // Optional: Add border radius to match button shape
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: widget.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          elevation: widget.elevation, // Shadow elevation
          backgroundColor:
              Colors.transparent, // Make button background transparent
          shadowColor: Colors.transparent, // Remove shadow if any
          foregroundColor: Colors.white, // Set text/icon color to be visible

          iconColor: Colors.white, // Icon color
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );

    // return GestureDetector(
    //   onTapDown:
    //       _isInactive
    //           ? null
    //           : widget.onPressed == null
    //           ? null
    //           : (_) => setState(() => _isPressed = true),
    //   onTapUp:
    //       _isInactive
    //           ? null
    //           : widget.onPressed == null
    //           ? null
    //           : (_) => setState(() => _isPressed = false),
    //   onTapCancel:
    //       _isInactive
    //           ? null
    //           : widget.onPressed == null
    //           ? null
    //           : () => setState(() => _isPressed = false),
    //   child: InkWell(
    //     onTap:
    //         _isInactive
    //             ? null
    //             : widget.onPressed == null
    //             ? null
    //             : () async {
    //               _isInactive = true;
    //               setState(() => _isPressed = true);
    //               widget.onPressed!();
    //               await Future.delayed(Durations.short3, () {
    //                 if (mounted) {
    //                   setState(() {
    //                     _isPressed = false;
    //                     // _isInactive = true;
    //                   });
    //                 }
    //               });
    //               await Future.delayed(widget.inactiveDelay, () {
    //                 if (mounted) {
    //                   setState(() {
    //                     _isInactive = false;
    //                   });
    //                 }
    //               });
    //               // await Future.delayed(Durations.short3, () {
    //               //   widget.onPressed!();
    //               // });
    //             },
    //     borderRadius: BorderRadius.circular(widget.borderRadius),
    //     splashColor: Colors.white.withAlpha(200),
    //     highlightColor: Colors.white.withAlpha(100),
    //     child: Container(
    //       height: widget.buttonHeight,
    //       decoration: BoxDecoration(
    //         gradient:
    //             widget.onPressed == null
    //                 ? LinearGradient(
    //                   colors: [Colors.grey.shade300, Colors.grey.shade500],
    //                   begin: Alignment.topLeft,
    //                   end: Alignment.bottomRight,
    //                 )
    //                 : widget.gradient,
    //         borderRadius: BorderRadius.circular(widget.borderRadius),
    //         boxShadow:
    //             _isPressed
    //                 ? []
    //                 : [
    //                   const BoxShadow(
    //                     color: Colors.black26,
    //                     offset: Offset(0, 3),
    //                     blurRadius: 8.0,
    //                   ),
    //                 ],
    //       ),
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [Center(child: widget.child)],
    //       ),
    //     ),
    //   ),
    // );
  }
}

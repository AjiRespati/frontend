import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Responsive extends StatelessWidget {
  const Responsive(
      {required this.mobile, this.tablet, required this.desktop, super.key});

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(
        desktop: 1140,
        tablet: 980,
        watch: 260,
      ),
      watch: (_) => mobile,
      mobile: (_) => mobile,
      tablet: (_) => tablet ?? _tabletViewByOrientation(desktop, mobile),
      desktop: (_) => desktop,
    );
  }
}

Widget _tabletViewByOrientation(
  Widget desktop,
  Widget mobile,
) {
  return OrientationLayoutBuilder(
    portrait: (context) => mobile,
    landscape: (context) => desktop,
  );
}

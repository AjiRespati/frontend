import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobileLayout,
    this.tabletLayout,
    required this.desktopLayout,
    super.key,
  });

  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget desktopLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileLayout;
        } else if (constraints.maxWidth < 1200) {
          return tabletLayout ?? mobileLayout;
        } else {
          return desktopLayout;
        }
      },
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tampilan Mobile", style: TextStyle(fontSize: 18)),
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tampilan Tablet", style: TextStyle(fontSize: 22)),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tampilan Desktop", style: TextStyle(fontSize: 26)),
    );
  }
}

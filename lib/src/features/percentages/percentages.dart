import 'package:flutter/material.dart';
import 'package:frontend/src/features/percentages/percentages_desktop.dart';
import 'package:frontend/src/features/percentages/percentages_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Percentages extends StatefulWidget with GetItStatefulWidgetMixin {
  Percentages({super.key});

  @override
  State<Percentages> createState() => _PercentagesState();
}

class _PercentagesState extends State<Percentages> with GetItStateMixin {
  Future<void> _setup() async {
    await get<StockViewModel>().fetchPercentages();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: PercentagesMobile(),
      desktopLayout: PercentagesDesktop(),
    );
  }
}

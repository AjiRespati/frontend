import 'package:flutter/material.dart';
import 'package:frontend/src/features/settings/settings_desktop.dart';
import 'package:frontend/src/features/settings/settings_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Settings extends StatefulWidget with GetItStatefulWidgetMixin {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with GetItStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<SystemViewModel>().self(context);
      if ((get<SystemViewModel>().level ?? 0) > 3) {
        get<SystemViewModel>().getAllUser(context);
        get<StockViewModel>().getAllFrezer(context);
        get<StockViewModel>().getAllShops(context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: SettingsMobile(),
      desktopLayout: SettingsDesktop(),
    );
  }
}

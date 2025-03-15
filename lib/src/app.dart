import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../application_info.dart';
import 'routes/animate_route_transitions.dart';
import 'routes/app_router.dart';
import 'utils/custom_scroll_behavior.dart';
import 'view_models/provider.dart';
import 'widgets/not_found_page.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: ApplicationInfo.appName,
          theme: ThemeData(
            textTheme: GoogleFonts.mulishTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              // surface: const Color.fromRGBO(0, 0, 255, 0.03),
            ),
            useMaterial3: true,
          ),
          navigatorKey: locator<NavigationKey>().navigatorKey,
          initialRoute: "/",
          onGenerateRoute: AppRouter.routes(),
          onUnknownRoute: (settings) {
            return FadeRoute(page: const NotFoundPage(), settings: settings);
          },
          scrollBehavior: CustomScrollBehavior(),
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
          supportedLocales: const [Locale('en'), Locale('id')],
          debugShowCheckedModeBanner: !ApplicationInfo.isProduction,
        );
      },
    );
  }
}

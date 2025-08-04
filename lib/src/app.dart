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
            // Set the textTheme to a different Google Font.
            // Rubik is a great option that has a playful, rounded feel.
            textTheme: GoogleFonts.maliTextTheme(
              Theme.of(
                context,
              ).textTheme, // This ensures that the existing theme properties are preserved
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red.shade400,
              primary: Colors.red,
              secondary: Colors.yellow.shade800,
              // surface: const Color.fromRGBO(0, 0, 255, 0.03),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/localization/app_language.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const TamweenApp());
}

class TamweenApp extends StatelessWidget {
  const TamweenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.tajawalTextTheme(ThemeData.light().textTheme);

    return ListenableBuilder(
      listenable: AppLanguage.instance,
      builder: (context, child) {
        return Directionality(
          textDirection: AppLanguage.instance.textDirection,
          child: MaterialApp(
            title: AppLanguage.instance.tr('app_title'),
            debugShowCheckedModeBanner: false,
            locale: AppLanguage.instance.locale,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00BFA5),
                brightness: Brightness.light,
              ),
              textTheme: textTheme,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1C1C1E),
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                titleTextStyle: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              scaffoldBackgroundColor: const Color(0xFFF2F2F7),
              cardTheme: CardThemeData(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: Color(0xFFE5E5EA)),
                ),
                color: Colors.white,
              ),
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}


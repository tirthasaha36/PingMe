import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/circular_theme_transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const PingMeApp());
}

class PingMeApp extends StatelessWidget {
  const PingMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
          child: MaterialApp(
            title: 'PingMe',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            themeAnimationDuration: Duration.zero,
            builder: (context, child) {
              return CircularThemeTransition(
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const SplashOrHomeWrapper(),
          ),
        );
      },
    );
  }
}

class SplashOrHomeWrapper extends StatefulWidget {
  const SplashOrHomeWrapper({super.key});

  @override
  State<SplashOrHomeWrapper> createState() => _SplashOrHomeWrapperState();
}

class _SplashOrHomeWrapperState extends State<SplashOrHomeWrapper> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onFinished: () {
          if (mounted) {
            setState(() {
              _showSplash = false;
            });
          }
        },
      );
    }
    return const HomeScreen();
  }
}

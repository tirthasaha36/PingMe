import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

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
    return MaterialApp(
      title: 'PingMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashOrHomeWrapper(),
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

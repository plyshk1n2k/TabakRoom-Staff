import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tabakroom_staff/screens/auth_check.dart';
import 'package:tabakroom_staff/screens/home_screen.dart';
import 'package:tabakroom_staff/screens/login_screen.dart';
import 'package:tabakroom_staff/screens/pin_screen.dart';
import 'package:tabakroom_staff/services/api_service.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';
import 'package:tabakroom_staff/services/auth_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/themes/theme_provider.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await AppPreferences.init();
  final bool isAuthenticated =
      await AuthService.isLoggedIn(); // Проверяем авторизацию

  ApiService.onLogoutCallback = () async {
    await AuthService.logout();
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  };

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: TabakRoomApp(isAuthenticated: isAuthenticated),
    ),
  );
}

class TabakRoomApp extends StatelessWidget {
  final bool isAuthenticated; // 🔹 Добавляем поле для авторизации

  const TabakRoomApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
        onTap: () {
          // Убираем фокус с текстовых полей при нажатии вне их
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TabakRoom',
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          navigatorKey: navigatorKey,
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/pin_screen': (context) => const PinScreen(),
          },
          home: AuthCheck(),
          builder: (context, child) => AppLock(
            builder: (context, arg) => child!,
            lockScreenBuilder: (context) => const PinScreen(),
            initiallyEnabled:
                isAuthenticated, // 🔹 Теперь точно корректное значение
            initialBackgroundLockLatency: const Duration(seconds: 1),
          ),
        ));
  }
}

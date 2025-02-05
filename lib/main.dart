import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tabakroom_staff/screens/auth_check.dart';
import 'package:tabakroom_staff/screens/login_screen.dart';
import 'package:tabakroom_staff/services/api_service.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';
import 'package:tabakroom_staff/services/auth_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/themes/theme_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Загружаем .env
  await AppPreferences.init();
  ApiService.onLogoutCallback = () async {
    await AuthService.logout(); // 🔹 Удаляем токены
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  };
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const TabakRoomApp(),
    ),
  );
}

class TabakRoomApp extends StatelessWidget {
  const TabakRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        // Убираем фокус с текстовых полей при нажатии вне их
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Убираем баннер отладки
        title: 'TabakRoom',
        theme: CustomTheme.lightTheme, // Светлая тема
        darkTheme: CustomTheme.darkTheme, // Тёмная тема
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        navigatorKey: navigatorKey, // 🔹 Подключаем глобальный навигатор
        routes: {
          '/login': (context) => LoginScreen(),
        },
        home: AuthCheck(),
      ),
    );
  }
}

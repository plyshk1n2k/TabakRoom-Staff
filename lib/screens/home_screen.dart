import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabakroom_staff/screens/create_order_screen.dart';
import 'package:tabakroom_staff/screens/login_screen.dart';
import 'package:tabakroom_staff/screens/suspicious_transactions_screen.dart';
import 'package:tabakroom_staff/screens/low_stock_screen.dart';
import 'package:tabakroom_staff/services/auth_service.dart';
import 'package:tabakroom_staff/themes/theme_provider.dart';
import 'package:tabakroom_staff/widgets/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ТабакRoom - Главная',
        ),
        centerTitle: true,
        leading: // Кнопка для смены темы с разными иконками
            IconButton(
          icon: Icon(
            _isDarkMode
                ? Icons.nightlight_round_outlined
                : Icons
                    .wb_sunny_outlined, // Иконка меняется в зависимости от темы
          ),
          onPressed: () async {
            await themeProvider.toggleTheme();
          }, // Переключение темы при нажатии
        ),
        actions: [
          IconButton(
              onPressed: () {
                AuthService.logout(); // Выход пользователя
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // Удаляем все предыдущие страницы
                );
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuCard(
              icon: Icons.inventory_2_outlined,
              title: 'Анализ остатков',
              description: 'Приоритет закупок',
              screen: const LowStockScreen(),
            ),
            MenuCard(
              icon: Icons.warning_amber_rounded,
              title: 'Подозрительные транзакции',
              description: 'Анализ операций с бонусами',
              screen: const SuspiciousTransactionsScreen(),
            ),
            MenuCard(
              icon: Icons.assignment_add,
              title: 'Формирование заказа',
              description: 'Помощь в составлении заказа',
              screen: const CreateOrderScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

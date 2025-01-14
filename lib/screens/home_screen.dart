import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabakroom_staff/screens/suspicious_transactions_screen.dart';
import 'package:tabakroom_staff/screens/low_stock_screen.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/themes/theme_provider.dart';

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
        leading: // Кнопка для смены темы с разными иконками
            IconButton(
          icon: Icon(
            _isDarkMode
                ? Icons.nightlight_round
                : Icons.wb_sunny, // Иконка меняется в зависимости от темы
          ),
          onPressed: () async {
            await themeProvider.toggleTheme();
          }, // Переключение темы при нажатии
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.warning_amber_rounded,
              title: 'Подозрительные транзакции',
              description: 'Анализ операций с бонусами',
              screen: const SuspiciousTransactionsScreen(),
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Заканчивающиеся товары',
              description: 'Приоритет закупок',
              screen: const LowStockScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required Widget screen}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 50,
                color: AppColors.backgroundLight,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.backgroundLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

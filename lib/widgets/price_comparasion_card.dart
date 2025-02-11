import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class PriceComparisonCard extends StatelessWidget {
  final double currentPrice;
  final double initialPrice;
  final Color? customColor; // Можно передать свой цвет (необязательно)

  const PriceComparisonCard({
    Key? key,
    required this.currentPrice,
    required this.initialPrice,
    this.customColor, // Цвет опциональный
  }) : super(key: key);

  /// 🔹 Расчёт изменения цены в процентах
  double _calculatePercentageChange() {
    if (initialPrice == 0) return 0.0; // Защита от деления на 0
    return ((currentPrice - initialPrice) / initialPrice) * 100;
  }

  @override
  Widget build(BuildContext context) {
    double percentageChange = _calculatePercentageChange();
    bool isPositive = percentageChange >= 0;

    // Если цвет не передали, выбираем автоматически
    Color indicatorColor =
        customColor ?? (isPositive ? AppColors.secondary : AppColors.danger);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 4),
        Text(
          "$currentPrice ₽",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: indicatorColor, // ✅ Используем кастомный или автоцвет
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              "${percentageChange.abs().toStringAsFixed(2)}%",
              style: TextStyle(
                color: indicatorColor, // ✅ Используем кастомный или автоцвет
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

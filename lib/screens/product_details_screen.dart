import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productName;
  final String warehouse;
  final int salesLast7Days;
  final int salesLast30Days;
  final int salesLast180Days;
  final int currentStock;
  final int stockCoverageDays;
  final String priority;

  const ProductDetailsScreen({
    Key? key,
    required this.productName,
    required this.warehouse,
    required this.salesLast7Days,
    required this.salesLast30Days,
    required this.salesLast180Days,
    required this.currentStock,
    required this.stockCoverageDays,
    required this.priority,
  }) : super(key: key);

  String _pluralizeDay(int days) {
    if (days % 10 == 1 && days % 100 != 11) {
      return 'день';
    } else if ([2, 3, 4].contains(days % 10) &&
        ![12, 13, 14].contains(days % 100)) {
      return 'дня';
    } else {
      return 'дней';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название товара
            Text(
              productName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Карточка с данными склада
            _buildInfoCard(
              context,
              title: 'Склад',
              content: warehouse,
              icon: Icons.warehouse_outlined,
            ),

            // Карточка с данными по продажам
            _buildInfoCard(
              context,
              title: 'Продажи',
              content:
                  '7 дней: $salesLast7Days\n30 дней: $salesLast30Days\n180 дней: $salesLast180Days',
              icon: Icons.bar_chart_outlined,
            ),

            // Карточка с текущим остатком
            _buildInfoCard(
              context,
              title: 'Остаток',
              content: '$currentStock шт.',
              icon: Icons.inventory_2_outlined,
            ),

            // Карточка с расчётом ориентировочного времени
            _buildInfoCard(
              context,
              title: 'Ориентировочно хватит',
              content: '$stockCoverageDays ${_pluralizeDay(stockCoverageDays)}',
              icon: Icons.access_time_outlined,
            ),

            // Карточка с приоритетом
            _buildInfoCard(
              context,
              title: 'Приоритет',
              content: priority,
              icon: Icons.priority_high_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // Виджет для каждой карточки
  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required String content,
      required IconData icon}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(content, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

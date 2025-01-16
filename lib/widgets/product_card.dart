import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/skeleton.dart';
import '../models/product_purchase_priority.dart';

class ProductCard extends StatefulWidget {
  final ProductPurchasePriority? productPriority;
  final bool isLoading;

  const ProductCard({
    Key? key,
    required this.productPriority,
    this.isLoading = false, // Значение по умолчанию
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
  }

  Color _getPriorityColor(String priority, bool isDarkMode) {
    switch (priority.toLowerCase()) {
      case 'high':
        return isDarkMode ? AppColors.dangerForDark : AppColors.danger;
      case 'medium':
        return isDarkMode ? AppColors.orangeForDark : AppColors.orange;
      case 'low':
        return isDarkMode ? AppColors.secondaryForDark : AppColors.secondary;
      default:
        return isDarkMode
            ? AppColors.disableElementForDark
            : AppColors.disableElement;
    }
  }

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
    if (widget.isLoading || widget.productPriority == null) {
      // Показываем SkeletonLoader
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonLoader(width: double.infinity, height: 20),
              SizedBox(height: 8),
              SkeletonLoader(width: 150, height: 16),
              SizedBox(height: 8),
              SkeletonLoader(width: 200, height: 16),
              SizedBox(height: 8),
              SkeletonLoader(width: double.infinity, height: 16),
            ],
          ),
        ),
      );
    }
    // Если данные загружены, показываем ProductCard
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.productPriority!.product.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                        widget.productPriority!.priorityLevel,
                        Theme.of(context).brightness == Brightness.dark),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      widget.productPriority!.priorityLevel.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
            Divider(
              color: AppColors.backgroundLight,
              height: 10,
              endIndent: 5,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Склад: ',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: widget.productPriority!.warehouse.name,
                    style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
            const SizedBox(height: 4),
            Text(
              'Продажи:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'за 7 дней: ${widget.productPriority!.totalSalesLast7Days} шт. | за 30 дней: ${widget.productPriority!.totalSalesLast30Days} шт.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Остаток: ',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: '${widget.productPriority!.currentStock} шт.',
                    style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Закончится через: ~',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text:
                        '${widget.productPriority!.stockCoverageDays} ${_pluralizeDay(widget.productPriority!.stockCoverageDays)}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

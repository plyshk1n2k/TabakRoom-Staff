import 'package:flutter/material.dart';
import 'package:tabakroom_staff/screens/product_details_screen.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/skeleton.dart';
import '../models/product_purchase_priority.dart';

class ProductCard extends StatefulWidget {
  final ProductPurchasePriority? productPriority;
  final bool isLoading;

  const ProductCard({
    super.key,
    required this.productPriority,
    this.isLoading = false, // Значение по умолчанию
  });

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
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.secondary;
      default:
        return isDarkMode
            ? AppColors.defaultElementForDark
            : AppColors.defaultElement;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || widget.productPriority == null) {
      // Показываем SkeletonLoader
      return Card(
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
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                  productId: widget.productPriority!.product.id,
                  productName: widget.productPriority!.product.name,
                  warehouseId: widget.productPriority!.warehouse.id,
                  warehouse: widget.productPriority!.warehouse.name,
                  salesLast7Days: widget.productPriority!.totalSalesLast7Days,
                  salesLast30Days: widget.productPriority!.totalSalesLast30Days,
                  salesLast180Days:
                      widget.productPriority!.totalSalesLast180Days,
                  currentStock: widget.productPriority!.currentStock,
                  stockCoverageDays: widget.productPriority!.stockCoverageDays,
                  priority: widget.productPriority!.priorityLevel))),
      child: Card(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(
                            widget.productPriority!.priorityLevel,
                            Theme.of(context).brightness == Brightness.dark),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.productPriority!.priorityLevel.toUpperCase(),
                        style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

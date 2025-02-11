import 'package:flutter/material.dart';
import 'package:tabakroom_staff/screens/product_details_screen.dart';
import 'package:tabakroom_staff/themes/color_utils.dart';
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
    return Card(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                      dataScreen: widget.productPriority!))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.productPriority!.product.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: ColorUtils.getPriorityColor(
                              widget.productPriority!.priorityLevel,
                              Theme.of(context).brightness == Brightness.dark),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: Text(
                          widget.productPriority!.priorityLevel.toUpperCase(),
                          style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

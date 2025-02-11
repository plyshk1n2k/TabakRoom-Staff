import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/order_recommendation.dart';
import 'package:tabakroom_staff/services/order_recommendation_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/price_comparasion_card.dart';

class OrderRecommendationScreen extends StatefulWidget {
  final List<int> selectedProductIds;

  const OrderRecommendationScreen({Key? key, required this.selectedProductIds})
      : super(key: key);

  @override
  State<OrderRecommendationScreen> createState() =>
      _OrderRecommendationScreenState();
}

class _OrderRecommendationScreenState extends State<OrderRecommendationScreen> {
  String _selectedStrategy = "best_price";
  List<OrderRecommendation> recommendedProducts = [];
  bool _isLoading = false;

  final Map<String, String> strategyNames = {
    "best_price": "📉 Выгода",
    "best_supplier": "📦 Поставщик",
    "balanced": "⚖ Баланс",
  };

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  void _fetchRecommendations() async {
    setState(() {
      _isLoading = true;
    });

    final response = await OrderRecommendationService.fetchRecommendations(
      selectedProducts: widget.selectedProductIds,
      strategy: _selectedStrategy,
    );

    setState(() {
      if (response.isSuccess) {
        recommendedProducts = response.data!;
      } else {
        recommendedProducts = [];
      }
      _isLoading = false;
    });
  }

  /// Группировка товаров по поставщикам
  Map<String, List<OrderRecommendation>> _groupBySupplier() {
    Map<String, List<OrderRecommendation>> groupedData = {};
    for (var product in recommendedProducts) {
      if (!groupedData.containsKey(product.strategyPrice.supplier.name)) {
        groupedData[product.strategyPrice.supplier.name] = [];
      }
      groupedData[product.strategyPrice.supplier.name]!.add(product);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _groupBySupplier();

    return Scaffold(
      appBar: AppBar(title: const Text("Рекомендации к заказу")),
      body: Column(
        children: [
          // 📌 Сегментированный выбор стратегии
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: strategyNames.entries.map((entry) {
                return ButtonSegment<String>(
                  value: entry.key,
                  label: Text(entry.value),
                );
              }).toList(),
              selected: <String>{_selectedStrategy},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedStrategy = newSelection.first;
                  _fetchRecommendations();
                });
              },
            ),
          ),

          // 📌 Группированный список товаров
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    backgroundColor: AppColors.defaultElement,
                    color: AppColors.primary,
                  ))
                : ListView(
                    padding: EdgeInsets.all(8),
                    children: groupedData.entries.map((entry) {
                      final supplier = entry.key;
                      final products = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Заголовок поставщика
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              supplier,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Список товаров этого поставщика
                          ...products.map((product) {
                            return Card(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.strategyPrice.product.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      PriceComparisonCard(
                                        currentPrice:
                                            product.strategyPrice.price,
                                        initialPrice: product.top1Price.price,
                                        customColor:
                                            product.strategyPrice.price >
                                                    product.top1Price.price
                                                ? AppColors.danger
                                                : AppColors.secondary,
                                      )
                                    ],
                                  )),
                            );
                          }).toList(),

                          SizedBox(height: 15), // Отступ между поставщиками
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

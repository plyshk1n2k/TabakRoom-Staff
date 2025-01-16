import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/product_card.dart'; // Убедись, что MenuCard импортирован

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  List<ProductPurchasePriority> data = []; // ✅ Инициализируем пустым списком
  bool dataIsLoaded = false;
  bool get _isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    loadData(); // ✅ Загружаем данные при старте
  }

  void loadData() async {
    final ApiResponse<List<ProductPurchasePriority>> response =
        await PurchasePriorityService.fetchPriorities();

    setState(() {
      if (response.isSuccess && response.data != null) {
        data = response.data!;
        dataIsLoaded = true;
      } else {
        data = [];
        dataIsLoaded = true;
      }
    });
  }

  void showFilters() async {
    CustomBottomSheet.show(
      context: context,
      content: Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Фильтрация',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Приоритет',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TabakRoom'),
          actions: [
            IconButton(
                onPressed: () => showFilters(),
                icon: Icon(
                  Icons.tune,
                  color: Theme.of(context).iconTheme.color,
                ))
          ],
        ),
        body: dataIsLoaded
            ? ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ProductCard(productPriority: item, isLoading: false);
                },
              )
            : ListView.builder(
                itemCount: 5, // Скелетонов будет 5
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return const ProductCard(
                      productPriority: null, isLoading: true);
                },
              ));
  }
}

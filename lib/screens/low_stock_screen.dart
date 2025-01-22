import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/custom_elevated_button.dart';
import 'package:tabakroom_staff/widgets/filter_chips.dart';
import 'package:tabakroom_staff/widgets/product_card.dart'; // Убедись, что MenuCard импортирован

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  List<ProductPurchasePriority> data = []; // ✅ Инициализируем пустым списком
  List<String> filterPriorities = [];
  List<Warehouse> filterWarehouses = [];
  List<ProductCategories> filterProductCategories = [];
  late FilterOptions filterParams;
  bool dataIsLoaded = false;
  bool get _isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    filterParams = await FilterOptions.loadFromPreferences();
    setState(() {
      dataIsLoaded = false;
    });

    final ApiResponse<List<String>> responsePriorities =
        await PurchasePriorityService.fetchPriorities();
    setState(() {
      if (responsePriorities.isSuccess && responsePriorities.data != null) {
        filterPriorities = responsePriorities.data!;
      }
    });

    final ApiResponse<List<Warehouse>> responseWarehouses =
        await PurchasePriorityService.fetchWarehouses();

    setState(() {
      if (responseWarehouses.isSuccess && responsePriorities.data != null) {
        filterWarehouses = responseWarehouses.data!;
      }
    });

    final ApiResponse<List<ProductCategories>> responseProductCategories =
        await PurchasePriorityService.fetchProductCategories();

    setState(() {
      if (responseProductCategories.isSuccess &&
          responseProductCategories.data != null) {
        filterProductCategories = responseProductCategories.data!;
      }
    });

    loadProducts();
  }

  void loadProducts() async {
    setState(() {
      dataIsLoaded = false;
    });
    final ApiResponse<List<ProductPurchasePriority>> response =
        await PurchasePriorityService.fetchPrioritiesProducts(
            filter: filterParams);

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
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Column(
            children: [
              SingleChildScrollView(
                // ✅ Добавляем скролл для всего контента
                child: Column(
                  mainAxisSize: MainAxisSize.min, // ✅ Ограничиваем размер
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Фильтрация',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Приоритет',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Divider(
                      height: 15,
                      color: Theme.of(context).dividerTheme.color,
                    ),
                    FilterChips(
                      options: filterPriorities,
                      selectedOption: filterParams.priorityLevel,
                      onSelected: (p0) {
                        setState(() {
                          filterParams.priorityLevel = p0;
                        });
                        loadProducts();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Склад',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Divider(
                      height: 15,
                      color: Theme.of(context).dividerTheme.color,
                    ),
                    FilterChips(
                      selectedOption: filterParams.warehouseId,
                      options: filterWarehouses
                          .map((item) => {'id': item.id, 'label': item.name})
                          .toList(),
                      onSelected: (item) {
                        setState(() {
                          filterParams.warehouseId = item;
                        });
                        loadProducts();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Группы',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Divider(
                      height: 15,
                      color: Theme.of(context).dividerTheme.color,
                    ),
                    FilterChips(
                      selectedOption: filterParams.groupId,
                      options: filterProductCategories
                          .map((item) => {'id': item.id, 'label': item.name})
                          .toList(),
                      onSelected: (item) {
                        setState(() {
                          filterParams.groupId = item;
                        });
                        loadProducts();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              CustomElevatedButton(
                text: 'Сбросить параметры',
                backgroundColor: AppColors.danger,
                onPressed: filterParams.isEmpty
                    ? null
                    : () {
                        setState(() {
                          filterParams.reset(); // Сброс параметров
                        });
                        print(filterParams.priorityLevel);
                        loadProducts(); // Обновляем данные
                      },
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Анализ остатков'),
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
            ? data.isEmpty
                ? Center(
                    child: Text('Данные отсутствуют'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return ProductCard(
                          productPriority: item, isLoading: false);
                    },
                  )
            : ListView.builder(
                itemCount: 8, // Скелетонов будет 5
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return const ProductCard(
                      productPriority: null, isLoading: true);
                },
              ));
  }
}

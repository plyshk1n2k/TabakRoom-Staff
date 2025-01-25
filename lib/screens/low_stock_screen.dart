import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/filters_builder.dart';
import 'package:tabakroom_staff/widgets/product_card.dart'; // Убедись, что MenuCard импортирован

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  List<ProductPurchasePriority> data = []; // ✅ Инициализируем пустым списком
  List<FilterValues<dynamic>> filterPriorities = [];
  List<FilterValues<dynamic>> filterWarehouses = [];
  List<FilterValues<dynamic>> filterProductCategories = [];
  late FilterOptions filterParams;
  bool dataIsLoaded = false;

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
        filterPriorities = responsePriorities.data!
            .map((element) => FilterValues(label: element, value: element))
            .toList();
      }
    });

    final ApiResponse<List<Warehouse>> responseWarehouses =
        await PurchasePriorityService.fetchWarehouses();

    setState(() {
      if (responseWarehouses.isSuccess && responsePriorities.data != null) {
        filterWarehouses = responseWarehouses.data!
            .map((element) =>
                FilterValues(label: element.name, value: element.id))
            .toList();
      }
    });

    final ApiResponse<List<ProductCategories>> responseProductCategories =
        await PurchasePriorityService.fetchProductCategories();

    setState(() {
      if (responseProductCategories.isSuccess &&
          responseProductCategories.data != null) {
        filterProductCategories = responseProductCategories.data!
            .map((element) =>
                FilterValues(label: element.name, value: element.id))
            .toList();
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
        content: FiltersBuilder(data: [
          FiltersData(
              label: 'Приоритет',
              filterValues: filterPriorities,
              currentValue: filterParams.priorityLevel,
              onValueChange: (newValue) {
                setState(() {
                  filterParams.priorityLevel = newValue;
                });
                loadProducts();
              }),
          FiltersData(
              label: 'Склад',
              filterValues: filterWarehouses,
              currentValue: filterParams.warehouseId,
              onValueChange: (newValue) {
                setState(() {
                  filterParams.warehouseId = newValue;
                });
                loadProducts();
              }),
          FiltersData(
              label: 'Группы товаров',
              filterValues: filterProductCategories,
              currentValue: filterParams.groupId,
              onValueChange: (newValue) {
                setState(() {
                  filterParams.groupId = newValue;
                });
                loadProducts();
              }),
        ]));
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

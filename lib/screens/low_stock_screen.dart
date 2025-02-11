import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/custom_snakbar.dart';
import 'package:tabakroom_staff/widgets/filters_builder.dart';
import 'package:tabakroom_staff/widgets/product_card.dart'; // Убедись, что MenuCard импортирован

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  List<ProductPurchasePriority> data = []; // ✅ Инициализируем пустым списком
  List<FilterValues> filterPriorities = [];
  List<FilterValues> filterWarehouses = [];
  List<FilterValues> filterProductCategories = [];
  late FilterOptions filterParams;
  bool dataIsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    filterParams = await FilterOptions.loadFromPreferences('low_stock_screen');
    setState(() {
      dataIsLoaded = false;
    });

    // ✅ Гарантируем правильный тип после загрузки
    filterParams.priorityLevel =
        List<String>.from(filterParams.priorityLevel ?? []);
    filterParams.warehouseId = List<int>.from(filterParams.warehouseId ?? []);
    filterParams.groupId = List<int>.from(filterParams.groupId ?? []);

    final ApiResponse<List<String>> responsePriorities =
        await PurchasePriorityService.fetchPriorities();
    setState(() {
      if (responsePriorities.isSuccess && responsePriorities.data != null) {
        filterPriorities = responsePriorities.data!
            .map((element) =>
                FilterValues(label: element, value: element)) // ❌ Без <String>
            .toList();
      }
    });

    final ApiResponse<List<Warehouse>> responseWarehouses =
        await PurchasePriorityService.fetchWarehouses();

    setState(() {
      if (responseWarehouses.isSuccess && responseWarehouses.data != null) {
        filterWarehouses = responseWarehouses.data!
            .map((element) => FilterValues(
                label: element.name, value: element.id)) // ❌ Без <int>
            .toList();
      }
    });

    final ApiResponse<List<ProductCategories>> responseProductCategories =
        await PurchasePriorityService.fetchProductCategories();

    setState(() {
      if (responseProductCategories.isSuccess &&
          responseProductCategories.data != null) {
        filterProductCategories = responseProductCategories.data!
            .map((element) => FilterValues(
                label: element.name, value: element.id)) // ❌ Без <int>
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
            filter: filterParams); // ✅ filterParams уже содержит `List<T>`

    setState(() {
      if (response.isSuccess && response.data != null) {
        data = response.data!;
        dataIsLoaded = true;
      } else {
        data = [];
        dataIsLoaded = true;
        CustomSnackbar.show(context,
            message: response.error ?? 'Ошибка получения данных',
            type: WidgetType.danger,
            position: SnackbarPosition.top);
      }
    });
  }

  void showFilters() async {
    CustomBottomSheet.show(
      context: context,
      content: FiltersBuilder(
        onApply: () async {
          loadProducts();
        },
        data: [
          FiltersData(
            label: 'Приоритет',
            filterValues: filterPriorities,
            currentValues: List<String>.from(
                filterParams.priorityLevel ?? []), // Явно String
            onValueChange: (newValues) {
              setState(() {
                filterParams.priorityLevel = List<String>.from(newValues);
              });
            },
            isMultiSelect: false,
          ),
          FiltersData(
            label: 'Склад',
            filterValues: filterWarehouses,
            currentValues:
                List<int>.from(filterParams.warehouseId ?? []), // Явно int
            onValueChange: (newValues) {
              setState(() {
                filterParams.warehouseId = List<int>.from(newValues);
              });
            },
            isMultiSelect: false,
          ),
          FiltersData(
            label: 'Группы товаров',
            filterValues: filterProductCategories,
            currentValues:
                List<int>.from(filterParams.groupId ?? []), // Явно String
            onValueChange: (newValues) {
              setState(() {
                filterParams.groupId = List<int>.from(newValues);
              });
            },
            isMultiSelect: false, // ✅ Разрешаем множественный выбор
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Анализ остатков'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => showFilters(),
                icon: Icon(
                  Icons.tune,
                  color: Theme.of(context).iconTheme.color,
                ))
          ],
        ),
        body: RefreshIndicator.adaptive(
            onRefresh: () async {
              loadProducts();
            },
            child: dataIsLoaded
                ? data.isEmpty
                    ? Center(
                        child: Text('Данные отсутствуют'),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return ProductCard(
                              productPriority: item, isLoading: false);
                        },
                      )
                : Center(
                    child: CircularProgressIndicator(
                    backgroundColor: AppColors.defaultElement,
                    color: AppColors.primary,
                  ))));
  }
}

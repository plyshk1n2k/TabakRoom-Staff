import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/custom_snakbar.dart';
import 'package:tabakroom_staff/widgets/filters_builder.dart';
import 'package:tabakroom_staff/widgets/multi_select_list.dart';
import 'package:tabakroom_staff/widgets/product_card.dart'; // Убедись, что MenuCard импортирован

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  MultiSelectController<ProductPurchasePriority> _multiSelectController =
      MultiSelectController<ProductPurchasePriority>();

  List<ProductPurchasePriority> data = []; // ✅ Инициализируем пустым списком
  List<ProductPurchasePriority> _selectedProducts = [];
  List<FilterValues> filterPriorities = []; // Просто FilterValues, без <T>
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
    filterParams =
        await FilterOptions.loadFromPreferences('create_order_screen');
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
    _multiSelectController = MultiSelectController<
        ProductPurchasePriority>(); // Пересоздаём контроллер
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
            isMultiSelect: true,
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
            isMultiSelect: true, // ✅ Разрешаем множественный выбор
          ),
        ],
      ),
    );
  }

  void _onSelectionChanged(List<ProductPurchasePriority> selected) {
    setState(() {
      _selectedProducts = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор товаров'),
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
                  : Column(
                      children: [
                        Expanded(
                          child: MultiSelectList<ProductPurchasePriority>(
                            controller: _multiSelectController,
                            items: data,
                            itemLabel: (item) => item.product.name,
                            onSelectionChanged: _onSelectionChanged,
                          ),
                        ),
                      ],
                    )
              : ListView.builder(
                  itemCount: 8, // Скелетонов будет 5
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return const ProductCard(
                        productPriority: null, isLoading: true);
                  },
                )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: AppColors.primary,
        overlayColor: Colors.black54, // Затемнение фона при открытии
        overlayOpacity: 0.3,
        spacing: 15, // Расстояние между кнопками
        spaceBetweenChildren: 5, // Отступ между кнопками
        buttonSize:
            const Size(50, 50), // Размер главной кнопки (по умолчанию 56x56)
        childrenButtonSize: const Size(46, 46), // Размер вложенных кнопок

        children: [
          SpeedDialChild(
            child: Icon(Icons.check, color: Colors.white),
            label: "Выбрать все",
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Закругленные углы
            ),
            onTap: () => _multiSelectController.selectAll(),
          ),
          SpeedDialChild(
            child: Icon(Icons.clear, color: Colors.white),
            label: "Отменить выбор",
            backgroundColor: AppColors.danger,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Закругленные углы
            ),
            onTap: () => _multiSelectController.deselectAll(),
          ),
        ],
      ),
    );
  }
}

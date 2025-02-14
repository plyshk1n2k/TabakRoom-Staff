import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_categories.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/models/warehouse.dart';
import 'package:tabakroom_staff/screens/order_recommendation_screen.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/themes/color_utils.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/custom_elevated_button.dart';
import 'package:tabakroom_staff/widgets/custom_snakbar.dart';
import 'package:tabakroom_staff/widgets/filters_builder.dart';
import 'package:tabakroom_staff/widgets/multi_select_list.dart';
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
            ),
          ),
          PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ), // Три точки
              onSelected: (value) {
                if (value == "selected_all") {
                  _multiSelectController.selectAll();
                } else if (value == "decline_select") {
                  _multiSelectController.deselectAll();
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "selected_all",
                      child: ListTile(
                        visualDensity: VisualDensity(
                            horizontal: -4, vertical: -4), // Уменьшаем отступы

                        leading: Icon(
                          Icons.check_box,
                          color: AppColors.secondary,
                        ),
                        title: Text(
                          'Выбрать все',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: "decline_select",
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Icon(
                          Icons.clear,
                          color: AppColors.danger,
                        ),
                        title: Text(
                          'Отменить выбор',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ])
        ],
      ),
      body: Stack(
        children: [
          // Основной контент
          RefreshIndicator.adaptive(
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
                                trailingWidget: (item) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.getPriorityColor(
                                          item.priorityLevel,
                                          Theme.of(context).brightness ==
                                              Brightness.dark),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                    child: Text(
                                      item.priorityLevel.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                                onSelectionChanged: _onSelectionChanged,
                              ),
                            ),
                            SizedBox(height: 70), // Отступ для кнопки
                          ],
                        )
                  : Center(
                      child: CircularProgressIndicator(
                      backgroundColor: AppColors.defaultElement,
                      color: AppColors.primary,
                    ))),

          // Кнопка подтверждения
          Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: CustomElevatedButton(
                  onPressed: _selectedProducts.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderRecommendationScreen(
                                selectedProductIds: _selectedProducts
                                    .map((elem) => elem.product.id)
                                    .toList(),
                              ),
                            ),
                          );
                        }
                      : null,
                  text: "Подтвердить (${_selectedProducts.length})",
                  buttonType: ButtonType.primary)),
        ],
      ),
    );
  }
}

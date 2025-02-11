import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/product_purchase_priority.dart';
import 'package:tabakroom_staff/models/top_supplier_price.dart';
import 'package:tabakroom_staff/services/purchase_priority_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/custom_snakbar.dart';
import 'package:tabakroom_staff/widgets/skeleton.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductPurchasePriority dataScreen;

  const ProductDetailsScreen({super.key, required this.dataScreen});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<TopSupplierPrice> supplierPrices = [];
  bool dataIsLoaded = false;
  double? minPrice; // 🔹 Минимальная цена

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      dataIsLoaded = false;
    });

    final ApiResponse<List<TopSupplierPrice>> response =
        await PurchasePriorityService.fetchTopPriceSupplier(
            widget.dataScreen.product.id,
            warehouseId: widget.dataScreen.warehouse.id);

    setState(() {
      if (response.isSuccess && response.data != null) {
        supplierPrices = response.data!;
        if (supplierPrices.isNotEmpty) {
          minPrice = supplierPrices
              .map((e) => e.price)
              .reduce((a, b) => a < b ? a : b);
        }
      } else {
        supplierPrices = [];
        CustomSnackbar.show(context,
            message: response.error ?? 'Ошибка получения цен от поставщиков',
            type: WidgetType.danger,
            position: SnackbarPosition.top);
      }
      dataIsLoaded = true;
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Название товара
              Text(
                widget.dataScreen.product.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Карточка с данными склада
              _buildInfoCard(
                context,
                title: 'Склад',
                content: widget.dataScreen.warehouse.name,
                icon: Icons.warehouse_outlined,
              ),

              // Карточка с данными по продажам
              _buildInfoCard(
                context,
                title: 'Продажи',
                content:
                    '7 дней: ${widget.dataScreen.totalSalesLast7Days}\n30 дней: ${widget.dataScreen.totalSalesLast30Days}\n180 дней: ${widget.dataScreen.totalSalesLast180Days}',
                icon: Icons.bar_chart_outlined,
              ),

              // Карточка с текущим остатком
              _buildInfoCard(
                context,
                title: 'Остаток',
                content: '${widget.dataScreen.currentStock} шт.',
                icon: Icons.inventory_2_outlined,
              ),

              // Карточка с расчётом ориентировочного времени
              _buildInfoCard(
                context,
                title: 'Ориентировочно хватит',
                content:
                    '${widget.dataScreen.stockCoverageDays} ${_pluralizeDay(widget.dataScreen.stockCoverageDays)}',
                icon: Icons.access_time_outlined,
              ),

              // Карточка с приоритетом
              _buildInfoCard(
                context,
                title: 'Приоритет',
                content: widget.dataScreen.priorityLevel,
                icon: Icons.priority_high_outlined,
              ),

              // Карточка поставщиков с ценами
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assessment_outlined,
                            color: Theme.of(context)
                                .iconTheme
                                .color, // ✅ Устанавливаем цвет
                            size: 35,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Цены от поставщиков',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ✅ Если данные загружаются — показываем скелетоны
                      if (!dataIsLoaded)
                        Column(
                          children:
                              List.generate(3, (index) => _buildSkeletonTile()),
                        )
                      // ✅ Если данные загружены, но их нет — показываем текст "Нет данных"
                      else if (supplierPrices.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Нет данных о ценах',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      // ✅ Если данные есть — отображаем их
                      else
                        ...supplierPrices.map((priceData) {
                          return _buildSupplierTile(priceData.supplier.name,
                              priceData.price, priceData.priceForDate);
                        }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Виджет для каждой карточки
  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required String content,
      required IconData icon}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(content, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Используем твой SkeletonLoader для списка
  Widget _buildSkeletonTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SkeletonLoader(
              width: 30,
              height: 30,
              borderRadius: BorderRadius.circular(15)), // Кружок для иконки
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(
                    width: double.infinity,
                    height: 16), // Линия для имени поставщика
                const SizedBox(height: 6),
                SkeletonLoader(width: 100, height: 14), // Линия для цены
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Обычный элемент списка поставщиков
  Widget _buildSupplierTile(
      String supplierName, double price, DateTime priceForDate) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      title: Text(
        supplierName,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: Text(
        'Стоимость на дату: ${DateFormat('dd.MM.yyyy').format(priceForDate)}\nЦена: $price руб.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

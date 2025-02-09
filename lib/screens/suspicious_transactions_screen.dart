import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/models/detect_suspicious_bonus.dart';
import 'package:tabakroom_staff/screens/incident_detail_screen.dart';
import 'package:tabakroom_staff/services/suspicious_transactions_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/bottom_sheet.dart';
import 'package:tabakroom_staff/widgets/custom_snakbar.dart';
import 'package:tabakroom_staff/widgets/filters_builder.dart';
import 'package:tabakroom_staff/widgets/skeleton.dart';

class SuspiciousTransactionsScreen extends StatefulWidget {
  const SuspiciousTransactionsScreen({super.key});

  @override
  State<SuspiciousTransactionsScreen> createState() =>
      _SuspiciousTransactionsScreenState();
}

class _SuspiciousTransactionsScreenState
    extends State<SuspiciousTransactionsScreen> {
  List<DetectSuspiciousBonus> data = []; // ✅ Инициализируем пустым списком
  bool dataIsLoaded = false;
  late FilterOptions filterParams;

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

    final ApiResponse<List<DetectSuspiciousBonus>> response =
        await SuspiciousTransactionsService.fetchSuspiciousTransactions(
            filter: filterParams);

    setState(() {
      if (response.isSuccess && response.data != null) {
        data = response.data!;
      } else {
        data = [];
        CustomSnackbar.show(context,
            message: response.error ?? 'Ошибка получения данных',
            type: WidgetType.danger,
            position: SnackbarPosition.top);
      }
      dataIsLoaded = true;
    });
  }

  void showFilters() {
    CustomBottomSheet.show(
      context: context,
      content: FiltersBuilder(
        onApply: () async {
          loadData();
        },
        data: [
          FiltersData(
            label: 'Статус проверки',
            filterValues: [
              FilterValues(label: 'Не проверенные', value: false),
              FilterValues(label: 'Проверенные', value: true),
            ],
            currentValues: filterParams.isResolved != null
                ? [filterParams.isResolved!] // ✅ Преобразуем в список
                : [],
            onValueChange: (newValues) {
              setState(() {
                filterParams.isResolved =
                    newValues.isNotEmpty ? newValues.first : null;
              });
            },
            isMultiSelect: false, // ✅ Одиночный выбор
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Анализ транзакций'),
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
              loadData();
            },
            child: dataIsLoaded
                ? data.isEmpty
                    ? Center(
                        child: Text('Данные отсутствуют'),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        padding: const EdgeInsets.all(16.0),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return Opacity(
                            opacity: item.isResolved ? 0.5 : 1,
                            child: Card(
                              child: ListTile(
                                  leading: !item.isResolved
                                      ? Icon(
                                          Icons.warning_amber_outlined,
                                          color: AppColors.warning,
                                          size: 30,
                                        )
                                      : Icon(
                                          Icons.check_circle_outline,
                                          size: 30,
                                          color: AppColors.secondary,
                                        ),
                                  title: Text(
                                    'Клиент - ${item.user.name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  subtitle: Text(
                                    'Количество транзакций: ${item.transactions.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  onTap: () async {
                                    final shouldReload = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IncidentDetailsPage(
                                                  userName: item.user.name,
                                                  detectedAt: item.detectedAt,
                                                  isResolved: item.isResolved,
                                                  transactions:
                                                      item.transactions,
                                                  incidentId: item.id,
                                                )));
                                    if (shouldReload == true) {
                                      loadData(); // Метод для перезагрузки данных
                                    }
                                  }),
                            ),
                          );
                        },
                      )
                : ListView.builder(
                    itemCount: 8, // Скелетонов будет 5
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      return Card(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SkeletonLoader(
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Flexible(
                                child: Column(
                              children: [
                                SkeletonLoader(),
                                SizedBox(
                                  height: 10,
                                ),
                                SkeletonLoader()
                              ],
                            ))
                          ],
                        ),
                      ));
                    },
                  )));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabakroom_staff/models/bonus_transactions.dart';
import 'package:tabakroom_staff/services/suspicious_transactions_service.dart'; // Импорт вашего ApiService

class IncidentDetailsPage extends StatelessWidget {
  final String userName;
  final DateTime detectedAt;
  final bool isResolved;
  final String? reviewedBy;
  final List<BonusTransaction> transactions;
  final int incidentId; // Добавлено поле для идентификатора инцидента

  const IncidentDetailsPage({
    super.key,
    required this.userName,
    required this.detectedAt,
    required this.isResolved,
    this.reviewedBy,
    required this.transactions,
    required this.incidentId, // Обязательное поле
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали инцидента'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация об инциденте
            _buildIncidentInfo(context),
            const SizedBox(height: 16),
            // Список транзакций
            const Text(
              'Подозрительные транзакции:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 10,
              color: Theme.of(context).dividerTheme.color,
            ),
            _buildTransactionsList(),
          ],
        ),
      ),
      floatingActionButton: isResolved
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  onMarkIncidentReviewed(context, incidentId), // Вызов метода
              tooltip: 'Отметить как проверенный',
              child: const Icon(
                Icons.check,
              ),
            ),
    );
  }

  Widget _buildIncidentInfo(BuildContext context) {
    return Card(
        child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Клиент: ',
                  style: Theme.of(context).textTheme.headlineMedium),
              TextSpan(
                  text: userName, style: Theme.of(context).textTheme.bodyMedium)
            ])),
            const SizedBox(height: 8),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Дата обнаружения: ',
                  style: Theme.of(context).textTheme.headlineMedium),
              TextSpan(
                  text: DateFormat('dd.MM.yyyy HH:mm')
                      .format(detectedAt.toLocal()),
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
            const SizedBox(height: 8),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Статус: ',
                  style: Theme.of(context).textTheme.headlineMedium),
              TextSpan(
                  text: isResolved ? "Проверено" : "Не проверено",
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
            const SizedBox(height: 8),
            if (isResolved && reviewedBy != null)
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Проверил: ',
                    style: Theme.of(context).textTheme.headlineMedium),
                TextSpan(
                    text: reviewedBy,
                    style: Theme.of(context).textTheme.bodyMedium)
              ])),
          ],
        ),
      ),
    ));
  }

  Widget _buildTransactionsList() {
    if (transactions.isEmpty) {
      return const Center(
        child: Text('Нет подозрительных транзакций'),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Транзакция №${transaction.id}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Сумма: ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextSpan(
                      text: '${transaction.bonusValue}₽\n',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: 'Дата: ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextSpan(
                      text: DateFormat('dd.MM.yyyy HH:mm')
                          .format(transaction.executionDate.toLocal()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Метод для отметки инцидента как проверенного
  Future<void> onMarkIncidentReviewed(
      BuildContext context, int incidentId) async {
    final result = await SuspiciousTransactionsService.markIncidentReviewed(
        incidentId: incidentId);

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Инцидент успешно отмечен как проверенный')),
      );
      Navigator.of(context)
          .pop(true); // Возвращаемся назад после успешной проверки
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Произошла ошибка')),
      );
    }
  }
}

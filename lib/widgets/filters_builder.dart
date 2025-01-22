import 'package:flutter/material.dart';
import 'package:tabakroom_staff/widgets/filter_chips.dart';

class FiltersBuilder extends StatefulWidget {
  final List<FiltersData> data;

  const FiltersBuilder({super.key, required this.data});

  @override
  _FilterBuilderState createState() => _FilterBuilderState();
}

class _FilterBuilderState extends State<FiltersBuilder> {
  /// Метод для сброса всех фильтров
  void _resetFilters() {
    setState(() {
      for (var filter in widget.data) {
        // Устанавливаем значение фильтра в null (или любое значение по умолчанию)
        filter.updateValue(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Фильтрация',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: List.generate(
                widget.data.length,
                (index) {
                  final elem = widget.data[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        elem.label,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Divider(
                        height: 15,
                        color: Theme.of(context).dividerTheme.color,
                        thickness: 2,
                        endIndent: 5,
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: elem.filterValues.map((option) {
                          final String optionLabel = option.label;
                          final dynamic optionValue = option.value;

                          return ChoiceChip(
                            label: Text(
                              optionLabel,
                              style: TextStyle(
                                color: elem.currentValue == optionValue
                                    ? Colors.white
                                    : isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: elem.currentValue == optionValue,
                            onSelected: (bool selected) {
                              setState(() {
                                if (elem.currentValue == optionValue) {
                                  elem.updateValue(null); // Снимаем выбор
                                } else {
                                  elem.updateValue(
                                      optionValue); // Устанавливаем новое значение
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      if (index <
                          widget.data.length -
                              1) // Проверка: если не последний элемент
                        SizedBox(height: 20), // Отступ между элементами
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: _resetFilters,
              child: Text(
                'Сбросить параметры',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ));
  }
}

class FiltersData<T> {
  final String label;
  final List<FilterValues> filterValues;
  T? currentValue; // Убрали final, чтобы значение могло изменяться
  final ValueChanged<T?> onValueChange;

  FiltersData({
    required this.label,
    required this.filterValues,
    required this.currentValue,
    required this.onValueChange,
  });

  /// Метод для обновления значения
  void updateValue(T? newValue) {
    currentValue = newValue; // Обновляем значение
    onValueChange(newValue); // Уведомляем о изменении
  }
}

class FilterValues<T> {
  //Значение которое пользователь увидит в интерфейсе
  final String label;
  //Значение выбранного фильтра
  final T value;

  /// Создаёт объект данных фильтра.
  ///
  /// - [label]: Название фильтра, отображается в интерфейсе.
  /// - [value]: Значение выбранного фильтра
  FilterValues({required this.label, required this.value});
}

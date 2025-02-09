import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:tabakroom_staff/widgets/custom_elevated_button.dart';

class FiltersBuilder extends StatefulWidget {
  final List<FiltersData> data;
  final Future<void> Function()
      onApply; // Указываем, что это асинхронная функция

  const FiltersBuilder({super.key, required this.data, required this.onApply});

  @override
  _FilterBuilderState createState() => _FilterBuilderState();
}

class _FilterBuilderState extends State<FiltersBuilder> {
  bool hasChanges = false;
  late Map<String, dynamic> initialValues; // Храним начальные значения

  @override
  void initState() {
    super.initState();
    _saveInitialValues(); // Сохраняем начальные значения фильтров
    _checkForChanges(); // Проверяем изменения
  }

  /// Сохраняем начальные значения фильтров
  void _saveInitialValues() {
    initialValues = {
      for (var filter in widget.data)
        filter.label: List.from(filter.currentValues)
    };
  }

  /// Проверяем, изменились ли фильтры по сравнению с начальными значениями
  void _checkForChanges() {
    final newHasChanges = widget.data.any(
      (filter) => !const DeepCollectionEquality().equals(
        filter.currentValues,
        initialValues[filter.label] ?? [],
      ),
    );
    if (hasChanges != newHasChanges) {
      setState(() {
        hasChanges = newHasChanges;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      for (var filter in widget.data) {
        if (filter.isMultiSelect) {
          filter.updateValues([]);
        } else {
          filter.updateValue(null);
        }
      }
      _checkForChanges();
    });
  }

  void _handleApply() async {
    setState(() {
      for (var filter in widget.data) {
        filter.saveValues([...filter.currentValues]);
      }
    });

    await widget.onApply();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.data.isEmpty) {
      return Center(child: Text("Нет доступных фильтров"));
    }

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
                          final bool isSelected =
                              elem.currentValues.contains(optionValue);

                          return FilterChip(
                            label: Text(
                              optionLabel,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (elem.isMultiSelect) {
                                  // ✅ Множественный выбор
                                  if (isSelected) {
                                    elem.updateValues([...elem.currentValues]
                                      ..remove(optionValue));
                                  } else {
                                    elem.updateValues(
                                        [...elem.currentValues, optionValue]);
                                  }
                                } else {
                                  // ✅ Одиночный выбор
                                  elem.updateValue(
                                      selected ? optionValue : null);
                                }
                              });
                              _checkForChanges();
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
              height: 30,
            ),
            CustomElevatedButton(
                onPressed: hasChanges ? _handleApply : null,
                text: 'Применить параметры',
                buttonType: ButtonType.primary),
            SizedBox(
              height: 10,
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

class FiltersData {
  final String label;
  final List<FilterValues> filterValues;
  final bool isMultiSelect;
  List<dynamic> currentValues; // Динамические значения, но будем приводить к нужному типу
  final ValueChanged<List<dynamic>> onValueChange;

  FiltersData({
    required this.label,
    required this.filterValues,
    required this.currentValues,
    required this.onValueChange,
    this.isMultiSelect = false,
  });

  void updateValues(List<dynamic> newValues) {
    currentValues = List<dynamic>.from(newValues);
  }

  void updateValue(dynamic newValue) {
    currentValues = newValue != null ? [newValue] : [];
  }

  void saveValues(List<dynamic> newValues) {
    onValueChange(List<dynamic>.from(newValues));
  }
}

class FilterValues {
  final String label;
  final dynamic value; // Делаем `value` динамичным, чтобы он мог быть любым
  FilterValues({required this.label, required this.value});
}


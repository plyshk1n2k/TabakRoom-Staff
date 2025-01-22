import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  final List<dynamic> options; // ✅ Принимает как List<String>, так и List<Map>
  final Function(dynamic)
      onSelected; // ✅ Callback при выборе, возвращает значение
  final dynamic selectedOption; // ✅ Текущий выбранный элемент

  const FilterChips({
    super.key,
    required this.options,
    required this.onSelected,
    this.selectedOption,
  });

  @override
  _FilterChipsState createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  dynamic _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.options.map((option) {
        final String optionLabel = option is Map<String, dynamic>
            ? option['label']
            : option.toString();

        final dynamic optionValue =
            option is Map<String, dynamic> ? option['id'] : option;

        return ChoiceChip(
          label: Text(
            optionLabel,
            style: TextStyle(
              color: _currentSelection == optionValue
                  ? Colors.white
                  : isDarkMode
                      ? Colors.white70
                      : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: _currentSelection == optionValue,
          onSelected: (bool selected) {
            setState(() {
              if (_currentSelection == optionValue) {
                _currentSelection =
                    null; // Снять выбор, если элемент уже выбран
              } else {
                _currentSelection = optionValue; // Установить новый выбор
              }
            });
            widget.onSelected(_currentSelection);
          },
        );
      }).toList(),
    );
  }
}

// 📦 Пример использования:
// 1️⃣ Список объектов
// FilterChips(
//   options: [
//     {'id': 1, 'label': 'Склад 1'},
//     {'id': 2, 'label': 'Склад 2'},
//     {'id': 3, 'label': 'Склад 3'},
//   ],
//   onSelected: (value) {
//     print('Выбран фильтр с id: \$value');
//   },
// )

// 2️⃣ Список строк
// FilterChips(
//   options: ['Параметр 1', 'Параметр 2', 'Параметр 3'],
//   onSelected: (value) {
//     print('Выбран фильтр: \$value');
//   },
// )

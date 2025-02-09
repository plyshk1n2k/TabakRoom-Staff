import 'package:flutter/material.dart';

class MultiSelectController<T> extends ChangeNotifier {
  List<T> _selectedItems = [];
  late List<T> _allItems; // Полный список элементов

  void setItems(List<T> items) {
    _allItems = items;
    notifyListeners();
  }

  void selectAll() {
    _selectedItems = List.from(_allItems);
    notifyListeners();
  }

  void deselectAll() {
    _selectedItems.clear();
    notifyListeners();
  }

  List<T> get selectedItems => _selectedItems;
}

class MultiSelectList<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(List<T>) onSelectionChanged;
  final MultiSelectController<T> controller; // Контроллер

  const MultiSelectList({
    Key? key,
    required this.items,
    required this.itemLabel,
    required this.onSelectionChanged,
    required this.controller,
  }) : super(key: key);

  @override
  _MultiSelectListState<T> createState() => _MultiSelectListState<T>();
}

class _MultiSelectListState<T> extends State<MultiSelectList<T>> {
  List<T> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    widget.controller.setItems(widget.items);

    widget.controller.addListener(() {
      setState(() {
        _selectedItems = widget.controller.selectedItems;
      });
      widget.onSelectionChanged(_selectedItems);
    });
  }

  void _toggleSelection(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      widget.onSelectionChanged(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = _selectedItems.contains(item);

        return Card(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _toggleSelection(item),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) => _toggleSelection(item),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text(
                        widget.itemLabel(item),
                        style: Theme.of(context).textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

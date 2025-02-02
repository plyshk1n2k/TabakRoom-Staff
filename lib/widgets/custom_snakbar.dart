import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

enum SnackbarPosition { top, bottom }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required WidgetType type,
    SnackbarPosition position = SnackbarPosition.bottom,
    Duration duration = const Duration(seconds: 6),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _SnackbarContent(
          message: message,
          type: type,
          position: position,
          onClose: () {
            if (overlayEntry.mounted) {
              overlayEntry.remove(); // Удаляем Snackbar из Overlay
            }
          },
        );
      },
    );

    overlay.insert(overlayEntry);

    // Автоматическое закрытие через `duration`
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _SnackbarContent extends StatefulWidget {
  final String message;
  final WidgetType type;
  final SnackbarPosition position;
  final VoidCallback onClose;

  const _SnackbarContent({
    super.key,
    required this.message,
    required this.type,
    required this.position,
    required this.onClose,
  });

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragOffset = 0.0;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, widget.position == SnackbarPosition.top ? -1.5 : 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(); // Запуск анимации появления
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isClosing) return;

    // Если Snackbar сверху и движение идёт вниз — игнорируем
    if (widget.position == SnackbarPosition.top && details.primaryDelta! > 0) {
      return;
    }

    // Если Snackbar снизу и движение идёт вверх — игнорируем
    if (widget.position == SnackbarPosition.bottom &&
        details.primaryDelta! < 0) {
      return;
    }
    setState(() {
      _dragOffset += details.primaryDelta!;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    double screenHeight = MediaQuery.of(context).size.height;
    double closeThreshold = widget.position == SnackbarPosition.top
        ? screenHeight * 0.1
        : screenHeight * 0.05; // 10% или 5% экрана

    if (_dragOffset.abs() > closeThreshold) {
      _closeSnackbar();
    } else {
      setState(() {
        _dragOffset = 0; // Возвращаем Snackbar обратно
      });
    }
  }

  void _closeSnackbar() {
    if (_isClosing) return;
    _isClosing = true;

    _controller.reverse().then((_) {
      widget.onClose(); // Удаляем Snackbar из Overlay
    });
  }

  Color getBgColor(WidgetType widgetType) {
    switch (widgetType) {
      case WidgetType.primary:
        return AppColors.primary;
      case WidgetType.warning:
        return AppColors.warning;
      case WidgetType.danger:
        return AppColors.danger;
      case WidgetType.success:
        return AppColors.secondary;
    }
  }

  IconData getIcon(WidgetType widgetType) {
    switch (widgetType) {
      case WidgetType.primary:
        return Icons.info_outline;
      case WidgetType.warning:
        return Icons.warning_amber;
      case WidgetType.danger:
        return Icons.dangerous_outlined;
      case WidgetType.success:
        return Icons.check_circle_outline_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top; // Высота выреза
    double? topPosition =
        widget.position == SnackbarPosition.top ? topPadding + 20 : null;
    double? bottomPosition =
        widget.position == SnackbarPosition.bottom ? 40 - _dragOffset : null;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      top: topPosition != null ? topPosition + _dragOffset : null,
      bottom: bottomPosition,
      left: 20,
      right: 20,
      child: GestureDetector(
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        child: SlideTransition(
          position: _animation,
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            color: getBgColor(widget.type), // Цвет Snackbar
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    getIcon(widget.type),
                    color: Colors.white,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required WidgetType type,
    Duration duration = const Duration(seconds: 6),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: _SnackbarContent(
            message: message,
            type: type,
            onClose: () {
              overlayEntry.remove(); // Удаляем OverlayEntry
            },
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    // Удаляем Snackbar после задержки, если пользователь не свайпнул
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
  final VoidCallback onClose;

  const _SnackbarContent({
    super.key,
    required this.message,
    required this.type,
    required this.onClose,
  });

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Начальное положение (вне экрана снизу)
      end: Offset.zero, // Конечное положение (видимое)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Запускаем анимацию появления
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void closeSnackbar() {
    _controller.reverse().then((value) {
      widget.onClose(); // Удаление Snackbar из Overlay
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          closeSnackbar(); // Закрываем при свайпе вниз
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(12),
          color: getBgColor(widget.type), // Цвет Snackbar
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

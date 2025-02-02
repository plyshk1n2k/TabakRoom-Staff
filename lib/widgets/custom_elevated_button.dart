import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

enum ButtonType {
  primary, // Основная кнопка
  danger, // Опасная (красная)
  success, // Успешная (зелёная)
  warning, // Предупреждающая (жёлтая)
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final ButtonType buttonType;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.buttonType,
    this.isLoading = false,
  });

  Color getButtonColor() {
    switch (buttonType) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.danger:
        return AppColors.danger;
      case ButtonType.success:
        return AppColors.secondary;
      case ButtonType.warning:
        return AppColors.warning;
    }
  }

  Color getDisableButtonColor() {
    switch (buttonType) {
      case ButtonType.primary:
        return AppColors.lightPrimary;
      case ButtonType.danger:
        return AppColors.lightDanger;
      case ButtonType.success:
        return AppColors.lightSecondary;
      case ButtonType.warning:
        return AppColors.lightWarning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: getDisableButtonColor(),
        backgroundColor: getButtonColor(), // Цвет кнопки
        elevation: 4.0, // Тень кнопки
        padding: EdgeInsets.all(14), // Внутренний отступ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Скругление углов
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          : Text(
              text,
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
    );
  }
}

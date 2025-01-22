import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final double elevation;
  final bool isLoading;
  final String text;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor = AppColors.primary, // Цвет фона по умолчанию
    this.disabledBackgroundColor =
        AppColors.lightPrimary, // Цвет фона заблокированного элемента
    this.textColor = AppColors.textLight, // Цвет текста по умолчанию
    this.borderRadius = 8.0, // Радиус скругления
    this.padding = 16.0, // Отступ внутри кнопки
    this.elevation = 4.0, // Высота тени
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: disabledBackgroundColor,
        backgroundColor: backgroundColor, // Цвет кнопки
        elevation: elevation, // Тень кнопки
        padding: EdgeInsets.all(padding), // Внутренний отступ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Скругление углов
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
              style: TextStyle(color: AppColors.textLight),
            ),
    );
  }
}

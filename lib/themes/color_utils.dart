import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class ColorUtils {
  static Color getPriorityColor(String priority, bool isDarkMode) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.secondary;
      default:
        return isDarkMode
            ? AppColors.defaultElementForDark
            : AppColors.defaultElement;
    }
  }
}

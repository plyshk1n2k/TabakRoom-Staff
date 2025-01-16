import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required Widget content,
    bool isDismissible = true,
    bool enableDrag = true,
    double initialHeight = 0.7,
    double widthFactor = 1, // Коэффициент ширины окна
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Прозрачный фон
      builder: (context) {
        return Stack(
          children: [
            // Размытие и затемнение фона
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Размытие
              child: Container(
                color: AppColors.backgroundDarkTransparent, // Затемнение
              ),
            ),
            // Само окно
            Align(
              alignment:
                  Alignment.bottomCenter, // Выравнивание по нижнему центру
              child: FractionallySizedBox(
                widthFactor: widthFactor, // Ширина окна (0.9 = 90% экрана)
                child: DraggableScrollableSheet(
                  initialChildSize: initialHeight,
                  minChildSize: 0.25,
                  maxChildSize: 0.85,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.outlineBorderNonActiveForDark,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                child: content,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

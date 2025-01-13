import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF008FFF);
  static const Color primaryForDark = Color(0xFF45ADFF);
  static const Color primaryTransparent = Color.fromARGB(133, 68, 137, 255);

  static const Color secondary = Color(0xFF309054);
  static const Color secondaryForDark = Color(0xFF44CC77);

  static const Color danger = Color(0xFFB00020);
  static const Color dangerForDark = Color(0xFFCF6679);

  static const Color orange = Color(0xFFFF5436);
  static const Color orangeForDark = Color(0xFFFF8975);

  static const Color backgroundLight = Color(0xFFF5F8FF);
  static const Color backgroundLightTransparent = Colors.white10;

  static const Color backgroundDark = Color(0xFF14212A);
  static const Color backgroundDark2 = Color(0xFF2C3F50);
  static const Color backgroundDarkTransparent = Colors.black12;

  static const Color textLight = Color(0xFFEBF1F1);
  static const Color textDark = Color(0xFF2C3F50);
  static const Color textGrey = Colors.grey;

  static const Color outlineBorderNonActive = Color(0xFFBEC3C6);
  static const Color outlineBorderNonActiveForDark = Color(0xFFEBF1F1);
  static const Color outlineBorderActive = primary;
  static const Color outlineBorderActiveForDark = primaryForDark;

  static const Color disableElement = Color(0xFF6F6F6F);
  static const Color disableElementForDark = Color(0xFF7C7C7C);
}

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
          backgroundColor:
              AppColors.backgroundLight, // Цвет фона для всех AppBar
          titleTextStyle: TextStyle(
              color: AppColors.textDark, // Цвет текста для всех AppBar
              fontSize: 20,
              fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(
            color: AppColors.backgroundDark, // Цвет иконок для всех AppBar
          ),
          elevation: 0, // Высота тени для всех AppBar
          scrolledUnderElevation: 0),
      cardTheme: CardTheme(
        color: const Color(0xFF2C3F50),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.backgroundLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.backgroundLight,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: AppColors.disableElement),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.backgroundLight,
        selectionColor: AppColors.primary,
        selectionHandleColor: AppColors.backgroundLight,
      ),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: AppColors.textLight, fontSize: 16)),
      iconTheme: const IconThemeData(
        color: AppColors.backgroundDark,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        // Для стилизации фона и других свойств используйте menuStyle
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors
              .backgroundDarkTransparent), // Цвет фона выпадающего списка
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Скругленные углы
          )),
        ),
        textStyle: const TextStyle(
            color: AppColors.textLight, // Цвет текста в списке
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.outlineBorderActive,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.outlineBorderNonActive,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textLight,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textGrey,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.outlineBorderActive,
            width: 4.0,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.backgroundDark,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        showUnselectedLabels: true,
      ),
      dividerColor: AppColors.backgroundLight,
      canvasColor: AppColors.primaryTransparent);

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
          backgroundColor:
              AppColors.backgroundDark, // Цвет фона для всех AppBar
          titleTextStyle: TextStyle(
              color: AppColors.textLight, // Цвет текста для всех AppBar
              fontSize: 20,
              fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(
            color: AppColors.backgroundLight, // Цвет иконок для всех AppBar
          ),
          elevation: 0, // Высота тени для всех AppBar
          scrolledUnderElevation: 0),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: AppColors.textLight, fontSize: 16)),
      iconTheme: const IconThemeData(
        color: AppColors.backgroundLight,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        // Для стилизации фона и других свойств используйте menuStyle
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors
              .backgroundDarkTransparent), // Цвет фона выпадающего списка
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Скругленные углы
          )),
        ),
        textStyle: const TextStyle(
            color: AppColors.textLight, // Цвет текста в списке
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF34495E),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryForDark,
        foregroundColor: AppColors.backgroundLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryForDark,
            foregroundColor: AppColors.backgroundLight,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: AppColors.disableElementForDark),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.backgroundLight,
        selectionColor: AppColors.primaryForDark,
        selectionHandleColor: AppColors.backgroundLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.outlineBorderActiveForDark,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.outlineBorderNonActiveForDark,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textLight,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primaryForDark,
        unselectedLabelColor: AppColors.textGrey,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primaryForDark,
            width: 4.0,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primaryForDark,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        showUnselectedLabels: true,
      ),
      canvasColor: AppColors.backgroundLightTransparent);
}

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0A55EA);
  static const Color primaryForDark = Color(0xFF0A55EA);
  static const Color lightPrimary = Color(0xFF7DA6F5);
  static const Color primaryTransparent = Color.fromARGB(133, 68, 137, 255);
  static const Color skyBlue = Color(0xFFC8DBFC);

  static const Color secondary = Color(0xFF21C252);
  static const Color secondaryForDark = Color(0xFF21C252);

  static const Color danger = Color(0xFFED004E);
  static const Color dangerForDark = Color(0xFFED004E);

  static const Color warning = Color(0xFFF0941E);
  static const Color warningForDark = Color(0xFFF0941E);

  static const Color backgroundLight = Color(0xFFF5F8FF);
  static const Color backgroundLightTransparent = Colors.white10;

  static const Color backgroundDark = Colors.black;
  static const Color backgroundDark2 = Color(0xFF131315);
  static const Color backgroundDarkTransparent = Colors.black12;

  static const Color textLight = Color(0xFFEBF1F1);
  static const Color textDark = Color.fromARGB(255, 0, 0, 0);
  static const Color textGrey = Colors.grey;

  static const Color outlineBorderNonActive = Color(0xFFBEC3C6);
  static const Color outlineBorderNonActiveForDark = Color(0xFFEBF1F1);
  static const Color outlineBorderActive = lightPrimary;
  static const Color outlineBorderActiveForDark = lightPrimary;

  static const Color disableElement = Color(0xFF6F6F6F);
  static const Color disableElementForDark = Color(0xFF7C7C7C);

  static const Color defaultElement = Color(0xFFCACACF);
  static const Color defaultElementForDark = Color(0xFF303036);
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
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.defaultElement,
        checkmarkColor: AppColors.backgroundLight,
        selectedColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.backgroundLight,
        elevation: 5, // Высота тени
        shadowColor: AppColors.defaultElement,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Радиус скругления углов
          side: BorderSide(color: AppColors.defaultElement), // Лёгкая граница
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
            disabledBackgroundColor: AppColors.lightPrimary),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.backgroundDark,
        selectionColor: AppColors.lightPrimary,
        selectionHandleColor: AppColors.backgroundDark,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: AppColors.textDark, fontSize: 16),
        bodySmall: TextStyle(color: AppColors.textDark, fontSize: 14),
      ),
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
            color: AppColors.lightPrimary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.defaultElement,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textDark,
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
      dividerTheme: DividerThemeData(color: AppColors.backgroundLight),
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
        bodyMedium: TextStyle(color: AppColors.textLight, fontSize: 16),
        bodySmall: TextStyle(color: AppColors.textLight, fontSize: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.defaultElementForDark,
        checkmarkColor: AppColors.backgroundLight,
        selectedColor: AppColors.primaryForDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
        color: AppColors.backgroundDark2,
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
            disabledBackgroundColor: AppColors.lightPrimary),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.backgroundLight,
        selectionColor: AppColors.lightPrimary,
        selectionHandleColor: AppColors.backgroundLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.lightPrimary,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.defaultElement,
            width: 2.0,
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
          color: AppColors.textLight,
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
      dividerTheme: DividerThemeData(color: AppColors.backgroundLight),
      canvasColor: AppColors.backgroundLightTransparent);
}

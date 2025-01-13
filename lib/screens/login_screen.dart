import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // Переменная для показа/скрытия пароля
  bool get _isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // 👉 Флаг загрузки

  // Метод для имитации авторизации
  Future<void> _login() async {
    setState(() {
      _isLoading = true; // 👉 Включаем спиннер
    });

    await Future.delayed(const Duration(seconds: 2)); // ⏳ Имитация запроса

    setState(() {
      _isLoading = false; // ❌ Выключаем спиннер
    });

    // 🟢 Здесь логика обработки ответа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Успешная авторизация!",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor:
            _isDarkMode ? AppColors.secondaryForDark : AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔥 Логотип или изображение
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Image.asset(
                  'assets/images/splash_image.png',
                  height: 150,
                ),
              ),

              const SizedBox(height: 20),

              // 📋 Поле ввода логина
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  labelText: 'Логин',
                  prefixIcon: const Icon(Icons.person),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20), // Увеличивает высоту
                ),
              ),
              const SizedBox(height: 15),

              // 📋 Поле ввода пароля с кнопкой показа/скрытия
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Скрытие пароля
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: const Icon(Icons.lock),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20), // Увеличивает высоту
                  // 👁 Кнопка показа/скрытия пароля
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.backgroundLight,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🔘 Кнопка "Войти"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isDarkMode
                        ? AppColors.orangeForDark
                        : AppColors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null // Блокируем кнопку, если идёт загрузка
                      : _login, // Вызываем метод логина
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Войти',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

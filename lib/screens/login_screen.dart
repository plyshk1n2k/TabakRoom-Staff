import 'package:flutter/material.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/screens/home_screen.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/services/auth_service.dart';
import 'package:tabakroom_staff/widgets/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _formCompleted = false;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse<void> response = await AuthService.login(
      _loginController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      _showSnackBar("Успешный вход!", success: true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showSnackBar(response.error ?? "Ошибка авторизации", success: false);
    }
  }

  void _showSnackBar(String message, {required bool success}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: success
            ? (_isDarkMode ? AppColors.secondaryForDark : AppColors.secondary)
            : (_isDarkMode ? AppColors.dangerForDark : AppColors.danger),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/splash_image.png',
              height: 150,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Логин',
                prefixIcon: const Icon(Icons.person),
              ),
              onChanged: (value) => _updateFormState(),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Пароль',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              onChanged: (value) => _updateFormState(),
            ),
            const SizedBox(height: 30),
            SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: 'Войти',
                  onPressed: _isLoading || !_formCompleted ? null : _login,
                  isLoading: _isLoading,
                )),
          ],
        ),
      ),
    );
  }

  void _updateFormState() {
    setState(() {
      _formCompleted = _loginController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }
}

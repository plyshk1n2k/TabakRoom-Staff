import 'package:flutter/material.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  bool get _isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    // AuthService.logout();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    bool isLoggedIn = await AuthService.isLoggedIn();

    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          backgroundColor: AppColors.defaultElement,
          color: AppColors.primary,
        )),
      );
    }

    return _isLoggedIn ? HomeScreen() : LoginScreen();
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tabakroom_staff/main.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';
import 'package:tabakroom_staff/services/auth_service.dart';
import 'package:tabakroom_staff/themes/theme_data.dart';
import 'package:tabakroom_staff/widgets/custom_snakbar.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _auth = LocalAuthentication();
  List<String> _pin = [];
  String? _savedPin;
  bool _isConfirmingPin = false;
  List<String>? _firstEnteredPin;
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  bool blurScreen = false;
  bool _isPinLoaded = false; // 🔹 Переменная для контроля состояния PIN

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    // 🔹 Создаем анимацию размытия при запуске экрана
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 700), // Обязательно указываем время
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // 🔹 Откладываем запуск биометрии, чтобы сначала показался `PinScreen`
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadSavedPin();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 🔹 Загружаем сохранённый PIN-код
  Future<void> _loadSavedPin() async {
    final pin = await AppPreferences.getValue<String>('user_pin');
    setState(() {
      _savedPin = pin;
      _isPinLoaded = true; // 🔹 Теперь PIN загружен, можно менять UI
    });

    if (pin?.isNotEmpty == true) {
      bool authenticate =
          await _authenticateBiometric(); // 🔹 Запрашиваем Face ID, если PIN есть
      if (authenticate) {
        _unlockApp();
      }
    } else {
      _removeBlur(); // 🔹 Если PIN пустой или отсутствует, убираем размытие
    }
  }

  void _removeBlur() {
    if (mounted) {
      _animationController.forward().then((_) {});
    }
    setState(() {
      blurScreen = false;
    });
  }

  void _startBlur() {
    setState(() {
      blurScreen = true;
    });
    _animationController.reset(); // Сбрасываем анимацию, если она уже была
  }

  /// 🔹 Проверяем, можно ли использовать биометрию (есть ли датчики + разрешение)
  Future<bool> _canUseBiometric() async {
    bool canCheck = await _auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    bool isBiometricEnabled = canCheck && availableBiometrics.isNotEmpty;

    return isBiometricEnabled;
  }

  /// 🔹 Запускаем Face ID / Touch ID, если биометрия разрешена
  Future<bool> _authenticateBiometric() async {
    if (!await _canUseBiometric()) {
      _removeBlur();
      return false;
    }

    try {
      _startBlur();
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Используйте Face ID для входа',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      _removeBlur();

      return authenticated;
    } catch (e) {
      _removeBlur();

      return false;
    }
  }

  /// 🔹 Добавление цифры в PIN-код
  void _addDigit(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin.add(digit);
      });

      if (_pin.length == 6) {
        _verifyPin();
      }
    }
  }

  /// 🔹 Удаление последней цифры
  void _deleteDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  /// 🔹 Проверяем PIN-код
  Future<void> _verifyPin() async {
    final enteredPin = _pin.join();

    if (_savedPin == null) {
      if (!_isConfirmingPin) {
        // 🔹 Первый ввод нового PIN-кода
        setState(() {
          _firstEnteredPin = List.from(_pin);
          _pin.clear();
          _isConfirmingPin = true;
        });
      } else {
        // 🔹 Подтверждение PIN-кода
        if (_firstEnteredPin!.join() == enteredPin) {
          await AppPreferences.setValue<String>('user_pin', enteredPin);
          setState(() {
            _savedPin = enteredPin;
          });
          bool authenticated =
              await _authenticateBiometric(); // 🔹 Автоматически запрашиваем Face ID
          _unlockApp();
        } else {
          // 🔹 Ошибка: PIN-коды не совпадают
          setState(() {
            _pin.clear();
            _isConfirmingPin = false;
          });
          CustomSnackbar.show(context,
              message: 'PIN-коды не совпадают',
              type: WidgetType.warning,
              position: SnackbarPosition.top,
              duration: const Duration(seconds: 3));
        }
      }
    } else if (_savedPin == enteredPin) {
      _unlockApp();
    } else {
      // 🔹 Ошибка: неверный PIN-код
      setState(() {
        _pin.clear();
      });

      CustomSnackbar.show(context,
          message: 'Неверный PIN-код',
          type: WidgetType.danger,
          position: SnackbarPosition.top,
          duration: const Duration(seconds: 3));
    }
  }

  /// 🔹 Разблокировка приложения
  void _unlockApp() {
    AppLock.of(context)?.didUnlock(); // 🔹 Разблокируем приложение
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              !_isPinLoaded
                  ? "" // 🔹 Пока PIN загружается, ничего не показываем
                  : _isConfirmingPin
                      ? "Повторите код"
                      : _savedPin == null
                          ? "Придумайте код"
                          : "Введите код",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),

            // 🔹 PIN-индикаторы (6 точек)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < _pin.length
                          ? AppColors.primary
                          : _isDarkMode
                              ? AppColors.backgroundDark2
                              : AppColors.defaultElement,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 70),

            _buildTextButton(
              'Выйти',
              () async {
                AuthService.logout();
                navigatorKey.currentState?.pushReplacementNamed('/login');
                _unlockApp();
              },
            ),

            // 🔹 Цифровая клавиатура
            for (var row in [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['face', '0', 'delete']
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((key) {
                  if (key == 'delete') {
                    return _buildIconButton('delete');
                  } else if (key == 'face') {
                    return _buildIconButton('face');
                  } else {
                    return _buildNumberButton(key, _isDarkMode);
                  }
                }).toList(),
              ),
          ],
        ),
        blurScreen
            ? AnimatedBuilder(
                animation: _blurAnimation,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _blurAnimation.value,
                        sigmaY: _blurAnimation.value),
                    child: Opacity(
                      opacity:
                          _blurAnimation.value / 10, // 🔹 Плавное исчезновение
                      child: Container(
                        color: Colors.black
                            .withOpacity(0.2), // 🔹 Затемнение при размытии
                      ),
                    ),
                  );
                },
              )
            : SizedBox(),
      ],
    ));
  }

  /// 🔹 Кнопки с цифрами (1-9, 0)
  Widget _buildNumberButton(String number, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isDarkMode ? AppColors.backgroundDark2 : AppColors.defaultElement,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _addDigit(number),
          borderRadius: BorderRadius.circular(50),
          child: Center(
            child: Text(
              number,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Кнопка Face ID
  Widget _buildIconButton(String typeIcon) {
    bool isPinEmpty = _pin.isEmpty;

    switch (typeIcon) {
      case 'face':
        return InkWell(
          onTap: () async {
            bool authenticated = await _authenticateBiometric();
            if (authenticated) _unlockApp();
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Center(
                child: SvgPicture.asset(
              'assets/icons/${_isDarkMode ? 'custom_face_id_white.svg' : 'custom_face_id_black.svg'}',
              width: 55,
              height: 55,
            )),
          ),
        );
      case 'delete':
        return InkWell(
          onTap: () => isPinEmpty ? null : _deleteDigit(),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Center(
              child: Icon(
                Icons.backspace,
                size: 28,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        );
      default:
        return SizedBox();
    }
  }

  /// 🔹 Кнопка "Забыли код?"
  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 70,
        height: 20,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

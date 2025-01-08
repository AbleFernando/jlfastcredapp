import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';

class LoginController with MessageStateMixin {
  LoginController({required UserLoginService loginService})
      : _loginService = loginService;

  final UserLoginService _loginService;

  final _obscurePassword = signal(true);
  final _logged = signal(false);

  bool get logged => _logged();
  bool get obscurePassword => _obscurePassword();

  void passwordToggle() => _obscurePassword.value = !_obscurePassword.value;

  Future<void> login(String email, String password) async {
    final loginResult = await _loginService.execute(email, password);
    switch (loginResult) {
      // case Left(value: ServiceException(:final message)):
      case Left(value: ServiceException(:var message, :var isErro)):
        if (isErro) {
          showError(message);
        } else {
          showInfo(message);
        }
      // showError(message);
      case Right(value: final userCredential):
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageConstants.userUid, userCredential.user!.uid);
        sp.setString(
            LocalStorageConstants.userName, userCredential.user!.displayName!);
        _logged.value = true;
    }
  }
}

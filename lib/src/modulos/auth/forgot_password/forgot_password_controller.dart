import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ForgotPasswordController with MessageStateMixin {
  ForgotPasswordController({required UserLoginService loginService})
      : _loginService = loginService;

  final UserLoginService _loginService;
  final _resetDone = signal(false);

  bool get resetDone => _resetDone();

  Future<void> resetPassWord(String email) async {
    final loginResult = await _loginService.resetPassWord(email);
    switch (loginResult) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: _):
        showSuccess('E-mail enviado com sucesso');
        _resetDone.value = true;
    }
  }
}

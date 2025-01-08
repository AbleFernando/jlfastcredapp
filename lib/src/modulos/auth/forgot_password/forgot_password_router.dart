import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/auth/forgot_password/forgot_password_controller.dart';
import 'package:jlfastcred/src/modulos/auth/forgot_password/forgot_password_page.dart';

class ForgotPasswordRouter extends FlutterGetItModulePageRouter {
  const ForgotPasswordRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        // Bind.lazySingleton<UserLoginService>(
        //     (i) => UserLoginServiceImpl(userRepository: i())),
        Bind.lazySingleton((i) => ForgotPasswordController(loginService: i())),
      ];

  @override
  WidgetBuilder get view => (_) => const ForgotPasswordPage();
}

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/auth/forgot_password/forgot_password_router.dart';
import 'package:jlfastcred/src/modulos/auth/login/login_router.dart';

class AuthModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        // Bind.lazySingleton<UserRepository>((i) => UserRepositoryImpl()),
      ];

  @override
  String get moduleRouteName => '/auth';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/login': (_) => const LoginRouter(),
        '/forgotPassword': (_) => const ForgotPasswordRouter(),
      };
}

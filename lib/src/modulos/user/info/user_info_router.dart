import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/consultant/info/info_consultant_page.dart';
import 'package:jlfastcred/src/modulos/user/info/user_info_controller.dart';

class UserInfoRouter extends FlutterGetItModulePageRouter {
  const UserInfoRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        // Bind.lazySingleton<UserRepository>((i) => UserRepositoryImpl()),
        Bind.lazySingleton((i) => UserInfoController(userService: i())),
      ];

  @override
  WidgetBuilder get view => (_) => const UserInfoPage();
}

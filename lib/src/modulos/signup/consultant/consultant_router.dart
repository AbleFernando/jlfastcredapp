import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/consultant/consultant_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

import './consultant_page.dart';

class ConsultantRouter extends FlutterGetItModulePageRouter {
  const ConsultantRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<UserRepository>((i) => UserRepositoryImpl()),
        Bind.lazySingleton((i) =>
            ConsultantController(userService: i(), brasilApiService: i())),
      ];

  @override
  WidgetBuilder get view => (_) => const ConsultantPage();
}

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/find_consultant/find_consultant_controller.dart';
import 'package:jlfastcred/src/modulos/signup/find_consultant/find_consultant_page.dart';

class FindConsultantRouter extends FlutterGetItModulePageRouter {
  const FindConsultantRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => FindConsultantController(userService: i()),
        ),
      ];

  @override
  WidgetBuilder get view => (_) => const FindConsultantPage();
}

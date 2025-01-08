import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/home/home_page.dart';
import 'package:jlfastcred/src/modulos/signup/consultant/consultant_page.dart';
import 'package:jlfastcred/src/modulos/signup/documents/documents_page_router.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_page.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

import 'consultant/consultant_controller.dart';
import 'find_consultant/find_consultant_router.dart';
import 'who_i_am/who_i_am_page.dart';

class SignUpModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<UserService>(
            (i) => UserServiceImpl(userRepository: i())),
        // Bind.lazySingleton((i) => SignUpController()),
        Bind.lazySingleton((i) =>
            ConsultantController(userService: i(), brasilApiService: i())),
      ];

  @override
  String get moduleRouteName => '/signup';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/': (context) => const SignUpPage(),
        '/whoIAm': (context) => const WhoIAmPage(),
        '/find-consultant': (context) => const FindConsultantRouter(),
        '/consultant': (context) => const ConsultantPage(),
        // '/documents': (context) => const DocumentsPage(),
        '/documents': (context) => const DocumentsPageRouter(),
        '/done': (context) => const HomePage(),
      };
}

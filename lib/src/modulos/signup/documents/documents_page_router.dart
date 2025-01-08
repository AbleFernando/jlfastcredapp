import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/signup/documents/documents_page.dart';

import 'documents_page_controller.dart';

class DocumentsPageRouter extends FlutterGetItModulePageRouter {
  const DocumentsPageRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) => DocumentsPageController(userService: i()),
        ),
      ];

  @override
  WidgetBuilder get view => (_) => const DocumentsPage();
}

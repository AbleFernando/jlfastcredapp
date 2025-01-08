import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/client/list/list_client_controller.dart';
import 'package:jlfastcred/src/modulos/client/list/list_client_page.dart';

class ListClientRouter extends FlutterGetItModulePageRouter {
  const ListClientRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton((i) => ListClientController(simulationService: i())),
      ];

  @override
  WidgetBuilder get view => (_) => const ListClientPage();
}

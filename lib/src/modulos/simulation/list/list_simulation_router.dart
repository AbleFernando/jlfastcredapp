import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/list/list_simulation_controller.dart';
import 'package:jlfastcred/src/modulos/simulation/list/list_simulation_page.dart';

class ListSimulationRouter extends FlutterGetItModulePageRouter {
  const ListSimulationRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
            (i) => ListSimulationController(simulationService: i())),
      ];

  @override
  WidgetBuilder get view => (_) => const ListSimulationPage();
}

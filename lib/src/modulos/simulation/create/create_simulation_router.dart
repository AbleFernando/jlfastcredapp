import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/create/create_simulation_controller.dart';

import 'create_simulation_page.dart';

class CreateSimulationRouter extends FlutterGetItModulePageRouter {
  const CreateSimulationRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
            (i) => CreateSimulationController(simulationService: i()))
      ];

  @override
  WidgetBuilder get view => (_) => const CreateSimulationPage();
}

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/view/view_simulation_controller.dart';
import 'package:jlfastcred/src/modulos/simulation/view/view_simulation_page.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class ViewSimulationRouter extends FlutterGetItModulePageRouter {
  const ViewSimulationRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
            (i) => ViewSimulationController(simulationService: i())),
      ];

  @override
  WidgetBuilder get view => (contex) {
        final form =
            ModalRoute.of(contex)!.settings.arguments as SimulationModel;
        contex.get<ViewSimulationController>().simulationForm.value = form;
        return const ViewSimulationPage();
      };
}

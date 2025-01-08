import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/simulation/create/create_simulation_router.dart';
import 'package:jlfastcred/src/modulos/simulation/list/list_simulation_router.dart';
import 'package:jlfastcred/src/modulos/simulation/view/view_simulation_router.dart';

class SimulationModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        // Bind.lazySingleton<SimulationRepository>(
        //     (i) => SimulationRepositoryImpl()),
      ];
  @override
  String get moduleRouteName => '/simulation';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/list': (_) => const ListSimulationRouter(),
        '/create': (_) => const CreateSimulationRouter(),
        '/view': (_) => const ViewSimulationRouter(),
      };
}

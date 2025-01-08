import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/home/home_controller.dart';
import 'package:jlfastcred/src/modulos/home/home_page.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class HomeModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<SimulationRepository>(
            (i) => SimulationRepositoryImpl()),
        Bind.lazySingleton((i) => HomoController(simulationService: i())),
        Bind.lazySingleton<AdvanceRepository>((i) => AdvanceRepositoryImpl()),
        Bind.lazySingleton<ClientRepository>((i) => ClientRepositoryImpl()),
      ];
  @override
  String get moduleRouteName => '/home';

  @override
  Map<String, WidgetBuilder> get pages => {
        '/': (context) => const HomePage(),
      };
}

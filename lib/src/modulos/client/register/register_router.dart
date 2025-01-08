import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/src/modulos/client/register/register_controller.dart';
import 'package:jlfastcred/src/modulos/client/register/register_page.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class RegisterRouter extends FlutterGetItModulePageRouter {
  const RegisterRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton(
          (i) =>
              RegisterController(simulationService: i(), brasilApiService: i()),
        ),
      ];

  @override
  WidgetBuilder get view => (contex) {
        final form =
            ModalRoute.of(contex)!.settings.arguments as SimulationModel;
        contex.get<RegisterController>().simulationForm.value = form;
        return const RegisterPage();
      };
}

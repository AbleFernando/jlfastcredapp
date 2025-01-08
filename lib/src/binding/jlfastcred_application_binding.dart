import 'package:flutter_getit/flutter_getit.dart';
import 'package:jlfastcred/core/env.dart';
import 'package:jlfastcred/src/modulos/signup/sign_up_controller.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class JlfastcredApplicationBinding extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton((i) => SignUpController()),
        Bind.lazySingleton<UserRepository>((i) => UserRepositoryImpl()),

        Bind.lazySingleton<SimulationService>(
          (i) => SimulationServiceImpl(
            simulationRepository: i(),
            advanceRepository: i(),
          ),
        ),

        Bind.lazySingleton(
          (i) => RestClient(Env.apiBaseUrl),
        ),

        //BRASIL API
        Bind.lazySingleton<BrasilApiRepository>(
            (i) => BrasilApiRepositoryImpl(restClient: i())),
        Bind.lazySingleton<BrasilApiService>(
            (i) => BrasilApiServiceImpl(brasilApiRepository: i())),

        // Bind.lazySingleton(
        //     (i) => CreateSimulationController(simulationService: i()))
        // Bind.lazySingleton<RestClient>(
        //       (i) => RestClient(Env.backendBaseUrl),
        //     )
      ];
}

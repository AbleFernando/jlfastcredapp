import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CreateSimulationController with MessageStateMixin {
  final SimulationService _simulationService;

  CreateSimulationController({
    required SimulationService simulationService,
  }) : _simulationService = simulationService;

  final _created = signal(false);
  bool get created => _created();

  Future<void> cadastrarSimulacao(SimulationModel simulationModel) async {
    final result = await _simulationService.cadastrarSimulacao(simulationModel);

    switch (result) {
      case Left(value: ServiceException(:var message)):
        showError(message);
      case Right():
        showSuccess('Simulação cadastrada com sucesso');
        _created.value = true;
    }
  }
}

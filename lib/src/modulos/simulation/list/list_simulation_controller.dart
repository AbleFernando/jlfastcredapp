import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ListSimulationController with MessageStateMixin {
  final SimulationService _simulationService;

  ListSimulationController({required SimulationService simulationService})
      : _simulationService = simulationService;

  final Signal<List<SimulationModel>> _listSignal =
      signal(List<SimulationModel>.empty(growable: true));
  List<SimulationModel> get listSimulation => _listSignal.value;

  Future<void> obterSimulacaoPorTipo(String tipo) async {
    final result = await _simulationService.obterSimulacaoPorTipo(tipo);

    switch (result) {
      case Left(value: ServiceException(:var message)):
        showError(message);
      case Right(value: final listSimulation):
        _listSignal.value = listSimulation;
      // showSuccess('Filtro aplicado com sucesso');
    }
  }
}

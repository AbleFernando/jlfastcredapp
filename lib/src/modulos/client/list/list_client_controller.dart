import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ListClientController with MessageStateMixin {
  final SimulationService _simulationService;

  ListClientController({required SimulationService simulationService})
      : _simulationService = simulationService;

  final Signal<List<SimulationModel>> _listSignal =
      signal(List<SimulationModel>.empty(growable: true));
  List<SimulationModel> get listClient => _listSignal.value;

  Future<void> searchClientForRegister() async {
    final result = await _simulationService.searchClientForRegister();

    switch (result) {
      case Left(value: ServiceException(:var message)):
        showError(message);
      case Right(value: final listClient):
        _listSignal.value = listClient;
      // showSuccess('Filtro aplicado com sucesso');
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:jlfastcred_core/jlfastcred_core.dart';

class ViewSimulationController with MessageStateMixin {
  final simulationForm = signal<SimulationModel?>(null);
  final SimulationService _simulationService;

  ViewSimulationController({
    required SimulationService simulationService,
  }) : _simulationService = simulationService;

  final _created = signal(false);
  bool get created => _created();

  String formatarData(DateTime data, String formato) {
    final DateFormat formatter = DateFormat(formato);
    return formatter.format(data);
  }

  Future<void> reenviarSimulacao(SimulationModel simulationModel) async {
    final result = await _simulationService.reenviarSimulacao(simulationModel);

    switch (result) {
      case Left(value: ServiceException(:var message)):
        showError(message);
      case Right():
        showSuccess('Simulação reenviada com sucesso');
        _created.value = true;
    }
  }

  void dispose() {
    simulationForm.dispose();
    _created.dispose();
  }
}

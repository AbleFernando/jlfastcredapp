import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class UserInfoController with MessageStateMixin {
  final UserService _userService;

  UserInfoController({required UserService userService})
      : _userService = userService;

  final Signal<List<SimulationModel>> _listSignal =
      signal(List<SimulationModel>.empty(growable: true));
  List<SimulationModel> get listClient => _listSignal.value;

  Future<void> searchClientForRegister() async {
    final result = await _userService.findConsultantByDocument('123445');

    switch (result) {
      case Left(value: ServiceException(:var message)):
        showError(message);
      case Right(value: final listClient):
      // _listSignal.value = listClient;
      // showSuccess('Filtro aplicado com sucesso');
    }
  }
}

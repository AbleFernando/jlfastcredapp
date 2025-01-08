import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FindConsultantController with MessageStateMixin {
  final UserService _userService;

  FindConsultantController({required UserService userService})
      : _userService = userService;

  final _consultantNotFound = ValueSignal<bool>(true);
  final _users = ValueSignal<Users?>(null);

  bool get consultantNotFound => _consultantNotFound();
  Users? get users => _users();

  Future<void> findConsultantByDocument(String document) async {
    final patientResult = await _userService.findConsultantByDocument(document);

    bool consultantNotFound = true;
    Users? consultant;

    switch (patientResult) {
      case Right(value: Users model):
        if (model.status.toLowerCase() == UsersStatus.devolvido.name) {
          showInfo('Usuário reprovado, por favor ajuste seu cadsatro');
        }
        consultantNotFound = false;
        consultant = model;

      // case Right(value: _):
      //   consultantNotFound = true;
      //   consultant = null;
      case Left(value: ServiceException(:var message, :var isErro)):
        if (isErro) {
          showError(message);
        } else {
          showInfo(message);
        }
        return;
    }

    //envia um sinal de refresh apenas para a tela mesmo sendo 2 variáveis.
    batch(() {
      _users.value = consultant;
      _consultantNotFound.forceUpdate(consultantNotFound);
    });
  }

  void continueWithoutDocument() {
    batch(() {
      _users.value = null;
      _consultantNotFound.forceUpdate(true);
    });
  }

  void clearForm() {
    _users.value = null;
    _consultantNotFound.forceUpdate(true);
    clearAllMessages();
  }
}

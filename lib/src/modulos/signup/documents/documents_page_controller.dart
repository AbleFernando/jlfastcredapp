import 'dart:developer';
import 'dart:io';

import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class DocumentsPageController with MessageStateMixin {
  final UserService _userService;

  DocumentsPageController({required UserService userService})
      : _userService = userService;

  Users? users;
  final _nextStep = signal<bool>(false);

  bool get nextStep => _nextStep();

  void goNextStep() {
    _nextStep.value = true;
  }

  final _created = signal(false);
  bool get created => _created();

  Future<void> saveAndNext(
      Users registerPatientModel,
      File anexoFrenteDocumento,
      File anexoVersoDocumento,
      File anexoAntecedenteCriminal,
      File anexoSelf) async {
    final resultUserRegister = await _userService.registerWithDocument(
        registerPatientModel,
        anexoFrenteDocumento,
        anexoVersoDocumento,
        anexoAntecedenteCriminal,
        anexoSelf);

    switch (resultUserRegister) {
      case Left():
        showError('Erro ao cadastrar consultor');
      case Right(value: final consultor):
        log(consultor);
        // showInfo('Paciente cadastro com sucesso');
        // users = consultor;
        // goNextStep();
        _created.value = true;
    }
  }
}

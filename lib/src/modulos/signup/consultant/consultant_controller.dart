// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

class ConsultantController with MessageStateMixin {
  final UserService _userService;
  final BrasilApiService _brasilApiService;

  ConsultantController(
      {required UserService userService,
      required BrasilApiService brasilApiService})
      : _userService = userService,
        _brasilApiService = brasilApiService;

  final _cepV1 = signal<CepV1>(CepV1.empty());
  CepV1 get cepV1 => _cepV1();

  Users? users;

  final _nextStep = signal<bool>(false);
  bool get nextStep => _nextStep();

  // final _refreshForm = signal<bool>(false);
  // bool get refreshForm => _refreshForm();

  void goNextStep() {
    _nextStep.value = true;
  }

  void clearForm() {
    users = null;
    _nextStep.value = false;
    _cepV1.value = CepV1.empty();
  }

  var _bankDetails = List.empty();

  Future<void> saveAndNext(Users registerPatientModel) async {
    final result = await _userService.register(registerPatientModel);

    switch (result) {
      case Left():
        showError('Erro ao cadastrar consultor');
      case Right(value: final consultor):
        // showInfo('Paciente cadastro com sucesso');
        users = consultor;
        goNextStep();
    }
  }

  Future<void> fetchAddressByCep(String cep) async {
    final result = await _brasilApiService.fetchAddressByCep(cep);

    switch (result) {
      case Left():
        showError('Erro ao buscar o CEP via API');
        _cepV1.value = CepV1.empty();
      case Right(value: final cep):
        _cepV1.value = cep;
      // _refreshForm.value = true;
    }
  }

  Future<void> initializeBank() async {
    final result = await _brasilApiService.fetchBankList();
    switch (result) {
      case Left():
        showError('Erro ao buscar os BANCOS via API');
        break;
      case Right(value: final bankDetails):
        // showInfo(bankDetails.first.name!);
        batch(() {
          _bankDetails = bankDetails;
          _bankDetails.sort((a, b) => a.code.compareTo(b.code));
        });
        // _bankDetails = bankDetails;
        // _bankDetails.sort((a, b) => a.code.compareTo(b.code));
        // _refreshForm.value = true;
        break;
    }
  }

  List<DropdownMenuItem<BankDetails>> getDropdownItems() {
    return _bankDetails.map((bank) {
      return DropdownMenuItem<BankDetails>(
        value: bank,
        child: Text('${bank.code} - ${bank.name}'),
      );
    }).toList();
  }
}

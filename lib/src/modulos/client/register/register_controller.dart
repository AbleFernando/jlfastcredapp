import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:jlfastcred_core/jlfastcred_core.dart';

class RegisterController with MessageStateMixin {
  final SimulationService _simulationService;
  final BrasilApiService _brasilApiService;

  RegisterController({
    required SimulationService simulationService,
    required BrasilApiService brasilApiService,
  })  : _simulationService = simulationService,
        _brasilApiService = brasilApiService;

  final simulationForm = signal<SimulationModel?>(null);

  final _created = signal(false);
  bool get created => _created();

  final _cepV1 = signal<CepV1>(CepV1.empty());
  CepV1 get cepV1 => _cepV1();

  var _bankDetails = List.empty();

  Future<void> cadastrarClient(File anexoFrenteDocumento,
      File anexoVersoDocumento, SimulationModel simulationModel) async {
    final result = await _simulationService.registerClient(
        anexoFrenteDocumento, anexoVersoDocumento, simulationModel);

    switch (result) {
      case Left(value: ServiceException(:var message)):
        showError(message);
      case Right():
        showSuccess('Simulação cadastrada com sucesso');
        _created.value = true;
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

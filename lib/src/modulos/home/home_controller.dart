import 'package:jlfastcred_core/jlfastcred_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomoController with MessageStateMixin {
  final SimulationService _simulationService;

  HomoController({
    required SimulationService simulationService,
  }) : _simulationService = simulationService;

  final _totalComissaoConsultor = signal(0.00);
  double get totalComissaoConsultor => _totalComissaoConsultor();

  double _valorTotalNoMes = 0.00;
  double get valorTotalNoMes => _valorTotalNoMes;

  double _valorTotalNoAno = 0.00;
  double get valorTotalNoAno => _valorTotalNoAno;

  final _tipoCalculo = signal('Aguardando');
  String get tipoCalculo => _tipoCalculo();

  final _createdAdvance = signal(false);
  bool get createdAdvance => _createdAdvance();
  set createdAdvance(bool value) {
    _createdAdvance.value = value;
  }

  final _totalClientes = signal(0);
  int get totalClientes => _totalClientes();

  Future<void> obterTotalComissaoConsultor() async {
    final result = await _simulationService.obterTotalComissaoConsultor();

    switch (result) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _totalComissaoConsultor.value = somatorio;
    }
  }

  Future<void> obterValotTotalComissaoPaga() async {
    _valorTotalNoMes = 0;
    _valorTotalNoAno = 0;

    final resultMes =
        await _simulationService.obterValorTotalComissaoPagaNoMes();
    final resultTotal =
        await _simulationService.obterValorTotalComissaoPagaNoTotal();

    switch (resultMes) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _valorTotalNoMes = somatorio;
    }

    switch (resultTotal) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _valorTotalNoAno = somatorio;
    }

    _tipoCalculo.value = 'comissao';
  }

  Future<void> obterValoresSimulacao() async {
    _valorTotalNoMes = 0;
    _valorTotalNoAno = 0;
    final resultMes = await _simulationService.obterQteTotalSimulacaoNoMes();
    final resultTotal = await _simulationService.obterQteTotalSimulacao();

    switch (resultMes) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _valorTotalNoMes = double.parse(somatorio.toString());
    }

    switch (resultTotal) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _valorTotalNoAno = double.parse(somatorio.toString());
    }

    _tipoCalculo.value = 'simulacao';
  }

  Future<void> obterValoresDigitacao() async {
    _valorTotalNoMes = 0;
    _valorTotalNoAno = 0;
    final resultMes = await _simulationService.obterQteTotalDigitacaoNoMes();
    final resultTotal = await _simulationService.obterQteTotalDigitacao();

    switch (resultMes) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _valorTotalNoMes = double.parse(somatorio.toString());
    }

    switch (resultTotal) {
      case Left(value: ServiceException(:final message)):
        showError(message);
      case Right(value: final somatorio):
        _valorTotalNoAno = double.parse(somatorio.toString());
    }

    _tipoCalculo.value = 'digitacao';
  }

  Future<void> requestAdvance() async {
    final result = await _simulationService.requestAdvance();

    switch (result) {
      case Left(value: ServiceException(:final message, :final isErro)):
        if (isErro == false) {
          showInfo(message);
        } else {
          showError(message);
        }
        _createdAdvance.value = true;
      case Right(value: final message):
        showSuccess(message);
        _createdAdvance.value = true;
    }
  }

  Future<void> obterTotalClientes() async {
    final result = await _simulationService.searchClientForRegister();
    switch (result) {
      case Left(value: ServiceException(:final message, :final isErro)):
        if (isErro == false) {
          showInfo(message);
        } else {
          showError(message);
        }
      case Right(value: final list):
        _totalClientes.value = list.length;
    }
  }
}

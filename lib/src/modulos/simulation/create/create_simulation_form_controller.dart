import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

mixin CreateSimulationFormController {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final cpfOrBenefitNumberEC = TextEditingController();
  final birthDateEC = TextEditingController();
  final margemEC = TextEditingController();
  File? anexo;

  void disposeForm() {
    nameEC.dispose();
    cpfOrBenefitNumberEC.dispose();
    birthDateEC.dispose();
    margemEC.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
    );

    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      birthDateEC.text = formattedDate;
    }
  }

  String selectedOptionProduto = 'Selecione';
  List<String> optionsProduto = [
    'Selecione',
    'FGTS',
    'INSS',
    'SIAPE',
    'FORÇAS/GOV',
  ];

  String selectedOptionContrato = 'Selecione';
  List<String> optionsContrato = [
    'Selecione',
    'Geral',
    'Contrato novo',
    'Refinanciamento',
    'Portabilidade',
    'Cartão benefício',
    'Cartão consignado'
  ];

  //Responsável por realizar a validação da data preenchida
  //possível refatoramento futuro para ser reaproveitada em outra parte
  String? dateValidator(String value) {
    // Verifica se a string está no formato correto
    RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(value)) {
      return 'A data informada é inválida';
    }

    // Divide a string da data
    List<String> dateParts = value.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Tenta criar um objeto DateTime
    try {
      DateTime date = DateTime(year, month, day);
      // Verifica se o objeto DateTime criado corresponde à data original
      if (date.day != day || date.month != month || date.year != year) {
        return 'A data informada é inválida';
      }
    } catch (e) {
      return 'A data informada é inválida';
    }

    return null;
  }

  Future<SimulationModel> createSimulationRegister() async {
    return SimulationModel(
      id: '',
      birthDate: DateFormat('dd/MM/yyyy').parseStrict(birthDateEC.text),
      cpfOrBenefitNumber: cpfOrBenefitNumberEC.text,
      dataCadastro: DateTime.now(),
      status: 'Nova',
      comissao: 0.00,
      pontosFastCred: 0.00,
      link: '',
      banco: '',
      name: nameEC.text,
      numeroProposta: '',
      operationType: selectedOptionProduto.toUpperCase(),
      dataDigitacao: '',
      statusDigitacao: 'Aguardando Aprovação',
      motivoPendencia: '',
      tipoContrato: selectedOptionContrato,
      file: anexo,
      consultant: Users.empty(),
      client: Client.empty(),
      margemUrl: '',
    );
  }
}

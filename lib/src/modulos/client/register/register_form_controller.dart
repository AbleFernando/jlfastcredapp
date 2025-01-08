import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jlfastcred/src/modulos/client/register/register_page.dart';
import 'package:jlfastcred_core/jlfastcred_core.dart';

mixin RegisterFormController on State<RegisterPage> {
  late bool enabledForm;

  late File anexoFrenteDocumento;
  late File anexoVersoDocumento;

  final formKey = GlobalKey<FormState>();

  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final phoneEC = TextEditingController();
  final birthDateEC = TextEditingController();

  final documentEC = TextEditingController();

  final addressEC = TextEditingController();
  final numberEC = TextEditingController();
  final complementEC = TextEditingController();
  final cepEC = TextEditingController();
  final neighborhoodEC = TextEditingController();
  final cityEC = TextEditingController();
  final stateEC = TextEditingController();
  // final districtEC = TextEditingController();

  final bankEC = TextEditingController();
  final accountEC = TextEditingController();
  final pixEC = TextEditingController();
  final branchEC = TextEditingController();
  final accountTypeEC = TextEditingController();

  // Variável que mantém o banco selecionado
  BankDetails? selectedBank;

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    phoneEC.dispose();
    birthDateEC.dispose();
    documentEC.dispose();
    addressEC.dispose();
    numberEC.dispose();
    complementEC.dispose();
    cepEC.dispose();
    neighborhoodEC.dispose();
    cityEC.dispose();
    stateEC.dispose();
    // districtEC.dispose();
    bankEC.dispose();
    accountEC.dispose();
    pixEC.dispose();
    branchEC.dispose();
    super.dispose();
  }

  String selectedOptionTipoConta = 'Selecione';
  List<String> optionsTipoConta = [
    'Selecione',
    'Conta corrente',
    'Conta poupança',
  ];

  void initializeForm(final SimulationModel? model) {
    if (model != null) {
      enabledForm = true;

      nameEC.text = model.name;
      emailEC.text = model.client.email;
      phoneEC.text = model.client.contato;

      birthDateEC.text =
          "${model.birthDate.day}/${model.birthDate.month}/${model.birthDate.year}";

      documentEC.text = model.cpfOrBenefitNumber;
      cepEC.text = model.client.cep;
      addressEC.text = model.client.endereco;
      numberEC.text = model.client.numero;
      complementEC.text = model.client.complemento;
      stateEC.text = model.client.uf;
      cityEC.text = model.client.cidade;
      // districtEC.text = model.bairro;
      bankEC.text = model.client.dadosBancarios.bankName;
      accountEC.text = model.client.dadosBancarios.accountNumber;
      pixEC.text = model.client.dadosBancarios.pixKey;
      branchEC.text = model.client.dadosBancarios.branchNumber;
    }
  }

  SimulationModel createClientRegister(SimulationModel simulation) {
    return simulation.copyWith(
      client: Client(
        id: simulation.id,
        bairro: neighborhoodEC.text,
        cep: cepEC.text,
        cidade: cityEC.text,
        complemento: complementEC.text,
        cpfOrBenefitNumber: documentEC.text,
        email: emailEC.text,
        contato: phoneEC.text,
        endereco: addressEC.text,
        name: nameEC.text,
        numero: numberEC.text,
        uf: stateEC.text,
        dadosBancarios: BankingInformation(
            accountNumber: accountEC.text,
            bankName: bankEC.text,
            branchNumber: branchEC.text,
            pixKey: pixEC.text,
            tipoConta: accountTypeEC.text),
        urls: Urls.empty(),
        isClient: true,
      ),
    );
  }

  void initializeCep(final CepV1 cepV1) {
    addressEC.text = cepV1.street;
    cityEC.text = cepV1.city;
    stateEC.text = cepV1.state;
    neighborhoodEC.text = cepV1.neighborhood;
  }
}
